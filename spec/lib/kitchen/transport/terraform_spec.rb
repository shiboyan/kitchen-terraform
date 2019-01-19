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
require "kitchen/transport/terraform"
require "support/kitchen/terraform/configurable_examples"

::RSpec.describe ::Kitchen::Transport::Terraform do
  it_behaves_like "Kitchen::Terraform::Configurable" do
    let :described_instance do
      described_class.new
    end
  end

  describe ".superclass" do
    specify "should return ::Kitchen::Transport::Base" do
      expect(described_class.superclass).to be ::Kitchen::Transport::Base
    end
  end
end
