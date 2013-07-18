#
# Copyright Gavin Sandie (beach@vicecity.co.uk)
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

include_recipe "chef_handler"

chef_gem "riemann-client"

cookbook_file "#{node["chef_handler"]["handler_path"]}/chef-riemann.rb" do
  source "chef-riemann.rb"
end

chef_handler "RiemannReporting" do
  source "#{node["chef_handler"]["handler_path"]}/chef-riemann.rb"
  arguments [
    :riemann_host => node["chef_riemann"]["riemann_host"],
    :riemann_port => node["chef_riemann"]["riemann_port"],
    :ttl => node["chef_riemann"]["ttl"],
    :tags => node["chef_riemann"]["tags"]
  ]
  action :enable
end
