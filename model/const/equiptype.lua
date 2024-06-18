local var0_0 = class("EquipType")

var0_0.CannonQuZhu = 1
var0_0.CannonQingXun = 2
var0_0.CannonZhongXun = 3
var0_0.CannonZhanlie = 4
var0_0.Torpedo = 5
var0_0.AntiAircraft = 6
var0_0.FighterAircraft = 7
var0_0.TorpedoAircraft = 8
var0_0.BomberAircraft = 9
var0_0.Equipment = 10
var0_0.CannonZhongXun2 = 11
var0_0.SeaPlane = 12
var0_0.SubmarineTorpedo = 13
var0_0.Sonar = 14
var0_0.AntiSubAircraft = 15
var0_0.Helicopter = 17
var0_0.Goods = 18
var0_0.Missile = 20
var0_0.RangedAntiAircraft = 21
var0_0.AmmoType_1 = 1
var0_0.AmmoType_2 = 2
var0_0.AmmoType_3 = 3
var0_0.AmmoType_4 = 4
var0_0.AmmoType_5 = 5
var0_0.AmmoType_6 = 6
var0_0.AmmoType_7 = 7
var0_0.AmmoType_8 = 8
var0_0.AmmoType_8 = 9
var0_0.AmmoType_8 = 10
var0_0.CannonEquipTypes = {
	var0_0.CannonQuZhu,
	var0_0.CannonQingXun,
	var0_0.CannonZhongXun,
	var0_0.CannonZhanlie,
	var0_0.CannonZhongXun2
}
var0_0.AirProtoEquipTypes = {
	var0_0.FighterAircraft,
	var0_0.TorpedoAircraft,
	var0_0.BomberAircraft
}
var0_0.AirEquipTypes = {
	var0_0.FighterAircraft,
	var0_0.TorpedoAircraft,
	var0_0.BomberAircraft,
	var0_0.SeaPlane
}
var0_0.AirExtendEquipTypes = {
	var0_0.FighterAircraft,
	var0_0.TorpedoAircraft,
	var0_0.BomberAircraft,
	var0_0.SeaPlane,
	var0_0.AntiSubAircraft,
	var0_0.Helicopter
}
var0_0.AirDomainEquip = {
	var0_0.FighterAircraft,
	var0_0.TorpedoAircraft,
	var0_0.BomberAircraft,
	var0_0.SeaPlane
}
var0_0.TorpedoEquipTypes = {
	var0_0.Torpedo,
	var0_0.SubmarineTorpedo
}
var0_0.DeviceEquipTypes = {
	var0_0.Equipment,
	var0_0.AntiSubAircraft,
	var0_0.Sonar,
	var0_0.Helicopter,
	var0_0.Goods
}
var0_0.AircraftSkinType = {
	var0_0.FighterAircraft,
	var0_0.TorpedoAircraft,
	var0_0.BomberAircraft,
	var0_0.SeaPlane,
	var0_0.AntiSubAircraft
}

local var1_0 = {
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
local var2_0 = {
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

function var0_0.Type2Name(arg0_1)
	return pg.equip_data_by_type[arg0_1].type_name
end

function var0_0.Type2Name2(arg0_2)
	return pg.equip_data_by_type[arg0_2].type_name2
end

function var0_0.type2Tag(arg0_3)
	if not var0_0.tagPrints then
		var0_0.tagPrints = {
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

	return var0_0.tagPrints[arg0_3]
end

function var0_0.getCompareGroup(arg0_4)
	local var0_4 = Equipment.getConfigData(arg0_4).type

	return pg.equip_data_by_type[var0_4].compare_group
end

function var0_0.type2Title(arg0_5, arg1_5)
	if arg1_5 <= 4 then
		return var1_0[arg0_5]
	elseif arg1_5 == var0_0.Torpedo then
		return var1_0[3]
	elseif arg1_5 == var0_0.AntiAircraft or arg1_5 == var0_0.RangedAntiAircraft then
		return var1_0[4]
	elseif arg1_5 >= 7 and arg1_5 <= 9 or arg1_5 == var0_0.SeaPlane then
		return var0_0.Type2Name(arg1_5)
	elseif arg1_5 == var0_0.Equipment or arg1_5 == var0_0.AntiSubAircraft then
		return var1_0[6]
	elseif arg1_5 == var0_0.SubmarineTorpedo then
		return var1_0[7]
	elseif arg1_5 == var0_0.Missile then
		return var1_0[17]
	end
end

local var3_0 = {
	1,
	2,
	3,
	4,
	11
}
local var4_0 = {
	7,
	8,
	9,
	12
}
local var5_0 = {
	1,
	2
}
local var6_0 = {
	10,
	14,
	15,
	17,
	18
}

local function var7_0(arg0_6)
	if _.all(arg0_6, function(arg0_7)
		return table.contains(var6_0, arg0_7)
	end) then
		return "equipment"
	elseif _.all(arg0_6, function(arg0_8)
		return table.contains(var3_0, arg0_8)
	end) then
		return "main_cannons"
	elseif #arg0_6 == 1 then
		return var2_0[arg0_6[1]]
	elseif #arg0_6 > 1 then
		if _.all(arg0_6, function(arg0_9)
			return table.contains(var4_0, arg0_9)
		end) then
			return "equipment_aircraft"
		else
			return "primary_weapons"
		end
	end

	return ""
end

local function var8_0(arg0_10, arg1_10)
	if _.all(arg1_10, function(arg0_11)
		return table.contains(var3_0, arg0_11)
	end) and _.is_equal(arg0_10, arg1_10) then
		return "main_cannons"
	elseif _.all(arg0_10, function(arg0_12)
		return table.contains(var6_0, arg0_12)
	end) then
		return "equipment"
	elseif _.all(arg0_10, function(arg0_13)
		return table.contains(var5_0, arg0_13)
	end) then
		return "sub_cannons"
	elseif #arg0_10 == 1 then
		return var2_0[arg0_10[1]]
	elseif #arg0_10 > 1 then
		if _.all(arg0_10, function(arg0_14)
			return table.contains(var4_0, arg0_14)
		end) then
			return "equipment_aircraft"
		else
			return "sub_weapons"
		end
	end

	return ""
end

local function var9_0(arg0_15)
	if _.all(arg0_15, function(arg0_16)
		return table.contains(var6_0, arg0_16)
	end) then
		return "equipment"
	elseif #arg0_15 == 2 and table.contains(arg0_15, EquipType.AntiAircraft) and table.contains(arg0_15, EquipType.RangedAntiAircraft) then
		return "antiair"
	elseif _.all(arg0_15, function(arg0_17)
		return table.contains(var5_0, arg0_17)
	end) then
		return "sub_cannons"
	elseif #arg0_15 == 1 then
		return var2_0[arg0_15[1]]
	elseif #arg0_15 > 1 then
		if _.all(arg0_15, function(arg0_18)
			return table.contains(var4_0, arg0_18)
		end) then
			return "equipment_aircraft"
		else
			return "sub_weapons"
		end
	end

	return ""
end

function var0_0.Types2Title(arg0_19, arg1_19)
	local var0_19 = pg.ship_data_template[arg1_19]
	local var1_19 = var0_19["equip_" .. arg0_19]

	if arg0_19 == 1 then
		return var7_0(var1_19)
	elseif arg0_19 == 2 then
		local var2_19 = var0_19.equip_1

		return var8_0(var1_19, var2_19)
	elseif arg0_19 == 3 then
		return var9_0(var1_19)
	elseif arg0_19 == 4 or arg0_19 == 5 then
		return var2_0[var1_19[1]]
	end
end

function var0_0.LabelToName(arg0_20)
	if arg0_20 == "antiair" then
		arg0_20 = "air_defense_artillery"
	elseif arg0_20 == "equipment" then
		arg0_20 = "device"
	end

	return i18n("word_" .. arg0_20)
end

return var0_0
