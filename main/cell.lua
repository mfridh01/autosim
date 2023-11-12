local world = require "main.world"

local M = {}

function M:set_tile(v)
	self.tile = v
end

function M:get_tile()
	return self.tile
end

function M:get_neighbors(the_map, layer)
	self.neighbors = {}
	local building_type = the_map or world.state.building_type
	if building_type == "none" then building_type = the_map end
	
	local current_tilemap = world.tilemaps[building_type] or world.tilemaps[the_map]
	local current_grid = current_tilemap.grid[current_tilemap.layers[1]] or current_tilemap.grid[layer]
	local is_inbounds = world.is_tile_on_grid({x = self.position.x, y = self.position.y}, building_type)
	local neighbors = {}

	if current_grid[self.position.x] and current_grid[self.position.x][self.position.y + 1] then
		local neighbor_top = 	vmath.vector3(self.position.x, self.position.y + 1, 0)
		table.insert(neighbors, neighbor_top)
	end

	if current_grid[self.position.x + 1] and current_grid[self.position.x + 1][self.position.y] then
		local neighbor_right =	vmath.vector3(self.position.x + 1, self.position.y, 0)
		table.insert(neighbors, neighbor_right)
	end

	if current_grid[self.position.x] and current_grid[self.position.x][self.position.y - 1] then
		local neighbor_down = 	vmath.vector3(self.position.x, self.position.y - 1, 0)
		table.insert(neighbors, neighbor_down)
	end

	if current_grid[self.position.x - 1] and current_grid[self.position.x - 1][self.position.y] then
		local neighbor_left = 	vmath.vector3(self.position.x - 1, self.position.y, 0)
		table.insert(neighbors, neighbor_left)
	end

	self.neighbors = neighbors
	return neighbors
end

function M:get_rotation_pool(neighbors)
	local cursor_tilemap = world.state.building_type
	local cursor_layer = world.tilemaps[cursor_tilemap].layers[1]
	local rotation_pool = {}
	
	for _, neighbor in ipairs(neighbors) do
		local neighbor_cell = world.tilemaps[cursor_tilemap].grid[cursor_layer][neighbor.x][neighbor.y]
		
		if neighbor_cell.direction.finish ~= "none" then
			for k, _ in pairs(world.tilemaps[neighbor_cell.tilemap].tiles[neighbor_cell.direction.finish]) do
				local rot_string = k .. "_" .. neighbor_cell.direction.finish
				table.insert(rotation_pool, rot_string)
			end
		end
	end

	if #rotation_pool == 3 then
		--pprint(rotation_pool)
		return rotation_pool
	end

	return {}
end

function M:set_connections(current_cell, the_map)
	if not current_cell.is_targetable then return end
	local cursor_tilemap = the_map
	if cursor_tilemap == "none" then cursor_tilemap = current_cell.tilemap end
	local cursor_layer = world.tilemaps[cursor_tilemap].layer
	current_cell.connections = {}
	
	local cursor_layer = world.tilemaps[cursor_tilemap].layers[1]

	for _, neighbor in ipairs(current_cell.neighbors) do
		local neighbor_cell = world.tilemaps[cursor_tilemap].grid[cursor_layer][neighbor.x][neighbor.y]

		if neighbor_cell.direction.finish == "up" then table.insert(current_cell.connections, vmath.vector3(current_cell.position.x, current_cell.position.y - 1, 0))
		elseif neighbor_cell.direction.finish == "right" then table.insert(current_cell.connections, vmath.vector3(current_cell.position.x - 1, current_cell.position.y, 0))
		elseif neighbor_cell.direction.finish == "down" then table.insert(current_cell.connections, vmath.vector3(current_cell.position.x, current_cell.position.y + 1, 0))
		elseif neighbor_cell.direction.finish == "left" then table.insert(current_cell.connections, vmath.vector3(current_cell.position.x + 1, current_cell.position.y, 0))
		end	
	end
end

function M:set_animation_tiles(the_map)
	local short_tilemap = world.tilemaps[self.tilemap]
	local tiles = short_tilemap.tiles[self.direction.finish][self.direction.start]

	pprint(self)

	self.animation.frame_start = tiles.start
	self.animation.frame_finish = tiles.finish
end

function M.new(name, the_map, layer, tile, direction, position, is_destroyable, is_targetable, is_showing_cursor, type_info)
	local state = {
		name = name or "",
		tilemap = the_map or "",
		layer = layer or "",
		tile = tile or 0,
		direction = {
			start = direction.start or "none",
			finish = direction.finish or "none",
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
		connections = {},
		neighbors = {},
		type_info = {
			type = type_info.type or "",
			input = {
				directions = type_info.input.directions or {},
				next = type_info.input.next or "",
			},
			output = {
				directions = type_info.output.directions or {},
				next = type_info.output.next or "",
			},
		}
	}
	return setmetatable(state, { __index = M })
end

return M