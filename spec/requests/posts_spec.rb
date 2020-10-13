require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it 'succeeds' do
      get posts_path
      expect(response).to have_http_status(200)
    end

    it 'returns an array of JSON objects' do
      get posts_path
      expect(response.body).to eq '[]'
    end
  end
end
