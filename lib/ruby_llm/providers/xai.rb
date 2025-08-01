# frozen_string_literal: true

module RubyLLM
  module Providers
    # XAI API integration.
    module XAI
      extend Anthropic
      extend XAI::Models

      module_function

      def api_base(_config)
        'https://api.x.ai/v1'
      end

      def headers(config)
        {
          'Authorization' => "Bearer #{config.xai_api_key}"
        }
      end

      def slug
        'xai'
      end

      def configuration_requirements
        %i[xai_api_key]
      end
    end
  end
end
