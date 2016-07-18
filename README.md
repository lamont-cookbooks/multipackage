# Multipackage Cookbook

[![Build Status](https://travis-ci.org/lamont-cookbooks/multipackage.svg?branch=master)](https://travis-ci.org/lamont-cookbooks/multipackage)
+[![Code Climate](https://codeclimate.com/github/lamont-cookbooks/multipackage/badges/gpa.svg)](https://codeclimate.com/github/lamont-cookbooks/multipackage)
[![Cookbook Version](https://img.shields.io/cookbook/v/multipackage.svg)](https://supermarket.chef.io/cookbooks/multipackage)

## Chef Package Installation Nirvana

* Leverages Chef 12.1.0 multipackage installation
* Back-compat with Chef 12.0.x
* Compatible with package provider that do not support multipackage
* Accumulate packages across all cookbooks and install with one resource
* Duplicated packages do not generate CHEF-3694 resource cloning errors

## Chef 11.x Compat

* The last version of this that supported Chef 11.x was 2.0.4

Note that in that version you would have used `multipackage_install` to do scatter-gather instead of
`multipackage` since the API changed.

## Description

This cookbook supplies an LWRP `multipackage_internal` which provides a backwards-compatability
layer around supplying an array of packages to the package resource which was introduced in 
Chef 12.1.0.  By using this LWRP a cookbook will execute a single resource with an array argument
on Chef 12.1.0, but will dispatch multiple resources to handle each individual resource to maintain
compatibility with previous versions of Chef.

This cookbook also supplies a definition `multipackage` which wraps `multipackage` with
additional functionality not present in core chef which implements an accumulator pattern to
gather packages from many different cookbooks and install them in a single resource call (assuming
it runs on Chef 12.1.0 or greater).

## Supports

This should run fine on any distro on any version of Chef.  For installing multiple packages in a
single resource call the core chef provider that is being used will need to support that (as of
Chef 12.1.0 this is only apt on Ubuntu and yum on RHELs/Fedora).

## Cookbook Dependencies

None

## Resources

### multipackage_internal

This takes an array of packages and installs them.  On chef versions that do not support array arguments to the package
resource it will explode the `package_name` argument into multiple package resources for backwards compatibility.

#### Example

This installs three packages and shows the parameters which the definition supports:

```ruby
multipackage_internal [ "lsof, "tcpdump", "zsh" ] do
  version [ "1.1.1", "2.2.2", "3.3.3" ]
  options { "some" => "options" }
  timeout 86400
end
```

#### Actions

- `:install` - install the packages
- `:remove` - remove the packages
- `:upgrade` - upgrade the packages
- `:reconfig` - reconfigure the packages
- `:purge` - purge the packages

#### Parameters

* `package_name` - This must be an array
* `version` - This must be an array and, if present, must have the same number of elements as `package_name`
* `options` - Options to pass to package provider(s).
* `timeout` - Timeout to pass to package provider(s).

## Definitions

### multipackage

This implements an accumulator pattern to gather all its arguments across every cookbook and issue a single
`multipackage_internal` resource to install all of the gathered packages.  The resource will be placed in the
resource collection at the point where the first definition is encountered -- in other words it will run very early
in converge phase as opposed to being implemented as a delayed notification which would run too late for 
cookbooks to depend upon the packages being installed.

#### Example

On Chef >= 12.1.0 and Ubuntu/RHEL these files will result in a single resource that installs all 4 packages at once.

In `my_zlib/default.rb`:

```ruby
multipackage "zlib-dev"
```

In `my_zsh/default.rb`:

```ruby
multipackage "zsh"
```

In `my_xml/default.rb`:

```ruby
multipackage [ "xml2-dev", "xslt-dev" ]
```

The definition with no arguments will create the `multipackage_internal` resource in the resource collection at the
point where this line is evaluated (if this is the first recipe line your chef client run parses, then the first thing
that will happen in your chef-client run is that all packages will be installed):

```ruby
multipackage
```

In Chef 12 (Chef-11 definitions do not support this behavior) this definition returns the resource it creates so you
can hang notifies and subscribes off of if:

```ruby
multipackage.notifies :write, "log[foo]", :immediately
```

#### Parameters

* `package_name` - This must be an array
* `version` - This must be an array and, if present, must have the same number of elements as `package_name`
* `options` - Options to pass to package provider, currently there is no merging, last-writer-wins
* `timeout` - Timeout to pass to package provider, last-writer-wins

## Recipes

None

## Attributes

None

## Usage

Put 'depends multipackage' in your metadata.rb to gain access to the LWRP and definition in your code.

## NOTE on Using Definitions

This cookbook uses a definition for a specific purpose to implement an accumulator or scatter-gather pattern so that
many statements across multiple recipes and cookbooks produce one resource which is executed.  This is done with a
definition so that the accumulating/gathering process occurs at compile-time.  When compile-time is finished all of
the data has been accumulated.  This lets a resource run very early in the run-list and do its work early.

If this was implemented as an LWRP it would have to do its accumulation work late, at converge time in the provider
That would make it impossible to install the packages early.  An LWRP implementation is possible in conjunction with a
delayed notification to a resource to consume the accumulated data, but then recipe code could not depend on the
packages having been installed.  Since a definition is a compile-time macro this cookbook takes advantage of that
distinction to more elegantly solve this problem without forcing providers to run at `compile_time` which is more of
an antipattern than definitions are.

Definitions also do not have a "CHEF-3694" "resource cloning" issue.  That makes it easy for the definition to roll its
own logic to handle collisions.

In general LWRPs should always be used over definitions.  This is the one case where they should be used.

## Bugs and Edge Conditions

- options could be merged in the definition
- timeout could update the timeout in the definition only if its larger than the current one or something like that
- there's other parameters to `package`, `yum_package`, etc that are not implemented
- to suppress CHEF-3694 errors the first declaration of installing a package 'wins' with regards to options/version/etc

## Contributing

Just open a PR or Issue on GitHub.

## License and Author

- Author:: Lamont Granquist (<lamont@chef.io>)

```text
Copyright:: 2015 Lamont Granquist

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
