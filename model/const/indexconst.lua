local var0 = class("IndexConst")

function var0.Flags2Bits(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0) do
		var0 = bit.bor(var0, bit.lshift(1, iter1))
	end

	return var0
end

function var0.FlagRange2Bits(arg0, arg1)
	local var0 = 0

	for iter0 = arg0, arg1 do
		var0 = bit.bor(var0, bit.lshift(1, iter0))
	end

	return var0
end

function var0.ToggleBits(arg0, arg1, arg2, arg3)
	local var0 = arg0
	local var1 = bit.lshift(1, arg3)

	if arg2 then
		local var2 = bit.lshift(1, arg2)
		local var3 = _.reduce(arg1, 0, function(arg0, arg1)
			return arg0 + (arg1 ~= arg2 and bit.lshift(1, arg1) or 0)
		end)

		if var1 == var2 then
			var0 = var2
		else
			if bit.band(var0, var2) > 0 then
				var0 = var0 - var2
			end

			if bit.band(var0, var1) > 0 then
				var1 = -var1
			end

			var0 = var0 + var1

			if var0 == var3 or var0 == 0 then
				var0 = var2
			end
		end
	else
		if bit.band(var0, var1) > 0 then
			var1 = -var1
		end

		var0 = var0 + var1
	end

	return var0
end

function var0.SingleToggleBits(arg0, arg1, arg2, arg3)
	local var0 = arg0
	local var1 = bit.lshift(1, arg3)

	if var0 == var1 then
		var0 = bit.lshift(1, arg2)
	else
		var0 = var1
	end

	return var0
end

function var0.StrLShift(arg0, arg1)
	local var0 = ""

	for iter0 = 1, arg1 do
		arg0 = arg0 .. "0"
	end

	return arg0 .. var0
end

function var0.StrAnd(arg0, arg1)
	local var0 = ""
	local var1 = string.len(arg0) > string.len(arg1) and arg0 or arg1
	local var2 = var1 == arg0 and arg1 or arg0
	local var3 = string.len(var1)
	local var4 = string.len(var2)

	for iter0 = 1, var4 do
		if string.sub(var2, iter0, iter0) == "1" and string.sub(var1, var3 - var4 + iter0, var3 - var4 + iter0) == "1" then
			var0 = var0 .. "1"
		else
			var0 = var0 .. "0"
		end
	end

	local var5 = ""

	for iter1 = 1, var3 - var4 do
		var5 = var5 .. "0"
	end

	return var5 .. var0
end

function var0.StrOr(arg0, arg1)
	local var0 = ""
	local var1 = string.len(arg0) > string.len(arg1) and arg0 or arg1
	local var2 = var1 == arg0 and arg1 or arg0
	local var3 = string.len(var1)
	local var4 = string.len(var2)

	for iter0 = 1, var4 do
		if string.sub(var2, iter0, iter0) == "1" or string.sub(var1, var3 - var4 + iter0, var3 - var4 + iter0) == "1" then
			var0 = var0 .. "1"
		else
			var0 = var0 .. "0"
		end
	end

	return string.sub(var1, 1, var3 - var4) .. var0
end

function var0.Flags2Str(arg0)
	local var0 = ""

	for iter0, iter1 in ipairs(arg0) do
		var0 = var0.StrOr(var0, var0.StrLShift("1", iter1))
	end

	return var0
end

function var0.FlagRange2Str(arg0, arg1)
	local var0 = ""

	for iter0 = arg0, arg1 do
		var0 = var0.StrOr(var0, var0.StrLShift("1", iter0))
	end

	return var0
end

function var0.ToggleStr(arg0, arg1, arg2, arg3)
	local var0 = arg0
	local var1 = var0.StrLShift("1", arg3)

	if arg2 then
		local var2 = var0.StrLShift("1", arg2)
		local var3 = ""

		for iter0, iter1 in ipairs(arg1) do
			if iter1 ~= arg2 then
				var3 = var0.StrOr(var3, var0.StrLShift("1", iter1))
			end
		end

		if var1 == var2 or var0 == var3 then
			var0 = var2
		else
			if string.find(var0.StrAnd(var0, var2), "1") ~= nil then
				var0 = var1
			else
				local var4 = var0.StrOr(var0, var1)
				local var5 = string.len(var4) - arg3
				local var6 = string.find(var0.StrAnd(var0, var1), "1") ~= nil and "0" or "1"

				var0 = string.sub(var4, 1, var5 - 1) .. var6 .. string.sub(var4, var5 + 1)
			end

			if var0 == var3 or string.find(var0, "1") == nil then
				var0 = var2
			end
		end
	else
		local var7 = var0.StrOr(var0, var1)
		local var8 = string.len(var7) - arg3
		local var9 = string.find(var0.StrAnd(var0, var1), "1") ~= nil and "0" or "1"

		var0 = string.sub(var7, 1, var8 - 1) .. var9 .. string.sub(var7, var8 + 1)
	end

	return var0
end

function var0.BitAll(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0) do
		var0 = bit.bor(iter1, var0)
	end

	return var0
end

var0.EquipmentTypeSmallCannon = bit.lshift(1, 0)
var0.EquipmentTypeMediumCannon = bit.lshift(1, 1)
var0.EquipmentTypeBigCannon = bit.lshift(1, 2)
var0.EquipmentTypeWarshipTorpedo = bit.lshift(1, 3)
var0.EquipmentTypeSubmaraineTorpedo = bit.lshift(1, 4)
var0.EquipmentTypeAntiAircraft = bit.lshift(1, 5)
var0.EquipmentTypeFighter = bit.lshift(1, 6)
var0.EquipmentTypeBomber = bit.lshift(1, 7)
var0.EquipmentTypeTorpedoBomber = bit.lshift(1, 8)
var0.EquipmentTypeEquip = bit.lshift(1, 9)
var0.EquipmentTypeOther = bit.lshift(1, 10)
var0.EquipmentTypeIndexs = {
	var0.EquipmentTypeSmallCannon,
	var0.EquipmentTypeMediumCannon,
	var0.EquipmentTypeBigCannon,
	var0.EquipmentTypeWarshipTorpedo,
	var0.EquipmentTypeSubmaraineTorpedo,
	var0.EquipmentTypeAntiAircraft,
	var0.EquipmentTypeFighter,
	var0.EquipmentTypeBomber,
	var0.EquipmentTypeTorpedoBomber,
	var0.EquipmentTypeEquip,
	var0.EquipmentTypeOther
}
var0.EquipmentTypeAll = var0.BitAll(var0.EquipmentTypeIndexs)

table.insert(var0.EquipmentTypeIndexs, 1, var0.EquipmentTypeAll)

function var0.filterEquipByType(arg0, arg1)
	if not arg1 or arg1 == var0.EquipmentTypeAll then
		return true
	end

	for iter0 = 2, #EquipmentSortCfg.index do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = EquipmentSortCfg.index[iter0].types

			if table.contains(var1, arg0:getConfig("type")) then
				return true
			end
		end
	end

	return false
end

var0.EquipmentTypeNames = {
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
var0.EquipCampUS = bit.lshift(1, 0)
var0.EquipCampEN = bit.lshift(1, 1)
var0.EquipCampJP = bit.lshift(1, 2)
var0.EquipCampDE = bit.lshift(1, 3)
var0.EquipCampCN = bit.lshift(1, 4)
var0.EquipCampITA = bit.lshift(1, 5)
var0.EquipCampSN = bit.lshift(1, 6)
var0.EquipCampFR = bit.lshift(1, 7)
var0.EquipCampMNF = bit.lshift(1, 8)
var0.EquipCampLINK = bit.lshift(1, 9)
var0.EquipCampOther = bit.lshift(1, 10)
var0.EquipCampIndexs = {
	var0.EquipCampUS,
	var0.EquipCampEN,
	var0.EquipCampJP,
	var0.EquipCampDE,
	var0.EquipCampCN,
	var0.EquipCampITA,
	var0.EquipCampSN,
	var0.EquipCampFR,
	var0.EquipCampMNF,
	var0.EquipCampLINK,
	var0.EquipCampOther
}
var0.EquipCampNames = {
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
var0.EquipCampAll = var0.BitAll(var0.EquipCampIndexs)

table.insert(var0.EquipCampIndexs, 1, var0.EquipCampAll)

function var0.filterEquipByCamp(arg0, arg1)
	if not arg1 or arg1 == var0.EquipmentTypeAll then
		return true
	end

	for iter0 = 2, #EquipmentSortCfg.campIndex do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = EquipmentSortCfg.campIndex[iter0].types

			for iter1, iter2 in ipairs(var1) do
				if iter2 == Nation.LINK then
					if arg0:getNation() >= Nation.LINK then
						return true
					end
				elseif iter2 == arg0:getNation() then
					return true
				end
			end
		end
	end

	return false
end

var0.EquipProperty_Cannon = bit.lshift(1, 0)
var0.EquipProperty_Air = bit.lshift(1, 1)
var0.EquipProperty_Dodge = bit.lshift(1, 2)
var0.EquipProperty_AntiAircraft = bit.lshift(1, 3)
var0.EquipProperty_Torpedo = bit.lshift(1, 4)
var0.EquipProperty_Reload = bit.lshift(1, 5)
var0.EquipProperty_Durability = bit.lshift(1, 6)
var0.EquipProperty_Antisub = bit.lshift(1, 7)
var0.EquipProperty_Oxy = bit.lshift(1, 8)
var0.EquipProperty_Speed = bit.lshift(1, 9)
var0.EquipProperty_Hit = bit.lshift(1, 10)
var0.EquipProperty_Luck = bit.lshift(1, 11)
var0.EquipPropertyIndexs = {
	var0.EquipProperty_Cannon,
	var0.EquipProperty_Air,
	var0.EquipProperty_Dodge,
	var0.EquipProperty_AntiAircraft,
	var0.EquipProperty_Torpedo,
	var0.EquipProperty_Reload,
	var0.EquipProperty_Durability,
	var0.EquipProperty_Antisub,
	var0.EquipProperty_Oxy,
	var0.EquipProperty_Speed,
	var0.EquipProperty_Hit,
	var0.EquipProperty_Luck
}
var0.EquipPropertyAll = var0.BitAll(var0.EquipPropertyIndexs)

table.insert(var0.EquipPropertyIndexs, 1, var0.EquipPropertyAll)

var0.EquipPropertyNames = {
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

function var0.filterEquipByProperty(arg0, arg1)
	local var0 = {}

	if arg0:getConfig("attribute_1") then
		table.insert(var0, arg0:getConfig("attribute_1"))
	end

	if arg0:getConfig("attribute_2") then
		table.insert(var0, arg0:getConfig("attribute_2"))
	end

	if arg0:getConfig("attribute_3") then
		table.insert(var0, arg0:getConfig("attribute_3"))
	end

	local var1 = 0

	for iter0, iter1 in ipairs(arg1) do
		if not iter1 or iter1 == var0.EquipPropertyAll then
			var1 = var1 + 1
		else
			for iter2 = 2, #EquipmentSortCfg.propertyIndex do
				local var2 = bit.lshift(1, iter2 - 2)

				if bit.band(var2, iter1) > 0 then
					local var3 = EquipmentSortCfg.propertyIndex[iter2].types

					for iter3 = #var0, 1, -1 do
						local var4 = var0[iter3]

						if table.contains(var3, var4) then
							var1 = var1 + 1

							table.remove(var0, iter3)

							break
						end
					end
				end
			end
		end
	end

	return var1 >= #arg1
end

var0.EquipAmmoChuanjia = bit.lshift(1, 0)
var0.EquipAmmoGaobao = bit.lshift(1, 1)
var0.EquipAmmoTongchangDan = bit.lshift(1, 2)
var0.EquipAmmoQita = bit.lshift(1, 3)
var0.EquipAmmoIndexs_1 = {
	var0.EquipAmmoChuanjia,
	var0.EquipAmmoGaobao,
	var0.EquipAmmoTongchangDan,
	var0.EquipAmmoQita
}
var0.EquipAmmoAll_1 = var0.BitAll(var0.EquipAmmoIndexs_1)

table.insert(var0.EquipAmmoIndexs_1, 1, var0.EquipAmmoAll_1)

var0.EquipAmmoIndexs_1_Names = {
	"attribute_ammo",
	"equip_ammo_type_1",
	"equip_ammo_type_2",
	"equip_ammo_type_3",
	"word_shipType_other"
}

function var0.filterEquipAmmo1(arg0, arg1)
	if not arg1 or arg1 == var0.EquipAmmoAll_1 then
		return true
	end

	for iter0 = 2, #EquipmentSortCfg.ammoIndex1 do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = EquipmentSortCfg.ammoIndex1[iter0].types

			if table.contains(var1, arg0:getConfig("ammo")) then
				return true
			end
		end
	end

	return false
end

var0.EquipAmmoShengdao = bit.lshift(1, 0)
var0.EquipAmmoTongchang = bit.lshift(1, 1)
var0.EquipAmmoIndexs_2 = {
	var0.EquipAmmoShengdao,
	var0.EquipAmmoTongchang
}
var0.EquipAmmoAll_2 = var0.BitAll(var0.EquipAmmoIndexs_2)

table.insert(var0.EquipAmmoIndexs_2, 1, var0.EquipAmmoAll_2)

var0.EquipAmmoIndexs_2_Names = {
	"attribute_ammo",
	"equip_ammo_type_4",
	"equip_ammo_type_5"
}

function var0.filterEquipAmmo2(arg0, arg1)
	if not arg1 or arg1 == var0.EquipAmmoAll_2 then
		return true
	end

	for iter0 = 2, #EquipmentSortCfg.ammoIndex2 do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = EquipmentSortCfg.ammoIndex2[iter0].types

			if table.contains(var1, arg0:getConfig("ammo")) then
				return true
			end
		end
	end

	return false
end

var0.EquipmentRarity1 = bit.lshift(1, 0)
var0.EquipmentRarity2 = bit.lshift(1, 1)
var0.EquipmentRarity3 = bit.lshift(1, 2)
var0.EquipmentRarity4 = bit.lshift(1, 3)
var0.EquipmentRarity5 = bit.lshift(1, 4)
var0.EquipmentRarityIndexs = {
	var0.EquipmentRarity1,
	var0.EquipmentRarity2,
	var0.EquipmentRarity3,
	var0.EquipmentRarity4,
	var0.EquipmentRarity5
}
var0.EquipmentRarityAll = var0.BitAll(var0.EquipmentRarityIndexs)

table.insert(var0.EquipmentRarityIndexs, 1, var0.EquipmentRarityAll)

var0.RarityNames = {
	"index_all",
	"index_rare2",
	"index_rare3",
	"index_rare4",
	"index_rare5",
	"index_rare6"
}

function var0.filterEquipByRarity(arg0, arg1)
	if not arg1 or arg1 == var0.EquipmentRarityAll then
		return true
	end

	local var0 = math.max(arg0:getConfig("rarity") - 2, 0)
	local var1 = bit.lshift(1, var0)

	return bit.band(var1, arg1) > 0
end

var0.EquipmentExtraNames = {
	"index_without_limit",
	"index_equip",
	"index_strengthen",
	"index_reform"
}
var0.EquipmentExtraEquiping = bit.lshift(1, 0)
var0.EquipmentExtraStrengthen = bit.lshift(1, 1)
var0.EquipmentExtraTransform = bit.lshift(1, 2)
var0.EquipmentExtraIndexs = {
	var0.EquipmentExtraEquiping,
	var0.EquipmentExtraStrengthen,
	var0.EquipmentExtraTransform
}
var0.EquipmentExtraNone = 0

table.insert(var0.EquipmentExtraIndexs, 1, var0.EquipmentExtraNone)

function var0.filterEquipByExtra(arg0, arg1)
	arg1 = arg1 or 0

	if bit.band(arg1, var0.EquipmentExtraEquiping) > 0 and not arg0.shipId then
		return false
	end

	if bit.band(arg1, var0.EquipmentExtraStrengthen) > 0 then
		local var0 = pg.equip_data_template[arg0.id]

		if not var0 or not var0.next or var0.next == 0 then
			return false
		end
	end

	if bit.band(arg1, var0.EquipmentExtraTransform) > 0 then
		local var1 = EquipmentProxy.EquipTransformTargetDict[Equipment.GetEquipRootStatic(arg0.id)]

		if not var1 or not var1.targets then
			return false
		end
	end

	return true
end

var0.DisplayEquipSkinSort = 6
var0.DisplayEquipSkinIndex = 7
var0.DisplayEquipSkinTheme = 8
var0.EquipSkinSortType = 1
var0.EquipSkinSortTypes = {
	var0.EquipSkinSortType
}
var0.EquipSkinSortNames = {
	i18n("word_equipskin_type")
}
var0.EquipSkinIndexAll = 1
var0.EquipSkinIndexCannon = 2
var0.EquipSkinIndexTarpedo = 3
var0.EquipSkinIndexAircraft = 4
var0.EquipSkinIndexAux = 5
var0.EquipSkinIndexTypes = {
	var0.EquipSkinIndexAll,
	var0.EquipSkinIndexCannon,
	var0.EquipSkinIndexTarpedo,
	var0.EquipSkinIndexAircraft,
	var0.EquipSkinIndexAux
}
var0.EquipSkinIndexNames = {
	i18n("word_equipskin_all"),
	i18n("word_equipskin_cannon"),
	i18n("word_equipskin_tarpedo"),
	i18n("word_equipskin_aircraft"),
	i18n("word_equipskin_aux")
}
var0.EquipSkinThemeAll = 1
var0.EquipSkinThemeEnd = nil
var0.EquipSkinThemeTypes = {
	var0.EquipSkinThemeAll
}

for iter0, iter1 in ipairs(pg.equip_skin_theme_template.all) do
	table.insert(var0.EquipSkinThemeTypes, iter0 + var0.EquipSkinThemeAll)

	if iter0 == #pg.equip_skin_theme_template.all then
		var0.EquipSkinThemeEnd = iter0 + var0.EquipSkinThemeAll + 1
	end
end

var0.EquipSkinThemeNames = {
	i18n("word_equipskin_all")
}

for iter2, iter3 in ipairs(pg.equip_skin_theme_template.all) do
	local var1 = pg.equip_skin_theme_template[iter3].name

	table.insert(var0.EquipSkinThemeNames, var1)
end

function var0.filterEquipSkinByIndex(arg0, arg1)
	if not arg1 then
		return true
	end

	if bit.band(arg1, bit.lshift(1, var0.EquipSkinIndexAll)) > 0 then
		return true
	end

	local var0 = {}
	local var1 = {
		1,
		2,
		3,
		4,
		5
	}

	for iter0, iter1 in ipairs(var0.EquipSkinIndexTypes) do
		if bit.band(arg1, bit.lshift(1, iter1)) > 0 then
			local var2 = var1[iter1]
			local var3 = EquipmentSortCfg.skinIndex[var2].types

			for iter2, iter3 in ipairs(var3) do
				table.insert(var0, iter3)
			end
		end
	end

	local var4 = pg.equip_skin_template

	if arg0.count > 0 and arg0.isSkin then
		local var5 = var4[arg0.id].equip_type

		for iter4, iter5 in pairs(var5) do
			if table.contains(var0, iter5) then
				return true
			end
		end
	end
end

function var0.filterEquipSkinByTheme(arg0, arg1)
	if not arg1 then
		return true
	end

	if string.find(var0.StrAnd(arg1, var0.StrLShift("1", var0.EquipSkinThemeAll)), "1") ~= nil then
		return true
	end

	local var0 = pg.equip_skin_template
	local var1 = pg.equip_skin_theme_template

	if arg0.count > 0 and arg0.isSkin then
		local var2 = arg0.id
		local var3 = var0[var2].themeid
		local var4

		for iter0, iter1 in ipairs(var0.EquipSkinThemeTypes) do
			if string.find(var0.StrAnd(arg1, var0.StrLShift("1", iter0)), "1") ~= nil then
				local var5 = var1[var1[pg.equip_skin_theme_template.all[iter1 - 1]].id].ids

				if table.contains(var5, var2) then
					return true
				end
			end
		end
	end
end

var0.SpWeaponTypeQvZhu = bit.lshift(1, 0)
var0.SpWeaponTypeQingXvn = bit.lshift(1, 1)
var0.SpWeaponTypeZhongXvn = bit.lshift(1, 2)
var0.SpWeaponTypeZhanLie = bit.lshift(1, 3)
var0.SpWeaponTypeHangMu = bit.lshift(1, 4)
var0.SpWeaponTypeWeiXiu = bit.lshift(1, 5)
var0.SpWeaponTypeQianTing = bit.lshift(1, 6)
var0.SpWeaponTypeQiTa = bit.lshift(1, 7)
var0.SpWeaponTypeIndexs = {
	var0.SpWeaponTypeQvZhu,
	var0.SpWeaponTypeQingXvn,
	var0.SpWeaponTypeZhongXvn,
	var0.SpWeaponTypeZhanLie,
	var0.SpWeaponTypeHangMu,
	var0.SpWeaponTypeWeiXiu,
	var0.SpWeaponTypeQianTing,
	var0.SpWeaponTypeQiTa
}
var0.SpWeaponTypeAll = var0.BitAll(var0.SpWeaponTypeIndexs)

table.insert(var0.SpWeaponTypeIndexs, 1, var0.SpWeaponTypeAll)

function var0.filterSpWeaponByType(arg0, arg1)
	if not arg1 or arg1 == var0.SpWeaponTypeAll then
		return true
	end

	local var0 = arg0:GetWearableShipTypes()

	for iter0 = 0, #var0.SpWeaponTypeIndexs - 2 do
		local var1 = bit.lshift(1, iter0)

		if bit.band(var1, arg1) > 0 then
			local var2 = ShipIndexCfg.type[4 + iter0].types

			if _.any(var2, function(arg0)
				return table.contains(var0, arg0)
			end) then
				return true
			end
		end
	end

	return false
end

var0.SpWeaponTypeNames = {
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
var0.SpWeaponRarityNames = {
	"index_all",
	"index_rare3",
	"index_rare4",
	"index_rare5"
}
var0.SpWeaponRarity1 = bit.lshift(1, 0)
var0.SpWeaponRarity2 = bit.lshift(1, 1)
var0.SpWeaponRarity3 = bit.lshift(1, 2)
var0.SpWeaponRarityIndexs = {
	var0.SpWeaponRarity1,
	var0.SpWeaponRarity2,
	var0.SpWeaponRarity3
}
var0.SpWeaponRarityAll = var0.BitAll(var0.SpWeaponRarityIndexs)

table.insert(var0.SpWeaponRarityIndexs, 1, var0.SpWeaponRarityAll)

function var0.filterSpWeaponByRarity(arg0, arg1)
	if not arg1 or arg1 == var0.SpWeaponRarityAll then
		return true
	end

	local var0 = math.max(arg0:GetRarity() - 2, 0)
	local var1 = bit.lshift(1, var0)

	return bit.band(var1, arg1) > 0
end

var0.LABEL_COUNT = 9
var0.ECodeLabelNames = {}
var0.ECodeLabelIndexs = {}

for iter4 = 1, var0.LABEL_COUNT do
	local var2 = bit.lshift(1, iter4 - 1)

	table.insert(var0.ECodeLabelNames, "equip_share_label_" .. iter4)
	table.insert(var0.ECodeLabelIndexs, var2)
end

local var3 = var0.BitAll(var0.ECodeLabelIndexs)

table.insert(var0.ECodeLabelNames, 1, "index_all")
table.insert(var0.ECodeLabelIndexs, 1, var3)

function var0.filterEquipCodeByLable(arg0, arg1)
	if not arg1 or arg1 == var3 then
		return true
	end

	for iter0, iter1 in ipairs(arg0:GetLabels()) do
		if bit.band(bit.lshift(1, iter1 - 1), arg1) > 0 then
			return true
		end
	end

	return false
end

return var0
