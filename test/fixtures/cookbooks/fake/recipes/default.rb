
module MultiPackageHelper
  include Chef::DSL::Recipe
  def package_installed?(package)
    !build_resource(:package, package).current_value.version.nil?
  end
end

Chef::Resource::RubyBlock.send(:include, MultiPackageHelper)

package_list_one = %w[tcpdump unzip]
package_list_two = %w[lsof zsh]
package_list = package_list_one + package_list_two

multipackage package_list_one

multipackage_install package_list_two

ruby_block "validate packages installed 1" do
  block do
    package_list.each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end

multipackage package_list do
  action :remove
end

ruby_block "validate packages removed 1" do
  block do
    package_list.each do |pkg|
      raise "#{pkg} not removed" if package_installed?(pkg)
    end
  end
end

multipackage_internal package_list

ruby_block "validate packages installed 2" do
  block do
    package_list.each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end
