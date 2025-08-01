# frozen_string_literal: true

module RubyLLM
  module Providers
    module XAI
      # Determines capabilities and pricing for XAI models
      module Capabilities
        module_function

        # Returns the context window size for the given model ID
        # @param model_id [String] the model identifier
        # @return [Integer] the context window size in tokens
        def context_window_for(model_id)
          case model_id
          when 'grok-4' then 256_000
          when 'grok-3' then 1_000_000
          when 'grok-3-mini' then 131_072
          when 'grok-2' then 128_000
          when 'grok-2-vision' then 128_000 # rubocop:disable Lint/DuplicateBranch
          when 'grok-vision-beta' then 131_072 # rubocop:disable Lint/DuplicateBranch
          else 128_000 # rubocop:disable Lint/DuplicateBranch
          end
        end

        # Returns the maximum number of tokens that can be generated
        # @param model_id [String] the model identifier
        # @return [Integer] the maximum number of tokens
        def max_tokens_for(_model_id)
          8_192
        end

        # Returns the price per million tokens for input
        # @param model_id [String] the model identifier
        # @return [Float] the price per million tokens in USD
        def input_price_for(model_id)
          PRICES.dig(model_family(model_id), :input) || 1.0
        end

        # Returns the price per million tokens for output
        # @param model_id [String] the model identifier
        # @return [Float] the price per million tokens in USD
        def output_price_for(model_id)
          PRICES.dig(model_family(model_id), :output) || 1.0
        end

        # Determines if the model supports vision capabilities
        # @param model_id [String] the model identifier
        # @return [Boolean] true if the model supports vision
        def supports_vision?(model_id)
          case model_id
          when 'grok-2-vision', 'grok-vision-beta' then true
          else false
          end
        end

        # Determines if the model supports function calling
        # @param model_id [String] the model identifier
        # @return [Boolean] true if the model supports functions
        def supports_functions?(_model_id)
          true
        end

        # Determines if the model supports JSON mode
        def supports_json_mode?(_model_id)
          true
        end

        # Formats the model ID into a human-readable display name
        # @param model_id [String] the model identifier
        # @return [String] the formatted display name
        def format_display_name(model_id)
          model_id.split('-').map(&:capitalize).join(' ')
        end

        # Returns the model type
        # @param model_id [String] the model identifier
        # @return [String] the model type (e.g., 'chat')
        def model_type(_model_id)
          'chat'
        end

        # Returns the model family
        # @param model_id [String] the model identifier
        # @return [Symbol] the model family
        def model_family(model_id)
          case model_id
          when 'grok-4' then :grok_4 # rubocop:disable Naming/VariableNumber
          when 'grok-3' then :grok_3 # rubocop:disable Naming/VariableNumber
          when 'grok-3-mini' then :grok_3_mini
          when 'grok-2' then :grok_2 # rubocop:disable Naming/VariableNumber
          when 'grok-2-vision' then :grok_2_vision
          when 'grok-vision-beta' then :grok_vision_beta
          else :unknown
          end
        end

        def modalities_for(model_id)
          modalities = {
            input: ['text'],
            output: ['text']
          }
          modalities[:input] << 'image' if supports_vision?(model_id)
          modalities
        end

        def capabilities_for(model_id)
          capabilities = %w[streaming json_mode]
          capabilities << 'vision' if supports_vision?(model_id)
          capabilities << 'tools' if supports_functions?(model_id)
          capabilities
        end

        def pricing_for(model_id)
          family = model_family(model_id)
          prices = PRICES.fetch(family, { input: 1.0, output: 1.0 })

          {
            text_tokens: {
              standard: {
                input_per_million: prices[:input],
                output_per_million: prices[:output]
              }
            }
          }
        end

        # Pricing information for XAI models (USD per 1M tokens)
        PRICES = {
          grok_4: { input: 3.0, output: 15.0 }, # rubocop:disable Naming/VariableNumber
          grok_3: { input: 3.0, output: 15.0 }, # rubocop:disable Naming/VariableNumber
          grok_3_mini: { input: 0.25, output: 0.50 },
          grok_2: { input: 5.0, output: 15.0 }, # rubocop:disable Naming/VariableNumber
          grok_2_vision: { input: 5.0, output: 15.0 },
          grok_vision_beta: { input: 5.0, output: 15.0 }
        }.freeze
      end
    end
  end
end
