class Player
  attr_reader :chip, :display

  def self.get_player_chip(color)
    if color == 'red'
      "🔴"
    else
      "🔵"
    end
  end

  def initialize(color, display)
    @chip = Player.get_player_chip(color)
    @display = display
  end

end
