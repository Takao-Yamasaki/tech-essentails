# bubble_sortメソッドの作成
def bubble_sort(numbers)
  # 要素数の回数分繰り返す
  numbers.size.times do |i|
    # １つの要素に対して、次の要素と大小比較を繰り返す
    # 例えば、numbers[0] = 10が次の要素の値より小さくなるまで入替え処理を繰り返し、内側の繰り返し処理を抜ける
    (numbers.size - 1).times do |j|
      # numbers[j]がnumbers[j+1]より大きければ、numbers[j]とnumbers[j+1]の値を入れ替える
      numbers[j], numbers[j + 1] = numbers[j + 1], numbers[j] if numbers[j] > numbers[j + 1]
    end
  end
  numbers
end

# bubble_sortメソッドの呼び出し
p bubble_sort([10, 8, 3, 5, 2, 4, 11, 18, 20, 33])