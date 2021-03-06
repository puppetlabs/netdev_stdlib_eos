# encoding: utf-8

require 'puppet/type'
require 'puppet_x/net_dev/eos_api'

Puppet::Type.type(:syslog_server).provide(:eos) do

  # Create methods that set the @property_hash for the #flush method
  mk_resource_methods

  # Mix in the api as instance methods
  include PuppetX::NetDev::EosApi

  # Mix in the api as class methods
  extend PuppetX::NetDev::EosApi

  def self.instances
    result = node.api('logging').get
    result[:hosts].each_with_object([]) do |host, arry|
      provider_hash = { name: host, ensure: :present }
      arry << new(provider_hash)
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def severity_level=(val)
    not_supported 'severity_level'
  end

  def vrf=(val)
    not_support 'vrf'
  end

  def source_interface=(val)
    not_suppported 'source_interface'
  end

  def create
    node.api('logging').add_host(resource[:name])
    @provider_hash = { name: resource[:name], ensure: :present }
  end

  def destroy
    node.api('logging').remove_host(resource[:name])
    @provider_hash = { name: resource[:name], ensure: :absent }
  end
end
