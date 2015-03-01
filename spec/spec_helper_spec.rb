#
# Copyright 2015, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

require 'halite/spec_helper'

describe Halite::SpecHelper do
  include Halite::SpecHelper

  describe '#recipe' do
    context 'with a block' do
      recipe do
        ruby_block 'test'
      end

      it { is_expected.to run_ruby_block('test') }
    end # /context with a block

    context 'with a recipe' do
      let(:chefspec_options) { {dry_run: true} }
      recipe 'test'

      it do
        expect(chef_runner).to receive(:converge).with('test')
        chef_run
      end
    end # /context with a recipe
  end # /describe #recipe

  describe '#resource' do
    subject { Chef::Resource::HaliteTest }

    context 'with defaults' do
      resource(:halite_test)
      it { is_expected.to be_a(Class) }
      it { is_expected.to be < Chef::Resource }
      it { expect(subject.new(nil, nil).resource_name).to eq(:halite_test) }
      it { expect(subject.new(nil, nil).action).to eq(:run) }
      it { expect(subject.new(nil, nil).allowed_actions).to eq([:nothing, :run]) }
    end # /context with defaults

    context 'with auto:false' do
      resource(:halite_test, auto: false)
      it { is_expected.to be_a(Class) }
      it { is_expected.to be < Chef::Resource }
      it { expect(subject.new(nil, nil).resource_name).to be_nil }
      it { expect(subject.new(nil, nil).action).to eq(:nothing) }
      it { expect(subject.new(nil, nil).allowed_actions).to eq([:nothing]) }
    end # /context with auto:false

    context 'with a parent' do
      resource(:halite_test, parent: Chef::Resource::File)
      it { is_expected.to be_a(Class) }
      it { is_expected.to be < Chef::Resource }
      it { is_expected.to be < Chef::Resource::File }
    end # /context with a parent

    context 'with a helper-defined parent' do
      resource(:halite_parent)
      resource(:halite_test, parent: :halite_parent)
      it { is_expected.to be_a(Class) }
      it { is_expected.to be < Chef::Resource }
      it { is_expected.to be < Chef::Resource::HaliteParent }
    end # /context with a helper-defined parent

    context 'with a helper-defined parent in an enclosing context' do
      resource(:halite_parent)
      context 'inner' do
        resource(:halite_test, parent: :halite_parent)
        it { is_expected.to be_a(Class) }
        it { is_expected.to be < Chef::Resource }
        it { is_expected.to be < Chef::Resource::HaliteParent }
      end
    end # /context with a helper-defined parent in an enclosing context

    # Long name is long but ¯\_(ツ)_/¯
    context 'regression test for finding the wrong parent in a sibling context' do
      resource(:halite_parent) do
        def value
          :parent
        end
      end

      context 'sibling' do
        resource(:halite_parent) do
          def value
            :sibling
          end
        end
      end

      context 'inner' do
        resource(:halite_test, parent: :halite_parent)
        subject { Chef::Resource::HaliteTest.new(nil, nil).value }
        it { is_expected.to eq(:parent) }
      end
    end # /context regression test for finding the wrong parent in a sibling context

    context 'with step_into:false' do
      resource(:halite_test, step_into: false)
      provider(:halite_test) do
        def action_run
          ruby_block 'inner'
        end
      end
      recipe do
        halite_test 'test'
      end
      # Have to create this because step_into normally handles that
      def run_halite_test(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:halite_test, :run, resource_name)
      end

      it { is_expected.to run_halite_test('test') }
      it { is_expected.to_not run_ruby_block('inner') }
    end # /context with step_into:false
  end # /describe #resource
end
