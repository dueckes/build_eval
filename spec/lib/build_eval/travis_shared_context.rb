shared_context "stubbed Travis API interactions" do

  module StubTravisBuild

    def finished?
      # Intentionally blank
    end

    def passed?
      # Intentionally blank
    end

  end

    module StubTravisRepository

    def recent_builds
      # Intentionally blank
    end

  end

  module StubTravisPro

    Repository = StubTravisRepository

    def self.github_auth(auth_token)
      # Intentionally blank
    end

  end

  module StubTravis

    Repository = StubTravisRepository
    Pro = StubTravisPro

    module Client
      Repository = StubTravisRepository
      Build = StubTravisBuild
      Error = ::StandardError
    end

  end

  before(:context) do
    ::Travis = StubTravis
  end

end
