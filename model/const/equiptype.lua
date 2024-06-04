local var0 = class("EquipType")

var0.CannonQuZhu = 1
var0.CannonQingXun = 2
var0.CannonZhongXun = 3
var0.CannonZhanlie = 4
var0.Torpedo = 5
var0.AntiAircraft = 6
var0.FighterAircraft = 7
var0.TorpedoAircraft = 8
var0.BomberAircraft = 9
var0.Equipment = 10
var0.CannonZhongXun2 = 11
var0.SeaPlane = 12
var0.SubmarineTorpedo = 13
var0.Sonar = 14
var0.AntiSubAircraft = 15
var0.Helicopter = 17
var0.Goods = 18
var0.Missile = 20
var0.RangedAntiAircraft = 21
var0.AmmoType_1 = 1
var0.AmmoType_2 = 2
var0.AmmoType_3 = 3
var0.AmmoType_4 = 4
var0.AmmoType_5 = 5
var0.AmmoType_6 = 6
var0.AmmoType_7 = 7
var0.AmmoType_8 = 8
var0.AmmoType_8 = 9
var0.AmmoType_8 = 10
var0.CannonEquipTypes = {
	var0.CannonQuZhu,
	var0.CannonQingXun,
	var0.CannonZhongXun,
	var0.CannonZhanlie,
	var0.CannonZhongXun2
}
var0.AirProtoEquipTypes = {
	var0.FighterAircraft,
	var0.TorpedoAircraft,
	var0.BomberAircraft
}
var0.AirEquipTypes = {
	var0.FighterAircraft,
	var0.TorpedoAircraft,
	var0.BomberAircraft,
	var0.SeaPlane
}
var0.AirExtendEquipTypes = {
	var0.FighterAircraft,
	var0.TorpedoAircraft,
	var0.BomberAircraft,
	var0.SeaPlane,
	var0.AntiSubAircraft,
	var0.Helicopter
}
var0.AirDomainEquip = {
	var0.FighterAircraft,
	var0.TorpedoAircraft,
	var0.BomberAircraft,
	var0.SeaPlane
}
var0.TorpedoEquipTypes = {
	var0.Torpedo,
	var0.SubmarineTorpedo
}
var0.DeviceEquipTypes = {
	var0.Equipment,
	var0.AntiSubAircraft,
	var0.Sonar,
	var0.Helicopter,
	var0.Goods
}
var0.AircraftSkinType = {
	var0.FighterAircraft,
	var0.TorpedoAircraft,
	var0.BomberAircraft,
	var0.SeaPlane,
	var0.AntiSubAircraft
}

local var1 = {
	i18n("word_primary_weapons"),
	i18n("word_sub_cannons"),
	i18n("word_torpedo"),
	i18n("word_air_defense_artillery"),
	i18n("word_shipboard_aircraft"),
	i18n("word_device"),
	i18n("word_submarine_torpedo"),
	i18n("wrod_sub_weapons"),
	i18n("word_main_cannons"),
	i18n("word_cannon"),
	i18n("word_equipment_aircraft"),
	i18n("word_fighter"),
	i18n("word_bomber"),
	i18n("word_attacker"),
	i18n("word_seaplane"),
	i18n("word_equipment"),
	i18n("word_missile")
}
local var2 = {
	"cannon",
	"cannon",
	"cannon",
	"cannon",
	"torpedo",
	"antiair",
	"fighter",
	"attacker",
	"bomber",
	"equipment",
	"cannon",
	"seaplane",
	"torpedo",
	"equipment",
	"equipment",
	nil,
	"equipment",
	"equipment",
	nil,
	"missile",
	"antiair"
}

function var0.Type2Name(arg0)
	return pg.equip_data_by_type[arg0].type_name
end

function var0.Type2Name2(arg0)
	return pg.equip_data_by_type[arg0].type_name2
end

function var0.type2Tag(arg0)
	if not var0.tagPrints then
		var0.tagPrints = {
			"4",
			"4",
			"4",
			"4",
			"5",
			"6",
			"7",
			"8",
			"9",
			"10",
			"4",
			"12",
			"5",
			"10",
			"13",
			nil,
			"14",
			"15",
			nil,
			"16",
			"6"
		}
	end

	return var0.tagPrints[arg0]
end

function var0.getCompareGroup(arg0)
	local var0 = Equipment.getConfigData(arg0).type

	return pg.equip_data_by_type[var0].compare_group
end

function var0.type2Title(arg0, arg1)
	if arg1 <= 4 then
		return var1[arg0]
	elseif arg1 == var0.Torpedo then
		return var1[3]
	elseif arg1 == var0.AntiAircraft or arg1 == var0.RangedAntiAircraft then
		return var1[4]
	elseif arg1 >= 7 and arg1 <= 9 or arg1 == var0.SeaPlane then
		return var0.Type2Name(arg1)
	elseif arg1 == var0.Equipment or arg1 == var0.AntiSubAircraft then
		return var1[6]
	elseif arg1 == var0.SubmarineTorpedo then
		return var1[7]
	elseif arg1 == var0.Missile then
		return var1[17]
	end
end

local var3 = {
	1,
	2,
	3,
	4,
	11
}
local var4 = {
	7,
	8,
	9,
	12
}
local var5 = {
	1,
	2
}
local var6 = {
	10,
	14,
	15,
	17,
	18
}

local function var7(arg0)
	if _.all(arg0, function(arg0)
		return table.contains(var6, arg0)
	end) then
		return "equipment"
	elseif _.all(arg0, function(arg0)
		return table.contains(var3, arg0)
	end) then
		return "main_cannons"
	elseif #arg0 == 1 then
		return var2[arg0[1]]
	elseif #arg0 > 1 then
		if _.all(arg0, function(arg0)
			return table.contains(var4, arg0)
		end) then
			return "equipment_aircraft"
		else
			return "primary_weapons"
		end
	end

	return ""
end

local function var8(arg0, arg1)
	if _.all(arg1, function(arg0)
		return table.contains(var3, arg0)
	end) and _.is_equal(arg0, arg1) then
		return "main_cannons"
	elseif _.all(arg0, function(arg0)
		return table.contains(var6, arg0)
	end) then
		return "equipment"
	elseif _.all(arg0, function(arg0)
		return table.contains(var5, arg0)
	end) then
		return "sub_cannons"
	elseif #arg0 == 1 then
		return var2[arg0[1]]
	elseif #arg0 > 1 then
		if _.all(arg0, function(arg0)
			return table.contains(var4, arg0)
		end) then
			return "equipment_aircraft"
		else
			return "sub_weapons"
		end
	end

	return ""
end

local function var9(arg0)
	if _.all(arg0, function(arg0)
		return table.contains(var6, arg0)
	end) then
		return "equipment"
	elseif #arg0 == 2 and table.contains(arg0, EquipType.AntiAircraft) and table.contains(arg0, EquipType.RangedAntiAircraft) then
		return "antiair"
	elseif _.all(arg0, function(arg0)
		return table.contains(var5, arg0)
	end) then
		return "sub_cannons"
	elseif #arg0 == 1 then
		return var2[arg0[1]]
	elseif #arg0 > 1 then
		if _.all(arg0, function(arg0)
			return table.contains(var4, arg0)
		end) then
			return "equipment_aircraft"
		else
			return "sub_weapons"
		end
	end

	return ""
end

function var0.Types2Title(arg0, arg1)
	local var0 = pg.ship_data_template[arg1]
	local var1 = var0["equip_" .. arg0]

	if arg0 == 1 then
		return var7(var1)
	elseif arg0 == 2 then
		local var2 = var0.equip_1

		return var8(var1, var2)
	elseif arg0 == 3 then
		return var9(var1)
	elseif arg0 == 4 or arg0 == 5 then
		return var2[var1[1]]
	end
end

function var0.LabelToName(arg0)
	if arg0 == "antiair" then
		arg0 = "air_defense_artillery"
	elseif arg0 == "equipment" then
		arg0 = "device"
	end

	return i18n("word_" .. arg0)
end

return var0
