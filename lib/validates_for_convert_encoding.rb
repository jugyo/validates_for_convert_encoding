require 'iconv'

module ConvertEncodingValidation
  def self.included(base)
    base.extend ClassMethods
  end

  module InstanceMethods
    def self.included(base)
      base.class_inheritable_accessor :columns_for_convert_encode
      base.columns_for_convert_encode = {}
    end

    def valid_for_convert_encodeing?
      return unless columns_for_convert_encode
      columns_for_convert_encode.each do |key, options|
        convert_encodeing_to = options[:to].to_s
        convert_encodeing_from = options[:from].to_s
        convert_value = self.attributes[key].to_s
        begin
          Iconv.new(convert_encodeing_to, convert_encodeing_from).iconv(convert_value)
        rescue Iconv::IllegalSequence => e
          errors.add(key, "invalid sequence for #{convert_encodeing_to} from #{convert_encodeing_from}")
        end
      end
    end
  end

  module ClassMethods
    def self.extended(base)
      base.send(:include, InstanceMethods)
      base.validate :valid_for_convert_encodeing?
    end

    def validates_for_convert_encoding(options = {})
      target_columns = self.columns.select{ |column| [:string, :text].member?(column.type) }
      target_columns.each do |column|
        validates_for_convert_encoding_of(column.name, options)
      end
    end

    def validates_for_convert_encoding_of(column, options = {})
      raise ArgumentError, 'wrong arguments.' unless (options.keys - [:from, :to]).empty?
      columns_for_convert_encode[column.to_s] = options
    end
  end
end
