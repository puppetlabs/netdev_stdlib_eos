#
# Copyright (c) 2014, Arista Networks, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#   Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
#   Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
#
#   Neither the name of Arista Networks nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ARISTA NETWORKS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
require 'rbeapi/client'

##
# PuppetX namespace
module PuppetX
  ##
  # Eos namesapece
  module NetDev
    ##
    # EapiProviderMixin module
    module EosApi

      def prefetch(resources)
        provider_hash = instances.each_with_object({}) do |provider, hsh|
          hsh[provider.name] = provider
        end

        resources.each_pair do |name, resource|
          resource.provider = provider_hash[name] if provider_hash[name]
        end
      end

      ##
      # Instance of Rbeapi::Client::Node used to sending and receiving
      # eAPI messages.  In addition, the node object provides access to
      # Ruby Client for eAPI API modules used to configure EOS resources.
      #
      # @return [Node] An instance of Rbeapi::Client::Node used to send
      #   and receive eAPI messages
      def node
        return @node if @node
        Rbeapi::Client.load_config(ENV['RBEAPI_CONF']) if ENV['RBEAPI_CONF']
        connection_name = ENV['RBEAPI_CONNECTION'] || 'localhost'
        @node = Rbeapi::Client.connect_to(connection_name)
      end

      def netdev(api)
        node.api(api, path: 'rbeapi/netdev', namespace: 'Rbeapi::Netdev')
      end

      ##
      # not_supported raises a NotImplementedError for parameters that are
      # not implemented on the EOS platform for netdev types
      #
      # @option [String] :msg Overrides the default message provided by this
      #   method when called
      #
      # @raises [NotImplementError]
      def not_supported(param, opts = {})
        msg = opts[:msg] || "Parameter[#{param}] not supported on EOS platforms"
        Puppet.notice(msg)
      end
    end
  end
end
