class Janken
  SELECTABLE_GAME_COUNT = [1, 3, 5]
  attr_accessor :game_count
  attr_accessor :cpu
  attr_accessor :matches

  def initialize(player, cpu = Cpu.new)
  # インスタンス作成時に渡された名前をインスタンス変数に格納する
    @player = player
    @cpu = cpu
    @matches = []
  end

  # メイン処理
  def start
    # じゃんけんの回数を選択させる処理
    show_game_count_section
    # 入力された回数分だけじゃんけんを行う
    1.upto(@game_count) do |count|
      battle(count)
    end
    # 最終的な結果を表示する
    show_result
  end

  # じゃんけんの回数を選択させる処理
  def show_game_count_section
    puts "何本勝負？(press #{SELECTABLE_GAME_COUNT.join(' or ')})"
    @game_count = gets.to_i
    if SELECTABLE_GAME_COUNT.include?(game_count)
      puts "#{game_count}本勝負を選びました" 
    else
     puts "#{SELECTABLE_GAME_COUNT.join('か')}で入力してください"
      show_game_count_section
    end
  end

  # じゃんけんを行う
  def battle(count)
    puts "#{count}本目"
    match = Match.new(count, @player, @cpu)
    p self.matches << match
    match.battle
    puts "#{wined_count}勝#{lose_count}敗"
  end

  # 最終的な結果を表示する
  def show_result
    puts '結果'
    puts "#{wined_count}勝#{lose_count}敗であなたの#{wined_count > lose_count ? '勝ち' : '負け'}"
  end

  # 勝った回数をカウント
  # match.winedには、勝ったら'true'が、負けたら'false'が格納される
  # filterメソッドで真となる配列を返す
  # countメソッドで要素数の合計を返している
  def wined_count
    self.matches.filter{ |match| match.winned }.count
  end

  # 負けた回数をカウント
  # match.winedには、勝ったら'true'が、負けたら'false'が格納される
  # rejectメソッドは偽であった配列を返す
  # countメソッドで要素数の合計を返している
  def lose_count
    self.matches.reject{ |match| match.winned }.count
  end
end

class Match
  attr_accessor :count
  attr_accessor :player
  attr_accessor :player_hand
  attr_accessor :cpu
  attr_accessor :cpu_hand
  attr_accessor :winned

  def initialize(count, player, cpu)
    @count = count
    @player = player
    @cpu = cpu
  end

  # じゃんけんを行う
  def battle
    @player_hand = @player.create_hand
    @cpu_hand = @cpu.create_hand

    puts "CPU...#{@cpu_hand.name}"
    puts "あなた...#{@player_hand.name}"
    if @player.draw?(@cpu)
      puts 'あいこで...'
      battle
    elsif @player.win?(@cpu)
      puts '勝ち！'
      @winned = true
    elsif @player.lose?(@cpu)
      puts '負け！'
      @wined = false
    end
  end
end

class Player
  attr_accessor :matches
  attr_accessor :hand

  def create_hand
    puts 'じゃんけん…(press g or c or p)'
    # 入力された値をシンボルに変換してtypeに格納
    type = gets.chomp.to_sym
    # クラス名::定数名 でHandクラスのNAME_MAPPING定数を参照
    if Hand::NAME_MAPPING.keys.include?(type)
      @hand = Hand.new(type)
      @hand
    else
      puts 'g or c or p で入力して'
      # create_handをもう一度呼び出す
      create_hand
    end
  end

  def draw?(cpu)
    @hand.draw?(cpu.hand)
  end

  def win?(cpu)
    @hand.win?(cpu.hand)
  end

  def lose?(cpu)
    @hand.lose?(cpu.hand)
  end
end

class Cpu
  attr_accessor :hand

  def create_hand
  # HandメソッドのNAME_MAPPING定数のキーからランダムに取り出し、シンボルに変換する
    @hand = Hand.new(Hand::NAME_MAPPING.keys.sample.to_sym)
    @hand
  end
end

class Hand
  # グーチョキパーの対照表
  NAME_MAPPING = {
   g: 'グー',
   c: 'チョキ',
   p: 'パー'
  }
  # 勝ち負けの対照表
  WIN_LOSE_MAPPING = {
    g: :c,
    c: :p,
    p: :g
  }
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def name
    NAME_MAPPING[@type]
  end

  def draw?(hand)
    @type == hand.type
  end

  def win?(hand)
    WIN_LOSE_MAPPING[@type] == hand.type
  end

  def lose?(hand)
    # 勝ち負け対照表を反転させる
    # invertメソッドで、値=>キーのハッシュを返す
    WIN_LOSE_MAPPING.invert[@type] == hand.type
  end
end

janken = Janken.new(Player.new)
janken.start