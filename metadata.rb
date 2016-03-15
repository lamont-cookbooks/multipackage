maintainer "Lamont Granquist"
maintainer_email "lamont@scriptkiddie.org"
license "Apache 2.0"
source_url "https://github.com/lamont-cookbooks/multipackage"
issues_url "https://github.com/lamont-cookbooks/multipackage/issues"
description "Accumulated installation of multiple packages across multiple cookbooks"
long_description "Accumulated installation of multiple packages across multiple cookbooks"
version "3.0.29"
name "multipackage"

depends "compat_resource"

chef_version ">= 12.0.0" if respond_to?(:chef_version)
