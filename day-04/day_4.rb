# frozen_string_literal: true

require 'set'

INPUT_FILES = %w[sample.txt input.txt].freeze

def read_file
  File.read(File.join(__dir__, INPUT_FILES[1]))
end

# Non optimal solution
def count_matches
  card_stack = card_list
  queue = range_array(0, card_stack.size)

  queue_pointer = 0
  while queue_pointer < queue.size
    current_index = queue[queue_pointer]
    current_card = card_stack[current_index]

    queue += range_array(current_index + 1, current_card[:matches].size) if current_card[:matches].size.positive?

    queue_pointer += 1
  end

  queue.size
end

# More performant solution
# We just need to count the number of copies of each card
def count_matches_2
  card_stack = card_list
  copies = Array.new(card_stack.size, 1)

  # Iterate through the card stack
  card_stack.each_with_index do |card, index|
    # Iterate over the cards ahead of the current card up to the total match count
    # Card 1 at index 0 has 4 matches, here we look at cards in index 1-4
    for i in (index + 1)..(index + card[:matches].size)

      # Iterate once for each copy of the card
      for j in 0...copies[index]
        copies[i] += 1
      end
    end
  end

  copies.sum
end

def card_list
  card_string_arr = read_file.split("\n")

  card_string_arr.map do |card_str|
    card_id, numbers_str = card_str.split(': ')

    winning_numbers_str, your_numbers_str = numbers_str.split('|').map(&:chomp)
    winning_numbers = winning_numbers_str.split(' ')
    your_numbers = your_numbers_str.split(' ')

    matches = (Set.new(winning_numbers) & Set.new(your_numbers)).to_a

    {
      card_id: card_id,
      winning_numbers: winning_numbers,
      your_numbers: your_numbers,
      matches: matches
    }
  end
end

def range_array(start, total)
  range = []
  for i in start...(start + total)
    range << i
  end
  range
end

puts count_matches_2
