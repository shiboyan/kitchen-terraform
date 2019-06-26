# frozen_string_literal: true

# Copyright 2016 New Context Services, Inc.
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

require "kitchen"
require "kitchen/terraform/configurable"
require "kitchen/transport/terraform/connection"

module Kitchen
  module Transport
    # The transport...
    #
    # === Configuration Attributes
    #
    # The transport has configuration attributes..
    #
    #   transport:
    #     name: terraform
    # @version 2
    class Terraform < ::Kitchen::Transport::Base
      kitchen_transport_api_version 2

      include ::Kitchen::Terraform::Configurable

      def connection(_state)
        ::Kitchen::Transport::Terraform::Connection.new
      end
    end
  end
end
