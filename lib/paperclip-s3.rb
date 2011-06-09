require "paperclip-s3/version"

module Paperclip
  module S3
    
    # Extends the paperclips has_attached_file method
    # It will use S3 Storage. The credentials will be read from the environment
    def has_attached_file(name, options = {})
      options[:storage] ||= :s3
      options[:path]    ||= "/:class-:attachment/:id/:style-:basename.:extension"
      options[:bucket]  ||= ENV["S3_BUCKET"]
      options[:s3_credentials] ||= {
                                      :access_key_id => ENV['S3_KEY'],
                                      :secret_access_key => ENV['S3_SECRET']
                                   }
      super(name, options)
    end
    
    
  end
end

if defined?(ActiveRecord) and defined?(Rails)
  ActiveRecord::Base.send :extend, Paperclip::S3 if Rails.env.production?
end