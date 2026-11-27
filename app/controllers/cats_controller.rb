class CatsController < ApplicationController
  # 猫台帳を見るだけならログイン不要（閲覧する人向け）
  allow_unauthenticated_access only: :index

  def index
    # カードに地区名を表示するので、N+1にならないよう地区もまとめて取得する
    @cats = Cat.includes(:area).order(:id)
  end

  def show
    # 存在しないIDのときは find が ActiveRecord::RecordNotFound を出し、Railsが404にする
    @cat = Cat.find(params[:id])
    # 報告は新しい順。同じ時刻の報告があっても順番がぶれないよう id でも並べる（自分の報告一覧と同じ）
    @sightings = @cat.sightings.order(created_at: :desc, id: :desc)
  end
end
