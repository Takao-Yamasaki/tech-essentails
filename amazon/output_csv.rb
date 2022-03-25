require 'uri'
require 'csv'

url_array = [
  'https://www.amazon.co.jp/%E3%82%B0%E3%83%AC%E3%83%B4%E3%82%A3%E3%82%AA-%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF-%E3%83%93%E3%82%B8%E3%83%8D%E3%82%B9%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF-AIN_HYT_SWN_businessryukku_00-%E3%83%96%E3%83%A9%E3%83%83%E3%82%AF/dp/B085HLVJYP',
  'https://www.amazon.co.jp/%E3%83%93%E3%82%A2%E3%83%B3%E3%82%AD-%E3%83%95%E3%83%A9%E3%83%83%E3%83%97%E3%83%90%E3%83%83%E3%82%AF%E3%83%91%E3%83%83%E3%82%AF-%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF-NBTC-37-%E6%92%A5%E6%B0%B4/dp/B00UY43FVS',
  'https://www.amazon.co.jp/MARK-RYDEN-%E3%83%90%E3%83%83%E3%82%AF%E3%83%91%E3%83%83%E3%82%AF%E9%98%B2%E6%B0%B4-%E3%83%93%E3%82%B8%E3%83%8D%E3%82%B9%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF-%E7%9B%97%E9%9B%A3%E9%98%B2%E6%AD%A2%E3%83%A9%E3%83%83%E3%83%97%E3%83%88%E3%83%83%E3%83%97%E3%83%90%E3%83%83%E3%82%B017%E3%82%A4%E3%83%B3%E3%83%81%E3%83%91%E3%82%BD%E3%82%B3%E3%83%B3%E5%AF%BE%E5%BF%9C/dp/B082VTKYY9',
  'https://www.amazon.co.jp/%E3%83%93%E3%82%B8%E3%83%8D%E3%82%B9%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF-%E3%83%90%E3%83%83%E3%82%AF%E3%83%91%E3%83%83%E3%82%AF-USB%E5%85%85%E9%9B%BB%E3%83%9D%E3%83%BC%E3%83%8815-6%E3%82%A4%E3%83%B3%E3%83%81PC-%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF%E3%82%B5%E3%83%83%E3%82%AF-%E3%83%A1%E3%83%B3%E3%82%BA%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF/dp/B08FY6NGWN',
  'https://www.amazon.co.jp/SUNOGE-%E3%83%90%E3%83%83%E3%82%AF%E3%83%91%E3%83%83%E3%82%AF-%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF%E3%82%B5%E3%83%83%E3%82%AF-%E3%83%93%E3%82%B8%E3%83%8D%E3%82%B9%E3%83%AA%E3%83%A5%E3%83%83%E3%82%AF-%E3%83%A9%E3%83%83%E3%83%97%E3%83%88%E3%83%83%E3%83%97%E3%83%90%E3%83%83%E3%82%B0/dp/B08XHS9FQP'
]

items = {}

# URLの加工
# key: urlから商品IDを抽出したものを格納
# value: urlから商品名を抽出し、エンコーディングを変換したものを格納
# mapだと配列を返すので、to_hでハッシュ化する
items =  url_array.map { |url| [url.split('/')[5], URI.decode_www_form_component(url.split('/')[3])] }.to_h

# CSVの書き出し
CSV.open('./result.csv','w') do |result|
  # ヘッダを出力
  result << ['商品ID','商品名']
  # 明細行を出力
  items.map {|key, value| result << [key, value]} 
end

puts 'CSV出力が終了しました'