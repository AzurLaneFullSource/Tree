local var0_0 = class("IndexConst")

function var0_0.Flags2Bits(arg0_1)
	local var0_1 = 0

	for iter0_1, iter1_1 in ipairs(arg0_1) do
		var0_1 = bit.bor(var0_1, bit.lshift(1, iter1_1))
	end

	return var0_1
end

function var0_0.FlagRange2Bits(arg0_2, arg1_2)
	local var0_2 = 0

	for iter0_2 = arg0_2, arg1_2 do
		var0_2 = bit.bor(var0_2, bit.lshift(1, iter0_2))
	end

	return var0_2
end

function var0_0.ToggleBits(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg0_3
	local var1_3 = bit.lshift(1, arg3_3)

	if arg2_3 then
		local var2_3 = bit.lshift(1, arg2_3)
		local var3_3 = _.reduce(arg1_3, 0, function(arg0_4, arg1_4)
			return arg0_4 + (arg1_4 ~= arg2_3 and bit.lshift(1, arg1_4) or 0)
		end)

		if var1_3 == var2_3 then
			var0_3 = var2_3
		else
			if bit.band(var0_3, var2_3) > 0 then
				var0_3 = var0_3 - var2_3
			end

			if bit.band(var0_3, var1_3) > 0 then
				var1_3 = -var1_3
			end

			var0_3 = var0_3 + var1_3

			if var0_3 == var3_3 or var0_3 == 0 then
				var0_3 = var2_3
			end
		end
	else
		if bit.band(var0_3, var1_3) > 0 then
			var1_3 = -var1_3
		end

		var0_3 = var0_3 + var1_3
	end

	return var0_3
end

function var0_0.SingleToggleBits(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5
	local var1_5 = bit.lshift(1, arg3_5)

	if var0_5 == var1_5 then
		var0_5 = bit.lshift(1, arg2_5)
	else
		var0_5 = var1_5
	end

	return var0_5
end

function var0_0.StrLShift(arg0_6, arg1_6)
	local var0_6 = ""

	for iter0_6 = 1, arg1_6 do
		arg0_6 = arg0_6 .. "0"
	end

	return arg0_6 .. var0_6
end

function var0_0.StrAnd(arg0_7, arg1_7)
	local var0_7 = ""
	local var1_7 = string.len(arg0_7) > string.len(arg1_7) and arg0_7 or arg1_7
	local var2_7 = var1_7 == arg0_7 and arg1_7 or arg0_7
	local var3_7 = string.len(var1_7)
	local var4_7 = string.len(var2_7)

	for iter0_7 = 1, var4_7 do
		if string.sub(var2_7, iter0_7, iter0_7) == "1" and string.sub(var1_7, var3_7 - var4_7 + iter0_7, var3_7 - var4_7 + iter0_7) == "1" then
			var0_7 = var0_7 .. "1"
		else
			var0_7 = var0_7 .. "0"
		end
	end

	local var5_7 = ""

	for iter1_7 = 1, var3_7 - var4_7 do
		var5_7 = var5_7 .. "0"
	end

	return var5_7 .. var0_7
end

function var0_0.StrOr(arg0_8, arg1_8)
	local var0_8 = ""
	local var1_8 = string.len(arg0_8) > string.len(arg1_8) and arg0_8 or arg1_8
	local var2_8 = var1_8 == arg0_8 and arg1_8 or arg0_8
	local var3_8 = string.len(var1_8)
	local var4_8 = string.len(var2_8)

	for iter0_8 = 1, var4_8 do
		if string.sub(var2_8, iter0_8, iter0_8) == "1" or string.sub(var1_8, var3_8 - var4_8 + iter0_8, var3_8 - var4_8 + iter0_8) == "1" then
			var0_8 = var0_8 .. "1"
		else
			var0_8 = var0_8 .. "0"
		end
	end

	return string.sub(var1_8, 1, var3_8 - var4_8) .. var0_8
end

function var0_0.Flags2Str(arg0_9)
	local var0_9 = ""

	for iter0_9, iter1_9 in ipairs(arg0_9) do
		var0_9 = var0_0.StrOr(var0_9, var0_0.StrLShift("1", iter1_9))
	end

	return var0_9
end

function var0_0.FlagRange2Str(arg0_10, arg1_10)
	local var0_10 = ""

	for iter0_10 = arg0_10, arg1_10 do
		var0_10 = var0_0.StrOr(var0_10, var0_0.StrLShift("1", iter0_10))
	end

	return var0_10
end

function var0_0.ToggleStr(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11
	local var1_11 = var0_0.StrLShift("1", arg3_11)

	if arg2_11 then
		local var2_11 = var0_0.StrLShift("1", arg2_11)
		local var3_11 = ""

		for iter0_11, iter1_11 in ipairs(arg1_11) do
			if iter1_11 ~= arg2_11 then
				var3_11 = var0_0.StrOr(var3_11, var0_0.StrLShift("1", iter1_11))
			end
		end

		if var1_11 == var2_11 or var0_11 == var3_11 then
			var0_11 = var2_11
		else
			if string.find(var0_0.StrAnd(var0_11, var2_11), "1") ~= nil then
				var0_11 = var1_11
			else
				local var4_11 = var0_0.StrOr(var0_11, var1_11)
				local var5_11 = string.len(var4_11) - arg3_11
				local var6_11 = string.find(var0_0.StrAnd(var0_11, var1_11), "1") ~= nil and "0" or "1"

				var0_11 = string.sub(var4_11, 1, var5_11 - 1) .. var6_11 .. string.sub(var4_11, var5_11 + 1)
			end

			if var0_11 == var3_11 or string.find(var0_11, "1") == nil then
				var0_11 = var2_11
			end
		end
	else
		local var7_11 = var0_0.StrOr(var0_11, var1_11)
		local var8_11 = string.len(var7_11) - arg3_11
		local var9_11 = string.find(var0_0.StrAnd(var0_11, var1_11), "1") ~= nil and "0" or "1"

		var0_11 = string.sub(var7_11, 1, var8_11 - 1) .. var9_11 .. string.sub(var7_11, var8_11 + 1)
	end

	return var0_11
end

function var0_0.BitAll(arg0_12)
	local var0_12 = 0

	for iter0_12, iter1_12 in ipairs(arg0_12) do
		var0_12 = bit.bor(iter1_12, var0_12)
	end

	return var0_12
end

var0_0.EquipmentTypeSmallCannon = bit.lshift(1, 0)
var0_0.EquipmentTypeMediumCannon = bit.lshift(1, 1)
var0_0.EquipmentTypeBigCannon = bit.lshift(1, 2)
var0_0.EquipmentTypeWarshipTorpedo = bit.lshift(1, 3)
var0_0.EquipmentTypeSubmaraineTorpedo = bit.lshift(1, 4)
var0_0.EquipmentTypeAntiAircraft = bit.lshift(1, 5)
var0_0.EquipmentTypeFighter = bit.lshift(1, 6)
var0_0.EquipmentTypeBomber = bit.lshift(1, 7)
var0_0.EquipmentTypeTorpedoBomber = bit.lshift(1, 8)
var0_0.EquipmentTypeEquip = bit.lshift(1, 9)
var0_0.EquipmentTypeOther = bit.lshift(1, 10)
var0_0.EquipmentTypeIndexs = {
	var0_0.EquipmentTypeSmallCannon,
	var0_0.EquipmentTypeMediumCannon,
	var0_0.EquipmentTypeBigCannon,
	var0_0.EquipmentTypeWarshipTorpedo,
	var0_0.EquipmentTypeSubmaraineTorpedo,
	var0_0.EquipmentTypeAntiAircraft,
	var0_0.EquipmentTypeFighter,
	var0_0.EquipmentTypeBomber,
	var0_0.EquipmentTypeTorpedoBomber,
	var0_0.EquipmentTypeEquip,
	var0_0.EquipmentTypeOther
}
var0_0.EquipmentTypeAll = var0_0.BitAll(var0_0.EquipmentTypeIndexs)

table.insert(var0_0.EquipmentTypeIndexs, 1, var0_0.EquipmentTypeAll)

function var0_0.filterEquipByType(arg0_13, arg1_13)
	if not arg1_13 or arg1_13 == var0_0.EquipmentTypeAll then
		return true
	end

	for iter0_13 = 2, #EquipmentSortCfg.index do
		local var0_13 = bit.lshift(1, iter0_13 - 2)

		if bit.band(var0_13, arg1_13) > 0 then
			local var1_13 = EquipmentSortCfg.index[iter0_13].types

			if table.contains(var1_13, arg0_13:getConfig("type")) then
				return true
			end
		end
	end

	return false
end

var0_0.EquipmentTypeNames = {
	"word_equipment_all",
	"word_equipment_small_cannon",
	"word_equipment_medium_cannon",
	"word_equipment_big_cannon",
	"word_equipment_warship_torpedo",
	"word_equipment_submarine_torpedo",
	"word_equipment_antiaircraft",
	"word_equipment_fighter",
	"word_equipment_bomber",
	"word_equipment_torpedo_bomber",
	"word_equipment_equip",
	"word_equipment_special"
}
var0_0.EquipCampUS = bit.lshift(1, 0)
var0_0.EquipCampEN = bit.lshift(1, 1)
var0_0.EquipCampJP = bit.lshift(1, 2)
var0_0.EquipCampDE = bit.lshift(1, 3)
var0_0.EquipCampCN = bit.lshift(1, 4)
var0_0.EquipCampITA = bit.lshift(1, 5)
var0_0.EquipCampSN = bit.lshift(1, 6)
var0_0.EquipCampFR = bit.lshift(1, 7)
var0_0.EquipCampMNF = bit.lshift(1, 8)
var0_0.EquipCampLINK = bit.lshift(1, 9)
var0_0.EquipCampOther = bit.lshift(1, 10)
var0_0.EquipCampIndexs = {
	var0_0.EquipCampUS,
	var0_0.EquipCampEN,
	var0_0.EquipCampJP,
	var0_0.EquipCampDE,
	var0_0.EquipCampCN,
	var0_0.EquipCampITA,
	var0_0.EquipCampSN,
	var0_0.EquipCampFR,
	var0_0.EquipCampMNF,
	var0_0.EquipCampLINK,
	var0_0.EquipCampOther
}
var0_0.EquipCampNames = {
	"word_shipNation_all",
	"word_shipNation_baiYing",
	"word_shipNation_huangJia",
	"word_shipNation_chongYing",
	"word_shipNation_tieXue",
	"word_shipNation_dongHuang",
	"word_shipNation_saDing",
	"word_shipNation_beiLian",
	"word_shipNation_ziyou",
	"word_shipNation_weixi",
	"word_shipNation_link",
	"word_shipNation_other"
}
var0_0.EquipCampAll = var0_0.BitAll(var0_0.EquipCampIndexs)

table.insert(var0_0.EquipCampIndexs, 1, var0_0.EquipCampAll)

function var0_0.filterEquipByCamp(arg0_14, arg1_14)
	if not arg1_14 or arg1_14 == var0_0.EquipmentTypeAll then
		return true
	end

	for iter0_14 = 2, #EquipmentSortCfg.campIndex do
		local var0_14 = bit.lshift(1, iter0_14 - 2)

		if bit.band(var0_14, arg1_14) > 0 then
			local var1_14 = EquipmentSortCfg.campIndex[iter0_14].types

			for iter1_14, iter2_14 in ipairs(var1_14) do
				if iter2_14 == Nation.LINK then
					if arg0_14:getNation() >= Nation.LINK then
						return true
					end
				elseif iter2_14 == arg0_14:getNation() then
					return true
				end
			end
		end
	end

	return false
end

var0_0.EquipProperty_Cannon = bit.lshift(1, 0)
var0_0.EquipProperty_Air = bit.lshift(1, 1)
var0_0.EquipProperty_Dodge = bit.lshift(1, 2)
var0_0.EquipProperty_AntiAircraft = bit.lshift(1, 3)
var0_0.EquipProperty_Torpedo = bit.lshift(1, 4)
var0_0.EquipProperty_Reload = bit.lshift(1, 5)
var0_0.EquipProperty_Durability = bit.lshift(1, 6)
var0_0.EquipProperty_Antisub = bit.lshift(1, 7)
var0_0.EquipProperty_Oxy = bit.lshift(1, 8)
var0_0.EquipProperty_Speed = bit.lshift(1, 9)
var0_0.EquipProperty_Hit = bit.lshift(1, 10)
var0_0.EquipProperty_Luck = bit.lshift(1, 11)
var0_0.EquipPropertyIndexs = {
	var0_0.EquipProperty_Cannon,
	var0_0.EquipProperty_Air,
	var0_0.EquipProperty_Dodge,
	var0_0.EquipProperty_AntiAircraft,
	var0_0.EquipProperty_Torpedo,
	var0_0.EquipProperty_Reload,
	var0_0.EquipProperty_Durability,
	var0_0.EquipProperty_Antisub,
	var0_0.EquipProperty_Oxy,
	var0_0.EquipProperty_Speed,
	var0_0.EquipProperty_Hit,
	var0_0.EquipProperty_Luck
}
var0_0.EquipPropertyAll = var0_0.BitAll(var0_0.EquipPropertyIndexs)

table.insert(var0_0.EquipPropertyIndexs, 1, var0_0.EquipPropertyAll)

var0_0.EquipPropertyNames = {
	"sort_attribute",
	"attribute_cannon",
	"attribute_air",
	"attribute_dodge",
	"attribute_antiaircraft",
	"attribute_torpedo",
	"attribute_reload",
	"attribute_durability",
	"attribute_antisub",
	"attribute_oxy_max",
	"attribute_speed",
	"attribute_hit",
	"attribute_luck"
}

function var0_0.filterEquipByProperty(arg0_15, arg1_15)
	local var0_15 = {}

	if arg0_15:getConfig("attribute_1") then
		table.insert(var0_15, arg0_15:getConfig("attribute_1"))
	end

	if arg0_15:getConfig("attribute_2") then
		table.insert(var0_15, arg0_15:getConfig("attribute_2"))
	end

	if arg0_15:getConfig("attribute_3") then
		table.insert(var0_15, arg0_15:getConfig("attribute_3"))
	end

	local var1_15 = 0

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		if not iter1_15 or iter1_15 == var0_0.EquipPropertyAll then
			var1_15 = var1_15 + 1
		else
			for iter2_15 = 2, #EquipmentSortCfg.propertyIndex do
				local var2_15 = bit.lshift(1, iter2_15 - 2)

				if bit.band(var2_15, iter1_15) > 0 then
					local var3_15 = EquipmentSortCfg.propertyIndex[iter2_15].types

					for iter3_15 = #var0_15, 1, -1 do
						local var4_15 = var0_15[iter3_15]

						if table.contains(var3_15, var4_15) then
							var1_15 = var1_15 + 1

							table.remove(var0_15, iter3_15)

							break
						end
					end
				end
			end
		end
	end

	return var1_15 >= #arg1_15
end

var0_0.EquipAmmoChuanjia = bit.lshift(1, 0)
var0_0.EquipAmmoGaobao = bit.lshift(1, 1)
var0_0.EquipAmmoTongchangDan = bit.lshift(1, 2)
var0_0.EquipAmmoQita = bit.lshift(1, 3)
var0_0.EquipAmmoIndexs_1 = {
	var0_0.EquipAmmoChuanjia,
	var0_0.EquipAmmoGaobao,
	var0_0.EquipAmmoTongchangDan,
	var0_0.EquipAmmoQita
}
var0_0.EquipAmmoAll_1 = var0_0.BitAll(var0_0.EquipAmmoIndexs_1)

table.insert(var0_0.EquipAmmoIndexs_1, 1, var0_0.EquipAmmoAll_1)

var0_0.EquipAmmoIndexs_1_Names = {
	"attribute_ammo",
	"equip_ammo_type_1",
	"equip_ammo_type_2",
	"equip_ammo_type_3",
	"word_shipType_other"
}

function var0_0.filterEquipAmmo1(arg0_16, arg1_16)
	if not arg1_16 or arg1_16 == var0_0.EquipAmmoAll_1 then
		return true
	end

	for iter0_16 = 2, #EquipmentSortCfg.ammoIndex1 do
		local var0_16 = bit.lshift(1, iter0_16 - 2)

		if bit.band(var0_16, arg1_16) > 0 then
			local var1_16 = EquipmentSortCfg.ammoIndex1[iter0_16].types

			if table.contains(var1_16, arg0_16:getConfig("ammo")) then
				return true
			end
		end
	end

	return false
end

var0_0.EquipAmmoShengdao = bit.lshift(1, 0)
var0_0.EquipAmmoTongchang = bit.lshift(1, 1)
var0_0.EquipAmmoIndexs_2 = {
	var0_0.EquipAmmoShengdao,
	var0_0.EquipAmmoTongchang
}
var0_0.EquipAmmoAll_2 = var0_0.BitAll(var0_0.EquipAmmoIndexs_2)

table.insert(var0_0.EquipAmmoIndexs_2, 1, var0_0.EquipAmmoAll_2)

var0_0.EquipAmmoIndexs_2_Names = {
	"attribute_ammo",
	"equip_ammo_type_4",
	"equip_ammo_type_5"
}

function var0_0.filterEquipAmmo2(arg0_17, arg1_17)
	if not arg1_17 or arg1_17 == var0_0.EquipAmmoAll_2 then
		return true
	end

	for iter0_17 = 2, #EquipmentSortCfg.ammoIndex2 do
		local var0_17 = bit.lshift(1, iter0_17 - 2)

		if bit.band(var0_17, arg1_17) > 0 then
			local var1_17 = EquipmentSortCfg.ammoIndex2[iter0_17].types

			if table.contains(var1_17, arg0_17:getConfig("ammo")) then
				return true
			end
		end
	end

	return false
end

var0_0.EquipmentRarity1 = bit.lshift(1, 0)
var0_0.EquipmentRarity2 = bit.lshift(1, 1)
var0_0.EquipmentRarity3 = bit.lshift(1, 2)
var0_0.EquipmentRarity4 = bit.lshift(1, 3)
var0_0.EquipmentRarity5 = bit.lshift(1, 4)
var0_0.EquipmentRarityIndexs = {
	var0_0.EquipmentRarity1,
	var0_0.EquipmentRarity2,
	var0_0.EquipmentRarity3,
	var0_0.EquipmentRarity4,
	var0_0.EquipmentRarity5
}
var0_0.EquipmentRarityAll = var0_0.BitAll(var0_0.EquipmentRarityIndexs)

table.insert(var0_0.EquipmentRarityIndexs, 1, var0_0.EquipmentRarityAll)

var0_0.RarityNames = {
	"index_all",
	"index_rare2",
	"index_rare3",
	"index_rare4",
	"index_rare5",
	"index_rare6"
}

function var0_0.filterEquipByRarity(arg0_18, arg1_18)
	if not arg1_18 or arg1_18 == var0_0.EquipmentRarityAll then
		return true
	end

	local var0_18 = math.max(arg0_18:getConfig("rarity") - 2, 0)
	local var1_18 = bit.lshift(1, var0_18)

	return bit.band(var1_18, arg1_18) > 0
end

var0_0.EquipmentExtraNames = {
	"index_without_limit",
	"index_equip",
	"index_strengthen",
	"index_reform"
}
var0_0.EquipmentExtraEquiping = bit.lshift(1, 0)
var0_0.EquipmentExtraStrengthen = bit.lshift(1, 1)
var0_0.EquipmentExtraTransform = bit.lshift(1, 2)
var0_0.EquipmentExtraIndexs = {
	var0_0.EquipmentExtraEquiping,
	var0_0.EquipmentExtraStrengthen,
	var0_0.EquipmentExtraTransform
}
var0_0.EquipmentExtraNone = 0

table.insert(var0_0.EquipmentExtraIndexs, 1, var0_0.EquipmentExtraNone)

function var0_0.filterEquipByExtra(arg0_19, arg1_19)
	arg1_19 = arg1_19 or 0

	if bit.band(arg1_19, var0_0.EquipmentExtraEquiping) > 0 and not arg0_19.shipId then
		return false
	end

	if bit.band(arg1_19, var0_0.EquipmentExtraStrengthen) > 0 then
		local var0_19 = pg.equip_data_template[arg0_19.id]

		if not var0_19 or not var0_19.next or var0_19.next == 0 then
			return false
		end
	end

	if bit.band(arg1_19, var0_0.EquipmentExtraTransform) > 0 then
		local var1_19 = EquipmentProxy.EquipTransformTargetDict[Equipment.GetEquipRootStatic(arg0_19.id)]

		if not var1_19 or not var1_19.targets then
			return false
		end
	end

	return true
end

var0_0.DisplayEquipSkinSort = 6
var0_0.DisplayEquipSkinIndex = 7
var0_0.DisplayEquipSkinTheme = 8
var0_0.EquipSkinSortType = 1
var0_0.EquipSkinSortTypes = {
	var0_0.EquipSkinSortType
}
var0_0.EquipSkinSortNames = {
	i18n("word_equipskin_type")
}
var0_0.EquipSkinIndexAll = 1
var0_0.EquipSkinIndexCannon = 2
var0_0.EquipSkinIndexTarpedo = 3
var0_0.EquipSkinIndexAircraft = 4
var0_0.EquipSkinIndexAux = 5
var0_0.EquipSkinIndexTypes = {
	var0_0.EquipSkinIndexAll,
	var0_0.EquipSkinIndexCannon,
	var0_0.EquipSkinIndexTarpedo,
	var0_0.EquipSkinIndexAircraft,
	var0_0.EquipSkinIndexAux
}
var0_0.EquipSkinIndexNames = {
	i18n("word_equipskin_all"),
	i18n("word_equipskin_cannon"),
	i18n("word_equipskin_tarpedo"),
	i18n("word_equipskin_aircraft"),
	i18n("word_equipskin_aux")
}
var0_0.EquipSkinThemeAll = 1
var0_0.EquipSkinThemeEnd = nil
var0_0.EquipSkinThemeTypes = {
	var0_0.EquipSkinThemeAll
}

for iter0_0, iter1_0 in ipairs(pg.equip_skin_theme_template.all) do
	table.insert(var0_0.EquipSkinThemeTypes, iter0_0 + var0_0.EquipSkinThemeAll)

	if iter0_0 == #pg.equip_skin_theme_template.all then
		var0_0.EquipSkinThemeEnd = iter0_0 + var0_0.EquipSkinThemeAll + 1
	end
end

var0_0.EquipSkinThemeNames = {
	i18n("word_equipskin_all")
}

for iter2_0, iter3_0 in ipairs(pg.equip_skin_theme_template.all) do
	local var1_0 = pg.equip_skin_theme_template[iter3_0].name

	table.insert(var0_0.EquipSkinThemeNames, var1_0)
end

function var0_0.filterEquipSkinByIndex(arg0_20, arg1_20)
	if not arg1_20 then
		return true
	end

	if bit.band(arg1_20, bit.lshift(1, var0_0.EquipSkinIndexAll)) > 0 then
		return true
	end

	local var0_20 = {}
	local var1_20 = {
		1,
		2,
		3,
		4,
		5
	}

	for iter0_20, iter1_20 in ipairs(var0_0.EquipSkinIndexTypes) do
		if bit.band(arg1_20, bit.lshift(1, iter1_20)) > 0 then
			local var2_20 = var1_20[iter1_20]
			local var3_20 = EquipmentSortCfg.skinIndex[var2_20].types

			for iter2_20, iter3_20 in ipairs(var3_20) do
				table.insert(var0_20, iter3_20)
			end
		end
	end

	local var4_20 = pg.equip_skin_template

	if arg0_20.count > 0 and arg0_20.isSkin then
		local var5_20 = var4_20[arg0_20.id].equip_type

		for iter4_20, iter5_20 in pairs(var5_20) do
			if table.contains(var0_20, iter5_20) then
				return true
			end
		end
	end
end

function var0_0.filterEquipSkinByTheme(arg0_21, arg1_21)
	if not arg1_21 then
		return true
	end

	if string.find(var0_0.StrAnd(arg1_21, var0_0.StrLShift("1", var0_0.EquipSkinThemeAll)), "1") ~= nil then
		return true
	end

	local var0_21 = pg.equip_skin_template
	local var1_21 = pg.equip_skin_theme_template

	if arg0_21.count > 0 and arg0_21.isSkin then
		local var2_21 = arg0_21.id
		local var3_21 = var0_21[var2_21].themeid
		local var4_21

		for iter0_21, iter1_21 in ipairs(var0_0.EquipSkinThemeTypes) do
			if string.find(var0_0.StrAnd(arg1_21, var0_0.StrLShift("1", iter0_21)), "1") ~= nil then
				local var5_21 = var1_21[var1_21[pg.equip_skin_theme_template.all[iter1_21 - 1]].id].ids

				if table.contains(var5_21, var2_21) then
					return true
				end
			end
		end
	end
end

var0_0.SpWeaponTypeQvZhu = bit.lshift(1, 0)
var0_0.SpWeaponTypeQingXvn = bit.lshift(1, 1)
var0_0.SpWeaponTypeZhongXvn = bit.lshift(1, 2)
var0_0.SpWeaponTypeZhanLie = bit.lshift(1, 3)
var0_0.SpWeaponTypeHangMu = bit.lshift(1, 4)
var0_0.SpWeaponTypeWeiXiu = bit.lshift(1, 5)
var0_0.SpWeaponTypeQianTing = bit.lshift(1, 6)
var0_0.SpWeaponTypeQiTa = bit.lshift(1, 7)
var0_0.SpWeaponTypeIndexs = {
	var0_0.SpWeaponTypeQvZhu,
	var0_0.SpWeaponTypeQingXvn,
	var0_0.SpWeaponTypeZhongXvn,
	var0_0.SpWeaponTypeZhanLie,
	var0_0.SpWeaponTypeHangMu,
	var0_0.SpWeaponTypeWeiXiu,
	var0_0.SpWeaponTypeQianTing,
	var0_0.SpWeaponTypeQiTa
}
var0_0.SpWeaponTypeAll = var0_0.BitAll(var0_0.SpWeaponTypeIndexs)

table.insert(var0_0.SpWeaponTypeIndexs, 1, var0_0.SpWeaponTypeAll)

function var0_0.filterSpWeaponByType(arg0_22, arg1_22)
	if not arg1_22 or arg1_22 == var0_0.SpWeaponTypeAll then
		return true
	end

	local var0_22 = arg0_22:GetWearableShipTypes()

	for iter0_22 = 0, #var0_0.SpWeaponTypeIndexs - 2 do
		local var1_22 = bit.lshift(1, iter0_22)

		if bit.band(var1_22, arg1_22) > 0 then
			local var2_22 = ShipIndexCfg.type[4 + iter0_22].types

			if _.any(var2_22, function(arg0_23)
				return table.contains(var0_22, arg0_23)
			end) then
				return true
			end
		end
	end

	return false
end

var0_0.SpWeaponTypeNames = {
	"word_equipment_all",
	"spweapon_ui_index_shipType_quZhu",
	"spweapon_ui_index_shipType_qinXun",
	"spweapon_ui_index_shipType_zhongXun",
	"spweapon_ui_index_shipType_zhanLie",
	"spweapon_ui_index_shipType_hangMu",
	"spweapon_ui_index_shipType_weiXiu",
	"spweapon_ui_index_shipType_qianTing",
	"spweapon_ui_index_shipType_other"
}
var0_0.SpWeaponRarityNames = {
	"index_all",
	"index_rare3",
	"index_rare4",
	"index_rare5"
}
var0_0.SpWeaponRarity1 = bit.lshift(1, 0)
var0_0.SpWeaponRarity2 = bit.lshift(1, 1)
var0_0.SpWeaponRarity3 = bit.lshift(1, 2)
var0_0.SpWeaponRarityIndexs = {
	var0_0.SpWeaponRarity1,
	var0_0.SpWeaponRarity2,
	var0_0.SpWeaponRarity3
}
var0_0.SpWeaponRarityAll = var0_0.BitAll(var0_0.SpWeaponRarityIndexs)

table.insert(var0_0.SpWeaponRarityIndexs, 1, var0_0.SpWeaponRarityAll)

function var0_0.filterSpWeaponByRarity(arg0_24, arg1_24)
	if not arg1_24 or arg1_24 == var0_0.SpWeaponRarityAll then
		return true
	end

	local var0_24 = math.max(arg0_24:GetRarity() - 2, 0)
	local var1_24 = bit.lshift(1, var0_24)

	return bit.band(var1_24, arg1_24) > 0
end

var0_0.LABEL_COUNT = 9
var0_0.ECodeLabelNames = {}
var0_0.ECodeLabelIndexs = {}

for iter4_0 = 1, var0_0.LABEL_COUNT do
	local var2_0 = bit.lshift(1, iter4_0 - 1)

	table.insert(var0_0.ECodeLabelNames, "equip_share_label_" .. iter4_0)
	table.insert(var0_0.ECodeLabelIndexs, var2_0)
end

local var3_0 = var0_0.BitAll(var0_0.ECodeLabelIndexs)

table.insert(var0_0.ECodeLabelNames, 1, "index_all")
table.insert(var0_0.ECodeLabelIndexs, 1, var3_0)

function var0_0.filterEquipCodeByLable(arg0_25, arg1_25)
	if not arg1_25 or arg1_25 == var3_0 then
		return true
	end

	for iter0_25, iter1_25 in ipairs(arg0_25:GetLabels()) do
		if bit.band(bit.lshift(1, iter1_25 - 1), arg1_25) > 0 then
			return true
		end
	end

	return false
end

return var0_0
