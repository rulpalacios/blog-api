require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    before { get '/posts' }

    it 'should return OK' do
      payload = JSON.parse(response.body)
      expect(payload['data']).to be_empty
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'with data in the DB' do
    let!(:posts) { create_list(:post, 10, published: true) }
    before { get '/posts' }
    it 'should return all the published posts' do
      payload = JSON.parse(response.body)
      expect(payload['data'].size).to eq(posts.size)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /posts/{id}' do
    let!(:post) { create(:post) }

    it 'should return a post' do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['data']['attributes']['id']).to eq(post.id)
      expect(payload['data']['attributes']['title']).to eq(post.title)
      expect(payload['data']['attributes']['content']).to eq(post.content)
      expect(payload['data']['attributes']['author']['name']).to eq(post.user.name)
      expect(payload['data']['attributes']['author']['email']).to eq(post.user.email)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /posts' do
    let!(:user) { create(:user) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'title',
          content: 'content',
          published: false,
          user_id: user.id
        }
      }

      post '/posts', params: req_payload
      payload = JSON.parse(response.body)

      expect(payload).not_to be_empty
      expect(payload['data']['attributes']['id']).not_to be_nil
      expect(response).to have_http_status(:created)
    end

    it 'should return a error message on invalid post' do
      req_payload = {
        post: {
          content: 'content',
          published: false,
          user_id: user.id
        }
      }

      post '/posts', params: req_payload
      payload = JSON.parse(response.body)

      expect(payload).not_to be_empty
      expect(payload['error']).not_to be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /posts/{id}' do
    let!(:article) { create(:post) }

    it 'should update a post' do
      req_payload = {
        post: {
          title: 'title',
          content: 'content',
        }
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['data']['attributes']['id']).to eq(article.id)
      expect(response).to have_http_status(:ok)
    end

    it 'should return a error message on invalid post' do
      req_payload = {
        post: {
          title: nil,
          content: nil,
        }
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['error']).to_not be_empty
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end