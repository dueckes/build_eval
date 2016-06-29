module BuildEval
  module Travis
    module Session

      class Factory

        class << self

          def create(github_token)
            BuildEval::Travis::Session::Session.new(create_raw_session(github_token), github_token)
          end

          private

          def create_raw_session(github_token)
            ::Travis::Client::Session.new(uri: uri_for(github_token), ssl: {}).tap do |session|
              session.github_auth(github_token) if github_token
            end
          end

          def uri_for(github_token)
            github_token ? ::Travis::Client::PRO_URI : ::Travis::Client::ORG_URI
          end

        end

      end

    end
  end
end
