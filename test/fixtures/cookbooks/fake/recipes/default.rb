
module MultiPackageHelper
  include Chef::DSL::Recipe
  def package_installed?(package)
    !build_resource(:package, package).current_value.version.nil?
  end
end

Chef::Resource::RubyBlock.send(:include, MultiPackageHelper)

multipackage [ "bash", "tcsh" ]

multipackage_install [ "bash", "zsh" ]

ruby_block "validate packages installed 1" do
  block do
    %w{bash tcsh zsh}.each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end

multipackage [ "tcsh", "zsh" ] do
  action :remove
end

ruby_block "validate packages removed 1" do
  block do
    %w{tcsh zsh}.each do |pkg|
      raise "#{pkg} not removed" if package_installed?(pkg)
    end
  end
end

multipackage_internal [ "bash", "tcsh", "zsh" ]

ruby_block "validate packages installed 2" do
  block do
    %w{bash tcsh zsh}.each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end
