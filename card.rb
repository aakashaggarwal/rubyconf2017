class Card
  RANKS = %w(2 3 4 5 6 7 8 9 10 J Q K A)
  SUITS = %w(Spade Heart Club Diamond)

  attr_accessor :rank, :suit

  def initialize(id)
    self.rank = RANKS[id % 13]
    self.suit = SUITS[id % 4]
  end
end

class Deck
  attr_accessor :cards
  def initialize(number_of_deck)
    self.cards = []
    number_of_deck.times do |time|
      # shuffle array and init each Card
      self.cards += (0..51).to_a.shuffle.collect { |id| Card.new(id) }
      self.cards.shuffle!
    end
  end
end

class Game
  attr_accessor :player_scores, :dealer_scores, :player_cards, :dealer_cards
  def initialize
    self.player_scores = [0]
    self.dealer_scores = [0]
    self.player_cards = []
    self.dealer_cards = []
    current_index = 0
    # player_count = 1
    number_of_decks = 4
    d = Deck.new(number_of_decks)
    play_game('player', d.cards)
    self.player_cards.each do |player_card|
      puts "Player cards: " + player_card.rank + " of " + player_card.suit
    end
    self.dealer_cards.each do |dealer_card|
      puts "Dealer cards: " + dealer_card.rank + " of " + dealer_card.suit
    end
  end

  def play_game(type_of_player, cards_array, current_index=0)
    # puts current_index
    if current_index < 4
      if type_of_player == 'player'
        puts "Hey Player you're dealt "+ cards_array[current_index].rank + " of " + cards_array[current_index].suit
        self.player_cards.push(cards_array[current_index])
        self.player_scores = self.score_player(self.player_scores, cards_array[current_index])
        current_index =+ current_index + 1
        self.play_game('dealer', cards_array, current_index)
      else
        self.dealer_scores = self.score_player(self.dealer_scores, cards_array[current_index])
        self.dealer_cards.push(cards_array[current_index])
        if current_index == 1
          puts "Hey Dealer is dealt "+ cards_array[current_index].rank + " of " + cards_array[current_index].suit
        end
        current_index =+ current_index + 1
        self.play_game('player', cards_array, current_index)
      end
    else
      if type_of_player == 'player'
        puts "Do you want to HIT or STAND?"
        input =gets.chomp
        if input.downcase == "hit"
          puts "Hey Player you're dealt "+ cards_array[current_index].rank + " of " + cards_array[current_index].suit
          self.player_cards.push(cards_array[current_index])
          self.player_scores = self.score_player(self.player_scores, cards_array[current_index])
          if self.player_scores.include? 21
            puts "Congrats you've got BlackJack"
            self.play_game('dealer', cards_array, current_index)
          elsif self.player_scores.first > 21
            puts "Sorry you are busted, the dealer wins"
          else
            current_index =+ current_index + 1
            self.play_game('player', cards_array, current_index)
          end
        end
        if input.downcase == "stand"
          self.play_game('dealer', cards_array, current_index)
        end
      else
        player_score = self.player_scores.reject {|x| x > 21}.last
        dealer_score = self.dealer_scores.reject {|x| x > 21}.last
        if dealer_score.nil?
          puts "Player wins"
        else
          if dealer_score.to_i > player_score.to_i && dealer_score > 17
            puts "Dealer Wins"
          elsif dealer_score == player_score && dealer_score > 17
            puts "Draw"
          else
            dealer_score = self.dealer_scores.reject {|x| x > 21}.first
            if dealer_score > 17
              puts "Player Wins"
            else
              self.dealer_cards.push(cards_array[current_index])
              self.dealer_scores = self.score_player(self.dealer_scores, cards_array[current_index])
              current_index =+ current_index + 1
              self.play_game('dealer', cards_array, current_index)
            end
          end
        end
      end
    end
  end

  def score_player(past_scores, card)
    scores = []
    if card.rank == "A"
      past_scores.each do |past_score|
        scores.push(past_score + 1)
        scores.push(past_score + 11)
      end
    else
      past_scores.each do |past_score|
        if ['K', 'Q', 'J'].include? card.rank
          scores.push(past_score + 10)
        else
          scores.push(past_score + card.rank.to_i)
        end
      end
    end
    return scores
  end
end

class BlackJack
  game = Game.new
end