local var0_0 = class("ShipSkin", import(".BaseVO"))

var0_0.SKIN_TYPE_DEFAULT = -1
var0_0.SKIN_TYPE_COMMON_FASHION = 0
var0_0.SKIN_TYPE_PROPOSE = 1
var0_0.SKIN_TYPE_REMAKE = 2
var0_0.SKIN_TYPE_OLD = 3
var0_0.SKIN_TYPE_NOT_HAVE_HIDE = 4
var0_0.SKIN_TYPE_SHOW_IN_TIME = 5
var0_0.SKIN_TYPE_TB = 6
var0_0.WITH_LIVE2D = 1
var0_0.WITH_BG = 2
var0_0.WITH_EFFECT = 3
var0_0.WITH_DYNAMIC_BG = 4
var0_0.WITH_BGM = 5
var0_0.WITH_SPINE = 6
var0_0.WITH_SPINE_PLUS = 7
var0_0.WITH_CHANGE = 8

function var0_0.Tag2Name(arg0_1)
	if not var0_0.Tag2NameTab then
		var0_0.Tag2NameTab = {
			[var0_0.WITH_BG] = "bg",
			[var0_0.WITH_BGM] = "bgm",
			[var0_0.WITH_DYNAMIC_BG] = "dtbg",
			[var0_0.WITH_EFFECT] = "effect",
			[var0_0.WITH_LIVE2D] = "live2d",
			[var0_0.WITH_SPINE] = "spine",
			[var0_0.WITH_SPINE_PLUS] = "spine_plus",
			[var0_0.WITH_CHANGE] = "change"
		}
	end

	return var0_0.Tag2NameTab[arg0_1]
end

function var0_0.GetShopTypeIdBySkinId(arg0_2, arg1_2)
	local var0_2 = pg.ship_skin_template.get_id_list_by_shop_type_id

	if arg1_2[arg0_2] then
		return arg1_2[arg0_2]
	end

	for iter0_2, iter1_2 in pairs(var0_2) do
		for iter2_2, iter3_2 in ipairs(iter1_2) do
			arg1_2[iter3_2] = iter0_2

			if iter3_2 == arg0_2 then
				return iter0_2
			end
		end
	end
end

local var1_0 = pg.ship_skin_template.get_id_list_by_ship_group

function var0_0.GetSkinByType(arg0_3, arg1_3)
	local var0_3 = var1_0[arg0_3] or {}

	for iter0_3, iter1_3 in ipairs(var0_3) do
		local var1_3 = pg.ship_skin_template[iter1_3]

		if var1_3.skin_type == arg1_3 then
			return var1_3
		end
	end
end

function var0_0.GetAllSkinByGroup(arg0_4)
	local var0_4 = {}
	local var1_4 = var1_0[arg0_4] or {}

	for iter0_4, iter1_4 in ipairs(var1_4) do
		local var2_4 = pg.ship_skin_template[iter1_4]

		if var2_4.no_showing ~= "1" then
			table.insert(var0_4, var2_4)
		end
	end

	return var0_4
end

function var0_0.GetShareSkinsByGroupId(arg0_5)
	local function var0_5(arg0_6)
		local var0_6 = arg0_6:getConfig("skin_type")

		return not (var0_6 == var0_0.SKIN_TYPE_DEFAULT or var0_6 == var0_0.SKIN_TYPE_REMAKE or var0_6 == var0_0.SKIN_TYPE_OLD)
	end

	local var1_5 = pg.ship_data_group.get_id_list_by_group_type[arg0_5][1]
	local var2_5 = pg.ship_data_group[var1_5]

	if not var2_5.share_group_id or #var2_5.share_group_id <= 0 then
		return {}
	end

	local var3_5 = {}

	for iter0_5, iter1_5 in ipairs(var2_5.share_group_id) do
		local var4_5 = pg.ship_skin_template.get_id_list_by_ship_group[iter1_5]

		for iter2_5, iter3_5 in ipairs(var4_5) do
			local var5_5 = ShipSkin.New({
				id = iter3_5
			})

			if var0_5(var5_5) then
				table.insert(var3_5, var5_5)
			end
		end
	end

	return var3_5
end

function var0_0.Ctor(arg0_7, arg1_7)
	arg0_7.id = arg1_7.id
	arg0_7.configId = arg1_7.id
	arg0_7.endTime = arg1_7.end_time or arg1_7.time or 0
	arg0_7.isNew = true

	if arg0_7:getConfig("skin_type") == var0_0.SKIN_TYPE_TB then
		arg0_7.shipName = NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_7.id))
	else
		local var0_7 = arg0_7:getConfig("ship_group")
		local var1_7 = ShipGroup.getDefaultShipConfig(var0_7)

		arg0_7.shipName = var1_7 and var1_7.name or ""
	end

	arg0_7.skinName = arg0_7:getConfig("name")
end

function var0_0.HasNewFlag(arg0_8)
	return arg0_8.isNew
end

function var0_0.SetIsNew(arg0_9, arg1_9)
	arg0_9.isNew = arg1_9
end

function var0_0.bindConfigTable(arg0_10)
	return pg.ship_skin_template
end

function var0_0.isExpireType(arg0_11)
	return arg0_11.endTime > 0
end

function var0_0.getExpireTime(arg0_12)
	return arg0_12.endTime
end

function var0_0.isExpired(arg0_13)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_13.endTime
end

function var0_0.getRemainTime(arg0_14)
	return arg0_14:getExpireTime() - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.getIcon(arg0_15)
	return arg0_15:getConfig("painting")
end

function var0_0.InShowTime(arg0_16)
	return getProxy(ShipSkinProxy):InShowTime(arg0_16.id)
end

function var0_0.IsDefault(arg0_17)
	return arg0_17:getConfig("skin_type") == var0_0.SKIN_TYPE_DEFAULT
end

function var0_0.IsType(arg0_18, arg1_18)
	return arg0_18:getConfig("shop_type_id") == arg1_18
end

function var0_0.IsMatchKey(arg0_19, arg1_19)
	if not arg1_19 or arg1_19 == "" then
		return true
	end

	arg1_19 = string.lower(string.gsub(arg1_19, "%.", "%%."))
	arg1_19 = string.lower(string.gsub(arg1_19, "%-", "%%-"))

	return string.find(string.lower(arg0_19.shipName), arg1_19) or string.find(string.lower(arg0_19.skinName), arg1_19)
end

function var0_0.ToShip(arg0_20)
	local var0_20 = arg0_20:getConfig("ship_group")
	local var1_20 = ShipGroup.getDefaultShipConfig(var0_20)

	if var1_20 then
		return Ship.New({
			id = 1,
			intimacy = 10000,
			template_id = var1_20.id,
			skin_id = arg0_20.id
		})
	else
		return nil
	end
end

function var0_0.GetDefaultShipConfig(arg0_21)
	local var0_21 = arg0_21:getConfig("ship_group")

	return (ShipGroup.getDefaultShipConfig(var0_21))
end

function var0_0.IsLive2d(arg0_22)
	if not arg0_22.isLive2dTag then
		arg0_22.isLive2dTag = table.contains(arg0_22:getConfig("tag"), var0_0.WITH_LIVE2D)
	end

	return arg0_22.isLive2dTag
end

function var0_0.IsDbg(arg0_23)
	if not arg0_23.isDGBTag then
		arg0_23.isDGBTag = table.contains(arg0_23:getConfig("tag"), var0_0.WITH_DYNAMIC_BG)
	end

	return arg0_23.isDGBTag
end

function var0_0.IsBG(arg0_24)
	if not arg0_24.isBGTag then
		arg0_24.isBGTag = table.contains(arg0_24:getConfig("tag"), var0_0.WITH_BG)
	end

	return arg0_24.isBGTag
end

function var0_0.IsEffect(arg0_25)
	if not arg0_25.isEffectTag then
		arg0_25.isEffectTag = table.contains(arg0_25:getConfig("tag"), var0_0.WITH_EFFECT)
	end

	return arg0_25.isEffectTag
end

function var0_0.isBgm(arg0_26)
	if not arg0_26.isBgmTag then
		arg0_26.isBgmTag = table.contains(arg0_26:getConfig("tag"), var0_0.WITH_BGM)
	end

	return arg0_26.isBgmTag
end

function var0_0.IsSpine(arg0_27)
	if not arg0_27.isSpine then
		arg0_27.isSpine = table.contains(arg0_27:getConfig("tag"), var0_0.WITH_SPINE)
	end

	return arg0_27.isSpine
end

function var0_0.CantUse(arg0_28)
	local var0_28 = arg0_28:IsTransSkin()
	local var1_28 = arg0_28:IsProposeSkin()
	local var2_28 = arg0_28:getConfig("ship_group")
	local var3_28 = getProxy(BayProxy):_ExistGroupShip(var2_28, var0_28, var1_28)
	local var4_28 = getProxy(CollectionProxy).shipGroups[var2_28] == nil

	return not var3_28 or var4_28
end

function var0_0.OwnShip(arg0_29)
	local var0_29 = arg0_29:IsTransSkin()
	local var1_29 = arg0_29:IsProposeSkin()
	local var2_29 = arg0_29:getConfig("ship_group")

	return (getProxy(BayProxy):_ExistGroupShip(var2_29, var0_29, var1_29))
end

function var0_0.WithoutUse(arg0_30)
	local var0_30 = arg0_30:getConfig("ship_group")
	local var1_30 = getProxy(BayProxy):findShipsByGroup(var0_30)
	local var2_30 = _.all(var1_30, function(arg0_31)
		return arg0_31.skinId ~= arg0_30.id
	end)

	return #var1_30 > 0 and var2_30
end

function var0_0.ExistShip(arg0_32)
	local var0_32 = arg0_32:getConfig("ship_group")

	return pg.ship_data_statistics[tonumber(var0_32 .. 1)] ~= nil
end

function var0_0.IsTransSkin(arg0_33)
	return arg0_33:getConfig("skin_type") == var0_0.SKIN_TYPE_REMAKE
end

function var0_0.IsProposeSkin(arg0_34)
	return arg0_34:getConfig("skin_type") == var0_0.SKIN_TYPE_PROPOSE
end

function var0_0.IsChangeSkin(arg0_35)
	return table.contains(arg0_35:getConfig("tag"), var0_0.WITH_CHANGE)
end

function var0_0.IsChangeSkinMainIndex(arg0_36)
	if arg0_36:IsChangeSkin() then
		return arg0_36:getConfig("change_skin").index == 1
	end

	return false
end

function var0_0.MatchChangeSkinMain(arg0_37)
	if arg0_37:IsChangeSkin() and not arg0_37:IsChangeSkinMainIndex() then
		return false
	end

	return true
end

function var0_0.CanShare(arg0_38)
	local var0_38 = getProxy(ShipSkinProxy):hasSkin(arg0_38.configId)

	local function var1_38()
		if var0_38 then
			return true
		end

		return arg0_38:InShowTime()
	end

	local function var2_38()
		local var0_40 = arg0_38:getConfig("ship_group")
		local var1_40 = getProxy(BayProxy):getRawData()

		for iter0_40, iter1_40 in pairs(var1_40) do
			if iter1_40.groupId == var0_40 and iter1_40.propose then
				return true
			end
		end

		return false
	end

	local var3_38 = arg0_38:getConfig("skin_type")

	return not (var3_38 == var0_0.SKIN_TYPE_DEFAULT or var3_38 == var0_0.SKIN_TYPE_REMAKE or var3_38 == var0_0.SKIN_TYPE_OLD or var3_38 == var0_0.SKIN_TYPE_NOT_HAVE_HIDE and not var0_38 or var3_38 == var0_0.SKIN_TYPE_SHOW_IN_TIME and not var1_38())
end

function var0_0.IsShareSkin(arg0_41, arg1_41)
	local var0_41 = pg.ship_skin_template[arg1_41]
	local var1_41 = pg.ship_data_group
	local var2_41 = var1_41[var1_41.get_id_list_by_group_type[arg0_41.groupId][1]].share_group_id

	return table.contains(var2_41, var0_41.ship_group)
end

function var0_0.CanUseShareSkinForShip(arg0_42, arg1_42)
	local var0_42 = var0_0.IsShareSkin(arg0_42, arg1_42)
	local var1_42 = ShipSkin.New({
		id = arg1_42
	})
	local var2_42 = false
	local var3_42 = var1_42:CanShare()
	local var4_42 = var1_42:IsProposeSkin()

	if var3_42 and var4_42 and arg0_42.propose then
		var2_42 = true
	elseif var3_42 and not var4_42 then
		var2_42 = math.floor(arg0_42:getIntimacy() / 100) >= arg0_42:GetNoProposeIntimacyMax()
	end

	return var0_42 and var2_42
end

function var0_0.ExistReward(arg0_43)
	local var0_43 = pg.ship_skin_reward[arg0_43.configId]

	return var0_43 ~= nil and #var0_43.reward > 0
end

function var0_0.GetRewardList(arg0_44)
	if not arg0_44:ExistReward() then
		return {}
	end

	local var0_44 = pg.ship_skin_reward[arg0_44.configId]
	local var1_44 = {}

	for iter0_44, iter1_44 in pairs(var0_44.reward) do
		table.insert(var1_44, {
			type = iter1_44[1],
			id = iter1_44[2],
			count = iter1_44[3]
		})
	end

	return var1_44
end

function var0_0.GetRewardListDesc(arg0_45)
	local var0_45 = arg0_45:GetRewardList()

	if #var0_45 <= 0 then
		return ""
	end

	local var1_45 = _.map(var0_45, function(arg0_46)
		return {
			arg0_46.type,
			arg0_46.id,
			arg0_46.count
		}
	end)

	return getDropInfo(var1_45)
end

return var0_0
