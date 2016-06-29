module BuildEval

  module Travis

    STATUS_BY_COLOR = { green: "Success", yellow: "Building", red: "Failure" }.freeze

    private_constant :STATUS_BY_COLOR

    def self.last_build_status(args)
      BuildEval::Travis::Session.open(args[:github_token]) do |session|
        repository = session.repo(args[:repository_path])
        build = args[:branch] ? repository.branch(args[:branch]) : repository.last_build
        STATUS_BY_COLOR[build.color.to_sym]
      end
    rescue ::Travis::Client::Error
      "Unknown"
    end

  end

end
