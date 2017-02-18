json.extract! user,
  :id,
  :username,
  :email,
  :photo_url,
  :current_channel

json.subscriptions user.channels do |channel|
  json.extract! channel, :id, :name, :description
end
