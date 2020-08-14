# frozen_string_literal: true

module Mastermind
  COLORS = %w[red blue green yellow black white].freeze

  # This class represents the game state
  class Game
    attr_accessor :codebreaker, :codemaker
    attr_reader :secret_code

    def play_game
      setup_game
      end_message = "\nNo turns left! Game over!"
      12.times do |num|
        result = play_round(num)
        codebreaker.receive_result(result)
        if result == %w[O O O O]
          end_message = "\nCorrect! Game over!"
          break
        end
      end

      puts end_message
    end

    private

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
      return %w[O O O O] if answer == guess

      result = []

      answer = answer.clone
      guess.each_with_index do |color, index|
        if color == answer[index]
          result.push('O')
          answer[index] = nil
        else
          index = answer.index(color)
          if index && answer[index] != guess[index]
            result.push('X')
            answer[index] = nil
          else
            result.push('_')
          end
        end
      end

      result
    end

    def setup_game
      puts "\nWould you like to play as the codebreaker or codemaker?"
      puts '1: Codebreaker'
      puts '2: Codemaker'

      choice = 0
      loop do
        choice = gets.chomp.to_i
        break if [1, 2].include?(choice)

        puts 'Invalid input, please try again.'
      end

      if choice == 1
        @codebreaker = Human.new
        @codemaker = Cpu.new
      else
        @codebreaker = Cpu.new
        @codemaker = Human.new
      end

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
      puts "\nYou are the codemaker! Enter your secret code one color at a time. Valid colors are"\
           'red, green, blue, yellow, black, and white:'
      input_code
    end

    def receive_result(result)
      puts "\nGuess feedback (O = correct, X = wrong position, _ = incorrect):"
      puts result.join(' ')
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
    attr_accessor :possible_colors, :last_guess, :must_include

    def initialize
      @possible_colors = Array.new(4) { %w[red green blue yellow black white] }
      @must_include = []
    end

    def generate_code
      code = []
      4.times do
        code.push(COLORS.sample)
      end

      puts "\nThe CPU has generated a secret code."
      code
    end

    def guess_code
      puts "\nThe CPU is thinking..."
      sleep(3)

      guess = []

      possible_colors.each_with_index do |pos, index|
        guess[index] = if (pos & must_include).to_a.empty?
                         possible_colors[index].sample
                       else
                         must_include.delete((pos & must_include)[0])
                       end
      end
      puts "CPU guess: #{guess.join(' ')}"

      self.last_guess = guess
      guess
    end

    def receive_result(result)
      puts "\nGuess feedback (O = correct, X = wrong position, _ = incorrect):"
      puts result.join(' ')

      self.must_include = []
      result.each_with_index do |pos, index|
        possible_colors[index] = [last_guess[index]] if pos == 'O'
        possible_colors[index].delete(last_guess[index]) if %w[_ X].include?(pos)
        must_include.push(last_guess[index]) if pos == 'X'
      end
    end
  end
end

game = Mastermind::Game.new
game.play_game
