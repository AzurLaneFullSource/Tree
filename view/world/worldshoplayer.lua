local var0 = class("WorldShopLayer", import("view.base.BaseUI"))

var0.Listeners = {
	onUpdateGoods = "updateGoods"
}
var0.optionsPath = {
	"adapt/top/title/option"
}

function var0.getUIName(arg0)
	return "WorldShopUI"
end

function var0.getBGM(arg0)
	return "story-richang"
end

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.btnBack = arg0:findTF("adapt/top/title/back_button")
	arg0.rtRes = arg0:findTF("adapt/middle/content/res")
	arg0.rtResetTime = arg0:findTF("adapt/middle/content/resetTimer")
	arg0.rtResetTip = arg0:findTF("adapt/middle/content/resetTip")
	arg0.rtShop = arg0:findTF("adapt/middle/content/world_shop")
	arg0.goodsItemList = UIItemList.New(arg0.rtShop:Find("content"), arg0.rtShop:Find("content/item_tpl"))
	arg0.singleWindow = OriginShopSingleWindow.New(arg0._tf, arg0.event)
	arg0.multiWindow = OriginShopMultiWindow.New(arg0._tf, arg0.event)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf, {
		groupName = arg0:getGroupNameFromData()
	})
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.rtRes, function()
		arg0:emit(var0.ON_DROP, {
			type = DROP_TYPE_RESOURCE,
			id = WorldConst.ResourceID
		})
	end, SFX_PANEL)
	arg0.goodsItemList:make(function(arg0, arg1, arg2)
		local var0 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var1 = Goods.Create(arg0.goodsList[var0], Goods.TYPE_WORLD)

			GoodsCard.New(arg2):update(var1)

			local var2 = var1:getLimitCount()

			setText(arg2:Find("item/count_contain/label"), i18n("activity_shop_exchange_count"))
			setText(arg2:Find("item/count_contain/count"), var2 - var1.buyCount .. "/" .. var2)
			setTextColor(arg2:Find("item/count_contain/count"), Color.New(unpack(ActivityGoodsCard.DefaultColor)))
			setTextColor(arg2:Find("item/count_contain/label"), Color.New(unpack(ActivityGoodsCard.DefaultColor)))
			onButton(arg0, arg2, function()
				local var0 = nowWorld()

				if var1:getConfig("genre") == ShopArgs.WorldCollection and var0:GetTaskProxy():hasDoingCollectionTask() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("world_collection_task_tip_1"))

					return
				elseif var1.id == 100000 and not underscore.any(underscore.values(var0.pressingAwardDic), function(arg0)
					return arg0.flag
				end) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("world_complete_item_tip"))

					return
				end

				if not var1:canPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				;(var2 > 1 and arg0.multiWindow or arg0.singleWindow):ExecuteAction("Open", var1, function(arg0, arg1)
					arg0:emit(WorldShopMediator.BUY_ITEM, arg0.id, arg1)
				end)
			end, SFX_PANEL)
		end
	end)
	arg0:AddWorldListener()

	local var0 = nowWorld()

	arg0:updateGoods(nil, nil, var0:GetWorldShopGoodsDictionary())

	local var1 = var0:IsReseted()

	setActive(arg0.rtResetTime, var1)
	setActive(arg0.rtResetTip, not var1)
	setText(arg0.rtResetTime:Find("number"), math.floor(var0:GetResetWaitingTime() / 86400))
	setText(arg0.rtResetTip:Find("info"), i18n("world_shop_preview_tip"))

	if var1 then
		WorldGuider.GetInstance():PlayGuide("WorldG180")
	end
end

function var0.onBackPressed(arg0)
	if arg0.singleWindow:isShowing() then
		arg0.singleWindow:Close()

		return
	end

	if arg0.multiWindow:isShowing() then
		arg0.multiWindow:Close()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	triggerButton(arg0.btnBack)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0:RemoveWorldListener()
	arg0.singleWindow:Destroy()
	arg0.multiWindow:Destroy()
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = WorldConst.ResourceID
	}):getIcon(), "", arg0.rtRes:Find("icon"), true)
	setText(arg0.rtRes:Find("number"), arg0.player:getResource(WorldConst.ResourceID))
end

function var0.AddWorldListener(arg0)
	nowWorld():AddListener(World.EventUpdateShopGoods, arg0.onUpdateGoods)
end

function var0.RemoveWorldListener(arg0)
	nowWorld():RemoveListener(World.EventUpdateShopGoods, arg0.onUpdateGoods)
end

function var0.updateGoods(arg0, arg1, arg2, arg3)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = nowWorld()
	local var2 = var1.expiredTime
	local var3 = var1:GetTaskProxy()
	local var4 = {}

	for iter0, iter1 in pairs(arg3) do
		if not var0:inTime(pg.shop_template[iter0].time) or not var0:inTime(pg.shop_template[iter0].time, var2 - 1) then
			-- block empty
		elseif iter0 == 100000 and not nowWorld():IsReseted() then
			-- block empty
		elseif pg.shop_template[iter0].genre == ShopArgs.WorldCollection and iter1 == 0 and var3:getRecycleTask(pg.shop_template[iter0].effect_args[2]) then
			-- block empty
		else
			table.insert(var4, {
				id = iter0,
				count = iter1
			})
		end
	end

	table.sort(var4, CompareFuncs({
		function(arg0)
			return pg.shop_template[arg0.id].order
		end,
		function(arg0)
			return arg0.id
		end
	}))

	arg0.goodsList = var4

	arg0.goodsItemList:align(#arg0.goodsList)
end

return var0
