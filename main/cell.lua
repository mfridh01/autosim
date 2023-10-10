local world = require "main.world"

local M = {}

function M:set_tile(v)
	self.tile = v
end

function M:get_tile()
	return self.tile
end

function M:get_connections()
	local current_tilemap = world.tilemaps[world.state.building_type]
	local current_grid = current_tilemap.grid[current_tilemap.layers[1]]
	local is_inbounds = world.is_tile_on_grid({x = self.position.x, y = self.position.y}, world.state.building_type)
	local neighbors = {}

	if current_grid[self.position.x] and current_grid[self.position.x][self.position.y + 1] then
		local neighbor_top = 	current_grid[self.position.x][self.position.y + 1]
		table.insert(neighbors, neighbor_top)
	end

	if current_grid[self.position.x + 1] and current_grid[self.position.x + 1][self.position.y] then
		local neighbor_right =	current_grid[self.position.x + 1][self.position.y]
		table.insert(neighbors, neighbor_right)
	end

	if current_grid[self.position.x] and current_grid[self.position.x][self.position.y - 1] then
		local neighbor_down = 	current_grid[self.position.x][self.position.y - 1]
		table.insert(neighbors, neighbor_down)
	end

	if current_grid[self.position.x - 1] and current_grid[self.position.x - 1][self.position.y] then
		local neighbor_left = 	current_grid[self.position.x - 1][self.position.y]
		table.insert(neighbors, neighbor_left)
	end

	return self.name
end

function M:set_animation_tiles(the_map)
	local short_tilemap = world.tilemaps[self.tilemap]
	local tiles = short_tilemap.tiles[self.direction.finish][self.direction.start]

	self.animation.frame_start = tiles.start
	self.animation.frame_finish = tiles.finish
end

function M.new(name, the_map, layer, tile, direction, position, is_destroyable, is_targetable, is_showing_cursor)
	local state = {
		name = name or "",
		tilemap = the_map or "",
		layer = layer or "",
		tile = tile or 0,
		direction = {
			start = direction.start or "",
			finish = direction.finish or "",
		},
		position = {
			x = position.x or 0,
			y = position.y or 0,
		},
		animation = {
			frame_start = 0,
			frame_finish = 0,
		},
		is_destroyable = is_destroyable or false,
		is_targetable = is_targetable or false,
		is_showing_cursor = is_showing_cursor or false,
	}

	return setmetatable(state, { __index = M })
end

return M