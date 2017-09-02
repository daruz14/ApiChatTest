class Conversation < ApplicationRecord
  has_many :user_conversations, foreign_key: :conversation_id
  has_many :messages, dependent: :destroy
end
