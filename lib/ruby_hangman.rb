def get_random_word
random_dictionary_words = Array.new
dictionary_words = File.read("5desk.txt").split
dictionary_words.each do |word|
  if word.length > 4 && word.length < 13
    random_dictionary_words.push(word)
  end
end
return random_dictionary_words.sample
end

def start_game
  user_guesses = ""
  game_over = false
  guess_count = 7
  correct_guess = Array.new
  incorrect_guess = Array.new
  random_word = get_random_word().downcase
  while !game_over do
    failed = 0
    p "Pick a letter?"
    user_guess = gets.chomp
    user_guesses += user_guess
    random_word.split('').each { |letter| 
    if user_guesses[letter]
      print letter
    else
      print "_"
      failed += 1
    end
    }
    print "\n"
    if failed == 0
      p "You figured out the word, Congrats!"
      break
    elsif random_word.include?(user_guess)
      correct_guess.push(user_guess)
      p "Guesses remaining: #{guess_count}"
      p "Correct guesses: #{correct_guess.join(' ').upcase}"
    else
      incorrect_guess.push(user_guess)
      guess_count = guess_count -1
      p "Guesses remaining: #{guess_count}"
      p "Incorrect guesses: #{incorrect_guess.join(' ').upcase}"
        if guess_count == 0
        game_over == true
        p "Game Over"
        break
        end
    end
  end
end

start_game()
