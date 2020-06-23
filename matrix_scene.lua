local SIZE_X = 60
local SIZE_Y = 50
local SIZE_C = 15

local mid_clicks = 0

function mscene_load()
	if matrix == nil then
		matrix = mscene_new_matrix(SIZE_X, SIZE_Y)
	end
end

function mscene_new_matrix(maxx, maxy)
	local m = {}
	for y = 1, maxy do
		m[y] = {}
		for x = 1, maxx do
			m[y][x] = false
		end
	end
	return m
end

function mscene_draw()
	for y = 1, SIZE_Y do
		for x = 1, SIZE_X do
			local X = math.ceil((x - 1) * SIZE_C)
			local Y = math.ceil((y - 1) * SIZE_C)
			if matrix[y][x] then
				love.graphics.rectangle('fill', X, Y, SIZE_C - 1, SIZE_C - 1)
			end
		end
	end
	-- Draw mouse cursor
	local m = love.mouse
	mscene_mcursor(m:getX(), m:getY())
end

function mscene_mcursor(x, y)
	local X = (math.ceil(x / SIZE_C)) - 1
	local Y = (math.ceil(y / SIZE_C)) - 1
	local S = SIZE_C / 2.5
	local _X = (X * SIZE_C) + S
	local _Y = (Y * SIZE_C) + S
	love.graphics.rectangle('fill', _X, _Y, S, S)
end

function mscene_mpressed(x, y, button, istouch, presses)
	if button == 1 then
		local X = math.ceil(x / SIZE_C)
		local Y = math.ceil(y / SIZE_C)
		if matrix[Y][X] then
			matrix[Y][X] = false
		else
			matrix[Y][X] = true
		end
	elseif button == 2 then
		mscene_life()
	elseif button == 3 then
		mscene_clear()
	end
	-- Mid clicks counter
	if button == 3 then
		mid_clicks = mid_clicks + 1
		if mid_clicks == 3 then
			mscene_random()
			mid_clicks = 0
		end
	else
		mid_clicks = 0
	end
end

function mscene_life()
	local ops = {}

	for y = 1, SIZE_Y do
		for x = 1, SIZE_X do
			local n    = mscene_neighbors_count(x, y)
			local life = mscene_matrix_get(x, y)
			if life then
				if (n == 3 or n == 2) ~= true then
					ops[#ops + 1] = {c=false, x=x, y=y}
				end
			else
				if n == 3 then
					ops[#ops + 1] = {c=true, x=x, y=y}
				end
			end
		end
	end

	for k, v in ipairs(ops) do
		matrix[v.y][v.x] = v.c
	end
end

function mscene_neighbors_count(x, y)
	local cnt = 0
	if mscene_matrix_get(x-1, y-1) then cnt = cnt + 1 end
	if mscene_matrix_get(x, y-1)   then cnt = cnt + 1 end
	if mscene_matrix_get(x+1, y-1) then cnt = cnt + 1 end
	if mscene_matrix_get(x-1, y)   then cnt = cnt + 1 end
	if mscene_matrix_get(x+1, y)   then cnt = cnt + 1 end
	if mscene_matrix_get(x-1, y+1) then cnt = cnt + 1 end
	if mscene_matrix_get(x, y+1)   then cnt = cnt + 1 end
	if mscene_matrix_get(x+1, y+1) then cnt = cnt + 1 end
	return cnt
end

function mscene_matrix_get(x, y)
	if x > SIZE_X then return false end
	if x < 1      then return false end
	if y > SIZE_Y then return false end
	if y < 1      then return false end
	return matrix[y][x]
end

function mscene_clear()
	for y = 1, SIZE_Y do
		for x = 1, SIZE_X do
			matrix[y][x] = false
		end
	end
end

function mscene_random()
	for y = 1, SIZE_Y do
		for x = 1, SIZE_X do
			local r = love.math.random(2)
			local b = false
			if r == 2 then b = true end
			matrix[y][x] = b
		end
	end
end