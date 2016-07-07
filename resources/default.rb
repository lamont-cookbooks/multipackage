default_action :install

provides :multipackage

property :package_name, [String, Array], coerce: proc { |x| [x.is_a?(String) ? x.split(", ") : x ].flatten }, name_property: true
property :version, [String, Array], coerce: proc { |x| [x].flatten }
property :options, String
property :timeout, [String, Integer]

action :install do
  do_action(:install)
end

action :remove do
  do_action(:remove)
end

action :purge do
  do_action(:purge)
end

action :reconfig do
  do_action(:reconfig)
end

action :upgrade do
  do_action(:upgrade)
end

action_class do
  def do_action(action)
    # @todo make sure package_names and versions have the same num of items
    # (unless version is omitted)
    t = with_run_context :parent do
      find_resource(:multipackage_internal, "collected packages #{action}") do
        package_name []
        version []
        action action
      end
    end

    package_name.each_with_index do |pack, i|
      if t.package_name.include?(pack)
        # supress CHEF-3694 errors and be more useful about warning if there's only a reason
        if options
          Chef::Log.warn "ignoring options #{options} set on duplicated package #{pack}"
        end
        if timeout
          Chef::Log.warn "ignoring timeout #{timeout} set on duplicated package #{pack}"
        end
        next
      end
      t.package_name.push(pack)
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

def after_created
  Array(action).each do |action|
    run_action(action)
  end
end
