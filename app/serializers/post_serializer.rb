class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :expires, :valid_from
end
