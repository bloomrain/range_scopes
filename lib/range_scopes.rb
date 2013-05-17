require "range_scopes/version"

require 'active_support/concern'

module RangeScopes

  extend ActiveSupport::Concern

  included do
    scope :range_between, ->(params){
      if params.keys.length != 2
        raise Exception.new("Range should be between two values, but #{params.keys.length} is given") 
      end
      
      from, till = params.values.first(2)
      from_key, till_key = params.keys.first(2)

      if till.to_i == 0 and from.to_i == 0
        where({})
      else
        if till.to_i == 0
          where("? <= #{till_key} OR #{till_key} IS NULL", from.to_i)
        elsif from.to_i == 0
          where("#{from_key} <= ? OR #{from_key} IS NULL", till.to_i)
        else
          where(
            "NOT((? < #{from_key} AND ? < #{from_key})" + 
            " OR (#{till_key} < ? AND #{till_key} < ?))",
            from.to_i, till.to_i, from.to_i, till.to_i
          )
        end
      end
    }
  end
end
