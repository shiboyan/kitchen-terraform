# frozen_string_literal: true

# Copyright 2016-2019 New Context, Inc.
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

module Kitchen
  module Terraform
    # VersionVerifier is the class of objects which verify a Terraform client version against a requirement.
    class VersionVerifier
      # #verify verifies a version against the requirement.
      def verify
        logger.banner "Starting verification of the Terraform client version."
        strategy_factory.build.call
        logger.banner "Finished verification of the Terraform client version."
      end

      # #initialize prepares a new instance of the class.
      #
      # @param logger [Kitchen::Logger] a logger to log messages.
      # @param strategy_factory [Kitchen::Terraform::VersionVerifierStrategyFactory] a verification strategy factory.
      # @return [Kitchen::Terraform::VersionVerifier]
      def initialize(logger:, strategy_factory:)
        self.logger = logger
        self.strategy_factory = strategy_factory
      end

      private

      attr_accessor :logger, :strategy_factory
    end
  end
end
