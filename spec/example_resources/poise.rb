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

require 'chef/resource'
require 'chef/provider'
require 'poise'


# A `halite_test_poise` resource for use in Halite's unit tests.
module HaliteTestPoise
  class Resource < Chef::Resource
    include Poise
    provides(:halite_test_poise)
    actions(:run)
  end

  class Provider < Chef::Provider
    include Poise
    provides(:halite_test_poise)

    def action_run
      notifying_block do
        ruby_block new_resource.name do
          block { }
        end
      end
    end
  end
end
