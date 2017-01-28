d = Deck.new
d.cards.each do |card|
  puts "#{card.rank} #{card.suit}"
end
