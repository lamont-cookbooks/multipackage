# Multipackage Cookbook

## Description

This cookbook supplies an LWRP `multipackage_install` which provides a backwards-compatability
layer around supplying an array of packages to the package resource which was introduced in 
Chef 12.1.0.  By using this LWRP a cookbook will execute a single resource with an array argument
on Chef 12.1.0, but will dispatch multiple resources to handle each individual resource to maintain
compatibility with previous versions of Chef.

This cookbook also supplies a definition `multipackage` which wraps `multipackage_install` with
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

### multipackage_install

This takes an array of packages and installs them.  On chef versions that do not support array arguments to the package
resource it will explode the `package_name` argument into multiple package resources for backwards compatibility.

#### Example

```ruby
multipackage_install [ "lsof, "tcpdump", "zsh" ] do
  version [ "1.1.1", "2.2.2", "3.3.3" ]
  options { "some" => "options" }
  timeout 86400
end
```

#### Actions

- `:install` - install the packages

#### Parameters

* `package_name` - This must be an array
* `version` - This must be an array and, if present, must have the same number of elements as `package_name`
* `options` - Options to pass to package provider(s).
* `timeout` - Timeout to pass to package provider(s).

## Definitions

### multipackage

This implements an accumulator pattern to gather all its arguments across every cookbook and issue a single
`multipackage_install` resource to install all of the gathered packages.

#### Example

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

On Chef >= 12.1.0 and Ubuntu/RHEL this will result in a single resource that installs all 4 packages at once.

#### Actions

- `:install` - Setup the symlinks

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

## Bugs

- options could be merged in the definition
- timeout could update the timeout in the definition only if its larger than the current one or something like that
- there's other paramters to package, yum_package, etc that are not implemented

## Contributing

Just open a PR or Issue on GitHub.

## License and Author

- Author:: Lamont Granquist (<lamont@scriptkiddie.org>)

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
