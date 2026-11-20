# 開発用のサンプルデータ（何度実行しても重複しないよう find_or_create_by! を使う）

areas = %w[新家中町 西堤学園町 新庄].index_with do |name|
  Area.find_or_create_by!(name: name)
end

cats = [
  { area: "新家中町",   name: "みけ",     features: "三毛・しっぽが短い",     sex: "メス", ear_cut: true },
  { area: "新家中町",   name: "くろ",     features: "黒猫・首元に白い毛",     sex: "オス", ear_cut: false },
  { area: "西堤学園町", name: "はちわれ", features: "白黒のハチワレ",         sex: "不明", ear_cut: false },
  { area: "新庄",       name: "きじ",     features: "キジトラ・左耳が小さい", sex: "オス", ear_cut: true }
]

cats.each do |attrs|
  Cat.find_or_create_by!(name: attrs[:name], area: areas[attrs[:area]]) do |cat|
    cat.features = attrs[:features]
    cat.sex = attrs[:sex]
    cat.ear_cut = attrs[:ear_cut]
  end
end

puts "地区: #{Area.count}件 / 猫: #{Cat.count}匹"
