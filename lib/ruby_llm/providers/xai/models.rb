# frozen_string_literal: true

module RubyLLM
  module Providers
    module XAI
      # Models methods of the XAI API integration
      module Models
        def list_models(**)
          slug = 'xai'
          capabilities = XAI::Capabilities
          parse_list_models_response(nil, slug, capabilities)
        end

        def parse_list_models_response(_response, slug, capabilities)
          [
            create_model_info('grok-4', slug, capabilities),
            create_model_info('grok-3', slug, capabilities),
            create_model_info('grok-3-mini', slug, capabilities),
            create_model_info('grok-2', slug, capabilities),
            create_model_info('grok-2-vision', slug, capabilities),
            create_model_info('grok-vision-beta', slug, capabilities)
          ]
        end

        def create_model_info(id, slug, capabilities)
          Model::Info.new(
            id: id,
            name: capabilities.format_display_name(id),
            provider: slug,
            family: capabilities.model_family(id).to_s,
            created_at: Time.now,
            context_window: capabilities.context_window_for(id),
            max_output_tokens: capabilities.max_tokens_for(id),
            modalities: capabilities.modalities_for(id),
            capabilities: capabilities.capabilities_for(id),
            pricing: capabilities.pricing_for(id),
            metadata: {}
          )
        end
      end
    end
  end
end
