module BuildEval
  module Travis

    class SessionFactory

      class << self

        def create(github_token)
          find_session(github_token) || create_session(github_token)
        end

        def clear_cache
          @sessions = {}
        end

        private

        def find_session(github_token)
          sessions[github_token]
        end

        def create_session(github_token)
          travis_uri = github_token ? ::Travis::Client::PRO_URI : ::Travis::Client::ORG_URI
          sessions[github_token] = ::Travis::Client::Session.new(uri: travis_uri, ssl: {}).tap do |session|
            session.github_auth(github_token) if github_token
          end
        end

        def sessions
          @sessions ||= {}
        end

      end

    end

  end
end
