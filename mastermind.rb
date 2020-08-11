# frozen_string_literal: true

module Mastermind
  COLORS = %w[red blue green yellow black white].freeze

  class Game
  end

  # This class represents a human player
  class Human
    def input_code
      puts 'Please enter your code:'

      result = Array.new(4)
      4.times do |num|
        print "Position #{num + 1}: "
        result[num] = input_color
      end

      result
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
        code.push(COLORS.sample)
      end
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
