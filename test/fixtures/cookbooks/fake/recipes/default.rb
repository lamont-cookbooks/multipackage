
module MultiPackageHelper
  include Chef::DSL::Recipe
  def package_installed?(package)
    !build_resource(:package, package).current_value.version.nil?
  end
end

Chef::Resource::RubyBlock.send(:include, MultiPackageHelper)

multipackage %w[bash tcsh]

multipackage_install %w[bash zsh]

ruby_block "validate packages installed 1" do
  block do
    %w[bash tcsh zsh].each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end

if %w[rhel fedora].include?(node['platform_family'])
  # yum multipackage remove is buggy
  %w[tcsh zsh].each do |pkg|
    package pkg do
      action :remove
    end
  end
else
  multipackage %w[tcsh zsh] do
    action :remove
  end
end

ruby_block "validate packages removed 1" do
  block do
    %w[tcsh zsh].each do |pkg|
      raise "#{pkg} not removed" if package_installed?(pkg)
    end
  end
end

multipackage_internal %w[bash tcsh zsh]

ruby_block "validate packages installed 2" do
  block do
    %w[bash tcsh zsh].each do |pkg|
      raise "#{pkg} not installed" unless package_installed?(pkg)
    end
  end
end
