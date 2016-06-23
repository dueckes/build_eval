module BuildEval

  class Travis

    class << self

      def last_build_status(args)
        repository = travis_module_for(args)::Repository.find(args[:build_path])
        repository.recent_builds.find(&:finished?).passed? ? "Success" : "Failure"
      rescue ::Travis::Client::Error
        "Unknown"
      end

      private

      def travis_module_for(args)
        travis_module = ::Travis
        if args[:github_token]
          travis_module = ::Travis::Pro
          travis_module.github_auth(args[:github_token])
        end
        travis_module
      end

    end

  end

end
