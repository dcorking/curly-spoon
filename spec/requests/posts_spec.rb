require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    it 'succeeds' do
      get posts_path
      expect(response).to have_http_status(200)
    end

    it 'returns an array of JSON objects' do
      get posts_path
      expect(response.body).to eq '[]'
    end
  end

  describe 'POST /posts' do
    it 'succeeds' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      expect(response).to have_http_status(201)
    end

    it 'adds a persistent post' do
      expect do
        post posts_path, params: { post: { title: 'Hello world!' } }
      end.to change {Post.count}.by(1)
      expect(Post.last.title).to eq('Hello world!')
    end

    it 'returns the object and integer id' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      expect(JSON.parse(response.body)). to match(
                                    'id' => an_instance_of(Integer),
                                    'title' => 'Hello world!',
                                    'body' => nil,
                                    'valid_from' => nil,
                                    'expires'=> nil,
                                )
    end
  end

  describe 'PUT /posts/{id}' do
    it 'succeeds' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      id = JSON.parse(response.body)['id']
      put post_path(id), params:  { post: { title: 'Hello Bath!' } }
      expect(response).to have_http_status(200)
    end

    it 'updates the post' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      id = JSON.parse(response.body)['id']
      get post_path(id)
      expect(JSON.parse(response.body)['title']).to eq('Hello world!')
      put post_path(id), params:  { post: { title: 'Hello Bath!' } }
      expect(JSON.parse(response.body)['title']).to eq('Hello Bath!')
      get post_path(id)
      expect(JSON.parse(response.body)['title']).to eq('Hello Bath!')
    end
  end
end
