# frozen_string_literal: true

require 'set'

INPUT_FILES = %w[sample.txt input.txt].freeze
SPECIAL_CHARS = %w[@ # $ % & * - + = /].freeze

TOP_LEFT = [-1, -1].freeze
TOP = [-1, 0].freeze
TOP_RIGHT = [-1, 1].freeze
RIGHT = [0, 1].freeze
BOTTOM_RIGHT = [1, 1].freeze
BOTTOM = [1, 0].freeze
BOTTOM_LEFT = [1, -1].freeze
LEFT = [0, -1].freeze

ADJACENT_SIDES = [TOP_LEFT, TOP, TOP_RIGHT, RIGHT, BOTTOM_RIGHT, BOTTOM, BOTTOM_LEFT, LEFT].freeze

def read_file
  File.read(File.join(__dir__, INPUT_FILES[1]))
end

def build_engine_grid
  # Example: ['467..114..', '...*......', '..35..633.', ...]
  lines_arr = read_file.split("\n")

  # Example: [["4", "6", "7", ".", ".", "1", "1", "4", ".", "."], [".", ".", ".", "*", ".", ".", ".", ".", ".", "."], ...]
  lines_arr.map { |line| line.split('') }
end

def find_engine_parts
  grid = build_engine_grid

  # Iteration through the grid
  part_numbers = []
  gear_ratios = []
  grid.each_with_index do |row, row_index|
    row.each_with_index do |col, col_index|
      if SPECIAL_CHARS.include?(col)
        part_numbers += find_adjacent_numbers(row_index, col_index, grid,
                                              gear_ratios).to_a
      end
    end
  end

  puts "gear_ratios sum: #{gear_ratios.reduce(:+)}"
  part_numbers
end

def sum_part_numbers
  find_engine_parts.sum
end

def number?(char)
  char.to_i.to_s == char
end

def find_adjacent_numbers(row, col, grid, gear_ratios)
  # A set is similiar to an array but does not allow duplicates
  # This is help full since a number can be adjacent in many spots
  # puts "special char #{grid[row][col]} found at row: #{row}, col: #{col}}"

  numbers = Set.new
  ADJACENT_SIDES.each do |side|
    row_look = row + side[0]
    col_look = col + side[1]

    # Verify we are not looking outside of the bounds of the grid
    inbounds = inbounds?(row_look, col_look, grid)

    numbers << find_full_number(row_look, col_look, grid) if inbounds && number?(grid[row_look][col_look])
  end

  is_gear = grid[row][col] == '*' && numbers.length == 2

  gear_ratios << numbers.reduce(:*) if is_gear
  numbers
end

def inbounds?(row, col, grid)
  top_bound = 0
  bottom_bound = grid.length - 1
  left_bound = 0
  right_bound = grid[0].length - 1

  top_bound_check = row >= top_bound
  bottom_bound_check = row <= bottom_bound
  left_bound_check = col >= left_bound
  right_bound_check = col <= right_bound

  top_bound_check && bottom_bound_check && left_bound_check && right_bound_check
end

def find_full_number(row, col, grid)
  # Looking right to find the index (col) of the first number
  col -= 1 while col.positive? && number?(grid[row][col - 1])

  # Concat the values to a string until we find a char that is not a number or hit the end of the row
  number_str = ''
  while number?(grid[row][col]) && col < grid[row].length
    number_str += grid[row][col]
    col += 1
  end

  number_str.to_i
end

puts "sum_part_numbers: #{sum_part_numbers}"
