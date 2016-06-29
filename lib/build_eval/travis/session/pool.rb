module BuildEval
  module Travis
    module Session

      class Pool

        class << self

          def get(github_token)
            get_session(github_token) || create_session(github_token)
          end

          def release(session)
            session.clear_cache
            sessions_for(session.github_token) << session
          end

          def clear
            @pool = {}
          end

          private

          def get_session(github_token)
            sessions_for(github_token).shift
          end

          def create_session(github_token)
            BuildEval::Travis::Session::Factory.create(github_token)
          end

          def sessions_for(github_token)
            @pool ||= {}
            @pool[github_token] ||= []
            @pool[github_token]
          end

        end

      end

    end
  end
end
