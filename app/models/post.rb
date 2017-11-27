class Post < ApplicationRecord
  belongs_to :category
  validates :title, :content, :category_id, presence: true

  def index
    if params[:category].blank?
      @posts = Post.all.order("id DESC")
    else
      @category_id = Category.find_by(name: params[:category]).id
      @posts = Post.where(category_id: @category_id).order("id DESC")
    end
  end
end
