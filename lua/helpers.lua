-- helpers.lua


function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end

function distanceSquared( x1, y1, x2, y2 )
	return (x2-x1)^2 + (y2-y1)^2
end

function lineDistance( x, y, dx, dy, u, v )
	local wx, wy = u-x, v-y
	return math.sqrt((wx^2 + wy^2)-(((dx*wx+dy*wy)^2)/(dx^2+dy^2))) --MATHAMAGICAL
end

--- This checks if the current position is too close to a list of existing positions, returning true if they are outside the minimum distance from all existing positions. Optional param dense_core allows you to create a center point from which positions cannot be near to
---@param pos position
---@param existing_positions table
---@param min_distance number
---@param dense_core? boolean
function is_too_close(pos, existing_positions, min_distance, dense_core)
	local dense_core = dense_core or false
	if #existing_positions == 0 then return false end
	
	if dense_core then
		local distance_from_core = distance(pos.o.x, pos.o.y, 0, 0)
		if distance_from_core < min_distance * 5 then return true end
	end
	

	for _, other_pos in ipairs(existing_positions) do
		local dist = distance(pos.o.x, pos.o.y, other_pos.o.x, other_pos.o.y)
		if dist < min_distance then
			return true
		end
	end
	return false
end

--- Takes a list 'b' and adds it to the end of a list 'a' then returns the combined list
---@param a table
---@param b table
function appendList(a, b)
  local ab = {}
  table.move(a, 1, #a, 1, ab)
  table.move(b, 1, #b, #ab + 1, ab)
  return ab
end

function shallow_copy(tbl)
    local copy = {}
    for k, v in pairs(tbl) do
        copy[k] = v
    end
    return copy
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--- Takes a table, t, and shuffles the entries' order around at random, returning the new shuffled table
---@param t table
function shuffle(t)
  local tbl = {}
  for i = 1, #t do
    tbl[i] = t[i]
  end
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function list_files_in_directory(dir)
	local iter, err_msg = lsdir(dir)
	local files = {}
	if iter then
		for path, attr in iter do
			-- print(path, attr)
			table.insert(files, path)
		end

		return files
	else
		print(err_msg)
	end

end

function RGBtoHex(rgb)
	-- math.clamp(rgb[1], 0, 255)
	-- math.clamp(rgb[2], 0, 255)
	-- math.clamp(rgb[3], 0, 255)
    return string.format("0xFF%02X%02X%02X", rgb[1], rgb[2], rgb[3])
end

function add_to_weighted_list(list, name, weight)
	local n = name
	local w = weight
	local t = {["name"] = n, ["weight"] = w}

    -- Check if the name is already there
    for _, list_name in ipairs(list) do
        if list_name == n then
            -- Add to the existing citizen's population
            list_name.weight = list_name.weight + weight
			if list_name.weight < 0 then table.remove(list, _) end
            return
        end
    end

	table.insert(list, t)
end

function weighted_random(items)
    local total_weight = 0
    for _, item in ipairs(items) do
        total_weight = total_weight + item.weight
    end

    local roll = math.random() * total_weight
    local cumulative = 0

    for _, item in ipairs(items) do
        cumulative = cumulative + item.weight
        if roll <= cumulative then
            return item.name
        end
    end
end

function sleep (a) 
    local sec = tonumber(os.clock() + a); 
    while (os.clock() < sec) do 
    end 
end

function table_length(t)
    local count = 0
    for _, _ in pairs(t) do
        count = count + 1
    end
    return count
end

function get_party_position(party_id)
    game.party_get_position(1, party_id)
    return game.preg[1]
end

function write_to_file(data, filename)
    local file = io.open(filename, "w")
    assert(file, "Could not open file for saving.")
    file:write(data)
    file:close()
end

function print_table_recursive(table, indent)
    if not indent then indent = 0 end -- Default indent to 0 if not provided

    local indent_string = string.rep(" ", indent) -- Create an indent string

    WriteLogLine(indent_string .. "{", true) -- Start with an opening brace and indent

    for k, v in pairs(table) do
        WriteLogLine(indent_string .. "  " .. k .. " = ", true) -- Indent key and value

        if type(v) == "table" then
            print_table_recursive(v, indent + 2) -- Recursive call for sub-tables
        else
            WriteLogLine(indent_string .. "  " .. tostring(v), true) -- Print non-table values
        end
    end

    WriteLogLine(indent_string .. "}", true) -- End with a closing brace and indent
end