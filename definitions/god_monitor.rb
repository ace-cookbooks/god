#
# Cookbook Name:: god
# Definition:: god_monitor
#
# Copyright 2009, Opscode, Inc.
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

# reload: Reload god so it notices the new service.  :delayed (default) or :immediately.
# action: :enable To create the monitoring config (default), or :disable to remove it.
# variables: Hash of instance variables to pass to the ERB template
# template_cookbook: the cookbook in which the configuration resides
# template_source: filename of the ERB configuration template, defaults to <LWRP Name>.conf.erb
define :god_monitor, :action => :enable, :reload => :delayed, :variables => {}, :template_cookbook => "god", :template_source => nil do
  include_recipe "god"

  params[:template_source] ||= "#{params[:name]}.god.erb"
  if params[:action] == :enable
    template "/etc/god/conf.d/#{params[:name]}.god" do
      owner "root"
      group "root"
      mode 0644
      source params[:template_source]
      cookbook params[:template_cookbook]
      variables params[:variables]
      notifies :restart, resources(:service => "god"), params[:reload]
      action :create
    end
  else
    template "/etc/god/conf.d/#{params[:name]}.conf" do
      action :delete
      notifies :restart, resources(:service => "god"), params[:reload]
    end
  end
end
