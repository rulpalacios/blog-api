class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :content

  attribute :author do |object|
    {
      name: object.user.name,
      email: object.user.email
    }
  end
end
