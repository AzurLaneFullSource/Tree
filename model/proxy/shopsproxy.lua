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
		if var0_1[iter1_1].genre == ShopArgs.GiftPackage and var0_1[iter1_1].discount == 100 then
			table.insert(arg0_1.freeGiftIdList, iter1_1)
		end
	end

	arg0_1.newServerShopList = {}
	arg0_1.activityShops = {}
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

function var0_0.getActivityShopById(arg0_24, arg1_24)
	if not arg0_24.activityShops[arg1_24] then
		local var0_24 = getProxy(ActivityProxy):getActivityById(arg1_24)
		local var1_24 = var0_24 and not var0_24:isEnd() and ActivityShop.New(var0_24)

		arg0_24.activityShops[arg1_24] = var1_24
	end

	return arg0_24.activityShops[arg1_24]
end

function var0_0.updateActivityShop(arg0_25, arg1_25, arg2_25)
	assert(arg0_25.activityShops, "activityShops can not be nil")

	arg0_25.activityShops[arg1_25] = arg2_25:sendselfNotification(var0_0.ACTIVITY_SHOP_UPDATED, {
		activityId = arg1_25,
		shop = arg2_25:clone()
	})
end

function var0_0.UpdateActivityGoods(arg0_26, arg1_26, arg2_26, arg3_26)
	local var0_26 = arg0_26:getActivityShopById(arg1_26)

	var0_26:getGoodsById(arg2_26):addBuyCount(arg3_26)

	arg0_26.activityShops[arg1_26] = var0_26

	arg0_26:sendNotification(var0_0.ACTIVITY_SHOP_GOODS_UPDATED, {
		activityId = arg1_26,
		goodsId = arg2_26
	})
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

function var0_0.SetNewServerShop(arg0_49, arg1_49, arg2_49)
	arg0_49.newServerShopList[arg1_49] = arg2_49
end

function var0_0.GetNewServerShop(arg0_50, arg1_50)
	return arg0_50.newServerShopList[arg1_50]
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

function var0_0.SetCruiseShop(arg0_57, arg1_57)
	arg0_57.cruiseShop = arg1_57
end

function var0_0.UpdateCruiseShop(arg0_58)
	arg0_58.cruiseShop = CruiseShop.New(arg0_58:GetNormalList(), arg0_58:GetNormalGroupList())

	arg0_58:sendNotification(var0_0.CRUISE_SHOP_UPDATED, {
		shop = arg0_58.cruiseShop
	})
end

function var0_0.GetCruiseShop(arg0_59)
	return arg0_59.cruiseShop
end

function var0_0.remove(arg0_60)
	for iter0_60, iter1_60 in pairs(arg0_60.timers) do
		iter1_60:Stop()
	end

	arg0_60.timers = nil

	arg0_60:removeWaitTimer()
end

function var0_0.ShouldRefreshChargeList(arg0_61)
	local var0_61 = arg0_61:getFirstChargeList()
	local var1_61 = arg0_61:getChargedList()
	local var2_61 = arg0_61:GetNormalList()
	local var3_61 = arg0_61:GetNormalGroupList()

	return not var0_61 or not var1_61 or not var2_61 or not var3_61 or arg0_61.refreshChargeList
end

function var0_0.GetRecommendCommodities(arg0_62)
	local var0_62 = arg0_62:getChargedList()
	local var1_62 = arg0_62:GetNormalList()
	local var2_62 = arg0_62:GetNormalGroupList()

	if not var0_62 or not var1_62 or not var2_62 then
		return {}
	end

	local var3_62 = {}

	for iter0_62, iter1_62 in ipairs(pg.recommend_shop.all) do
		local var4_62 = pg.recommend_shop[iter1_62].time

		if pg.TimeMgr.GetInstance():inTime(var4_62) then
			local var5_62 = RecommendCommodity.New({
				id = iter1_62,
				chargedList = var0_62,
				normalList = var1_62,
				normalGroupList = var2_62
			})

			if var5_62:CanShow() then
				table.insert(var3_62, var5_62)
			end
		end
	end

	table.sort(var3_62, function(arg0_63, arg1_63)
		return arg0_63:GetOrder() < arg1_63:GetOrder()
	end)

	return var3_62
end

function var0_0.GetGiftCommodity(arg0_64, arg1_64, arg2_64)
	local var0_64 = Goods.Create({
		shop_id = arg1_64
	}, arg2_64)

	if var0_64:isChargeType() then
		local var1_64 = ChargeConst.getBuyCount(arg0_64.chargeList, var0_64.id)

		var0_64:updateBuyCount(var1_64)
	else
		local var2_64 = ChargeConst.getBuyCount(arg0_64.normalList, var0_64.id)

		var0_64:updateBuyCount(var2_64)

		local var3_64 = var0_64:getConfig("group") or 0

		if var3_64 > 0 then
			local var4_64 = ChargeConst.getGroupLimit(arg0_64.normalGroupList, var3_64)

			var0_64:updateGroupCount(var4_64)
		end
	end

	return var0_64
end

function var0_0.GetGroupPayCount(arg0_65, arg1_65)
	for iter0_65, iter1_65 in ipairs(arg0_65.normalGroupList) do
		if iter1_65.shop_id == arg1_65 then
			return arg0_65.normalGroupList[iter0_65].pay_count or 0
		end
	end

	return 0
end

function var0_0.SpecialBannerBlockCheck(arg0_66, arg1_66)
	if not LOCK_SHOP_BANNER_US then
		return true
	end

	local var0_66, var1_66 = unpack(getGameset("levellimit_shopbanner"))

	return var0_66 <= arg1_66.level or arg0_66.name ~= "banner_big" or table.contains(var1_66, arg0_66.id)
end

function var0_0.GiftPackageRedDotTip(arg0_67, arg1_67, arg2_67)
	local var0_67 = {}

	if arg0_67:ShouldRefreshChargeList() then
		table.insert(var0_67, function(arg0_68)
			pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
				callback = arg0_68
			})
		end)
	end

	seriesAsync(var0_67, function()
		local var0_69 = underscore.any(arg0_67:GetAllShowGiftPackages(arg2_67), function(arg0_70)
			return arg0_70:isTip()
		end)

		for iter0_69, iter1_69 in ipairs(arg1_67) do
			setActive(iter1_69, var0_69)
		end
	end)
end

function var0_0.GetAllShowGiftPackages(arg0_71, arg1_71)
	assert(not arg0_71:ShouldRefreshChargeList())

	local var0_71 = {}
	local var1_71 = RefluxShopView.getAllRefluxPackID()
	local var2_71 = getProxy(PlayerProxy):getRawData()
	local var3_71 = pg.pay_data_display

	for iter0_71, iter1_71 in pairs(var3_71.all) do
		if not table.contains(var1_71, iter1_71) then
			local var4_71 = var3_71[iter1_71]
			local var5_71 = var4_71.extra_service
			local var6_71 = var4_71.akashi_pick > 0

			if (arg1_71 == nil or var6_71 == arg1_71) and (var5_71 == Goods.ITEM_BOX or var5_71 == Goods.PASS_ITEM) then
				local var7_71 = Goods.Create({
					shop_id = iter1_71
				}, Goods.TYPE_CHARGE)

				if arg0_71:filterLimitTypeGoods(var7_71, var2_71) and arg0_71:IsVaildBattlePass(var7_71) then
					table.insert(var0_71, var7_71)
				end
			end
		end
	end

	for iter2_71, iter3_71 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.GiftPackage] or {}) do
		local var8_71 = ShopConst.GetShopConfig(iter3_71).akashi_pick > 0

		if (arg1_71 == nil or var8_71 == arg1_71) and not table.contains(var1_71, iter3_71) then
			local var9_71 = Goods.Create({
				shop_id = iter3_71
			}, Goods.TYPE_GIFT_PACKAGE)

			table.insert(var0_71, var9_71)
		end
	end

	for iter4_71, iter5_71 in ipairs(pg.shop_template.get_id_list_by_genre[ShopArgs.GiftActPackage] or {}) do
		local var10_71 = ShopConst.GetShopConfig(iter5_71).akashi_pick > 0

		if (arg1_71 == nil or var10_71 == arg1_71) and not table.contains(var1_71, iter5_71) then
			local var11_71 = Goods.Create({
				shop_id = iter5_71
			}, Goods.TYPE_GIFT_PACKAGE_ACT)

			table.insert(var0_71, var11_71)
		end
	end

	local var12_71 = {}
	local var13_71 = {}

	for iter6_71, iter7_71 in ipairs(var0_71) do
		if iter7_71:isChargeType() then
			local var14_71 = ChargeConst.getBuyCount(arg0_71.chargeList, iter7_71.id)

			iter7_71:updateBuyCount(var14_71)

			if iter7_71:canPurchase() and iter7_71:inTime() then
				table.insert(var12_71, iter7_71)
			end
		elseif not iter7_71:isLevelLimit(var2_71.level, true) then
			local var15_71 = ChargeConst.getBuyCount(arg0_71.normalList, iter7_71.id)

			iter7_71:updateBuyCount(var15_71)

			local var16_71 = iter7_71:getConfig("group") or 0
			local var17_71 = false

			if var16_71 > 0 then
				local var18_71 = iter7_71:getConfig("group_limit")
				local var19_71 = ChargeConst.getGroupLimit(arg0_71.normalGroupList, var16_71)

				iter7_71:updateGroupCount(var19_71)

				var17_71 = var18_71 > 0 and var18_71 <= var19_71
			end

			local var20_71, var21_71 = pg.TimeMgr.GetInstance():inTime(iter7_71:getConfig("time"))

			if iter7_71.id == 69999 then
				warning(PrintTable(iter7_71:getConfig("time")), iter7_71.__cname)
				warning(var20_71, var21_71, iter7_71:canPurchase(), var17_71)
			end

			if var21_71 then
				table.insert(var13_71, iter7_71)
			end

			if var20_71 and iter7_71:canPurchase() and not var17_71 then
				table.insert(var12_71, iter7_71)
			end
		end
	end

	return var12_71, var13_71
end

function var0_0.IsVaildBattlePass(arg0_72, arg1_72)
	if not arg1_72:isPassItem() then
		return true
	end

	local var0_72 = arg1_72:getConfig("sub_display")[1]
	local var1_72 = getProxy(ActivityProxy):RawGetActivityById(var0_72)

	if var1_72 and not var1_72:isEnd() then
		return true
	end

	local var2_72, var3_72 = PrevPeriodCrusingActivity.StaticExistPrevPeriodCrusingActivity()

	if var2_72 and var0_72 == var3_72 then
		return true
	end

	return false
end

function var0_0.filterLimitTypeGoods(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg1_73:getConfig("limit_type")

	return switch(var0_73, {
		[3] = function()
			if arg1_73:getConfig("limit_arg") ~= 0 or arg1_73:isLevelLimit(arg2_73.level, true) then
				return false
			end

			local var0_74
			local var1_74
			local var2_74

			for iter0_74, iter1_74 in ipairs(arg1_73:getSameLimitGroupTecGoods()) do
				if iter1_74:getConfig("limit_arg") == 1 then
					var1_74 = iter1_74
				elseif iter1_74:getConfig("limit_arg") == 2 then
					var0_74 = iter1_74
				elseif iter1_74:getConfig("limit_arg") == 3 then
					var2_74 = iter1_74
				end
			end

			local var3_74 = ChargeConst.getBuyCount(arg0_73.chargeList, var0_74.id)
			local var4_74 = ChargeConst.getBuyCount(arg0_73.chargeList, var1_74.id)
			local var5_74 = ChargeConst.getBuyCount(arg0_73.chargeList, var2_74.id)

			if var4_74 > 0 then
				return false
			elseif var3_74 > 0 and var5_74 > 0 then
				return false
			else
				return true
			end
		end,
		[5] = function()
			if arg1_73:getConfig("limit_arg") ~= 0 or arg1_73:isLevelLimit(arg2_73.level, true) then
				return false
			end

			for iter0_75, iter1_75 in ipairs(arg1_73:getSameLimitGroupTecGoods()) do
				if iter1_75:getConfig("limit_arg") ~= 0 and ChargeConst.getBuyCount(arg0_73.chargeList, iter1_75.id) > 0 then
					return false
				end
			end

			return true
		end
	}, function()
		return true
	end)
end

function var0_0.CanPurchasedByCharge(arg0_77, arg1_77)
	local var0_77 = pg.pay_data_display.get_id_list_by_extra_service[Goods.NON_MAIL] or {}

	for iter0_77, iter1_77 in ipairs(var0_77) do
		local var1_77 = pg.pay_data_display[iter1_77].extra_service_item

		if type(var1_77) == "string" then
			var1_77 = {}
		end

		for iter2_77, iter3_77 in ipairs(var1_77) do
			local var2_77 = iter3_77[1]
			local var3_77 = iter3_77[2]
			local var4_77 = iter3_77[3]

			if var2_77 == DROP_TYPE_SKIN and var3_77 == arg1_77 then
				return true, iter1_77
			end
		end
	end

	return false
end

function var0_0.IsSkinTypeCharge(arg0_78, arg1_78)
	local var0_78 = pg.pay_data_display[arg1_78]

	assert(var0_78, "pay_data_display" .. arg1_78)

	local var1_78 = var0_78.extra_service_item

	if type(var1_78) == "string" then
		var1_78 = {}
	end

	for iter0_78, iter1_78 in ipairs(var1_78) do
		local var2_78 = iter1_78[1]
		local var3_78 = iter1_78[2]
		local var4_78 = iter1_78[3]

		if var2_78 == DROP_TYPE_SKIN then
			return true, var3_78
		end
	end

	return false
end

return var0_0
