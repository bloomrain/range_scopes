require "range_scopes/engine"

module RangeScopes
  extend ActiveSupport::Concern

  included do
    scope :range_between, ->(params){
      if params.keys.length != 2
        raise Exception.new("Range should be between two values, but #{params.keys.length} is given") 
      end
      
      from, till = params.values.first(2)
      from_key, till_key = params.keys.first(2).map do |key|
        key.match(/[.]/) ? key : "`#{self.table_name}`.#{key}"
      end

      if till.to_i == 0 and from.to_i == 0
        where({})
      else
        if till.to_i == 0
          where("? <= #{till_key} OR #{till_key} IS NULL", from.to_i)
        elsif from.to_i == 0
          where("#{from_key} <= ? OR #{from_key} IS NULL", till.to_i)
        else
          where(
            "(#{from_key} IS NULL AND #{till_key} IS NULL) OR " + 
            "(#{from_key} BETWEEN :from AND :till) OR " + 
            "(#{till_key} BETWEEN :from AND :till) OR " +
            "(:from BETWEEN #{from_key} AND #{till_key}) OR " +
            "(:till BETWEEN #{from_key} AND #{till_key})",
            {from: from, till: till}
          )
        end
      end
    }
  end
end
