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

module Halite
  module Converter
    module Other

      def self.write(spec, base_path)
        spec.each_file('chef') do |path, rel_path|
          dir_path = File.dirname(rel_path)
          FileUtils.mkdir_p(File.join(base_path, dir_path)) unless dir_path == '.'
          File.open(path, 'rb') do |in_f|
            File.open(File.join(base_path, rel_path), 'wb') do |out_f|
              IO.copy_stream(in_f, out_f)
            end
          end
        end
      end

    end
  end
end
