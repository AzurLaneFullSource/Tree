local var0_0 = class("WorldMap", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	cells = "table",
	gid = "number",
	isDelegated = "boolean",
	findex = "number",
	phaseDisplayList = "table",
	isPressing = "boolean",
	salvageAutoResult = "boolean",
	id = "number",
	valid = "boolean",
	clearFlag = "boolean",
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
	return string.format("地图 [%s] [id: %s] [gid: %s] [危险度: %s] [是否委派：%s] [是否压制：%s]", arg0_1.config.name, arg0_1.id, tostring(arg0_1.gid), arg0_1:GetDanger(), arg0_1.isDelegated, arg0_1.isPressing)
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
	return underscore.to_array(arg0_26.fleets)
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

function var0_0.UpdateDeteagtedMark(arg0_57, arg1_57)
	if tobool(arg0_57.isDelegated) ~= tobool(arg1_57) then
		arg0_57.isDelegated = arg1_57
	end
end

function var0_0.UpdatePressingMark(arg0_58, arg1_58)
	if tobool(arg0_58.isPressing) ~= tobool(arg1_58) then
		arg0_58.isPressing = arg1_58

		nowWorld():GetTaskProxy():doUpdateTaskByMap(arg0_58.id, arg1_58)
	end
end

function var0_0.ExistAny(arg0_59, arg1_59, arg2_59)
	return arg0_59:GetCell(arg1_59, arg2_59):GetAliveAttachment() or arg0_59:ExistFleet(arg1_59, arg2_59)
end

function var0_0.ExistFleet(arg0_60, arg1_60, arg2_60)
	return tobool(arg0_60:FindFleet(arg1_60, arg2_60))
end

function var0_0.CalcFleetSpeed(arg0_61, arg1_61)
	local var0_61 = arg1_61:GetSpeed()

	if arg0_61:GetCell(arg1_61.row, arg1_61.column):GetTerrain() == WorldMapCell.TerrainFog then
		var0_61 = math.min(var0_61, 1)
	end

	return var0_61
end

function var0_0.FindPath(arg0_62, arg1_62, arg2_62, arg3_62)
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

			if arg0_62:IsWalkable(iter0_62, iter1_62) and (not arg3_62 or arg0_62:GetCell(iter0_62, iter1_62):GetInFOV()) then
				var2_62 = PathFinding.PrioNormal

				if iter0_62 == arg2_62.row and iter1_62 == arg2_62.column then
					if not arg0_62:IsStayPoint(iter0_62, iter1_62) then
						var2_62 = PathFinding.PrioObstacle
					end
				elseif arg0_62:IsObstacle(iter0_62, iter1_62) then
					var2_62 = PathFinding.PrioObstacle
				end
			end

			var1_62[iter0_62][iter1_62] = var2_62
		end
	end

	var0_62.cells = var1_62

	return var0_62:Find(arg1_62, arg2_62)
end

function var0_0.FindAIPath(arg0_63, arg1_63, arg2_63)
	local var0_63 = var0_0.pathFinder

	if not var0_63 then
		var0_63 = PathFinding.New({}, WorldConst.MaxRow, WorldConst.MaxColumn)
		var0_0.pathFinder = var0_63
	end

	local var1_63 = {}

	for iter0_63 = 0, WorldConst.MaxRow - 1 do
		if not var1_63[iter0_63] then
			var1_63[iter0_63] = {}
		end

		for iter1_63 = 0, WorldConst.MaxColumn - 1 do
			local var2_63 = PathFinding.PrioForbidden

			if arg0_63:IsWalkable(iter0_63, iter1_63) then
				var2_63 = PathFinding.PrioNormal

				if (iter0_63 ~= arg2_63.row or iter1_63 ~= arg2_63.column) and arg0_63:ExistFleet(iter0_63, iter1_63) then
					var2_63 = PathFinding.PrioObstacle
				end
			end

			var1_63[iter0_63][iter1_63] = var2_63
		end
	end

	var0_63.cells = var1_63

	return var0_63:Find(arg1_63, arg2_63)
end

function var0_0.GetMoveRange(arg0_64, arg1_64)
	local var0_64 = arg1_64.row
	local var1_64 = arg1_64.column
	local var2_64 = arg0_64:CalcFleetSpeed(arg1_64)
	local var3_64 = {}

	for iter0_64 = 0, WorldConst.MaxRow - 1 do
		if not var3_64[iter0_64] then
			var3_64[iter0_64] = {}
		end

		for iter1_64 = 0, WorldConst.MaxColumn - 1 do
			var3_64[iter0_64][iter1_64] = arg0_64:IsWalkable(iter0_64, iter1_64)
		end
	end

	local var4_64 = {}
	local var5_64 = {
		{
			step = 0,
			row = var0_64,
			column = var1_64
		}
	}

	var3_64[var0_64][var1_64] = false

	while #var5_64 > 0 do
		local var6_64 = table.remove(var5_64, 1)

		table.insert(var4_64, var6_64)

		local var7_64 = {
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

		_.each(var7_64, function(arg0_65)
			arg0_65.row = var6_64.row + arg0_65.row
			arg0_65.column = var6_64.column + arg0_65.column
			arg0_65.step = var6_64.step + 1

			if arg0_65.row >= 0 and arg0_65.row < WorldConst.MaxRow and arg0_65.column >= 0 and arg0_65.column < WorldConst.MaxColumn and arg0_65.step <= var2_64 and var3_64[arg0_65.row][arg0_65.column] then
				var3_64[arg0_65.row][arg0_65.column] = false

				if arg0_64:IsObstacle(arg0_65.row, arg0_65.column) then
					table.insert(var4_64, arg0_65)
				else
					table.insert(var5_64, arg0_65)
				end
			end
		end)
	end

	var4_64 = _.filter(var4_64, function(arg0_66)
		return arg0_64:IsStayPoint(arg0_66.row, arg0_66.column)
	end)

	return var4_64
end

function var0_0.BuildLongMoveInfos(arg0_67)
	local var0_67 = {}

	for iter0_67 = 0, WorldConst.MaxRow - 1 do
		var0_67[iter0_67] = var0_67[iter0_67] or {}

		for iter1_67 = 0, WorldConst.MaxColumn - 1 do
			if arg0_67:IsWalkable(iter0_67, iter1_67) and arg0_67:GetCell(iter0_67, iter1_67):GetInFOV() then
				var0_67[iter0_67][iter1_67] = {
					isMark = false,
					isFinish = false,
					row = iter0_67,
					column = iter1_67,
					dp = {},
					last = {},
					isStayPoint = arg0_67:IsStayPoint(iter0_67, iter1_67),
					isObstacle = arg0_67:IsObstacle(iter0_67, iter1_67)
				}
			end
		end
	end

	return var0_67
end

function var0_0.GetLongMoveRange(arg0_68, arg1_68)
	local var0_68 = arg1_68.row
	local var1_68 = arg1_68.column
	local var2_68 = arg0_68:CalcFleetSpeed(arg1_68)
	local var3_68 = arg0_68:BuildLongMoveInfos()
	local var4_68 = {}
	local var5_68 = {}
	local var6_68 = {
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

	local function var7_68(arg0_69, arg1_69, arg2_69)
		return arg0_69 < arg1_69 or arg2_69 < arg0_69
	end

	local function var8_68(arg0_70)
		if not arg0_70 then
			return
		end

		arg0_70.isFinish = true

		table.insert(var4_68, arg0_70)

		if arg0_70.isStayPoint then
			local var0_70 = arg0_70.dp

			for iter0_70 = 1, var2_68 do
				if var0_70[iter0_70] and (not var0_70[0] or var0_70[0] > var0_70[iter0_70] + 1) then
					var0_70[0] = var0_70[iter0_70] + 1
					arg0_70.last[0] = arg0_70.last[iter0_70]
				end
			end
		end
	end

	local var9_68 = var3_68[var0_68][var1_68]

	var9_68.dp[0] = 0
	var9_68.isMark = true

	var8_68(var9_68)

	while var9_68 do
		_.each(var6_68, function(arg0_71)
			if var7_68(var9_68.row + arg0_71.row, 0, WorldConst.MaxRow - 1) or var7_68(var9_68.column + arg0_71.column, 0, WorldConst.MaxColumn - 1) then
				return
			end

			local var0_71 = var3_68[var9_68.row + arg0_71.row][var9_68.column + arg0_71.column]

			if var0_71 and not var0_71.isFinish then
				for iter0_71 = 1, var2_68 do
					if var9_68.dp[iter0_71 - 1] and (not var0_71.dp[iter0_71] or var0_71.dp[iter0_71] > var9_68.dp[iter0_71 - 1]) then
						var0_71.dp[iter0_71] = var9_68.dp[iter0_71 - 1]
						var0_71.last[iter0_71] = {
							var9_68,
							iter0_71 - 1
						}

						if not var0_71.isMark then
							var0_71.isMark = true

							table.insert(var5_68, var0_71)
						end
					end
				end
			end
		end)

		repeat
			var9_68 = table.remove(var5_68, 1)

			var8_68(var9_68)
		until not var9_68 or not var9_68.isObstacle
	end

	local var10_68 = {}

	for iter0_68, iter1_68 in ipairs(var4_68) do
		if iter1_68.dp[0] and iter1_68.dp[0] > 0 then
			table.insert(var10_68, {
				row = iter1_68.row,
				column = iter1_68.column,
				stay = iter1_68.dp[0]
			})
		end
	end

	return var10_68, var3_68
end

function var0_0.IsWalkable(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72:GetCell(arg1_72, arg2_72)

	return var0_72 and var0_72.walkable and (var0_72:CanLeave() or arg0_72:IsStayPoint(arg1_72, arg2_72))
end

function var0_0.IsStayPoint(arg0_73, arg1_73, arg2_73)
	return arg0_73:GetCell(arg1_73, arg2_73):CanArrive() and not arg0_73:ExistFleet(arg1_73, arg2_73)
end

function var0_0.IsObstacle(arg0_74, arg1_74, arg2_74)
	return not arg0_74:GetCell(arg1_74, arg2_74):CanPass()
end

function var0_0.IsSign(arg0_75, arg1_75, arg2_75)
	return arg0_75:GetCell(arg1_75, arg2_75):IsSign()
end

function var0_0.FindNearestBlankPoint(arg0_76, arg1_76, arg2_76)
	local var0_76 = {}

	for iter0_76 = 0, WorldConst.MaxRow - 1 do
		if not var0_76[iter0_76] then
			var0_76[iter0_76] = {}
		end

		for iter1_76 = 0, WorldConst.MaxColumn - 1 do
			var0_76[iter0_76][iter1_76] = arg0_76:IsWalkable(iter0_76, iter1_76)
		end
	end

	local var1_76 = {
		row = arg1_76,
		column = arg2_76
	}
	local var2_76 = {}

	while #var1_76 > 0 do
		local var3_76 = table.remove(var1_76, 1)

		table.insert(var2_76, var3_76)

		local var4_76 = {
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

		_.each(var4_76, function(arg0_77)
			arg0_77.row = var3_76.row + arg0_77.row
			arg0_77.column = var3_76.column + arg0_77.column

			if arg0_77.row >= 0 and arg0_77.row < WorldConst.MaxRow and arg0_77.column >= 0 and arg0_77.column < WorldConst.MaxColumn and not (_.any(var1_76, function(arg0_78)
				return arg0_78.row == arg0_77.row and arg0_78.column == arg0_77.column
			end) or _.any(var2_76, function(arg0_79)
				return arg0_79.row == arg0_77.row and arg0_79.column == arg0_77.column
			end)) and var0_76[arg0_77.row][arg0_77.column] then
				if arg0_76:ExistAny(arg0_77.row, arg0_77.column) then
					table.insert(var1_76, arg0_77)
				else
					return arg0_77
				end
			end
		end)
	end
end

function var0_0.WriteBack(arg0_80, arg1_80, arg2_80)
	local var0_80 = arg0_80:GetFleet()
	local var1_80 = {}

	for iter0_80, iter1_80 in ipairs(var0_80:GetShips(true)) do
		table.insert(var1_80, iter1_80)
	end

	if arg2_80.statistics.submarineAid then
		local var2_80 = arg0_80:GetSubmarineFleet()

		assert(var2_80, "submarine fleet not exist.")

		local var3_80 = var2_80:GetTeamShips(TeamType.Submarine, true)

		for iter2_80, iter3_80 in ipairs(var3_80) do
			table.insert(var1_80, iter3_80)
		end

		var2_80:UseAmmo()
		var2_80:AddDefeatEnemies(arg1_80)
	end

	var0_80:AddDefeatEnemies(arg1_80)
	_.each(var1_80, function(arg0_81)
		local var0_81 = arg2_80.statistics[arg0_81.id]

		if var0_81 then
			arg0_81.hpRant = var0_81.bp
		end

		if arg0_81.hpRant <= 0 then
			arg0_81:Rebirth()
		end
	end)

	local var4_80 = arg0_80:GetCell(var0_80.row, var0_80.column):GetStageEnemy()

	assert(var4_80)

	if arg1_80 then
		var4_80:UpdateFlag(1)

		arg0_80.phaseDisplayList = table.mergeArray(arg0_80.phaseDisplayList, var4_80:SetHP(0))

		local var5_80 = false

		_.each(arg0_80:GetFleets(), function(arg0_82)
			var5_80 = var5_80 or arg0_82:HasDamageLevel()

			arg0_82:ClearDamageLevel()
		end)

		if var5_80 then
			table.insert(arg0_80.phaseDisplayList, 1, {
				story = "W1500",
				hp = var4_80:GetMaxHP()
			})
		end
	else
		arg0_80.isLoss = true

		var0_80:IncDamageLevel(var4_80)
		var4_80:UpdateData(var4_80.data - 1)

		arg0_80.phaseDisplayList = table.mergeArray(arg0_80.phaseDisplayList, var4_80:SetHP(arg2_80.statistics._maxBossHP))

		local var6_80 = nowWorld()

		if var6_80.isAutoFight then
			var6_80:TriggerAutoFight(false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("autofight_tip_bigworld_dead"))
		end
	end

	_.each(arg2_80.hpDropInfo, function(arg0_83)
		local var0_83 = #arg0_80.phaseDisplayList + 1

		for iter0_83, iter1_83 in ipairs(arg0_80.phaseDisplayList) do
			if iter1_83.hp < arg0_83.hp then
				var0_83 = iter0_83

				break
			end
		end

		arg0_80:AddPhaseDisplay({
			hp = arg0_83.hp,
			drops = PlayerConst.addTranDrop(arg0_83.drop_info)
		}, var0_83)
	end)
end

function var0_0.AddPhaseDisplay(arg0_84, arg1_84, arg2_84)
	if arg2_84 then
		table.insert(arg0_84.phaseDisplayList, arg2_84, arg1_84)
	else
		table.insert(arg0_84.phaseDisplayList, arg1_84)
	end
end

function var0_0.FindAttachments(arg0_85, arg1_85, arg2_85)
	local var0_85 = {}

	for iter0_85, iter1_85 in pairs(arg0_85.typeAttachments) do
		if not arg1_85 or arg1_85 == iter0_85 then
			for iter2_85, iter3_85 in ipairs(iter1_85) do
				if not arg2_85 or iter3_85.id == arg2_85 then
					table.insert(var0_85, iter3_85)
				end
			end
		end
	end

	return var0_85
end

function var0_0.FindEnemys(arg0_86)
	local var0_86 = {}

	for iter0_86, iter1_86 in pairs(arg0_86.typeAttachments) do
		if WorldMapAttachment.IsEnemyType(iter0_86) then
			var0_86 = table.mergeArray(var0_86, iter1_86)
		end
	end

	return var0_86
end

function var0_0.GetMapMinMax(arg0_87)
	local var0_87 = Vector2(WorldConst.MaxColumn, WorldConst.MaxRow)
	local var1_87 = Vector2(-WorldConst.MaxColumn, -WorldConst.MaxRow)

	for iter0_87 = 0, WorldConst.MaxRow - 1 do
		for iter1_87 = 0, WorldConst.MaxColumn - 1 do
			if arg0_87:GetCell(iter0_87, iter1_87) then
				var0_87.x = math.min(var0_87.x, iter1_87)
				var0_87.y = math.min(var0_87.y, iter0_87)
				var1_87.x = math.max(var1_87.x, iter1_87)
				var1_87.y = math.max(var1_87.y, iter0_87)
			end
		end
	end

	return var0_87.y, var1_87.y, var0_87.x, var1_87.x
end

function var0_0.GetMapSize(arg0_88)
	local var0_88, var1_88, var2_88, var3_88 = arg0_88:GetMapMinMax()

	return var1_88 - var0_88 + 1, var3_88 - var2_88 + 1
end

function var0_0.CountEventEffectKeys(arg0_89, arg1_89)
	local var0_89 = 0

	for iter0_89, iter1_89 in ipairs(arg0_89:GetNormalFleets()) do
		local var1_89 = arg0_89:GetCell(iter1_89.row, iter1_89.column):GetAliveAttachment()

		if var1_89 and var1_89.type == WorldMapAttachment.TypeEvent and var1_89:GetEventEffect() == arg1_89 then
			var0_89 = var0_89 + 1
		end
	end

	return var0_89
end

function var0_0.EventEffectOpenFOV(arg0_90, arg1_90)
	assert(arg1_90.effect_type == WorldMapAttachment.EffectEventFOV)

	local var0_90, var1_90 = unpack(arg1_90.effect_paramater)
	local var2_90 = var1_90 >= 0

	var1_90 = var2_90 and var1_90 or math.abs(var1_90) - 1

	local var3_90 = arg0_90:FindAttachments(WorldMapAttachment.TypeEvent, var0_90)

	_.each(var3_90, function(arg0_91)
		arg0_90.centerCellFOV = {
			row = arg0_91.row,
			column = arg0_91.column
		}

		for iter0_91 = math.max(arg0_91.row - var1_90, 0), math.min(arg0_91.row + var1_90, WorldConst.MaxRow - 1) do
			for iter1_91 = math.max(arg0_91.column - var1_90, 0), math.min(arg0_91.column + var1_90, WorldConst.MaxColumn - 1) do
				if WorldConst.InFOVRange(arg0_91.row, arg0_91.column, iter0_91, iter1_91, var1_90) then
					local var0_91 = arg0_90:GetCell(iter0_91, iter1_91)

					if var0_91 then
						if var2_90 then
							var0_91:UpdateInFov(bit.bor(var0_91.infov, WorldConst.FOVEventEffect))
						else
							var0_91:UpdateInFov(bit.band(var0_91.infov, WorldConst.Flag16Max - WorldConst.FOVEventEffect))
						end
					end
				end
			end
		end
	end)
end

function var0_0.OrderAROpenFOV(arg0_92, arg1_92)
	if arg1_92 then
		local var0_92 = arg0_92:GetFleet()

		arg0_92.centerCellFOV = {
			row = var0_92.row,
			column = var0_92.column
		}
	end

	for iter0_92, iter1_92 in pairs(arg0_92.cells) do
		if arg1_92 then
			iter1_92:UpdateInFov(bit.bor(iter1_92.infov, WorldConst.FOVEventEffect))
		else
			iter1_92:UpdateInFov(bit.band(iter1_92.infov, WorldConst.Flag16Max - WorldConst.FOVEventEffect))
		end
	end
end

function var0_0.GetMaxDistanceCell(arg0_93, arg1_93, arg2_93)
	local var0_93
	local var1_93 = 0
	local var2_93 = {
		{
			row = arg0_93.top,
			column = arg0_93.left
		},
		{
			row = arg0_93.bottom,
			column = arg0_93.left
		},
		{
			row = arg0_93.top,
			column = arg0_93.right
		},
		{
			row = arg0_93.bottom,
			column = arg0_93.right
		}
	}

	for iter0_93, iter1_93 in pairs(var2_93) do
		local var3_93 = (iter1_93.row - arg1_93) * (iter1_93.row - arg1_93) + (iter1_93.column - arg2_93) * (iter1_93.column - arg2_93)

		if var1_93 < var3_93 then
			var0_93 = iter1_93
			var1_93 = var3_93
		end
	end

	return var0_93, math.sqrt(var1_93)
end

function var0_0.GetCellsInFOV(arg0_94)
	local var0_94 = {}

	for iter0_94, iter1_94 in pairs(arg0_94.cells) do
		if iter1_94:GetInFOV() then
			table.insert(var0_94, iter1_94)
		end
	end

	return var0_94
end

function var0_0.AlwaysInFOV(arg0_95)
	return arg0_95.config.map_sight == 1
end

function var0_0.GetEventTipWord(arg0_96)
	local var0_96 = arg0_96:FindAttachments(WorldMapAttachment.TypeEvent)
	local var1_96 = ""
	local var2_96 = 0

	for iter0_96, iter1_96 in ipairs(var0_96) do
		local var3_96 = pg.world_event_desc[iter1_96.id]

		if iter1_96:IsAlive() and var3_96 and var2_96 < var3_96.hint_pri then
			var2_96 = var3_96.hint_pri
			var1_96 = var3_96.hint
		end
	end

	return var1_96, var2_96
end

function var0_0.GetEventPoisonRate(arg0_97)
	local var0_97 = arg0_97:FindAttachments(WorldMapAttachment.TypeEvent)
	local var1_97 = 0

	for iter0_97, iter1_97 in ipairs(var0_97) do
		if iter1_97:IsAlive() then
			var1_97 = var1_97 + iter1_97.config.infection_value
		end
	end

	return var1_97, arg0_97.config.is_sairen
end

function var0_0.GetPressingLevel(arg0_98)
	return arg0_98.config.complete_effect
end

function var0_0.CheckMapPressing(arg0_99)
	return arg0_99:GetPressingLevel() > 0 and not arg0_99.isPressing and arg0_99:GetEventPoisonRate() == 0
end

function var0_0.CheckMapPressingDisplay(arg0_100)
	return arg0_100:GetPressingLevel() > 1
end

function var0_0.UpdateClearFlag(arg0_101, arg1_101)
	arg0_101.clearFlag = tobool(arg1_101)
end

function var0_0.IsUnlockFleetMode(arg0_102)
	if arg0_102.config.move_switch == 1 then
		return true
	elseif arg0_102.config.move_switch == 0 then
		return false
	else
		assert(false, "config error")
	end
end

function var0_0.CheckFleetSalvage(arg0_103, arg1_103)
	local var0_103 = underscore.detect(arg0_103:GetFleets(), function(arg0_104)
		return arg0_104:IsCatSalvage() and (arg1_103 or arg0_104:IsSalvageFinish() or arg0_103.salvageAutoResult or arg0_104.catSalvageFrom ~= arg0_103.id)
	end)

	if var0_103 then
		return var0_103.id
	else
		arg0_103.salvageAutoResult = false
	end
end

function var0_0.GetChapterAuraBuffs(arg0_105)
	local var0_105 = {}

	for iter0_105, iter1_105 in ipairs(arg0_105.fleets) do
		local var1_105 = iter1_105:getMapAura()

		for iter2_105, iter3_105 in ipairs(var1_105) do
			table.insert(var0_105, iter3_105)
		end
	end

	return var0_105
end

function var0_0.GetChapterAidBuffs(arg0_106)
	local var0_106 = {}

	for iter0_106, iter1_106 in ipairs(arg0_106.fleets) do
		if iter0_106 ~= arg0_106.findex then
			local var1_106 = iter1_106:getMapAid()

			for iter2_106, iter3_106 in pairs(var1_106) do
				var0_106[iter2_106] = iter3_106
			end
		end
	end

	return var0_106
end

function var0_0.getFleetBattleBuffs(arg0_107, arg1_107, arg2_107)
	local var0_107 = {}

	underscore.each(arg1_107:GetBuffList(), function(arg0_108)
		local var0_108 = arg0_108.config.lua_id

		if var0_108 ~= 0 then
			table.insert(var0_107, var0_108)
		end
	end)

	local var1_107 = {}

	if arg2_107 and arg1_107:IsCatSalvage() then
		-- block empty
	else
		var1_107 = arg0_107:BuildBattleBuffList(arg1_107)
	end

	return var0_107, var1_107
end

function var0_0.BuildBattleBuffList(arg0_109, arg1_109)
	local var0_109 = {}
	local var1_109, var2_109 = arg0_109:triggerSkill(arg1_109, FleetSkill.TypeBattleBuff)

	if var1_109 and #var1_109 > 0 then
		local var3_109 = {}

		for iter0_109, iter1_109 in ipairs(var1_109) do
			local var4_109 = var2_109[iter0_109]
			local var5_109 = arg1_109:findCommanderBySkillId(var4_109.id)

			var3_109[var5_109] = var3_109[var5_109] or {}

			table.insert(var3_109[var5_109], iter1_109)
		end

		for iter2_109, iter3_109 in pairs(var3_109) do
			table.insert(var0_109, {
				iter2_109,
				iter3_109
			})
		end
	end

	local var6_109 = arg1_109:getCommanders()

	for iter4_109, iter5_109 in pairs(var6_109) do
		local var7_109 = iter5_109:getTalents()

		for iter6_109, iter7_109 in ipairs(var7_109) do
			local var8_109 = iter7_109:getBuffsAddition()

			if #var8_109 > 0 then
				local var9_109

				for iter8_109, iter9_109 in ipairs(var0_109) do
					if iter9_109[1] == iter5_109 then
						var9_109 = iter9_109[2]

						break
					end
				end

				if not var9_109 then
					var9_109 = {}

					table.insert(var0_109, {
						iter5_109,
						var9_109
					})
				end

				for iter10_109, iter11_109 in ipairs(var8_109) do
					table.insert(var9_109, iter11_109)
				end
			end
		end
	end

	return var0_109
end

function var0_0.CanLongMove(arg0_110, arg1_110)
	return arg0_110:IsUnlockFleetMode() and not arg1_110:HasTrapBuff() and arg0_110:GetFleetTerrain(arg1_110) ~= WorldMapCell.TerrainFog
end

function var0_0.triggerSkill(arg0_111, arg1_111, arg2_111)
	local var0_111 = _.filter(arg1_111:findSkills(arg2_111), function(arg0_112)
		local var0_112 = arg0_112:GetTriggers()

		return _.any(var0_112, function(arg0_113)
			return arg0_113[1] == FleetSkill.TriggerInSubTeam and arg0_113[2] == 1
		end) == (arg1_111:GetFleetType() == FleetType.Submarine) and _.all(arg0_112:GetTriggers(), function(arg0_114)
			return arg0_111:triggerCheck(arg1_111, arg0_112, arg0_114)
		end)
	end)

	return _.reduce(var0_111, nil, function(arg0_115, arg1_115)
		local var0_115 = arg1_115:GetType()
		local var1_115 = arg1_115:GetArgs()

		if var0_115 == FleetSkill.TypeMoveSpeed or var0_115 == FleetSkill.TypeHuntingLv or var0_115 == FleetSkill.TypeTorpedoPowerUp then
			return (arg0_115 or 0) + var1_115[1]
		elseif var0_115 == FleetSkill.TypeAmbushDodge or var0_115 == FleetSkill.TypeAirStrikeDodge then
			return math.max(arg0_115 or 0, var1_115[1])
		elseif var0_115 == FleetSkill.TypeAttack or var0_115 == FleetSkill.TypeStrategy then
			arg0_115 = arg0_115 or {}

			table.insert(arg0_115, var1_115)

			return arg0_115
		elseif var0_115 == FleetSkill.TypeBattleBuff then
			arg0_115 = arg0_115 or {}

			table.insert(arg0_115, var1_115[1])

			return arg0_115
		end
	end), var0_111
end

function var0_0.triggerCheck(arg0_116, arg1_116, arg2_116, arg3_116)
	local var0_116 = arg3_116[1]

	if var0_116 == FleetSkill.TriggerDDHead then
		local var1_116 = arg1_116:GetTeamShipVOs(TeamType.Vanguard, false)

		return #var1_116 > 0 and ShipType.IsTypeQuZhu(var1_116[1]:getShipType())
	elseif var0_116 == FleetSkill.TriggerVanCount then
		local var2_116 = arg1_116:GetTeamShipVOs(TeamType.Vanguard, false)

		return #var2_116 >= arg3_116[2] and #var2_116 <= arg3_116[3]
	elseif var0_116 == FleetSkill.TriggerShipCount then
		local var3_116 = _.filter(arg1_116:GetShipVOs(false), function(arg0_117)
			return table.contains(arg3_116[2], arg0_117:getShipType())
		end)

		return #var3_116 >= arg3_116[3] and #var3_116 <= arg3_116[4]
	elseif var0_116 == FleetSkill.TriggerAroundEnemy then
		local var4_116 = {
			row = arg1_116.row,
			column = arg1_116.column
		}
		local var5_116 = {}
		local var6_116 = arg3_116[2]

		for iter0_116 = -var6_116, var6_116 do
			local var7_116 = var6_116 - math.abs(iter0_116)

			for iter1_116 = -var7_116, var7_116 do
				local var8_116 = arg0_116:GetCell(var4_116.row + iter0_116, var4_116.column + iter1_116)

				table.insert(var5_116, var8_116)
			end
		end

		return underscore.any(var5_116, function(arg0_118)
			local var0_118 = arg0_118:ExistEnemy() and arg0_118:GetStageEnemy().config.type or nil

			return type(arg3_116[3]) == "number" and arg3_116[3] == var0_118 or type(arg3_116[3]) == "table" and table.contains(arg3_116[3], var0_118)
		end)
	elseif var0_116 == FleetSkill.TriggerNekoPos then
		local var9_116 = arg1_116:findCommanderBySkillId(arg2_116.id)

		for iter2_116, iter3_116 in pairs(arg1_116:getCommanders()) do
			if var9_116.id == iter3_116.id and iter2_116 == arg3_116[2] then
				return true
			end
		end
	elseif var0_116 == FleetSkill.TriggerAroundLand then
		local var10_116 = {
			row = arg1_116.row,
			column = arg1_116.column
		}
		local var11_116 = arg3_116[2]

		for iter4_116 = -var11_116, var11_116 do
			local var12_116 = var11_116 - math.abs(iter4_116)

			for iter5_116 = -var12_116, var12_116 do
				local var13_116 = var10_116.row + iter4_116
				local var14_116 = var10_116.column + iter5_116

				if arg0_116:GetCell(var13_116, var14_116) and not arg0_116:IsWalkable(var13_116, var14_116) then
					return true
				end
			end
		end

		return false
	elseif var0_116 == FleetSkill.TriggerAroundCombatAlly then
		local var15_116 = {
			row = arg1_116.row,
			column = arg1_116.column
		}

		return _.any(arg0_116.fleets, function(arg0_119)
			return arg1_116.id ~= arg0_119.id and arg0_119:GetFleetType() == FleetType.Normal and arg0_116:GetCell(arg0_119.line.row, arg0_119.line.column):ExistEnemy() and ManhattonDist(var15_116, {
				row = arg0_119.line.row,
				column = arg0_119.line.column
			}) <= arg3_116[2]
		end)
	elseif var0_116 == FleetSkill.TriggerInSubTeam then
		return true
	else
		assert(false, "invalid trigger type: " .. var0_116)
	end
end

function var0_0.OnUpdateAttachmentExist(arg0_120, arg1_120, arg2_120, arg3_120)
	local var0_120 = arg3_120.type

	arg0_120.typeAttachments[var0_120] = arg0_120.typeAttachments[var0_120] or {}

	if arg1_120 == WorldMapCell.EventAddAttachment then
		table.insert(arg0_120.typeAttachments[var0_120], arg3_120)
	elseif arg1_120 == WorldMapCell.EventRemoveAttachment then
		table.removebyvalue(arg0_120.typeAttachments[var0_120], arg3_120)
	end

	local var1_120 = arg3_120:GetVisionRadius()

	if var1_120 > 0 then
		local var2_120 = 0

		if arg1_120 == WorldMapCell.EventAddAttachment then
			var2_120 = var2_120 + 1
		elseif arg1_120 == WorldMapCell.EventRemoveAttachment then
			var2_120 = var2_120 - 1
		else
			assert(false, "listener event error: " .. arg1_120)
		end

		arg0_120.centerCellFOV = {
			row = arg2_120.row,
			column = arg2_120.column
		}

		for iter0_120 = arg2_120.row - var1_120, arg2_120.row + var1_120 do
			for iter1_120 = arg2_120.column - var1_120, arg2_120.column + var1_120 do
				local var3_120 = arg0_120:GetCell(iter0_120, iter1_120)

				if var3_120 and WorldConst.InFOVRange(arg2_120.row, arg2_120.column, var3_120.row, var3_120.column, var1_120) then
					var3_120:ChangeInLight(var2_120 > 0)
				end
			end
		end
	end

	local var4_120 = arg3_120:GetRadiationBuffs()

	if #var4_120 > 0 then
		local var5_120 = {}

		for iter2_120, iter3_120 in ipairs(var4_120) do
			local var6_120, var7_120, var8_120 = unpack(iter3_120)

			if arg1_120 == WorldMapCell.EventAddAttachment then
				var5_120[var6_120] = true

				arg0_120:AddBuff(var6_120, var7_120, var8_120)
			elseif arg1_120 == WorldMapCell.EventRemoveAttachment then
				var5_120[var6_120] = true

				arg0_120:RemoveBuff(var6_120, var7_120, var8_120)
			end
		end

		for iter4_120, iter5_120 in pairs(var5_120) do
			if iter5_120 then
				arg0_120:FlushFaction(iter4_120)
			end
		end
	end
end

function var0_0.GetBGM(arg0_121)
	return arg0_121.config.bgm
end

function var0_0.NeedClear(arg0_122)
	local var0_122, var1_122 = arg0_122:GetEventPoisonRate()

	return var1_122 > 0 and var0_122 == 0 or arg0_122.clearFlag or arg0_122.config.is_clear > 0
end

function var0_0.GetBuff(arg0_123, arg1_123, arg2_123)
	if not arg0_123.factionBuffs[arg1_123][arg2_123] then
		arg0_123.factionBuffs[arg1_123][arg2_123] = WorldBuff.New()

		arg0_123.factionBuffs[arg1_123][arg2_123]:Setup({
			floor = 0,
			id = arg2_123
		})
	end

	return arg0_123.factionBuffs[arg1_123][arg2_123]
end

function var0_0.AddBuff(arg0_124, arg1_124, arg2_124, arg3_124)
	arg0_124:GetBuff(arg1_124, arg2_124):AddFloor(arg3_124)
end

function var0_0.RemoveBuff(arg0_125, arg1_125, arg2_125, arg3_125)
	local var0_125 = arg0_125:GetBuff(arg1_125, arg2_125)

	if arg3_125 then
		var0_125:AddFloor(arg3_125 * -1)
	else
		arg0_125.factionBuffs[arg1_125][arg2_125] = nil
	end
end

function var0_0.GetBuffList(arg0_126, arg1_126, arg2_126)
	if arg1_126 == var0_0.FactionSelf then
		return underscore.filter(underscore.values(arg0_126.factionBuffs[arg1_126]), function(arg0_127)
			return arg0_127:GetFloor() > 0
		end)
	elseif arg1_126 == var0_0.FactionEnemy then
		if WorldMapAttachment.IsEnemyType(arg2_126.type) or arg2_126.type == WorldMapAttachment.TypeEvent and arg2_126:GetSpEventType() == WorldMapAttachment.SpEventEnemy then
			return underscore.filter(underscore.values(arg0_126.factionBuffs[arg1_126]), function(arg0_128)
				return arg0_128:GetFloor() > 0
			end)
		else
			return {}
		end
	else
		assert(false, string.format("faction error: $d", arg1_126))
	end
end

function var0_0.FlushFaction(arg0_129, arg1_129)
	if arg1_129 == var0_0.FactionSelf then
		underscore.each(arg0_129:GetFleets(), function(arg0_130)
			arg0_130:DispatchEvent(WorldMapFleet.EventUpdateBuff)
		end)
	elseif arg1_129 == var0_0.FactionEnemy then
		local var0_129 = {}

		underscore.each(arg0_129:FindEnemys(), function(arg0_131)
			var0_129[WorldMapCell.GetName(arg0_131.row, arg0_131.column)] = true
		end)
		underscore.each(arg0_129:FindAttachments(WorldMapAttachment.TypeEvent), function(arg0_132)
			if arg0_132:GetSpEventType() == WorldMapAttachment.SpEventEnemy then
				var0_129[WorldMapCell.GetName(arg0_132.row, arg0_132.column)] = true
			end
		end)

		for iter0_129 in pairs(var0_129) do
			arg0_129.cells[iter0_129]:DispatchEvent(var0_0.EventUpdateMapBuff)
		end
	else
		assert(false, string.format("faction error: $d", arg1_129))
	end
end

function var0_0.GetBattleLuaBuffs(arg0_133, arg1_133, arg2_133)
	local var0_133 = {}

	underscore.each(arg0_133:GetBuffList(arg1_133, arg2_133), function(arg0_134)
		if arg0_134.config.lua_id > 0 then
			table.insert(var0_133, arg0_134.config.lua_id)
		end
	end)

	return var0_133
end

function var0_0.UpdateFleetLocation(arg0_135, arg1_135, arg2_135, arg3_135)
	local var0_135 = arg0_135:GetFleet(arg1_135)

	assert(var0_135, "without this fleet : " .. arg1_135)

	if var0_135.row ~= arg2_135 or var0_135.column ~= arg3_135 then
		arg0_135:CheckFleetUpdateFOV(var0_135, function()
			var0_135.row = arg2_135
			var0_135.column = arg3_135
		end)
		var0_135:DispatchEvent(WorldMapFleet.EventUpdateLocation)
	end
end

function var0_0.GetRangeDic(arg0_137, arg1_137)
	local var0_137 = {}

	WorldConst.RangeCheck(arg1_137, arg0_137:GetFOVRange(arg1_137), function(arg0_138, arg1_138)
		local var0_138 = WorldMapCell.GetName(arg0_138, arg1_138)

		if arg0_137.cells[var0_138] then
			var0_137[var0_138] = defaultValue(var0_137[var0_138], 0) + 1
		end
	end)

	return var0_137
end

function var0_0.CheckFleetUpdateFOV(arg0_139, arg1_139, arg2_139)
	if not arg0_139:IsValid() then
		arg2_139()

		return
	end

	local var0_139 = arg0_139:GetRangeDic(arg1_139)
	local var1_139 = arg0_139:GetFleetTerrain(arg1_139) == WorldMapCell.TerrainFog
	local var2_139 = arg0_139:IsFleetTerrainSairenFog(arg1_139)
	local var3_139 = arg0_139:CalcFleetSpeed(arg1_139)

	arg2_139()

	local var4_139 = arg0_139:GetRangeDic(arg1_139)
	local var5_139 = arg0_139:GetFleetTerrain(arg1_139) == WorldMapCell.TerrainFog
	local var6_139 = arg0_139:IsFleetTerrainSairenFog(arg1_139)
	local var7_139 = arg0_139:CalcFleetSpeed(arg1_139)

	arg0_139.centerCellFOV = {
		row = arg1_139.row,
		column = arg1_139.column
	}

	local var8_139 = false
	local var9_139 = false
	local var10_139 = {}

	if not var1_139 then
		for iter0_139, iter1_139 in pairs(var0_139) do
			var10_139[iter0_139] = defaultValue(var10_139[iter0_139], 0) - iter1_139
		end
	end

	if not var5_139 then
		for iter2_139, iter3_139 in pairs(var4_139) do
			var10_139[iter2_139] = defaultValue(var10_139[iter2_139], 0) + iter3_139
		end
	end

	for iter4_139, iter5_139 in pairs(var10_139) do
		if iter5_139 ~= 0 then
			arg0_139.cells[iter4_139]:ChangeInLight(iter5_139 > 0)

			var8_139 = true
		end
	end

	if arg0_139:GetFleet() == arg1_139 then
		local var11_139 = {}

		if var1_139 then
			for iter6_139, iter7_139 in pairs(var0_139) do
				var11_139[iter6_139] = defaultValue(var11_139[iter6_139], 0) - iter7_139
			end
		end

		if var5_139 then
			for iter8_139, iter9_139 in pairs(var4_139) do
				var11_139[iter8_139] = defaultValue(var11_139[iter8_139], 0) + iter9_139
			end
		end

		if var1_139 ~= var5_139 or var2_139 ~= var6_139 then
			for iter10_139, iter11_139 in pairs(arg0_139.cells) do
				local var12_139

				if var11_139[iter10_139] and var11_139[iter10_139] ~= 0 then
					var12_139 = var11_139[iter10_139] > 0
				end

				iter11_139:UpdateFog(var5_139, var12_139, var6_139)
			end

			var8_139 = true
		else
			for iter12_139, iter13_139 in pairs(var11_139) do
				if iter13_139 ~= 0 then
					arg0_139.cells[iter12_139]:UpdateFog(nil, iter13_139 > 0, nil)

					var8_139 = true
				end
			end
		end

		if var3_139 ~= var7_139 then
			var9_139 = true
		end
	end

	if var8_139 then
		arg0_139:DispatchEvent(var0_0.EventUpdateFleetFOV)
	end

	if var9_139 then
		arg0_139:DispatchEvent(var0_0.EventUpdateMoveSpeed)
	end
end

function var0_0.CheckSelectFleetUpdateFog(arg0_140, arg1_140)
	if not arg0_140:IsValid() then
		arg1_140()

		return
	end

	local var0_140 = arg0_140:GetFleet()
	local var1_140 = arg0_140:GetRangeDic(var0_140)
	local var2_140 = arg0_140:GetFleetTerrain(var0_140) == WorldMapCell.TerrainFog
	local var3_140 = arg0_140:IsFleetTerrainSairenFog(var0_140)

	arg1_140()

	local var4_140 = arg0_140:GetFleet()
	local var5_140 = arg0_140:GetRangeDic(var4_140)
	local var6_140 = arg0_140:GetFleetTerrain(var4_140) == WorldMapCell.TerrainFog
	local var7_140 = arg0_140:IsFleetTerrainSairenFog(var4_140)

	arg0_140.centerCellFOV = {
		row = var4_140.row,
		column = var4_140.column
	}

	local var8_140 = {}

	if var2_140 then
		for iter0_140, iter1_140 in pairs(var1_140) do
			var8_140[iter0_140] = defaultValue(var8_140[iter0_140], 0) - iter1_140
		end
	end

	if var6_140 then
		for iter2_140, iter3_140 in pairs(var5_140) do
			var8_140[iter2_140] = defaultValue(var8_140[iter2_140], 0) + iter3_140
		end
	end

	if var2_140 ~= var6_140 or var3_140 ~= var7_140 then
		for iter4_140, iter5_140 in pairs(arg0_140.cells) do
			local var9_140

			if var8_140[iter4_140] and var8_140[iter4_140] ~= 0 then
				var9_140 = var8_140[iter4_140] > 0
			end

			iter5_140:UpdateFog(var6_140, var9_140, var7_140)
		end
	else
		for iter6_140, iter7_140 in pairs(var8_140) do
			if iter7_140 ~= 0 then
				arg0_140.cells[iter6_140]:UpdateFog(nil, iter7_140 > 0, nil)
			end
		end
	end

	arg0_140:DispatchEvent(var0_0.EventUpdateFleetFOV)
end

function var0_0.CheckEventAutoTrigger(arg0_141, arg1_141)
	if arg1_141:GetSpEventType() == WorldMapAttachment.SpEventConsumeItem then
		return getProxy(SettingsProxy):GetWorldFlag("consume_item")
	end

	local var0_141 = arg1_141:GetEventEffect()

	if var0_141 then
		local var1_141 = arg0_141:GetFleet()
		local var2_141 = var0_141.effect_type

		if var2_141 == WorldMapAttachment.EffectEventConsumeCarry then
			local var3_141 = var0_141.effect_paramater[1] or {}

			return not underscore.any(var3_141, function(arg0_142)
				return not var1_141:ExistCarry(arg0_142)
			end)
		elseif var2_141 == WorldMapAttachment.EffectEventCatSalvage then
			return var1_141:GetDisplayCommander() and not var1_141:IsCatSalvage()
		end
	end

	return true
end

function var0_0.CanAutoFight(arg0_143)
	if arg0_143.config.is_auto > 0 then
		for iter0_143 = 1, arg0_143.config.is_auto do
			if not nowWorld():IsSystemOpen(WorldConst["SystemAutoFight_" .. iter0_143]) then
				return false
			end
		end

		return true
	else
		return false
	end
end

function var0_0.CkeckTransport(arg0_144)
	assert(arg0_144:IsValid(), "without map info")

	if arg0_144.config.is_transfer == 0 then
		return false, i18n("world_transport_disable")
	end

	if arg0_144:CheckAttachmentTransport() == "block" then
		return false, i18n("world_movelimit_event_text")
	end

	if nowWorld():CheckTaskLockMap() then
		return false, i18n("world_task_maplock")
	end

	return true
end

return var0_0
