local M = {}

M.TILEMAPS_TRANSPORTATION_BELT_YELLOW = "transportation_belt_yellow"
M.TILEMAPS_WORLD = "world"
M.TILEMAPS_BUILDING_GRID = "building_grid"

M.TILEMAP_ORDER = {
	M.TILEMAPS_TRANSPORTATION_BELT_YELLOW,
	M.TILEMAPS_WORLD,
}

-- Input action_id
M.BUILD_BELT = "build_belt"
M.ROTATE = "rotate"
M.FLIP = "flip"
M.CLEAR_ALL_ACTIONS = "clear_all_actions"
M.MOUSE_LEFT_BUTTON = "mouse_left_button"

-- Rotation pools
M.ROTATION_ORDER_START = "rotation_order_start"

M.cursor = {
	tile_source_url = "/game/cursor/cursor.tilesource",
	tile_map_url = "/transportation/transportation#transportation",
}

M.state = {
	is_building = false,
	is_dragging = false,
	is_flipping = false,
	building_type = "none",
	building_layer = "none",
	rotation_frame = 1,
	rotation_pool = "up",
	direction = "right",
}

M.guis = {
	tile_information = {
		url = "/gui#tile_information",
		nodes = {
			text = {
				body = "text",
			},
		},
	},
}

M.tilemaps = {
	building_grid = {
		url = "/main#building_grid",
		layers = {
			"layer1",
		},
		size = {
			x = 0,
			y = 0,
			width = 0,
			size = 0,
		},
		is_targetable = false,
		is_destroyable = false,
		is_animated = false,
		is_showing_curor = true,
		tile_size = 32,
		grid = {},
	},
	world = {
		url = "/world/tilemap#world",
		layers = {
			"water",
			"grass",
			"stone",
		},
		name = "World",
		type = "world",
		is_targetable = true,
		is_destroyable = false,
		is_animated = false,
		is_showing_cursor = false,
		tile_size = 32,
		delay = 4,
		size = {
			x = 0,
			y = 0,
			width = 0,
			height = 0,
		},
		grid = {
		},
	},
	transportation_belt_yellow = {
		url = "/transportation/transportation#transportation",
		layers = {"belts"},
		name = "Yellow belt",
		type = "transportation",
		is_targetable = true,
		is_destroyable = true,
		is_animated = true,
		is_showing_cursor = true,
		tile_size = 32,
		delay = 4,
		size = {
			x = 0,
			y = 0,
			width = 0,
			height = 0,
		},
		forbidden_tiles = {
			"water",
		},
		tiles = {
			up = {
				up		= {is_corner = false,	start = 9,	finish = 12},
				right	= {is_corner = true,	start = 13,	finish = 16},
				left 	= {is_corner = true,	start = 37,	finish = 40},
			},
			right = {
				right	= {is_corner = false,	start = 17,	finish = 20},
				down	= {is_corner = true,	start = 45,	finish = 48},
				up		= {is_corner = true,	start = 21,	finish = 24},
			},
			down = {
				down	= {is_corner = false,	start = 1,	finish = 4},
				left	= {is_corner = true,	start = 53,	finish = 56},
				right	= {is_corner = true,	start = 29,	finish = 32},
			},
			left = {
				left	= {is_corner = false,	start = 25,	finish = 28},
				up		= {is_corner = true,	start = 61,	finish = 64},
				down	= {is_corner = true,	start = 5,	finish = 8},
			},
			none = {
				none 	= {start = 0,	finish = 0},
			},
			rotation = {
				right = {
					--rotation_order_start = {"up_up", "right_up", "right_right", "down_right", "down_down", "left_down", "left_left", "up_right"},
					up_up		= {is_corner = false,	direction = "up",		direction_start = "up"},
					right_up	= {is_corner = true,	direction = "right",	direction_start = "up"},
					right_right = {is_corner = false,	direction = "right",	direction_start = "right"},
					down_right	= {is_corner = true,	direction = "down",		direction_start = "right"},
					down_down	= {is_corner = false,	direction = "down",		direction_start = "down"},
					left_down	= {is_corner = true,	direction = "left",		direction_start = "down"},
					left_left	= {is_corner = false,	direction = "left",		direction_start = "left"},
					up_right	= {is_corner = true,	direction = "up",		direction_start = "right"},
				},
				left = {
					--rotation_order_start = {"up_up", "left_up", "left_left", "down_left", "down_down", "right_down", "right_right", "up_left"},
					up_up 		= {is_corner = false,	direction = "up",		direction_start = "up"},
					left_up 	= {is_corner = true,	direction = "left",		direction_start = "up"},
					left_left	= {is_corner = false,	direction = "left",		direction_start = "left"},
					down_left 	= {is_corner = true,	direction = "down",		direction_start = "left"},
					down_down 	= {is_corner = false, 	direction = "down",		direction_start = "down"},
					right_down 	= {is_corner = true,	direction = "right",	direction_start = "down"},
					right_right = {is_corner = false, 	direction = "right",	direction_start = "right"},
					up_left 	= {is_corner = true,	direction = "up",		direction_start = "left"},
				},
			},
			animation = {
				frame_current = 1,
				frames = 4,
				frame_delay = 30/4,
				frame_delay_current = 0,
			},
		},
		grid = {},
	}
}

function M.tile_information(tile)
	-- Get all tilemaps in order.
	for _, tilemap_order in pairs(M.TILEMAP_ORDER) do
		local short_tilemap = M.tilemaps[tilemap_order]
		local grid = short_tilemap.grid

		for layer in pairs(grid) do
			local cell = grid[layer][tile.x][tile.y]
			if cell and cell.is_targetable and cell.tile ~= 0 then
				return cell
			end
		end
	end

	return nil
end

function M.get_available_connections(the_map, direction)
	local rotations = M.tilemaps[the_map].tiles[direction]
	local keyset = {}
	
	for k, _ in pairs(rotations) do
		table.insert(keyset, k)
	end

	return keyset
end

function M.get_available_rotations(the_map, direction)
	local rotations = M.tilemaps[the_map].tiles.rotation[direction]
	local keyset = {}

	for k, _ in pairs(rotations) do
		table.insert(keyset, k)
	end

	return keyset
end

function M.set_tiles_building_grid()
	
end

function M.world_to_tile(position, tile_size)
	return vmath.vector3(math.ceil(position.x / tile_size), math.ceil(position.y / tile_size), 0)
end

return M