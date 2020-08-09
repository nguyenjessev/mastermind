# frozen_string_literal: true

module Mastermind
  class Game
  end

  class Human
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
