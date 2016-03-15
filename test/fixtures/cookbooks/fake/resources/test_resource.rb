
provides :test_resource

resource_name :test_resource

action :doit do
  multipackage [ "lsof", "zsh" ]
end
