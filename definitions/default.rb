
define :multipackage_install do
  # @todo make sure package_name and version have the same # of items (unless verison is omitted)
  package_name = [ params[:package_name] || params[:name] ].flatten if params[:package_name] || params[:name]
  package_name ||= []
  version      = [ params[:version] ].flatten if params[:version]
  options      = params[:options]
  timeout      = params[:timeout]

  t = begin
        resources(multipackage: "collected packages")
      rescue Chef::Exceptions::ResourceNotFound
        multipackage "collected packages" do
          package_name Array.new
          version Array.new
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
