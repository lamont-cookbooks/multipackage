actions :install
default_action :install

attribute :package_name, kind_of: Array, name_attribute: true
attribute :version, kind_of: Array
attribute :options, kind_of: String
attribute :timeout, kind_of: [ String, Integer ]
