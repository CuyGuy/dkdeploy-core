# update apt packages
include_recipe 'apt'

# Create unix user for tests
user 'test-user' do
  action :create
end

group 'test-group' do
  action :create
  append true
  members 'test-user'
end

# install apache2-utils. It is needed for the assets:add_htpasswd task
package 'apache2-utils' do
  action :install
end

mysql_service 'default' do
  port '3306'
  # Need for remote connection
  bind_address '0.0.0.0'
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {
  :host     => '127.0.0.1',
  :username => 'root',
  :password => 'ilikerandompasswords'
}

mysql_database 'dkdeploy_core' do
  connection mysql_connection_info
  action   :create
end

mysql_database_user 'root' do
  connection mysql_connection_info
  host       '%'
  password   'ilikerandompasswords'
  action     :create
  privileges [:all]
  action     :grant
end

directory '/var/www' do
  owner 'vagrant'
  group 'vagrant'
  mode '0770'
  action :create
end
