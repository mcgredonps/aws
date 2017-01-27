#
# Cookbook:: mmowgli
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

#require 'json'
#file = File.read('/vagrant/cookbooks/mmowgli/chefAttributes.json')
#default.merge! JSON.parse(file)

execute "update-upgrade" do
  command "yum -y update"
  action :run
end

# Baseline packages
package ['epel-release', 'cifs-utils', 'samba-client', 'samba-common', 'ntp',  'libselinux-python', 'subversion', 'git', 'httpd', 'mod_ssl', 'unzip'] do
    action :install
end

# Very, very, very basic security
package ['clamav', 'fail2ban', 'httpd', 'mod_ssl', 'unzip'] do
    action :install
end

bash 'extract_module' do
  code <<-EOH
    cd /usr
    mkdir -p /usr/java
    #mkdir -p default['java']['install_dir']
    #tar xzf default['java']['tarball'] -C default['java']['install_dir']
    tar -xvf /vagrant/jdk-8u111-linux-x64.tar.gz -C /usr/java
    tar -xvf /vagrant/apache-tomcat-8.5.9.tar.gz -C /usr/java
    cd /vagrant
    /usr/bin/unzip /vagrant/jce_policy-8.zip
    cp /vagrant/UnlimitedJCEPolicyJDK8/local_policy.jar  /usr/java/jdk1.8.0_111/jre/lib/security/
    cp /vagrant/UnlimitedJCEPolicyJDK8/US_export_policy.jar  /usr/java/jdk1.8.0_111/jre/lib/security/
  EOH
end