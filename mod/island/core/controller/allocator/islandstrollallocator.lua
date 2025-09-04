local var0_0 = class("IslandStrollAllocator")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.mapId = arg1_1.mapId

	local var0_1 = pg.island_waypoint.get_id_list_by_mapId[arg0_1.mapId] or {}

	arg0_1.paths = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		local var1_1 = pg.island_waypoint[iter1_1]

		if not arg0_1.paths[var1_1.group] then
			arg0_1.paths[var1_1.group] = {}
		end

		table.insert(arg0_1.paths[var1_1.group], iter1_1)
	end

	arg0_1.cache = {}
end

function var0_0.Allocator(arg0_2, arg1_2)
	assert(not table.contains(arg0_2.cache, arg1_2), "path has been used")

	if not arg0_2.paths[arg1_2] then
		arg1_2 = arg0_2:GetRandomPathId()
	end

	assert(arg0_2.paths[arg1_2], "path not found" .. arg1_2)
	table.insert(arg0_2.cache, arg1_2)

	local var0_2 = arg0_2:GetWaypoints(arg1_2)
	local var1_2 = pg.island_waypoint[var0_2[1]].position

	return arg1_2, var1_2
end

function var0_0.GetWaypoints(arg0_3, arg1_3)
	local var0_3 = arg0_3.paths[arg1_3] or {}

	table.sort(var0_3, function(arg0_4, arg1_4)
		return arg0_4 < arg1_4
	end)

	return var0_3
end

function var0_0.GetRandomPathId(arg0_5)
	local var0_5 = {}

	for iter0_5, iter1_5 in pairs(arg0_5.paths) do
		if not table.contains(arg0_5.cache, iter0_5) then
			table.insert(var0_5, iter0_5)
		end
	end

	if #var0_5 <= 0 then
		return -1
	end

	return var0_5[math.Random(1, #var0_5)]
end

function var0_0.Dispose(arg0_6)
	return
end

return var0_0
