class RockPaperScissors
  def fight(game_count)
    win = 0
    lose = 0
    one_more =0

    game_count.times do |n|
      # あいこだった場合、one_more = 1となっている
      if one_more == 1
        puts "あいこで...(press g or c or p)" 
        one_more = 0
      else
        puts "じゃんけん…(press g or c or p)"
      end

      shoots = { 'g' => 'グー', 'c' => 'チョキ', 'p' => 'パー' }
      
      my_shoot = gets.chomp!
      # CPUはランダムでピックアップ
      cpu_shoot = ['g', 'c' ,'p'].sample
      
      puts "CPU…#{shoots[cpu_shoot]}"
      puts "あなた…#{shoots[my_shoot]}"

      if my_shoot == 'g' &&  cpu_shoot == 'c' || my_shoot == 'c' && cpu_shoot == 'p' || my_shoot == 'p' && cpu_shoot == 'g' 
        win += 1
        puts '勝ち!'
      elsif my_shoot == 'g' && cpu_shoot == 'p' || my_shoot == 'c' && cpu_shoot == 'g' || my_shoot == 'p' && cpu_shoot == 'c'
        lose += 1
        puts '負け!'
      else
        # あいこだった場合、one_moreフラグを立てる
        one_more = 1
        # 繰り返し処理をやり直す
        redo unless one_more == 0
      end
      puts "#{win}勝#{lose}敗"
    end

    puts "結果"
    if win > lose
      puts "#{win}勝#{lose}敗であなたの勝ち"
    else
      puts "#{win}勝#{lose}敗であなたの負け"
    end

  end
end

rock_paper_scissors = RockPaperScissors.new

puts "何本勝負？(press 1 or 3 or 5)"   
# 押されたキーを取得
game_count = gets.chomp!.to_i

if game_count != 1 && game_count != 3 && game_count != 5
  return puts 'もう一度実行し直してください'
else
  puts "#{game_count}本勝負を選びました"
end

rock_paper_scissors.fight(game_count)