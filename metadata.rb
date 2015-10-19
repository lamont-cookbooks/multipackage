maintainer       "Lamont Granquist"
maintainer_email "lamont@scriptkiddie.org"
license          "Apache 2.0"
source_url       "https://github.com/lamont-cookbooks/multipackage"
issues_url       "https://github.com/lamont-cookbooks/multipackage/issues"
description      "Installation of multiple packages collected cross multiple cookbooks with a single package resource."
long_description "Installation of multiple packages collected cross multiple cookbooks with a single package resource."
version          "3.0.5"
name             "multipackage"

depends "compat_resource"

chef_version ">= 12.0.0" if respond_to?(:chef_version)
