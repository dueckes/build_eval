module BuildEval
  module Travis
    module Session

      def self.open(github_token)
        session = BuildEval::Travis::Session::Pool.get(github_token)
        yield session
      ensure
        BuildEval::Travis::Session::Pool.release(session)
      end

    end
  end
end
