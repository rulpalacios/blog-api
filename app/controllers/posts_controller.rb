class PostsController < ApplicationController
  # GET /posts
  def index
    @posts = Post.where(published: true)

    render json: PostSerializer.new(@posts), status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id])

    render json: PostSerializer.new(@post), status: :ok
  end

  # POST /posts
  def create
    @post = Post.create!(post_params) 
    render json: PostSerializer.new(@post), status: :created  
  end

  # PUT /posts
  def update
    @post = Post.find(params[:id])
    @post.update!(post_params)
    render json: PostSerializer.new(@post), status: :ok
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :published, :user_id)
  end
end