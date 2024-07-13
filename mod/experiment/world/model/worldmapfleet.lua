local var0_0 = class("WorldMapFleet", import(".WorldBaseFleet"))

var0_0.Fields = {
	lossFlag = "number",
	column = "number",
	catSalvageList = "table",
	catSalvageStep = "number",
	index = "number",
	ammo = "number",
	damageLevel = "number",
	ammoMax = "number",
	row = "number",
	buffs = "table",
	defeatEnemies = "number",
	skills = "table",
	catSalvageFrom = "number",
	carries = "table"
}
var0_0.EventUpdateLocation = "WorldMapFleet.EventUpdateLocation"
var0_0.EventUpdateShipOrder = "WorldMapFleet.EventUpdateShipOrder"
var0_0.EventAddShip = "WorldMapFleet.EventAddShip"
var0_0.EventRemoveShip = "WorldMapFleet.EventRemoveShip"
var0_0.EventAddCarry = "WorldMapFleet.EventAddCarry"
var0_0.EventRemoveCarry = "WorldMapFleet.EventRemoveCarry"
var0_0.EventUpdateBuff = "WorldMapFleet.EventUpdateBuff"
var0_0.EventUpdateDamageLevel = "WorldMapFleet.EventUpdateDamageLevel"
var0_0.EventUpdateDefeat = "WorldMapFleet.EventUpdateDefeat"
var0_0.EventUpdateCatSalvage = "WorldMapFleet.EventUpdateCatSalvage"

function var0_0.GetName(arg0_1)
	return "fleet_" .. arg0_1
end

function var0_0.DebugPrint(arg0_2)
	local var0_2 = _.map(arg0_2:GetBuffList(), function(arg0_3)
		return arg0_3.id .. "#" .. arg0_3:GetFloor()
	end)
	local var1_2 = _.map(arg0_2.carries, function(arg0_4)
		return "carries"
	end)
	local var2_2, var3_2 = arg0_2:GetAmmo()
	local var4_2 = string.format("[第%s舰队] [id: %s] [位置: %s, %s] [弹药: %s/%s] [携带物: %s] [战损: %s] [buff: %s]", arg0_2.index, arg0_2.id, arg0_2.row, arg0_2.column, var2_2, var3_2, table.concat(var1_2, ", "), arg0_2.damageLevel, table.concat(var0_2, ", "))
	local var5_2 = {
		[TeamType.Main] = "主力",
		[TeamType.Vanguard] = "先锋",
		[TeamType.Submarine] = "潜艇"
	}
	local var6_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2:GetShips(true)) do
		local var7_2 = WorldConst.FetchShipVO(iter1_2.id)
		local var8_2 = _.map(iter1_2:GetBuffList(), function(arg0_5)
			return arg0_5.id .. "#" .. arg0_5:GetFloor()
		end)
		local var9_2 = string.format("\t\t[%s] [id: %s] [config_id: %s] [%s] [hp: %s%%] [buff: %s]" .. " <material=underline c=#A9F548 event=ShipProperty args=%s><color=#A9F548>属性</color></material>", var7_2:getName(), var7_2.id, var7_2.configId, var5_2[var7_2:getTeamType()], iter1_2.hpRant / 100, table.concat(var8_2, ", "), var7_2.id)

		table.insert(var6_2, var9_2)
	end

	return var4_2 .. "\n" .. table.concat(var6_2, "\n")
end

function var0_0.Build(arg0_6)
	var0_0.super.Build(arg0_6)

	arg0_6.carries = {}
end

function var0_0.Setup(arg0_7, arg1_7)
	arg0_7.id = arg1_7.id

	local var0_7 = _.map(arg1_7.ship_list, function(arg0_8)
		local var0_8 = WPool:Get(WorldMapShip)

		var0_8:Setup(arg0_8)

		return var0_8
	end)

	arg0_7:UpdateShips(var0_7)

	arg0_7.commanderIds = {}

	for iter0_7, iter1_7 in ipairs(arg1_7.commander_list or {}) do
		arg0_7.commanderIds[iter1_7.pos] = iter1_7.id
	end

	arg0_7.skills = {}

	arg0_7:updateCommanderSkills()

	arg0_7.row = arg1_7.pos.row
	arg0_7.column = arg1_7.pos.column
	arg0_7.ammo = arg1_7.bullet
	arg0_7.ammoMax = arg1_7.bullet_max
	arg0_7.damageLevel = math.clamp(arg1_7.damage_level, 0, #WorldConst.DamageBuffList)

	_.each(arg1_7.attach_list, function(arg0_9)
		local var0_9 = WPool:Get(WorldCarryItem)

		var0_9:Setup(arg0_9)
		table.insert(arg0_7.carries, var0_9)
	end)

	arg0_7.buffs = WorldConst.ParsingBuffs(arg1_7.buff_list)
	arg0_7.defeatEnemies = arg1_7.kill_count
	arg0_7.catSalvageStep = arg1_7.cmd_collection.progress
	arg0_7.catSalvageList = arg1_7.cmd_collection.progress_list
	arg0_7.catSalvageFrom = arg1_7.cmd_collection.random_id

	if arg0_7:GetFleetType() == FleetType.Submarine then
		arg0_7.row = -1
		arg0_7.column = -1
	end
end

function var0_0.GetCost(arg0_10)
	local var0_10 = {
		gold = 0,
		oil = 0
	}
	local var1_10 = {
		gold = 0,
		oil = 0
	}

	return var0_10, var1_10
end

function var0_0.GetFleetIndex(arg0_11)
	return arg0_11.index
end

function var0_0.GetDefaultName(arg0_12)
	return Fleet.DEFAULT_NAME[#arg0_12[TeamType.Submarine] > 0 and arg0_12.index + 10 or arg0_12.index]
end

function var0_0.FormationEqual(arg0_13, arg1_13)
	local var0_13 = _.map(arg0_13:GetShips(true), function(arg0_14)
		return arg0_14.id
	end)
	local var1_13 = _.map(arg1_13:GetShips(true), function(arg0_15)
		return arg0_15.id
	end)

	for iter0_13 = 1, math.max(#var0_13, #var1_13) do
		if var0_13[iter0_13] ~= var1_13[iter0_13] then
			return false
		end
	end

	return true
end

function var0_0.GetPropertiesSum(arg0_16)
	local var0_16 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}
	local var1_16 = arg0_16:GetShipVOs(true)

	for iter0_16, iter1_16 in ipairs(var1_16) do
		local var2_16 = iter1_16:getProperties()

		var0_16.cannon = var0_16.cannon + math.floor(var2_16.cannon)
		var0_16.torpedo = var0_16.torpedo + math.floor(var2_16.torpedo)
		var0_16.antiAir = var0_16.antiAir + math.floor(var2_16.antiaircraft)
		var0_16.air = var0_16.air + math.floor(var2_16.air)
	end

	return var0_16
end

function var0_0.GetGearScoreSum(arg0_17, arg1_17)
	local var0_17 = 0
	local var1_17 = arg1_17 and arg0_17:GetTeamShipVOs(arg1_17) or arg0_17:GetShipVOs()

	for iter0_17, iter1_17 in ipairs(var1_17) do
		var0_17 = var0_17 + iter1_17:getShipCombatPower()
	end

	return var0_17
end

function var0_0.GetLevelCount(arg0_18)
	local var0_18 = arg0_18:GetShipVOs()
	local var1_18 = 0

	underscore.each(var0_18, function(arg0_19)
		var1_18 = var1_18 + arg0_19.level
	end)

	return var1_18
end

function var0_0.AddShip(arg0_20, arg1_20, arg2_20)
	assert(arg1_20.class == WorldMapShip)
	assert(not _.any(arg0_20:GetShips(true), function(arg0_21)
		return arg0_21.id == arg1_20.id
	end), "ship exist in port: " .. arg1_20.id)

	local var0_20 = WorldConst.FetchRawShipVO(arg1_20.id)

	assert(var0_20, "ship not exist: " .. arg1_20.id)

	local var1_20 = arg0_20[var0_20:getTeamType()]

	arg2_20 = arg2_20 or #var1_20 + 1
	arg1_20.fleetId = arg0_20.id

	table.insert(var1_20, arg2_20, arg1_20)
	arg0_20:DispatchEvent(var0_0.EventAddShip, arg1_20)
end

function var0_0.RemoveShip(arg0_22, arg1_22)
	local var0_22 = WorldConst.FetchRawShipVO(arg1_22)

	assert(var0_22, "ship not exist: " .. arg1_22)

	local var1_22 = arg0_22[var0_22:getTeamType()]

	for iter0_22 = #var1_22, 1, -1 do
		if var1_22[iter0_22].id == arg1_22 then
			local var2_22 = table.remove(var1_22, iter0_22)

			var2_22.fleetId = nil

			arg0_22:DispatchEvent(var0_0.EventRemoveShip, var2_22)

			return var2_22, iter0_22
		end
	end
end

function var0_0.ReplaceShip(arg0_23, arg1_23, arg2_23)
	assert(arg0_23:GetShip(arg1_23))

	if arg0_23:GetShip(arg2_23.id) then
		arg0_23:SwitchShip(arg1_23, arg2_23.id)
	else
		local var0_23, var1_23 = arg0_23:RemoveShip(arg1_23)

		arg0_23:AddShip(arg2_23, var1_23)
	end
end

function var0_0.SwitchShip(arg0_24, arg1_24, arg2_24)
	local var0_24 = WorldConst.FetchRawShipVO(arg1_24)
	local var1_24 = WorldConst.FetchRawShipVO(arg2_24)

	assert(var0_24 and var1_24)

	local var2_24 = var0_24:getTeamType()
	local var3_24 = var1_24:getTeamType()

	assert(var2_24 == var3_24)

	local var4_24
	local var5_24

	for iter0_24, iter1_24 in ipairs(arg0_24[var2_24]) do
		if iter1_24.id == arg1_24 then
			var4_24 = iter0_24
		end

		if iter1_24.id == arg2_24 then
			var5_24 = iter0_24
		end
	end

	if var4_24 ~= var5_24 then
		arg0_24[var2_24][var4_24], arg0_24[var3_24][var5_24] = arg0_24[var3_24][var5_24], arg0_24[var2_24][var4_24]

		arg0_24:DispatchEvent(var0_0.EventUpdateShipOrder)
	end
end

function var0_0.CheckRemoveShip(arg0_25, arg1_25)
	local var0_25 = arg1_25:getTeamType()

	if #arg0_25:GetTeamShips(var0_25, true) == 1 then
		return false, i18n("ship_formationUI_removeError_onlyShip", arg1_25:getConfig("name"), "", Fleet.C_TEAM_NAME[var0_25])
	end

	return true
end

function var0_0.CheckChangeShip(arg0_26, arg1_26, arg2_26)
	if not (arg1_26 and WorldConst.FetchWorldShip(arg1_26.id).fleetId == WorldConst.FetchWorldShip(arg2_26.id).fleetId) and (not arg1_26 or not arg1_26:isSameKind(arg2_26)) and _.any(arg0_26:GetShips(true), function(arg0_27)
		return WorldConst.FetchRawShipVO(arg0_27.id):isSameKind(arg2_26)
	end) then
		return false, i18n("ship_formationMediator_changeNameError_sameShip")
	end

	return true
end

function var0_0.GetAmmo(arg0_28)
	return arg0_28.ammo, arg0_28.ammoMax
end

function var0_0.UseAmmo(arg0_29)
	assert(arg0_29.ammo > 0, "without ammo")

	arg0_29.ammo = arg0_29.ammo - 1
end

function var0_0.GetTotalAmmo(arg0_30)
	return _.reduce(arg0_30:GetShips(true), 0, function(arg0_31, arg1_31)
		return arg0_31 + arg1_31:GetImportWorldShipVO():getShipAmmo()
	end)
end

function var0_0.RepairSubmarine(arg0_32)
	_.each(arg0_32:GetTeamShips(TeamType.Submarine, true), function(arg0_33)
		arg0_33:Repair()
	end)

	arg0_32.ammo = arg0_32:GetTotalAmmo()
	arg0_32.ammoMax = arg0_32.ammo
end

function var0_0.GetSpeed(arg0_34)
	local var0_34 = pg.gameset.world_move_initial_step.key_value

	if #arg0_34:GetBuffsByTrap(WorldBuff.TrapVortex) > 0 then
		var0_34 = math.min(var0_34, 1)
	end

	for iter0_34, iter1_34 in ipairs(arg0_34:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		var0_34 = math.min(var0_34, iter1_34:GetTrapParams()[2])
	end

	return var0_34
end

function var0_0.GetStepDurationRate(arg0_35)
	local var0_35 = 1

	for iter0_35, iter1_35 in ipairs(arg0_35:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		var0_35 = math.min(var0_35, iter1_35:GetTrapParams()[3] / 100)
	end

	return 1 / var0_35
end

function var0_0.GetFOVRange(arg0_36)
	local var0_36 = 1

	for iter0_36, iter1_36 in ipairs(arg0_36:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		var0_36 = math.min(var0_36, iter1_36:GetTrapParams()[1] / 100)
	end

	return math.floor(WorldConst.GetFOVRadius() * var0_36)
end

function var0_0.GetCarries(arg0_37)
	return arg0_37.carries
end

function var0_0.ExistCarry(arg0_38, arg1_38)
	return _.any(arg0_38.carries, function(arg0_39)
		return arg0_39.id == arg1_38
	end)
end

function var0_0.AddCarry(arg0_40, arg1_40)
	table.insert(arg0_40.carries, arg1_40)
	arg0_40:DispatchEvent(WorldMapFleet.EventAddCarry, arg1_40)
end

function var0_0.RemoveCarry(arg0_41, arg1_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.carries) do
		if iter1_41.id == arg1_41 then
			for iter2_41 = #arg0_41.carries, iter0_41 + 1, -1 do
				arg0_41.carries[iter2_41]:UpdateOffset(arg0_41.carries[iter2_41 - 1].offsetRow, arg0_41.carries[iter2_41 - 1].offsetColumn)
			end

			table.remove(arg0_41.carries, iter0_41)
			arg0_41:DispatchEvent(WorldMapFleet.EventRemoveCarry, iter1_41)

			break
		end
	end
end

function var0_0.RemoveAllCarries(arg0_42)
	local var0_42

	for iter0_42 = #arg0_42.carries, 1, -1 do
		local var1_42 = table.remove(arg0_42.carries)

		arg0_42:DispatchEvent(WorldMapFleet.EventRemoveCarry, var1_42)
	end
end

function var0_0.BuildCarryPath(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg0_43:GetCarries()
	local var1_43 = table.indexof(var0_43, arg1_43)

	assert(var1_43, "can not find carry item: " .. arg1_43.id)

	local var2_43 = _.map(arg3_43, function(arg0_44)
		return {
			row = arg0_44.row,
			column = arg0_44.column
		}
	end)

	table.insert(var2_43, 1, {
		row = arg2_43.row,
		column = arg2_43.column
	})

	for iter0_43 = 1, var1_43 - 1 do
		table.insert(var2_43, 1, {
			row = arg2_43.row + var0_43[iter0_43].offsetRow,
			column = arg2_43.column + var0_43[iter0_43].offsetColumn
		})
	end

	while #var2_43 > #arg3_43 do
		table.remove(var2_43, #var2_43)
	end

	for iter1_43, iter2_43 in ipairs(var2_43) do
		var2_43[iter1_43].duration = arg3_43[iter1_43].duration
	end

	return var2_43
end

function var0_0.HasDamageLevel(arg0_45)
	return arg0_45.damageLevel > 0
end

function var0_0.IncDamageLevel(arg0_46, arg1_46)
	local var0_46 = pg.world_expedition_data[arg1_46:GetBattleStageId()].failed_morale
	local var1_46 = math.min(#WorldConst.DamageBuffList, arg0_46.damageLevel + (var0_46 or 1))

	if var1_46 ~= arg0_46.damageLevel then
		arg0_46.damageLevel = var1_46

		arg0_46:DispatchEvent(var0_0.EventUpdateDamageLevel)
	end
end

function var0_0.ClearDamageLevel(arg0_47)
	local var0_47 = 0

	if var0_47 ~= arg0_47.damageLevel then
		arg0_47.damageLevel = var0_47

		arg0_47:DispatchEvent(var0_0.EventUpdateDamageLevel)
	end
end

function var0_0.GetDamageBuff(arg0_48)
	if arg0_48.damageLevel > 0 then
		local var0_48 = WorldBuff.New()

		var0_48:Setup({
			floor = 1,
			id = WorldConst.DamageBuffList[arg0_48.damageLevel]
		})

		return var0_48
	end
end

function var0_0.GetBuffList(arg0_49)
	local var0_49 = _.filter(_.values(arg0_49.buffs), function(arg0_50)
		return arg0_50:GetFloor() > 0
	end)
	local var1_49 = nowWorld():GetActiveMap()

	return table.mergeArray(var0_49, var1_49:GetBuffList(WorldMap.FactionSelf))
end

function var0_0.UpdateBuffs(arg0_51, arg1_51)
	if arg0_51.buffs ~= arg1_51 then
		local var0_51 = nowWorld()

		if not var0_51.isAutoFight then
			local var1_51 = var0_51:GetActiveMap()

			for iter0_51, iter1_51 in pairs(WorldConst.CompareBuffs(arg0_51.buffs, arg1_51).add) do
				if #iter1_51.config.trap_lua > 0 then
					var1_51:AddPhaseDisplay({
						story = iter1_51.config.trap_lua
					})
				end
			end
		end

		arg0_51.buffs = arg1_51

		arg0_51:DispatchEvent(var0_0.EventUpdateBuff)
	end
end

function var0_0.GetBuff(arg0_52, arg1_52)
	return arg0_52.buffs[arg1_52]
end

function var0_0.GetBuffsByTrap(arg0_53, arg1_53)
	return underscore.filter(arg0_53:GetBuffList(), function(arg0_54)
		return arg0_54:GetTrapType() == arg1_53
	end)
end

function var0_0.HasTrapBuff(arg0_55)
	for iter0_55, iter1_55 in ipairs(arg0_55:GetBuffList()) do
		if iter1_55:GetTrapType() ~= 0 then
			return true
		end
	end

	return false
end

function var0_0.GetBuffFxList(arg0_56)
	local var0_56 = {}

	_.each(arg0_56:GetBuffList(), function(arg0_57)
		if arg0_57.config.buff_fx and #arg0_57.config.buff_fx > 0 then
			table.insert(var0_56, arg0_57.config.buff_fx)
		end
	end)

	return var0_56
end

function var0_0.GetWatchingBuff(arg0_58)
	local var0_58 = {}

	for iter0_58, iter1_58 in ipairs(pg.gameset.world_sairenbuff_fleeticon.description) do
		var0_58[iter1_58] = true
	end

	for iter2_58, iter3_58 in ipairs(arg0_58:GetBuffList()) do
		if var0_58[iter3_58.id] then
			return iter3_58
		end
	end

	return nil
end

function var0_0.AddDefeatEnemies(arg0_59, arg1_59)
	if arg1_59 then
		arg0_59.defeatEnemies = arg0_59.defeatEnemies + 1

		arg0_59:DispatchEvent(var0_0.EventUpdateDefeat)
	end
end

function var0_0.ClearDefeatEnemies(arg0_60)
	arg0_60.defeatEnemies = 0

	arg0_60:DispatchEvent(var0_0.EventUpdateDefeat)
end

function var0_0.getDefeatCount(arg0_61)
	return arg0_61.defeatEnemies
end

function var0_0.getMapAura(arg0_62)
	local var0_62 = {}

	for iter0_62, iter1_62 in ipairs(arg0_62:GetShips(true)) do
		var0_62 = table.mergeArray(var0_62, iter1_62:GetImportWorldShipVO():getMapAuras())
	end

	return var0_62
end

function var0_0.getMapAid(arg0_63)
	local var0_63 = {}

	for iter0_63, iter1_63 in ipairs(arg0_63:GetShips(true)) do
		local var1_63 = iter1_63:GetImportWorldShipVO():getMapAids()

		for iter2_63, iter3_63 in ipairs(var1_63) do
			var0_63[iter1_63] = var0_63[iter1_63] or {}

			table.insert(var0_63[iter1_63], iter3_63)
		end
	end

	return var0_63
end

function var0_0.outputCommanders(arg0_64)
	local var0_64 = {}

	for iter0_64, iter1_64 in pairs(arg0_64.commanderIds) do
		assert(iter1_64, "id is nil")
		table.insert(var0_64, {
			pos = iter0_64,
			id = iter1_64
		})
	end

	return var0_64
end

function var0_0.getCommanders(arg0_65, arg1_65)
	local var0_65 = {}

	if arg1_65 and arg0_65:IsCatSalvage() then
		-- block empty
	else
		for iter0_65, iter1_65 in pairs(arg0_65.commanderIds) do
			var0_65[iter0_65] = getProxy(CommanderProxy):getCommanderById(iter1_65)
		end
	end

	return var0_65
end

function var0_0.getCommanderByPos(arg0_66, arg1_66)
	return arg0_66:getCommanders()[arg1_66]
end

function var0_0.updateCommanderByPos(arg0_67, arg1_67, arg2_67)
	if arg2_67 then
		arg0_67.commanderIds[arg1_67] = arg2_67.id
	else
		arg0_67.commanderIds[arg1_67] = nil
	end

	arg0_67:updateCommanderSkills()
end

function var0_0.getCommandersAddition(arg0_68)
	local var0_68 = {}

	for iter0_68, iter1_68 in pairs(CommanderConst.PROPERTIES) do
		local var1_68 = 0

		for iter2_68, iter3_68 in pairs(arg0_68:getCommanders()) do
			var1_68 = var1_68 + iter3_68:getAbilitysAddition()[iter1_68]
		end

		if var1_68 > 0 then
			table.insert(var0_68, {
				attrName = iter1_68,
				value = var1_68
			})
		end
	end

	return var0_68
end

function var0_0.getCommandersTalentDesc(arg0_69)
	local var0_69 = {}

	for iter0_69, iter1_69 in pairs(arg0_69:getCommanders()) do
		local var1_69 = iter1_69:getTalentsDesc()

		for iter2_69, iter3_69 in pairs(var1_69) do
			if var0_69[iter2_69] then
				var0_69[iter2_69].value = var0_69[iter2_69].value + iter3_69.value
			else
				var0_69[iter2_69] = {
					name = iter2_69,
					value = iter3_69.value,
					type = iter3_69.type
				}
			end
		end
	end

	return var0_69
end

function var0_0.findCommanderBySkillId(arg0_70, arg1_70)
	local var0_70 = arg0_70:getCommanders()

	for iter0_70, iter1_70 in pairs(var0_70) do
		if _.any(iter1_70:getSkills(), function(arg0_71)
			return _.any(arg0_71:GetTacticSkillForWorld(), function(arg0_72)
				return arg0_72 == arg1_70
			end)
		end) then
			return iter1_70
		end
	end
end

function var0_0.updateCommanderSkills(arg0_73)
	local var0_73 = #arg0_73.skills

	while var0_73 > 0 do
		local var1_73 = arg0_73.skills[var0_73]

		if not arg0_73:findCommanderBySkillId(var1_73.id) and var1_73:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0_73.skills, var0_73)
		end

		var0_73 = var0_73 - 1
	end

	local var2_73 = arg0_73:getCommanders()

	for iter0_73, iter1_73 in pairs(var2_73) do
		for iter2_73, iter3_73 in ipairs(iter1_73:getSkills()) do
			for iter4_73, iter5_73 in ipairs(iter3_73:GetTacticSkillForWorld()) do
				table.insert(arg0_73.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5_73))
			end
		end
	end
end

function var0_0.getSkills(arg0_74)
	return arg0_74.skills
end

function var0_0.getSkill(arg0_75, arg1_75)
	return _.detect(arg0_75:getSkills(), function(arg0_76)
		return arg0_76.id == arg1_75
	end)
end

function var0_0.findSkills(arg0_77, arg1_77)
	return _.filter(arg0_77:getSkills(), function(arg0_78)
		return arg0_78:GetType() == arg1_77
	end)
end

function var0_0.IsCatSalvage(arg0_79)
	return arg0_79.catSalvageFrom and arg0_79.catSalvageFrom > 0
end

function var0_0.UpdateCatSalvage(arg0_80, arg1_80, arg2_80, arg3_80)
	arg0_80.catSalvageStep = arg1_80
	arg0_80.catSalvageList = arg2_80
	arg0_80.catSalvageFrom = arg3_80

	local var0_80 = nowWorld()

	if arg0_80:GetRarityState() == 2 and not var0_80.isAutoFight then
		var0_80:GetActiveMap():AddPhaseDisplay({
			story = pg.gameset.world_catsearch_raritytip.description[1]
		})
	end

	arg0_80:DispatchEvent(var0_0.EventUpdateCatSalvage)
end

function var0_0.IsSalvageFinish(arg0_81)
	return arg0_81.catSalvageStep == #arg0_81.catSalvageList
end

local function var1_0(arg0_82)
	return pg.world_catsearch_node[arg0_82].special_drop == 1
end

function var0_0.GetRarityState(arg0_83)
	if arg0_83.catSalvageStep == 0 then
		return 0
	end

	if var1_0(arg0_83.catSalvageList[arg0_83.catSalvageStep]) then
		return 2
	else
		for iter0_83 = 1, arg0_83.catSalvageStep - 1 do
			if var1_0(arg0_83.catSalvageList[iter0_83]) then
				return 1
			end
		end
	end

	return 0
end

function var0_0.GetSalvageScoreRarity(arg0_84)
	local var0_84 = 0

	for iter0_84, iter1_84 in ipairs(arg0_84.catSalvageList) do
		var0_84 = var0_84 + pg.world_catsearch_node[iter1_84].score
	end

	local var1_84

	for iter2_84, iter3_84 in ipairs(pg.gameset.world_catsearch_score.description) do
		if iter3_84 < var0_84 then
			var1_84 = iter2_84
		else
			break
		end
	end

	return var1_84
end

function var0_0.GetDisplayCommander(arg0_85)
	local var0_85 = arg0_85:getCommanders()

	for iter0_85 = 1, 2 do
		if arg0_85.commanderIds[iter0_85] then
			return getProxy(CommanderProxy):getCommanderById(arg0_85.commanderIds[iter0_85])
		end
	end
end

function var0_0.HasCommander(arg0_86, arg1_86)
	for iter0_86, iter1_86 in pairs(arg0_86.commanderIds) do
		if arg1_86 == iter1_86 then
			return true
		end
	end

	return false
end

function var0_0.switchShip(arg0_87, arg1_87, arg2_87, arg3_87, arg4_87, arg5_87)
	arg0_87:SwitchShip(arg4_87, arg5_87)
end

return var0_0
