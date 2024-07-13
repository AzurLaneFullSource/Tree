local var0_0 = class("ShipIndexConst")

var0_0.SortRarity = bit.lshift(1, 0)
var0_0.SortLevel = bit.lshift(1, 1)
var0_0.SortPower = bit.lshift(1, 2)
var0_0.SortAchivedTime = bit.lshift(1, 3)
var0_0.SortIntimacy = bit.lshift(1, 4)
var0_0.SortEnergy = bit.lshift(1, 13)
var0_0.SortProperty_Cannon = bit.lshift(1, 5)
var0_0.SortProperty_Air = bit.lshift(1, 6)
var0_0.SortProperty_Dodge = bit.lshift(1, 7)
var0_0.SortProperty_AntiAircraft = bit.lshift(1, 8)
var0_0.SortProperty_Torpedo = bit.lshift(1, 9)
var0_0.SortProperty_Reload = bit.lshift(1, 10)
var0_0.SortProperty_Durability = bit.lshift(1, 11)
var0_0.SortProperty_Antisub = bit.lshift(1, 12)
var0_0.SortPropertyIndexs = {
	var0_0.SortProperty_Cannon,
	var0_0.SortProperty_Air,
	var0_0.SortProperty_Dodge,
	var0_0.SortProperty_AntiAircraft,
	var0_0.SortProperty_Torpedo,
	var0_0.SortProperty_Reload,
	var0_0.SortProperty_Durability,
	var0_0.SortProperty_Antisub
}
var0_0.SortPropertyAll = IndexConst.BitAll(var0_0.SortPropertyIndexs)

table.insert(var0_0.SortPropertyIndexs, 1, var0_0.SortPropertyAll)

var0_0.SortIndexs = {
	var0_0.SortRarity,
	var0_0.SortLevel,
	var0_0.SortPower,
	var0_0.SortAchivedTime,
	var0_0.SortIntimacy,
	var0_0.SortEnergy
}

function var0_0.getSortFuncAndName(arg0_1, arg1_1)
	for iter0_1 = 1, #ShipIndexCfg.sort do
		local var0_1 = bit.lshift(1, iter0_1 - 1)

		if bit.band(var0_1, arg0_1) > 0 then
			return underscore.map(ShipIndexCfg.sort[iter0_1].sortFuncs, function(arg0_2)
				return function(arg0_3)
					return (arg1_1 and -1 or 1) * arg0_2(arg0_3)
				end
			end), ShipIndexCfg.sort[iter0_1].name
		end
	end
end

var0_0.SortNames = {
	"word_rarity",
	"word_lv",
	"word_synthesize_power",
	"word_achieved_item",
	"attribute_intimacy",
	"sort_energy"
}
var0_0.SortPropertyNames = {
	"sort_attribute",
	"word_attr_cannon",
	"word_attr_air",
	"word_attr_dodge",
	"word_attr_antiaircraft",
	"word_attr_torpedo",
	"word_attr_reload",
	"word_attr_durability",
	"word_attr_antisub"
}

function var0_0.sortByCombatPower()
	return {
		function(arg0_5)
			return -arg0_5:getShipCombatPower()
		end,
		function(arg0_6)
			return arg0_6.configId
		end
	}
end

function var0_0.sortByField(arg0_7)
	return {
		function(arg0_8)
			return -arg0_8[arg0_7]
		end,
		function(arg0_9)
			return -arg0_9:getRarity()
		end,
		function(arg0_10)
			return arg0_10.configId
		end
	}
end

function var0_0.sortByProperty(arg0_11)
	return {
		function(arg0_12)
			return -arg0_12:getShipProperties()[arg0_11]
		end,
		function(arg0_13)
			return arg0_13.configId
		end
	}
end

function var0_0.sortByCfg(arg0_14)
	return {
		function(arg0_15)
			return -(arg0_14 == "rarity" and arg0_15:getRarity() or arg0_15:getConfig(arg0_14))
		end,
		function(arg0_16)
			return arg0_16.configId
		end
	}
end

function var0_0.sortByIntimacy()
	return {
		function(arg0_18)
			return -arg0_18.intimacy
		end,
		function(arg0_19)
			return arg0_19.propose and 0 or 1
		end,
		function(arg0_20)
			return arg0_20.configId
		end,
		function(arg0_21)
			return -arg0_21.level
		end
	}
end

function var0_0.sortByEnergy()
	return {
		function(arg0_23)
			return -arg0_23:getEnergy()
		end,
		function(arg0_24)
			return arg0_24.configId
		end
	}
end

var0_0.TypeFront = bit.lshift(1, 0)
var0_0.TypeBack = bit.lshift(1, 1)
var0_0.TypeQuZhu = bit.lshift(1, 2)
var0_0.TypeQingXun = bit.lshift(1, 3)
var0_0.TypeZhongXun = bit.lshift(1, 4)
var0_0.TypeZhanLie = bit.lshift(1, 5)
var0_0.TypeHangMu = bit.lshift(1, 6)
var0_0.TypeWeiXiu = bit.lshift(1, 7)
var0_0.TypeQianTing = bit.lshift(1, 8)
var0_0.TypeOther = bit.lshift(1, 9)
var0_0.TypeIndexs = {
	var0_0.TypeFront,
	var0_0.TypeBack,
	var0_0.TypeQuZhu,
	var0_0.TypeQingXun,
	var0_0.TypeZhongXun,
	var0_0.TypeZhanLie,
	var0_0.TypeHangMu,
	var0_0.TypeWeiXiu,
	var0_0.TypeQianTing,
	var0_0.TypeOther
}
var0_0.TypeAll = IndexConst.BitAll(var0_0.TypeIndexs)

table.insert(var0_0.TypeIndexs, 1, var0_0.TypeAll)

var0_0.TypeNames = {
	"index_all",
	"index_fleetfront",
	"index_fleetrear",
	"index_shipType_quZhu",
	"index_shipType_qinXun",
	"index_shipType_zhongXun",
	"index_shipType_zhanLie",
	"index_shipType_hangMu",
	"index_shipType_weiXiu",
	"index_shipType_qianTing",
	"index_other"
}

function var0_0.filterByType(arg0_25, arg1_25)
	if not arg1_25 or arg1_25 == var0_0.TypeAll then
		return true
	end

	for iter0_25 = 2, #ShipIndexCfg.type do
		local var0_25 = bit.lshift(1, iter0_25 - 2)

		if bit.band(var0_25, arg1_25) > 0 then
			local var1_25 = ShipIndexCfg.type[iter0_25].types

			if iter0_25 < 4 then
				local var2_25 = ShipIndexCfg.type[iter0_25].shipTypes

				if table.contains(var1_25, arg0_25:getShipType()) then
					return true
				end

				if table.contains(var1_25, arg0_25:getTeamType()) then
					return true
				end
			elseif table.contains(var1_25, arg0_25:getShipType()) then
				return true
			end
		end
	end

	return false
end

var0_0.CampUS = bit.lshift(1, 0)
var0_0.CampEN = bit.lshift(1, 1)
var0_0.CampJP = bit.lshift(1, 2)
var0_0.CampDE = bit.lshift(1, 3)
var0_0.CampCN = bit.lshift(1, 4)
var0_0.CampITA = bit.lshift(1, 5)
var0_0.CampSN = bit.lshift(1, 6)
var0_0.CampFF = bit.lshift(1, 7)
var0_0.CampMNF = bit.lshift(1, 8)
var0_0.CampMETA = bit.lshift(1, 9)
var0_0.CampMot = bit.lshift(1, 10)
var0_0.CampOther = bit.lshift(1, 11)
var0_0.CampIndexs = {
	var0_0.CampUS,
	var0_0.CampEN,
	var0_0.CampJP,
	var0_0.CampDE,
	var0_0.CampCN,
	var0_0.CampITA,
	var0_0.CampSN,
	var0_0.CampFF,
	var0_0.CampMNF,
	var0_0.CampMETA,
	var0_0.CampMot,
	var0_0.CampOther
}
var0_0.CampAll = IndexConst.BitAll(var0_0.CampIndexs)

table.insert(var0_0.CampIndexs, 1, var0_0.CampAll)

var0_0.CampNames = {
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
	"word_shipNation_meta_index",
	"word_shipNation_mot",
	"word_shipNation_other"
}

function var0_0.filterByCamp(arg0_26, arg1_26)
	if not arg1_26 or arg1_26 == var0_0.CampAll then
		return true
	end

	for iter0_26 = 2, #ShipIndexCfg.camp do
		local var0_26 = bit.lshift(1, iter0_26 - 2)

		if bit.band(var0_26, arg1_26) > 0 then
			local var1_26 = ShipIndexCfg.camp[iter0_26].types

			for iter1_26, iter2_26 in ipairs(var1_26) do
				if iter2_26 == Nation.LINK then
					if arg0_26:getNation() >= Nation.LINK then
						return true
					end
				elseif iter2_26 == arg0_26:getNation() then
					return true
				end
			end
		end
	end

	return false
end

var0_0.Rarity1 = bit.lshift(1, 0)
var0_0.Rarity2 = bit.lshift(1, 1)
var0_0.Rarity3 = bit.lshift(1, 2)
var0_0.Rarity4 = bit.lshift(1, 3)
var0_0.Rarity5 = bit.lshift(1, 4)
var0_0.RarityIndexs = {
	var0_0.Rarity1,
	var0_0.Rarity2,
	var0_0.Rarity3,
	var0_0.Rarity4,
	var0_0.Rarity5
}
var0_0.RarityAll = IndexConst.BitAll(var0_0.RarityIndexs)

table.insert(var0_0.RarityIndexs, 1, var0_0.RarityAll)

var0_0.RarityNames = {
	"index_all",
	"index_rare2",
	"index_rare3",
	"index_rare4",
	"index_rare5",
	"index_rare6"
}

function var0_0.filterByRarity(arg0_27, arg1_27)
	if not arg1_27 or arg1_27 == var0_0.RarityAll then
		return true
	end

	for iter0_27 = 2, #ShipIndexCfg.rarity do
		local var0_27 = bit.lshift(1, iter0_27 - 2)

		if bit.band(var0_27, arg1_27) > 0 then
			local var1_27 = ShipIndexCfg.rarity[iter0_27].types

			if table.contains(var1_27, arg0_27:getRarity()) then
				return true
			end
		end
	end

	return false
end

var0_0.MetaRarityIndexs = {
	var0_0.RarityAll,
	var0_0.Rarity3,
	var0_0.Rarity4
}
var0_0.MetaRarityNames = {
	"index_all",
	"index_rare4",
	"index_rare5"
}
var0_0.MetaExtraRepair = bit.lshift(1, 0)
var0_0.MetaExtraTactics = bit.lshift(1, 1)
var0_0.MetaExtraEnergy = bit.lshift(1, 2)
var0_0.MetaExtraIndexs = {
	var0_0.MetaExtraRepair,
	var0_0.MetaExtraTactics,
	var0_0.MetaExtraEnergy
}
var0_0.MetaExtraAll = IndexConst.BitAll(var0_0.MetaExtraIndexs)

table.insert(var0_0.MetaExtraIndexs, 1, var0_0.MetaExtraAll)

var0_0.MetaExtraNames = {
	"index_no_limit",
	"index_meta_repair",
	"index_meta_tactics",
	"index_meta_energy"
}
var0_0.ExtraSkin = bit.lshift(1, 0)
var0_0.ExtraRemould = bit.lshift(1, 1)
var0_0.Extrastrengthen = bit.lshift(1, 2)
var0_0.ExtraUpgrade = bit.lshift(1, 3)
var0_0.ExtraNotMaxLv = bit.lshift(1, 4)
var0_0.ExtraAwakening = bit.lshift(1, 5)
var0_0.ExtraAwakening2 = bit.lshift(1, 6)
var0_0.ExtraSpecial = bit.lshift(1, 7)
var0_0.ExtraProposeSkin = bit.lshift(1, 8)

if not LOCK_SP_WEAPON then
	var0_0.ExtraUniqueSpWeapon = bit.lshift(1, 9)
	var0_0.DRESSED = bit.lshift(1, 10)
	var0_0.ExtraMarry = bit.lshift(1, 11)
else
	var0_0.DRESSED = bit.lshift(1, 9)
	var0_0.ExtraMarry = bit.lshift(1, 10)
end

var0_0.ExtraIndexs = {
	var0_0.ExtraSkin,
	var0_0.ExtraRemould,
	var0_0.Extrastrengthen,
	var0_0.ExtraUpgrade,
	var0_0.ExtraNotMaxLv,
	var0_0.ExtraAwakening,
	var0_0.ExtraAwakening2,
	var0_0.ExtraSpecial,
	var0_0.ExtraProposeSkin
}

if not LOCK_SP_WEAPON then
	table.insert(var0_0.ExtraIndexs, var0_0.ExtraUniqueSpWeapon)
end

table.insert(var0_0.ExtraIndexs, var0_0.DRESSED)
table.insert(var0_0.ExtraIndexs, var0_0.ExtraMarry)

var0_0.ExtraAll = IndexConst.BitAll(var0_0.ExtraIndexs)

table.insert(var0_0.ExtraIndexs, 1, var0_0.ExtraAll)

var0_0.ExtraNames = {
	"index_no_limit",
	"index_skin",
	"index_reform_cw",
	"index_strengthen",
	"index_upgrade",
	"index_not_lvmax",
	"index_awakening",
	"index_awakening2",
	"index_special",
	"index_propose_skin"
}

if not LOCK_SP_WEAPON then
	var0_0.ExtraNames[11] = "index_spweapon"
end

table.insert(var0_0.ExtraNames, "index_dressed")
table.insert(var0_0.ExtraNames, "index_marry")

function var0_0.filterByExtra(arg0_28, arg1_28)
	if not arg1_28 or arg1_28 == var0_0.ExtraAll then
		return true
	end

	if arg1_28 == var0_0.ExtraSkin then
		return arg0_28:hasAvailiableSkin()
	elseif arg1_28 == var0_0.ExtraRemould then
		return arg0_28:isRemouldable() and not arg0_28:isAllRemouldFinish()
	elseif arg1_28 == var0_0.Extrastrengthen then
		return not arg0_28:isMetaShip() and not arg0_28:isIntensifyMax()
	elseif arg1_28 == var0_0.ExtraUpgrade then
		return arg0_28:canUpgrade()
	elseif arg1_28 == var0_0.ExtraNotMaxLv then
		return arg0_28:notMaxLevelForFilter()
	elseif arg1_28 == var0_0.ExtraAwakening then
		return arg0_28:isAwakening()
	elseif arg1_28 == var0_0.ExtraAwakening2 then
		return arg0_28:isAwakening2()
	elseif arg1_28 == var0_0.ExtraSpecial then
		return arg0_28:isSpecialFilter()
	elseif arg1_28 == var0_0.ExtraProposeSkin then
		return arg0_28:hasProposeSkin()
	elseif arg1_28 == var0_0.ExtraUniqueSpWeapon then
		return arg0_28:HasUniqueSpWeapon()
	elseif arg1_28 == var0_0.DRESSED then
		return not arg0_28:IsDefaultSkin() and arg0_28:getRemouldSkinId() ~= arg0_28.skinId
	elseif arg1_28 == var0_0.ExtraMarry then
		return arg0_28.propose
	end

	return false
end

var0_0.CollExtraSpecial = bit.lshift(1, 0)
var0_0.CollExtraNotObtained = bit.lshift(1, 1)
var0_0.CollExtraIndexs = {
	var0_0.CollExtraSpecial,
	var0_0.CollExtraNotObtained
}
var0_0.CollExtraAll = IndexConst.BitAll(var0_0.CollExtraIndexs)

table.insert(var0_0.CollExtraIndexs, 1, var0_0.CollExtraAll)

var0_0.CollExtraNames = {
	"index_no_limit",
	"index_special",
	"index_not_obtained"
}

function var0_0.filterByCollExtra(arg0_29, arg1_29)
	if not arg1_29 or arg1_29 == var0_0.CollExtraAll then
		return true
	end

	if arg1_29 == var0_0.CollExtraSpecial then
		return arg0_29:isSpecialFilter()
	end

	if arg1_29 == var0_0.CollExtraNotObtained then
		local var0_29 = arg0_29:getGroupId()
		local var1_29 = arg0_29:isRemoulded()
		local var2_29 = getProxy(CollectionProxy):getShipGroup(var0_29)

		if ShipGroup.getState(var0_29, var2_29, var1_29) ~= ShipGroup.STATE_UNLOCK then
			return true
		end
	end

	return false
end

return var0_0
