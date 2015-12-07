module BuildEval
  module Server

    class InvalidSelectorError < BuildEval::Error

      def initialize(response, selector)
        super("Build response did not match selector:\nResponse: #{response.message}\nSelector: #{selector}")
      end

    end

  end
end
