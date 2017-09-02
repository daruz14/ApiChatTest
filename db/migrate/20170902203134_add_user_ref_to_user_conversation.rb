class AddUserRefToUserConversation < ActiveRecord::Migration[5.0]
  def change
    add_reference :user_conversations, :user, foreign_key: true
  end
end
