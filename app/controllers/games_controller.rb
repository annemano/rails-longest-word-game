require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet[rand(alphabet.length - 1)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    # check if letters of the word are available in the grid
    @in_grid = word_in_grid?
    # check if valid english word
    @valid = valid_english_word?
    # calculate total score for this session
    @user_score = total_score
  end

  private

  def word_in_grid?
    letter_hash = @letters.split.each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
    word_hash = @word.upcase.split('').each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
    reviewed_word = word_hash.select { |key, value| value <= letter_hash[key] }
    word_hash == reviewed_word
  end

  def valid_english_word?
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    JSON.parse(word_serialized)['found']
  end

  def total_score
    session[:score] = 0 if session[:score].nil?
    # add points to the total score if valid word
    session[:score] += @word.length if @in_grid && @valid
    # return total score
    session[:score]
  end
end
