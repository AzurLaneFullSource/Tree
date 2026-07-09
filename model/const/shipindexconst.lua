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
var0_0.RoleProgressBar = {
	var0_0.SortUnlockable,
	var0_0.SortGotLock,
	var0_0.SortNotGet
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
var0_0.SortDefault = bit.lshift(1, 0)
var0_0.SortProgressBar = bit.lshift(1, 1)
var0_0.SortRoleStory = {
	var0_0.SortDefault,
	var0_0.SortProgressBar
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

function var0_0.getSortName(arg0_4)
	for iter0_4 = 1, #ShipIndexConst.SortRoleStory do
		local var0_4 = bit.lshift(1, iter0_4 - 1)

		if bit.band(var0_4, arg0_4) > 0 then
			return iter0_4
		end
	end
end

var0_0.SortRoleStoryName = {
	"memory_filter_option_1",
	"memory_filter_option_2"
}
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
		function(arg0_6)
			return -arg0_6:getShipCombatPower()
		end,
		function(arg0_7)
			return arg0_7.configId
		end
	}
end

function var0_0.sortByField(arg0_8)
	return {
		function(arg0_9)
			return -arg0_9[arg0_8]
		end,
		function(arg0_10)
			return -arg0_10:getRarity()
		end,
		function(arg0_11)
			return arg0_11.configId
		end
	}
end

function var0_0.sortByProperty(arg0_12)
	return {
		function(arg0_13)
			return -arg0_13:getShipProperties()[arg0_12]
		end,
		function(arg0_14)
			return arg0_14.configId
		end
	}
end

function var0_0.sortByCfg(arg0_15)
	return {
		function(arg0_16)
			return -(arg0_15 == "rarity" and arg0_16:getRarity() or arg0_16:getConfig(arg0_15))
		end,
		function(arg0_17)
			return arg0_17.configId
		end
	}
end

function var0_0.sortByIntimacy()
	return {
		function(arg0_19)
			return -arg0_19.intimacy
		end,
		function(arg0_20)
			return arg0_20.propose and 0 or 1
		end,
		function(arg0_21)
			return arg0_21.configId
		end,
		function(arg0_22)
			return -arg0_22.level
		end
	}
end

function var0_0.sortByEnergy()
	return {
		function(arg0_24)
			return -arg0_24:getEnergy()
		end,
		function(arg0_25)
			return arg0_25.configId
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

function var0_0.filterByType(arg0_26, arg1_26)
	if not arg1_26 or arg1_26 == var0_0.TypeAll then
		return true
	end

	for iter0_26 = 2, #ShipIndexCfg.type do
		local var0_26 = bit.lshift(1, iter0_26 - 2)

		if bit.band(var0_26, arg1_26) > 0 then
			local var1_26 = ShipIndexCfg.type[iter0_26].types

			if iter0_26 < 4 then
				local var2_26 = ShipIndexCfg.type[iter0_26].shipTypes

				if table.contains(var1_26, arg0_26:getShipType()) then
					return true
				end

				if table.contains(var1_26, arg0_26:getTeamType()) then
					return true
				end
			elseif table.contains(var1_26, arg0_26:getShipType()) then
				return true
			end
		end
	end

	return false
end

var0_0.SortUnlockable = bit.lshift(1, 0)
var0_0.SortGotLock = bit.lshift(1, 1)
var0_0.SortNotGet = bit.lshift(1, 2)
var0_0.RoleProgress = {
	var0_0.SortUnlockable,
	var0_0.SortGotLock,
	var0_0.SortNotGet
}
var0_0.All = IndexConst.BitAll(var0_0.RoleProgress)

table.insert(var0_0.RoleProgress, 1, var0_0.All)

var0_0.RoleProgressName = {
	"memory_filter_option_3",
	"memory_filter_option_4",
	"memory_filter_option_5",
	"memory_filter_option_6"
}

function var0_0.filterRoleProgressBar(arg0_27, arg1_27)
	if not arg1_27 or arg1_27 == var0_0.ProgressAll then
		return true
	end

	local var0_27 = getProxy(CollectionProxy):getShipGroup(arg0_27.ship_group)

	for iter0_27 = 2, #RoleIndexCfg.progress do
		local var1_27 = bit.lshift(1, iter0_27 - 2)

		if bit.band(var1_27, arg1_27) > 0 then
			local var2_27 = RoleIndexCfg.progress[iter0_27].types

			if #var2_27 == 0 then
				return true
			end

			for iter1_27, iter2_27 in ipairs(var2_27) do
				if iter2_27 == 1 then
					local var3_27 = pg.memory_template[arg0_27.memories[1]].story

					if var0_27 and not pg.NewStoryMgr.GetInstance():IsPlayed(var3_27) and arg0_27.id ~= 501 then
						return true
					end
				elseif iter2_27 == 2 then
					local var4_27 = pg.memory_template[arg0_27.memories[1]].story

					if pg.NewStoryMgr.GetInstance():IsPlayed(var4_27) then
						return true
					end
				elseif iter2_27 == 3 and not var0_27 then
					return true
				end
			end
		end
	end

	return false
end

local var1_0 = {
	"CampUS",
	"CampEN",
	"CampJP",
	"CampDE",
	"CampCN",
	"CampITA",
	"CampSN",
	"CampFF",
	"CampMNF",
	"CampNL",
	"CampLDP",
	"CampMETA",
	"CampMot",
	"CampOther"
}

if LOCK_NATION_HNLMS then
	table.removebyvalue(var1_0, "CampNL")
end

var0_0.CampIndexs = {}

for iter0_0, iter1_0 in ipairs(var1_0) do
	var0_0[iter1_0] = bit.lshift(1, iter0_0 - 1)

	table.insert(var0_0.CampIndexs, var0_0[iter1_0])
end

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
	"word_shipNation_yujinwangguo",
	"word_shipNation_jinghuanlianmeng",
	"word_shipNation_meta_index",
	"word_shipNation_mot",
	"word_shipNation_other"
}

if LOCK_NATION_HNLMS then
	table.removebyvalue(var0_0.CampNames, "word_shipNation_yujinwangguo")
end

function var0_0.filterByCamp(arg0_28, arg1_28)
	if not arg1_28 or arg1_28 == var0_0.CampAll then
		return true
	end

	local var0_28 = underscore.to_array(ShipIndexCfg.camp)

	if LOCK_NATION_HNLMS then
		var0_28 = underscore.filter(var0_28, function(arg0_29)
			return #arg0_29.types ~= 1 or arg0_29.types[1] ~= Nation.NL
		end)
	end

	for iter0_28 = 2, #var0_28 do
		local var1_28 = bit.lshift(1, iter0_28 - 2)

		if bit.band(var1_28, arg1_28) > 0 then
			local var2_28 = var0_28[iter0_28].types

			for iter1_28, iter2_28 in ipairs(var2_28) do
				if iter2_28 == Nation.LINK then
					if arg0_28:getNation() >= Nation.LINK then
						return true
					end
				elseif iter2_28 == arg0_28:getNation() then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.RolefilterByCamp(arg0_30, arg1_30)
	if not arg1_30 or arg1_30 == var0_0.CampAll then
		return true
	end

	local var0_30 = underscore.to_array(ShipIndexCfg.camp)

	if LOCK_NATION_HNLMS then
		var0_30 = underscore.filter(var0_30, function(arg0_31)
			return #arg0_31.types ~= 1 or arg0_31.types[1] ~= Nation.NL
		end)
	end

	for iter0_30 = 2, #var0_30 do
		local var1_30 = bit.lshift(1, iter0_30 - 2)

		if bit.band(var1_30, arg1_30) > 0 then
			local var2_30 = var0_30[iter0_30].types

			for iter1_30, iter2_30 in ipairs(var2_30) do
				if iter2_30 == Nation.LINK then
					if arg0_30.nationality >= Nation.LINK then
						return true
					end
				elseif iter2_30 == arg0_30.nationality then
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

function var0_0.filterByRarity(arg0_32, arg1_32)
	if not arg1_32 or arg1_32 == var0_0.RarityAll then
		return true
	end

	for iter0_32 = 2, #ShipIndexCfg.rarity do
		local var0_32 = bit.lshift(1, iter0_32 - 2)

		if bit.band(var0_32, arg1_32) > 0 then
			local var1_32 = ShipIndexCfg.rarity[iter0_32].types

			if table.contains(var1_32, arg0_32:getRarity()) then
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

function var0_0.filterByExtra(arg0_33, arg1_33)
	if not arg1_33 or arg1_33 == var0_0.ExtraAll then
		return true
	end

	if arg1_33 == var0_0.ExtraSkin then
		return arg0_33:hasAvailiableSkin()
	elseif arg1_33 == var0_0.ExtraRemould then
		return arg0_33:isRemouldable() and not arg0_33:isAllRemouldFinish()
	elseif arg1_33 == var0_0.Extrastrengthen then
		return not arg0_33:isMetaShip() and not arg0_33:isIntensifyMax()
	elseif arg1_33 == var0_0.ExtraUpgrade then
		return arg0_33:canUpgrade()
	elseif arg1_33 == var0_0.ExtraNotMaxLv then
		return arg0_33:notMaxLevelForFilter()
	elseif arg1_33 == var0_0.ExtraAwakening then
		return arg0_33:isAwakening()
	elseif arg1_33 == var0_0.ExtraAwakening2 then
		return arg0_33:isAwakening2()
	elseif arg1_33 == var0_0.ExtraSpecial then
		return arg0_33:isSpecialFilter()
	elseif arg1_33 == var0_0.ExtraProposeSkin then
		return arg0_33:hasProposeSkin()
	elseif arg1_33 == var0_0.ExtraUniqueSpWeapon then
		return arg0_33:HasUniqueSpWeapon()
	elseif arg1_33 == var0_0.DRESSED then
		return not arg0_33:IsDefaultSkin() and arg0_33:getRemouldSkinId() ~= arg0_33:getSkinId()
	elseif arg1_33 == var0_0.ExtraMarry then
		return arg0_33.propose
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

function var0_0.filterByCollExtra(arg0_34, arg1_34)
	if not arg1_34 or arg1_34 == var0_0.CollExtraAll then
		return true
	end

	if arg1_34 == var0_0.CollExtraSpecial then
		return arg0_34:isSpecialFilter()
	end

	if arg1_34 == var0_0.CollExtraNotObtained then
		local var0_34 = arg0_34:getGroupId()
		local var1_34 = arg0_34:isRemoulded()
		local var2_34 = getProxy(CollectionProxy):getShipGroup(var0_34)

		if ShipGroup.getState(var0_34, var2_34, var1_34) ~= ShipGroup.STATE_UNLOCK then
			return true
		end
	end

	return false
end

return var0_0
