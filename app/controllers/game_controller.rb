require 'longest_word'

class GameController < ApplicationController
  def grid
  end

  def game
    @grid = generate_grid(params[:gridsize].to_i)
  end

  def score
    session[:count_games] = 1 if session[:count_games].nil?
    session[:count_games] += 1

    session[:highscore] = [] if session[:highscore].nil?

    @start = params[:starttime].to_time
    @end = Time.now
    @word = params[:userinput]

    @result = run_game(params[:userinput], params[:grid].split(""), @start, @end)

    session[:highscore] << @result[:score]

  end
end

