if defined?(ChefSpec)
  def install_multipackage_internal(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:multipackage_internal, :install, resource_name)
  end

  def remove_multipackage_internal(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:multipackage_internal, :remove, resource_name)
  end

  def upgrade_multipackage_internal(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:multipackage_internal, :upgrade, resource_name)
  end

  def reconfig_multipackage_internal(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:multipackage_internal, :reconfig, resource_name)
  end

  def purge_multipackage_internal(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:multipackage_internal, :purge, resource_name)
  end
end
