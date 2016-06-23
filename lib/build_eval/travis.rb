module BuildEval

  class Travis

    def initialize(travis_module)
      @travis_module = travis_module
    end

    def login(auth_token)
      @travis_module.github_auth(auth_token)
    end

    def last_build_status_for(build_path)
      @travis_module::Repository.find(build_path).recent_builds.find(&:finished?).passed? ? "Success" : "Failure"
    rescue ::Travis::Client::Error
      "Unknown"
    end

  end

end
