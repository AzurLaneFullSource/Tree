local var0_0 = class("FleetSkill", import(".BaseVO"))

var0_0.SystemCommanderNeko = 1
var0_0.TypeMoveSpeed = "move_speed"
var0_0.TypeHuntingLv = "hunt_lv"
var0_0.TypeAmbushDodge = "ambush_dodge"
var0_0.TypeAirStrikeDodge = "airfight_doge"
var0_0.TypeStrategy = "strategy"
var0_0.TypeBattleBuff = "battle_buff"
var0_0.TypeAttack = "attack"
var0_0.TypeTorpedoPowerUp = "torpedo_power_up"
var0_0.TriggerDDHead = "dd_head"
var0_0.TriggerAroundEnemy = "around_enemy"
var0_0.TriggerVanCount = "vang_count"
var0_0.TriggerNekoPos = "pos"
var0_0.TriggerAroundLand = "around_land"
var0_0.TriggerAroundCombatAlly = "around_combat_ally"
var0_0.TriggerShipCount = "count"
var0_0.TriggerInSubTeam = "insubteam"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.system = arg1_1
	arg0_1.id = arg2_1
	arg0_1.configId = arg0_1.id
end

function var0_0.GetSystem(arg0_2)
	return arg0_2.system
end

function var0_0.bindConfigTable(arg0_3)
	if arg0_3:GetSystem() == var0_0.SystemCommanderNeko then
		return pg.commander_skill_effect_template
	end

	assert(false, "Do not support exception.")
end

function var0_0.GetType(arg0_4)
	if arg0_4:GetSystem() == var0_0.SystemCommanderNeko then
		return arg0_4:getConfig("effect_type")
	end

	assert(false, "Do not support exception.")
end

function var0_0.GetArgs(arg0_5)
	if arg0_5:GetSystem() == var0_0.SystemCommanderNeko then
		return arg0_5:getConfig("args")
	end

	assert(false, "Do not support exception.")
end

function var0_0.GetTriggers(arg0_6)
	if arg0_6:GetSystem() == var0_0.SystemCommanderNeko then
		return arg0_6:getConfig("condition")
	end

	assert(false, "Do not support exception.")
end

function var0_0.triggerSkill(arg0_7, arg1_7)
	local var0_7 = _.filter(arg0_7:findSkills(arg1_7), function(arg0_8)
		local var0_8 = arg0_8:GetTriggers()

		return _.any(var0_8, function(arg0_9)
			return arg0_9[1] == FleetSkill.TriggerInSubTeam and arg0_9[2] == 1
		end) == (arg0_7:getFleetType() == FleetType.Submarine) and _.all(arg0_8:GetTriggers(), function(arg0_10)
			return var0_0.NoneChapterFleetCheck(arg0_7, arg0_8, arg0_10)
		end)
	end)

	return _.reduce(var0_7, nil, function(arg0_11, arg1_11)
		local var0_11 = arg1_11:GetType()
		local var1_11 = arg1_11:GetArgs()

		if var0_11 == FleetSkill.TypeBattleBuff then
			arg0_11 = arg0_11 or {}

			table.insert(arg0_11, var1_11[1])

			return arg0_11
		end
	end), var0_7
end

function var0_0.NoneChapterFleetCheck(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg2_12[1]
	local var1_12 = getProxy(BayProxy)

	if var0_12 == FleetSkill.TriggerDDHead then
		local var2_12 = var1_12:getShipByTeam(arg0_12, TeamType.Vanguard)

		return #var2_12 > 0 and ShipType.IsTypeQuZhu(var2_12[1]:getShipType())
	elseif var0_12 == FleetSkill.TriggerVanCount then
		local var3_12 = var1_12:getShipByTeam(arg0_12, TeamType.Vanguard)

		return #var3_12 >= arg2_12[2] and #var3_12 <= arg2_12[3]
	elseif var0_12 == FleetSkill.TriggerShipCount then
		local var4_12 = _.filter(var1_12:getShipsByFleet(arg0_12), function(arg0_13)
			return table.contains(arg2_12[2], arg0_13:getShipType())
		end)

		return #var4_12 >= arg2_12[3] and #var4_12 <= arg2_12[4]
	elseif var0_12 == FleetSkill.TriggerNekoPos then
		local var5_12 = arg0_12:findCommanderBySkillId(arg1_12.id)

		for iter0_12, iter1_12 in pairs(arg0_12:getCommanders()) do
			if var5_12.id == iter1_12.id and iter0_12 == arg2_12[2] then
				return true
			end
		end
	elseif var0_12 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

function var0_0.triggerMirrorSkill(arg0_14, arg1_14)
	local var0_14 = _.filter(arg0_14:findSkills(arg1_14), function(arg0_15)
		local var0_15 = arg0_15:GetTriggers()

		return _.any(var0_15, function(arg0_16)
			return arg0_16[1] == FleetSkill.TriggerInSubTeam and arg0_16[2] == 1
		end) == (arg0_14:getFleetType() == FleetType.Submarine) and _.all(arg0_15:GetTriggers(), function(arg0_17)
			return var0_0.MirrorFleetCheck(arg0_14, arg0_15, arg0_17)
		end)
	end)

	return _.reduce(var0_14, nil, function(arg0_18, arg1_18)
		local var0_18 = arg1_18:GetType()
		local var1_18 = arg1_18:GetArgs()

		if var0_18 == FleetSkill.TypeBattleBuff then
			arg0_18 = arg0_18 or {}

			table.insert(arg0_18, var1_18[1])

			return arg0_18
		end
	end), var0_14
end

function var0_0.MirrorFleetCheck(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg2_19[1]
	local var1_19 = getProxy(BayProxy)

	if var0_19 == FleetSkill.TriggerDDHead then
		local var2_19 = arg0_19:getShipsByTeam(TeamType.Vanguard, false)

		return #var2_19 > 0 and ShipType.IsTypeQuZhu(var2_19[1]:getShipType())
	elseif var0_19 == FleetSkill.TriggerVanCount then
		local var3_19 = arg0_19:getShipsByTeam(TeamType.Vanguard, false)

		return #var3_19 >= arg2_19[2] and #var3_19 <= arg2_19[3]
	elseif var0_19 == FleetSkill.TriggerShipCount then
		local var4_19 = _.filter(arg0_19:getShips(false), function(arg0_20)
			return table.contains(arg2_19[2], arg0_20:getShipType())
		end)

		return #var4_19 >= arg2_19[3] and #var4_19 <= arg2_19[4]
	elseif var0_19 == FleetSkill.TriggerNekoPos then
		local var5_19 = arg0_19:findCommanderBySkillId(arg1_19.id)

		for iter0_19, iter1_19 in pairs(arg0_19:getCommanders()) do
			if var5_19.id == iter1_19.id and iter0_19 == arg2_19[2] then
				return true
			end
		end
	elseif var0_19 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

function var0_0.GuildBossTriggerSkill(arg0_21, arg1_21)
	local var0_21 = _.filter(arg0_21:findSkills(arg1_21), function(arg0_22)
		local var0_22 = arg0_22:GetTriggers()

		return _.any(var0_22, function(arg0_23)
			return arg0_23[1] == FleetSkill.TriggerInSubTeam and arg0_23[2] == 1
		end) == (arg0_21:getFleetType() == FleetType.Submarine) and _.all(arg0_22:GetTriggers(), function(arg0_24)
			return var0_0.GuildBossFleetCheck(arg0_21, arg0_22, arg0_24)
		end)
	end)

	return _.reduce(var0_21, nil, function(arg0_25, arg1_25)
		local var0_25 = arg1_25:GetType()
		local var1_25 = arg1_25:GetArgs()

		if var0_25 == FleetSkill.TypeBattleBuff then
			arg0_25 = arg0_25 or {}

			table.insert(arg0_25, var1_25[1])

			return arg0_25
		end
	end), var0_21
end

function var0_0.GuildBossFleetCheck(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26[1]

	if var0_26 == FleetSkill.TriggerDDHead then
		local var1_26 = arg0_26:GetTeamTypeShips(TeamType.Vanguard)

		return #var1_26 > 0 and ShipType.IsTypeQuZhu(var1_26[1]:getShipType())
	elseif var0_26 == FleetSkill.TriggerVanCount then
		local var2_26 = arg0_26:GetTeamTypeShips(TeamType.Vanguard)

		return #var2_26 >= arg2_26[2] and #var2_26 <= arg2_26[3]
	elseif var0_26 == FleetSkill.TriggerShipCount then
		local var3_26 = _.filter(arg0_26:GetShips(), function(arg0_27)
			local var0_27 = arg0_27.ship

			return table.contains(arg2_26[2], var0_27:getShipType())
		end)

		return #var3_26 >= arg2_26[3] and #var3_26 <= arg2_26[4]
	elseif var0_26 == FleetSkill.TriggerNekoPos then
		local var4_26 = arg0_26:findCommanderBySkillId(arg1_26.id)

		for iter0_26, iter1_26 in pairs(arg0_26:getCommanders()) do
			if var4_26.id == iter1_26.id and iter0_26 == arg2_26[2] then
				return true
			end
		end
	elseif var0_26 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

return var0_0
