# need build_resource
include Chef::DSL::Recipe

default_action :install

provides :multipackage_internal

property :package_name, [String, Array], name_property: true
property :version, [String, Array]
property :options, String
property :per_package_timeout, [String, Integer]

action :install do
  do_action(new_resource, :install)
end

action :upgrade do
  do_action(new_resource, :upgrade)
end

action :reconfig do
  do_action(new_resource, :reconfig)
end

action :remove do
  do_action(new_resource, :remove)
end

action :purge do
  do_action(new_resource, :purge)
end

# FIXME: can we get rid of new_resource everywhere?
def multipackage_resource(new_resource, action)
  package_name_array = package_name.is_a?(Array) ? package_name : package_name.split(", ")
  version_array = [new_resource.version].flatten if new_resource.version
  if new_resource.per_package_timeout
    total_timeout = new_resource.per_package_timeout *
      package_name_array.count
  end
  package new_resource.name do
    package_name package_name_array
    version version_array if version_array
    options new_resource.options if new_resource.options
    timeout total_timeout if total_timeout
    action action
  end
end

def singlepackage_resources(new_resource, action)
  package_name_array = package_name.is_a?(Array) ? package_name : package_name.split(", ")
  version_array = [new_resource.version].flatten if new_resource.version
  package_name_array.each_with_index do |package_name, i|
    version = version_array[i] if version_array
    package package_name do
      version version if version
      options new_resource.options if new_resource.options
      if new_resource.per_package_timeout
        timeout new_resource.per_package_timeout
      end
      action action
    end
  end
end

def do_action(new_resource, action)
  if multipackage_supported?
    begin
      multipackage_resource(new_resource, action)
    rescue Chef::Exceptions::ValidationFailed
      singlepackage_resources(new_resource, action)
    end
  else
    singlepackage_resources(new_resource, action)
  end
end

def multipackage_supported?
  test = build_resource(:package, "anything")
  (test.is_a?(Chef::Resource::YumPackage) && action != :remove) ||
    test.is_a?(Chef::Resource::AptPackage)
end
