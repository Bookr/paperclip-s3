module Paperclip
  module S3
    if defined? Rails::Railtie # Don't break rails 2.x
      require 'rails'
      class Railtie < Rails::Railtie
        initializer 'paperclip.force_s3_attachment_on_production' do
          ActiveSupport.on_load :active_record do
            Paperclip::S3::Railtie.insert
          end
        end
      end
    end

    class Railtie
      def self.insert
        in_staging = false

        if (defined?(Rails.env) && Rails.env)
          in_staging = Rails.env.staging?
        elsif (defined?(RAILS_ENV) && RAILS_ENV)
          in_staging = RAILS_ENV =~ /staging/
        end

        ActiveRecord::Base.send(:include, Paperclip::S3::Glue) if in_staging
      end
    end
  end
end
