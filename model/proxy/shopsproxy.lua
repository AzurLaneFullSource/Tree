local var0 = class("ShopsProxy", import(".NetProxy"))

var0.MERITOROUS_SHOP_UPDATED = "ShopsProxy:MERITOROUS_SHOP_UPDATED"
var0.SHOPPINGSTREET_UPDATE = "ShopsProxy:SHOPPINGSTREET_UPDATE"
var0.FIRST_CHARGE_IDS_UPDATED = "ShopsProxy:FIRST_CHARGE_IDS_UPDATED"
var0.CHARGED_LIST_UPDATED = "ShopsProxy:CHARGED_LIST_UPDATED"
var0.NORMAL_LIST_UPDATED = "ShopsProxy:NORMAL_LIST_UPDATED"
var0.NORMAL_GROUP_LIST_UPDATED = "ShopsProxy:NORMAL_GROUP_LIST_UPDATED"
var0.ACTIVITY_SHOP_UPDATED = "ShopsProxy:ACTIVITY_SHOP_UPDATED"
var0.GUILD_SHOP_ADDED = "ShopsProxy:GUILD_SHOP_ADDED"
var0.GUILD_SHOP_UPDATED = "ShopsProxy:GUILD_SHOP_UPDATED"
var0.ACTIVITY_SHOPS_UPDATED = "ShopsProxy:ACTIVITY_SHOPS_UPDATED"
var0.SHAM_SHOP_UPDATED = "ShopsProxy:SHAM_SHOP_UPDATED"
var0.FRAGMENT_SHOP_UPDATED = "ShopsProxy:FRAGMENT_SHOP_UPDATED"
var0.ACTIVITY_SHOP_GOODS_UPDATED = "ShopsProxy:ACTIVITY_SHOP_GOODS_UPDATED"
var0.META_SHOP_GOODS_UPDATED = "ShopsProxy:META_SHOP_GOODS_UPDATED"
var0.MEDAL_SHOP_UPDATED = "ShopsProxy:MEDAL_SHOP_UPDATED"
var0.QUOTA_SHOP_UPDATED = "ShopsProxy:QUOTA_SHOP_UPDATED"

function var0.register(arg0)
	arg0.shopStreet = nil
	arg0.meritorousShop = nil
	arg0.guildShop = nil
	arg0.refreshChargeList = false
	arg0.metaShop = nil
	arg0.miniShop = nil

	arg0:on(22102, function(arg0)
		local var0 = getProxy(ShopsProxy)
		local var1 = ShoppingStreet.New(arg0.street)

		var0:setShopStreet(var1)
	end)

	arg0.shamShop = ShamBattleShop.New()
	arg0.fragmentShop = FragmentShop.New()

	arg0:on(16200, function(arg0)
		arg0.shamShop:update(arg0.month, arg0.core_shop_list)
		arg0.fragmentShop:update(arg0.month, arg0.blue_shop_list, arg0.normal_shop_list)
	end)

	arg0.timers = {}
	arg0.tradeNoPrev = ""

	local var0 = pg.shop_template

	arg0.freeGiftIdList = {}

	for iter0, iter1 in pairs(var0.all) do
		if var0[iter1].genre == "gift_package" and var0[iter1].discount == 100 then
			table.insert(arg0.freeGiftIdList, iter1)
		end
	end
end

function var0.setShopStreet(arg0, arg1)
	arg0.shopStreet = arg1

	arg0:sendNotification(var0.SHOPPINGSTREET_UPDATE, {
		shopStreet = Clone(arg0.shopStreet)
	})
end

function var0.UpdateShopStreet(arg0, arg1)
	arg0.shopStreet = arg1
end

function var0.getShopStreet(arg0)
	return Clone(arg0.shopStreet)
end

function var0.getMeritorousShop(arg0)
	return Clone(arg0.meritorousShop)
end

function var0.addMeritorousShop(arg0, arg1)
	arg0.meritorousShop = arg1

	arg0:sendNotification(var0.MERITOROUS_SHOP_UPDATED, Clone(arg1))
end

function var0.updateMeritorousShop(arg0, arg1)
	arg0.meritorousShop = arg1
end

function var0.getMiniShop(arg0)
	return Clone(arg0.miniShop)
end

function var0.setMiniShop(arg0, arg1)
	arg0.miniShop = arg1
end

function var0.setNormalList(arg0, arg1)
	arg0.normalList = arg1 or {}
end

function var0.GetNormalList(arg0)
	return Clone(arg0.normalList)
end

function var0.GetNormalByID(arg0, arg1)
	if not arg0.normalList then
		arg0.normalList = {}
	end

	local var0 = arg0.normalList[arg1] or Goods.Create({
		buyCount = 0,
		id = arg1
	}, Goods.TYPE_GIFT_PACKAGE)

	arg0.normalList[arg1] = var0

	return arg0.normalList[arg1]
end

function var0.updateNormalByID(arg0, arg1)
	arg0.normalList[arg1.id] = arg1
end

function var0.checkHasFreeNormal(arg0)
	for iter0, iter1 in ipairs(arg0.freeGiftIdList) do
		if arg0:checkNormalCanPurchase(iter1) then
			return true
		end
	end

	return false
end

function var0.checkNormalCanPurchase(arg0, arg1)
	if arg0.normalList[arg1] ~= nil then
		local var0 = arg0.normalList[arg1]

		if not var0:inTime() then
			return false
		end

		local var1 = var0:getConfig("group") or 0

		if var1 > 0 then
			local var2 = var0:getConfig("group_limit")
			local var3 = arg0:getGroupLimit(var1)

			return var2 > 0 and var3 < var2
		elseif var0:canPurchase() then
			return true
		end
	else
		return arg0:GetNormalByID(arg1):inTime()
	end
end

function var0.setNormalGroupList(arg0, arg1)
	arg0.normalGroupList = arg1
end

function var0.GetNormalGroupList(arg0)
	return arg0.normalGroupList
end

function var0.updateNormalGroupList(arg0, arg1, arg2)
	if arg1 <= 0 then
		return
	end

	for iter0, iter1 in ipairs(arg0.normalGroupList) do
		if iter1.shop_id == arg1 then
			local var0 = arg0.normalGroupList[iter0].pay_count or 0

			arg0.normalGroupList[iter0].pay_count = var0 + arg2

			return
		end
	end

	table.insert(arg0.normalGroupList, {
		shop_id = arg1,
		pay_count = arg2
	})
end

function var0.getGroupLimit(arg0, arg1)
	if not arg0.normalGroupList then
		return 0
	end

	for iter0, iter1 in ipairs(arg0.normalGroupList) do
		if iter1.shop_id == arg1 then
			return iter1.pay_count
		end
	end

	return 0
end

function var0.addActivityShops(arg0, arg1)
	arg0.activityShops = arg1

	arg0:sendNotification(var0.ACTIVITY_SHOPS_UPDATED)
end

function var0.getActivityShopById(arg0, arg1)
	assert(arg0.activityShops[arg1], "activity shop should exist" .. arg1)

	return arg0.activityShops[arg1]
end

function var0.updateActivityShop(arg0, arg1, arg2)
	assert(arg0.activityShops, "activityShops can not be nil")

	arg0.activityShops[arg1] = arg2

	arg0:sendNotification(var0.ACTIVITY_SHOP_UPDATED, {
		activityId = arg1,
		shop = arg2:clone()
	})
end

function var0.UpdateActivityGoods(arg0, arg1, arg2, arg3)
	local var0 = arg0:getActivityShopById(arg1)

	var0:getGoodsById(arg2):addBuyCount(arg3)

	arg0.activityShops[arg1] = var0

	arg0:sendNotification(var0.ACTIVITY_SHOP_GOODS_UPDATED, {
		activityId = arg1,
		goodsId = arg2
	})
end

function var0.getActivityShops(arg0)
	return arg0.activityShops
end

function var0.setFirstChargeList(arg0, arg1)
	arg0.firstChargeList = arg1

	arg0:sendNotification(var0.FIRST_CHARGE_IDS_UPDATED, Clone(arg1))
end

function var0.getFirstChargeList(arg0)
	return Clone(arg0.firstChargeList)
end

function var0.setChargedList(arg0, arg1)
	arg0.chargeList = arg1

	arg0:sendNotification(var0.CHARGED_LIST_UPDATED, Clone(arg1))
end

function var0.getChargedList(arg0)
	return Clone(arg0.chargeList)
end

local var1 = 3
local var2 = 10

function var0.chargeFailed(arg0, arg1, arg2)
	if not arg0.timers[arg1] then
		pg.UIMgr.GetInstance():LoadingOn()

		arg0.timers[arg1] = Timer.New(function()
			if arg0.timers[arg1].loop == 1 then
				pg.UIMgr.GetInstance():LoadingOff()
			end

			PaySuccess(arg1, arg2)
		end, var1, var2)

		arg0.timers[arg1]:Start()
	end
end

function var0.removeChargeTimer(arg0, arg1)
	if arg0.timers[arg1] then
		pg.UIMgr.GetInstance():LoadingOff()
		arg0.timers[arg1]:Stop()

		arg0.timers[arg1] = nil
	end
end

function var0.addWaitTimer(arg0)
	pg.UIMgr.GetInstance():LoadingOn()

	arg0.waitBiliTimer = Timer.New(function()
		arg0:removeWaitTimer()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("charge_time_out")
		})
	end, 25, 1)

	arg0.waitBiliTimer:Start()
end

function var0.removeWaitTimer(arg0)
	if arg0.waitBiliTimer then
		pg.UIMgr.GetInstance():LoadingOff()
		arg0.waitBiliTimer:Stop()

		arg0.waitBiliTimer = nil
	end
end

function var0.setGuildShop(arg0, arg1)
	assert(isa(arg1, GuildShop), "shop should instance of GuildShop")
	assert(arg0.guildShop == nil, "shop already exist")

	arg0.guildShop = arg1

	arg0:sendNotification(var0.GUILD_SHOP_ADDED, arg0.guildShop)
end

function var0.getGuildShop(arg0)
	return arg0.guildShop
end

function var0.updateGuildShop(arg0, arg1, arg2)
	assert(isa(arg1, GuildShop), "shop should instance of GuildShop")
	assert(arg0.guildShop, "should exist shop")

	arg0.guildShop = arg1

	arg0:sendNotification(var0.GUILD_SHOP_UPDATED, {
		shop = arg0.guildShop,
		reset = arg2
	})
end

function var0.AddShamShop(arg0, arg1)
	arg0.shamShop = arg1

	arg0:sendNotification(var0.SHAM_SHOP_UPDATED, arg1)
end

function var0.updateShamShop(arg0, arg1)
	arg0.shamShop = arg1
end

function var0.getShamShop(arg0)
	return arg0.shamShop
end

function var0.AddFragmentShop(arg0, arg1)
	arg0.fragmentShop = arg1

	arg0:sendNotification(var0.FRAGMENT_SHOP_UPDATED, arg1)
end

function var0.updateFragmentShop(arg0, arg1)
	arg0.fragmentShop = arg1
end

function var0.getFragmentShop(arg0)
	return arg0.fragmentShop
end

function var0.AddMetaShop(arg0, arg1)
	arg0.metaShop = arg1
end

function var0.GetMetaShop(arg0)
	return arg0.metaShop
end

function var0.UpdateMetaShopGoods(arg0, arg1, arg2)
	arg0:GetMetaShop():getGoodsById(arg1):addBuyCount(arg2)
	arg0:sendNotification(var0.META_SHOP_GOODS_UPDATED, {
		goodsId = arg1
	})
end

function var0.SetNewServerShop(arg0, arg1)
	arg0.newServerShop = arg1
end

function var0.GetNewServerShop(arg0)
	return arg0.newServerShop
end

function var0.SetMedalShop(arg0, arg1)
	arg0.medalShop = arg1
end

function var0.UpdateMedalShop(arg0, arg1)
	arg0.medalShop = arg1

	arg0:sendNotification(var0.MEDAL_SHOP_UPDATED, arg1)
end

function var0.GetMedalShop(arg0)
	return arg0.medalShop
end

function var0.setQuotaShop(arg0, arg1)
	arg0.quotaShop = arg1
end

function var0.getQuotaShop(arg0)
	return arg0.quotaShop
end

function var0.updateQuotaShop(arg0, arg1, arg2)
	arg0.quotaShop = arg1

	arg0:sendNotification(var0.QUOTA_SHOP_UPDATED, {
		shop = arg0.quotaShop,
		reset = arg2
	})
end

function var0.remove(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = nil

	arg0:removeWaitTimer()
end

function var0.ShouldRefreshChargeList(arg0)
	local var0 = arg0:getFirstChargeList()
	local var1 = arg0:getChargedList()
	local var2 = arg0:GetNormalList()
	local var3 = arg0:GetNormalGroupList()

	return not var0 or not var1 or not var2 or not var3 or arg0.refreshChargeList
end

function var0.GetRecommendCommodities(arg0)
	local var0 = arg0:getChargedList()
	local var1 = arg0:GetNormalList()
	local var2 = arg0:GetNormalGroupList()

	if not var0 or not var1 or not var2 then
		return {}
	end

	local var3 = {}

	for iter0, iter1 in ipairs(pg.recommend_shop.all) do
		local var4 = pg.recommend_shop[iter1].time

		if pg.TimeMgr.GetInstance():inTime(var4) then
			local var5 = RecommendCommodity.New({
				id = iter1,
				chargedList = var0,
				normalList = var1,
				normalGroupList = var2
			})

			if var5:CanShow() then
				table.insert(var3, var5)
			end
		end
	end

	table.sort(var3, function(arg0, arg1)
		return arg0:GetOrder() < arg1:GetOrder()
	end)

	return var3
end

function var0.GetGiftCommodity(arg0, arg1, arg2)
	local var0 = Goods.Create({
		shop_id = arg1
	}, arg2)

	if var0:isChargeType() then
		local var1 = ChargeConst.getBuyCount(arg0.chargeList, var0.id)

		var0:updateBuyCount(var1)
	else
		local var2 = ChargeConst.getBuyCount(arg0.normalList, var0.id)

		var0:updateBuyCount(var2)

		local var3 = var0:getConfig("group") or 0

		if var3 > 0 then
			local var4 = ChargeConst.getGroupLimit(arg0.normalGroupList, var3)

			var0:updateGroupCount(var4)
		end
	end

	return var0
end

return var0
