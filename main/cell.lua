local world = require "main.world"

local M = {}

function M:set_tile(v)
	self.tile = v
end

function M:get_tile()
	return self.tile
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