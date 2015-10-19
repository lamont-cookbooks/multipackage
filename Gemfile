source 'https://rubygems.org'

gem "chef", ">= 12.5.1"

group :rake do
  gem "rake"
  gem "tomlrb"
end

group :lint do
  gem "foodcritic", ">= 5.0.0"
  gem "finstyle", ">= 1.5.0"
end

group :unit do
  gem "berkshelf",  ">= 4.0.1"
  gem "chefspec",   ">= 4.4.0"
end

group :kitchen_common do
  gem "test-kitchen", ">= 1.4.2"
end

group :kitchen_vagrant do
  gem "kitchen-vagrant", ">= 0.19.0"
end

group :kitchen_cloud do
  gem "kitchen-digitalocean", ">= 0.9.3"
  gem "kitchen-ec2", ">= 0.10.0"
end

group :kitchen_docker do
  gem "kitchen-docker", ">= 2.3.0"
end
