
use_inline_resources

provides :fake

action :run do
  multipackage new_resource.package_name
end
