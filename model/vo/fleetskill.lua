local var0 = class("FleetSkill", import(".BaseVO"))

var0.SystemCommanderNeko = 1
var0.TypeMoveSpeed = "move_speed"
var0.TypeHuntingLv = "hunt_lv"
var0.TypeAmbushDodge = "ambush_dodge"
var0.TypeAirStrikeDodge = "airfight_doge"
var0.TypeStrategy = "strategy"
var0.TypeBattleBuff = "battle_buff"
var0.TypeAttack = "attack"
var0.TypeTorpedoPowerUp = "torpedo_power_up"
var0.TriggerDDHead = "dd_head"
var0.TriggerAroundEnemy = "around_enemy"
var0.TriggerVanCount = "vang_count"
var0.TriggerNekoPos = "pos"
var0.TriggerAroundLand = "around_land"
var0.TriggerAroundCombatAlly = "around_combat_ally"
var0.TriggerShipCount = "count"
var0.TriggerInSubTeam = "insubteam"

function var0.Ctor(arg0, arg1, arg2)
	arg0.system = arg1
	arg0.id = arg2
	arg0.configId = arg0.id
end

function var0.GetSystem(arg0)
	return arg0.system
end

function var0.bindConfigTable(arg0)
	if arg0:GetSystem() == var0.SystemCommanderNeko then
		return pg.commander_skill_effect_template
	end

	assert(false, "Do not support exception.")
end

function var0.GetType(arg0)
	if arg0:GetSystem() == var0.SystemCommanderNeko then
		return arg0:getConfig("effect_type")
	end

	assert(false, "Do not support exception.")
end

function var0.GetArgs(arg0)
	if arg0:GetSystem() == var0.SystemCommanderNeko then
		return arg0:getConfig("args")
	end

	assert(false, "Do not support exception.")
end

function var0.GetTriggers(arg0)
	if arg0:GetSystem() == var0.SystemCommanderNeko then
		return arg0:getConfig("condition")
	end

	assert(false, "Do not support exception.")
end

function var0.triggerSkill(arg0, arg1)
	local var0 = _.filter(arg0:findSkills(arg1), function(arg0)
		local var0 = arg0:GetTriggers()

		return _.any(var0, function(arg0)
			return arg0[1] == FleetSkill.TriggerInSubTeam and arg0[2] == 1
		end) == (arg0:getFleetType() == FleetType.Submarine) and _.all(arg0:GetTriggers(), function(arg0)
			return var0.NoneChapterFleetCheck(arg0, arg0, arg0)
		end)
	end)

	return _.reduce(var0, nil, function(arg0, arg1)
		local var0 = arg1:GetType()
		local var1 = arg1:GetArgs()

		if var0 == FleetSkill.TypeBattleBuff then
			arg0 = arg0 or {}

			table.insert(arg0, var1[1])

			return arg0
		end
	end), var0
end

function var0.NoneChapterFleetCheck(arg0, arg1, arg2)
	local var0 = arg2[1]
	local var1 = getProxy(BayProxy)

	if var0 == FleetSkill.TriggerDDHead then
		local var2 = var1:getShipByTeam(arg0, TeamType.Vanguard)

		return #var2 > 0 and ShipType.IsTypeQuZhu(var2[1]:getShipType())
	elseif var0 == FleetSkill.TriggerVanCount then
		local var3 = var1:getShipByTeam(arg0, TeamType.Vanguard)

		return #var3 >= arg2[2] and #var3 <= arg2[3]
	elseif var0 == FleetSkill.TriggerShipCount then
		local var4 = _.filter(var1:getShipsByFleet(arg0), function(arg0)
			return table.contains(arg2[2], arg0:getShipType())
		end)

		return #var4 >= arg2[3] and #var4 <= arg2[4]
	elseif var0 == FleetSkill.TriggerNekoPos then
		local var5 = arg0:findCommanderBySkillId(arg1.id)

		for iter0, iter1 in pairs(arg0:getCommanders()) do
			if var5.id == iter1.id and iter0 == arg2[2] then
				return true
			end
		end
	elseif var0 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

function var0.triggerMirrorSkill(arg0, arg1)
	local var0 = _.filter(arg0:findSkills(arg1), function(arg0)
		local var0 = arg0:GetTriggers()

		return _.any(var0, function(arg0)
			return arg0[1] == FleetSkill.TriggerInSubTeam and arg0[2] == 1
		end) == (arg0:getFleetType() == FleetType.Submarine) and _.all(arg0:GetTriggers(), function(arg0)
			return var0.MirrorFleetCheck(arg0, arg0, arg0)
		end)
	end)

	return _.reduce(var0, nil, function(arg0, arg1)
		local var0 = arg1:GetType()
		local var1 = arg1:GetArgs()

		if var0 == FleetSkill.TypeBattleBuff then
			arg0 = arg0 or {}

			table.insert(arg0, var1[1])

			return arg0
		end
	end), var0
end

function var0.MirrorFleetCheck(arg0, arg1, arg2)
	local var0 = arg2[1]
	local var1 = getProxy(BayProxy)

	if var0 == FleetSkill.TriggerDDHead then
		local var2 = arg0:getShipsByTeam(TeamType.Vanguard, false)

		return #var2 > 0 and ShipType.IsTypeQuZhu(var2[1]:getShipType())
	elseif var0 == FleetSkill.TriggerVanCount then
		local var3 = arg0:getShipsByTeam(TeamType.Vanguard, false)

		return #var3 >= arg2[2] and #var3 <= arg2[3]
	elseif var0 == FleetSkill.TriggerShipCount then
		local var4 = _.filter(arg0:getShips(false), function(arg0)
			return table.contains(arg2[2], arg0:getShipType())
		end)

		return #var4 >= arg2[3] and #var4 <= arg2[4]
	elseif var0 == FleetSkill.TriggerNekoPos then
		local var5 = arg0:findCommanderBySkillId(arg1.id)

		for iter0, iter1 in pairs(arg0:getCommanders()) do
			if var5.id == iter1.id and iter0 == arg2[2] then
				return true
			end
		end
	elseif var0 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

function var0.GuildBossTriggerSkill(arg0, arg1)
	local var0 = _.filter(arg0:findSkills(arg1), function(arg0)
		local var0 = arg0:GetTriggers()

		return _.any(var0, function(arg0)
			return arg0[1] == FleetSkill.TriggerInSubTeam and arg0[2] == 1
		end) == (arg0:getFleetType() == FleetType.Submarine) and _.all(arg0:GetTriggers(), function(arg0)
			return var0.GuildBossFleetCheck(arg0, arg0, arg0)
		end)
	end)

	return _.reduce(var0, nil, function(arg0, arg1)
		local var0 = arg1:GetType()
		local var1 = arg1:GetArgs()

		if var0 == FleetSkill.TypeBattleBuff then
			arg0 = arg0 or {}

			table.insert(arg0, var1[1])

			return arg0
		end
	end), var0
end

function var0.GuildBossFleetCheck(arg0, arg1, arg2)
	local var0 = arg2[1]

	if var0 == FleetSkill.TriggerDDHead then
		local var1 = arg0:GetTeamTypeShips(TeamType.Vanguard)

		return #var1 > 0 and ShipType.IsTypeQuZhu(var1[1]:getShipType())
	elseif var0 == FleetSkill.TriggerVanCount then
		local var2 = arg0:GetTeamTypeShips(TeamType.Vanguard)

		return #var2 >= arg2[2] and #var2 <= arg2[3]
	elseif var0 == FleetSkill.TriggerShipCount then
		local var3 = _.filter(arg0:GetShips(), function(arg0)
			local var0 = arg0.ship

			return table.contains(arg2[2], var0:getShipType())
		end)

		return #var3 >= arg2[3] and #var3 <= arg2[4]
	elseif var0 == FleetSkill.TriggerNekoPos then
		local var4 = arg0:findCommanderBySkillId(arg1.id)

		for iter0, iter1 in pairs(arg0:getCommanders()) do
			if var4.id == iter1.id and iter0 == arg2[2] then
				return true
			end
		end
	elseif var0 == FleetSkill.TriggerInSubTeam then
		return true
	else
		return false
	end
end

return var0
