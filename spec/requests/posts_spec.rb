require 'rails_helper'
require 'timecop'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    it 'succeeds' do
      get posts_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns an array of JSON objects' do
      get posts_path
      expect(response.body).to eq '[]'
    end
  end

  describe 'POST /posts' do
    it 'succeeds' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      expect(response).to have_http_status(:created)
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
      expect(response).to have_http_status(:ok)
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

  describe 'DELETE /posts/{id}' do
    it 'succeeds' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      id = JSON.parse(response.body)['id']
      delete post_path(id)
      expect(response).to have_http_status(:no_content)
    end

    it 'deletes the post' do
      post posts_path, params: { post: { title: 'Hello world!' } }
      id = JSON.parse(response.body)['id']
      delete post_path(id)
      get post_path(id)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET /posts/expired' do
    it 'succeeds' do
      get expired_posts_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns expired posts' do
      Timecop.freeze(Date.new(2020,3,1)) do
        post posts_path, params: { post: { expires: '2020-02-28' }}

        get expired_posts_path
        posts = JSON.parse(response.body)

        expect(posts.length).to eq 1
        expect(DateTime.iso8601(posts[0]['expires'])).to eq DateTime.new(2020,2,28)
      end
    end
  end

  describe 'GET /posts/current' do
    it 'succeeds' do
      get current_posts_path

      expect(response).to have_http_status(:ok)
    end

    it 'shows current posts' do
      Timecop.freeze(Date.new(2020,3,1)) do
        post posts_path, params: { post:
                                    { valid_from: '2020-02-28',
                                      expires: '2020-03-02' } }

        get current_posts_path
        posts = JSON.parse(response.body)
        expect(posts.length).to eq(1)
      end
    end

    it 'omits expired posts' do
      Timecop.freeze(DateTime.new(2020,3,1,0,1)) do
        post posts_path, params: { post:
                                    { valid_from: '2020-02-28',
                                      expires: '2020-03-01T00:00Z' } }

        get current_posts_path
        posts = JSON.parse(response.body)
        expect(posts.length).to eq(0)
      end
    end

    it 'omits posts that are not yet valid' do
      Timecop.freeze(DateTime.new(2020,2,28,23,59)) do
        post posts_path, params: { post:
                                    { valid_from: '2020-03-01T00:00Z',
                                      expires: '2020-03-02' } }

        get current_posts_path
        posts = JSON.parse(response.body)
        expect(posts.length).to eq(0)
      end
    end
  end
end
