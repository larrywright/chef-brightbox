# Installs and configures Ruby 1.9 using the brightbox apt-get source.

apt_repository "brightbox-ruby-ng-#{node['lsb']['codename']}" do
  uri          "http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu"
  distribution node['lsb']['codename']
  components   ["main"]
  keyserver    "keyserver.ubuntu.com"
  key          "C3173AA6"
  action       :add
end

["build-essential", "ruby1.9.1-full", "ruby-switch"].each do |name|
  apt_package name do
    action :install
  end
end

if node["brightbox"]["ruby"]["active_version"] == "1.9.1"
  execute "ruby-switch --set ruby1.9.1" do
    action :run
    not_if "ruby-switch --check | grep -q 'ruby1.9.1'"
  end
else
  execute "ruby-switch --set ruby1.8" do
    action :run
    not_if "ruby-switch --check | grep -q 'ruby1.8'"
  end
end

cookbook_file "/etc/gemrc" do
  action :create_if_missing
  source "gemrc"
  mode   "0644"
end

["bundler", "rake"].each do |gem|
  gem_package gem do
    action :install
  end
end
