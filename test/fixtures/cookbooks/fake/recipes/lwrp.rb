
module MultiPackageHelper
  include Chef::DSL::Recipe
  def package_installed?(package)
    !build_resource(:package, package).current_value.version.nil?
  end
end

Chef::Resource::RubyBlock.send(:include, MultiPackageHelper)

package_list = %w[lsof zsh]

test_resource "doit"

ruby_block "validate packages installed" do
  block do
    package_list.each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end
