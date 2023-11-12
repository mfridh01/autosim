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

-- Tile types
M.NORMAL = "normal"
M.SPLITTER = "splitter"
M.MERGERR = "merger"

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
	direction = "right",
	direction_start = "",
	direction_finish = "",
	rotation_frame = 1,
	rotation_pool = {"up_up"}
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
				right	= {is_corner = true,	start = 37,	finish = 40},
				left 	= {is_corner = true,	start = 13,	finish = 16},
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
				split	= {start = 89,	finish = 92},
			},
			split = {
				down_right_down_left = {is_corner = false, start = 65, finish = 68},
				down_right_down = {is_corner = false, start = 73, finish = 76},
				down_down_left = {is_corner = false, start = 81, finish = 84},
				down_right_left = {is_corner = false, start = 89, finish = 92},
				down_down = {is_corner = false, start = 97, finish = 100},
				down_right = {is_corner = false, start = 105, finish = 108},
				down_left = {is_corner = false, start = 113, finish = 116},
				down_none = {is_corner = false, start = 121, finish = 124},
				none_none = {is_corner = false, start = 125, finish = 128},

				none_right_down_left = {is_corner = false, start = 69, finish = 72},
				none_right_down = {is_corner = false, start = 77, finish = 80},
				none_down_left = {is_corner = false, start = 85, finish = 88},
				none_right_left = {is_corner = false, start = 93, finish = 96},
				none_down = {is_corner = false, start = 101, finish = 104},
				none_right = {is_corner = false, start = 109, finish = 112},
				none_left = {is_corner = false, start = 117, finish = 120},
			},
			merge = {
				down_right_down_left = {is_corner = false, start = 129, finish = 132},
				down_right_down = {is_corner = false, start = 137, finish = 140},
				down_down_left = {is_corner = false, start = 145, finish = 148},
				down_right_left = {is_corner = false, start = 153, finish = 156},
				down_down = {is_corner = false, start = 161, finish = 164},
				down_right = {is_corner = false, start = 169, finish = 172},
				down_left = {is_corner = false, start = 177, finish = 180},
				down_none = {is_corner = false, start = 185, finish = 188},
				none_none = {is_corner = false, start = 189, finish = 192},

				none_right_down_left = {is_corner = false, start = 133, finish = 136},
				none_right_down = {is_corner = false, start = 141, finish = 144},
				none_down_left = {is_corner = false, start = 149, finish = 152},
				none_right_left = {is_corner = false, start = 157, finish = 160},
				none_down = {is_corner = false, start = 165, finish = 168},
				none_right = {is_corner = false, start = 173, finish = 176},
				none_left = {is_corner = false, start = 181, finish = 184},
			},
			rotation = {
				right = {
					up_up		= {is_corner = false,	direction = "up",		direction_start = "up"},
					right_up	= {is_corner = true,	direction = "right",	direction_start = "up"},
					right_right = {is_corner = false,	direction = "right",	direction_start = "right"},
					down_right	= {is_corner = true,	direction = "down",		direction_start = "right"},
					down_down	= {is_corner = false,	direction = "down",		direction_start = "down"},
					left_down	= {is_corner = true,	direction = "left",		direction_start = "down"},
					left_left	= {is_corner = false,	direction = "left",		direction_start = "left"},
					up_right	= {is_corner = true,	direction = "up",		direction_start = "right"},
					no_connections = {"up_up", "right_right", "down_down", "left_left"},
				},
				left = {
					up_up 		= {is_corner = false,	direction = "up",		direction_start = "up"},
					left_up 	= {is_corner = true,	direction = "left",		direction_start = "up"},
					left_left	= {is_corner = false,	direction = "left",		direction_start = "left"},
					down_left 	= {is_corner = true,	direction = "down",		direction_start = "left"},
					down_down 	= {is_corner = false, 	direction = "down",		direction_start = "down"},
					right_down 	= {is_corner = true,	direction = "right",	direction_start = "down"},
					right_right = {is_corner = false, 	direction = "right",	direction_start = "right"},
					up_left 	= {is_corner = true,	direction = "up",		direction_start = "left"},
					no_connections = {"up_up", "right_right", "down_down", "left_left"},
				},
				split = {
					down_right_down_left = {is_corner = false, direction = "right_down_left", direction_start = "down"},
					down_right_down = {is_corner = false, direction = "right_down", direction_start = "down"},
					down_down_left = {is_corner = false, direction = "down_left", direction_start = "down"},
					down_right = {is_corner = false, direction = "right", direction_start = "down"},
					down_down = {is_corner = false, direction = "down", direction_start = "down"},
					down_left = {is_corner = false, direction = "left", direction_start = "down"},
					down = {is_corner = false, direction = "none", direction_start = "down"},
					none = {is_corner = false, direction = "none", direction_start = "none"},
				}
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
	if not tile then return end

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
	return M.tilemaps[the_map].tiles.rotation[direction].no_connections
end

function M.set_tiles_building_grid()
	
end

function M.world_to_tile(position, tile_size)
	return vmath.vector3(math.ceil(position.x / tile_size), math.ceil(position.y / tile_size), 0)
end

function M.is_tile_on_grid(cell, building_type)
	local current_tilemap = M.tilemaps[building_type]
	local current_grid = current_tilemap.grid[current_tilemap.layers[1]]
-- 	
-- 	if cell.position.x < current_tilemap.size.x or cell.position.x > #current_grid or
-- 	cell.position.y < current_tilemap.size.y or cell.position.y > #current_grid[1] then
-- 		return false
-- 	end
-- 
-- 	return true

	if not current_grid[cell.x][cell.y] then return false end
	return true
end

return M