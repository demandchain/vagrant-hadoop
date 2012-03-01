#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2011, Robin Wenglewski
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

#creating the hadoop username
user "#{node["hadoop"]["username"]}" do
  comment "Hadoop User"
  home "/home/#{node["hadoop"]["username"]}"
  shell "/bin/bash"
  password "#{node["hadoop"]["password"]}"
  action :create 
end

#creating the hadoop home directory
directory "/home/#{node["hadoop"]["username"]}" do
  owner node["hadoop"]["username"]
  group node["hadoop"]["username"]
  mode "0755"
  action :create
end

#creating the hadoop hdfs directory
directory node["hadoop"]["hdfs-folder"] do
  owner node["hadoop"]["username"]
  group node["hadoop"]["username"]
  mode "0755"
  action :create
end

#creating the hadoop keys directory
directory "/home/#{node["hadoop"]["username"]}/keys" do
  owner node["hadoop"]["username"]
  group node["hadoop"]["username"]
  mode "0755"
  action :create
end

#creating the hadoop .ssh directory
directory "/home/#{node["hadoop"]["username"]}/.ssh" do
  owner node["hadoop"]["username"]
  group node["hadoop"]["username"]
  mode "0755"
  action :create
end

#creating authorized_keys file
file "/home/#{node["hadoop"]["username"]}/.ssh/authorized_keys" do
  owner node["hadoop"]["username"]
  group node["hadoop"]["username"]
  mode "0755"
  action :create
end

#downloading HADOOP archive to ~ and extracting it
script "download_and_extract_hadoop" do
  interpreter "bash"
  user node["hadoop"]["username"]
  cwd "/home/#{node["hadoop"]["username"]}"
  code <<-EOH
  wget #{node["hadoop"]["download-url"]}
  tar -zxf #{node["hadoop"]["archive-name"]}
  EOH
end

#updating environment vars
script "update_env_vars" do
  interpreter "bash"
  user "root"
  code <<-EOH
  echo HADOOP_HOME="/home/#{node["hadoop"]["username"]}/#{node["hadoop"]["folder-name"]}" >> /etc/environment
  echo HADOOP_INSTALL="/home/#{node["hadoop"]["username"]}/#{node["hadoop"]["folder-name"]}" >> /etc/environment
  EOH
end



