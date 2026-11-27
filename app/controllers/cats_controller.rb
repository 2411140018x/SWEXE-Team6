class CatsController < ApplicationController
  # 猫台帳を見るだけならログイン不要（閲覧する人向け）
  allow_unauthenticated_access only: :index

  def index
    # カードに地区名を表示するので、N+1にならないよう地区もまとめて取得する
    @cats = Cat.includes(:area).order(:id)
  end
end
