# need build_resource

default_action :install

provides :multipackage_internal

property :package_name, [String, Array], name_property: true
property :version, [String, Array]
property :options, String
property :timeout, [String, Integer]

action :install do
  do_action(:install)
end

action :upgrade do
  do_action(:upgrade)
end

action :reconfig do
  do_action(:reconfig)
end

action :remove do
  do_action(:remove)
end

action :purge do
  do_action(:purge)
end

action_class do
  def multipackage_resource(action)
    package_name_array = package_name.is_a?(Array) ? package_name : package_name.split(", ")
    version_array = [new_resource.version].flatten if new_resource.version
    package new_resource.name do
      package_name package_name_array
      version version_array if version_array
      options new_resource.options if new_resource.options
      timeout new_resource.timeout if new_resource.timeout
      action action
    end
  end

  def singlepackage_resources(action)
    package_name_array = package_name.is_a?(Array) ? package_name : package_name.split(", ")
    version_array = [new_resource.version].flatten if new_resource.version
    package_name_array.each_with_index do |package_name, i|
      version = version_array[i] if version_array
      package package_name do
        version version if version
        options new_resource.options if new_resource.options
        timeout new_resource.timeout if new_resource.timeout
        action action
      end
    end
  end

  def do_action(action)
    if multipackage_supported?
      begin
        multipackage_resource(action)
      rescue Chef::Exceptions::ValidationFailed
        singlepackage_resources(action)
      end
    else
      singlepackage_resources(action)
    end
  end

  def multipackage_supported?
    test = build_resource(:package, "anything")
    ( test.is_a?(Chef::Resource::YumPackage) && !action == :remove) ||
      test.is_a?(Chef::Resource::AptPackage)
  end
end
