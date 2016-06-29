module BuildEval
  module Examples

    class TravisPro

      class << self

        def build_configurations
          ENV["TRAVIS_PRO_BUILDS"].split(",")
        end

        def monitor
          BuildEval.server(
            type:         :TravisPro,
            username:     "MYOB-Technology",
            github_token: ENV["TRAVIS_PRO_GITHUB_TOKEN"]
          ).monitor(*build_configurations)
        end

        def display_statuses
          puts monitor.evaluate.to_s
        end

      end

    end

  end
end
