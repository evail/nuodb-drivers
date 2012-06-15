#
# Copyright (c) 2012, NuoDB, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of NuoDB, Inc. nor the names of its contributors may
#       be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL NUODB, INC. BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

module ActiveRecord
  module ConnectionAdapters
    module Nuodb
      module DatabaseStatements

        def execute(sql, name = nil)
          do_execute sql, name
        end

        def do_execute(sql, name = 'SQL')
          log(sql, name) do
            @connection.execute(sql)
          end
        end

        def exec_query(sql, name = 'SQL', binds = [])

          # Convert the binds into a simple array of values
          cbinds = binds.map { |c|
            c[1]
          }

          # execute the query
          result = @connection.execute(sql, *cbinds)

          # build the result object
          obj = ActiveRecord::Result.new(result.column_names, result.to_a)
          def obj.generated_key=(generated_key)
            @generated_key = generated_key
          end
          def obj.generated_key
            @generated_key
          end
          keys = result.handle.generated_keys;
          if keys
            obj.generated_key = keys[0]
          end

          obj

        end

        def last_inserted_id(result)
          result.generated_key
        end

        protected

        def select(sql, name = nil, binds = [])
          exec_query(sql, name, binds).to_a
        end

      end
    end
  end
end
