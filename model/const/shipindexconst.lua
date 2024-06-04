local var0 = class("ShipIndexConst")

var0.SortRarity = bit.lshift(1, 0)
var0.SortLevel = bit.lshift(1, 1)
var0.SortPower = bit.lshift(1, 2)
var0.SortAchivedTime = bit.lshift(1, 3)
var0.SortIntimacy = bit.lshift(1, 4)
var0.SortEnergy = bit.lshift(1, 13)
var0.SortProperty_Cannon = bit.lshift(1, 5)
var0.SortProperty_Air = bit.lshift(1, 6)
var0.SortProperty_Dodge = bit.lshift(1, 7)
var0.SortProperty_AntiAircraft = bit.lshift(1, 8)
var0.SortProperty_Torpedo = bit.lshift(1, 9)
var0.SortProperty_Reload = bit.lshift(1, 10)
var0.SortProperty_Durability = bit.lshift(1, 11)
var0.SortProperty_Antisub = bit.lshift(1, 12)
var0.SortPropertyIndexs = {
	var0.SortProperty_Cannon,
	var0.SortProperty_Air,
	var0.SortProperty_Dodge,
	var0.SortProperty_AntiAircraft,
	var0.SortProperty_Torpedo,
	var0.SortProperty_Reload,
	var0.SortProperty_Durability,
	var0.SortProperty_Antisub
}
var0.SortPropertyAll = IndexConst.BitAll(var0.SortPropertyIndexs)

table.insert(var0.SortPropertyIndexs, 1, var0.SortPropertyAll)

var0.SortIndexs = {
	var0.SortRarity,
	var0.SortLevel,
	var0.SortPower,
	var0.SortAchivedTime,
	var0.SortIntimacy,
	var0.SortEnergy
}

function var0.getSortFuncAndName(arg0, arg1)
	for iter0 = 1, #ShipIndexCfg.sort do
		local var0 = bit.lshift(1, iter0 - 1)

		if bit.band(var0, arg0) > 0 then
			return underscore.map(ShipIndexCfg.sort[iter0].sortFuncs, function(arg0)
				return function(arg0)
					return (arg1 and -1 or 1) * arg0(arg0)
				end
			end), ShipIndexCfg.sort[iter0].name
		end
	end
end

var0.SortNames = {
	"word_rarity",
	"word_lv",
	"word_synthesize_power",
	"word_achieved_item",
	"attribute_intimacy",
	"sort_energy"
}
var0.SortPropertyNames = {
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

function var0.sortByCombatPower()
	return {
		function(arg0)
			return -arg0:getShipCombatPower()
		end,
		function(arg0)
			return arg0.configId
		end
	}
end

function var0.sortByField(arg0)
	return {
		function(arg0)
			return -arg0[arg0]
		end,
		function(arg0)
			return -arg0:getRarity()
		end,
		function(arg0)
			return arg0.configId
		end
	}
end

function var0.sortByProperty(arg0)
	return {
		function(arg0)
			return -arg0:getShipProperties()[arg0]
		end,
		function(arg0)
			return arg0.configId
		end
	}
end

function var0.sortByCfg(arg0)
	return {
		function(arg0)
			return -(arg0 == "rarity" and arg0:getRarity() or arg0:getConfig(arg0))
		end,
		function(arg0)
			return arg0.configId
		end
	}
end

function var0.sortByIntimacy()
	return {
		function(arg0)
			return -arg0.intimacy
		end,
		function(arg0)
			return arg0.propose and 0 or 1
		end,
		function(arg0)
			return arg0.configId
		end,
		function(arg0)
			return -arg0.level
		end
	}
end

function var0.sortByEnergy()
	return {
		function(arg0)
			return -arg0:getEnergy()
		end,
		function(arg0)
			return arg0.configId
		end
	}
end

var0.TypeFront = bit.lshift(1, 0)
var0.TypeBack = bit.lshift(1, 1)
var0.TypeQuZhu = bit.lshift(1, 2)
var0.TypeQingXun = bit.lshift(1, 3)
var0.TypeZhongXun = bit.lshift(1, 4)
var0.TypeZhanLie = bit.lshift(1, 5)
var0.TypeHangMu = bit.lshift(1, 6)
var0.TypeWeiXiu = bit.lshift(1, 7)
var0.TypeQianTing = bit.lshift(1, 8)
var0.TypeOther = bit.lshift(1, 9)
var0.TypeIndexs = {
	var0.TypeFront,
	var0.TypeBack,
	var0.TypeQuZhu,
	var0.TypeQingXun,
	var0.TypeZhongXun,
	var0.TypeZhanLie,
	var0.TypeHangMu,
	var0.TypeWeiXiu,
	var0.TypeQianTing,
	var0.TypeOther
}
var0.TypeAll = IndexConst.BitAll(var0.TypeIndexs)

table.insert(var0.TypeIndexs, 1, var0.TypeAll)

var0.TypeNames = {
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

function var0.filterByType(arg0, arg1)
	if not arg1 or arg1 == var0.TypeAll then
		return true
	end

	for iter0 = 2, #ShipIndexCfg.type do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = ShipIndexCfg.type[iter0].types

			if iter0 < 4 then
				local var2 = ShipIndexCfg.type[iter0].shipTypes

				if table.contains(var1, arg0:getShipType()) then
					return true
				end

				if table.contains(var1, arg0:getTeamType()) then
					return true
				end
			elseif table.contains(var1, arg0:getShipType()) then
				return true
			end
		end
	end

	return false
end

var0.CampUS = bit.lshift(1, 0)
var0.CampEN = bit.lshift(1, 1)
var0.CampJP = bit.lshift(1, 2)
var0.CampDE = bit.lshift(1, 3)
var0.CampCN = bit.lshift(1, 4)
var0.CampITA = bit.lshift(1, 5)
var0.CampSN = bit.lshift(1, 6)
var0.CampFF = bit.lshift(1, 7)
var0.CampMNF = bit.lshift(1, 8)
var0.CampMETA = bit.lshift(1, 9)
var0.CampMot = bit.lshift(1, 10)
var0.CampOther = bit.lshift(1, 11)
var0.CampIndexs = {
	var0.CampUS,
	var0.CampEN,
	var0.CampJP,
	var0.CampDE,
	var0.CampCN,
	var0.CampITA,
	var0.CampSN,
	var0.CampFF,
	var0.CampMNF,
	var0.CampMETA,
	var0.CampMot,
	var0.CampOther
}
var0.CampAll = IndexConst.BitAll(var0.CampIndexs)

table.insert(var0.CampIndexs, 1, var0.CampAll)

var0.CampNames = {
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

function var0.filterByCamp(arg0, arg1)
	if not arg1 or arg1 == var0.CampAll then
		return true
	end

	for iter0 = 2, #ShipIndexCfg.camp do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = ShipIndexCfg.camp[iter0].types

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

var0.Rarity1 = bit.lshift(1, 0)
var0.Rarity2 = bit.lshift(1, 1)
var0.Rarity3 = bit.lshift(1, 2)
var0.Rarity4 = bit.lshift(1, 3)
var0.Rarity5 = bit.lshift(1, 4)
var0.RarityIndexs = {
	var0.Rarity1,
	var0.Rarity2,
	var0.Rarity3,
	var0.Rarity4,
	var0.Rarity5
}
var0.RarityAll = IndexConst.BitAll(var0.RarityIndexs)

table.insert(var0.RarityIndexs, 1, var0.RarityAll)

var0.RarityNames = {
	"index_all",
	"index_rare2",
	"index_rare3",
	"index_rare4",
	"index_rare5",
	"index_rare6"
}

function var0.filterByRarity(arg0, arg1)
	if not arg1 or arg1 == var0.RarityAll then
		return true
	end

	for iter0 = 2, #ShipIndexCfg.rarity do
		local var0 = bit.lshift(1, iter0 - 2)

		if bit.band(var0, arg1) > 0 then
			local var1 = ShipIndexCfg.rarity[iter0].types

			if table.contains(var1, arg0:getRarity()) then
				return true
			end
		end
	end

	return false
end

var0.MetaRarityIndexs = {
	var0.RarityAll,
	var0.Rarity3,
	var0.Rarity4
}
var0.MetaRarityNames = {
	"index_all",
	"index_rare4",
	"index_rare5"
}
var0.MetaExtraRepair = bit.lshift(1, 0)
var0.MetaExtraTactics = bit.lshift(1, 1)
var0.MetaExtraEnergy = bit.lshift(1, 2)
var0.MetaExtraIndexs = {
	var0.MetaExtraRepair,
	var0.MetaExtraTactics,
	var0.MetaExtraEnergy
}
var0.MetaExtraAll = IndexConst.BitAll(var0.MetaExtraIndexs)

table.insert(var0.MetaExtraIndexs, 1, var0.MetaExtraAll)

var0.MetaExtraNames = {
	"index_no_limit",
	"index_meta_repair",
	"index_meta_tactics",
	"index_meta_energy"
}
var0.ExtraSkin = bit.lshift(1, 0)
var0.ExtraRemould = bit.lshift(1, 1)
var0.Extrastrengthen = bit.lshift(1, 2)
var0.ExtraUpgrade = bit.lshift(1, 3)
var0.ExtraNotMaxLv = bit.lshift(1, 4)
var0.ExtraAwakening = bit.lshift(1, 5)
var0.ExtraAwakening2 = bit.lshift(1, 6)
var0.ExtraSpecial = bit.lshift(1, 7)
var0.ExtraProposeSkin = bit.lshift(1, 8)

if not LOCK_SP_WEAPON then
	var0.ExtraUniqueSpWeapon = bit.lshift(1, 9)
	var0.DRESSED = bit.lshift(1, 10)
	var0.ExtraMarry = bit.lshift(1, 11)
else
	var0.DRESSED = bit.lshift(1, 9)
	var0.ExtraMarry = bit.lshift(1, 10)
end

var0.ExtraIndexs = {
	var0.ExtraSkin,
	var0.ExtraRemould,
	var0.Extrastrengthen,
	var0.ExtraUpgrade,
	var0.ExtraNotMaxLv,
	var0.ExtraAwakening,
	var0.ExtraAwakening2,
	var0.ExtraSpecial,
	var0.ExtraProposeSkin
}

if not LOCK_SP_WEAPON then
	table.insert(var0.ExtraIndexs, var0.ExtraUniqueSpWeapon)
end

table.insert(var0.ExtraIndexs, var0.DRESSED)
table.insert(var0.ExtraIndexs, var0.ExtraMarry)

var0.ExtraAll = IndexConst.BitAll(var0.ExtraIndexs)

table.insert(var0.ExtraIndexs, 1, var0.ExtraAll)

var0.ExtraNames = {
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
	var0.ExtraNames[11] = "index_spweapon"
end

table.insert(var0.ExtraNames, "index_dressed")
table.insert(var0.ExtraNames, "index_marry")

function var0.filterByExtra(arg0, arg1)
	if not arg1 or arg1 == var0.ExtraAll then
		return true
	end

	if arg1 == var0.ExtraSkin then
		return arg0:hasAvailiableSkin()
	elseif arg1 == var0.ExtraRemould then
		return arg0:isRemouldable() and not arg0:isAllRemouldFinish()
	elseif arg1 == var0.Extrastrengthen then
		return not arg0:isMetaShip() and not arg0:isIntensifyMax()
	elseif arg1 == var0.ExtraUpgrade then
		return arg0:canUpgrade()
	elseif arg1 == var0.ExtraNotMaxLv then
		return arg0:notMaxLevelForFilter()
	elseif arg1 == var0.ExtraAwakening then
		return arg0:isAwakening()
	elseif arg1 == var0.ExtraAwakening2 then
		return arg0:isAwakening2()
	elseif arg1 == var0.ExtraSpecial then
		return arg0:isSpecialFilter()
	elseif arg1 == var0.ExtraProposeSkin then
		return arg0:hasProposeSkin()
	elseif arg1 == var0.ExtraUniqueSpWeapon then
		return arg0:HasUniqueSpWeapon()
	elseif arg1 == var0.DRESSED then
		return not arg0:IsDefaultSkin() and arg0:getRemouldSkinId() ~= arg0.skinId
	elseif arg1 == var0.ExtraMarry then
		return arg0.propose
	end

	return false
end

var0.CollExtraSpecial = bit.lshift(1, 0)
var0.CollExtraNotObtained = bit.lshift(1, 1)
var0.CollExtraIndexs = {
	var0.CollExtraSpecial,
	var0.CollExtraNotObtained
}
var0.CollExtraAll = IndexConst.BitAll(var0.CollExtraIndexs)

table.insert(var0.CollExtraIndexs, 1, var0.CollExtraAll)

var0.CollExtraNames = {
	"index_no_limit",
	"index_special",
	"index_not_obtained"
}

function var0.filterByCollExtra(arg0, arg1)
	if not arg1 or arg1 == var0.CollExtraAll then
		return true
	end

	if arg1 == var0.CollExtraSpecial then
		return arg0:isSpecialFilter()
	end

	if arg1 == var0.CollExtraNotObtained then
		local var0 = arg0:getGroupId()
		local var1 = arg0:isRemoulded()
		local var2 = getProxy(CollectionProxy):getShipGroup(var0)

		if ShipGroup.getState(var0, var2, var1) ~= ShipGroup.STATE_UNLOCK then
			return true
		end
	end

	return false
end

return var0
