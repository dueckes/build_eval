module BuildEval

  module Travis

    def self.last_build_status(args)
      session = BuildEval::Travis::SessionFactory.create(args[:github_token])
      repository = session.repo(args[:repository_path])
      repository.recent_builds.find(&:finished?).passed? ? "Success" : "Failure"
    rescue ::Travis::Client::Error
      "Unknown"
    end

  end

end
