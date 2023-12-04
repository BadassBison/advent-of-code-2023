# frozen_string_literal: true

def read_input_file
  File.read(File.join(__dir__, 'input.txt'))
end

def build_game_data
  # Example hash design: { game_id: { rounds: [[r, g, b], [r, g, b], [r, g, b]], max: [r, g, b], min: [r, g, b] }

  read_input_file.split("\n").each_with_object({}) do |line, hash|
    # example: line = "Game 1: 2 red, 2 green; 1 red, 1 green, 2 blue; 3 blue, 3 red, 3 green; 1 blue, 3 green, 7 red; 5 red, 3 green, 1 blue"

    game_id, rounds = line.split(': ')
    # emample: game_id = "Game 1"
    #          rounds = "2 red, 2 green; 1 red, 1 green, 2 blue; 3 blue, 3 red, 3 green; 1 blue, 3 green, 7 red; 5 red, 3 green, 1 blue"

    rounds_arr = rounds.split('; ').map do |round|
      # example: round = "2 red, 2 green"

      values = [0, 0, 0]
      round.split(', ').each do |color_str|
        # example: color_str = "2 red"

        count, color = color_str.split(' ')
        # exmaple: count = "2"
        #          color = "red"

        values[0] = count.to_i if color == 'red'
        # exmaple: values = [2, 0, 0]

        values[1] = count.to_i if color == 'green'
        # exmaple: values = [2, 2, 0]

        values[2] = count.to_i if color == 'blue'
        # exmaple: values = [2, 2, 0]
      end

      values
    end

    # These will collect all the values of each color, and give the max/min
    max_red = rounds_arr.map { |round| round[0] }.max
    min_red = rounds_arr.map { |round| round[0] }.min

    max_green = rounds_arr.map { |round| round[1] }.max
    min_green = rounds_arr.map { |round| round[1] }.min

    max_blue = rounds_arr.map { |round| round[2] }.max
    min_blue = rounds_arr.map { |round| round[2] }.min

    # Data object for the game
    hash[game_id] = {
      rounds: rounds_arr,
      max: [max_red, max_green, max_blue],
      min: [min_red, min_green, min_blue],
      power: max_red * max_green * max_blue
    }

    # implicit return
    hash
  end
end

def calculate_result(max_red, max_green, max_blue)
  game_data = build_game_data
  games_possible = []
  sum_power = 0

  # Example: game_id = "Game 68", data = {:rounds=>[[3, 2, 12], [5, 2, 14], [6, 0, 14], [6, 2, 10]], :max=>[6, 2, 14], :min=>[3, 0, 10]}
  game_data.each do |game_id, data|
    id = game_id.split(' ')[1].to_i
    max = data[:max]
    sum_power += data[:power]

    games_possible << id if max[0] <= max_red && max[1] <= max_green && max[2] <= max_blue
  end

  sum_power
end

puts calculate_result(12, 13, 14)
