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
var0_0.WITH_LIVE2D_PLUS = 9
var0_0.WITH_DOUBLE_VIOCE = 10
var0_0.WITH_ASMR = 11

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
			[var0_0.WITH_CHANGE] = "change",
			[var0_0.WITH_LIVE2D_PLUS] = "live2d_plus",
			[var0_0.WITH_DOUBLE_VIOCE] = "double_voice",
			[var0_0.WITH_ASMR] = "asmr_skin"
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

	if arg0_7:getConfig("skin_type") == var0_0.SKIN_TYPE_TB then
		arg0_7.shipName = NewEducateHelper.GetShipNameBySecId(NewEducateHelper.GetSecIdBySkinId(arg0_7.id))
	else
		local var0_7 = arg0_7:getConfig("ship_group")
		local var1_7 = ShipGroup.getDefaultShipConfig(var0_7)

		arg0_7.shipName = var1_7 and var1_7.name or ""
	end

	arg0_7.skinName = arg0_7:getConfig("name")
end

function var0_0.bindConfigTable(arg0_8)
	return pg.ship_skin_template
end

function var0_0.isExpireType(arg0_9)
	return arg0_9.endTime > 0
end

function var0_0.getExpireTime(arg0_10)
	return arg0_10.endTime
end

function var0_0.isExpired(arg0_11)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_11.endTime
end

function var0_0.getRemainTime(arg0_12)
	return arg0_12:getExpireTime() - pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.getIcon(arg0_13)
	return arg0_13:getConfig("painting")
end

function var0_0.InShowTime(arg0_14)
	return getProxy(ShipSkinProxy):InShowTime(arg0_14.id)
end

function var0_0.IsDefault(arg0_15)
	return arg0_15:getConfig("skin_type") == var0_0.SKIN_TYPE_DEFAULT
end

function var0_0.IsType(arg0_16, arg1_16)
	return arg0_16:getConfig("shop_type_id") == arg1_16
end

function var0_0.IsMatchKey(arg0_17, arg1_17)
	if not arg1_17 or arg1_17 == "" then
		return true
	end

	arg1_17 = string.lower(string.gsub(arg1_17, "%.", "%%."))
	arg1_17 = string.lower(string.gsub(arg1_17, "%-", "%%-"))

	return string.find(string.lower(arg0_17.shipName), arg1_17) or string.find(string.lower(arg0_17.skinName), arg1_17)
end

function var0_0.ToShip(arg0_18)
	local var0_18 = arg0_18:getConfig("ship_group")
	local var1_18 = ShipGroup.getDefaultShipConfig(var0_18)

	if var1_18 then
		return Ship.New({
			id = 1,
			intimacy = 10000,
			template_id = var1_18.id,
			skin_id = arg0_18.id
		})
	else
		return nil
	end
end

function var0_0.GetDefaultShipConfig(arg0_19)
	local var0_19 = arg0_19:getConfig("ship_group")

	return (ShipGroup.getDefaultShipConfig(var0_19))
end

function var0_0.IsLive2d(arg0_20)
	if not arg0_20.isLive2dTag then
		arg0_20.isLive2dTag = table.contains(arg0_20:getConfig("tag"), var0_0.WITH_LIVE2D)
	end

	return arg0_20.isLive2dTag
end

function var0_0.IsDbg(arg0_21)
	if not arg0_21.isDGBTag then
		arg0_21.isDGBTag = table.contains(arg0_21:getConfig("tag"), var0_0.WITH_DYNAMIC_BG)
	end

	return arg0_21.isDGBTag
end

function var0_0.IsBG(arg0_22)
	if not arg0_22.isBGTag then
		arg0_22.isBGTag = table.contains(arg0_22:getConfig("tag"), var0_0.WITH_BG)
	end

	return arg0_22.isBGTag
end

function var0_0.IsEffect(arg0_23)
	if not arg0_23.isEffectTag then
		arg0_23.isEffectTag = table.contains(arg0_23:getConfig("tag"), var0_0.WITH_EFFECT)
	end

	return arg0_23.isEffectTag
end

function var0_0.isBgm(arg0_24)
	if not arg0_24.isBgmTag then
		arg0_24.isBgmTag = table.contains(arg0_24:getConfig("tag"), var0_0.WITH_BGM)
	end

	return arg0_24.isBgmTag
end

function var0_0.IsSpine(arg0_25)
	if not arg0_25.isSpine then
		arg0_25.isSpine = table.contains(arg0_25:getConfig("tag"), var0_0.WITH_SPINE)
	end

	return arg0_25.isSpine
end

function var0_0.IsSpinePlus(arg0_26)
	if not arg0_26.isSpinePlus then
		arg0_26.isSpinePlus = table.contains(arg0_26:getConfig("tag"), var0_0.WITH_SPINE_PLUS)
	end

	return arg0_26.isSpinePlus
end

function var0_0.IsLive2dPlus(arg0_27)
	if not arg0_27.isLive2dPlusTag then
		arg0_27.isLive2dPlusTag = table.contains(arg0_27:getConfig("tag"), var0_0.WITH_LIVE2D_PLUS)
	end

	return arg0_27.isLive2dPlusTag
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
	local var0_30 = getProxy(BayProxy):CanUseShareSkinPhantoms(arg0_30.id)

	return #var0_30 > 0 and underscore.all(var0_30, function(arg0_31)
		return arg0_31:getSkinId() ~= arg0_30.id and not var0_0.IsSameChangeSkinGroup(arg0_31:getSkinId(), arg0_30.id)
	end)
end

function var0_0.NoUse(arg0_32)
	local var0_32 = getProxy(BayProxy):CanUseShareSkinPhantoms(arg0_32.id)

	return #var0_32 == 0 or #var0_32 > 0 and underscore.all(var0_32, function(arg0_33)
		return arg0_33:getSkinId() ~= arg0_32.id and not var0_0.IsSameChangeSkinGroup(arg0_33:getSkinId(), arg0_32.id)
	end)
end

function var0_0.ExistShip(arg0_34)
	local var0_34 = arg0_34:getConfig("ship_group")

	return pg.ship_data_statistics[tonumber(var0_34 .. 1)] ~= nil
end

function var0_0.IsTransSkin(arg0_35)
	return arg0_35:getConfig("skin_type") == var0_0.SKIN_TYPE_REMAKE
end

function var0_0.IsProposeSkin(arg0_36)
	return arg0_36:getConfig("skin_type") == var0_0.SKIN_TYPE_PROPOSE
end

function var0_0.IsHxDynamicPreview(arg0_37)
	if HXSet.isHx() then
		return arg0_37:getConfig("shop_dynamic_hx") == 1
	end

	return false
end

function var0_0.IsChangeSkinMainIndex(arg0_38)
	if var0_0.IsChangeSkin(arg0_38.id) then
		return arg0_38:getConfig("change_skin").index == 1
	end

	return false
end

function var0_0.MatchChangeSkinMain(arg0_39)
	if var0_0.IsChangeSkin(arg0_39.id) and not arg0_39:IsChangeSkinMainIndex() then
		return false
	end

	return true
end

function var0_0.CanShare(arg0_40)
	local var0_40 = getProxy(ShipSkinProxy):hasSkin(arg0_40.configId)

	local function var1_40()
		if var0_40 then
			return true
		end

		return arg0_40:InShowTime()
	end

	local function var2_40()
		local var0_42 = arg0_40:getConfig("ship_group")
		local var1_42 = getProxy(BayProxy):getRawData()

		for iter0_42, iter1_42 in pairs(var1_42) do
			if iter1_42.groupId == var0_42 and iter1_42.propose then
				return true
			end
		end

		return false
	end

	local var3_40 = arg0_40:getConfig("skin_type")

	return not (var3_40 == var0_0.SKIN_TYPE_DEFAULT or var3_40 == var0_0.SKIN_TYPE_REMAKE or var3_40 == var0_0.SKIN_TYPE_OLD or var3_40 == var0_0.SKIN_TYPE_NOT_HAVE_HIDE and not var0_40 or var3_40 == var0_0.SKIN_TYPE_SHOW_IN_TIME and not var1_40())
end

function var0_0.CanShareInJuus(arg0_43)
	local var0_43 = getProxy(ShipSkinProxy):hasSkin(arg0_43.configId)
	local var1_43 = arg0_43:getConfig("skin_type")

	return not (var1_43 == var0_0.SKIN_TYPE_REMAKE or var1_43 == var0_0.SKIN_TYPE_OLD or var1_43 == var0_0.SKIN_TYPE_NOT_HAVE_HIDE and not var0_43 or var1_43 == var0_0.SKIN_TYPE_SHOW_IN_TIME and not var0_43)
end

function var0_0.IsShareSkin(arg0_44, arg1_44)
	local var0_44 = pg.ship_skin_template[arg1_44]
	local var1_44 = pg.ship_data_group
	local var2_44 = var1_44[var1_44.get_id_list_by_group_type[arg0_44.groupId][1]].share_group_id

	return table.contains(var2_44, var0_44.ship_group)
end

function var0_0.CanUseShareSkinForShip(arg0_45, arg1_45)
	local var0_45 = var0_0.IsShareSkin(arg0_45, arg1_45)
	local var1_45 = ShipSkin.New({
		id = arg1_45
	})
	local var2_45 = false
	local var3_45 = var1_45:CanShare()
	local var4_45 = var1_45:IsProposeSkin()

	if var3_45 and var4_45 and arg0_45.propose then
		var2_45 = true
	elseif var3_45 and not var4_45 then
		var2_45 = math.floor(arg0_45:getIntimacy() / 100) >= arg0_45:GetNoProposeIntimacyMax()
	end

	return var0_45 and var2_45
end

function var0_0.ExistReward(arg0_46)
	local var0_46 = pg.ship_skin_reward[arg0_46.configId]

	return var0_46 ~= nil and #var0_46.reward > 0
end

function var0_0.GetRewardList(arg0_47)
	if not arg0_47:ExistReward() then
		return {}
	end

	local var0_47 = pg.ship_skin_reward[arg0_47.configId]
	local var1_47 = {}

	for iter0_47, iter1_47 in pairs(var0_47.reward) do
		table.insert(var1_47, {
			type = iter1_47[1],
			id = iter1_47[2],
			count = iter1_47[3]
		})
	end

	return var1_47
end

function var0_0.GetRewardListDesc(arg0_48)
	local var0_48 = arg0_48:GetRewardList()

	if #var0_48 <= 0 then
		return ""
	end

	local var1_48 = _.map(var0_48, function(arg0_49)
		return {
			arg0_49.type,
			arg0_49.id,
			arg0_49.count
		}
	end)

	return getDropInfo(var1_48)
end

function var0_0.GetShareGroupIds(arg0_50)
	local var0_50 = arg0_50:getConfig("ship_group")
	local var1_50 = pg.ship_data_group.get_id_list_by_group_type[var0_50][1]
	local var2_50 = pg.ship_data_group[var1_50]

	return var0_50, underscore.to_array(var2_50.share_group_id)
end

function var0_0.GetAllChangeSkinIds(arg0_51)
	if not var0_0.GetChangeSkinMainId(arg0_51) then
		return {
			arg0_51
		}
	end

	local var0_51 = var0_0.GetChangeSkinMainId(arg0_51)
	local var1_51 = {
		var0_51
	}
	local var2_51 = arg0_51

	for iter0_51 = 1, 10 do
		local var3_51 = var0_0.GetChangeSkinNextId(var2_51)

		if not table.contains(var1_51, var3_51) then
			table.insert(var1_51, var3_51)
		end

		var2_51 = var3_51

		if var0_0.GetChangeSkinIndex(var2_51) == 1 then
			return var1_51
		end
	end

	return var1_51
end

function var0_0.IsChangeSkin(arg0_52)
	local var0_52 = pg.ship_skin_template[arg0_52]

	if not var0_52 then
		warning("skin not exist " .. arg0_52)
	end

	return table.contains(var0_52.tag, var0_0.WITH_CHANGE) or table.contains(var0_52.tag, var0_0.WITH_DOUBLE_VIOCE) or table.contains(var0_52.tag, var0_0.WITH_ASMR)
end

function var0_0.GetChangeSkinMainId(arg0_53)
	if not var0_0.IsChangeSkin(arg0_53) then
		return arg0_53
	end

	while var0_0.GetChangeSkinIndex(arg0_53) ~= 1 do
		arg0_53 = var0_0.GetChangeSkinNextId(arg0_53)
	end

	return arg0_53
end

function var0_0.GetChangeSkinData(arg0_54)
	if not var0_0.IsChangeSkin(arg0_54) then
		return nil
	end

	local var0_54 = pg.ship_skin_template[arg0_54]

	if var0_54 and var0_54.change_skin and var0_54.change_skin ~= "" then
		return var0_54.change_skin
	end

	return nil
end

function var0_0.IsSameChangeSkinGroup(arg0_55, arg1_55)
	if not var0_0.IsChangeSkin(arg0_55) or not var0_0.IsChangeSkin(arg1_55) then
		return false
	end

	return var0_0.GetChangeSkinGroupId(arg0_55) == var0_0.GetChangeSkinGroupId(arg1_55)
end

function var0_0.GetChangeSkinGroupId(arg0_56)
	local var0_56 = var0_0.GetChangeSkinData(arg0_56)

	return var0_56 and var0_56.group or nil
end

function var0_0.GetChangeSkinNextId(arg0_57)
	local var0_57 = var0_0.GetChangeSkinData(arg0_57)

	return var0_57 and var0_57.next or nil
end

function var0_0.GetChangeSkinIndex(arg0_58)
	local var0_58 = var0_0.GetChangeSkinData(arg0_58)

	return var0_58 and var0_58.index or nil
end

function var0_0.GetChangeSkinState(arg0_59)
	local var0_59 = var0_0.GetChangeSkinData(arg0_59)

	return var0_59 and var0_59.state or nil
end

function var0_0.GetChangeSkinAction(arg0_60)
	local var0_60 = var0_0.GetChangeSkinData(arg0_60)

	return var0_60 and var0_60.action or nil
end

function var0_0.GetChangeSkinCustomDataId(arg0_61, arg1_61)
	local var0_61 = var0_0.GetChangeSkinData(arg0_61)

	return var0_61 and var0_61[arg1_61] or nil
end

function var0_0.GetStoreChangeSkinId(arg0_62, arg1_62)
	local var0_62, var1_62 = ShipPhantom.UnpackMark(arg1_62)
	local var2_62 = var0_0.GetStoreChangeSkinPrefsName(arg0_62, arg1_62)
	local var3_62 = PlayerPrefs.GetInt(var2_62, 0)

	if var3_62 == 0 then
		return nil
	else
		return var3_62
	end
end

function var0_0.SetStoreChangeSkinId(arg0_63, arg1_63)
	local var0_63

	var0_63 = ShipSkin.GetChangeSkinCustomDataId(arg0_63, "asmr") == 1 and true or false

	local var1_63, var2_63 = ShipPhantom.UnpackMark(arg1_63)
	local var3_63 = var0_0.GetChangeSkinGroupId(arg0_63)
	local var4_63 = var0_0.GetStoreChangeSkinPrefsName(var3_63, arg1_63)

	PlayerPrefs.SetInt(var4_63, arg0_63)
end

function var0_0.GetStoreChangeSkinPrefsName(...)
	return string.format("change_skin_group_%s", table.concat({
		...
	}, "_"))
end

return var0_0
