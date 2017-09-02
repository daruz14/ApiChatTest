class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  def self.required_params
        [:info, :user_id, :conversation_id]
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
