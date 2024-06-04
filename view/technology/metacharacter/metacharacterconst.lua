MetaCharacterConst = {}

local var0 = MetaCharacterConst

var0.Meta_Type_Act_PT = 1
var0.Meta_Type_Build = 2
var0.Meta_Type_Pass = 3
var0.REPAIR_ATTRS = {
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.Air,
	AttributeType.Reload
}
var0.ENERGY_ATTRS = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.AntiSub,
	AttributeType.Expend
}
var0.UIConfig = {}

setmetatable(var0.UIConfig, {
	__index = function(arg0, arg1)
		local var0 = pg.ship_strengthen_meta[arg1].uiconfig

		if var0 then
			return var0
		else
			return var0.UIConfig[970701]
		end
	end
})

var0.META_ART_RESOURCE_PERFIX = "metaship/"
var0.META_ACTIVE_LASTFIX = "_active"
var0.META_DISACTIVE_LASTFIX = "_disactive"
var0.META_BANNER_PERFIX = "banner_"
var0.META_NAME_PERFIX = "name_"
var0.META_TOAST_PERFIX = "toast_"
var0.HX_TAG = "_hx"

function var0.GetMetaCharacterPaintPath(arg0, arg1)
	if not HXSet.isHx() then
		if arg1 == true then
			local var0 = arg0 .. var0.META_ACTIVE_LASTFIX

			return var0.META_ART_RESOURCE_PERFIX .. var0, var0
		else
			local var1 = arg0 .. var0.META_DISACTIVE_LASTFIX

			return var0.META_ART_RESOURCE_PERFIX .. var1, var1
		end
	elseif arg1 == true then
		local var2 = arg0 .. var0.META_ACTIVE_LASTFIX .. var0.HX_TAG
		local var3 = var0.META_ART_RESOURCE_PERFIX .. var2

		if not checkABExist(var3) then
			var2 = arg0 .. var0.META_ACTIVE_LASTFIX
			var3 = var0.META_ART_RESOURCE_PERFIX .. var2
		end

		return var3, var2
	else
		local var4 = arg0 .. var0.META_DISACTIVE_LASTFIX .. var0.HX_TAG
		local var5 = var0.META_ART_RESOURCE_PERFIX .. var4

		if not checkABExist(var5) then
			var4 = arg0 .. var0.META_DISACTIVE_LASTFIX
			var5 = var0.META_ART_RESOURCE_PERFIX .. var4
		end

		return var5, var4
	end
end

function var0.GetMetaCharacterBannerPath(arg0)
	local var0 = var0.META_BANNER_PERFIX .. arg0

	return var0.META_ART_RESOURCE_PERFIX .. var0, var0
end

function var0.GetMetaCharacterNamePath(arg0)
	local var0 = var0.META_NAME_PERFIX .. arg0

	return var0.META_ART_RESOURCE_PERFIX .. var0, var0
end

function var0.GetMetaCharacterToastPath(arg0)
	local var0 = var0.META_TOAST_PERFIX .. arg0

	return var0.META_ART_RESOURCE_PERFIX .. var0, var0
end

function var0.GetMetaShipGroupIDByConfigID(arg0)
	return math.floor(arg0 / 10)
end

function var0.isMetaRepairRedTag(arg0)
	if not arg0 then
		return false
	end

	local var0 = getProxy(BayProxy):getMetaShipByGroupId(arg0)

	if not var0 then
		return false
	end

	local var1 = var0:getMetaCharacter()

	if not var1 then
		return false
	end

	local var2 = false

	for iter0, iter1 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		var2 = var1:getAttrVO(iter1):isCanRepair()

		if var2 == true then
			break
		end
	end

	return var2
end

function var0.isMetaEnergyRedTag(arg0)
	if not arg0 then
		return false
	end

	local var0 = getProxy(BayProxy):getMetaShipByGroupId(arg0)

	if not var0 then
		return false
	end

	local var1 = var0:getMetaCharacter()

	if not var1 then
		return false
	end

	local var2 = true
	local var3 = var1:getBreakOutInfo()

	if not var3:hasNextInfo() then
		var2 = false
	end

	local var4, var5 = var3:getLimited()

	if var4 > var0.level or var5 > var1:getCurRepairExp() then
		var2 = false
	end

	local var6, var7 = var3:getConsume()
	local var8
	local var9
	local var10
	local var11 = var7[1].itemId

	if var7[1].count > getProxy(BagProxy):getItemCountById(var11) then
		var2 = false
	end

	if var6 > getProxy(PlayerProxy):getData().gold then
		var2 = false
	end

	return var2
end

function var0.isMetaTacticsRedTag(arg0)
	return getProxy(MetaCharacterProxy):getRedTag(arg0)
end

function var0.isMetaSynRedTag(arg0)
	if not arg0 then
		return false
	end

	local var0 = getProxy(BayProxy):getMetaShipByGroupId(arg0)

	if not var0 then
		return false
	end

	if not var0:getMetaCharacter() then
		return false
	end

	local var1 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0)

	if var1:isPassType() or var1:isBuildType() then
		return false
	end

	if not var1:isShow() then
		return false
	end

	local var2 = false

	if var1.metaPtData then
		var2 = var1.metaPtData:CanGetAward()
	end

	return var2
end

function var0.isMetaMainSceneRedTag(arg0)
	if not arg0 then
		return false
	end

	if getProxy(BayProxy):getMetaShipByGroupId(arg0) then
		return false
	end

	local var0 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0)

	if var0:isPassType() or var0:isBuildType() then
		return false
	end

	if not var0:isShow() then
		return false
	end

	local var1 = var0:getMetaProgressPTState()

	if var1 == MetaProgress.STATE_CAN_FINISH or var1 == MetaProgress.STATE_CAN_AWARD then
		return true
	end
end

function var0.isMetaMainEntRedPoint()
	local var0 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0, iter1 in ipairs(var0) do
		if (var0.isMetaMainSceneRedTag(iter1.id) or var0.isMetaSynRedTag(iter1.id)) == true then
			return true
		end
	end

	return false
end

function var0.isMetaBannerRedPoint(arg0)
	local var0 = var0.isMetaTacticsRedTag(arg0) or var0.isMetaSynRedTag(arg0)
	local var1 = getProxy(BayProxy):getMetaShipByGroupId(arg0)

	if var1 then
		local var2 = getProxy(MetaCharacterProxy):getMetaTacticsInfoByShipID(var1.id):getTacticsStateForShow() == MetaTacticsInfo.States.LearnAble

		var0 = var0 or var2
	else
		local var3 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0)

		if var3:isPtType() then
			var0 = var0 or var3.metaPtData:CanGetAward()
		end
	end

	return var0
end

function var0.getFinalSkillIDListByMetaGroupID(arg0)
	local var0

	for iter0 = 1, 4 do
		local var1 = arg0 * 10 + iter0

		if pg.ship_data_template[var1] then
			var0 = var1
		end

		break
	end

	local var2 = {}

	for iter1, iter2 in ipairs(pg.ship_data_template[var0].buff_list_display) do
		table.insert(var2, iter2)
	end

	return var2
end

function var0.getTacticsSkillIDListByShipConfigID(arg0)
	local var0 = {}
	local var1 = pg.ship_data_template[arg0].buff_list_display

	for iter0, iter1 in ipairs(var1) do
		if MetaCharacterConst.isMetaTaskSkillID(iter1) then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getMetaSkillTacticsConfig(arg0, arg1)
	for iter0, iter1 in ipairs(pg.ship_meta_skilltask.all) do
		local var0 = pg.ship_meta_skilltask[iter1]

		if var0.skill_ID == arg0 and var0.level == arg1 then
			return var0
		end
	end
end

function var0.addReMetaTransItem(arg0, arg1)
	if not arg0.virgin and arg0:isMetaShip() and Player.isMetaShipNeedToTrans(arg0.configId) then
		local var0 = Player.metaShip2Res(arg0.configId)

		if not arg1 then
			for iter0, iter1 in ipairs(var0) do
				local var1 = iter1.type
				local var2 = iter1.id
				local var3 = iter1.count
				local var4 = Drop.New({
					type = var1,
					id = var2,
					count = var3
				})

				pg.m02:sendNotification(GAME.ADD_ITEM, var4)
			end
		end

		local var5 = var0[1].type
		local var6 = var0[1].id
		local var7 = var0[1].count

		return (Drop.New({
			type = var5,
			id = var6,
			count = var7
		}))
	end
end

function var0.isMetaTaskSkillID(arg0)
	for iter0, iter1 in ipairs(pg.ship_meta_skilltask.all) do
		if pg.ship_meta_skilltask[iter1].skill_ID == arg0 then
			return true
		end
	end

	return false
end

function var0.isMetaInArchive(arg0)
	local var0 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(arg0)

	if var0:isPtType() and var0:isInArchive() then
		return true
	else
		return false
	end
end

function var0.getRepairAbleMetaProgressVOList()
	local var0 = {}
	local var1 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1.metaShipVO

		if var2 then
			local var3 = var2:getMetaCharacter()

			if var3 and var3:getRepairRate() < 1 then
				table.insert(var0, iter1)
			end
		end
	end

	return var0
end

function var0.getTacticsAbleMetaProgressVOList()
	local var0 = {}
	local var1 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1.metaShipVO

		if var2 and not var2:isAllMetaSkillLevelMax() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getEnergyAbleMetaProgressVOList()
	local var0 = {}
	local var1 = getProxy(MetaCharacterProxy):getMetaProgressVOList()

	for iter0, iter1 in ipairs(var1) do
		local var2 = iter1.metaShipVO

		if var2 and not var2:isMaxStar() then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.filteMetaByType(arg0, arg1)
	if not arg1 or arg1 == ShipIndexConst.TypeAll then
		return true
	end

	local function var0(arg0)
		local var0

		for iter0 = 1, 4 do
			local var1 = arg0 * 10 + iter0

			if pg.ship_data_template[var1] then
				var0 = var1
			end

			break
		end

		return pg.ship_data_statistics[var0].type
	end

	local function var1(arg0)
		return TeamType.GetTeamFromShipType(arg0)
	end

	for iter0 = 2, #ShipIndexCfg.type do
		local var2 = bit.lshift(1, iter0 - 2)

		if bit.band(var2, arg1) > 0 then
			if iter0 < 4 then
				local var3 = var0(arg0.id)
				local var4 = var1(var3)
				local var5 = ShipIndexCfg.type[iter0].shipTypes
				local var6 = ShipIndexCfg.type[iter0].types

				if table.contains(var5, var3) then
					return true
				end

				if table.contains(var6, var4) then
					return true
				end
			else
				local var7 = var0(arg0.id)
				local var8 = ShipIndexCfg.type[iter0].types

				if table.contains(var8, var7) then
					return true
				end
			end
		end
	end

	return false
end

function var0.filteMetaByRarity(arg0, arg1)
	if not arg1 or arg1 == ShipIndexConst.RarityAll then
		return true
	end

	local function var0(arg0)
		local var0

		for iter0 = 1, 4 do
			local var1 = arg0 * 10 + iter0

			if pg.ship_data_template[var1] then
				var0 = var1
			end

			break
		end

		return pg.ship_data_statistics[var0].rarity
	end

	for iter0 = 2, #ShipIndexCfg.rarity do
		local var1 = bit.lshift(1, iter0 - 2)

		if bit.band(var1, arg1) > 0 then
			local var2 = ShipIndexCfg.rarity[iter0].types

			if table.contains(var2, var0(arg0.id)) then
				return true
			end
		end
	end

	return false
end

function var0.filteMetaExtra(arg0, arg1)
	if not arg1 or arg1 == ShipIndexConst.MetaExtraAll then
		return true
	end

	if ShipIndexConst.MetaExtraRepair == arg1 then
		return var0.filteMetaRepairAble(arg0)
	elseif ShipIndexConst.MetaExtraTactics == arg1 then
		return var0.filteMetaTacticsAble(arg0)
	elseif ShipIndexConst.MetaExtraEnergy == arg1 then
		return var0.filteMetaEnergyAble(arg0)
	else
		return false
	end
end

function var0.filteMetaRepairAble(arg0)
	local var0 = arg0.metaShipVO

	if var0 then
		local var1 = var0:getMetaCharacter()

		if var1 and var1:getRepairRate() < 1 then
			return true
		end
	end

	return false
end

function var0.filteMetaTacticsAble(arg0)
	local var0 = arg0.metaShipVO

	if var0 and not var0:isAllMetaSkillLevelMax() then
		return true
	end

	return false
end

function var0.filteMetaEnergyAble(arg0)
	local var0 = arg0.metaShipVO

	if var0 and not var0:isMaxStar() then
		return true
	end

	return false
end

function var0.filteMetaSynAble(arg0)
	if arg0:isPtType() then
		return not arg0:IsGotAllAwards()
	else
		return false
	end
end

return var0
