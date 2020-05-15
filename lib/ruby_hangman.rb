require 'yaml'
class Game
  @@dictionary = File.readlines("5desk.txt").keep_if { |word| word.chomp.length.between?(5,12) }
  @@user_guesses = ""
  @@correct_guess = Array.new
  @@incorrect_guess = Array.new
  def initialize
    @your_save = []
  end

  def get_random_word
    @secret_word = @@dictionary.sample.chomp
    @guess_count = @secret_word.length
    guess_word
  end

  def start_game
    p "Welcome to my Hangman!"
    puts "[1] = New Game [2] = Load saved Game"
    user_response = gets.chomp
    if user_response == "1"
      get_random_word
    elsif user_response == "2"
      load_game
    else
      start_game
    end
  end

  def guess_word
    @game_over = false
    while !@game_over do
      failed = 0
      p "[1] = SAVE [2] = EXIT"
      p "Pick a letter?"
      user_guess = gets.chomp
      if user_guess == "1"
        save_game
      elsif user_guess == "2"
        exit!
      else
        p @@user_guesses
        @@user_guesses += user_guess
        @secret_word.split('').each { |letter| 
        if @@user_guesses[letter]
          print letter
        else
          print "_"
          failed += 1
        end
        }
      end
      print "\n"
      if failed == 0
        winner
      elsif @secret_word.include?(user_guess)
        @@correct_guess.push(user_guess)
        p "Guesses remaining: #{@guess_count}"
        p "Correct guesses: #{@@correct_guess.join(' ').upcase}"
      else
        @@incorrect_guess.push(user_guess)
        @guess_count = @guess_count -1
        p "Guesses remaining: #{@guess_count}"
        p "Incorrect guesses: #{@@incorrect_guess.join(' ').upcase}"
        if @guess_count == 0
          loser
        end
      end
    end
  end

  def winner
      p "#{@secret_word}"
      p "You figured out the word, Congrats!"
      exit!
  end
  
  def loser
    @game_over == true
    p "The word was: #{@secret_word}"
    p "You Lose!"
    exit!
  end

  def save_game
    p "name save file:"
    save_name = gets.chomp
    secret_word = @secret_word
    user_guesses = @@user_guesses
    correct_guess = @@correct_guess
    incorrect_guess = @@incorrect_guess
    guess_count = @guess_count
    @your_save = [secret_word, user_guesses, correct_guess, incorrect_guess, guess_count]
    if File.exists?("#{save_name}.yml")
      p "File name already exists, please try a different name."
      save_game
    else
      File.new("#{save_name}.yml", "w+")
      File.open("#{save_name}.yml", "r+") do |line|
        line.write(@your_save.to_yaml)
      end
      exit!
    end
  end
  
  def load_game
    yml_files = File.join("*.yml")
    yml_files = Dir.glob(yml_files).join(", ")
    p "[1]Main Menu [2]Exit"
    p yml_files
    p "Select the game you would like to load (without the 'yaml'): "
    filename = gets.chomp
    if filename == "1"
      start_game
    elsif filename == "2"
      exit!
    elsif File.exists?("#{filename}.yml")
    @your_save = YAML.load_file("#{filename}.yml")
    @secret_word = @your_save[0]
    @@user_guesses = @your_save[1]
    @@correct_guess = @your_save[2]
    @@incorrect_guess = @your_save[3]
    @guess_count = @your_save[4].to_i
    guess_word
    else
      p "That filename does not exist, try again"
      load_game
    end
  end
end

game = Game.new
game.start_game
