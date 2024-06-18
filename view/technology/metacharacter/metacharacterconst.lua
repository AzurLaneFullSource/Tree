MetaCharacterConst = {}

local var0_0 = MetaCharacterConst

var0_0.Meta_Type_Act_PT = 1
var0_0.Meta_Type_Build = 2
var0_0.Meta_Type_Pass = 3
var0_0.REPAIR_ATTRS = {
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.Air,
	AttributeType.Reload
}
var0_0.ENERGY_ATTRS = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.AntiSub,
	AttributeType.Expend
}
var0_0.UIConfig = {}

setmetatable(var0_0.UIConfig, {
	__index = function(arg0_1, arg1_1)
		local var0_1 = pg.ship_strengthen_meta[arg1_1].uiconfig

		if var0_1 then
			return var0_1
		else
			return var0_0.UIConfig[970701]
		end
	end
})

var0_0.META_ART_RESOURCE_PERFIX = "metaship/"
var0_0.META_ACTIVE_LASTFIX = "_active"
var0_0.META_DISACTIVE_LASTFIX = "_disactive"
var0_0.META_BANNER_PERFIX = "banner_"
var0_0.META_NAME_PERFIX = "name_"
var0_0.META_TOAST_PERFIX = "toast_"
var0_0.HX_TAG = "_hx"

function var0_0.GetMetaCharacterPaintPath(arg0_2, arg1_2)
	if not HXSet.isHx() then
		if arg1_2 == true then
			local var0_2 = arg0_2 .. var0_0.META_ACTIVE_LASTFIX

			return var0_0.META_ART_RESOURCE_PERFIX .. var0_2, var0_2
		else
			local var1_2 = arg0_2 .. var0_0.META_DISACTIVE_LASTFIX

			return var0_0.META_ART_RESOURCE_PERFIX .. var1_2, var1_2
		end
	elseif arg1_2 == true then
		local var2_2 = arg0_2 .. var0_0.META_ACTIVE_LASTFIX .. var0_0.HX_TAG
		local var3_2 = var0_0.META_ART_RESOURCE_PERFIX .. var2_2

		if not checkABExist(var3_2) then
			var2_2 = arg0_2 .. var0_0.META_ACTIVE_LASTFIX
			var3_2 = var0_0.META_ART_RESOURCE_PERFIX .. var2_2
		end

		return var3_2, var2_2
	else
		local var4_2 = arg0_2 .. var0_0.META_DISACTIVE_LASTFIX .. var0_0.HX_TAG
		local var5_2 = var0_0.META_ART_RESOURCE_PERFIX .. var4_2

		if not checkABExist(var5_2) then
			var4_2 = arg0_2 .. var0_0.META_DISACTIVE_LASTFIX
			var5_2 = var0_0.META_ART_RESOURCE_PERFIX .. var4_2
		end

		return var5_2, var4_2
	end
end

function var0_0.GetMetaCharacterBannerPath(arg0_3)
	local var0_3 = var0_0.META_BANNER_PERFIX .. arg0_3

	return var0_0.META_ART_RESOURCE_PERFIX .. var0_3, var0_3
end

function var0_0.GetMetaCharacterNamePath(arg0_4)
	local var0_4 = var0_0.META_NAME_PERFIX .. arg0_4

	return var0_0.META_ART_RESOURCE_PERFIX .. var0_4, var0_4
end

function var0_0.GetMetaCharacterToastPath(arg0_5)
	local var0_5 = var0_0.META_TOAST_PERFIX .. arg0_5

	return var0_0.META_ART_RESOURCE_PERFIX .. var0_5, var0_5
end

function var0_0.GetMetaShipGroupIDByConfigID(arg0_6)
	return math.floor(arg0_6 / 10)
end

function var0_0.isMetaRepairRedTag(arg0_7)
	if not arg0_7 then
		return false
	end

	local var0_7 = getProxy(BayProxy):getMetaShipByGroupId(arg0_7)

	if not var0_7 then
		return false
	end

	local var1_7 = var0_7:getMetaCharacter()

	if not var1_7 then
		return false
	end

	local var2_7 = false

	for iter0_7, iter1_7 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		var2_7 = var1_7:getAttrVO(iter1_7):isCanRepair()

		if var2_7 == true then
			break
		end
	end

	return var2_7
end

function var0_0.isMetaEnergyRedTag(arg0_8)
	if not arg0_8 then
		return false
	end

	local var0_8 = getProxy(BayProxy):getMetaShipByGroupId(arg0_8)

	if not var0_8 then
		return false
	end

	local var1_8 = var0_8:getMetaCharacter()

	if not var1_8 then
		return false
	end

	local var2_8 = true
	local var3_8 = var1_8:getBreakOutInfo()

	if not var3_8:hasNextInfo() then
		var2_8 = false
	end

	local var4_8, var5_8 = var3_8:getLimited()

	if var4_8 > var0_8.level or var5_8 > var1_8:getCurRepairExp() then
		var2_8 = false
	end

	local var6_8, var7_8 = var3_8:getConsume()
	local var8_8
	local var9_8
	local var10_8
	local var11_8 = var7_8[1].itemId

	if var7_8[1].count > getProxy(BagProxy):getItemCountById(var11_8) then
		var2_8 = false
	end

	if var6_8 > getProxy(PlayerProxy):getData().gold then
		var2_8 = false
	end

	return var2_8
end

function var0_0.isMetaTacticsRedTag(arg0_9)
	return getProxy(MetaCharacterProxy):getRedTag(arg0_9)
end

function var0_0.isMetaSynRedTag(arg0_10)
	if not arg0_10 then
		return false
	end

	local var0_10 = getProxy(BayProxy):getMetaShipByGroupId(arg0_10)

	if not var0_10 then
		return false
	end

	if not var0_10:getMetaCharacter() then
		return false
	end

	local var1_10 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_10)

	if var1_10:isPassType() or var1_10:isBuildType() then
		return false
	end

	if not var1_10:isShow() then
		return false
	end

	local var2_10 = false

	if var1_10.metaPtData then
		var2_10 = var1_10.metaPtData:CanGetAward()
	end

	return var2_10
end

function var0_0.isMetaMainSceneRedTag(arg0_11)
	if not arg0_11 then
		return false
	end

	if getProxy(BayProxy):getMetaShipByGroupId(arg0_11) then
		return false
	end

	local var0_11 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_11)

	if var0_11:isPassType() or var0_11:isBuildType() then
		return false
	end

	if not var0_11:isShow() then
		return false
	end

	local var1_11 = var0_11:getMetaProgressPTState()

	if var1_11 == MetaProgress.STATE_CAN_FINISH or var1_11 == MetaProgress.STATE_CAN_AWARD then
		return true
	end
end

function var0_0.isMetaMainEntRedPoint()
	local var0_12 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0_12, iter1_12 in ipairs(var0_12) do
		if (var0_0.isMetaMainSceneRedTag(iter1_12.id) or var0_0.isMetaSynRedTag(iter1_12.id)) == true then
			return true
		end
	end

	return false
end

function var0_0.isMetaBannerRedPoint(arg0_13)
	local var0_13 = var0_0.isMetaTacticsRedTag(arg0_13) or var0_0.isMetaSynRedTag(arg0_13)
	local var1_13 = getProxy(BayProxy):getMetaShipByGroupId(arg0_13)

	if var1_13 then
		local var2_13 = getProxy(MetaCharacterProxy):getMetaTacticsInfoByShipID(var1_13.id):getTacticsStateForShow() == MetaTacticsInfo.States.LearnAble

		var0_13 = var0_13 or var2_13
	else
		local var3_13 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_13)

		if var3_13:isPtType() then
			var0_13 = var0_13 or var3_13.metaPtData:CanGetAward()
		end
	end

	return var0_13
end

function var0_0.getFinalSkillIDListByMetaGroupID(arg0_14)
	local var0_14

	for iter0_14 = 1, 4 do
		local var1_14 = arg0_14 * 10 + iter0_14

		if pg.ship_data_template[var1_14] then
			var0_14 = var1_14
		end

		break
	end

	local var2_14 = {}

	for iter1_14, iter2_14 in ipairs(pg.ship_data_template[var0_14].buff_list_display) do
		table.insert(var2_14, iter2_14)
	end

	return var2_14
end

function var0_0.getTacticsSkillIDListByShipConfigID(arg0_15)
	local var0_15 = {}
	local var1_15 = pg.ship_data_template[arg0_15].buff_list_display

	for iter0_15, iter1_15 in ipairs(var1_15) do
		if MetaCharacterConst.isMetaTaskSkillID(iter1_15) then
			table.insert(var0_15, iter1_15)
		end
	end

	return var0_15
end

function var0_0.getMetaSkillTacticsConfig(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(pg.ship_meta_skilltask.all) do
		local var0_16 = pg.ship_meta_skilltask[iter1_16]

		if var0_16.skill_ID == arg0_16 and var0_16.level == arg1_16 then
			return var0_16
		end
	end
end

function var0_0.addReMetaTransItem(arg0_17, arg1_17)
	if not arg0_17.virgin and arg0_17:isMetaShip() and Player.isMetaShipNeedToTrans(arg0_17.configId) then
		local var0_17 = Player.metaShip2Res(arg0_17.configId)

		if not arg1_17 then
			for iter0_17, iter1_17 in ipairs(var0_17) do
				local var1_17 = iter1_17.type
				local var2_17 = iter1_17.id
				local var3_17 = iter1_17.count
				local var4_17 = Drop.New({
					type = var1_17,
					id = var2_17,
					count = var3_17
				})

				pg.m02:sendNotification(GAME.ADD_ITEM, var4_17)
			end
		end

		local var5_17 = var0_17[1].type
		local var6_17 = var0_17[1].id
		local var7_17 = var0_17[1].count

		return (Drop.New({
			type = var5_17,
			id = var6_17,
			count = var7_17
		}))
	end
end

function var0_0.isMetaTaskSkillID(arg0_18)
	for iter0_18, iter1_18 in ipairs(pg.ship_meta_skilltask.all) do
		if pg.ship_meta_skilltask[iter1_18].skill_ID == arg0_18 then
			return true
		end
	end

	return false
end

function var0_0.isMetaInArchive(arg0_19)
	local var0_19 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0_19)

	if var0_19:isPtType() and var0_19:isInArchive() then
		return true
	else
		return false
	end
end

function var0_0.getRepairAbleMetaProgressVOList()
	local var0_20 = {}
	local var1_20 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0_20, iter1_20 in ipairs(var1_20) do
		local var2_20 = iter1_20.metaShipVO

		if var2_20 then
			local var3_20 = var2_20:getMetaCharacter()

			if var3_20 and var3_20:getRepairRate() < 1 then
				table.insert(var0_20, iter1_20)
			end
		end
	end

	return var0_20
end

function var0_0.getTacticsAbleMetaProgressVOList()
	local var0_21 = {}
	local var1_21 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0_21, iter1_21 in ipairs(var1_21) do
		local var2_21 = iter1_21.metaShipVO

		if var2_21 and not var2_21:isAllMetaSkillLevelMax() then
			table.insert(var0_21, iter1_21)
		end
	end

	return var0_21
end

function var0_0.getEnergyAbleMetaProgressVOList()
	local var0_22 = {}
	local var1_22 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0_22, iter1_22 in ipairs(var1_22) do
		local var2_22 = iter1_22.metaShipVO

		if var2_22 and not var2_22:isMaxStar() then
			table.insert(var0_22, iter1_22)
		end
	end

	return var0_22
end

function var0_0.filteMetaByType(arg0_23, arg1_23)
	if not arg1_23 or arg1_23 == ShipIndexConst.TypeAll then
		return true
	end

	local function var0_23(arg0_24)
		local var0_24

		for iter0_24 = 1, 4 do
			local var1_24 = arg0_24 * 10 + iter0_24

			if pg.ship_data_template[var1_24] then
				var0_24 = var1_24
			end

			break
		end

		return pg.ship_data_statistics[var0_24].type
	end

	local function var1_23(arg0_25)
		return TeamType.GetTeamFromShipType(arg0_25)
	end

	for iter0_23 = 2, #ShipIndexCfg.type do
		local var2_23 = bit.lshift(1, iter0_23 - 2)

		if bit.band(var2_23, arg1_23) > 0 then
			if iter0_23 < 4 then
				local var3_23 = var0_23(arg0_23.id)
				local var4_23 = var1_23(var3_23)
				local var5_23 = ShipIndexCfg.type[iter0_23].shipTypes
				local var6_23 = ShipIndexCfg.type[iter0_23].types

				if table.contains(var5_23, var3_23) then
					return true
				end

				if table.contains(var6_23, var4_23) then
					return true
				end
			else
				local var7_23 = var0_23(arg0_23.id)
				local var8_23 = ShipIndexCfg.type[iter0_23].types

				if table.contains(var8_23, var7_23) then
					return true
				end
			end
		end
	end

	return false
end

function var0_0.filteMetaByRarity(arg0_26, arg1_26)
	if not arg1_26 or arg1_26 == ShipIndexConst.RarityAll then
		return true
	end

	local function var0_26(arg0_27)
		local var0_27

		for iter0_27 = 1, 4 do
			local var1_27 = arg0_27 * 10 + iter0_27

			if pg.ship_data_template[var1_27] then
				var0_27 = var1_27
			end

			break
		end

		return pg.ship_data_statistics[var0_27].rarity
	end

	for iter0_26 = 2, #ShipIndexCfg.rarity do
		local var1_26 = bit.lshift(1, iter0_26 - 2)

		if bit.band(var1_26, arg1_26) > 0 then
			local var2_26 = ShipIndexCfg.rarity[iter0_26].types

			if table.contains(var2_26, var0_26(arg0_26.id)) then
				return true
			end
		end
	end

	return false
end

function var0_0.filteMetaExtra(arg0_28, arg1_28)
	if not arg1_28 or arg1_28 == ShipIndexConst.MetaExtraAll then
		return true
	end

	if ShipIndexConst.MetaExtraRepair == arg1_28 then
		return var0_0.filteMetaRepairAble(arg0_28)
	elseif ShipIndexConst.MetaExtraTactics == arg1_28 then
		return var0_0.filteMetaTacticsAble(arg0_28)
	elseif ShipIndexConst.MetaExtraEnergy == arg1_28 then
		return var0_0.filteMetaEnergyAble(arg0_28)
	else
		return false
	end
end

function var0_0.filteMetaRepairAble(arg0_29)
	local var0_29 = arg0_29.metaShipVO

	if var0_29 then
		local var1_29 = var0_29:getMetaCharacter()

		if var1_29 and var1_29:getRepairRate() < 1 then
			return true
		end
	end

	return false
end

function var0_0.filteMetaTacticsAble(arg0_30)
	local var0_30 = arg0_30.metaShipVO

	if var0_30 and not var0_30:isAllMetaSkillLevelMax() then
		return true
	end

	return false
end

function var0_0.filteMetaEnergyAble(arg0_31)
	local var0_31 = arg0_31.metaShipVO

	if var0_31 and not var0_31:isMaxStar() then
		return true
	end

	return false
end

function var0_0.filteMetaSynAble(arg0_32)
	if arg0_32:isPtType() then
		return not arg0_32:IsGotAllAwards()
	else
		return false
	end
end

return var0_0
