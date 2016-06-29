module BuildEval
  module Travis
    module Session

      class Session < DelegateClass(::Travis::Client::Session)

        attr_reader :github_token

        def initialize(raw_session, github_token)
          super(raw_session)
          @github_token = github_token
        end

      end

    end
  end
end
