require 'open-uri'
require 'json'

def generate_grid(grid_size)
  # TODO: generate random grid of letters
  grid = []
  (1..grid_size).each { grid << 'A'.upto('Z').to_a.sample }
  grid
end

def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  api_url = "http://api.wordreference.com/0.8/80143/json/enfr/#{attempt}"
  attempt_letters = attempt.upcase.split("")
  result = { time: end_time - start_time, translation: " ", score: 0, message: " " }
  if check(grid, attempt_letters)
    result = translation_counter(api_url, start_time, end_time, attempt_letters)
  else
    result[:message] = "not in the grid"
  end
  result
end


def check(grid, attempt_array)
  check_array = []
  attempt_array.each do |character|
    if grid.include?(character)
      check_array << character
      grid.delete_at(grid.index(character))
    end
  end
  check_array == attempt_array ? true : false
end

def translation_counter(url, start, ending, attempt_array)
  result = { time: (ending - start).round(4), translation: nil, score: 0, message: "not an english word" }
  open(url) do |stream|
    translation = JSON.parse(stream.read)
    if translation["term0"]
      result[:translation] = translation["term0"]["PrincipalTranslations"]["0"]["FirstTranslation"]["term"]
      result[:score] += ( attempt_array.length * 1000  / (ending - start) ).round(4)
      result[:message] = "well done"
    end
  end
  result
end



# p run_game("law", %w(W G G Z O N A L), Time.now, Time.now + 1.0)
# p run_game("law", %w(W G G Z O N A L), Time.now, Time.now + 10.0)
# p generate_grid(9)
# p run_game("wagon", %w(W G G Z O N A L), 1, 10)

p generate_grid(9)
