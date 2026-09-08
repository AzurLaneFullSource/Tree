local var0_0 = class("ReversePacmanMapControl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1._tpls = arg0_1._tf:Find("tpls")
	arg0_1.container = arg0_1._tf:Find("map/grids")
	arg0_1.buffContainer = arg0_1._tf:Find("map/buffs")
	arg0_1.routeGraph = ReversePacmanRouteGraph.New()
end

function var0_0.SetUp(arg0_2, arg1_2)
	local var0_2 = pg.activity_chasing_level[arg1_2].map_json
	local var1_2 = require("view.activity.ReversePacman.Maps." .. var0_2)

	arg0_2.mapId = var1_2.id
	arg0_2.duration = var1_2.duration
	arg0_2.skillSlotCount = var1_2.skillSlotCount
	arg0_2.ratingThresholds = var1_2.ratingThresholds
	arg0_2.width = var1_2.width
	arg0_2.height = var1_2.height
	arg0_2.grids = var1_2.grid
	arg0_2.tags = var1_2.tags
	arg0_2.spawnPoints = var1_2.spawnPoints
	arg0_2.deployPoints = var1_2.deployPoints
	arg0_2.canPickBuffs = {}

	arg0_2.routeGraph:Build(var1_2)
	arg0_2:BuildMapUI()
	arg0_2:AddListener()
end

function var0_0.BuildMapUI(arg0_3, arg1_3)
	removeAllChildren(arg0_3.container)

	arg0_3.gridViews = {}

	setSizeDelta(arg0_3.container, arg0_3.routeGraph:GetMapSize())

	for iter0_3 = 1, arg0_3.height do
		for iter1_3 = 1, arg0_3.width do
			local var0_3 = arg0_3:IsWalkable(iter1_3, iter0_3) and arg0_3._tpls:Find("grid_road") or arg0_3._tpls:Find("grid_block")
			local var1_3 = cloneTplTo(var0_3, arg0_3.container, iter1_3 .. "_" .. iter0_3)

			arg0_3.gridViews[#arg0_3.gridViews + 1] = var1_3

			setLocalPosition(var1_3, arg0_3:GetLocalPosInMap(iter1_3, iter0_3))
		end
	end
end

function var0_0.AddListener(arg0_4)
	arg0_4.binder:bind(ReversePacmanConst.EVENT.CAST, function(arg0_5, arg1_5)
		arg0_4:AddBuffGrid(arg1_5.buffId, arg1_5.cell)
	end)
	arg0_4.binder:bind(ReversePacmanConst.EVENT.PICK, function(arg0_6, arg1_6)
		arg0_4:RemoveBuffGrid(arg1_6.buff)
	end)
end

function var0_0.AddBuffGrid(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7._tpls:Find("buff_" .. arg1_7)
	local var1_7 = cloneTplTo(var0_7, arg0_7.buffContainer, arg2_7.x .. "_" .. arg2_7.y)
	local var2_7 = arg0_7:GetLocalPosInMap(arg2_7.x, arg2_7.y)

	setLocalPosition(var1_7, var2_7)

	if arg1_7 == ReversePacmanConst.BUFF.BLOCK then
		arg0_7.routeGraph:AddBlockNode(arg2_7.x, arg2_7.y)
		arg0_7.binder:emit(ReversePacmanConst.EVENT.GRAPH_CHANGED, {
			cell = arg2_7
		})
	else
		table.insert(arg0_7.canPickBuffs, {
			id = arg1_7,
			cell = arg2_7,
			x = var2_7.x,
			y = var2_7.y,
			tf = var1_7
		})
	end
end

function var0_0.RemoveBuffGrid(arg0_8, arg1_8)
	setActive(arg1_8.tf, false)
	table.removebyvalue(arg0_8.canPickBuffs, arg1_8)
end

function var0_0.GetCanPickBuffs(arg0_9)
	return arg0_9.canPickBuffs
end

function var0_0.GetTag(arg0_10, arg1_10, arg2_10)
	return arg0_10.tags[arg2_10] and arg0_10.tags[arg2_10][arg1_10] or ""
end

function var0_0.IsWalkable(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.grids[arg2_11] and arg0_11.grids[arg2_11][arg1_11] or nil

	return var0_11 ~= nil and var0_11 ~= ReversePacmanConst.GRID.BLOCK and not arg0_11.routeGraph:IsBuffBlock(arg1_11, arg2_11)
end

function var0_0.GetDuration(arg0_12)
	return arg0_12.duration
end

function var0_0.GetSpawnPoints(arg0_13)
	return arg0_13.spawnPoints
end

function var0_0.GetDeployPoints(arg0_14)
	return arg0_14.deployPoints
end

function var0_0.GetRatingThresholds(arg0_15)
	return arg0_15.ratingThresholds
end

function var0_0.GetRouteGraph(arg0_16)
	return arg0_16.routeGraph
end

function var0_0.GetLocalPosInMap(arg0_17, arg1_17, arg2_17)
	return arg0_17.routeGraph:GetLocalPosInMap(arg1_17, arg2_17)
end

function var0_0.GetNodeIdByPos(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.routeGraph:GetNodeByPos(arg1_18, arg2_18)

	return var0_18 and var0_18.id or nil
end

function var0_0.GetNodeIdByLocalPos(arg0_19, arg1_19)
	return arg0_19.routeGraph:GetNodeIdByLocalPos(arg1_19)
end

function var0_0.GetCellByLocalPos(arg0_20, arg1_20)
	return arg0_20.routeGraph:GetCellByLocalPos(arg1_20)
end

function var0_0.GetCenterCell(arg0_21)
	return {
		x = math.ceil(arg0_21.width / 2),
		y = math.ceil(arg0_21.height / 2)
	}
end

function var0_0.Update(arg0_22, arg1_22)
	return
end

function var0_0.Dispose(arg0_23)
	return
end

return var0_0
