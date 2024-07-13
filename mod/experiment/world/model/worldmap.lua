local var0_0 = class("WorldMap", import("...BaseEntity"))

var0_0.Fields = {
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
var0_0.Listeners = {
	onUpdateAttachmentExist = "OnUpdateAttachmentExist"
}
var0_0.EventUpdateActive = "WorldMap.EventUpdateActive"
var0_0.EventUpdateFIndex = "WorldMap.EventUpdateFIndex"
var0_0.EventUpdateMapBuff = "WorldMap.EventUpdateMapBuff"
var0_0.EventUpdateFleetFOV = "WorldMap.EventUpdateFleetFOV"
var0_0.EventUpdateMoveSpeed = "WorldMap.EventUpdateMoveSpeed"

function var0_0.DebugPrint(arg0_1)
	return string.format("地图 [%s] [id: %s] [gid: %s] [危险度: %s] [是否压制：%s]", arg0_1.config.name, arg0_1.id, tostring(arg0_1.gid), arg0_1:GetDanger(), arg0_1.isPressing)
end

function var0_0.Build(arg0_2)
	arg0_2.cells = {}
	arg0_2.ports = {}
	arg0_2.phaseDisplayList = {}
end

function var0_0.Dispose(arg0_3)
	arg0_3:UnbindFleets()
	arg0_3:DisposeTheme()
	arg0_3:DisposeGrid()
	arg0_3:DisposePort()
	arg0_3:Clear()
end

function var0_0.Setup(arg0_4, arg1_4)
	arg0_4.id = arg1_4

	assert(pg.world_chapter_random[arg0_4.id], "world_chapter_random not exist: " .. tostring(arg0_4.id))

	arg0_4.config = setmetatable({}, {
		__index = function(arg0_5, arg1_5)
			return arg0_4:GetConfig(arg1_5)
		end
	})
end

function var0_0.GetName(arg0_6, arg1_6)
	local var0_6 = arg1_6 and World.ReplacementMapType(arg1_6, arg0_6)

	if var0_6 == "sairen_chapter" or var0_6 == "teasure_chapter" then
		return arg1_6:GetBaseMap():GetName() .. "-" .. arg0_6.config.name
	else
		return arg0_6.config.name
	end
end

function var0_0.GetConfig(arg0_7, arg1_7)
	local var0_7 = pg.world_chapter_random[arg0_7.id]
	local var1_7 = pg.world_chapter_template[arg0_7.gid]
	local var2_7 = var0_7 and var0_7[arg1_7] or var1_7 and var1_7[arg1_7] or nil

	assert(var2_7 ~= nil, "can not find " .. arg1_7 .. " in WorldMap " .. arg0_7.id)

	return var2_7
end

var0_0.FactionSelf = 0
var0_0.FactionEnemy = 1

function var0_0.UpdateGridId(arg0_8, arg1_8)
	arg0_8.gid = arg1_8

	assert(pg.world_chapter_template[arg0_8.gid], "world_chapter_template not exist: " .. tostring(arg0_8.gid))
	arg0_8:DisposeTheme()
	arg0_8:DisposeGrid()
	arg0_8:DisposePort()

	arg0_8.factionBuffs = {
		[var0_0.FactionSelf] = {},
		[var0_0.FactionEnemy] = {}
	}

	for iter0_8, iter1_8 in ipairs(arg0_8.config.world_chapter_buff) do
		local var0_8, var1_8, var2_8 = unpack(iter1_8)

		arg0_8:AddBuff(var0_8, var1_8, var2_8)
	end

	arg0_8:SetupTheme()
	arg0_8:SetupGrid()
	arg0_8:SetupPort()
end

function var0_0.SetupTheme(arg0_9)
	local var0_9 = WPool:Get(WorldMapTheme)

	var0_9:Setup(arg0_9.config.theme)

	arg0_9.theme = var0_9
end

function var0_0.DisposeTheme(arg0_10)
	if arg0_10.theme then
		WPool:Return(arg0_10.theme)

		arg0_10.theme = nil
	end
end

function var0_0.SetupGrid(arg0_11, arg1_11)
	_.each(arg0_11.config.grids, function(arg0_12)
		local var0_12 = WPool:Get(WorldMapCell)

		var0_12:Setup(arg0_12)

		if arg0_11:AlwaysInFOV() then
			var0_12.infov = bit.bor(var0_12.infov, WorldConst.FOVMapSight)
		end

		local var1_12 = WorldMapCell.GetName(var0_12.row, var0_12.column)

		arg0_11.cells[var1_12] = var0_12

		if not arg1_11 then
			var0_12:AddListener(WorldMapCell.EventAddAttachment, arg0_11.onUpdateAttachmentExist)
			var0_12:AddListener(WorldMapCell.EventRemoveAttachment, arg0_11.onUpdateAttachmentExist)
		end
	end)

	arg0_11.left, arg0_11.right = 999999, 0
	arg0_11.top, arg0_11.bottom = 999999, 0

	for iter0_11 = 0, WorldConst.MaxRow do
		local var0_11
		local var1_11

		for iter1_11 = 0, WorldConst.MaxColumn do
			local var2_11 = arg0_11:GetCell(iter0_11, iter1_11)

			if var2_11 then
				if not var0_11 then
					var0_11 = iter1_11
					var2_11.dir = bit.bor(var2_11.dir, bit.lshift(1, WorldConst.DirLeft))
				end

				var1_11 = iter1_11
			end
		end

		if var1_11 then
			local var3_11 = arg0_11:GetCell(iter0_11, var1_11)

			var3_11.dir = bit.bor(var3_11.dir, bit.lshift(1, WorldConst.DirRight))
		end

		if var0_11 then
			arg0_11.left = math.min(arg0_11.left, var0_11)
		end

		if var1_11 then
			arg0_11.right = math.max(arg0_11.right, var1_11)
		end
	end

	for iter2_11 = 0, WorldConst.MaxColumn do
		local var4_11
		local var5_11

		for iter3_11 = 0, WorldConst.MaxRow do
			local var6_11 = arg0_11:GetCell(iter3_11, iter2_11)

			if var6_11 then
				if not var4_11 then
					var4_11 = iter3_11
					var6_11.dir = bit.bor(var6_11.dir, bit.lshift(1, WorldConst.DirUp))
				end

				var5_11 = iter3_11
			end
		end

		if var5_11 then
			local var7_11 = arg0_11:GetCell(var5_11, iter2_11)

			var7_11.dir = bit.bor(var7_11.dir, bit.lshift(1, WorldConst.DirDown))
		end

		if var4_11 then
			arg0_11.top = math.min(arg0_11.top, var4_11)
		end

		if var5_11 then
			arg0_11.bottom = math.max(arg0_11.bottom, var5_11)
		end
	end
end

function var0_0.DisposeGrid(arg0_13, arg1_13)
	if not arg1_13 then
		for iter0_13, iter1_13 in pairs(arg0_13.cells) do
			iter1_13:RemoveListener(WorldMapCell.EventAddAttachment, arg0_13.onUpdateAttachmentExist)
			iter1_13:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0_13.onUpdateAttachmentExist)
		end
	end

	WPool:ReturnMap(arg0_13.cells)

	arg0_13.cells = {}
	arg0_13.typeAttachments = {}
	arg0_13.left = nil
	arg0_13.top = nil
	arg0_13.right = nil
	arg0_13.bottom = nil
end

function var0_0.SetupPort(arg0_14)
	if #arg0_14.config.port_id > 0 then
		local var0_14 = WPool:Get(WorldMapPort)

		var0_14:Setup(arg0_14.config.port_id[1])

		local var1_14, var2_14 = unpack(arg0_14.config.port_id[2])

		for iter0_14 = var1_14 - 1, var1_14 + 1 do
			for iter1_14 = var2_14 - 1, var2_14 + 1 do
				if iter0_14 ~= var1_14 or iter1_14 ~= var2_14 then
					local var3_14 = arg0_14:GetCell(iter0_14, iter1_14)

					if var3_14 then
						var3_14:AddAttachment(WorldMapAttachment.MakeFakePort(iter0_14, iter1_14, var0_14.id))
					end
				end
			end
		end

		table.insert(arg0_14.ports, var0_14)
	end
end

function var0_0.DisposePort(arg0_15)
	WPool:ReturnArray(arg0_15.ports)

	arg0_15.ports = {}
end

function var0_0.IsValid(arg0_16)
	return arg0_16.valid
end

function var0_0.SetValid(arg0_17, arg1_17)
	arg0_17.valid = arg1_17

	if arg1_17 and arg0_17.fleets then
		for iter0_17, iter1_17 in ipairs(arg0_17:GetNormalFleets()) do
			arg0_17.centerCellFOV = {
				row = iter1_17.row,
				column = iter1_17.column
			}

			if arg0_17:GetFleetTerrain(iter1_17) ~= WorldMapCell.TerrainFog then
				WorldConst.RangeCheck(iter1_17, arg0_17:GetFOVRange(iter1_17), function(arg0_18, arg1_18)
					local var0_18 = arg0_17.cells[WorldMapCell.GetName(arg0_18, arg1_18)]

					if var0_18 then
						var0_18:ChangeInLight(true)
					end
				end)
			elseif arg0_17.findex == iter0_17 then
				local var0_17 = {}

				WorldConst.RangeCheck(iter1_17, arg0_17:GetFOVRange(iter1_17), function(arg0_19, arg1_19)
					local var0_19 = WorldMapCell.GetName(arg0_19, arg1_19)

					if arg0_17.cells[var0_19] then
						var0_17[var0_19] = true
					end
				end)

				local var1_17 = arg0_17:IsFleetTerrainSairenFog(iter1_17)

				for iter2_17, iter3_17 in pairs(arg0_17.cells) do
					iter3_17:UpdateFog(true, var0_17[iter2_17], var1_17)
				end
			end
		end
	end
end

function var0_0.IsMapOpen(arg0_20)
	return nowWorld():GetProgress() >= arg0_20:GetOpenProgress()
end

function var0_0.GetOpenProgress(arg0_21)
	local var0_21 = nowWorld():GetRealm()

	return var0_21 > 0 and arg0_21.config.open_stage[var0_21] or 9999
end

function var0_0.RemoveAllCellDiscovered(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.cells) do
		iter1_22:UpdateDiscovered(false)
	end
end

function var0_0.GetDanger(arg0_23)
	return arg0_23.config.hazard_level
end

function var0_0.BindFleets(arg0_24, arg1_24)
	arg0_24.fleets = arg1_24
end

function var0_0.UnbindFleets(arg0_25)
	arg0_25.fleets = nil
end

function var0_0.GetFleets(arg0_26)
	return _.rest(arg0_26.fleets, 1)
end

function var0_0.GetFleet(arg0_27, arg1_27)
	return arg1_27 and _.detect(arg0_27.fleets, function(arg0_28)
		return arg0_28.id == arg1_27
	end) or arg0_27.fleets[arg0_27.findex]
end

function var0_0.GetNormalFleets(arg0_29)
	return _.filter(arg0_29.fleets, function(arg0_30)
		return arg0_30:GetFleetType() == FleetType.Normal
	end)
end

function var0_0.GetSubmarineFleet(arg0_31)
	return _.detect(arg0_31.fleets, function(arg0_32)
		return arg0_32:GetFleetType() == FleetType.Submarine
	end)
end

function var0_0.FindFleet(arg0_33, arg1_33, arg2_33)
	return _.detect(arg0_33.fleets, function(arg0_34)
		return arg0_34.row == arg1_33 and arg0_34.column == arg2_33
	end)
end

function var0_0.CheckFleetMovable(arg0_35, arg1_35)
	return arg0_35:GetCell(arg1_35.row, arg1_35.column):CanLeave()
end

function var0_0.GetFleetTerrain(arg0_36, arg1_36)
	return arg0_36:GetCell(arg1_36.row, arg1_36.column):GetTerrain()
end

function var0_0.IsFleetTerrainSairenFog(arg0_37, arg1_37)
	return arg0_37:GetCell(arg1_37.row, arg1_37.column):IsTerrainSairenFog()
end

function var0_0.RemoveFleetsCarries(arg0_38, arg1_38)
	arg1_38 = arg1_38 or arg0_38.fleets

	_.each(arg1_38, function(arg0_39)
		arg0_39:RemoveAllCarries()
	end)
end

function var0_0.UpdateFleetIndex(arg0_40, arg1_40)
	if arg0_40.findex ~= arg1_40 then
		arg0_40:CheckSelectFleetUpdateFog(function()
			arg0_40.findex = arg1_40
		end)
		arg0_40:DispatchEvent(var0_0.EventUpdateFIndex)
	end
end

function var0_0.UpdateActive(arg0_42, arg1_42)
	local var0_42 = nowWorld():GetAtlas()

	if arg0_42.active ~= arg1_42 then
		arg0_42.active = arg1_42

		if arg1_42 then
			arg0_42:SetValid(false)
			var0_42:SetActiveMap(arg0_42)

			arg0_42.isCost = true

			var0_42:UpdateCostMap(arg0_42.id, arg0_42.isCost)
		elseif arg0_42:NeedClear() then
			arg0_42:RemoveAllCellDiscovered()

			arg0_42.clearFlag = false
			arg0_42.isCost = false

			var0_42:UpdateCostMap(arg0_42.id, arg0_42.isCost)
		end

		arg0_42:DispatchEvent(var0_0.EventUpdateActive)
	end
end

function var0_0.InPort(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43:GetPort()

	if not var0_43 or arg2_43 and var0_43.config.port_camp ~= arg2_43 then
		return false
	end

	local var1_43 = arg0_43:GetFleet(arg1_43)

	if var1_43:GetFleetType() == FleetType.Submarine then
		return var0_43.id
	else
		local var2_43 = arg0_43:GetCell(var1_43.row, var1_43.column):GetAliveAttachment()

		if var2_43 and var2_43.type == WorldMapAttachment.TypePort then
			return var2_43.id
		end
	end

	return false
end

function var0_0.canExit(arg0_44)
	return arg0_44.gid and pg.world_chapter_template_reset[arg0_44.gid] ~= nil
end

function var0_0.CheckAttachmentTransport(arg0_45)
	local var0_45 = WorldConst.GetTransportBlockEvent()
	local var1_45 = arg0_45:FindAttachments(WorldMapAttachment.TypeEvent)

	for iter0_45, iter1_45 in ipairs(var1_45) do
		if iter1_45:IsAlive() and var0_45[iter1_45.id] then
			return "block"
		end
	end

	local var2_45 = WorldConst.GetTransportStoryEvent()

	for iter2_45, iter3_45 in ipairs(var1_45) do
		if iter3_45:IsAlive() and var2_45[iter3_45.id] then
			return "story"
		end
	end
end

function var0_0.GetPort(arg0_46, arg1_46)
	return arg1_46 and _.detect(arg0_46.ports, function(arg0_47)
		return arg0_47.id == arg1_46
	end) or arg0_46.ports[1]
end

function var0_0.GetCell(arg0_48, arg1_48, arg2_48)
	local var0_48 = WorldMapCell.GetName(arg1_48, arg2_48)

	return arg0_48.cells[var0_48]
end

function var0_0.CalcTransportPos(arg0_49, arg1_49, arg2_49)
	local var0_49 = calcPositionAngle(arg1_49.config.area_pos[1] - arg2_49.config.area_pos[1], arg1_49.config.area_pos[2] - arg2_49.config.area_pos[2])
	local var1_49 = false

	if not arg0_49.gid then
		var1_49 = true
		arg0_49.gid = arg0_49.config.template_id[1][1]

		arg0_49:SetupGrid(var1_49)
	end

	local var2_49 = {
		row = (arg0_49.top + arg0_49.bottom) / 2,
		column = (arg0_49.left + arg0_49.right) / 2
	}
	local var3_49
	local var4_49 = 4294967295
	local var5_49

	for iter0_49 = arg0_49.left + 1, arg0_49.right - 1 do
		local var6_49 = math.abs(calcPositionAngle(iter0_49 - var2_49.column, var2_49.row - arg0_49.top) - var0_49)

		if var6_49 < var4_49 then
			var3_49 = {
				row = arg0_49.top,
				column = iter0_49
			}
			var4_49 = var6_49
		end

		local var7_49 = math.abs(calcPositionAngle(iter0_49 - var2_49.column, var2_49.row - arg0_49.bottom) - var0_49)

		if var7_49 < var4_49 then
			var3_49 = {
				row = arg0_49.bottom,
				column = iter0_49
			}
			var4_49 = var7_49
		end
	end

	for iter1_49 = arg0_49.top + 1, arg0_49.bottom - 1 do
		local var8_49 = math.abs(calcPositionAngle(arg0_49.left - var2_49.column, var2_49.row - iter1_49) - var0_49)

		if var8_49 < var4_49 then
			var3_49 = {
				row = iter1_49,
				column = arg0_49.left
			}
			var4_49 = var8_49
		end

		local var9_49 = math.abs(calcPositionAngle(arg0_49.right - var2_49.column, var2_49.row - iter1_49) - var0_49)

		if var9_49 < var4_49 then
			var3_49 = {
				row = iter1_49,
				column = arg0_49.right
			}
			var4_49 = var9_49
		end
	end

	if var1_49 then
		arg0_49:DisposeGrid(var1_49)

		arg0_49.gid = nil
	end

	return var3_49
end

function var0_0.AnyFleetInEdge(arg0_50)
	return arg0_50.active and _.any(arg0_50:GetNormalFleets(), function(arg0_51)
		return arg0_51.row == arg0_50.top or arg0_51.row == arg0_50.bottom or arg0_51.column == arg0_50.left or arg0_51.column == arg0_50.right
	end)
end

function var0_0.CheckInteractive(arg0_52, arg1_52)
	local var0_52 = arg0_52:FindAttachments(WorldMapAttachment.TypeEvent)

	for iter0_52, iter1_52 in ipairs(var0_52) do
		if iter1_52:RemainOpEffect() then
			return iter1_52
		end
	end

	for iter2_52, iter3_52 in ipairs(var0_52) do
		if iter3_52:IsAlive() then
			local var1_52 = iter3_52:GetEventEffect()

			if var1_52 and var1_52.autoactivate > 0 then
				return iter3_52
			end
		end
	end

	arg1_52 = arg1_52 or arg0_52:GetFleet()

	local var2_52 = arg0_52:GetCell(arg1_52.row, arg1_52.column)

	if var2_52.discovered then
		local var3_52 = var2_52:GetAliveAttachments()

		for iter4_52, iter5_52 in ipairs(var3_52) do
			if WorldMapAttachment.IsInteractiveType(iter5_52.type) and not iter5_52:IsTriggered() then
				if iter5_52:IsSign() then
					return nil
				elseif iter5_52.type == WorldMapAttachment.TypeEvent then
					local var4_52 = iter5_52:GetEventEffect()

					if var4_52 and (var4_52.effective_num <= 1 or arg0_52:CountEventEffectKeys(var4_52) >= var4_52.effective_num) then
						return iter5_52
					end
				else
					return iter5_52
				end
			end
		end
	end
end

function var0_0.CheckDiscover(arg0_53)
	local var0_53 = {}
	local var1_53 = arg0_53.theme

	for iter0_53, iter1_53 in pairs(arg0_53.cells) do
		if not iter1_53.discovered and iter1_53:GetInFOV() then
			table.insert(var0_53, {
				row = iter1_53.row,
				column = iter1_53.column
			})
		end
	end

	return var0_53
end

function var0_0.CheckDisplay(arg0_54, arg1_54)
	if arg1_54.type == WorldMapAttachment.TypeTrap then
		return true
	end

	return arg0_54:GetCell(arg1_54.row, arg1_54.column):GetDisplayAttachment() == arg1_54
end

function var0_0.GetFOVRange(arg0_55, arg1_55, arg2_55, arg3_55)
	arg2_55 = arg2_55 or arg1_55.row
	arg3_55 = arg3_55 or arg1_55.column

	local var0_55 = arg0_55:GetCell(arg2_55, arg3_55)

	return var0_55:GetTerrain() == WorldMapCell.TerrainFog and var0_55.terrainStrong or arg1_55:GetFOVRange()
end

function var0_0.UpdateVisionFlag(arg0_56, arg1_56)
	arg0_56.visionFlag = arg1_56

	arg0_56:OrderAROpenFOV(arg0_56.visionFlag)
end

function var0_0.UpdatePressingMark(arg0_57, arg1_57)
	if tobool(arg0_57.isPressing) ~= tobool(arg1_57) then
		arg0_57.isPressing = arg1_57

		nowWorld():GetTaskProxy():doUpdateTaskByMap(arg0_57.id, arg1_57)
	end
end

function var0_0.ExistAny(arg0_58, arg1_58, arg2_58)
	return arg0_58:GetCell(arg1_58, arg2_58):GetAliveAttachment() or arg0_58:ExistFleet(arg1_58, arg2_58)
end

function var0_0.ExistFleet(arg0_59, arg1_59, arg2_59)
	return tobool(arg0_59:FindFleet(arg1_59, arg2_59))
end

function var0_0.CalcFleetSpeed(arg0_60, arg1_60)
	local var0_60 = arg1_60:GetSpeed()

	if arg0_60:GetCell(arg1_60.row, arg1_60.column):GetTerrain() == WorldMapCell.TerrainFog then
		var0_60 = math.min(var0_60, 1)
	end

	return var0_60
end

function var0_0.FindPath(arg0_61, arg1_61, arg2_61, arg3_61)
	local var0_61 = var0_0.pathFinder

	if not var0_61 then
		var0_61 = PathFinding.New({}, WorldConst.MaxRow, WorldConst.MaxColumn)
		var0_0.pathFinder = var0_61
	end

	local var1_61 = {}

	for iter0_61 = 0, WorldConst.MaxRow - 1 do
		if not var1_61[iter0_61] then
			var1_61[iter0_61] = {}
		end

		for iter1_61 = 0, WorldConst.MaxColumn - 1 do
			local var2_61 = PathFinding.PrioForbidden

			if arg0_61:IsWalkable(iter0_61, iter1_61) and (not arg3_61 or arg0_61:GetCell(iter0_61, iter1_61):GetInFOV()) then
				var2_61 = PathFinding.PrioNormal

				if iter0_61 == arg2_61.row and iter1_61 == arg2_61.column then
					if not arg0_61:IsStayPoint(iter0_61, iter1_61) then
						var2_61 = PathFinding.PrioObstacle
					end
				elseif arg0_61:IsObstacle(iter0_61, iter1_61) then
					var2_61 = PathFinding.PrioObstacle
				end
			end

			var1_61[iter0_61][iter1_61] = var2_61
		end
	end

	var0_61.cells = var1_61

	return var0_61:Find(arg1_61, arg2_61)
end

function var0_0.FindAIPath(arg0_62, arg1_62, arg2_62)
	local var0_62 = var0_0.pathFinder

	if not var0_62 then
		var0_62 = PathFinding.New({}, WorldConst.MaxRow, WorldConst.MaxColumn)
		var0_0.pathFinder = var0_62
	end

	local var1_62 = {}

	for iter0_62 = 0, WorldConst.MaxRow - 1 do
		if not var1_62[iter0_62] then
			var1_62[iter0_62] = {}
		end

		for iter1_62 = 0, WorldConst.MaxColumn - 1 do
			local var2_62 = PathFinding.PrioForbidden

			if arg0_62:IsWalkable(iter0_62, iter1_62) then
				var2_62 = PathFinding.PrioNormal

				if (iter0_62 ~= arg2_62.row or iter1_62 ~= arg2_62.column) and arg0_62:ExistFleet(iter0_62, iter1_62) then
					var2_62 = PathFinding.PrioObstacle
				end
			end

			var1_62[iter0_62][iter1_62] = var2_62
		end
	end

	var0_62.cells = var1_62

	return var0_62:Find(arg1_62, arg2_62)
end

function var0_0.GetMoveRange(arg0_63, arg1_63)
	local var0_63 = arg1_63.row
	local var1_63 = arg1_63.column
	local var2_63 = arg0_63:CalcFleetSpeed(arg1_63)
	local var3_63 = {}

	for iter0_63 = 0, WorldConst.MaxRow - 1 do
		if not var3_63[iter0_63] then
			var3_63[iter0_63] = {}
		end

		for iter1_63 = 0, WorldConst.MaxColumn - 1 do
			var3_63[iter0_63][iter1_63] = arg0_63:IsWalkable(iter0_63, iter1_63)
		end
	end

	local var4_63 = {}
	local var5_63 = {
		{
			step = 0,
			row = var0_63,
			column = var1_63
		}
	}

	var3_63[var0_63][var1_63] = false

	while #var5_63 > 0 do
		local var6_63 = table.remove(var5_63, 1)

		table.insert(var4_63, var6_63)

		local var7_63 = {
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

		_.each(var7_63, function(arg0_64)
			arg0_64.row = var6_63.row + arg0_64.row
			arg0_64.column = var6_63.column + arg0_64.column
			arg0_64.step = var6_63.step + 1

			if arg0_64.row >= 0 and arg0_64.row < WorldConst.MaxRow and arg0_64.column >= 0 and arg0_64.column < WorldConst.MaxColumn and arg0_64.step <= var2_63 and var3_63[arg0_64.row][arg0_64.column] then
				var3_63[arg0_64.row][arg0_64.column] = false

				if arg0_63:IsObstacle(arg0_64.row, arg0_64.column) then
					table.insert(var4_63, arg0_64)
				else
					table.insert(var5_63, arg0_64)
				end
			end
		end)
	end

	var4_63 = _.filter(var4_63, function(arg0_65)
		return arg0_63:IsStayPoint(arg0_65.row, arg0_65.column)
	end)

	return var4_63
end

function var0_0.BuildLongMoveInfos(arg0_66)
	local var0_66 = {}

	for iter0_66 = 0, WorldConst.MaxRow - 1 do
		var0_66[iter0_66] = var0_66[iter0_66] or {}

		for iter1_66 = 0, WorldConst.MaxColumn - 1 do
			if arg0_66:IsWalkable(iter0_66, iter1_66) and arg0_66:GetCell(iter0_66, iter1_66):GetInFOV() then
				var0_66[iter0_66][iter1_66] = {
					isMark = false,
					isFinish = false,
					row = iter0_66,
					column = iter1_66,
					dp = {},
					last = {},
					isStayPoint = arg0_66:IsStayPoint(iter0_66, iter1_66),
					isObstacle = arg0_66:IsObstacle(iter0_66, iter1_66)
				}
			end
		end
	end

	return var0_66
end

function var0_0.GetLongMoveRange(arg0_67, arg1_67)
	local var0_67 = arg1_67.row
	local var1_67 = arg1_67.column
	local var2_67 = arg0_67:CalcFleetSpeed(arg1_67)
	local var3_67 = arg0_67:BuildLongMoveInfos()
	local var4_67 = {}
	local var5_67 = {}
	local var6_67 = {
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

	local function var7_67(arg0_68, arg1_68, arg2_68)
		return arg0_68 < arg1_68 or arg2_68 < arg0_68
	end

	local function var8_67(arg0_69)
		if not arg0_69 then
			return
		end

		arg0_69.isFinish = true

		table.insert(var4_67, arg0_69)

		if arg0_69.isStayPoint then
			local var0_69 = arg0_69.dp

			for iter0_69 = 1, var2_67 do
				if var0_69[iter0_69] and (not var0_69[0] or var0_69[0] > var0_69[iter0_69] + 1) then
					var0_69[0] = var0_69[iter0_69] + 1
					arg0_69.last[0] = arg0_69.last[iter0_69]
				end
			end
		end
	end

	local var9_67 = var3_67[var0_67][var1_67]

	var9_67.dp[0] = 0
	var9_67.isMark = true

	var8_67(var9_67)

	while var9_67 do
		_.each(var6_67, function(arg0_70)
			if var7_67(var9_67.row + arg0_70.row, 0, WorldConst.MaxRow - 1) or var7_67(var9_67.column + arg0_70.column, 0, WorldConst.MaxColumn - 1) then
				return
			end

			local var0_70 = var3_67[var9_67.row + arg0_70.row][var9_67.column + arg0_70.column]

			if var0_70 and not var0_70.isFinish then
				for iter0_70 = 1, var2_67 do
					if var9_67.dp[iter0_70 - 1] and (not var0_70.dp[iter0_70] or var0_70.dp[iter0_70] > var9_67.dp[iter0_70 - 1]) then
						var0_70.dp[iter0_70] = var9_67.dp[iter0_70 - 1]
						var0_70.last[iter0_70] = {
							var9_67,
							iter0_70 - 1
						}

						if not var0_70.isMark then
							var0_70.isMark = true

							table.insert(var5_67, var0_70)
						end
					end
				end
			end
		end)

		repeat
			var9_67 = table.remove(var5_67, 1)

			var8_67(var9_67)
		until not var9_67 or not var9_67.isObstacle
	end

	local var10_67 = {}

	for iter0_67, iter1_67 in ipairs(var4_67) do
		if iter1_67.dp[0] and iter1_67.dp[0] > 0 then
			table.insert(var10_67, {
				row = iter1_67.row,
				column = iter1_67.column,
				stay = iter1_67.dp[0]
			})
		end
	end

	return var10_67, var3_67
end

function var0_0.IsWalkable(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71:GetCell(arg1_71, arg2_71)

	return var0_71 and var0_71.walkable and (var0_71:CanLeave() or arg0_71:IsStayPoint(arg1_71, arg2_71))
end

function var0_0.IsStayPoint(arg0_72, arg1_72, arg2_72)
	return arg0_72:GetCell(arg1_72, arg2_72):CanArrive() and not arg0_72:ExistFleet(arg1_72, arg2_72)
end

function var0_0.IsObstacle(arg0_73, arg1_73, arg2_73)
	return not arg0_73:GetCell(arg1_73, arg2_73):CanPass()
end

function var0_0.IsSign(arg0_74, arg1_74, arg2_74)
	return arg0_74:GetCell(arg1_74, arg2_74):IsSign()
end

function var0_0.FindNearestBlankPoint(arg0_75, arg1_75, arg2_75)
	local var0_75 = {}

	for iter0_75 = 0, WorldConst.MaxRow - 1 do
		if not var0_75[iter0_75] then
			var0_75[iter0_75] = {}
		end

		for iter1_75 = 0, WorldConst.MaxColumn - 1 do
			var0_75[iter0_75][iter1_75] = arg0_75:IsWalkable(iter0_75, iter1_75)
		end
	end

	local var1_75 = {
		row = arg1_75,
		column = arg2_75
	}
	local var2_75 = {}

	while #var1_75 > 0 do
		local var3_75 = table.remove(var1_75, 1)

		table.insert(var2_75, var3_75)

		local var4_75 = {
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

		_.each(var4_75, function(arg0_76)
			arg0_76.row = var3_75.row + arg0_76.row
			arg0_76.column = var3_75.column + arg0_76.column

			if arg0_76.row >= 0 and arg0_76.row < WorldConst.MaxRow and arg0_76.column >= 0 and arg0_76.column < WorldConst.MaxColumn and not (_.any(var1_75, function(arg0_77)
				return arg0_77.row == arg0_76.row and arg0_77.column == arg0_76.column
			end) or _.any(var2_75, function(arg0_78)
				return arg0_78.row == arg0_76.row and arg0_78.column == arg0_76.column
			end)) and var0_75[arg0_76.row][arg0_76.column] then
				if arg0_75:ExistAny(arg0_76.row, arg0_76.column) then
					table.insert(var1_75, arg0_76)
				else
					return arg0_76
				end
			end
		end)
	end
end

function var0_0.WriteBack(arg0_79, arg1_79, arg2_79)
	local var0_79 = arg0_79:GetFleet()
	local var1_79 = {}

	for iter0_79, iter1_79 in ipairs(var0_79:GetShips(true)) do
		table.insert(var1_79, iter1_79)
	end

	if arg2_79.statistics.submarineAid then
		local var2_79 = arg0_79:GetSubmarineFleet()

		assert(var2_79, "submarine fleet not exist.")

		local var3_79 = var2_79:GetTeamShips(TeamType.Submarine, true)

		for iter2_79, iter3_79 in ipairs(var3_79) do
			table.insert(var1_79, iter3_79)
		end

		var2_79:UseAmmo()
		var2_79:AddDefeatEnemies(arg1_79)
	end

	var0_79:AddDefeatEnemies(arg1_79)
	_.each(var1_79, function(arg0_80)
		local var0_80 = arg2_79.statistics[arg0_80.id]

		if var0_80 then
			arg0_80.hpRant = var0_80.bp
		end

		if arg0_80.hpRant <= 0 then
			arg0_80:Rebirth()
		end
	end)

	local var4_79 = arg0_79:GetCell(var0_79.row, var0_79.column):GetStageEnemy()

	assert(var4_79)

	if arg1_79 then
		var4_79:UpdateFlag(1)

		arg0_79.phaseDisplayList = table.mergeArray(arg0_79.phaseDisplayList, var4_79:SetHP(0))

		local var5_79 = false

		_.each(arg0_79:GetFleets(), function(arg0_81)
			var5_79 = var5_79 or arg0_81:HasDamageLevel()

			arg0_81:ClearDamageLevel()
		end)

		if var5_79 then
			table.insert(arg0_79.phaseDisplayList, 1, {
				story = "W1500",
				hp = var4_79:GetMaxHP()
			})
		end
	else
		arg0_79.isLoss = true

		var0_79:IncDamageLevel(var4_79)
		var4_79:UpdateData(var4_79.data - 1)

		arg0_79.phaseDisplayList = table.mergeArray(arg0_79.phaseDisplayList, var4_79:SetHP(arg2_79.statistics._maxBossHP))

		local var6_79 = nowWorld()

		if var6_79.isAutoFight then
			var6_79:TriggerAutoFight(false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_dead"))
		end
	end

	_.each(arg2_79.hpDropInfo, function(arg0_82)
		local var0_82 = #arg0_79.phaseDisplayList + 1

		for iter0_82, iter1_82 in ipairs(arg0_79.phaseDisplayList) do
			if iter1_82.hp < arg0_82.hp then
				var0_82 = iter0_82

				break
			end
		end

		arg0_79:AddPhaseDisplay({
			hp = arg0_82.hp,
			drops = PlayerConst.addTranDrop(arg0_82.drop_info)
		}, var0_82)
	end)
end

function var0_0.AddPhaseDisplay(arg0_83, arg1_83, arg2_83)
	if arg2_83 then
		table.insert(arg0_83.phaseDisplayList, arg2_83, arg1_83)
	else
		table.insert(arg0_83.phaseDisplayList, arg1_83)
	end
end

function var0_0.FindAttachments(arg0_84, arg1_84, arg2_84)
	local var0_84 = {}

	for iter0_84, iter1_84 in pairs(arg0_84.typeAttachments) do
		if not arg1_84 or arg1_84 == iter0_84 then
			for iter2_84, iter3_84 in ipairs(iter1_84) do
				if not arg2_84 or iter3_84.id == arg2_84 then
					table.insert(var0_84, iter3_84)
				end
			end
		end
	end

	return var0_84
end

function var0_0.FindEnemys(arg0_85)
	local var0_85 = {}

	for iter0_85, iter1_85 in pairs(arg0_85.typeAttachments) do
		if WorldMapAttachment.IsEnemyType(iter0_85) then
			var0_85 = table.mergeArray(var0_85, iter1_85)
		end
	end

	return var0_85
end

function var0_0.GetMapMinMax(arg0_86)
	local var0_86 = Vector2(WorldConst.MaxColumn, WorldConst.MaxRow)
	local var1_86 = Vector2(-WorldConst.MaxColumn, -WorldConst.MaxRow)

	for iter0_86 = 0, WorldConst.MaxRow - 1 do
		for iter1_86 = 0, WorldConst.MaxColumn - 1 do
			if arg0_86:GetCell(iter0_86, iter1_86) then
				var0_86.x = math.min(var0_86.x, iter1_86)
				var0_86.y = math.min(var0_86.y, iter0_86)
				var1_86.x = math.max(var1_86.x, iter1_86)
				var1_86.y = math.max(var1_86.y, iter0_86)
			end
		end
	end

	return var0_86.y, var1_86.y, var0_86.x, var1_86.x
end

function var0_0.GetMapSize(arg0_87)
	local var0_87, var1_87, var2_87, var3_87 = arg0_87:GetMapMinMax()

	return var1_87 - var0_87 + 1, var3_87 - var2_87 + 1
end

function var0_0.CountEventEffectKeys(arg0_88, arg1_88)
	local var0_88 = 0

	for iter0_88, iter1_88 in ipairs(arg0_88:GetNormalFleets()) do
		local var1_88 = arg0_88:GetCell(iter1_88.row, iter1_88.column):GetAliveAttachment()

		if var1_88 and var1_88.type == WorldMapAttachment.TypeEvent and var1_88:GetEventEffect() == arg1_88 then
			var0_88 = var0_88 + 1
		end
	end

	return var0_88
end

function var0_0.EventEffectOpenFOV(arg0_89, arg1_89)
	assert(arg1_89.effect_type == WorldMapAttachment.EffectEventFOV)

	local var0_89, var1_89 = unpack(arg1_89.effect_paramater)
	local var2_89 = var1_89 >= 0

	var1_89 = var2_89 and var1_89 or math.abs(var1_89) - 1

	local var3_89 = arg0_89:FindAttachments(WorldMapAttachment.TypeEvent, var0_89)

	_.each(var3_89, function(arg0_90)
		arg0_89.centerCellFOV = {
			row = arg0_90.row,
			column = arg0_90.column
		}

		for iter0_90 = math.max(arg0_90.row - var1_89, 0), math.min(arg0_90.row + var1_89, WorldConst.MaxRow - 1) do
			for iter1_90 = math.max(arg0_90.column - var1_89, 0), math.min(arg0_90.column + var1_89, WorldConst.MaxColumn - 1) do
				if WorldConst.InFOVRange(arg0_90.row, arg0_90.column, iter0_90, iter1_90, var1_89) then
					local var0_90 = arg0_89:GetCell(iter0_90, iter1_90)

					if var0_90 then
						if var2_89 then
							var0_90:UpdateInFov(bit.bor(var0_90.infov, WorldConst.FOVEventEffect))
						else
							var0_90:UpdateInFov(bit.band(var0_90.infov, WorldConst.Flag16Max - WorldConst.FOVEventEffect))
						end
					end
				end
			end
		end
	end)
end

function var0_0.OrderAROpenFOV(arg0_91, arg1_91)
	if arg1_91 then
		local var0_91 = arg0_91:GetFleet()

		arg0_91.centerCellFOV = {
			row = var0_91.row,
			column = var0_91.column
		}
	end

	for iter0_91, iter1_91 in pairs(arg0_91.cells) do
		if arg1_91 then
			iter1_91:UpdateInFov(bit.bor(iter1_91.infov, WorldConst.FOVEventEffect))
		else
			iter1_91:UpdateInFov(bit.band(iter1_91.infov, WorldConst.Flag16Max - WorldConst.FOVEventEffect))
		end
	end
end

function var0_0.GetMaxDistanceCell(arg0_92, arg1_92, arg2_92)
	local var0_92
	local var1_92 = 0
	local var2_92 = {
		{
			row = arg0_92.top,
			column = arg0_92.left
		},
		{
			row = arg0_92.bottom,
			column = arg0_92.left
		},
		{
			row = arg0_92.top,
			column = arg0_92.right
		},
		{
			row = arg0_92.bottom,
			column = arg0_92.right
		}
	}

	for iter0_92, iter1_92 in pairs(var2_92) do
		local var3_92 = (iter1_92.row - arg1_92) * (iter1_92.row - arg1_92) + (iter1_92.column - arg2_92) * (iter1_92.column - arg2_92)

		if var1_92 < var3_92 then
			var0_92 = iter1_92
			var1_92 = var3_92
		end
	end

	return var0_92, math.sqrt(var1_92)
end

function var0_0.GetCellsInFOV(arg0_93)
	local var0_93 = {}

	for iter0_93, iter1_93 in pairs(arg0_93.cells) do
		if iter1_93:GetInFOV() then
			table.insert(var0_93, iter1_93)
		end
	end

	return var0_93
end

function var0_0.AlwaysInFOV(arg0_94)
	return arg0_94.config.map_sight == 1
end

function var0_0.GetEventTipWord(arg0_95)
	local var0_95 = arg0_95:FindAttachments(WorldMapAttachment.TypeEvent)
	local var1_95 = ""
	local var2_95 = 0

	for iter0_95, iter1_95 in ipairs(var0_95) do
		local var3_95 = pg.world_event_desc[iter1_95.id]

		if iter1_95:IsAlive() and var3_95 and var2_95 < var3_95.hint_pri then
			var2_95 = var3_95.hint_pri
			var1_95 = var3_95.hint
		end
	end

	return var1_95, var2_95
end

function var0_0.GetEventPoisonRate(arg0_96)
	local var0_96 = arg0_96:FindAttachments(WorldMapAttachment.TypeEvent)
	local var1_96 = 0

	for iter0_96, iter1_96 in ipairs(var0_96) do
		if iter1_96:IsAlive() then
			var1_96 = var1_96 + iter1_96.config.infection_value
		end
	end

	return var1_96, arg0_96.config.is_sairen
end

function var0_0.GetPressingLevel(arg0_97)
	return arg0_97.config.complete_effect
end

function var0_0.CheckMapPressing(arg0_98)
	return arg0_98:GetPressingLevel() > 0 and not arg0_98.isPressing and arg0_98:GetEventPoisonRate() == 0
end

function var0_0.CheckMapPressingDisplay(arg0_99)
	return arg0_99:GetPressingLevel() > 1
end

function var0_0.UpdateClearFlag(arg0_100, arg1_100)
	arg0_100.clearFlag = tobool(arg1_100)
end

function var0_0.IsUnlockFleetMode(arg0_101)
	if arg0_101.config.move_switch == 1 then
		return true
	elseif arg0_101.config.move_switch == 0 then
		return false
	else
		assert(false, "config error")
	end
end

function var0_0.CheckFleetSalvage(arg0_102, arg1_102)
	local var0_102 = underscore.detect(arg0_102:GetFleets(), function(arg0_103)
		return arg0_103:IsCatSalvage() and (arg1_102 or arg0_103:IsSalvageFinish() or arg0_102.salvageAutoResult or arg0_103.catSalvageFrom ~= arg0_102.id)
	end)

	if var0_102 then
		return var0_102.id
	else
		arg0_102.salvageAutoResult = false
	end
end

function var0_0.GetChapterAuraBuffs(arg0_104)
	local var0_104 = {}

	for iter0_104, iter1_104 in ipairs(arg0_104.fleets) do
		local var1_104 = iter1_104:getMapAura()

		for iter2_104, iter3_104 in ipairs(var1_104) do
			table.insert(var0_104, iter3_104)
		end
	end

	return var0_104
end

function var0_0.GetChapterAidBuffs(arg0_105)
	local var0_105 = {}

	for iter0_105, iter1_105 in ipairs(arg0_105.fleets) do
		if iter0_105 ~= arg0_105.findex then
			local var1_105 = iter1_105:getMapAid()

			for iter2_105, iter3_105 in pairs(var1_105) do
				var0_105[iter2_105] = iter3_105
			end
		end
	end

	return var0_105
end

function var0_0.getFleetBattleBuffs(arg0_106, arg1_106, arg2_106)
	local var0_106 = {}

	underscore.each(arg1_106:GetBuffList(), function(arg0_107)
		local var0_107 = arg0_107.config.lua_id

		if var0_107 ~= 0 then
			table.insert(var0_106, var0_107)
		end
	end)

	local var1_106 = {}

	if arg2_106 and arg1_106:IsCatSalvage() then
		-- block empty
	else
		var1_106 = arg0_106:BuildBattleBuffList(arg1_106)
	end

	return var0_106, var1_106
end

function var0_0.BuildBattleBuffList(arg0_108, arg1_108)
	local var0_108 = {}
	local var1_108, var2_108 = arg0_108:triggerSkill(arg1_108, FleetSkill.TypeBattleBuff)

	if var1_108 and #var1_108 > 0 then
		local var3_108 = {}

		for iter0_108, iter1_108 in ipairs(var1_108) do
			local var4_108 = var2_108[iter0_108]
			local var5_108 = arg1_108:findCommanderBySkillId(var4_108.id)

			var3_108[var5_108] = var3_108[var5_108] or {}

			table.insert(var3_108[var5_108], iter1_108)
		end

		for iter2_108, iter3_108 in pairs(var3_108) do
			table.insert(var0_108, {
				iter2_108,
				iter3_108
			})
		end
	end

	local var6_108 = arg1_108:getCommanders()

	for iter4_108, iter5_108 in pairs(var6_108) do
		local var7_108 = iter5_108:getTalents()

		for iter6_108, iter7_108 in ipairs(var7_108) do
			local var8_108 = iter7_108:getBuffsAddition()

			if #var8_108 > 0 then
				local var9_108

				for iter8_108, iter9_108 in ipairs(var0_108) do
					if iter9_108[1] == iter5_108 then
						var9_108 = iter9_108[2]

						break
					end
				end

				if not var9_108 then
					var9_108 = {}

					table.insert(var0_108, {
						iter5_108,
						var9_108
					})
				end

				for iter10_108, iter11_108 in ipairs(var8_108) do
					table.insert(var9_108, iter11_108)
				end
			end
		end
	end

	return var0_108
end

function var0_0.CanLongMove(arg0_109, arg1_109)
	return arg0_109:IsUnlockFleetMode() and not arg1_109:HasTrapBuff() and arg0_109:GetFleetTerrain(arg1_109) ~= WorldMapCell.TerrainFog
end

function var0_0.triggerSkill(arg0_110, arg1_110, arg2_110)
	local var0_110 = _.filter(arg1_110:findSkills(arg2_110), function(arg0_111)
		local var0_111 = arg0_111:GetTriggers()

		return _.any(var0_111, function(arg0_112)
			return arg0_112[1] == FleetSkill.TriggerInSubTeam and arg0_112[2] == 1
		end) == (arg1_110:GetFleetType() == FleetType.Submarine) and _.all(arg0_111:GetTriggers(), function(arg0_113)
			return arg0_110:triggerCheck(arg1_110, arg0_111, arg0_113)
		end)
	end)

	return _.reduce(var0_110, nil, function(arg0_114, arg1_114)
		local var0_114 = arg1_114:GetType()
		local var1_114 = arg1_114:GetArgs()

		if var0_114 == FleetSkill.TypeMoveSpeed or var0_114 == FleetSkill.TypeHuntingLv or var0_114 == FleetSkill.TypeTorpedoPowerUp then
			return (arg0_114 or 0) + var1_114[1]
		elseif var0_114 == FleetSkill.TypeAmbushDodge or var0_114 == FleetSkill.TypeAirStrikeDodge then
			return math.max(arg0_114 or 0, var1_114[1])
		elseif var0_114 == FleetSkill.TypeAttack or var0_114 == FleetSkill.TypeStrategy then
			arg0_114 = arg0_114 or {}

			table.insert(arg0_114, var1_114)

			return arg0_114
		elseif var0_114 == FleetSkill.TypeBattleBuff then
			arg0_114 = arg0_114 or {}

			table.insert(arg0_114, var1_114[1])

			return arg0_114
		end
	end), var0_110
end

function var0_0.triggerCheck(arg0_115, arg1_115, arg2_115, arg3_115)
	local var0_115 = arg3_115[1]

	if var0_115 == FleetSkill.TriggerDDHead then
		local var1_115 = arg1_115:GetTeamShipVOs(TeamType.Vanguard, false)

		return #var1_115 > 0 and ShipType.IsTypeQuZhu(var1_115[1]:getShipType())
	elseif var0_115 == FleetSkill.TriggerVanCount then
		local var2_115 = arg1_115:GetTeamShipVOs(TeamType.Vanguard, false)

		return #var2_115 >= arg3_115[2] and #var2_115 <= arg3_115[3]
	elseif var0_115 == FleetSkill.TriggerShipCount then
		local var3_115 = _.filter(arg1_115:GetShipVOs(false), function(arg0_116)
			return table.contains(arg3_115[2], arg0_116:getShipType())
		end)

		return #var3_115 >= arg3_115[3] and #var3_115 <= arg3_115[4]
	elseif var0_115 == FleetSkill.TriggerAroundEnemy then
		local var4_115 = {
			row = arg1_115.row,
			column = arg1_115.column
		}
		local var5_115 = {}
		local var6_115 = arg3_115[2]

		for iter0_115 = -var6_115, var6_115 do
			local var7_115 = var6_115 - math.abs(iter0_115)

			for iter1_115 = -var7_115, var7_115 do
				local var8_115 = arg0_115:GetCell(var4_115.row + iter0_115, var4_115.column + iter1_115)

				table.insert(var5_115, var8_115)
			end
		end

		return underscore.any(var5_115, function(arg0_117)
			local var0_117 = arg0_117:ExistEnemy() and arg0_117:GetStageEnemy().config.type or nil

			return type(arg3_115[3]) == "number" and arg3_115[3] == var0_117 or type(arg3_115[3]) == "table" and table.contains(arg3_115[3], var0_117)
		end)
	elseif var0_115 == FleetSkill.TriggerNekoPos then
		local var9_115 = arg1_115:findCommanderBySkillId(arg2_115.id)

		for iter2_115, iter3_115 in pairs(arg1_115:getCommanders()) do
			if var9_115.id == iter3_115.id and iter2_115 == arg3_115[2] then
				return true
			end
		end
	elseif var0_115 == FleetSkill.TriggerAroundLand then
		local var10_115 = {
			row = arg1_115.row,
			column = arg1_115.column
		}
		local var11_115 = arg3_115[2]

		for iter4_115 = -var11_115, var11_115 do
			local var12_115 = var11_115 - math.abs(iter4_115)

			for iter5_115 = -var12_115, var12_115 do
				local var13_115 = var10_115.row + iter4_115
				local var14_115 = var10_115.column + iter5_115

				if arg0_115:GetCell(var13_115, var14_115) and not arg0_115:IsWalkable(var13_115, var14_115) then
					return true
				end
			end
		end

		return false
	elseif var0_115 == FleetSkill.TriggerAroundCombatAlly then
		local var15_115 = {
			row = arg1_115.row,
			column = arg1_115.column
		}

		return _.any(arg0_115.fleets, function(arg0_118)
			return arg1_115.id ~= arg0_118.id and arg0_118:GetFleetType() == FleetType.Normal and arg0_115:GetCell(arg0_118.line.row, arg0_118.line.column):ExistEnemy() and ManhattonDist(var15_115, {
				row = arg0_118.line.row,
				column = arg0_118.line.column
			}) <= arg3_115[2]
		end)
	elseif var0_115 == FleetSkill.TriggerInSubTeam then
		return true
	else
		assert(false, "invalid trigger type: " .. var0_115)
	end
end

function var0_0.OnUpdateAttachmentExist(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = arg3_119.type

	arg0_119.typeAttachments[var0_119] = arg0_119.typeAttachments[var0_119] or {}

	if arg1_119 == WorldMapCell.EventAddAttachment then
		table.insert(arg0_119.typeAttachments[var0_119], arg3_119)
	elseif arg1_119 == WorldMapCell.EventRemoveAttachment then
		table.removebyvalue(arg0_119.typeAttachments[var0_119], arg3_119)
	end

	local var1_119 = arg3_119:GetVisionRadius()

	if var1_119 > 0 then
		local var2_119 = 0

		if arg1_119 == WorldMapCell.EventAddAttachment then
			var2_119 = var2_119 + 1
		elseif arg1_119 == WorldMapCell.EventRemoveAttachment then
			var2_119 = var2_119 - 1
		else
			assert(false, "listener event error: " .. arg1_119)
		end

		arg0_119.centerCellFOV = {
			row = arg2_119.row,
			column = arg2_119.column
		}

		for iter0_119 = arg2_119.row - var1_119, arg2_119.row + var1_119 do
			for iter1_119 = arg2_119.column - var1_119, arg2_119.column + var1_119 do
				local var3_119 = arg0_119:GetCell(iter0_119, iter1_119)

				if var3_119 and WorldConst.InFOVRange(arg2_119.row, arg2_119.column, var3_119.row, var3_119.column, var1_119) then
					var3_119:ChangeInLight(var2_119 > 0)
				end
			end
		end
	end

	local var4_119 = arg3_119:GetRadiationBuffs()

	if #var4_119 > 0 then
		local var5_119 = {}

		for iter2_119, iter3_119 in ipairs(var4_119) do
			local var6_119, var7_119, var8_119 = unpack(iter3_119)

			if arg1_119 == WorldMapCell.EventAddAttachment then
				var5_119[var6_119] = true

				arg0_119:AddBuff(var6_119, var7_119, var8_119)
			elseif arg1_119 == WorldMapCell.EventRemoveAttachment then
				var5_119[var6_119] = true

				arg0_119:RemoveBuff(var6_119, var7_119, var8_119)
			end
		end

		for iter4_119, iter5_119 in pairs(var5_119) do
			if iter5_119 then
				arg0_119:FlushFaction(iter4_119)
			end
		end
	end
end

function var0_0.GetBGM(arg0_120)
	return arg0_120.config.bgm
end

function var0_0.NeedClear(arg0_121)
	local var0_121, var1_121 = arg0_121:GetEventPoisonRate()

	return var1_121 > 0 and var0_121 == 0 or arg0_121.clearFlag or arg0_121.config.is_clear > 0
end

function var0_0.GetBuff(arg0_122, arg1_122, arg2_122)
	if not arg0_122.factionBuffs[arg1_122][arg2_122] then
		arg0_122.factionBuffs[arg1_122][arg2_122] = WorldBuff.New()

		arg0_122.factionBuffs[arg1_122][arg2_122]:Setup({
			floor = 0,
			id = arg2_122
		})
	end

	return arg0_122.factionBuffs[arg1_122][arg2_122]
end

function var0_0.AddBuff(arg0_123, arg1_123, arg2_123, arg3_123)
	arg0_123:GetBuff(arg1_123, arg2_123):AddFloor(arg3_123)
end

function var0_0.RemoveBuff(arg0_124, arg1_124, arg2_124, arg3_124)
	local var0_124 = arg0_124:GetBuff(arg1_124, arg2_124)

	if arg3_124 then
		var0_124:AddFloor(arg3_124 * -1)
	else
		arg0_124.factionBuffs[arg1_124][arg2_124] = nil
	end
end

function var0_0.GetBuffList(arg0_125, arg1_125, arg2_125)
	if arg1_125 == var0_0.FactionSelf then
		return underscore.filter(underscore.values(arg0_125.factionBuffs[arg1_125]), function(arg0_126)
			return arg0_126:GetFloor() > 0
		end)
	elseif arg1_125 == var0_0.FactionEnemy then
		if WorldMapAttachment.IsEnemyType(arg2_125.type) or arg2_125.type == WorldMapAttachment.TypeEvent and arg2_125:GetSpEventType() == WorldMapAttachment.SpEventEnemy then
			return underscore.filter(underscore.values(arg0_125.factionBuffs[arg1_125]), function(arg0_127)
				return arg0_127:GetFloor() > 0
			end)
		else
			return {}
		end
	else
		assert(false, string.format("faction error: $d", arg1_125))
	end
end

function var0_0.FlushFaction(arg0_128, arg1_128)
	if arg1_128 == var0_0.FactionSelf then
		underscore.each(arg0_128:GetFleets(), function(arg0_129)
			arg0_129:DispatchEvent(WorldMapFleet.EventUpdateBuff)
		end)
	elseif arg1_128 == var0_0.FactionEnemy then
		local var0_128 = {}

		underscore.each(arg0_128:FindEnemys(), function(arg0_130)
			var0_128[WorldMapCell.GetName(arg0_130.row, arg0_130.column)] = true
		end)
		underscore.each(arg0_128:FindAttachments(WorldMapAttachment.TypeEvent), function(arg0_131)
			if arg0_131:GetSpEventType() == WorldMapAttachment.SpEventEnemy then
				var0_128[WorldMapCell.GetName(arg0_131.row, arg0_131.column)] = true
			end
		end)

		for iter0_128 in pairs(var0_128) do
			arg0_128.cells[iter0_128]:DispatchEvent(var0_0.EventUpdateMapBuff)
		end
	else
		assert(false, string.format("faction error: $d", arg1_128))
	end
end

function var0_0.GetBattleLuaBuffs(arg0_132, arg1_132, arg2_132)
	local var0_132 = {}

	underscore.each(arg0_132:GetBuffList(arg1_132, arg2_132), function(arg0_133)
		if arg0_133.config.lua_id > 0 then
			table.insert(var0_132, arg0_133.config.lua_id)
		end
	end)

	return var0_132
end

function var0_0.UpdateFleetLocation(arg0_134, arg1_134, arg2_134, arg3_134)
	local var0_134 = arg0_134:GetFleet(arg1_134)

	assert(var0_134, "without this fleet : " .. arg1_134)

	if var0_134.row ~= arg2_134 or var0_134.column ~= arg3_134 then
		arg0_134:CheckFleetUpdateFOV(var0_134, function()
			var0_134.row = arg2_134
			var0_134.column = arg3_134
		end)
		var0_134:DispatchEvent(WorldMapFleet.EventUpdateLocation)
	end
end

function var0_0.GetRangeDic(arg0_136, arg1_136)
	local var0_136 = {}

	WorldConst.RangeCheck(arg1_136, arg0_136:GetFOVRange(arg1_136), function(arg0_137, arg1_137)
		local var0_137 = WorldMapCell.GetName(arg0_137, arg1_137)

		if arg0_136.cells[var0_137] then
			var0_136[var0_137] = defaultValue(var0_136[var0_137], 0) + 1
		end
	end)

	return var0_136
end

function var0_0.CheckFleetUpdateFOV(arg0_138, arg1_138, arg2_138)
	if not arg0_138:IsValid() then
		arg2_138()

		return
	end

	local var0_138 = arg0_138:GetRangeDic(arg1_138)
	local var1_138 = arg0_138:GetFleetTerrain(arg1_138) == WorldMapCell.TerrainFog
	local var2_138 = arg0_138:IsFleetTerrainSairenFog(arg1_138)
	local var3_138 = arg0_138:CalcFleetSpeed(arg1_138)

	arg2_138()

	local var4_138 = arg0_138:GetRangeDic(arg1_138)
	local var5_138 = arg0_138:GetFleetTerrain(arg1_138) == WorldMapCell.TerrainFog
	local var6_138 = arg0_138:IsFleetTerrainSairenFog(arg1_138)
	local var7_138 = arg0_138:CalcFleetSpeed(arg1_138)

	arg0_138.centerCellFOV = {
		row = arg1_138.row,
		column = arg1_138.column
	}

	local var8_138 = false
	local var9_138 = false
	local var10_138 = {}

	if not var1_138 then
		for iter0_138, iter1_138 in pairs(var0_138) do
			var10_138[iter0_138] = defaultValue(var10_138[iter0_138], 0) - iter1_138
		end
	end

	if not var5_138 then
		for iter2_138, iter3_138 in pairs(var4_138) do
			var10_138[iter2_138] = defaultValue(var10_138[iter2_138], 0) + iter3_138
		end
	end

	for iter4_138, iter5_138 in pairs(var10_138) do
		if iter5_138 ~= 0 then
			arg0_138.cells[iter4_138]:ChangeInLight(iter5_138 > 0)

			var8_138 = true
		end
	end

	if arg0_138:GetFleet() == arg1_138 then
		local var11_138 = {}

		if var1_138 then
			for iter6_138, iter7_138 in pairs(var0_138) do
				var11_138[iter6_138] = defaultValue(var11_138[iter6_138], 0) - iter7_138
			end
		end

		if var5_138 then
			for iter8_138, iter9_138 in pairs(var4_138) do
				var11_138[iter8_138] = defaultValue(var11_138[iter8_138], 0) + iter9_138
			end
		end

		if var1_138 ~= var5_138 or var2_138 ~= var6_138 then
			for iter10_138, iter11_138 in pairs(arg0_138.cells) do
				local var12_138

				if var11_138[iter10_138] and var11_138[iter10_138] ~= 0 then
					var12_138 = var11_138[iter10_138] > 0
				end

				iter11_138:UpdateFog(var5_138, var12_138, var6_138)
			end

			var8_138 = true
		else
			for iter12_138, iter13_138 in pairs(var11_138) do
				if iter13_138 ~= 0 then
					arg0_138.cells[iter12_138]:UpdateFog(nil, iter13_138 > 0, nil)

					var8_138 = true
				end
			end
		end

		if var3_138 ~= var7_138 then
			var9_138 = true
		end
	end

	if var8_138 then
		arg0_138:DispatchEvent(var0_0.EventUpdateFleetFOV)
	end

	if var9_138 then
		arg0_138:DispatchEvent(var0_0.EventUpdateMoveSpeed)
	end
end

function var0_0.CheckSelectFleetUpdateFog(arg0_139, arg1_139)
	if not arg0_139:IsValid() then
		arg1_139()

		return
	end

	local var0_139 = arg0_139:GetFleet()
	local var1_139 = arg0_139:GetRangeDic(var0_139)
	local var2_139 = arg0_139:GetFleetTerrain(var0_139) == WorldMapCell.TerrainFog
	local var3_139 = arg0_139:IsFleetTerrainSairenFog(var0_139)

	arg1_139()

	local var4_139 = arg0_139:GetFleet()
	local var5_139 = arg0_139:GetRangeDic(var4_139)
	local var6_139 = arg0_139:GetFleetTerrain(var4_139) == WorldMapCell.TerrainFog
	local var7_139 = arg0_139:IsFleetTerrainSairenFog(var4_139)

	arg0_139.centerCellFOV = {
		row = var4_139.row,
		column = var4_139.column
	}

	local var8_139 = {}

	if var2_139 then
		for iter0_139, iter1_139 in pairs(var1_139) do
			var8_139[iter0_139] = defaultValue(var8_139[iter0_139], 0) - iter1_139
		end
	end

	if var6_139 then
		for iter2_139, iter3_139 in pairs(var5_139) do
			var8_139[iter2_139] = defaultValue(var8_139[iter2_139], 0) + iter3_139
		end
	end

	if var2_139 ~= var6_139 or var3_139 ~= var7_139 then
		for iter4_139, iter5_139 in pairs(arg0_139.cells) do
			local var9_139

			if var8_139[iter4_139] and var8_139[iter4_139] ~= 0 then
				var9_139 = var8_139[iter4_139] > 0
			end

			iter5_139:UpdateFog(var6_139, var9_139, var7_139)
		end
	else
		for iter6_139, iter7_139 in pairs(var8_139) do
			if iter7_139 ~= 0 then
				arg0_139.cells[iter6_139]:UpdateFog(nil, iter7_139 > 0, nil)
			end
		end
	end

	arg0_139:DispatchEvent(var0_0.EventUpdateFleetFOV)
end

function var0_0.CheckEventAutoTrigger(arg0_140, arg1_140)
	if arg1_140:GetSpEventType() == WorldMapAttachment.SpEventConsumeItem then
		return getProxy(SettingsProxy):GetWorldFlag("consume_item")
	end

	local var0_140 = arg1_140:GetEventEffect()

	if var0_140 then
		local var1_140 = arg0_140:GetFleet()
		local var2_140 = var0_140.effect_type

		if var2_140 == WorldMapAttachment.EffectEventConsumeCarry then
			local var3_140 = var0_140.effect_paramater[1] or {}

			return not underscore.any(var3_140, function(arg0_141)
				return not var1_140:ExistCarry(arg0_141)
			end)
		elseif var2_140 == WorldMapAttachment.EffectEventCatSalvage then
			return var1_140:GetDisplayCommander() and not var1_140:IsCatSalvage()
		end
	end

	return true
end

function var0_0.CanAutoFight(arg0_142)
	if arg0_142.config.is_auto > 0 then
		for iter0_142 = 1, arg0_142.config.is_auto do
			if not nowWorld():IsSystemOpen(WorldConst["SystemAutoFight_" .. iter0_142]) then
				return false
			end
		end

		return true
	else
		return false
	end
end

function var0_0.CkeckTransport(arg0_143)
	assert(arg0_143:IsValid(), "without map info")

	if arg0_143.config.is_transfer == 0 then
		return false, i18n("world_transport_disable")
	end

	if arg0_143:CheckAttachmentTransport() == "block" then
		return false, i18n("world_movelimit_event_text")
	end

	if nowWorld():CheckTaskLockMap() then
		return false, i18n("world_task_maplock")
	end

	return true
end

return var0_0
