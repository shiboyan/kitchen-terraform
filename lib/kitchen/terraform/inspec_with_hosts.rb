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
require "kitchen/terraform/error"
require "kitchen/terraform/inspec"

module Kitchen
  module Terraform
    # InSpec instances act as interfaces to the InSpec gem.
    class InSpecWithHosts
      # exec executes InSpec controls.
      #
      # @raise [::Kitchen::Terraform::Error] if the execution of the InSpec controls fails.
      # @return [void]
      def exec(system:)
        system.each_host do |host:|
          ::Kitchen::Terraform::InSpec
            .new(locations: @locations, options: @options.merge(host: host))
            .info(message: "Verifying host #{host} of #{system}").exec
        end
      end

      private

      # @param locations [::Array<::String>] the locations of InSpec control files which contain the controls to be
      #   executed.
      # @param options [::Hash] options for execution.
      def initialize(locations:, options:)
        @locations = locations
        @options = options
      end
    end
  end
end
