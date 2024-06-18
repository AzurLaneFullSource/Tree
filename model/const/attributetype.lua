local var0_0 = class("AttributeType")

var0_0.Durability = "durability"
var0_0.Cannon = "cannon"
var0_0.Torpedo = "torpedo"
var0_0.AntiAircraft = "antiaircraft"
var0_0.AntiSub = "antisub"
var0_0.Air = "air"
var0_0.Reload = "reload"
var0_0.ArmorType = "armor_type"
var0_0.Armor = "armor"
var0_0.Hit = "hit"
var0_0.Speed = "speed"
var0_0.Luck = "luck"
var0_0.Dodge = "dodge"
var0_0.Expend = "expend"
var0_0.Intimacy = "intimacy"
var0_0.AirDominate = "AirDominate"
var0_0.Damage = "damage"
var0_0.CD = "cd"
var0_0.Healthy = "healthy"
var0_0.Speciality = "speciality"
var0_0.Range = "range"
var0_0.Angle = "angle"
var0_0.Scatter = "scatter"
var0_0.Ammo = "ammo"
var0_0.HuntingRange = "hunting_range"
var0_0.AirDurability = "AirDurability"
var0_0.AntiSiren = "anti_siren"
var0_0.Corrected = "corrected"
var0_0.OxyMax = "oxy_max"
var0_0.OxyCost = "oxy_cost"
var0_0.OxyRecovery = "oxy_recovery"
var0_0.OxyRecoverySurface = "oxy_recovery_surface"
var0_0.OxyRecoveryBench = "oxy_recovery_bench"
var0_0.OxyAttackDuration = "attack_duration"
var0_0.OxyRaidDistance = "raid_distance"
var0_0.SonarRange = "sonarRange"
var0_0.Tactics = "tactics"
var0_0.WorldPower = "world_power"

function var0_0.Type2Name(arg0_1)
	return i18n("attribute_" .. arg0_1)
end

var0_0.eliteConditionTip = {
	cannon = "elite_condition_cannon",
	air = "elite_condition_air",
	dodge = "elite_condition_dodge",
	torpedo = "elite_condition_torpedo",
	durability = "elite_condition_durability",
	reload = "elite_condition_reload",
	fleet_totle_level = "elite_condition_fleet_totle_level",
	antiaircraft = "elite_condition_antiaircraft",
	antisub = "elite_condition_antisub",
	level = "elite_condition_level"
}

local var1_0 = {
	[0] = "common_compare_equal",
	"common_compare_larger",
	"common_compare_not_less_than",
	[-1] = "common_compare_smaller",
	[-2] = "common_compare_not_more_than"
}

function var0_0.eliteConditionCompareTip(arg0_2)
	return i18n(var1_0[arg0_2])
end

function var0_0.EliteCondition2Name(arg0_3, ...)
	return i18n(var0_0.eliteConditionTip[arg0_3], ...)
end

function var0_0.EliteConditionCompare(arg0_4, arg1_4, arg2_4)
	if arg0_4 == 0 then
		return arg1_4 == arg2_4
	elseif arg0_4 == 1 then
		return arg2_4 < arg1_4
	elseif arg0_4 == -1 then
		return arg1_4 < arg2_4
	elseif arg0_4 == 2 then
		return arg2_4 <= arg1_4
	elseif arg0_4 == -2 then
		return arg1_4 <= arg2_4
	else
		assert(false, "compare type error")
	end
end

var0_0.attrNameTable = {
	[var0_0.Durability] = "maxHP",
	[var0_0.Cannon] = "cannonPower",
	[var0_0.Torpedo] = "torpedoPower",
	[var0_0.AntiAircraft] = "antiAirPower",
	[var0_0.AntiSub] = "antiSubPower",
	[var0_0.Air] = "airPower",
	[var0_0.Reload] = "loadSpeed",
	[var0_0.Hit] = "attackRating",
	[var0_0.Speed] = "speed",
	[var0_0.Luck] = "luck",
	[var0_0.Dodge] = "dodgeRate",
	[var0_0.OxyMax] = "oxyMax",
	[var0_0.OxyCost] = "oxyCost",
	[var0_0.OxyRecovery] = "oxyRecovery",
	[var0_0.OxyRecoveryBench] = "oxyRecoveryBench",
	[var0_0.OxyRecoverySurface] = "oxyRecoverySurface",
	[var0_0.OxyAttackDuration] = "oxyAtkDuration",
	[var0_0.OxyRaidDistance] = "raidDist"
}

function var0_0.ConvertBattleAttrName(arg0_5)
	if var0_0.attrNameTable[arg0_5] then
		return var0_0.attrNameTable[arg0_5]
	else
		return arg0_5
	end
end

var0_0.PrimalAttr = {
	torpedoPower = true,
	loadSpeed = true,
	antiSubPower = true,
	antiAirPower = true,
	dodgeRate = true,
	airPower = true,
	attackRating = true,
	cannonPower = true,
	velocity = true
}

function var0_0.IsPrimalBattleAttr(arg0_6)
	return var0_0.PrimalAttr[arg0_6]
end

return var0_0
