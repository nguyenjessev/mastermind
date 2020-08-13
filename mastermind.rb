# frozen_string_literal: true

require 'pry'

module Mastermind
  COLORS = %w[red blue green yellow black white].freeze

  # This class represents the game state
  class Game
    attr_accessor :codebreaker, :codemaker

    def play_game
      setup_game
    end

    private

    def setup_game
      @codebreaker = Human.new
      @codemaker = Cpu.new
      @secret_code = codemaker.generate_code
    end
  end

  # This class represents a human player
  class Human
    def input_code
      result = Array.new(4)
      4.times do |num|
        print "Position #{num + 1}: "
        result[num] = input_color
      end

      result
    end

    def guess_code
      puts 'Enter your guess, one color at a time. Valid colors are red, green, blue, yellow, black, and white:'
      input_code
    end

    def generate_code
      puts 'You are the codemaker! Enter your secret code one color at a time. Valid colors are '\
           'red, green, blue, yellow, black, and white:'
      input_code
    end

    private

    def input_color
      input = ''

      loop do
        input = gets.chomp.downcase

        break if COLORS.include?(input)

        puts 'Invalid input, please try again:'
      end

      input
    end
  end

  # This class represents the CPU
  class Cpu
    def generate_code
      code = Code.new
      4.times do
        code.code.push(COLORS.sample)
      end

      puts 'The CPU has generated a secret code.'
      code
    end
  end

  # This class represents a 4-color code
  class Code
    attr_accessor :code

    def initialize
      @code = []
    end
  end
end

game = Mastermind::Game.new
game.play_game
