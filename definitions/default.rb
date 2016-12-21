define :multipackage do # ~FC015
  multipackage_definition_impl(params)
end

define :multipackage_install do # ~FC015
  Chef::Log.deprecation(
    "The `multipackage_install` definition is deprecated, just use `multipackage` from now on"
  )
  params[:action] = :install
  multipackage_definition_impl(params)
end

define :multipackage_remove do # ~FC015
  Chef::Log.deprecation(
    "The `multipackage_remove` definition is deprecated, just use `multipackage` from now on"
  )
  params[:action] = :remove
  multipackage_definition_impl(params)
end

module MultipackageDefinitionImpl
  def multipackage_definition_impl(params)
    # @todo make sure package_names and versions have the same # of items
    # (unless verison is omitted)
    package_names = []
    if params[:package_name] || params[:name]
      package_names = [params[:package_name] || params[:name]].flatten
    end
    versions = [params[:version]].flatten if params[:version]
    options = params[:options]
    timeout = params[:per_package_timeout]
    action = params[:action] || :install

    t = begin
          # non-delayed eager accumulators like this cannot use recursive search
          run_context.resource_collection.find_local(:multipackage_internal => "collected packages #{action}")
        rescue Chef::Exceptions::ResourceNotFound
          multipackage_internal "collected packages #{action}" do
            package_name Array.new
            version Array.new
            action action
          end
        end

    package_names.each_with_index do |package_name, i|
      if t.package_name.include?(package_name)
        # supress CHEF-3694 errors and be more useful about warning if there's only a reason
        if options
          Chef::Log.warn "ignoring options #{options} set on duplicated package #{package_name}"
        end
        if timeout
          Chef::Log.warn "ignoring timeout #{timeout} set on duplicated package #{package_name}"
        end
        next
      end
      t.package_name.push(package_name)
      if versions
        t.version.push versions[i]
      else
        # keep the version array matching the package_name array
        t.version.push nil
      end
    end

    t.options(options) if options
    t.per_package_timeout(timeout) if timeout

    t
  end
end

Chef::Recipe.send(:include, MultipackageDefinitionImpl)
