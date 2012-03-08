#
# Cookbook Name:: java
# Attributes:: default
#
# Copyright 2010, Opscode, Inc.
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

default["yotpo-hadoop"]["machine-role"] = "slave"
default["yotpo-hadoop"]["download-url"] = "http://apache.mirrors.hoobly.com/hadoop/core/hadoop-0.23.1/hadoop-0.23.1.tar.gz"
default["yotpo-hadoop"]["archive-name"] = "hadoop-0.23.1.tar.gz"
default["yotpo-hadoop"]["folder-name"] = "hadoop-0.23.1"
default["yotpo-hadoop"]["username"] = "hadoop"
default["yotpo-hadoop"]["password"] = "$6$Rd0g63z95/$eSUZVufg.DytP.ETlrnzZWxRh19VgMZTG5QTRddNbZu0pyddjm1c0WSLamJ8a.N.bAA6dijr6684yTm0WzVBo."

#slave definitions 
default["yotpo-hadoop"]["masternode-ip"] = "127.0.0.1"

#master definitions 
