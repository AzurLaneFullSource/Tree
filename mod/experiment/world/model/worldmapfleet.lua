local var0 = class("WorldMapFleet", import(".WorldBaseFleet"))

var0.Fields = {
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
var0.EventUpdateLocation = "WorldMapFleet.EventUpdateLocation"
var0.EventUpdateShipOrder = "WorldMapFleet.EventUpdateShipOrder"
var0.EventAddShip = "WorldMapFleet.EventAddShip"
var0.EventRemoveShip = "WorldMapFleet.EventRemoveShip"
var0.EventAddCarry = "WorldMapFleet.EventAddCarry"
var0.EventRemoveCarry = "WorldMapFleet.EventRemoveCarry"
var0.EventUpdateBuff = "WorldMapFleet.EventUpdateBuff"
var0.EventUpdateDamageLevel = "WorldMapFleet.EventUpdateDamageLevel"
var0.EventUpdateDefeat = "WorldMapFleet.EventUpdateDefeat"
var0.EventUpdateCatSalvage = "WorldMapFleet.EventUpdateCatSalvage"

function var0.GetName(arg0)
	return "fleet_" .. arg0
end

function var0.DebugPrint(arg0)
	local var0 = _.map(arg0:GetBuffList(), function(arg0)
		return arg0.id .. "#" .. arg0:GetFloor()
	end)
	local var1 = _.map(arg0.carries, function(arg0)
		return "carries"
	end)
	local var2, var3 = arg0:GetAmmo()
	local var4 = string.format("[第%s舰队] [id: %s] [位置: %s, %s] [弹药: %s/%s] [携带物: %s] [战损: %s] [buff: %s]", arg0.index, arg0.id, arg0.row, arg0.column, var2, var3, table.concat(var1, ", "), arg0.damageLevel, table.concat(var0, ", "))
	local var5 = {
		[TeamType.Main] = "主力",
		[TeamType.Vanguard] = "先锋",
		[TeamType.Submarine] = "潜艇"
	}
	local var6 = {}

	for iter0, iter1 in ipairs(arg0:GetShips(true)) do
		local var7 = WorldConst.FetchShipVO(iter1.id)
		local var8 = _.map(iter1:GetBuffList(), function(arg0)
			return arg0.id .. "#" .. arg0:GetFloor()
		end)
		local var9 = string.format("\t\t[%s] [id: %s] [config_id: %s] [%s] [hp: %s%%] [buff: %s]" .. " <material=underline c=#A9F548 event=ShipProperty args=%s><color=#A9F548>属性</color></material>", var7:getName(), var7.id, var7.configId, var5[var7:getTeamType()], iter1.hpRant / 100, table.concat(var8, ", "), var7.id)

		table.insert(var6, var9)
	end

	return var4 .. "\n" .. table.concat(var6, "\n")
end

function var0.Build(arg0)
	var0.super.Build(arg0)

	arg0.carries = {}
end

function var0.Setup(arg0, arg1)
	arg0.id = arg1.id

	local var0 = _.map(arg1.ship_list, function(arg0)
		local var0 = WPool:Get(WorldMapShip)

		var0:Setup(arg0)

		return var0
	end)

	arg0:UpdateShips(var0)

	arg0.commanderIds = {}

	for iter0, iter1 in ipairs(arg1.commander_list or {}) do
		arg0.commanderIds[iter1.pos] = iter1.id
	end

	arg0.skills = {}

	arg0:updateCommanderSkills()

	arg0.row = arg1.pos.row
	arg0.column = arg1.pos.column
	arg0.ammo = arg1.bullet
	arg0.ammoMax = arg1.bullet_max
	arg0.damageLevel = math.clamp(arg1.damage_level, 0, #WorldConst.DamageBuffList)

	_.each(arg1.attach_list, function(arg0)
		local var0 = WPool:Get(WorldCarryItem)

		var0:Setup(arg0)
		table.insert(arg0.carries, var0)
	end)

	arg0.buffs = WorldConst.ParsingBuffs(arg1.buff_list)
	arg0.defeatEnemies = arg1.kill_count
	arg0.catSalvageStep = arg1.cmd_collection.progress
	arg0.catSalvageList = arg1.cmd_collection.progress_list
	arg0.catSalvageFrom = arg1.cmd_collection.random_id

	if arg0:GetFleetType() == FleetType.Submarine then
		arg0.row = -1
		arg0.column = -1
	end
end

function var0.GetCost(arg0)
	local var0 = {
		gold = 0,
		oil = 0
	}
	local var1 = {
		gold = 0,
		oil = 0
	}

	return var0, var1
end

function var0.GetFleetIndex(arg0)
	return arg0.index
end

function var0.GetDefaultName(arg0)
	return Fleet.DEFAULT_NAME[#arg0[TeamType.Submarine] > 0 and arg0.index + 10 or arg0.index]
end

function var0.FormationEqual(arg0, arg1)
	local var0 = _.map(arg0:GetShips(true), function(arg0)
		return arg0.id
	end)
	local var1 = _.map(arg1:GetShips(true), function(arg0)
		return arg0.id
	end)

	for iter0 = 1, math.max(#var0, #var1) do
		if var0[iter0] ~= var1[iter0] then
			return false
		end
	end

	return true
end

function var0.GetPropertiesSum(arg0)
	local var0 = {
		cannon = 0,
		antiAir = 0,
		air = 0,
		torpedo = 0
	}
	local var1 = arg0:GetShipVOs(true)

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1:getProperties()

		var0.cannon = var0.cannon + math.floor(var2.cannon)
		var0.torpedo = var0.torpedo + math.floor(var2.torpedo)
		var0.antiAir = var0.antiAir + math.floor(var2.antiaircraft)
		var0.air = var0.air + math.floor(var2.air)
	end

	return var0
end

function var0.GetGearScoreSum(arg0, arg1)
	local var0 = 0
	local var1 = arg1 and arg0:GetTeamShipVOs(arg1) or arg0:GetShipVOs()

	for iter0, iter1 in ipairs(var1) do
		var0 = var0 + iter1:getShipCombatPower()
	end

	return var0
end

function var0.GetLevelCount(arg0)
	local var0 = arg0:GetShipVOs()
	local var1 = 0

	underscore.each(var0, function(arg0)
		var1 = var1 + arg0.level
	end)

	return var1
end

function var0.AddShip(arg0, arg1, arg2)
	assert(arg1.class == WorldMapShip)
	assert(not _.any(arg0:GetShips(true), function(arg0)
		return arg0.id == arg1.id
	end), "ship exist in port: " .. arg1.id)

	local var0 = WorldConst.FetchRawShipVO(arg1.id)

	assert(var0, "ship not exist: " .. arg1.id)

	local var1 = arg0[var0:getTeamType()]

	arg2 = arg2 or #var1 + 1
	arg1.fleetId = arg0.id

	table.insert(var1, arg2, arg1)
	arg0:DispatchEvent(var0.EventAddShip, arg1)
end

function var0.RemoveShip(arg0, arg1)
	local var0 = WorldConst.FetchRawShipVO(arg1)

	assert(var0, "ship not exist: " .. arg1)

	local var1 = arg0[var0:getTeamType()]

	for iter0 = #var1, 1, -1 do
		if var1[iter0].id == arg1 then
			local var2 = table.remove(var1, iter0)

			var2.fleetId = nil

			arg0:DispatchEvent(var0.EventRemoveShip, var2)

			return var2, iter0
		end
	end
end

function var0.ReplaceShip(arg0, arg1, arg2)
	assert(arg0:GetShip(arg1))

	if arg0:GetShip(arg2.id) then
		arg0:SwitchShip(arg1, arg2.id)
	else
		local var0, var1 = arg0:RemoveShip(arg1)

		arg0:AddShip(arg2, var1)
	end
end

function var0.SwitchShip(arg0, arg1, arg2)
	local var0 = WorldConst.FetchRawShipVO(arg1)
	local var1 = WorldConst.FetchRawShipVO(arg2)

	assert(var0 and var1)

	local var2 = var0:getTeamType()
	local var3 = var1:getTeamType()

	assert(var2 == var3)

	local var4
	local var5

	for iter0, iter1 in ipairs(arg0[var2]) do
		if iter1.id == arg1 then
			var4 = iter0
		end

		if iter1.id == arg2 then
			var5 = iter0
		end
	end

	if var4 ~= var5 then
		arg0[var2][var4], arg0[var3][var5] = arg0[var3][var5], arg0[var2][var4]

		arg0:DispatchEvent(var0.EventUpdateShipOrder)
	end
end

function var0.CheckRemoveShip(arg0, arg1)
	local var0 = arg1:getTeamType()

	if #arg0:GetTeamShips(var0, true) == 1 then
		return false, i18n("ship_formationUI_removeError_onlyShip", arg1:getConfig("name"), "", Fleet.C_TEAM_NAME[var0])
	end

	return true
end

function var0.CheckChangeShip(arg0, arg1, arg2)
	if not (arg1 and WorldConst.FetchWorldShip(arg1.id).fleetId == WorldConst.FetchWorldShip(arg2.id).fleetId) and (not arg1 or not arg1:isSameKind(arg2)) and _.any(arg0:GetShips(true), function(arg0)
		return WorldConst.FetchRawShipVO(arg0.id):isSameKind(arg2)
	end) then
		return false, i18n("ship_formationMediator_changeNameError_sameShip")
	end

	return true
end

function var0.GetAmmo(arg0)
	return arg0.ammo, arg0.ammoMax
end

function var0.UseAmmo(arg0)
	assert(arg0.ammo > 0, "without ammo")

	arg0.ammo = arg0.ammo - 1
end

function var0.GetTotalAmmo(arg0)
	return _.reduce(arg0:GetShips(true), 0, function(arg0, arg1)
		return arg0 + arg1:GetImportWorldShipVO():getShipAmmo()
	end)
end

function var0.RepairSubmarine(arg0)
	_.each(arg0:GetTeamShips(TeamType.Submarine, true), function(arg0)
		arg0:Repair()
	end)

	arg0.ammo = arg0:GetTotalAmmo()
	arg0.ammoMax = arg0.ammo
end

function var0.GetSpeed(arg0)
	local var0 = pg.gameset.world_move_initial_step.key_value

	if #arg0:GetBuffsByTrap(WorldBuff.TrapVortex) > 0 then
		var0 = math.min(var0, 1)
	end

	for iter0, iter1 in ipairs(arg0:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		var0 = math.min(var0, iter1:GetTrapParams()[2])
	end

	return var0
end

function var0.GetStepDurationRate(arg0)
	local var0 = 1

	for iter0, iter1 in ipairs(arg0:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		var0 = math.min(var0, iter1:GetTrapParams()[3] / 100)
	end

	return 1 / var0
end

function var0.GetFOVRange(arg0)
	local var0 = 1

	for iter0, iter1 in ipairs(arg0:GetBuffsByTrap(WorldBuff.TrapCripple)) do
		var0 = math.min(var0, iter1:GetTrapParams()[1] / 100)
	end

	return math.floor(WorldConst.GetFOVRadius() * var0)
end

function var0.GetCarries(arg0)
	return arg0.carries
end

function var0.ExistCarry(arg0, arg1)
	return _.any(arg0.carries, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.AddCarry(arg0, arg1)
	table.insert(arg0.carries, arg1)
	arg0:DispatchEvent(WorldMapFleet.EventAddCarry, arg1)
end

function var0.RemoveCarry(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.carries) do
		if iter1.id == arg1 then
			for iter2 = #arg0.carries, iter0 + 1, -1 do
				arg0.carries[iter2]:UpdateOffset(arg0.carries[iter2 - 1].offsetRow, arg0.carries[iter2 - 1].offsetColumn)
			end

			table.remove(arg0.carries, iter0)
			arg0:DispatchEvent(WorldMapFleet.EventRemoveCarry, iter1)

			break
		end
	end
end

function var0.RemoveAllCarries(arg0)
	local var0

	for iter0 = #arg0.carries, 1, -1 do
		local var1 = table.remove(arg0.carries)

		arg0:DispatchEvent(WorldMapFleet.EventRemoveCarry, var1)
	end
end

function var0.BuildCarryPath(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetCarries()
	local var1 = table.indexof(var0, arg1)

	assert(var1, "can not find carry item: " .. arg1.id)

	local var2 = _.map(arg3, function(arg0)
		return {
			row = arg0.row,
			column = arg0.column
		}
	end)

	table.insert(var2, 1, {
		row = arg2.row,
		column = arg2.column
	})

	for iter0 = 1, var1 - 1 do
		table.insert(var2, 1, {
			row = arg2.row + var0[iter0].offsetRow,
			column = arg2.column + var0[iter0].offsetColumn
		})
	end

	while #var2 > #arg3 do
		table.remove(var2, #var2)
	end

	for iter1, iter2 in ipairs(var2) do
		var2[iter1].duration = arg3[iter1].duration
	end

	return var2
end

function var0.HasDamageLevel(arg0)
	return arg0.damageLevel > 0
end

function var0.IncDamageLevel(arg0, arg1)
	local var0 = pg.world_expedition_data[arg1:GetBattleStageId()].failed_morale
	local var1 = math.min(#WorldConst.DamageBuffList, arg0.damageLevel + (var0 or 1))

	if var1 ~= arg0.damageLevel then
		arg0.damageLevel = var1

		arg0:DispatchEvent(var0.EventUpdateDamageLevel)
	end
end

function var0.ClearDamageLevel(arg0)
	local var0 = 0

	if var0 ~= arg0.damageLevel then
		arg0.damageLevel = var0

		arg0:DispatchEvent(var0.EventUpdateDamageLevel)
	end
end

function var0.GetDamageBuff(arg0)
	if arg0.damageLevel > 0 then
		local var0 = WorldBuff.New()

		var0:Setup({
			floor = 1,
			id = WorldConst.DamageBuffList[arg0.damageLevel]
		})

		return var0
	end
end

function var0.GetBuffList(arg0)
	local var0 = _.filter(_.values(arg0.buffs), function(arg0)
		return arg0:GetFloor() > 0
	end)
	local var1 = nowWorld():GetActiveMap()

	return table.mergeArray(var0, var1:GetBuffList(WorldMap.FactionSelf))
end

function var0.UpdateBuffs(arg0, arg1)
	if arg0.buffs ~= arg1 then
		local var0 = nowWorld()

		if not var0.isAutoFight then
			local var1 = var0:GetActiveMap()

			for iter0, iter1 in pairs(WorldConst.CompareBuffs(arg0.buffs, arg1).add) do
				if #iter1.config.trap_lua > 0 then
					var1:AddPhaseDisplay({
						story = iter1.config.trap_lua
					})
				end
			end
		end

		arg0.buffs = arg1

		arg0:DispatchEvent(var0.EventUpdateBuff)
	end
end

function var0.GetBuff(arg0, arg1)
	return arg0.buffs[arg1]
end

function var0.GetBuffsByTrap(arg0, arg1)
	return underscore.filter(arg0:GetBuffList(), function(arg0)
		return arg0:GetTrapType() == arg1
	end)
end

function var0.HasTrapBuff(arg0)
	for iter0, iter1 in ipairs(arg0:GetBuffList()) do
		if iter1:GetTrapType() ~= 0 then
			return true
		end
	end

	return false
end

function var0.GetBuffFxList(arg0)
	local var0 = {}

	_.each(arg0:GetBuffList(), function(arg0)
		if arg0.config.buff_fx and #arg0.config.buff_fx > 0 then
			table.insert(var0, arg0.config.buff_fx)
		end
	end)

	return var0
end

function var0.GetWatchingBuff(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.gameset.world_sairenbuff_fleeticon.description) do
		var0[iter1] = true
	end

	for iter2, iter3 in ipairs(arg0:GetBuffList()) do
		if var0[iter3.id] then
			return iter3
		end
	end

	return nil
end

function var0.AddDefeatEnemies(arg0, arg1)
	if arg1 then
		arg0.defeatEnemies = arg0.defeatEnemies + 1

		arg0:DispatchEvent(var0.EventUpdateDefeat)
	end
end

function var0.ClearDefeatEnemies(arg0)
	arg0.defeatEnemies = 0

	arg0:DispatchEvent(var0.EventUpdateDefeat)
end

function var0.getDefeatCount(arg0)
	return arg0.defeatEnemies
end

function var0.getMapAura(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:GetShips(true)) do
		var0 = table.mergeArray(var0, iter1:GetImportWorldShipVO():getMapAuras())
	end

	return var0
end

function var0.getMapAid(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0:GetShips(true)) do
		local var1 = iter1:GetImportWorldShipVO():getMapAids()

		for iter2, iter3 in ipairs(var1) do
			var0[iter1] = var0[iter1] or {}

			table.insert(var0[iter1], iter3)
		end
	end

	return var0
end

function var0.outputCommanders(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.commanderIds) do
		assert(iter1, "id is nil")
		table.insert(var0, {
			pos = iter0,
			id = iter1
		})
	end

	return var0
end

function var0.getCommanders(arg0, arg1)
	local var0 = {}

	if arg1 and arg0:IsCatSalvage() then
		-- block empty
	else
		for iter0, iter1 in pairs(arg0.commanderIds) do
			var0[iter0] = getProxy(CommanderProxy):getCommanderById(iter1)
		end
	end

	return var0
end

function var0.getCommanderByPos(arg0, arg1)
	return arg0:getCommanders()[arg1]
end

function var0.updateCommanderByPos(arg0, arg1, arg2)
	if arg2 then
		arg0.commanderIds[arg1] = arg2.id
	else
		arg0.commanderIds[arg1] = nil
	end

	arg0:updateCommanderSkills()
end

function var0.getCommandersAddition(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(CommanderConst.PROPERTIES) do
		local var1 = 0

		for iter2, iter3 in pairs(arg0:getCommanders()) do
			var1 = var1 + iter3:getAbilitysAddition()[iter1]
		end

		if var1 > 0 then
			table.insert(var0, {
				attrName = iter1,
				value = var1
			})
		end
	end

	return var0
end

function var0.getCommandersTalentDesc(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0:getCommanders()) do
		local var1 = iter1:getTalentsDesc()

		for iter2, iter3 in pairs(var1) do
			if var0[iter2] then
				var0[iter2].value = var0[iter2].value + iter3.value
			else
				var0[iter2] = {
					name = iter2,
					value = iter3.value,
					type = iter3.type
				}
			end
		end
	end

	return var0
end

function var0.findCommanderBySkillId(arg0, arg1)
	local var0 = arg0:getCommanders()

	for iter0, iter1 in pairs(var0) do
		if _.any(iter1:getSkills(), function(arg0)
			return _.any(arg0:GetTacticSkillForWorld(), function(arg0)
				return arg0 == arg1
			end)
		end) then
			return iter1
		end
	end
end

function var0.updateCommanderSkills(arg0)
	local var0 = #arg0.skills

	while var0 > 0 do
		local var1 = arg0.skills[var0]

		if not arg0:findCommanderBySkillId(var1.id) and var1:GetSystem() == FleetSkill.SystemCommanderNeko then
			table.remove(arg0.skills, var0)
		end

		var0 = var0 - 1
	end

	local var2 = arg0:getCommanders()

	for iter0, iter1 in pairs(var2) do
		for iter2, iter3 in ipairs(iter1:getSkills()) do
			for iter4, iter5 in ipairs(iter3:GetTacticSkillForWorld()) do
				table.insert(arg0.skills, FleetSkill.New(FleetSkill.SystemCommanderNeko, iter5))
			end
		end
	end
end

function var0.getSkills(arg0)
	return arg0.skills
end

function var0.getSkill(arg0, arg1)
	return _.detect(arg0:getSkills(), function(arg0)
		return arg0.id == arg1
	end)
end

function var0.findSkills(arg0, arg1)
	return _.filter(arg0:getSkills(), function(arg0)
		return arg0:GetType() == arg1
	end)
end

function var0.IsCatSalvage(arg0)
	return arg0.catSalvageFrom and arg0.catSalvageFrom > 0
end

function var0.UpdateCatSalvage(arg0, arg1, arg2, arg3)
	arg0.catSalvageStep = arg1
	arg0.catSalvageList = arg2
	arg0.catSalvageFrom = arg3

	local var0 = nowWorld()

	if arg0:GetRarityState() == 2 and not var0.isAutoFight then
		var0:GetActiveMap():AddPhaseDisplay({
			story = pg.gameset.world_catsearch_raritytip.description[1]
		})
	end

	arg0:DispatchEvent(var0.EventUpdateCatSalvage)
end

function var0.IsSalvageFinish(arg0)
	return arg0.catSalvageStep == #arg0.catSalvageList
end

local function var1(arg0)
	return pg.world_catsearch_node[arg0].special_drop == 1
end

function var0.GetRarityState(arg0)
	if arg0.catSalvageStep == 0 then
		return 0
	end

	if var1(arg0.catSalvageList[arg0.catSalvageStep]) then
		return 2
	else
		for iter0 = 1, arg0.catSalvageStep - 1 do
			if var1(arg0.catSalvageList[iter0]) then
				return 1
			end
		end
	end

	return 0
end

function var0.GetSalvageScoreRarity(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.catSalvageList) do
		var0 = var0 + pg.world_catsearch_node[iter1].score
	end

	local var1

	for iter2, iter3 in ipairs(pg.gameset.world_catsearch_score.description) do
		if iter3 < var0 then
			var1 = iter2
		else
			break
		end
	end

	return var1
end

function var0.GetDisplayCommander(arg0)
	local var0 = arg0:getCommanders()

	for iter0 = 1, 2 do
		if arg0.commanderIds[iter0] then
			return getProxy(CommanderProxy):getCommanderById(arg0.commanderIds[iter0])
		end
	end
end

function var0.HasCommander(arg0, arg1)
	for iter0, iter1 in pairs(arg0.commanderIds) do
		if arg1 == iter1 then
			return true
		end
	end

	return false
end

function var0.switchShip(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0:SwitchShip(arg4, arg5)
end

return var0
