module RoomsHelper
  def search_rooms
    if params[:name_search].present? && params[:name_search].length.positive?
      Room.public_rooms
        .where
        .not(id: current_user.joined_rooms.pluck(:id))
        .where('name LIKE ?', "%#{params[:name_search]}%")
        .order(name: :asc)
    else
      []
    end
  end
end
