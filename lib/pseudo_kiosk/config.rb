module PseudoKiosk
  module Config
    class << self
      # accepts a lambda function or string
      # if lambda function is passed, instance of controller
      # is passed to lambda for access to helper functions like
      # current_user
      attr_accessor :unlock_mechanism

      def init!
        @defaults = {
          :@unlock_mechanism                     => nil,
        }
      end

      # Resets all configuration options to their default values.
      def reset!
        @defaults.each do |k, v|
          instance_variable_set(k, v)
        end
      end

      def update!
        @defaults.each do |k, v|
          instance_variable_set(k, v) unless instance_variable_defined?(k)
        end
      end

      def user_config(&blk)
        block_given? ? @user_config = blk : @user_config
      end

      def configure(&blk)
        @configure_blk = blk
        @configure_blk.call(self) 
      end

      def configure!
        @configure_blk.call(self) if @configure_blk
      end
    end

    init!
    reset!
  end
end
