local var0_0 = class("WorldShopLayer", import("view.base.BaseUI"))

var0_0.Listeners = {
	onUpdateGoods = "updateGoods"
}
var0_0.optionsPath = {
	"adapt/top/title/option"
}

function var0_0.getUIName(arg0_1)
	return "WorldShopUI"
end

function var0_0.getBGM(arg0_2)
	return "story-richang"
end

function var0_0.init(arg0_3)
	for iter0_3, iter1_3 in pairs(var0_0.Listeners) do
		arg0_3[iter0_3] = function(...)
			var0_0[iter1_3](arg0_3, ...)
		end
	end

	arg0_3.btnBack = arg0_3:findTF("adapt/top/title/back_button")
	arg0_3.rtRes = arg0_3:findTF("adapt/middle/content/res")
	arg0_3.rtResetTime = arg0_3:findTF("adapt/middle/content/resetTimer")
	arg0_3.rtResetTip = arg0_3:findTF("adapt/middle/content/resetTip")
	arg0_3.rtShop = arg0_3:findTF("adapt/middle/content/world_shop")
	arg0_3.goodsItemList = UIItemList.New(arg0_3.rtShop:Find("content"), arg0_3.rtShop:Find("content/item_tpl"))
	arg0_3.singleWindow = OriginShopSingleWindow.New(arg0_3._tf, arg0_3.event)
	arg0_3.multiWindow = OriginShopMultiWindow.New(arg0_3._tf, arg0_3.event)
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf, {
		groupName = arg0_5:getGroupNameFromData()
	})
	onButton(arg0_5, arg0_5.btnBack, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.rtRes, function()
		arg0_5:emit(var0_0.ON_DROP, {
			type = DROP_TYPE_RESOURCE,
			id = WorldConst.ResourceID
		})
	end, SFX_PANEL)
	arg0_5.goodsItemList:make(function(arg0_8, arg1_8, arg2_8)
		local var0_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventUpdate then
			local var1_8 = Goods.Create(arg0_5.goodsList[var0_8], Goods.TYPE_WORLD)

			GoodsCard.New(arg2_8):update(var1_8)

			local var2_8 = var1_8:getLimitCount()

			setText(arg2_8:Find("item/count_contain/label"), i18n("activity_shop_exchange_count"))
			setText(arg2_8:Find("item/count_contain/count"), var2_8 - var1_8.buyCount .. "/" .. var2_8)
			setTextColor(arg2_8:Find("item/count_contain/count"), Color.New(unpack(ActivityGoodsCard.DefaultColor)))
			setTextColor(arg2_8:Find("item/count_contain/label"), Color.New(unpack(ActivityGoodsCard.DefaultColor)))
			onButton(arg0_5, arg2_8, function()
				local var0_9 = nowWorld()

				if var1_8:getConfig("genre") == ShopArgs.WorldCollection and var0_9:GetTaskProxy():hasDoingCollectionTask() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("world_collection_task_tip_1"))

					return
				elseif var1_8.id == 100000 and not underscore.any(underscore.values(var0_9.pressingAwardDic), function(arg0_10)
					return arg0_10.flag
				end) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("world_complete_item_tip"))

					return
				end

				if not var1_8:canPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				;(var2_8 > 1 and arg0_5.multiWindow or arg0_5.singleWindow):ExecuteAction("Open", var1_8, function(arg0_11, arg1_11)
					arg0_5:emit(WorldShopMediator.BUY_ITEM, arg0_11.id, arg1_11)
				end)
			end, SFX_PANEL)
		end
	end)
	arg0_5:AddWorldListener()

	local var0_5 = nowWorld()

	arg0_5:updateGoods(nil, nil, var0_5:GetWorldShopGoodsDictionary())

	local var1_5 = var0_5:IsReseted()

	setActive(arg0_5.rtResetTime, var1_5)
	setActive(arg0_5.rtResetTip, not var1_5)
	setText(arg0_5.rtResetTime:Find("number"), math.floor(var0_5:GetResetWaitingTime() / 86400))
	setText(arg0_5.rtResetTip:Find("info"), i18n("world_shop_preview_tip"))

	if var1_5 then
		WorldGuider.GetInstance():PlayGuide("WorldG180")
	end
end

function var0_0.onBackPressed(arg0_12)
	if arg0_12.singleWindow:isShowing() then
		arg0_12.singleWindow:Close()

		return
	end

	if arg0_12.multiWindow:isShowing() then
		arg0_12.multiWindow:Close()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0_12.btnBack)
end

function var0_0.willExit(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf)
	arg0_13:RemoveWorldListener()
	arg0_13.singleWindow:Destroy()
	arg0_13.multiWindow:Destroy()
end

function var0_0.setPlayer(arg0_14, arg1_14)
	arg0_14.player = arg1_14

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = WorldConst.ResourceID
	}):getIcon(), "", arg0_14.rtRes:Find("icon"), true)
	setText(arg0_14.rtRes:Find("number"), arg0_14.player:getResource(WorldConst.ResourceID))
end

function var0_0.AddWorldListener(arg0_15)
	nowWorld():AddListener(World.EventUpdateShopGoods, arg0_15.onUpdateGoods)
end

function var0_0.RemoveWorldListener(arg0_16)
	nowWorld():RemoveListener(World.EventUpdateShopGoods, arg0_16.onUpdateGoods)
end

function var0_0.updateGoods(arg0_17, arg1_17, arg2_17, arg3_17)
	local var0_17 = pg.TimeMgr.GetInstance()
	local var1_17 = nowWorld()
	local var2_17 = var1_17.expiredTime
	local var3_17 = var1_17:GetTaskProxy()
	local var4_17 = {}

	for iter0_17, iter1_17 in pairs(arg3_17) do
		if not var0_17:inTime(pg.shop_template[iter0_17].time) or not var0_17:inTime(pg.shop_template[iter0_17].time, var2_17 - 1) then
			-- block empty
		elseif iter0_17 == 100000 and not nowWorld():IsReseted() then
			-- block empty
		elseif pg.shop_template[iter0_17].genre == ShopArgs.WorldCollection and iter1_17 == 0 and var3_17:getRecycleTask(pg.shop_template[iter0_17].effect_args[2]) then
			-- block empty
		else
			table.insert(var4_17, {
				id = iter0_17,
				count = iter1_17
			})
		end
	end

	table.sort(var4_17, CompareFuncs({
		function(arg0_18)
			return pg.shop_template[arg0_18.id].order
		end,
		function(arg0_19)
			return arg0_19.id
		end
	}))

	arg0_17.goodsList = var4_17

	arg0_17.goodsItemList:align(#arg0_17.goodsList)
end

return var0_0
