actions :install
default_action :install

attribute :package_name, kind_of: [ String, Array ], name_attribute: true
attribute :version, kind_of: [ String, Array ]
attribute :options, kind_of: String
attribute :timeout, kind_of: [ String, Integer ]
