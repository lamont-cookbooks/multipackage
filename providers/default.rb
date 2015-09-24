use_inline_resources

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

def do_action(new_resource, action)
  package_name_array = [ new_resource.package_name ].flatten
  version_array = [ new_resource.version ].flatten if new_resource.version

  begin
    package new_resource.name do
      package_name package_name_array
      version version_array if version_array
      options new_resource.options if new_resource.options
      timeout new_resource.timeout if new_resource.timeout
      action action
    end
  rescue Chef::Exceptions::ValidationFailed
    new_resource.package_name_array.each_with_index do |package_name, i|
      version = version_array[i] if version_array
      package package_name do
        version version if version
        options new_resource.options if new_resource.options
        timeout new_resource.timeout if new_resource.timeout
        action action
      end
    end
  end
end
