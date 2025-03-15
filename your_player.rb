require './base_player.rb'

class YourPlayer < BasePlayer
  def initialize(game:, name:)
    super
    @current_position = nil
  end

  def next_point(time:)
    # Implement your strategy here.
    if @current_position.nil?
      @current_position = starting_position
      grid.visit(@current_position)
      return @current_position
    end

    next_move = find_next_move
    if next_move
      grid.visit(next_move)
      @current_position = next_move
    end
    next_move || @current_position
  end

  def grid
    game.grid
  end

  private

  def starting_position
    # Start at a strategic position based on player name
    case name
    when 'Player 1'
      {row: 0, col: 0}
    when 'Player 2'
      {row: grid.max_row, col: grid.max_col}
    when 'Player 3'
      {row: grid.max_row, col: grid.max_col}
    end
  end

  def find_next_move
    # Get all unvisited neighbors
    unvisited_neighbors = grid.edges[@current_position].keys.reject { |n| grid.visited[n] }

    # If there are no unvisited neighbors, find the nearest unvisited node
    if unvisited_neighbors.empty?
      return find_nearest_unvisited
    end

    # Choose the neighbor with the minimum combined cost of travel and heuristic
    unvisited_neighbors.min_by do |n|
      travel_cost = grid.edges[@current_position][n]
      heuristic_cost = heuristic(n)
      travel_cost + heuristic_cost
    end
  end

  def find_nearest_unvisited
    # Find the nearest unvisited node from the current position
    unvisited_positions = grid.edges.keys.reject { |pos| grid.visited[pos] }
    return nil if unvisited_positions.empty?

    unvisited_positions.min_by do |pos|
      (pos[:row] - @current_position[:row]).abs + (pos[:col] - @current_position[:col]).abs
    end
  end

  def heuristic(position)
    # Calculate the distance to the nearest unvisited node
    unvisited_positions = grid.edges.keys.reject { |pos| grid.visited[pos] }
    return 0 if unvisited_positions.empty?

    unvisited_positions.map do |pos|
      (pos[:row] - position[:row]).abs + (pos[:col] - position[:col]).abs
    end.min
  end
end
