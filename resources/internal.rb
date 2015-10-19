# need build_resource
include Chef::DSL::Recipe

default_action :install

provides :multipackage_internal

property :package_name, [ String, Array ], name_property: true
property :version, [ String, Array ]
property :options, String
property :timeout, [ String, Integer ]

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
  puts "NEW_RESOURCE:"
  pp new_resource
  puts "PACKAGE_NAME:"
  pp new_resource.package_name
  package_name_array = [ new_resource.package_name ].flatten
  puts "PACKAGE_NAME_ARRAY:"
  pp package_name_array
  version_array = [ new_resource.version ].flatten if new_resource.version
  package new_resource.name do
    package_name package_name_array
    version version_array if version_array
    options new_resource.options if new_resource.options
    timeout new_resource.timeout if new_resource.timeout
    action action
  end
end

def singlepackage_resource(new_resource, action)
  package_name_array = package_name_array
  version_array = version_array
  new_resource.package_name.each_with_index do |package_name, i|
    version = version_array[i] if version_array
    package package_name do
      version version if version
      options new_resource.options if new_resource.options
      timeout new_resource.timeout if new_resource.timeout
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
  test.is_a?(Chef::Resource::YumPackage) || test.is_a?(Chef::Resource::AptPackage)
end
