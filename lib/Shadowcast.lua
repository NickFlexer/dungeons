-- Lua non recursive implementation of shadowcasting techinque for fast 
-- calculation of field of view. 
-- Original recursive algorithm by Björn Bergström [bjorn.bergstrom@roguelikedevelopment.org] 
-- description at http://www.roguebasin.com/index.php?title=FOV\_using\_recursive\_shadowcasting. 

-- coded by Ilya Kolbin ( iskolbin@gmail.com )

local insert, remove, pairs, ipairs, abs, max = table.insert, table.remove, pairs, ipairs, math.abs, math.max

local Shadowcast = {

	DIRECTIONS_8 = {
		{ 0,-1,-1, 0},
		{-1, 0, 0,-1},
		{ 0, 1,-1, 0},
		{ 1, 0, 0,-1},
		{ 0,-1, 1, 0},
		{-1, 0, 0, 1},
		{ 0, 1, 1, 0},
		{ 1, 0, 0, 1},
	},

	MANHATTAN = function( dx, dy ) return abs( dx ) + abs( dy ) end,
	EUCLIDEAN = function( dx, dy ) return (dx*dx + dy*dy)^0.5 end,
	CHEBYSHEV = function( dx, dy ) return max( abs( dx ), abs( dy )) end,
}

local ShadowcastMt = {
	__index = Shadowcast
}

--             cast( self._light, self._absorption, source[1], source[2], source[3], self._topology, self._directions )
local function cast( light, absorption, x0, y0, radius, topology, directions, negative, minx, miny, maxx, maxy )
	local minx, miny = minx or 1, miny or 1
	local maxx, maxy = maxx or #absorption, maxy or #absorption[1]
	local decay = 1/radius
	local stack = {}

	if not light[x0] then light[x0] = {} end
	if not light[x0][y0] then light[x0][y0] = 0.0 end
	
	light[x0][y0] = light[x0][y0] + (negative and -radius or radius) -- light the starting cell

	for _, xxyy in pairs( directions ) do
		local xx, xy, yx, yy = xxyy[1], xxyy[2], xxyy[3], xxyy[4]
		local n = 3
		stack[n-2], stack[n-1], stack[n] = 1, 1.0, 0.0
		while n > 0 do
			local row, start, finish = stack[n-2], stack[n-1], stack[n]
			n = n - 3

			if start >= finish then
				local newstart = 0.0
				local blocked = false;
				for dy = -row, -radius, -1 do
					if blocked then break end

					local inv_dy_plus05  = 1 / (dy + 0.5)
					local inv_dy_minus05 = 1 / (dy - 0.5)
					local leftslope  = (dy - 1.5) * inv_dy_plus05  --(dx - 0.5) / (dy + 0.5)
					local rightslope = (dy - 0.5) * inv_dy_minus05 --(dx + 0.5) / (dy - 0.5)
					local xydy, yydy = xy * dy, yy * dy
					for dx = dy, 0 do
						local x = x0 + dx * xx + xydy
						local y = y0 + yx * dx + yydy
						leftslope  = leftslope  + inv_dy_plus05
						rightslope = rightslope + inv_dy_minus05

						if ( not (x >= minx and y >= miny and x <= maxx and y <= maxy) or start < rightslope ) then

						elseif finish > leftslope then
							break
						else
							-- check if it's within the lightable area and light if needed
							local radius_ = topology( dx, dy )
							if radius_ <= radius then
								local bright = 1.0 - decay * radius_
								if dy == 0 or dx == 0 or dy == dx then
									bright = 0.5*bright
								end
								if negative then
									bright = -bright
								end

								light[x] = light[x] or {}
								light[x][y] = (light[x][y] or 0) + bright
							end

							if blocked then -- previous cell was a blocking one
								if absorption[x][y] >= 1 then -- hit a wall
									newstart = rightslope
								else
									blocked = false
									start = newstart
								end

							elseif absorption[x][y] >= 1 and -dy < radius then -- hit a wall within sight line
								blocked = true
								n = n + 3
								stack[n-2], stack[n-1], stack[n] = -dy + 1, start, leftslope
								newstart = rightslope
							end
						end
					end
				end
			end
		end
	end

	return light
end

Shadowcast.cast = cast

function Shadowcast.create(size_x, size_y, cell_blocked, lighting)
	return setmetatable({
		start_x = 1,
		start_y = 1,
		size_x = size_x,
		size_y = size_y,
		cell_blocked = cell_blocked,
		lighting = lighting,
		topology = function( dx, dy ) return (dx*dx + dy*dy)^0.5 end
	}, ShadowcastMt)
end

function Shadowcast:solve(x0, y0, radius)
	local _light = {}
	local data_fild = {}

	for x = 1, self.size_x do
		data_fild[x] = {}
		for y = 1, self.size_y do
			if self.cell_blocked(x, y) then
				data_fild[x][y] = 1
			else
				data_fild[x][y] = 0
			end
		end
	end

	cast(_light, data_fild, x0, y0, radius, self.topology, self.DIRECTIONS_8)

	for x = 1, self.size_x do
        for y = 1, self.size_y do
			if _light[x] and _light[x][y] and _light[x][y] > 0 then
				self.lighting(x, y)
			end
		end
	end
end

return setmetatable( Shadowcast, { __call = function( _,... )
	return Shadowcast.create( ... )
end } )
