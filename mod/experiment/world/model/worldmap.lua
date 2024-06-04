local var0 = class("WorldMap", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	cells = "table",
	findex = "number",
	gid = "number",
	phaseDisplayList = "table",
	salvageAutoResult = "boolean",
	isPressing = "boolean",
	id = "number",
	clearFlag = "boolean",
	valid = "boolean",
	visionFlag = "boolean",
	isLoss = "boolean",
	bottom = "number",
	centerCellFOV = "table",
	typeAttachments = "table",
	isCost = "boolean",
	theme = "table",
	fleets = "table",
	left = "number",
	factionBuffs = "table",
	ports = "table",
	top = "number",
	active = "boolean",
	right = "number"
}
var0.Listeners = {
	onUpdateAttachmentExist = "OnUpdateAttachmentExist"
}
var0.EventUpdateActive = "WorldMap.EventUpdateActive"
var0.EventUpdateFIndex = "WorldMap.EventUpdateFIndex"
var0.EventUpdateMapBuff = "WorldMap.EventUpdateMapBuff"
var0.EventUpdateFleetFOV = "WorldMap.EventUpdateFleetFOV"
var0.EventUpdateMoveSpeed = "WorldMap.EventUpdateMoveSpeed"

function var0.DebugPrint(arg0)
	return string.format("地图 [%s] [id: %s] [gid: %s] [危险度: %s] [是否压制：%s]", arg0.config.name, arg0.id, tostring(arg0.gid), arg0:GetDanger(), arg0.isPressing)
end

function var0.Build(arg0)
	arg0.cells = {}
	arg0.ports = {}
	arg0.phaseDisplayList = {}
end

function var0.Dispose(arg0)
	arg0:UnbindFleets()
	arg0:DisposeTheme()
	arg0:DisposeGrid()
	arg0:DisposePort()
	arg0:Clear()
end

function var0.Setup(arg0, arg1)
	arg0.id = arg1

	assert(pg.world_chapter_random[arg0.id], "world_chapter_random not exist: " .. tostring(arg0.id))

	arg0.config = setmetatable({}, {
		__index = function(arg0, arg1)
			return arg0:GetConfig(arg1)
		end
	})
end

function var0.GetName(arg0, arg1)
	local var0 = arg1 and World.ReplacementMapType(arg1, arg0)

	if var0 == "sairen_chapter" or var0 == "teasure_chapter" then
		return arg1:GetBaseMap():GetName() .. "-" .. arg0.config.name
	else
		return arg0.config.name
	end
end

function var0.GetConfig(arg0, arg1)
	local var0 = pg.world_chapter_random[arg0.id]
	local var1 = pg.world_chapter_template[arg0.gid]
	local var2 = var0 and var0[arg1] or var1 and var1[arg1] or nil

	assert(var2 ~= nil, "can not find " .. arg1 .. " in WorldMap " .. arg0.id)

	return var2
end

var0.FactionSelf = 0
var0.FactionEnemy = 1

function var0.UpdateGridId(arg0, arg1)
	arg0.gid = arg1

	assert(pg.world_chapter_template[arg0.gid], "world_chapter_template not exist: " .. tostring(arg0.gid))
	arg0:DisposeTheme()
	arg0:DisposeGrid()
	arg0:DisposePort()

	arg0.factionBuffs = {
		[var0.FactionSelf] = {},
		[var0.FactionEnemy] = {}
	}

	for iter0, iter1 in ipairs(arg0.config.world_chapter_buff) do
		local var0, var1, var2 = unpack(iter1)

		arg0:AddBuff(var0, var1, var2)
	end

	arg0:SetupTheme()
	arg0:SetupGrid()
	arg0:SetupPort()
end

function var0.SetupTheme(arg0)
	local var0 = WPool:Get(WorldMapTheme)

	var0:Setup(arg0.config.theme)

	arg0.theme = var0
end

function var0.DisposeTheme(arg0)
	if arg0.theme then
		WPool:Return(arg0.theme)

		arg0.theme = nil
	end
end

function var0.SetupGrid(arg0, arg1)
	_.each(arg0.config.grids, function(arg0)
		local var0 = WPool:Get(WorldMapCell)

		var0:Setup(arg0)

		if arg0:AlwaysInFOV() then
			var0.infov = bit.bor(var0.infov, WorldConst.FOVMapSight)
		end

		local var1 = WorldMapCell.GetName(var0.row, var0.column)

		arg0.cells[var1] = var0

		if not arg1 then
			var0:AddListener(WorldMapCell.EventAddAttachment, arg0.onUpdateAttachmentExist)
			var0:AddListener(WorldMapCell.EventRemoveAttachment, arg0.onUpdateAttachmentExist)
		end
	end)

	arg0.left, arg0.right = 999999, 0
	arg0.top, arg0.bottom = 999999, 0

	for iter0 = 0, WorldConst.MaxRow do
		local var0
		local var1

		for iter1 = 0, WorldConst.MaxColumn do
			local var2 = arg0:GetCell(iter0, iter1)

			if var2 then
				if not var0 then
					var0 = iter1
					var2.dir = bit.bor(var2.dir, bit.lshift(1, WorldConst.DirLeft))
				end

				var1 = iter1
			end
		end

		if var1 then
			local var3 = arg0:GetCell(iter0, var1)

			var3.dir = bit.bor(var3.dir, bit.lshift(1, WorldConst.DirRight))
		end

		if var0 then
			arg0.left = math.min(arg0.left, var0)
		end

		if var1 then
			arg0.right = math.max(arg0.right, var1)
		end
	end

	for iter2 = 0, WorldConst.MaxColumn do
		local var4
		local var5

		for iter3 = 0, WorldConst.MaxRow do
			local var6 = arg0:GetCell(iter3, iter2)

			if var6 then
				if not var4 then
					var4 = iter3
					var6.dir = bit.bor(var6.dir, bit.lshift(1, WorldConst.DirUp))
				end

				var5 = iter3
			end
		end

		if var5 then
			local var7 = arg0:GetCell(var5, iter2)

			var7.dir = bit.bor(var7.dir, bit.lshift(1, WorldConst.DirDown))
		end

		if var4 then
			arg0.top = math.min(arg0.top, var4)
		end

		if var5 then
			arg0.bottom = math.max(arg0.bottom, var5)
		end
	end
end

function var0.DisposeGrid(arg0, arg1)
	if not arg1 then
		for iter0, iter1 in pairs(arg0.cells) do
			iter1:RemoveListener(WorldMapCell.EventAddAttachment, arg0.onUpdateAttachmentExist)
			iter1:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0.onUpdateAttachmentExist)
		end
	end

	WPool:ReturnMap(arg0.cells)

	arg0.cells = {}
	arg0.typeAttachments = {}
	arg0.left = nil
	arg0.top = nil
	arg0.right = nil
	arg0.bottom = nil
end

function var0.SetupPort(arg0)
	if #arg0.config.port_id > 0 then
		local var0 = WPool:Get(WorldMapPort)

		var0:Setup(arg0.config.port_id[1])

		local var1, var2 = unpack(arg0.config.port_id[2])

		for iter0 = var1 - 1, var1 + 1 do
			for iter1 = var2 - 1, var2 + 1 do
				if iter0 ~= var1 or iter1 ~= var2 then
					local var3 = arg0:GetCell(iter0, iter1)

					if var3 then
						var3:AddAttachment(WorldMapAttachment.MakeFakePort(iter0, iter1, var0.id))
					end
				end
			end
		end

		table.insert(arg0.ports, var0)
	end
end

function var0.DisposePort(arg0)
	WPool:ReturnArray(arg0.ports)

	arg0.ports = {}
end

function var0.IsValid(arg0)
	return arg0.valid
end

function var0.SetValid(arg0, arg1)
	arg0.valid = arg1

	if arg1 and arg0.fleets then
		for iter0, iter1 in ipairs(arg0:GetNormalFleets()) do
			arg0.centerCellFOV = {
				row = iter1.row,
				column = iter1.column
			}

			if arg0:GetFleetTerrain(iter1) ~= WorldMapCell.TerrainFog then
				WorldConst.RangeCheck(iter1, arg0:GetFOVRange(iter1), function(arg0, arg1)
					local var0 = arg0.cells[WorldMapCell.GetName(arg0, arg1)]

					if var0 then
						var0:ChangeInLight(true)
					end
				end)
			elseif arg0.findex == iter0 then
				local var0 = {}

				WorldConst.RangeCheck(iter1, arg0:GetFOVRange(iter1), function(arg0, arg1)
					local var0 = WorldMapCell.GetName(arg0, arg1)

					if arg0.cells[var0] then
						var0[var0] = true
					end
				end)

				local var1 = arg0:IsFleetTerrainSairenFog(iter1)

				for iter2, iter3 in pairs(arg0.cells) do
					iter3:UpdateFog(true, var0[iter2], var1)
				end
			end
		end
	end
end

function var0.IsMapOpen(arg0)
	return nowWorld():GetProgress() >= arg0:GetOpenProgress()
end

function var0.GetOpenProgress(arg0)
	local var0 = nowWorld():GetRealm()

	return var0 > 0 and arg0.config.open_stage[var0] or 9999
end

function var0.RemoveAllCellDiscovered(arg0)
	for iter0, iter1 in pairs(arg0.cells) do
		iter1:UpdateDiscovered(false)
	end
end

function var0.GetDanger(arg0)
	return arg0.config.hazard_level
end

function var0.BindFleets(arg0, arg1)
	arg0.fleets = arg1
end

function var0.UnbindFleets(arg0)
	arg0.fleets = nil
end

function var0.GetFleets(arg0)
	return _.rest(arg0.fleets, 1)
end

function var0.GetFleet(arg0, arg1)
	return arg1 and _.detect(arg0.fleets, function(arg0)
		return arg0.id == arg1
	end) or arg0.fleets[arg0.findex]
end

function var0.GetNormalFleets(arg0)
	return _.filter(arg0.fleets, function(arg0)
		return arg0:GetFleetType() == FleetType.Normal
	end)
end

function var0.GetSubmarineFleet(arg0)
	return _.detect(arg0.fleets, function(arg0)
		return arg0:GetFleetType() == FleetType.Submarine
	end)
end

function var0.FindFleet(arg0, arg1, arg2)
	return _.detect(arg0.fleets, function(arg0)
		return arg0.row == arg1 and arg0.column == arg2
	end)
end

function var0.CheckFleetMovable(arg0, arg1)
	return arg0:GetCell(arg1.row, arg1.column):CanLeave()
end

function var0.GetFleetTerrain(arg0, arg1)
	return arg0:GetCell(arg1.row, arg1.column):GetTerrain()
end

function var0.IsFleetTerrainSairenFog(arg0, arg1)
	return arg0:GetCell(arg1.row, arg1.column):IsTerrainSairenFog()
end

function var0.RemoveFleetsCarries(arg0, arg1)
	arg1 = arg1 or arg0.fleets

	_.each(arg1, function(arg0)
		arg0:RemoveAllCarries()
	end)
end

function var0.UpdateFleetIndex(arg0, arg1)
	if arg0.findex ~= arg1 then
		arg0:CheckSelectFleetUpdateFog(function()
			arg0.findex = arg1
		end)
		arg0:DispatchEvent(var0.EventUpdateFIndex)
	end
end

function var0.UpdateActive(arg0, arg1)
	local var0 = nowWorld():GetAtlas()

	if arg0.active ~= arg1 then
		arg0.active = arg1

		if arg1 then
			arg0:SetValid(false)
			var0:SetActiveMap(arg0)

			arg0.isCost = true

			var0:UpdateCostMap(arg0.id, arg0.isCost)
		elseif arg0:NeedClear() then
			arg0:RemoveAllCellDiscovered()

			arg0.clearFlag = false
			arg0.isCost = false

			var0:UpdateCostMap(arg0.id, arg0.isCost)
		end

		arg0:DispatchEvent(var0.EventUpdateActive)
	end
end

function var0.InPort(arg0, arg1, arg2)
	local var0 = arg0:GetPort()

	if not var0 or arg2 and var0.config.port_camp ~= arg2 then
		return false
	end

	local var1 = arg0:GetFleet(arg1)

	if var1:GetFleetType() == FleetType.Submarine then
		return var0.id
	else
		local var2 = arg0:GetCell(var1.row, var1.column):GetAliveAttachment()

		if var2 and var2.type == WorldMapAttachment.TypePort then
			return var2.id
		end
	end

	return false
end

function var0.canExit(arg0)
	return arg0.gid and pg.world_chapter_template_reset[arg0.gid] ~= nil
end

function var0.CheckAttachmentTransport(arg0)
	local var0 = WorldConst.GetTransportBlockEvent()
	local var1 = arg0:FindAttachments(WorldMapAttachment.TypeEvent)

	for iter0, iter1 in ipairs(var1) do
		if iter1:IsAlive() and var0[iter1.id] then
			return "block"
		end
	end

	local var2 = WorldConst.GetTransportStoryEvent()

	for iter2, iter3 in ipairs(var1) do
		if iter3:IsAlive() and var2[iter3.id] then
			return "story"
		end
	end
end

function var0.GetPort(arg0, arg1)
	return arg1 and _.detect(arg0.ports, function(arg0)
		return arg0.id == arg1
	end) or arg0.ports[1]
end

function var0.GetCell(arg0, arg1, arg2)
	local var0 = WorldMapCell.GetName(arg1, arg2)

	return arg0.cells[var0]
end

function var0.CalcTransportPos(arg0, arg1, arg2)
	local var0 = calcPositionAngle(arg1.config.area_pos[1] - arg2.config.area_pos[1], arg1.config.area_pos[2] - arg2.config.area_pos[2])
	local var1 = false

	if not arg0.gid then
		var1 = true
		arg0.gid = arg0.config.template_id[1][1]

		arg0:SetupGrid(var1)
	end

	local var2 = {
		row = (arg0.top + arg0.bottom) / 2,
		column = (arg0.left + arg0.right) / 2
	}
	local var3
	local var4 = 4294967295
	local var5

	for iter0 = arg0.left + 1, arg0.right - 1 do
		local var6 = math.abs(calcPositionAngle(iter0 - var2.column, var2.row - arg0.top) - var0)

		if var6 < var4 then
			var3 = {
				row = arg0.top,
				column = iter0
			}
			var4 = var6
		end

		local var7 = math.abs(calcPositionAngle(iter0 - var2.column, var2.row - arg0.bottom) - var0)

		if var7 < var4 then
			var3 = {
				row = arg0.bottom,
				column = iter0
			}
			var4 = var7
		end
	end

	for iter1 = arg0.top + 1, arg0.bottom - 1 do
		local var8 = math.abs(calcPositionAngle(arg0.left - var2.column, var2.row - iter1) - var0)

		if var8 < var4 then
			var3 = {
				row = iter1,
				column = arg0.left
			}
			var4 = var8
		end

		local var9 = math.abs(calcPositionAngle(arg0.right - var2.column, var2.row - iter1) - var0)

		if var9 < var4 then
			var3 = {
				row = iter1,
				column = arg0.right
			}
			var4 = var9
		end
	end

	if var1 then
		arg0:DisposeGrid(var1)

		arg0.gid = nil
	end

	return var3
end

function var0.AnyFleetInEdge(arg0)
	return arg0.active and _.any(arg0:GetNormalFleets(), function(arg0)
		return arg0.row == arg0.top or arg0.row == arg0.bottom or arg0.column == arg0.left or arg0.column == arg0.right
	end)
end

function var0.CheckInteractive(arg0, arg1)
	local var0 = arg0:FindAttachments(WorldMapAttachment.TypeEvent)

	for iter0, iter1 in ipairs(var0) do
		if iter1:RemainOpEffect() then
			return iter1
		end
	end

	for iter2, iter3 in ipairs(var0) do
		if iter3:IsAlive() then
			local var1 = iter3:GetEventEffect()

			if var1 and var1.autoactivate > 0 then
				return iter3
			end
		end
	end

	arg1 = arg1 or arg0:GetFleet()

	local var2 = arg0:GetCell(arg1.row, arg1.column)

	if var2.discovered then
		local var3 = var2:GetAliveAttachments()

		for iter4, iter5 in ipairs(var3) do
			if WorldMapAttachment.IsInteractiveType(iter5.type) and not iter5:IsTriggered() then
				if iter5:IsSign() then
					return nil
				elseif iter5.type == WorldMapAttachment.TypeEvent then
					local var4 = iter5:GetEventEffect()

					if var4 and (var4.effective_num <= 1 or arg0:CountEventEffectKeys(var4) >= var4.effective_num) then
						return iter5
					end
				else
					return iter5
				end
			end
		end
	end
end

function var0.CheckDiscover(arg0)
	local var0 = {}
	local var1 = arg0.theme

	for iter0, iter1 in pairs(arg0.cells) do
		if not iter1.discovered and iter1:GetInFOV() then
			table.insert(var0, {
				row = iter1.row,
				column = iter1.column
			})
		end
	end

	return var0
end

function var0.CheckDisplay(arg0, arg1)
	if arg1.type == WorldMapAttachment.TypeTrap then
		return true
	end

	return arg0:GetCell(arg1.row, arg1.column):GetDisplayAttachment() == arg1
end

function var0.GetFOVRange(arg0, arg1, arg2, arg3)
	arg2 = arg2 or arg1.row
	arg3 = arg3 or arg1.column

	local var0 = arg0:GetCell(arg2, arg3)

	return var0:GetTerrain() == WorldMapCell.TerrainFog and var0.terrainStrong or arg1:GetFOVRange()
end

function var0.UpdateVisionFlag(arg0, arg1)
	arg0.visionFlag = arg1

	arg0:OrderAROpenFOV(arg0.visionFlag)
end

function var0.UpdatePressingMark(arg0, arg1)
	if tobool(arg0.isPressing) ~= tobool(arg1) then
		arg0.isPressing = arg1

		nowWorld():GetTaskProxy():doUpdateTaskByMap(arg0.id, arg1)
	end
end

function var0.ExistAny(arg0, arg1, arg2)
	return arg0:GetCell(arg1, arg2):GetAliveAttachment() or arg0:ExistFleet(arg1, arg2)
end

function var0.ExistFleet(arg0, arg1, arg2)
	return tobool(arg0:FindFleet(arg1, arg2))
end

function var0.CalcFleetSpeed(arg0, arg1)
	local var0 = arg1:GetSpeed()

	if arg0:GetCell(arg1.row, arg1.column):GetTerrain() == WorldMapCell.TerrainFog then
		var0 = math.min(var0, 1)
	end

	return var0
end

function var0.FindPath(arg0, arg1, arg2, arg3)
	local var0 = var0.pathFinder

	if not var0 then
		var0 = PathFinding.New({}, WorldConst.MaxRow, WorldConst.MaxColumn)
		var0.pathFinder = var0
	end

	local var1 = {}

	for iter0 = 0, WorldConst.MaxRow - 1 do
		if not var1[iter0] then
			var1[iter0] = {}
		end

		for iter1 = 0, WorldConst.MaxColumn - 1 do
			local var2 = PathFinding.PrioForbidden

			if arg0:IsWalkable(iter0, iter1) and (not arg3 or arg0:GetCell(iter0, iter1):GetInFOV()) then
				var2 = PathFinding.PrioNormal

				if iter0 == arg2.row and iter1 == arg2.column then
					if not arg0:IsStayPoint(iter0, iter1) then
						var2 = PathFinding.PrioObstacle
					end
				elseif arg0:IsObstacle(iter0, iter1) then
					var2 = PathFinding.PrioObstacle
				end
			end

			var1[iter0][iter1] = var2
		end
	end

	var0.cells = var1

	return var0:Find(arg1, arg2)
end

function var0.FindAIPath(arg0, arg1, arg2)
	local var0 = var0.pathFinder

	if not var0 then
		var0 = PathFinding.New({}, WorldConst.MaxRow, WorldConst.MaxColumn)
		var0.pathFinder = var0
	end

	local var1 = {}

	for iter0 = 0, WorldConst.MaxRow - 1 do
		if not var1[iter0] then
			var1[iter0] = {}
		end

		for iter1 = 0, WorldConst.MaxColumn - 1 do
			local var2 = PathFinding.PrioForbidden

			if arg0:IsWalkable(iter0, iter1) then
				var2 = PathFinding.PrioNormal

				if (iter0 ~= arg2.row or iter1 ~= arg2.column) and arg0:ExistFleet(iter0, iter1) then
					var2 = PathFinding.PrioObstacle
				end
			end

			var1[iter0][iter1] = var2
		end
	end

	var0.cells = var1

	return var0:Find(arg1, arg2)
end

function var0.GetMoveRange(arg0, arg1)
	local var0 = arg1.row
	local var1 = arg1.column
	local var2 = arg0:CalcFleetSpeed(arg1)
	local var3 = {}

	for iter0 = 0, WorldConst.MaxRow - 1 do
		if not var3[iter0] then
			var3[iter0] = {}
		end

		for iter1 = 0, WorldConst.MaxColumn - 1 do
			var3[iter0][iter1] = arg0:IsWalkable(iter0, iter1)
		end
	end

	local var4 = {}
	local var5 = {
		{
			step = 0,
			row = var0,
			column = var1
		}
	}

	var3[var0][var1] = false

	while #var5 > 0 do
		local var6 = table.remove(var5, 1)

		table.insert(var4, var6)

		local var7 = {
			{
				row = 1,
				column = 0
			},
			{
				row = -1,
				column = 0
			},
			{
				row = 0,
				column = 1
			},
			{
				row = 0,
				column = -1
			}
		}

		_.each(var7, function(arg0)
			arg0.row = var6.row + arg0.row
			arg0.column = var6.column + arg0.column
			arg0.step = var6.step + 1

			if arg0.row >= 0 and arg0.row < WorldConst.MaxRow and arg0.column >= 0 and arg0.column < WorldConst.MaxColumn and arg0.step <= var2 and var3[arg0.row][arg0.column] then
				var3[arg0.row][arg0.column] = false

				if arg0:IsObstacle(arg0.row, arg0.column) then
					table.insert(var4, arg0)
				else
					table.insert(var5, arg0)
				end
			end
		end)
	end

	var4 = _.filter(var4, function(arg0)
		return arg0:IsStayPoint(arg0.row, arg0.column)
	end)

	return var4
end

function var0.BuildLongMoveInfos(arg0)
	local var0 = {}

	for iter0 = 0, WorldConst.MaxRow - 1 do
		var0[iter0] = var0[iter0] or {}

		for iter1 = 0, WorldConst.MaxColumn - 1 do
			if arg0:IsWalkable(iter0, iter1) and arg0:GetCell(iter0, iter1):GetInFOV() then
				var0[iter0][iter1] = {
					isMark = false,
					isFinish = false,
					row = iter0,
					column = iter1,
					dp = {},
					last = {},
					isStayPoint = arg0:IsStayPoint(iter0, iter1),
					isObstacle = arg0:IsObstacle(iter0, iter1)
				}
			end
		end
	end

	return var0
end

function var0.GetLongMoveRange(arg0, arg1)
	local var0 = arg1.row
	local var1 = arg1.column
	local var2 = arg0:CalcFleetSpeed(arg1)
	local var3 = arg0:BuildLongMoveInfos()
	local var4 = {}
	local var5 = {}
	local var6 = {
		{
			row = 1,
			column = 0
		},
		{
			row = -1,
			column = 0
		},
		{
			row = 0,
			column = 1
		},
		{
			row = 0,
			column = -1
		}
	}

	local function var7(arg0, arg1, arg2)
		return arg0 < arg1 or arg2 < arg0
	end

	local function var8(arg0)
		if not arg0 then
			return
		end

		arg0.isFinish = true

		table.insert(var4, arg0)

		if arg0.isStayPoint then
			local var0 = arg0.dp

			for iter0 = 1, var2 do
				if var0[iter0] and (not var0[0] or var0[0] > var0[iter0] + 1) then
					var0[0] = var0[iter0] + 1
					arg0.last[0] = arg0.last[iter0]
				end
			end
		end
	end

	local var9 = var3[var0][var1]

	var9.dp[0] = 0
	var9.isMark = true

	var8(var9)

	while var9 do
		_.each(var6, function(arg0)
			if var7(var9.row + arg0.row, 0, WorldConst.MaxRow - 1) or var7(var9.column + arg0.column, 0, WorldConst.MaxColumn - 1) then
				return
			end

			local var0 = var3[var9.row + arg0.row][var9.column + arg0.column]

			if var0 and not var0.isFinish then
				for iter0 = 1, var2 do
					if var9.dp[iter0 - 1] and (not var0.dp[iter0] or var0.dp[iter0] > var9.dp[iter0 - 1]) then
						var0.dp[iter0] = var9.dp[iter0 - 1]
						var0.last[iter0] = {
							var9,
							iter0 - 1
						}

						if not var0.isMark then
							var0.isMark = true

							table.insert(var5, var0)
						end
					end
				end
			end
		end)

		repeat
			var9 = table.remove(var5, 1)

			var8(var9)
		until not var9 or not var9.isObstacle
	end

	local var10 = {}

	for iter0, iter1 in ipairs(var4) do
		if iter1.dp[0] and iter1.dp[0] > 0 then
			table.insert(var10, {
				row = iter1.row,
				column = iter1.column,
				stay = iter1.dp[0]
			})
		end
	end

	return var10, var3
end

function var0.IsWalkable(arg0, arg1, arg2)
	local var0 = arg0:GetCell(arg1, arg2)

	return var0 and var0.walkable and (var0:CanLeave() or arg0:IsStayPoint(arg1, arg2))
end

function var0.IsStayPoint(arg0, arg1, arg2)
	return arg0:GetCell(arg1, arg2):CanArrive() and not arg0:ExistFleet(arg1, arg2)
end

function var0.IsObstacle(arg0, arg1, arg2)
	return not arg0:GetCell(arg1, arg2):CanPass()
end

function var0.IsSign(arg0, arg1, arg2)
	return arg0:GetCell(arg1, arg2):IsSign()
end

function var0.FindNearestBlankPoint(arg0, arg1, arg2)
	local var0 = {}

	for iter0 = 0, WorldConst.MaxRow - 1 do
		if not var0[iter0] then
			var0[iter0] = {}
		end

		for iter1 = 0, WorldConst.MaxColumn - 1 do
			var0[iter0][iter1] = arg0:IsWalkable(iter0, iter1)
		end
	end

	local var1 = {
		row = arg1,
		column = arg2
	}
	local var2 = {}

	while #var1 > 0 do
		local var3 = table.remove(var1, 1)

		table.insert(var2, var3)

		local var4 = {
			{
				row = 1,
				column = 0
			},
			{
				row = -1,
				column = 0
			},
			{
				row = 0,
				column = 1
			},
			{
				row = 0,
				column = -1
			}
		}

		_.each(var4, function(arg0)
			arg0.row = var3.row + arg0.row
			arg0.column = var3.column + arg0.column

			if arg0.row >= 0 and arg0.row < WorldConst.MaxRow and arg0.column >= 0 and arg0.column < WorldConst.MaxColumn and not (_.any(var1, function(arg0)
				return arg0.row == arg0.row and arg0.column == arg0.column
			end) or _.any(var2, function(arg0)
				return arg0.row == arg0.row and arg0.column == arg0.column
			end)) and var0[arg0.row][arg0.column] then
				if arg0:ExistAny(arg0.row, arg0.column) then
					table.insert(var1, arg0)
				else
					return arg0
				end
			end
		end)
	end
end

function var0.WriteBack(arg0, arg1, arg2)
	local var0 = arg0:GetFleet()
	local var1 = {}

	for iter0, iter1 in ipairs(var0:GetShips(true)) do
		table.insert(var1, iter1)
	end

	if arg2.statistics.submarineAid then
		local var2 = arg0:GetSubmarineFleet()

		assert(var2, "submarine fleet not exist.")

		local var3 = var2:GetTeamShips(TeamType.Submarine, true)

		for iter2, iter3 in ipairs(var3) do
			table.insert(var1, iter3)
		end

		var2:UseAmmo()
		var2:AddDefeatEnemies(arg1)
	end

	var0:AddDefeatEnemies(arg1)
	_.each(var1, function(arg0)
		local var0 = arg2.statistics[arg0.id]

		if var0 then
			arg0.hpRant = var0.bp
		end

		if arg0.hpRant <= 0 then
			arg0:Rebirth()
		end
	end)

	local var4 = arg0:GetCell(var0.row, var0.column):GetStageEnemy()

	assert(var4)

	if arg1 then
		var4:UpdateFlag(1)

		arg0.phaseDisplayList = table.mergeArray(arg0.phaseDisplayList, var4:SetHP(0))

		local var5 = false

		_.each(arg0:GetFleets(), function(arg0)
			var5 = var5 or arg0:HasDamageLevel()

			arg0:ClearDamageLevel()
		end)

		if var5 then
			table.insert(arg0.phaseDisplayList, 1, {
				story = "W1500",
				hp = var4:GetMaxHP()
			})
		end
	else
		arg0.isLoss = true

		var0:IncDamageLevel(var4)
		var4:UpdateData(var4.data - 1)

		arg0.phaseDisplayList = table.mergeArray(arg0.phaseDisplayList, var4:SetHP(arg2.statistics._maxBossHP))

		local var6 = nowWorld()

		if var6.isAutoFight then
			var6:TriggerAutoFight(false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_dead"))
		end
	end

	_.each(arg2.hpDropInfo, function(arg0)
		local var0 = #arg0.phaseDisplayList + 1

		for iter0, iter1 in ipairs(arg0.phaseDisplayList) do
			if iter1.hp < arg0.hp then
				var0 = iter0

				break
			end
		end

		arg0:AddPhaseDisplay({
			hp = arg0.hp,
			drops = PlayerConst.addTranDrop(arg0.drop_info)
		}, var0)
	end)
end

function var0.AddPhaseDisplay(arg0, arg1, arg2)
	if arg2 then
		table.insert(arg0.phaseDisplayList, arg2, arg1)
	else
		table.insert(arg0.phaseDisplayList, arg1)
	end
end

function var0.FindAttachments(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.typeAttachments) do
		if not arg1 or arg1 == iter0 then
			for iter2, iter3 in ipairs(iter1) do
				if not arg2 or iter3.id == arg2 then
					table.insert(var0, iter3)
				end
			end
		end
	end

	return var0
end

function var0.FindEnemys(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.typeAttachments) do
		if WorldMapAttachment.IsEnemyType(iter0) then
			var0 = table.mergeArray(var0, iter1)
		end
	end

	return var0
end

function var0.GetMapMinMax(arg0)
	local var0 = Vector2(WorldConst.MaxColumn, WorldConst.MaxRow)
	local var1 = Vector2(-WorldConst.MaxColumn, -WorldConst.MaxRow)

	for iter0 = 0, WorldConst.MaxRow - 1 do
		for iter1 = 0, WorldConst.MaxColumn - 1 do
			if arg0:GetCell(iter0, iter1) then
				var0.x = math.min(var0.x, iter1)
				var0.y = math.min(var0.y, iter0)
				var1.x = math.max(var1.x, iter1)
				var1.y = math.max(var1.y, iter0)
			end
		end
	end

	return var0.y, var1.y, var0.x, var1.x
end

function var0.GetMapSize(arg0)
	local var0, var1, var2, var3 = arg0:GetMapMinMax()

	return var1 - var0 + 1, var3 - var2 + 1
end

function var0.CountEventEffectKeys(arg0, arg1)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0:GetNormalFleets()) do
		local var1 = arg0:GetCell(iter1.row, iter1.column):GetAliveAttachment()

		if var1 and var1.type == WorldMapAttachment.TypeEvent and var1:GetEventEffect() == arg1 then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.EventEffectOpenFOV(arg0, arg1)
	assert(arg1.effect_type == WorldMapAttachment.EffectEventFOV)

	local var0, var1 = unpack(arg1.effect_paramater)
	local var2 = var1 >= 0

	var1 = var2 and var1 or math.abs(var1) - 1

	local var3 = arg0:FindAttachments(WorldMapAttachment.TypeEvent, var0)

	_.each(var3, function(arg0)
		arg0.centerCellFOV = {
			row = arg0.row,
			column = arg0.column
		}

		for iter0 = math.max(arg0.row - var1, 0), math.min(arg0.row + var1, WorldConst.MaxRow - 1) do
			for iter1 = math.max(arg0.column - var1, 0), math.min(arg0.column + var1, WorldConst.MaxColumn - 1) do
				if WorldConst.InFOVRange(arg0.row, arg0.column, iter0, iter1, var1) then
					local var0 = arg0:GetCell(iter0, iter1)

					if var0 then
						if var2 then
							var0:UpdateInFov(bit.bor(var0.infov, WorldConst.FOVEventEffect))
						else
							var0:UpdateInFov(bit.band(var0.infov, WorldConst.Flag16Max - WorldConst.FOVEventEffect))
						end
					end
				end
			end
		end
	end)
end

function var0.OrderAROpenFOV(arg0, arg1)
	if arg1 then
		local var0 = arg0:GetFleet()

		arg0.centerCellFOV = {
			row = var0.row,
			column = var0.column
		}
	end

	for iter0, iter1 in pairs(arg0.cells) do
		if arg1 then
			iter1:UpdateInFov(bit.bor(iter1.infov, WorldConst.FOVEventEffect))
		else
			iter1:UpdateInFov(bit.band(iter1.infov, WorldConst.Flag16Max - WorldConst.FOVEventEffect))
		end
	end
end

function var0.GetMaxDistanceCell(arg0, arg1, arg2)
	local var0
	local var1 = 0
	local var2 = {
		{
			row = arg0.top,
			column = arg0.left
		},
		{
			row = arg0.bottom,
			column = arg0.left
		},
		{
			row = arg0.top,
			column = arg0.right
		},
		{
			row = arg0.bottom,
			column = arg0.right
		}
	}

	for iter0, iter1 in pairs(var2) do
		local var3 = (iter1.row - arg1) * (iter1.row - arg1) + (iter1.column - arg2) * (iter1.column - arg2)

		if var1 < var3 then
			var0 = iter1
			var1 = var3
		end
	end

	return var0, math.sqrt(var1)
end

function var0.GetCellsInFOV(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.cells) do
		if iter1:GetInFOV() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.AlwaysInFOV(arg0)
	return arg0.config.map_sight == 1
end

function var0.GetEventTipWord(arg0)
	local var0 = arg0:FindAttachments(WorldMapAttachment.TypeEvent)
	local var1 = ""
	local var2 = 0

	for iter0, iter1 in ipairs(var0) do
		local var3 = pg.world_event_desc[iter1.id]

		if iter1:IsAlive() and var3 and var2 < var3.hint_pri then
			var2 = var3.hint_pri
			var1 = var3.hint
		end
	end

	return var1, var2
end

function var0.GetEventPoisonRate(arg0)
	local var0 = arg0:FindAttachments(WorldMapAttachment.TypeEvent)
	local var1 = 0

	for iter0, iter1 in ipairs(var0) do
		if iter1:IsAlive() then
			var1 = var1 + iter1.config.infection_value
		end
	end

	return var1, arg0.config.is_sairen
end

function var0.GetPressingLevel(arg0)
	return arg0.config.complete_effect
end

function var0.CheckMapPressing(arg0)
	return arg0:GetPressingLevel() > 0 and not arg0.isPressing and arg0:GetEventPoisonRate() == 0
end

function var0.CheckMapPressingDisplay(arg0)
	return arg0:GetPressingLevel() > 1
end

function var0.UpdateClearFlag(arg0, arg1)
	arg0.clearFlag = tobool(arg1)
end

function var0.IsUnlockFleetMode(arg0)
	if arg0.config.move_switch == 1 then
		return true
	elseif arg0.config.move_switch == 0 then
		return false
	else
		assert(false, "config error")
	end
end

function var0.CheckFleetSalvage(arg0, arg1)
	local var0 = underscore.detect(arg0:GetFleets(), function(arg0)
		return arg0:IsCatSalvage() and (arg1 or arg0:IsSalvageFinish() or arg0.salvageAutoResult or arg0.catSalvageFrom ~= arg0.id)
	end)

	if var0 then
		return var0.id
	else
		arg0.salvageAutoResult = false
	end
end

function var0.GetChapterAuraBuffs(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.fleets) do
		local var1 = iter1:getMapAura()

		for iter2, iter3 in ipairs(var1) do
			table.insert(var0, iter3)
		end
	end

	return var0
end

function var0.GetChapterAidBuffs(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.fleets) do
		if iter0 ~= arg0.findex then
			local var1 = iter1:getMapAid()

			for iter2, iter3 in pairs(var1) do
				var0[iter2] = iter3
			end
		end
	end

	return var0
end

function var0.getFleetBattleBuffs(arg0, arg1, arg2)
	local var0 = {}

	underscore.each(arg1:GetBuffList(), function(arg0)
		local var0 = arg0.config.lua_id

		if var0 ~= 0 then
			table.insert(var0, var0)
		end
	end)

	local var1 = {}

	if arg2 and arg1:IsCatSalvage() then
		-- block empty
	else
		var1 = arg0:BuildBattleBuffList(arg1)
	end

	return var0, var1
end

function var0.BuildBattleBuffList(arg0, arg1)
	local var0 = {}
	local var1, var2 = arg0:triggerSkill(arg1, FleetSkill.TypeBattleBuff)

	if var1 and #var1 > 0 then
		local var3 = {}

		for iter0, iter1 in ipairs(var1) do
			local var4 = var2[iter0]
			local var5 = arg1:findCommanderBySkillId(var4.id)

			var3[var5] = var3[var5] or {}

			table.insert(var3[var5], iter1)
		end

		for iter2, iter3 in pairs(var3) do
			table.insert(var0, {
				iter2,
				iter3
			})
		end
	end

	local var6 = arg1:getCommanders()

	for iter4, iter5 in pairs(var6) do
		local var7 = iter5:getTalents()

		for iter6, iter7 in ipairs(var7) do
			local var8 = iter7:getBuffsAddition()

			if #var8 > 0 then
				local var9

				for iter8, iter9 in ipairs(var0) do
					if iter9[1] == iter5 then
						var9 = iter9[2]

						break
					end
				end

				if not var9 then
					var9 = {}

					table.insert(var0, {
						iter5,
						var9
					})
				end

				for iter10, iter11 in ipairs(var8) do
					table.insert(var9, iter11)
				end
			end
		end
	end

	return var0
end

function var0.CanLongMove(arg0, arg1)
	return arg0:IsUnlockFleetMode() and not arg1:HasTrapBuff() and arg0:GetFleetTerrain(arg1) ~= WorldMapCell.TerrainFog
end

function var0.triggerSkill(arg0, arg1, arg2)
	local var0 = _.filter(arg1:findSkills(arg2), function(arg0)
		local var0 = arg0:GetTriggers()

		return _.any(var0, function(arg0)
			return arg0[1] == FleetSkill.TriggerInSubTeam and arg0[2] == 1
		end) == (arg1:GetFleetType() == FleetType.Submarine) and _.all(arg0:GetTriggers(), function(arg0)
			return arg0:triggerCheck(arg1, arg0, arg0)
		end)
	end)

	return _.reduce(var0, nil, function(arg0, arg1)
		local var0 = arg1:GetType()
		local var1 = arg1:GetArgs()

		if var0 == FleetSkill.TypeMoveSpeed or var0 == FleetSkill.TypeHuntingLv or var0 == FleetSkill.TypeTorpedoPowerUp then
			return (arg0 or 0) + var1[1]
		elseif var0 == FleetSkill.TypeAmbushDodge or var0 == FleetSkill.TypeAirStrikeDodge then
			return math.max(arg0 or 0, var1[1])
		elseif var0 == FleetSkill.TypeAttack or var0 == FleetSkill.TypeStrategy then
			arg0 = arg0 or {}

			table.insert(arg0, var1)

			return arg0
		elseif var0 == FleetSkill.TypeBattleBuff then
			arg0 = arg0 or {}

			table.insert(arg0, var1[1])

			return arg0
		end
	end), var0
end

function var0.triggerCheck(arg0, arg1, arg2, arg3)
	local var0 = arg3[1]

	if var0 == FleetSkill.TriggerDDHead then
		local var1 = arg1:GetTeamShipVOs(TeamType.Vanguard, false)

		return #var1 > 0 and ShipType.IsTypeQuZhu(var1[1]:getShipType())
	elseif var0 == FleetSkill.TriggerVanCount then
		local var2 = arg1:GetTeamShipVOs(TeamType.Vanguard, false)

		return #var2 >= arg3[2] and #var2 <= arg3[3]
	elseif var0 == FleetSkill.TriggerShipCount then
		local var3 = _.filter(arg1:GetShipVOs(false), function(arg0)
			return table.contains(arg3[2], arg0:getShipType())
		end)

		return #var3 >= arg3[3] and #var3 <= arg3[4]
	elseif var0 == FleetSkill.TriggerAroundEnemy then
		local var4 = {
			row = arg1.row,
			column = arg1.column
		}
		local var5 = {}
		local var6 = arg3[2]

		for iter0 = -var6, var6 do
			local var7 = var6 - math.abs(iter0)

			for iter1 = -var7, var7 do
				local var8 = arg0:GetCell(var4.row + iter0, var4.column + iter1)

				table.insert(var5, var8)
			end
		end

		return underscore.any(var5, function(arg0)
			local var0 = arg0:ExistEnemy() and arg0:GetStageEnemy().config.type or nil

			return type(arg3[3]) == "number" and arg3[3] == var0 or type(arg3[3]) == "table" and table.contains(arg3[3], var0)
		end)
	elseif var0 == FleetSkill.TriggerNekoPos then
		local var9 = arg1:findCommanderBySkillId(arg2.id)

		for iter2, iter3 in pairs(arg1:getCommanders()) do
			if var9.id == iter3.id and iter2 == arg3[2] then
				return true
			end
		end
	elseif var0 == FleetSkill.TriggerAroundLand then
		local var10 = {
			row = arg1.row,
			column = arg1.column
		}
		local var11 = arg3[2]

		for iter4 = -var11, var11 do
			local var12 = var11 - math.abs(iter4)

			for iter5 = -var12, var12 do
				local var13 = var10.row + iter4
				local var14 = var10.column + iter5

				if arg0:GetCell(var13, var14) and not arg0:IsWalkable(var13, var14) then
					return true
				end
			end
		end

		return false
	elseif var0 == FleetSkill.TriggerAroundCombatAlly then
		local var15 = {
			row = arg1.row,
			column = arg1.column
		}

		return _.any(arg0.fleets, function(arg0)
			return arg1.id ~= arg0.id and arg0:GetFleetType() == FleetType.Normal and arg0:GetCell(arg0.line.row, arg0.line.column):ExistEnemy() and ManhattonDist(var15, {
				row = arg0.line.row,
				column = arg0.line.column
			}) <= arg3[2]
		end)
	elseif var0 == FleetSkill.TriggerInSubTeam then
		return true
	else
		assert(false, "invalid trigger type: " .. var0)
	end
end

function var0.OnUpdateAttachmentExist(arg0, arg1, arg2, arg3)
	local var0 = arg3.type

	arg0.typeAttachments[var0] = arg0.typeAttachments[var0] or {}

	if arg1 == WorldMapCell.EventAddAttachment then
		table.insert(arg0.typeAttachments[var0], arg3)
	elseif arg1 == WorldMapCell.EventRemoveAttachment then
		table.removebyvalue(arg0.typeAttachments[var0], arg3)
	end

	local var1 = arg3:GetVisionRadius()

	if var1 > 0 then
		local var2 = 0

		if arg1 == WorldMapCell.EventAddAttachment then
			var2 = var2 + 1
		elseif arg1 == WorldMapCell.EventRemoveAttachment then
			var2 = var2 - 1
		else
			assert(false, "listener event error: " .. arg1)
		end

		arg0.centerCellFOV = {
			row = arg2.row,
			column = arg2.column
		}

		for iter0 = arg2.row - var1, arg2.row + var1 do
			for iter1 = arg2.column - var1, arg2.column + var1 do
				local var3 = arg0:GetCell(iter0, iter1)

				if var3 and WorldConst.InFOVRange(arg2.row, arg2.column, var3.row, var3.column, var1) then
					var3:ChangeInLight(var2 > 0)
				end
			end
		end
	end

	local var4 = arg3:GetRadiationBuffs()

	if #var4 > 0 then
		local var5 = {}

		for iter2, iter3 in ipairs(var4) do
			local var6, var7, var8 = unpack(iter3)

			if arg1 == WorldMapCell.EventAddAttachment then
				var5[var6] = true

				arg0:AddBuff(var6, var7, var8)
			elseif arg1 == WorldMapCell.EventRemoveAttachment then
				var5[var6] = true

				arg0:RemoveBuff(var6, var7, var8)
			end
		end

		for iter4, iter5 in pairs(var5) do
			if iter5 then
				arg0:FlushFaction(iter4)
			end
		end
	end
end

function var0.GetBGM(arg0)
	return arg0.config.bgm
end

function var0.NeedClear(arg0)
	local var0, var1 = arg0:GetEventPoisonRate()

	return var1 > 0 and var0 == 0 or arg0.clearFlag or arg0.config.is_clear > 0
end

function var0.GetBuff(arg0, arg1, arg2)
	if not arg0.factionBuffs[arg1][arg2] then
		arg0.factionBuffs[arg1][arg2] = WorldBuff.New()

		arg0.factionBuffs[arg1][arg2]:Setup({
			floor = 0,
			id = arg2
		})
	end

	return arg0.factionBuffs[arg1][arg2]
end

function var0.AddBuff(arg0, arg1, arg2, arg3)
	arg0:GetBuff(arg1, arg2):AddFloor(arg3)
end

function var0.RemoveBuff(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetBuff(arg1, arg2)

	if arg3 then
		var0:AddFloor(arg3 * -1)
	else
		arg0.factionBuffs[arg1][arg2] = nil
	end
end

function var0.GetBuffList(arg0, arg1, arg2)
	if arg1 == var0.FactionSelf then
		return underscore.filter(underscore.values(arg0.factionBuffs[arg1]), function(arg0)
			return arg0:GetFloor() > 0
		end)
	elseif arg1 == var0.FactionEnemy then
		if WorldMapAttachment.IsEnemyType(arg2.type) or arg2.type == WorldMapAttachment.TypeEvent and arg2:GetSpEventType() == WorldMapAttachment.SpEventEnemy then
			return underscore.filter(underscore.values(arg0.factionBuffs[arg1]), function(arg0)
				return arg0:GetFloor() > 0
			end)
		else
			return {}
		end
	else
		assert(false, string.format("faction error: $d", arg1))
	end
end

function var0.FlushFaction(arg0, arg1)
	if arg1 == var0.FactionSelf then
		underscore.each(arg0:GetFleets(), function(arg0)
			arg0:DispatchEvent(WorldMapFleet.EventUpdateBuff)
		end)
	elseif arg1 == var0.FactionEnemy then
		local var0 = {}

		underscore.each(arg0:FindEnemys(), function(arg0)
			var0[WorldMapCell.GetName(arg0.row, arg0.column)] = true
		end)
		underscore.each(arg0:FindAttachments(WorldMapAttachment.TypeEvent), function(arg0)
			if arg0:GetSpEventType() == WorldMapAttachment.SpEventEnemy then
				var0[WorldMapCell.GetName(arg0.row, arg0.column)] = true
			end
		end)

		for iter0 in pairs(var0) do
			arg0.cells[iter0]:DispatchEvent(var0.EventUpdateMapBuff)
		end
	else
		assert(false, string.format("faction error: $d", arg1))
	end
end

function var0.GetBattleLuaBuffs(arg0, arg1, arg2)
	local var0 = {}

	underscore.each(arg0:GetBuffList(arg1, arg2), function(arg0)
		if arg0.config.lua_id > 0 then
			table.insert(var0, arg0.config.lua_id)
		end
	end)

	return var0
end

function var0.UpdateFleetLocation(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetFleet(arg1)

	assert(var0, "without this fleet : " .. arg1)

	if var0.row ~= arg2 or var0.column ~= arg3 then
		arg0:CheckFleetUpdateFOV(var0, function()
			var0.row = arg2
			var0.column = arg3
		end)
		var0:DispatchEvent(WorldMapFleet.EventUpdateLocation)
	end
end

function var0.GetRangeDic(arg0, arg1)
	local var0 = {}

	WorldConst.RangeCheck(arg1, arg0:GetFOVRange(arg1), function(arg0, arg1)
		local var0 = WorldMapCell.GetName(arg0, arg1)

		if arg0.cells[var0] then
			var0[var0] = defaultValue(var0[var0], 0) + 1
		end
	end)

	return var0
end

function var0.CheckFleetUpdateFOV(arg0, arg1, arg2)
	if not arg0:IsValid() then
		arg2()

		return
	end

	local var0 = arg0:GetRangeDic(arg1)
	local var1 = arg0:GetFleetTerrain(arg1) == WorldMapCell.TerrainFog
	local var2 = arg0:IsFleetTerrainSairenFog(arg1)
	local var3 = arg0:CalcFleetSpeed(arg1)

	arg2()

	local var4 = arg0:GetRangeDic(arg1)
	local var5 = arg0:GetFleetTerrain(arg1) == WorldMapCell.TerrainFog
	local var6 = arg0:IsFleetTerrainSairenFog(arg1)
	local var7 = arg0:CalcFleetSpeed(arg1)

	arg0.centerCellFOV = {
		row = arg1.row,
		column = arg1.column
	}

	local var8 = false
	local var9 = false
	local var10 = {}

	if not var1 then
		for iter0, iter1 in pairs(var0) do
			var10[iter0] = defaultValue(var10[iter0], 0) - iter1
		end
	end

	if not var5 then
		for iter2, iter3 in pairs(var4) do
			var10[iter2] = defaultValue(var10[iter2], 0) + iter3
		end
	end

	for iter4, iter5 in pairs(var10) do
		if iter5 ~= 0 then
			arg0.cells[iter4]:ChangeInLight(iter5 > 0)

			var8 = true
		end
	end

	if arg0:GetFleet() == arg1 then
		local var11 = {}

		if var1 then
			for iter6, iter7 in pairs(var0) do
				var11[iter6] = defaultValue(var11[iter6], 0) - iter7
			end
		end

		if var5 then
			for iter8, iter9 in pairs(var4) do
				var11[iter8] = defaultValue(var11[iter8], 0) + iter9
			end
		end

		if var1 ~= var5 or var2 ~= var6 then
			for iter10, iter11 in pairs(arg0.cells) do
				local var12

				if var11[iter10] and var11[iter10] ~= 0 then
					var12 = var11[iter10] > 0
				end

				iter11:UpdateFog(var5, var12, var6)
			end

			var8 = true
		else
			for iter12, iter13 in pairs(var11) do
				if iter13 ~= 0 then
					arg0.cells[iter12]:UpdateFog(nil, iter13 > 0, nil)

					var8 = true
				end
			end
		end

		if var3 ~= var7 then
			var9 = true
		end
	end

	if var8 then
		arg0:DispatchEvent(var0.EventUpdateFleetFOV)
	end

	if var9 then
		arg0:DispatchEvent(var0.EventUpdateMoveSpeed)
	end
end

function var0.CheckSelectFleetUpdateFog(arg0, arg1)
	if not arg0:IsValid() then
		arg1()

		return
	end

	local var0 = arg0:GetFleet()
	local var1 = arg0:GetRangeDic(var0)
	local var2 = arg0:GetFleetTerrain(var0) == WorldMapCell.TerrainFog
	local var3 = arg0:IsFleetTerrainSairenFog(var0)

	arg1()

	local var4 = arg0:GetFleet()
	local var5 = arg0:GetRangeDic(var4)
	local var6 = arg0:GetFleetTerrain(var4) == WorldMapCell.TerrainFog
	local var7 = arg0:IsFleetTerrainSairenFog(var4)

	arg0.centerCellFOV = {
		row = var4.row,
		column = var4.column
	}

	local var8 = {}

	if var2 then
		for iter0, iter1 in pairs(var1) do
			var8[iter0] = defaultValue(var8[iter0], 0) - iter1
		end
	end

	if var6 then
		for iter2, iter3 in pairs(var5) do
			var8[iter2] = defaultValue(var8[iter2], 0) + iter3
		end
	end

	if var2 ~= var6 or var3 ~= var7 then
		for iter4, iter5 in pairs(arg0.cells) do
			local var9

			if var8[iter4] and var8[iter4] ~= 0 then
				var9 = var8[iter4] > 0
			end

			iter5:UpdateFog(var6, var9, var7)
		end
	else
		for iter6, iter7 in pairs(var8) do
			if iter7 ~= 0 then
				arg0.cells[iter6]:UpdateFog(nil, iter7 > 0, nil)
			end
		end
	end

	arg0:DispatchEvent(var0.EventUpdateFleetFOV)
end

function var0.CheckEventAutoTrigger(arg0, arg1)
	if arg1:GetSpEventType() == WorldMapAttachment.SpEventConsumeItem then
		return getProxy(SettingsProxy):GetWorldFlag("consume_item")
	end

	local var0 = arg1:GetEventEffect()

	if var0 then
		local var1 = arg0:GetFleet()
		local var2 = var0.effect_type

		if var2 == WorldMapAttachment.EffectEventConsumeCarry then
			local var3 = var0.effect_paramater[1] or {}

			return not underscore.any(var3, function(arg0)
				return not var1:ExistCarry(arg0)
			end)
		elseif var2 == WorldMapAttachment.EffectEventCatSalvage then
			return var1:GetDisplayCommander() and not var1:IsCatSalvage()
		end
	end

	return true
end

function var0.CanAutoFight(arg0)
	if arg0.config.is_auto > 0 then
		for iter0 = 1, arg0.config.is_auto do
			if not nowWorld():IsSystemOpen(WorldConst["SystemAutoFight_" .. iter0]) then
				return false
			end
		end

		return true
	else
		return false
	end
end

function var0.CkeckTransport(arg0)
	assert(arg0:IsValid(), "without map info")

	if arg0.config.is_transfer == 0 then
		return false, i18n("world_transport_disable")
	end

	if arg0:CheckAttachmentTransport() == "block" then
		return false, i18n("world_movelimit_event_text")
	end

	if nowWorld():CheckTaskLockMap() then
		return false, i18n("world_task_maplock")
	end

	return true
end

return var0
