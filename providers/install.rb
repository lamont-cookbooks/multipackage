
use_inline_resources

action :install do
  begin
    package new_resource.name do
      package_name new_resource.package_name
      version new_resource.version if new_resource.version
      options new_resource.options if new_resource.options
      timeout new_resource.timeout if new_resource.timeout
    end
  rescue Chef::Exceptions::ValidationFailed
    new_resource.package_name.each_with_index do |package_name, i|
      version = new_resource.version[i] if new_resource.version
      package package_name do
        version version if version
        options new_resource.options if new_resource.options
        timeout new_resource.timeout if new_resource.timeout
      end
    end
  end
end
