# definitions are the right way to do an accumulator pattern
define :multipackage do # ~FC015
  multipackage_definition_impl(params)
end

define :multipackage_install do # ~FC015
  Chef::Log.deprecation("The `multipackage_install` definition is deprecated, just use `multipackage` from now on")
  params[:action] = :install
  multipackage_definition_impl(params)
end

define :multipackage_remove do # ~FC015
  Chef::Log.deprecation("The `multipackage_remove` definition is deprecated, just use `multipackage` from now on")
  params[:action] = :remove
  multipackage_definition_impl(params)
end

module MultipackageDefinitionImpl
  def multipackage_definition_impl(params)
    # @todo make sure package_name and version have the same # of items (unless verison is omitted)
    package_name = [ params[:package_name] || params[:name] ].flatten if params[:package_name] || params[:name]
    package_name ||= []
    version = [ params[:version] ].flatten if params[:version]
    options = params[:options]
    timeout = params[:timeout]
    action = params[:action] || :install

    t = begin
          resources(multipackage_internal: "collected packages #{action}")
        rescue Chef::Exceptions::ResourceNotFound
          multipackage_internal "collected packages #{action}" do
            package_name Array.new
            version Array.new
            action action
          end
        end

    package_name.each_with_index do |package_name, i|
      if t.package_name.include?(package_name)
        # supress CHEF-3694 errors and be more useful about warning if there's only a reason
        Chef::Log.warn "ignoring options #{options} set on duplicated package #{package_name}" if options
        Chef::Log.warn "ignoring timeout #{timeout} set on duplicated package #{package_name}" if timeout
        next
      end
      t.package_name.push(package_name)
      if version
        t.version.push version[i]
      else
        # keep the version array matching the package_name array
        t.version.push nil
      end
    end


    t.options(options) if options
    t.timeout(timeout) if timeout

    t
  end
end

Chef::Recipe.send(:include, MultipackageDefinitionImpl)
