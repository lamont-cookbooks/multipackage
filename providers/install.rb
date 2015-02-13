
use_inline_resources

action :install do
  package_name_array = [ new_resource.package_name ].flatten
  version_array = [ new_resource.version ].flatten if new_resource.version

  begin
    package new_resource.name do
      package_name package_name_array
      version version_array if version_array
      options new_resource.options if new_resource.options
      timeout new_resource.timeout if new_resource.timeout
    end
  rescue Chef::Exceptions::ValidationFailed
    new_resource.package_name.each_with_index do |package_name, i|
      version = version_array[i] if version_array
      package package_name do
        version version if version
        options new_resource.options if new_resource.options
        timeout new_resource.timeout if new_resource.timeout
      end
    end
  end
end
