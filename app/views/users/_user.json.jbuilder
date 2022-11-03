json.extract! user, :id, :id, :email, :name, :comment_id, :effective_id, :avatar, :created_at, :updated_at
json.url user_url(user, format: :json)
