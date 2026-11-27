class SightingsController < ApplicationController
  # ログイン必須は ApplicationController の Authentication で自動的にかかる

  def index
    # 自分の報告だけを新しい順に表示する。猫と地区の名前を出すので N+1 にならないようまとめて取得する
    @sightings = Current.user.sightings.includes(:cat, :area).order(created_at: :desc, id: :desc)
  end

  def new
    @sighting = Sighting.new
  end

  def create
    @sighting = Current.user.sightings.new(sighting_params)
    # 猫を選んだ場合は、地区はその猫の地区にそろえる
    @sighting.area = @sighting.cat.area if @sighting.cat

    if @sighting.save
      # 完了画面は redirect で出す（再読み込みで二重登録されないように）
      redirect_to complete_sightings_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def complete
  end

  private

  def sighting_params
    params.require(:sighting).permit(:cat_id, :area_id, :kind, :description)
  end
end
