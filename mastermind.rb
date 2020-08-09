# frozen_string_literal: true

module Mastermind
  COLORS = %w[red blue green yellow black white].freeze

  class Game
  end

  # This class represents a human player
  class Human
    def input_code
      puts 'Please enter your code:'
      4.times do |num|
        print "Position #{num}: "
        input = input_color
      end
    end

    private

    def input_color
      loop do
        input = gets.chomp.downcase

        break if @@COLORS.include?(input)

        puts 'Invalid input, please try again:'
      end

      input
    end
  end

  class Cpu
  end

  # This class represents a 4-color code
  class Code
    attr_accessor :code

    def initialize
      @code = []
    end
  end
end
