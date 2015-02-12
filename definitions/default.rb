
define :multipackage do
  # @todo make sure package_name and version have the same # of items (unless verison is omitted)
  package_name = [ params[:package_name] || params[:name] ].flatten
  version      = [ params[:version] ].flatten if params[:version]
  options      = params[:options]
  timeout      = params[:timeout]

  t = begin
        resources(multipackage_install: "collected packages")
      rescue Chef::Exceptions::ResourceNotFound
        multipackage_install "collected packages" do
          package_name Array.new
          version Array.new
        end
      end

  package_name.each_with_index do |package_name, i|
    next if t.package_name.include?(package_name)  # supress CHEF-3694 errors
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
