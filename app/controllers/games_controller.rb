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
    # check if word letters can be built from the original grid
    letter_hash = @letters.split.each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
    word_hash = @word.upcase.split('').each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
    reviewed_word = word_hash.select { |key, value| value <= letter_hash[key] }
    @grid = word_hash == reviewed_word
    # check if valid english word
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    @found = JSON.parse(word_serialized)['found']
    raise
    # calculate score
    # @score += @word.length if @grid && @found
  end
end
