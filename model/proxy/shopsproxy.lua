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
var0_0.CRUISE_SHOP_UPDATED = "ShopsProxy:CRUISE_SHOP_UPDATED"

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

function var0_0.timeCall(arg0_4)
	return {
		[ProxyRegister.DayCall] = function(arg0_5, arg1_5)
			local var0_5 = arg0_4:getShopStreet()

			if var0_5 then
				var0_5:resetflashCount()
				arg0_4:setShopStreet(var0_5)
			end

			arg0_4.refreshChargeList = true

			local var1_5 = arg0_4:getMiniShop()

			if var1_5 and var1_5:checkShopFlash() then
				pg.m02:sendNotification(GAME.MINI_GAME_SHOP_FLUSH)
			end

			if arg0_5 == 1 then
				arg0_4.shamShop:update(arg1_5.month, {})
				arg0_4:AddShamShop(arg0_4.shamShop)
				arg0_4.fragmentShop:Reset(arg1_5.month)
				arg0_4:AddFragmentShop(arg0_4.fragmentShop)

				if not LOCK_UR_SHIP then
					local var2_5 = pg.gameset.urpt_chapter_max.description[1]

					getProxy(BagProxy):ClearLimitCnt(var2_5)
				end
			end
		end
	}
end

function var0_0.setShopStreet(arg0_6, arg1_6)
	arg0_6.shopStreet = arg1_6

	arg0_6:sendNotification(var0_0.SHOPPINGSTREET_UPDATE, {
		shopStreet = Clone(arg0_6.shopStreet)
	})
end

function var0_0.UpdateShopStreet(arg0_7, arg1_7)
	arg0_7.shopStreet = arg1_7
end

function var0_0.getShopStreet(arg0_8)
	return Clone(arg0_8.shopStreet)
end

function var0_0.getMeritorousShop(arg0_9)
	return Clone(arg0_9.meritorousShop)
end

function var0_0.addMeritorousShop(arg0_10, arg1_10)
	arg0_10.meritorousShop = arg1_10

	arg0_10:sendNotification(var0_0.MERITOROUS_SHOP_UPDATED, Clone(arg1_10))
end

function var0_0.updateMeritorousShop(arg0_11, arg1_11)
	arg0_11.meritorousShop = arg1_11
end

function var0_0.getMiniShop(arg0_12)
	return Clone(arg0_12.miniShop)
end

function var0_0.setMiniShop(arg0_13, arg1_13)
	arg0_13.miniShop = arg1_13
end

function var0_0.setNormalList(arg0_14, arg1_14)
	arg0_14.normalList = arg1_14 or {}
end

function var0_0.GetNormalList(arg0_15)
	return Clone(arg0_15.normalList)
end

function var0_0.GetNormalByID(arg0_16, arg1_16)
	if not arg0_16.normalList then
		arg0_16.normalList = {}
	end

	local var0_16 = arg0_16.normalList[arg1_16] or Goods.Create({
		buyCount = 0,
		id = arg1_16
	}, Goods.TYPE_GIFT_PACKAGE)

	arg0_16.normalList[arg1_16] = var0_16

	return arg0_16.normalList[arg1_16]
end

function var0_0.updateNormalByID(arg0_17, arg1_17)
	arg0_17.normalList[arg1_17.id] = arg1_17
end

function var0_0.checkHasFreeNormal(arg0_18)
	for iter0_18, iter1_18 in ipairs(arg0_18.freeGiftIdList) do
		if arg0_18:checkNormalCanPurchase(iter1_18) then
			return true
		end
	end

	return false
end

function var0_0.checkNormalCanPurchase(arg0_19, arg1_19)
	if arg0_19.normalList[arg1_19] ~= nil then
		local var0_19 = arg0_19.normalList[arg1_19]

		if not var0_19:inTime() then
			return false
		end

		local var1_19 = var0_19:getConfig("group") or 0

		if var1_19 > 0 then
			local var2_19 = var0_19:getConfig("group_limit")
			local var3_19 = arg0_19:getGroupLimit(var1_19)

			return var2_19 > 0 and var3_19 < var2_19
		elseif var0_19:canPurchase() then
			return true
		end
	else
		return arg0_19:GetNormalByID(arg1_19):inTime()
	end
end

function var0_0.setNormalGroupList(arg0_20, arg1_20)
	arg0_20.normalGroupList = arg1_20
end

function var0_0.GetNormalGroupList(arg0_21)
	return arg0_21.normalGroupList
end

function var0_0.updateNormalGroupList(arg0_22, arg1_22, arg2_22)
	if arg1_22 <= 0 then
		return
	end

	for iter0_22, iter1_22 in ipairs(arg0_22.normalGroupList) do
		if iter1_22.shop_id == arg1_22 then
			local var0_22 = arg0_22.normalGroupList[iter0_22].pay_count or 0

			arg0_22.normalGroupList[iter0_22].pay_count = var0_22 + arg2_22

			return
		end
	end

	table.insert(arg0_22.normalGroupList, {
		shop_id = arg1_22,
		pay_count = arg2_22
	})
end

function var0_0.getGroupLimit(arg0_23, arg1_23)
	if not arg0_23.normalGroupList then
		return 0
	end

	for iter0_23, iter1_23 in ipairs(arg0_23.normalGroupList) do
		if iter1_23.shop_id == arg1_23 then
			return iter1_23.pay_count
		end
	end

	return 0
end

function var0_0.addActivityShops(arg0_24, arg1_24)
	arg0_24.activityShops = arg1_24

	arg0_24:sendNotification(var0_0.ACTIVITY_SHOPS_UPDATED)
end

function var0_0.getActivityShopById(arg0_25, arg1_25)
	assert(arg0_25.activityShops[arg1_25], "activity shop should exist" .. arg1_25)

	return arg0_25.activityShops[arg1_25]
end

function var0_0.updateActivityShop(arg0_26, arg1_26, arg2_26)
	assert(arg0_26.activityShops, "activityShops can not be nil")

	arg0_26.activityShops[arg1_26] = arg2_26

	arg0_26:sendNotification(var0_0.ACTIVITY_SHOP_UPDATED, {
		activityId = arg1_26,
		shop = arg2_26:clone()
	})
end

function var0_0.UpdateActivityGoods(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg0_27:getActivityShopById(arg1_27)

	var0_27:getGoodsById(arg2_27):addBuyCount(arg3_27)

	arg0_27.activityShops[arg1_27] = var0_27

	arg0_27:sendNotification(var0_0.ACTIVITY_SHOP_GOODS_UPDATED, {
		activityId = arg1_27,
		goodsId = arg2_27
	})
end

function var0_0.getActivityShops(arg0_28)
	return arg0_28.activityShops
end

function var0_0.setFirstChargeList(arg0_29, arg1_29)
	arg0_29.firstChargeList = arg1_29

	arg0_29:sendNotification(var0_0.FIRST_CHARGE_IDS_UPDATED, Clone(arg1_29))
end

function var0_0.getFirstChargeList(arg0_30)
	return Clone(arg0_30.firstChargeList)
end

function var0_0.setChargedList(arg0_31, arg1_31)
	arg0_31.chargeList = arg1_31

	arg0_31:sendNotification(var0_0.CHARGED_LIST_UPDATED, Clone(arg1_31))
end

function var0_0.getChargedList(arg0_32)
	return Clone(arg0_32.chargeList)
end

local var1_0 = 3
local var2_0 = 10

function var0_0.chargeFailed(arg0_33, arg1_33, arg2_33)
	if not arg0_33.timers[arg1_33] then
		pg.UIMgr.GetInstance():LoadingOn()

		arg0_33.timers[arg1_33] = Timer.New(function()
			if arg0_33.timers[arg1_33].loop == 1 then
				pg.UIMgr.GetInstance():LoadingOff()
			end

			PaySuccess(arg1_33, arg2_33)
		end, var1_0, var2_0)

		arg0_33.timers[arg1_33]:Start()
	end
end

function var0_0.removeChargeTimer(arg0_35, arg1_35)
	if arg0_35.timers[arg1_35] then
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_35.timers[arg1_35]:Stop()

		arg0_35.timers[arg1_35] = nil
	end
end

function var0_0.addWaitTimer(arg0_36)
	pg.UIMgr.GetInstance():LoadingOn()

	arg0_36.waitBiliTimer = Timer.New(function()
		arg0_36:removeWaitTimer()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("charge_time_out")
		})
	end, 25, 1)

	arg0_36.waitBiliTimer:Start()
end

function var0_0.removeWaitTimer(arg0_38)
	if arg0_38.waitBiliTimer then
		pg.UIMgr.GetInstance():LoadingOff()
		arg0_38.waitBiliTimer:Stop()

		arg0_38.waitBiliTimer = nil
	end
end

function var0_0.setGuildShop(arg0_39, arg1_39)
	assert(isa(arg1_39, GuildShop), "shop should instance of GuildShop")
	assert(arg0_39.guildShop == nil, "shop already exist")

	arg0_39.guildShop = arg1_39

	arg0_39:sendNotification(var0_0.GUILD_SHOP_ADDED, arg0_39.guildShop)
end

function var0_0.getGuildShop(arg0_40)
	return arg0_40.guildShop
end

function var0_0.updateGuildShop(arg0_41, arg1_41, arg2_41)
	assert(isa(arg1_41, GuildShop), "shop should instance of GuildShop")
	assert(arg0_41.guildShop, "should exist shop")

	arg0_41.guildShop = arg1_41

	arg0_41:sendNotification(var0_0.GUILD_SHOP_UPDATED, {
		shop = arg0_41.guildShop,
		reset = arg2_41
	})
end

function var0_0.AddShamShop(arg0_42, arg1_42)
	arg0_42.shamShop = arg1_42

	arg0_42:sendNotification(var0_0.SHAM_SHOP_UPDATED, arg1_42)
end

function var0_0.updateShamShop(arg0_43, arg1_43)
	arg0_43.shamShop = arg1_43
end

function var0_0.getShamShop(arg0_44)
	return arg0_44.shamShop
end

function var0_0.AddFragmentShop(arg0_45, arg1_45)
	arg0_45.fragmentShop = arg1_45

	arg0_45:sendNotification(var0_0.FRAGMENT_SHOP_UPDATED, arg1_45)
end

function var0_0.updateFragmentShop(arg0_46, arg1_46)
	arg0_46.fragmentShop = arg1_46
end

function var0_0.getFragmentShop(arg0_47)
	return arg0_47.fragmentShop
end

function var0_0.AddMetaShop(arg0_48, arg1_48)
	arg0_48.metaShop = arg1_48
end

function var0_0.GetMetaShop(arg0_49)
	return arg0_49.metaShop
end

function var0_0.UpdateMetaShopGoods(arg0_50, arg1_50, arg2_50)
	arg0_50:GetMetaShop():getGoodsById(arg1_50):addBuyCount(arg2_50)
	arg0_50:sendNotification(var0_0.META_SHOP_GOODS_UPDATED, {
		goodsId = arg1_50
	})
end

function var0_0.SetNewServerShop(arg0_51, arg1_51)
	arg0_51.newServerShop = arg1_51
end

function var0_0.GetNewServerShop(arg0_52)
	return arg0_52.newServerShop
end

function var0_0.SetMedalShop(arg0_53, arg1_53)
	arg0_53.medalShop = arg1_53
end

function var0_0.UpdateMedalShop(arg0_54, arg1_54)
	arg0_54.medalShop = arg1_54

	arg0_54:sendNotification(var0_0.MEDAL_SHOP_UPDATED, arg1_54)
end

function var0_0.GetMedalShop(arg0_55)
	return arg0_55.medalShop
end

function var0_0.setQuotaShop(arg0_56, arg1_56)
	arg0_56.quotaShop = arg1_56
end

function var0_0.getQuotaShop(arg0_57)
	return arg0_57.quotaShop
end

function var0_0.updateQuotaShop(arg0_58, arg1_58, arg2_58)
	arg0_58.quotaShop = arg1_58

	arg0_58:sendNotification(var0_0.QUOTA_SHOP_UPDATED, {
		shop = arg0_58.quotaShop,
		reset = arg2_58
	})
end

function var0_0.SetCruiseShop(arg0_59, arg1_59)
	arg0_59.cruiseShop = arg1_59
end

function var0_0.UpdateCruiseShop(arg0_60)
	arg0_60.cruiseShop = CruiseShop.New(arg0_60:GetNormalList(), arg0_60:GetNormalGroupList())

	arg0_60:sendNotification(var0_0.CRUISE_SHOP_UPDATED, {
		shop = arg0_60.cruiseShop
	})
end

function var0_0.GetCruiseShop(arg0_61)
	return arg0_61.cruiseShop
end

function var0_0.remove(arg0_62)
	for iter0_62, iter1_62 in pairs(arg0_62.timers) do
		iter1_62:Stop()
	end

	arg0_62.timers = nil

	arg0_62:removeWaitTimer()
end

function var0_0.ShouldRefreshChargeList(arg0_63)
	local var0_63 = arg0_63:getFirstChargeList()
	local var1_63 = arg0_63:getChargedList()
	local var2_63 = arg0_63:GetNormalList()
	local var3_63 = arg0_63:GetNormalGroupList()

	return not var0_63 or not var1_63 or not var2_63 or not var3_63 or arg0_63.refreshChargeList
end

function var0_0.GetRecommendCommodities(arg0_64)
	local var0_64 = arg0_64:getChargedList()
	local var1_64 = arg0_64:GetNormalList()
	local var2_64 = arg0_64:GetNormalGroupList()

	if not var0_64 or not var1_64 or not var2_64 then
		return {}
	end

	local var3_64 = {}

	for iter0_64, iter1_64 in ipairs(pg.recommend_shop.all) do
		local var4_64 = pg.recommend_shop[iter1_64].time

		if pg.TimeMgr.GetInstance():inTime(var4_64) then
			local var5_64 = RecommendCommodity.New({
				id = iter1_64,
				chargedList = var0_64,
				normalList = var1_64,
				normalGroupList = var2_64
			})

			if var5_64:CanShow() then
				table.insert(var3_64, var5_64)
			end
		end
	end

	table.sort(var3_64, function(arg0_65, arg1_65)
		return arg0_65:GetOrder() < arg1_65:GetOrder()
	end)

	return var3_64
end

function var0_0.GetGiftCommodity(arg0_66, arg1_66, arg2_66)
	local var0_66 = Goods.Create({
		shop_id = arg1_66
	}, arg2_66)

	if var0_66:isChargeType() then
		local var1_66 = ChargeConst.getBuyCount(arg0_66.chargeList, var0_66.id)

		var0_66:updateBuyCount(var1_66)
	else
		local var2_66 = ChargeConst.getBuyCount(arg0_66.normalList, var0_66.id)

		var0_66:updateBuyCount(var2_66)

		local var3_66 = var0_66:getConfig("group") or 0

		if var3_66 > 0 then
			local var4_66 = ChargeConst.getGroupLimit(arg0_66.normalGroupList, var3_66)

			var0_66:updateGroupCount(var4_66)
		end
	end

	return var0_66
end

function var0_0.GetGroupPayCount(arg0_67, arg1_67)
	for iter0_67, iter1_67 in ipairs(arg0_67.normalGroupList) do
		if iter1_67.shop_id == arg1_67 then
			return arg0_67.normalGroupList[iter0_67].pay_count or 0
		end
	end

	return 0
end

return var0_0
