require 'validates_for_convert_encoding'

ActiveRecord::Base.class_eval do
  include ConvertEncodingValidation
end
