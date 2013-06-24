class Hangman
  
  MAX_TRIES = 10
  
  def initialize(dict = 'dictionary.txt')
    @dict = File.readlines(dict).map(&:chomp)
  end
  
  def play
    print_menu
    choice = gets.to_i
    while choice != 5
      case choice
      when 1
        run(HumanPlayer.new,ComputerPlayer.new(@dict))
      when 2
        run(ComputerPlayer.new(@dict),HumanPlayer.new)
      when 3
        run(HumanPlayer.new,HumanPlayer.new)
      when 4
        run(ComputerPlayer.new(@dict),ComputerPlayer.new(@dict))
      else
        return "Bye-bye"
      end
      print_menu
      choice = gets.to_i
    end
  end
  
  def print_menu
    puts "[1] Human vs. Computer"
    puts "[2] Computer vs. Human"
    puts "[3] Human vs. Human"
    puts "[4] Computer vs. Computer"
    puts "[5] Quit"
  end
  
  def run(guesser,referee)
    turns = 1
    guesses = []
    secret_word = referee.pick_word
    display = secret_word
    until someone_won?(display) || MAX_TRIES < turns
      
      print "guessed: #{guesses.join(",")}" unless guesses == [] 
      
      guesses << guesser.guess(display)
      display = referee.process_guess(guesses)  
      
      prev_display ||= display
      turns += 1 if prev_display == display
      prev_display = display
    end
    puts "GAMEOVER"
    
  end
  
  def someone_won?(display)
    !display.split(//).include?('-')
  end
  
end

class HumanPlayer
  
  #player
  def guess(do_nothing)
    print "\n>"
    gets[0].downcase
  end
  
  #referee
  def pick_word
    puts "How long is the word?"
    display = "-" * gets.to_i
    puts display
    display
  end
  
  def process_guess(guess)
    gets.chomp
  end
  
end

class ComputerPlayer
  
  def initialize(dictionary)
    @dict = dictionary
    @guesses = []
  end
  
  #player
  def guess(string)
    @dict = @dict.select{|word| word.length == string.length}
    @dict = parse_dictionary(string,@dict)
    dict_string = @dict.join('')
    
    letter_count = ('a'..'z').to_a.map{|letter| [letter,dict_string.count(letter)] }
    letter_count = letter_count.sort_by{ |letter| letter[1] }
    letter_count = letter_count.select{|letter| !@guesses.include? letter[0] }
    @guesses << letter_count.last[0]
    puts "\nI guess ... #{@guesses[-1]}"
    @guesses[-1]
  end
  
  def parse_dictionary(string,dictionary)
    string.split(//).each_index{|index| string[index] = '.' if string[index] == '-'}
    dictionary.select{|word| Regexp.new(string).match word}
  end
  
  #referee
  def pick_word
    @secret_word = @dict.shuffle.first
    puts "-" * @secret_word.length
    "-" * @secret_word.length
  end
  
  def process_guess(guesses)
    display_word = @secret_word.dup
    @secret_word.split(//).each_index do |index|
      display_word[index] = "-" unless guesses.include? @secret_word[index]
    end
    puts display_word
    display_word
  end
  
end