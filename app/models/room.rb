class Room < ApplicationRecord
  validates_uniqueness_of :name
  scope :public_rooms, -> { where(is_private: false) }
  after_update_commit { broadcast_if_public }
  has_many :messages
  has_many :participants, dependent: :destroy
  has_many :joinables, dependent: :destroy
  has_many :joined_users, through: :joinables, source: :user

  def broadcast_if_public
    broadcast_latest_message
  end

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end
    single_room
  end

  def participant?(room, user)
    room.participants.where(user_id: user.id).exists?
    Participant.where(user_id: user.id, room_id: room.id).exists?
  end

  def latest_message
    messages.includes(:user).order(created_at: :desc).first
  end

  def broadcast_latest_message
    last_message = latest_message

    return unless last_message

    target = "room_#{id} last_message"

    # rubocop:disable Style/HashSyntax
    broadcast_update_to('rooms',
                        target: target,
                        partial: 'rooms/last_message',
                        locals: {
                          room: self,
                          user: last_message.user,
                          last_message: last_message
                        })
    # rubocop:enable Style/HashSyntax
  end
end
