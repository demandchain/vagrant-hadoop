#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2008-2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# force ohai to run and pick up new languages.java data
ruby_block "reload_ohai" do
  block do
    o = Ohai::System.new
    o.all_plugins
    node.automatic_attrs.merge! o.data
  end
  action :nothing
end

#creating the hadoop username
user "#{node["yotpo-hadoop"]["username"]}" do
  comment "Hadoop User"
  home "/home/#{node["yotpo-hadoop"]["username"]}"
  shell "/bin/bash"
  password "#{node["yotpo-hadoop"]["password"]}"
  action :create 
end

#creating the hadoop home directory
directory "/home/hadoop" do
  owner "hadoop"
  group "hadoop"
  mode "0755"
  action :create
end

#creating the hadoop hdfs directory
directory "/home/hadoop/hdfs" do
  owner "hadoop"
  group "hadoop"
  mode "0755"
  action :create
end

#creating the hadoop keys directory
directory "/home/hadoop/keys" do
  owner "hadoop"
  group "hadoop"
  mode "0755"
  action :create
end

#creating the hadoop .ssh directory
directory "/home/hadoop/.ssh" do
  owner "hadoop"
  group "hadoop"
  mode "0755"
  action :create
end

#creating authorized_keys file
file "/home/hadoop/.ssh/authorized_keys" do
  owner "hadoop"
  group "hadoop"
  mode "0755"
  only_if do node["yotpo-hadoop"]["machine-role"]=="slave" end
  action :create

end

#downloading HADOOP archive to ~ and extracting it
script "download_and_extract_hadoop" do
  interpreter "bash"
  user "hadoop"
  cwd "/home/hadoop"
  code <<-EOH
  wget #{node["yotpo-hadoop"]["download-url"]}
  tar -zxf #{node["yotpo-hadoop"]["archive-name"]}
  echo test -f #{node["yotpo-hadoop"]["archive-name"]}
  echo #{node["yotpo-hadoop"]["archive-name"]}
  EOH
  not_if %Q|test -f #{node["yotpo-hadoop"]["archive-name"]}|
end

#updating environment vars
script "update_env_vars" do
  interpreter "bash"
  user "root"
  code <<-EOH
  echo HADOOP_HOME="/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}" >> /etc/environment
  echo HADOOP_INSTALL="/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}" >> /etc/environment
  EOH
end

#copying all necessary hadoop configurations to the node
remote_directory "/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/conf" do
  source "hadoop-conf"
  files_backup 0
  files_owner "hadoop"
  files_group "hadoop"
  files_mode "0644"
  owner "hadoop"
  group "hadoop"
  mode "0755"
end

#copying master public key to the keys directory
remote_file "/home/hadoop/keys/masterkey.pub" do
  source "keys/masterkey.pub"
  mode "0644"
  only_if do node["yotpo-hadoop"]["machine-role"]=="slave" end
end

#insert the master public key to authorized_keys of the HADOOP user
script "authorizing_masterkey" do
  interpreter "bash"
  user "hadoop"
  only_if do node["yotpo-hadoop"]["machine-role"]=="slave" end
  code <<-EOH
  cat /home/hadoop/keys/masterkey.pub >> /home/hadoop/.ssh/authorized_keys
  EOH
end

template "/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/conf/core-site.xml" do
  mode "0644"
  source "core-site.erb"
end

template "/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/conf/hdfs-site.xml" do
  mode "0644"
  source "hdfs-site.erb"
end

template "/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/etc/hadoop/core-site.xml" do
  mode "0644"
  source "core-site.erb"
end

template "/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/etc/hadoop/hdfs-site.xml" do
  mode "0644"
  source "hdfs-site.erb"
end

if node["yotpo-hadoop"]["machine-role"]=="master"
  script "master" do
    interpreter "bash"
    user "hadoop"
    code <<-EOH
    touch /home/hadoop/master
    EOH
  end
  template "/home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/conf/hadoop-env.sh" do
    mode "0744"
    source "hadoop-env.erb"
  end
elsif node["yotpo-hadoop"]["machine-role"]=="slave"
  script "slave" do
    interpreter "bash"
    user "hadoop"
    code <<-EOH
    touch /home/hadoop/slave
    EOH
  end
end 

script "start_service" do
  interpreter "bash"
  user "hadoop"
  code <<-EOH
  export JAVA_HOME=/usr/lib/jvm/default-java
  /home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/bin/hdfs namenode -format 
  daemonize /home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/bin/hdfs namenode &
  daemonize /home/hadoop/#{node["yotpo-hadoop"]["folder-name"]}/bin/hdfs datanode &
  EOH
end
