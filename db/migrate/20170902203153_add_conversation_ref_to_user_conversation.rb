class AddConversationRefToUserConversation < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_conversations, :conversation, foreign_key: true
  end
end
