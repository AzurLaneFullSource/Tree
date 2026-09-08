local var0_0 = class("ReversePacmanRouteGraph")
local var1_0 = {
	ReversePacmanConst.DIR.UP,
	ReversePacmanConst.DIR.RIGHT,
	ReversePacmanConst.DIR.DOWN,
	ReversePacmanConst.DIR.LEFT
}

local function var2_0(arg0_1, arg1_1)
	return arg0_1 .. "_" .. arg1_1
end

local function var3_0(arg0_2)
	if arg0_2 == ReversePacmanConst.DIR.UP then
		return ReversePacmanConst.DIR.DOWN
	end

	if arg0_2 == ReversePacmanConst.DIR.RIGHT then
		return ReversePacmanConst.DIR.LEFT
	end

	if arg0_2 == ReversePacmanConst.DIR.DOWN then
		return ReversePacmanConst.DIR.UP
	end

	if arg0_2 == ReversePacmanConst.DIR.LEFT then
		return ReversePacmanConst.DIR.RIGHT
	end

	return nil
end

function var0_0.Ctor(arg0_3)
	arg0_3.nodes = {}
	arg0_3.nodeByPos = {}
end

function var0_0.Build(arg0_4, arg1_4)
	arg0_4.nodes = {}
	arg0_4.nodeByPos = {}
	arg0_4.blockedNodeIds = {}
	arg0_4._distCache = {}
	arg0_4._distCacheOrder = {}
	arg0_4.map = arg1_4
	arg0_4.grid = arg1_4.grid or {}
	arg0_4.width = arg1_4.width or 0
	arg0_4.height = arg1_4.height or 0
	arg0_4.cellSize = ReversePacmanConst.GRID_SIZE
	arg0_4.mapSize = {
		x = arg0_4.width * arg0_4.cellSize.x,
		y = arg0_4.height * arg0_4.cellSize.y
	}

	local var0_4 = 0

	for iter0_4 = 1, arg0_4.height do
		for iter1_4 = 1, arg0_4.width do
			local var1_4 = arg0_4.grid[iter0_4] and arg0_4.grid[iter0_4][iter1_4] or ReversePacmanConst.GRID.BLOCK

			if var1_4 ~= ReversePacmanConst.GRID.BLOCK then
				var0_4 = var0_4 + 1

				local var2_4 = {
					degree = 0,
					id = var0_4,
					x = iter1_4,
					y = iter0_4,
					cell = var1_4,
					neighbors = {},
					dirs = {},
					pos = arg0_4:GetLocalPosInMap(iter1_4, iter0_4),
					tag = ReversePacmanConst.TAG.ISOLATED
				}

				arg0_4.nodes[var0_4] = var2_4
				arg0_4.nodeByPos[var2_0(iter1_4, iter0_4)] = var2_4
			end
		end
	end

	for iter2_4, iter3_4 in ipairs(arg0_4.nodes) do
		arg0_4:_RebuildNodeAdjacency(iter3_4)
	end

	return arg0_4
end

function var0_0._RebuildNodeAdjacency(arg0_5, arg1_5)
	arg1_5.neighbors = {}
	arg1_5.dirs = {}

	if not arg0_5.blockedNodeIds[arg1_5.id] then
		for iter0_5, iter1_5 in ipairs(var1_0) do
			local var0_5 = ReversePacmanConst.DIR_VECTORS[iter1_5]
			local var1_5 = arg0_5.nodeByPos[var2_0(arg1_5.x + var0_5.x, arg1_5.y + var0_5.y)]

			if var1_5 and not arg0_5.blockedNodeIds[var1_5.id] then
				arg1_5.neighbors[#arg1_5.neighbors + 1] = var1_5.id
				arg1_5.dirs[var1_5.id] = iter1_5
			end
		end
	end

	arg1_5.degree = #arg1_5.neighbors
	arg1_5.tag = arg0_5:ResolveTag(arg1_5)
end

function var0_0._RefreshTopology(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.nodes) do
		arg0_6:_RebuildNodeAdjacency(iter1_6)
	end
end

function var0_0.ResolveTag(arg0_7, arg1_7)
	local var0_7 = arg1_7.degree or 0

	if var0_7 <= 0 then
		return ReversePacmanConst.TAG.ISOLATED
	end

	if var0_7 == 1 then
		return ReversePacmanConst.TAG.DEAD_END
	end

	if var0_7 == 2 then
		local var1_7 = arg1_7.neighbors[1]
		local var2_7 = arg1_7.neighbors[2]
		local var3_7 = arg1_7.dirs[var1_7]
		local var4_7 = arg1_7.dirs[var2_7]

		if var3_7 and var4_7 and var3_0(var3_7) == var4_7 then
			return ReversePacmanConst.TAG.CORRIDOR
		end

		return ReversePacmanConst.TAG.CORNER
	end

	return ReversePacmanConst.TAG.JUNCTION
end

function var0_0.AddBlockNode(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:GetNodeByPos(arg1_8, arg2_8)

	if var0_8 then
		arg0_8.blockedNodeIds[var0_8.id] = true

		arg0_8:_RefreshTopology()

		arg0_8._distCache = {}
		arg0_8._distCacheOrder = {}
	end
end

function var0_0.RemoveBlockNode(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:GetNodeByPos(arg1_9, arg2_9)

	if var0_9 then
		arg0_9.blockedNodeIds[var0_9.id] = nil

		arg0_9:_RefreshTopology()

		arg0_9._distCache = {}
		arg0_9._distCacheOrder = {}
	end
end

function var0_0.IsBuffBlock(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10:GetNodeByPos(arg1_10, arg2_10)

	return var0_10 ~= nil and arg0_10.blockedNodeIds[var0_10.id] == true
end

function var0_0.IsBuffBlockById(arg0_11, arg1_11)
	return arg1_11 ~= nil and arg0_11.blockedNodeIds[arg1_11] == true
end

function var0_0.GetNodeById(arg0_12, arg1_12)
	return arg0_12.nodes[arg1_12]
end

function var0_0.GetMapSize(arg0_13)
	return arg0_13.mapSize
end

function var0_0.GetCellSize(arg0_14)
	return arg0_14.cellSize
end

function var0_0.GetNodeByPos(arg0_15, arg1_15, arg2_15)
	return arg0_15.nodeByPos[var2_0(arg1_15, arg2_15)]
end

function var0_0.GetNeighbors(arg0_16, arg1_16)
	local var0_16 = arg0_16.nodes[arg1_16]

	if not var0_16 then
		return {}
	end

	return var0_16.neighbors
end

function var0_0.GetDirection(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.nodes[arg1_17]

	if not var0_17 then
		return nil
	end

	return var0_17.dirs[arg2_17]
end

function var0_0.GetDistanceField(arg0_18, arg1_18)
	arg0_18._distCache = arg0_18._distCache or {}
	arg0_18._distCacheOrder = arg0_18._distCacheOrder or {}

	local var0_18 = arg0_18._distCache[arg1_18]

	if var0_18 then
		for iter0_18, iter1_18 in ipairs(arg0_18._distCacheOrder) do
			if iter1_18 == arg1_18 then
				table.remove(arg0_18._distCacheOrder, iter0_18)

				break
			end
		end

		arg0_18._distCacheOrder[#arg0_18._distCacheOrder + 1] = arg1_18

		return var0_18
	end

	local var1_18 = {}

	if not arg0_18.nodes[arg1_18] then
		return var1_18
	end

	var1_18[arg1_18] = 0

	local var2_18 = {
		arg1_18
	}
	local var3_18 = 1

	while var2_18[var3_18] do
		local var4_18 = var2_18[var3_18]

		var3_18 = var3_18 + 1

		local var5_18 = var1_18[var4_18]
		local var6_18 = arg0_18.nodes[var4_18]

		for iter2_18, iter3_18 in ipairs(var6_18.neighbors) do
			if var1_18[iter3_18] == nil then
				var1_18[iter3_18] = var5_18 + 1
				var2_18[#var2_18 + 1] = iter3_18
			end
		end
	end

	arg0_18._distCache[arg1_18] = var1_18
	arg0_18._distCacheOrder[#arg0_18._distCacheOrder + 1] = arg1_18

	if 64 < #arg0_18._distCacheOrder then
		local var7_18 = table.remove(arg0_18._distCacheOrder, 1)

		if var7_18 then
			arg0_18._distCache[var7_18] = nil
		end
	end

	return var1_18
end

function var0_0.GetDistanceById(arg0_19, arg1_19, arg2_19)
	if not arg1_19 or not arg2_19 then
		return nil
	end

	return arg0_19:GetDistanceField(arg2_19)[arg1_19]
end

function var0_0.IsReachable(arg0_20, arg1_20, arg2_20)
	return arg0_20:GetDistanceById(arg1_20, arg2_20) ~= nil
end

function var0_0.FindPath(arg0_21, arg1_21, arg2_21)
	if arg1_21 == arg2_21 then
		return {
			arg1_21
		}
	end

	local var0_21 = arg0_21.nodes[arg1_21]
	local var1_21 = arg0_21.nodes[arg2_21]

	if not var0_21 or not var1_21 then
		return nil
	end

	local var2_21 = {
		arg1_21
	}
	local var3_21 = 1
	local var4_21 = {
		[arg1_21] = true
	}
	local var5_21 = {}

	while var2_21[var3_21] do
		local var6_21 = var2_21[var3_21]

		var3_21 = var3_21 + 1

		local var7_21 = arg0_21.nodes[var6_21]

		for iter0_21, iter1_21 in ipairs(var7_21.neighbors) do
			if not var4_21[iter1_21] then
				var4_21[iter1_21] = true
				var5_21[iter1_21] = var6_21

				if iter1_21 == arg2_21 then
					local var8_21 = 0
					local var9_21 = arg2_21

					while var9_21 do
						var8_21 = var8_21 + 1

						if var9_21 == arg1_21 then
							break
						end

						var9_21 = var5_21[var9_21]
					end

					local var10_21 = {}
					local var11_21 = arg2_21

					for iter2_21 = var8_21, 1, -1 do
						var10_21[iter2_21] = var11_21
						var11_21 = var5_21[var11_21]
					end

					return var10_21
				end

				var2_21[#var2_21 + 1] = iter1_21
			end
		end
	end

	return nil
end

function var0_0.GetManhattanDisById(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.nodes[arg1_22]
	local var1_22 = arg0_22.nodes[arg2_22]

	return arg0_22:GetManhattanDisByNode(var0_22, var1_22)
end

function var0_0.GetManhattanDisByNode(arg0_23, arg1_23, arg2_23)
	return math.abs(arg1_23.x - arg2_23.x) + math.abs(arg1_23.y - arg2_23.y)
end

function var0_0.IsWalkable(arg0_24, arg1_24, arg2_24)
	return arg0_24:GetNodeByPos(arg1_24, arg2_24) ~= nil
end

function var0_0.GetLocalPosInMap(arg0_25, arg1_25, arg2_25)
	local var0_25 = (arg1_25 - 1) * arg0_25.cellSize.x - arg0_25.mapSize.x / 2 + arg0_25.cellSize.x / 2
	local var1_25 = arg0_25.mapSize.y / 2 - (arg2_25 - 1) * arg0_25.cellSize.y - arg0_25.cellSize.y / 2

	return {
		x = var0_25,
		y = var1_25
	}
end

function var0_0.GetNodeIdByLocalPos(arg0_26, arg1_26)
	local var0_26 = math.floor((arg1_26.x + arg0_26.mapSize.x / 2) / arg0_26.cellSize.x) + 1
	local var1_26 = math.floor((arg0_26.mapSize.y / 2 - arg1_26.y) / arg0_26.cellSize.y) + 1

	if var0_26 < 1 or var0_26 > arg0_26.width or var1_26 < 1 or var1_26 > arg0_26.height then
		return nil
	end

	local var2_26 = arg0_26.nodeByPos[var2_0(var0_26, var1_26)]

	return var2_26 and var2_26.id or nil
end

function var0_0.GetCellByLocalPos(arg0_27, arg1_27)
	local var0_27 = math.floor((arg1_27.x + arg0_27.mapSize.x / 2) / arg0_27.cellSize.x) + 1
	local var1_27 = math.floor((arg0_27.mapSize.y / 2 - arg1_27.y) / arg0_27.cellSize.y) + 1

	if var0_27 < 1 or var0_27 > arg0_27.width or var1_27 < 1 or var1_27 > arg0_27.height then
		return nil
	end

	return {
		x = var0_27,
		y = var1_27
	}
end

return var0_0
