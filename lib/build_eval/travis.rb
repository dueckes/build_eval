module BuildEval

  class Travis

    class << self

      def last_build_status(args)
        repository = create_session(args).repo(args[:repository_path])
        repository.recent_builds.find(&:finished?).passed? ? "Success" : "Failure"
      rescue ::Travis::Client::Error
        "Unknown"
      end

      private

      def create_session(args)
        travis_uri = args[:github_token] ? ::Travis::Client::PRO_URI : ::Travis::Client::ORG_URI
        ::Travis::Client::Session.new(uri: travis_uri, ssl: {}).tap do |session|
          session.github_auth(args[:github_token]) if args[:github_token]
        end
      end

    end

  end

end
