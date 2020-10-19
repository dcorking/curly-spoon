class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.all

    render json: @posts
  end

  # GET /posts/expired
  def expired
    posts = Post.expired

    render json: posts
  end

  # GET /posts/current
  def current
    posts = Post.current
    render json: posts
  end

  # GET /posts/1
  def show
    if @post
      render json: @post
    else
      render json: nil, status: :not_found
    end
  end

  # POST /posts
  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  # return an error, rather than raise an exception, when no record
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def post_params
    params.require(:post).permit(:title, :body, :expires, :valid_from)
  end
end
