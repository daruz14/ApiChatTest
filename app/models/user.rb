class User < ApplicationRecord
  has_many :user_conversations, foreign_key: :user_id
  has_many :messages
  def self.required_params
        [:name, :password]
    end

    def self.validate_params(params)
        for key in self.required_params
            if !params.key?(key)
                return false
            end
        end
        return true
    end
end
