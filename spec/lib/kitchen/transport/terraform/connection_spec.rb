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
require "kitchen/transport/terraform/connection"
require "pathname"
require "uri/https"

::RSpec.describe ::Kitchen::Transport::Terraform::Connection do
  subject do
    described_class.new directory: directory, environment: environment, timeout: timeout
  end

  let :directory do
    "/directory"
  end

  let :environment do
    {"FOO" => "bar"}
  end

  let :timeout do
    1234
  end

  describe "#download" do
    let :local do
      "/local"
    end

    let :local_archive do
      ::Pathname.new ::File.join local, "terraform_0.11.11_linux_amd64.zip"
    end

    let :remote_archive_path do
      "/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip"
    end

    let :remotes do
      [remote_archive_path]
    end

    let :temporary_archive do
      ::Pathname.new "/tmp/terraform_0.11.11_linux_amd64.zip"
    end

    context "when the files can all be downloaded successfully" do
      before do
        allow(::URI::HTTPS).to receive(:open).with(
          host: "releases.hashicorp.com",
          path: remote_archive_path,
        ).and_return temporary_archive
      end

      specify "the files are saved under the Kitchen directory" do
        expect(::IO).to receive(:copy_stream).with temporary_archive, local_archive
      end

      after do
        subject.download remotes, local
      end
    end

    context "when the files can not all be downloaded successfully" do
      specify "a Kitchen::Transport::TransportFailed error is raised" do
        expect do
          subject.download remotes, local
        end.to raise_error ::Kitchen::Transport::TransportFailed
      end
    end
  end

  describe "#execute" do
    subject do
      described_class.new directory: directory, environment: environment, timeout: timeout
    end

    let :command do
      "command"
    end

    let :full_command do
      "terraform #{command}"
    end

    describe "the default environment" do
      specify "should preserve the locale of the parent environment" do
        expect(subject).to receive(:run_command).with(
          full_command,
          including(environment: including("LC_ALL" => nil))
        )
      end

      specify "should optimize Terraform for automation" do
        expect(subject).to receive(:run_command).with(
          full_command,
          including(environment: including("TF_IN_AUTOMATION" => "true"))
        )
      end

      after do
        subject.execute command
      end
    end

    context "when the command does exit successfully" do
      specify "should not raise an error" do
        expect(subject).to receive(:run_command).with(
          full_command,
          cwd: directory,
          environment: including(environment),
          timeout: timeout,
        )
      end

      after do
        subject.execute command
      end
    end

    context "when the command does not exit successfully" do
      let :error_message do
        "shell command failed"
      end

      before do
        allow(subject).to receive(:run_command).with(full_command, kind_of(::Hash)).and_raise(
          ::Kitchen::ShellOut::ShellCommandFailed,
          error_message
        )
      end

      specify "should raise a Kitchen::Transport::TransportFailed error" do
        expect do
          subject.execute command
        end.to raise_error ::Kitchen::Transport::TransportFailed, error_message
      end
    end

    context "when an unexpected error occurs" do
      let :error_message do
        "unexpected error"
      end

      before do
        allow(subject).to receive(:run_command).with(full_command, kind_of(::Hash)).and_raise(
          ::StandardError.new(error_message).extend(::Kitchen::Error)
        )
      end

      specify "should result in failure with the unexpected error message" do
        expect do
          subject.execute command
        end.to raise_error ::Kitchen::Terraform::Error, error_message
      end
    end
  end

  describe "#kind_of?" do
    specify "should return true when the argument is ::Kitchen::ShellOut" do
      expect(subject).to be_kind_of ::Kitchen::ShellOut
    end
  end
end
