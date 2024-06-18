local var0_0 = class("ShopsProxy", import(".NetProxy"))

var0_0.MERITOROUS_SHOP_UPDATED = "ShopsProxy:MERITOROUS_SHOP_UPDATED"
var0_0.SHOPPINGSTREET_UPDATE = "ShopsProxy:SHOPPINGSTREET_UPDATE"
var0_0.FIRST_CHARGE_IDS_UPDATED = "ShopsProxy:FIRST_CHARGE_IDS_UPDATED"
var0_0.CHARGED_LIST_UPDATED = "ShopsProxy:CHARGED_LIST_UPDATED"
var0_0.NORMAL_LIST_UPDATED = "ShopsProxy:NORMAL_LIST_UPDATED"
var0_0.NORMAL_GROUP_LIST_UPDATED = "ShopsProxy:NORMAL_GROUP_LIST_UPDATED"
var0_0.ACTIVITY_SHOP_UPDATED = "ShopsProxy:ACTIVITY_SHOP_UPDATED"
var0_0.GUILD_SHOP_ADDED = "ShopsProxy:GUILD_SHOP_ADDED"
var0_0.GUILD_SHOP_UPDATED = "ShopsProxy:GUILD_SHOP_UPDATED"
var0_0.ACTIVITY_SHOPS_UPDATED = "ShopsProxy:ACTIVITY_SHOPS_UPDATED"
var0_0.SHAM_SHOP_UPDATED = "ShopsProxy:SHAM_SHOP_UPDATED"
var0_0.FRAGMENT_SHOP_UPDATED = "ShopsProxy:FRAGMENT_SHOP_UPDATED"
var0_0.ACTIVITY_SHOP_GOODS_UPDATED = "ShopsProxy:ACTIVITY_SHOP_GOODS_UPDATED"
var0_0.META_SHOP_GOODS_UPDATED = "ShopsProxy:META_SHOP_GOODS_UPDATED"
var0_0.MEDAL_SHOP_UPDATED = "ShopsProxy:MEDAL_SHOP_UPDATED"
var0_0.QUOTA_SHOP_UPDATED = "ShopsProxy:QUOTA_SHOP_UPDATED"

function var0_0.register(arg0_1)
	arg0_1.shopStreet = nil
	arg0_1.meritorousShop = nil
	arg0_1.guildShop = nil
	arg0_1.refreshChargeList = false
	arg0_1.metaShop = nil
	arg0_1.miniShop = nil

	arg0_1:on(22102, function(arg0_2)
		local var0_2 = getProxy(ShopsProxy)
		local var1_2 = ShoppingStreet.New(arg0_2.street)

		var0_2:setShopStreet(var1_2)
	end)

	arg0_1.shamShop = ShamBattleShop.New()
	arg0_1.fragmentShop = FragmentShop.New()

	arg0_1:on(16200, function(arg0_3)
		arg0_1.shamShop:update(arg0_3.month, arg0_3.core_shop_list)
		arg0_1.fragmentShop:update(arg0_3.month, arg0_3.blue_shop_list, arg0_3.normal_shop_list)
	end)

	arg0_1.timers = {}
	arg0_1.tradeNoPrev = ""

	local var0_1 = pg.shop_template

	arg0_1.freeGiftIdList = {}

	for iter0_1, iter1_1 in pairs(var0_1.all) do
		if var0_1[iter1_1].genre == "gift_package" and var0_1[iter1_1].discount == 100 then
			table.insert(arg0_1.freeGiftIdList, iter1_1)
		end
	end
end

function var0_0.setShopStreet(arg0_4, arg1_4)
	arg0_4.shopStreet = arg1_4

	arg0_4:sendNotification(var0_0.SHOPPINGSTREET_UPDATE, {
		shopStreet = Clone(arg0_4.shopStreet)
	})
end

function var0_0.UpdateShopStreet(arg0_5, arg1_5)
	arg0_5.shopStreet = arg1_5
end

function var0_0.getShopStreet(arg0_6)
	return Clone(arg0_6.shopStreet)
end

function var0_0.getMeritorousShop(arg0_7)
	return Clone(arg0_7.meritorousShop)
end

function var0_0.addMeritorousShop(arg0_8, arg1_8)
	arg0_8.meritorousShop = arg1_8

	arg0_8:sendNotification(var0_0.MERITOROUS_SHOP_UPDATED, Clone(arg1_8))
end

function var0_0.updateMeritorousShop(arg0_9, arg1_9)
	arg0_9.meritorousShop = arg1_9
end

function var0_0.getMiniShop(arg0_10)
	return Clone(arg0_10.miniShop)
end

function var0_0.setMiniShop(arg0_11, arg1_11)
	arg0_11.miniShop = arg1_11
end

function var0_0.setNormalList(arg0_12, arg1_12)
	arg0_12.normalList = arg1_12 or {}
end

function var0_0.GetNormalList(arg0_13)
	return Clone(arg0_13.normalList)
end

function var0_0.GetNormalByID(arg0_14, arg1_14)
	if not arg0_14.normalList then
		arg0_14.normalList = {}
	end

	local var0_14 = arg0_14.normalList[arg1_14] or Goods.Create({
		buyCount = 0,
		id = arg1_14
	}, Goods.TYPE_GIFT_PACKAGE)

	arg0_14.normalList[arg1_14] = var0_14

	return arg0_14.normalList[arg1_14]
end

function var0_0.updateNormalByID(arg0_15, arg1_15)
	arg0_15.normalList[arg1_15.id] = arg1_15
end

function var0_0.checkHasFreeNormal(arg0_16)
	for iter0_16, iter1_16 in ipairs(arg0_16.freeGiftIdList) do
		if arg0_16:checkNormalCanPurchase(iter1_16) then
			return true
		end
	end

	return false
end

function var0_0.checkNormalCanPurchase(arg0_17, arg1_17)
	if arg0_17.normalList[arg1_17] ~= nil then
		local var0_17 = arg0_17.normalList[arg1_17]

		if not var0_17:inTime() then
			return false
		end

		local var1_17 = var0_17:getConfig("group") or 0

		if var1_17 > 0 then
			local var2_17 = var0_17:getConfig("group_limit")
			local var3_17 = arg0_17:getGroupLimit(var1_17)

			return var2_17 > 0 and var3_17 < var2_17
		elseif var0_17:canPurchase() then
			return true
		end
	else
		return arg0_17:GetNormalByID(arg1_17):inTime()
	end
end

function var0_0.setNormalGroupList(arg0_18, arg1_18)
	arg0_18.normalGroupList = arg1_18
end

function var0_0.GetNormalGroupList(arg0_19)
	return arg0_19.normalGroupList
end

function var0_0.updateNormalGroupList(arg0_20, arg1_20, arg2_20)
	if arg1_20 <= 0 then
		return
	end

	for iter0_20, iter1_20 in ipairs(arg0_20.normalGroupList) do
		if iter1_20.shop_id == arg1_20 then
			local var0_20 = arg0_20.normalGroupList[iter0_20].pay_count or 0

			arg0_20.normalGroupList[iter0_20].pay_count = var0_20 + arg2_20

			return
		end
	end

	table.insert(arg0_20.normalGroupList, {
		shop_id = arg1_20,
		pay_count = arg2_20
	})
end

function var0_0.getGroupLimit(arg0_21, arg1_21)
	if not arg0_21.normalGroupList then
		return 0
	end

	for iter0_21, iter1_21 in ipairs(arg0_21.normalGroupList) do
		if iter1_21.shop_id == arg1_21 then
			return iter1_21.pay_count
		end
	end

	return 0
end

function var0_0.addActivityShops(arg0_22, arg1_22)
	arg0_22.activityShops = arg1_22

	arg0_22:sendNotification(var0_0.ACTIVITY_SHOPS_UPDATED)
end

function var0_0.getActivityShopById(arg0_23, arg1_23)
	assert(arg0_23.activityShops[arg1_23], "activity shop should exist" .. arg1_23)

	return arg0_23.activityShops[arg1_23]
end

function var0_0.updateActivityShop(arg0_24, arg1_24, arg2_24)
	assert(arg0_24.activityShops, "activityShops can not be nil")

	arg0_24.activityShops[arg1_24] = arg2_24

	arg0_24:sendNotification(var0_0.ACTIVITY_SHOP_UPDATED, {
		activityId = arg1_24,
		shop = arg2_24:clone()
	})
end

function var0_0.UpdateActivityGoods(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg0_25:getActivityShopById(arg1_25)

	var0_25:getGoodsById(arg2_25):addBuyCount(arg3_25)

	arg0_25.activityShops[arg1_25] = var0_25

	arg0_25:sendNotification(var0_0.ACTIVITY_SHOP_GOODS_UPDATED, {
		activityId = arg1_25,
		goodsId = arg2_25
	})
end

function var0_0.getActivityShops(arg0_26)
	return arg0_26.activityShops
end

function var0_0.setFirstChargeList(arg0_27, arg1_27)
	arg0_27.firstChargeList = arg1_27

	arg0_27:sendNotification(var0_0.FIRST_CHARGE_IDS_UPDATED, Clone(arg1_27))
end

function var0_0.getFirstChargeList(arg0_28)
	return Clone(arg0_28.firstChargeList)
end

function var0_0.setChargedList(arg0_29, arg1_29)
	arg0_29.chargeList = arg1_29

	arg0_29:sendNotification(var0_0.CHARGED_LIST_UPDATED, Clone(arg1_29))
end

function var0_0.getChargedList(arg0_30)
	return Clone(arg0_30.chargeList)
end

local var1_0 = 3
local var2_0 = 10

function var0_0.chargeFailed(arg0_31, arg1_31, arg2_31)
	if not arg0_31.timers[arg1_31] then
		pg.UIMgr.GetInstance():LoadingOn()

		arg0_31.timers[arg1_31] = Timer.New(function()
			if arg0_31.timers[arg1_31].loop == 1 then
				pg.UIMgr.GetInstance():LoadingOff()
			end

			PaySuccess(arg1_31, arg2_31)
		end, var1_0, var2_0)

		arg0_31.timers[arg1_31]:Start()
	end
end

function var0_0.removeChargeTimer(arg0_33, arg1_33)
	if arg0_33.timers[arg1_33] then
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_33.timers[arg1_33]:Stop()

		arg0_33.timers[arg1_33] = nil
	end
end

function var0_0.addWaitTimer(arg0_34)
	pg.UIMgr.GetInstance():LoadingOn()

	arg0_34.waitBiliTimer = Timer.New(function()
		arg0_34:removeWaitTimer()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("charge_time_out")
		})
	end, 25, 1)

	arg0_34.waitBiliTimer:Start()
end

function var0_0.removeWaitTimer(arg0_36)
	if arg0_36.waitBiliTimer then
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_36.waitBiliTimer:Stop()

		arg0_36.waitBiliTimer = nil
	end
end

function var0_0.setGuildShop(arg0_37, arg1_37)
	assert(isa(arg1_37, GuildShop), "shop should instance of GuildShop")
	assert(arg0_37.guildShop == nil, "shop already exist")

	arg0_37.guildShop = arg1_37

	arg0_37:sendNotification(var0_0.GUILD_SHOP_ADDED, arg0_37.guildShop)
end

function var0_0.getGuildShop(arg0_38)
	return arg0_38.guildShop
end

function var0_0.updateGuildShop(arg0_39, arg1_39, arg2_39)
	assert(isa(arg1_39, GuildShop), "shop should instance of GuildShop")
	assert(arg0_39.guildShop, "should exist shop")

	arg0_39.guildShop = arg1_39

	arg0_39:sendNotification(var0_0.GUILD_SHOP_UPDATED, {
		shop = arg0_39.guildShop,
		reset = arg2_39
	})
end

function var0_0.AddShamShop(arg0_40, arg1_40)
	arg0_40.shamShop = arg1_40

	arg0_40:sendNotification(var0_0.SHAM_SHOP_UPDATED, arg1_40)
end

function var0_0.updateShamShop(arg0_41, arg1_41)
	arg0_41.shamShop = arg1_41
end

function var0_0.getShamShop(arg0_42)
	return arg0_42.shamShop
end

function var0_0.AddFragmentShop(arg0_43, arg1_43)
	arg0_43.fragmentShop = arg1_43

	arg0_43:sendNotification(var0_0.FRAGMENT_SHOP_UPDATED, arg1_43)
end

function var0_0.updateFragmentShop(arg0_44, arg1_44)
	arg0_44.fragmentShop = arg1_44
end

function var0_0.getFragmentShop(arg0_45)
	return arg0_45.fragmentShop
end

function var0_0.AddMetaShop(arg0_46, arg1_46)
	arg0_46.metaShop = arg1_46
end

function var0_0.GetMetaShop(arg0_47)
	return arg0_47.metaShop
end

function var0_0.UpdateMetaShopGoods(arg0_48, arg1_48, arg2_48)
	arg0_48:GetMetaShop():getGoodsById(arg1_48):addBuyCount(arg2_48)
	arg0_48:sendNotification(var0_0.META_SHOP_GOODS_UPDATED, {
		goodsId = arg1_48
	})
end

function var0_0.SetNewServerShop(arg0_49, arg1_49)
	arg0_49.newServerShop = arg1_49
end

function var0_0.GetNewServerShop(arg0_50)
	return arg0_50.newServerShop
end

function var0_0.SetMedalShop(arg0_51, arg1_51)
	arg0_51.medalShop = arg1_51
end

function var0_0.UpdateMedalShop(arg0_52, arg1_52)
	arg0_52.medalShop = arg1_52

	arg0_52:sendNotification(var0_0.MEDAL_SHOP_UPDATED, arg1_52)
end

function var0_0.GetMedalShop(arg0_53)
	return arg0_53.medalShop
end

function var0_0.setQuotaShop(arg0_54, arg1_54)
	arg0_54.quotaShop = arg1_54
end

function var0_0.getQuotaShop(arg0_55)
	return arg0_55.quotaShop
end

function var0_0.updateQuotaShop(arg0_56, arg1_56, arg2_56)
	arg0_56.quotaShop = arg1_56

	arg0_56:sendNotification(var0_0.QUOTA_SHOP_UPDATED, {
		shop = arg0_56.quotaShop,
		reset = arg2_56
	})
end

function var0_0.remove(arg0_57)
	for iter0_57, iter1_57 in pairs(arg0_57.timers) do
		iter1_57:Stop()
	end

	arg0_57.timers = nil

	arg0_57:removeWaitTimer()
end

function var0_0.ShouldRefreshChargeList(arg0_58)
	local var0_58 = arg0_58:getFirstChargeList()
	local var1_58 = arg0_58:getChargedList()
	local var2_58 = arg0_58:GetNormalList()
	local var3_58 = arg0_58:GetNormalGroupList()

	return not var0_58 or not var1_58 or not var2_58 or not var3_58 or arg0_58.refreshChargeList
end

function var0_0.GetRecommendCommodities(arg0_59)
	local var0_59 = arg0_59:getChargedList()
	local var1_59 = arg0_59:GetNormalList()
	local var2_59 = arg0_59:GetNormalGroupList()

	if not var0_59 or not var1_59 or not var2_59 then
		return {}
	end

	local var3_59 = {}

	for iter0_59, iter1_59 in ipairs(pg.recommend_shop.all) do
		local var4_59 = pg.recommend_shop[iter1_59].time

		if pg.TimeMgr.GetInstance():inTime(var4_59) then
			local var5_59 = RecommendCommodity.New({
				id = iter1_59,
				chargedList = var0_59,
				normalList = var1_59,
				normalGroupList = var2_59
			})

			if var5_59:CanShow() then
				table.insert(var3_59, var5_59)
			end
		end
	end

	table.sort(var3_59, function(arg0_60, arg1_60)
		return arg0_60:GetOrder() < arg1_60:GetOrder()
	end)

	return var3_59
end

function var0_0.GetGiftCommodity(arg0_61, arg1_61, arg2_61)
	local var0_61 = Goods.Create({
		shop_id = arg1_61
	}, arg2_61)

	if var0_61:isChargeType() then
		local var1_61 = ChargeConst.getBuyCount(arg0_61.chargeList, var0_61.id)

		var0_61:updateBuyCount(var1_61)
	else
		local var2_61 = ChargeConst.getBuyCount(arg0_61.normalList, var0_61.id)

		var0_61:updateBuyCount(var2_61)

		local var3_61 = var0_61:getConfig("group") or 0

		if var3_61 > 0 then
			local var4_61 = ChargeConst.getGroupLimit(arg0_61.normalGroupList, var3_61)

			var0_61:updateGroupCount(var4_61)
		end
	end

	return var0_61
end

return var0_0
