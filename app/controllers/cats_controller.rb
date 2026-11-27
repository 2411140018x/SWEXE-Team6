class CatsController < ApplicationController
  def index
    # カードに地区名を表示するので、N+1にならないよう地区もまとめて取得する
    @cats = Cat.includes(:area).order(:id)
  end

  def show
    # 存在しないIDのときは find が ActiveRecord::RecordNotFound を出し、Railsが404にする
    @cat = Cat.find(params[:id])
  end
end
