class Player
  attr_reader :chip, :display, :name

  def self.get_player_chip(color)
    if color == 'red'
      "🔴"
    else
      "🔵"
    end
  end

  def initialize(name, color, display)
    @name = name
    @chip = Player.get_player_chip(color)
    @display = display
  end

end
