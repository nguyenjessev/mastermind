# frozen_string_literal: true

require 'pry'

module Mastermind
  COLORS = %w[red blue green yellow black white].freeze

  # This class represents the game state
  class Game
    attr_accessor :codebreaker, :codemaker
    attr_reader :secret_code

    def play_game
      setup_game
      end_message = "\nSorry, you lost!"
      12.times do |num|
        result = play_round(num)
        if result[:correct] == 4
          end_message = "\nCorrect! You win!"
          break
        else
          print_result(result)
        end
      end

      puts end_message
    end

    private

    def print_result(result)
      puts "\nCorrect: #{result[:correct]}"
      puts "Wrong position: #{result[:wrong_position]}"
    end

    def play_round(round_num)
      print_turns(round_num)

      guess = codebreaker.guess_code
      verify_guess(secret_code, guess)
    end

    def print_turns(num)
      if num < 11
        puts "\nThere are #{12 - num} turns remaining."
      else
        puts 'There is 1 turn remaining.'
      end
    end

    def verify_guess(answer, guess)
      return { correct: 4, wrong_position: 0 } if answer == guess

      result = { correct: 0, wrong_position: 0 }

      answer = answer.clone
      guess.each_with_index do |color, index|
        if color == answer[index]
          result[:correct] += 1
          answer[index] = nil
          next
        end

        index = answer.index(color)
        if index && answer[index] != guess[index]
          result[:wrong_position] += 1
          answer[index] = nil
        end
      end

      result
    end

    def setup_game
      @codebreaker = Human.new
      @codemaker = Cpu.new
      @secret_code = codemaker.generate_code
    end
  end

  # This class represents a human player
  class Human
    def input_code
      result = []
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
      code = []
      4.times do
        code.push(COLORS.sample)
      end

      puts "\nThe CPU has generated a secret code."
      code
    end
  end
end

game = Mastermind::Game.new
game.play_game
