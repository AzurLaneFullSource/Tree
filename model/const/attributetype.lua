local var0 = class("AttributeType")

var0.Durability = "durability"
var0.Cannon = "cannon"
var0.Torpedo = "torpedo"
var0.AntiAircraft = "antiaircraft"
var0.AntiSub = "antisub"
var0.Air = "air"
var0.Reload = "reload"
var0.ArmorType = "armor_type"
var0.Armor = "armor"
var0.Hit = "hit"
var0.Speed = "speed"
var0.Luck = "luck"
var0.Dodge = "dodge"
var0.Expend = "expend"
var0.Intimacy = "intimacy"
var0.AirDominate = "AirDominate"
var0.Damage = "damage"
var0.CD = "cd"
var0.Healthy = "healthy"
var0.Speciality = "speciality"
var0.Range = "range"
var0.Angle = "angle"
var0.Scatter = "scatter"
var0.Ammo = "ammo"
var0.HuntingRange = "hunting_range"
var0.AirDurability = "AirDurability"
var0.AntiSiren = "anti_siren"
var0.Corrected = "corrected"
var0.OxyMax = "oxy_max"
var0.OxyCost = "oxy_cost"
var0.OxyRecovery = "oxy_recovery"
var0.OxyRecoverySurface = "oxy_recovery_surface"
var0.OxyRecoveryBench = "oxy_recovery_bench"
var0.OxyAttackDuration = "attack_duration"
var0.OxyRaidDistance = "raid_distance"
var0.SonarRange = "sonarRange"
var0.Tactics = "tactics"
var0.WorldPower = "world_power"

function var0.Type2Name(arg0)
	return i18n("attribute_" .. arg0)
end

var0.eliteConditionTip = {
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

local var1 = {
	[0] = "common_compare_equal",
	"common_compare_larger",
	"common_compare_not_less_than",
	[-1] = "common_compare_smaller",
	[-2] = "common_compare_not_more_than"
}

function var0.eliteConditionCompareTip(arg0)
	return i18n(var1[arg0])
end

function var0.EliteCondition2Name(arg0, ...)
	return i18n(var0.eliteConditionTip[arg0], ...)
end

function var0.EliteConditionCompare(arg0, arg1, arg2)
	if arg0 == 0 then
		return arg1 == arg2
	elseif arg0 == 1 then
		return arg2 < arg1
	elseif arg0 == -1 then
		return arg1 < arg2
	elseif arg0 == 2 then
		return arg2 <= arg1
	elseif arg0 == -2 then
		return arg1 <= arg2
	else
		assert(false, "compare type error")
	end
end

var0.attrNameTable = {
	[var0.Durability] = "maxHP",
	[var0.Cannon] = "cannonPower",
	[var0.Torpedo] = "torpedoPower",
	[var0.AntiAircraft] = "antiAirPower",
	[var0.AntiSub] = "antiSubPower",
	[var0.Air] = "airPower",
	[var0.Reload] = "loadSpeed",
	[var0.Hit] = "attackRating",
	[var0.Speed] = "speed",
	[var0.Luck] = "luck",
	[var0.Dodge] = "dodgeRate",
	[var0.OxyMax] = "oxyMax",
	[var0.OxyCost] = "oxyCost",
	[var0.OxyRecovery] = "oxyRecovery",
	[var0.OxyRecoveryBench] = "oxyRecoveryBench",
	[var0.OxyRecoverySurface] = "oxyRecoverySurface",
	[var0.OxyAttackDuration] = "oxyAtkDuration",
	[var0.OxyRaidDistance] = "raidDist"
}

function var0.ConvertBattleAttrName(arg0)
	if var0.attrNameTable[arg0] then
		return var0.attrNameTable[arg0]
	else
		return arg0
	end
end

var0.PrimalAttr = {
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

function var0.IsPrimalBattleAttr(arg0)
	return var0.PrimalAttr[arg0]
end

return var0
