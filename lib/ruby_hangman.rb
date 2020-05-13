def get_random_word
random_dictionary_words = Array.new
dictionary_words = File.read("5desk.txt").split
dictionary_words.each do |word|
  if word.length > 4 && word.length < 13
    random_dictionary_words.push(word)
  end
end
p random_dictionary_words.sample
end