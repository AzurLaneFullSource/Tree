local var0_0 = class("IslandTradeConfirmWindow", import(".IslandBaseMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandTradeConfirmUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.panel = arg0_2._tf:Find("panel")
	arg0_2.closeBtn = arg0_2.panel:Find("closeBtn")
	arg0_2.icon = arg0_2.panel:Find("icon")
	arg0_2.name = arg0_2.panel:Find("name"):GetComponent(typeof(Text))
	arg0_2.desc = arg0_2.panel:Find("desc"):GetComponent(typeof(Text))
	arg0_2.count = arg0_2.panel:Find("count/number_panel/value"):GetComponent(typeof(Text))
	arg0_2.leftBtn = arg0_2.panel:Find("count/left")
	arg0_2.rightBtn = arg0_2.panel:Find("count/right")
	arg0_2.minBtn = arg0_2.panel:Find("count/min")
	arg0_2.maxBtn = arg0_2.panel:Find("count/max")
	arg0_2.bottomItemList = UIItemList.New(arg0_2.panel:Find("itemList/Viewport/Content"), arg0_2.panel:Find("itemList/Viewport/Content/IslandItemTpl"))
	arg0_2.buyBtn = arg0_2.panel:Find("buyBtn")
	arg0_2.consumeIcon = arg0_2.buyBtn:Find("consume/icon")
	arg0_2.consumeCount = arg0_2.buyBtn:Find("consume/count"):GetComponent(typeof(Text))

	setText(arg0_2._tf:Find("panel/getDesc"), i18n("island_3Dshop_buy_tip0"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	pressPersistTrigger(arg0_3.leftBtn, 0.5, function(arg0_6)
		arg0_3:UpdateCount(arg0_3.curCount - 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_3.rightBtn, 0.5, function(arg0_7)
		arg0_3:UpdateCount(arg0_3.curCount + 1)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_3.minBtn, 0.5, function(arg0_8)
		arg0_3:UpdateCount(arg0_3.curCount - 10)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg0_3.maxBtn, 0.5, function(arg0_9)
		arg0_3:UpdateCount(arg0_3.curCount + 10)
	end, nil, true, true, 0.1, SFX_PANEL)
	arg0_3.bottomItemList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_3.awards[arg1_10 + 1]
			local var1_10 = {
				count = 1,
				type = DROP_TYPE_ISLAND_ITEM,
				id = var0_10.id
			}

			updateCustomDrop(arg2_10, var1_10)

			if arg0_3.settings.mode == IslandConst.TRADE_PURCHASE then
				setText(arg2_10:Find("icon_bg/count_bg/count"), arg0_3.curCount)
			elseif arg0_3.settings.mode == IslandConst.TRADE_SELL then
				setText(arg2_10:Find("icon_bg/count_bg/count"), arg0_3.price * arg0_3.curCount)
			end
		end
	end)
	onButton(arg0_3, arg0_3.buyBtn, function()
		if arg0_3.curCount <= 0 then
			local var0_11 = arg0_3.settings

			if var0_11.mode == IslandConst.TRADE_PURCHASE then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_cnt_inadequate"))
			elseif var0_11.mode == IslandConst.TRADE_SELL then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_sell_failed_label"))
			end

			return
		end

		if arg0_3.curCount > arg0_3.settings.maxCnt then
			if settings.mode == IslandConst.TRADE_PURCHASE then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_purchase_failed_label"))
			elseif settings.mode == IslandConst.TRADE_SELL then
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_sell_failed_label2"))
			end

			return
		end

		if arg0_3.settings.onYes then
			arg0_3.settings.onYes(arg0_3.curCount)
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_12)
	arg0_12.curCount = 1

	local var0_12 = arg0_12.settings

	arg0_12.price = var0_12.price or 0
	arg0_12.maxCnt = var0_12.maxCnt or 0
	arg0_12.awards = {}

	local var1_12 = IslandItem.New({
		id = IslandItem.PEARL_ID
	})
	local var2_12 = IslandItem.New({
		id = IslandItem.GOLD_ID
	})

	if var0_12.mode == IslandConst.TRADE_PURCHASE then
		setText(arg0_12._tf:Find("panel/title"), i18n("island_trade_purchase_sub_label"))
		setText(arg0_12._tf:Find("panel/buyBtn/text"), i18n("island_trade_purchase_sub_label"))
		GetImageSpriteFromAtlasAsync("island/" .. var2_12:GetIcon(), "", arg0_12.consumeIcon)
		table.insert(arg0_12.awards, var1_12)
	elseif var0_12.mode == IslandConst.TRADE_SELL then
		setText(arg0_12._tf:Find("panel/title"), i18n("island_trade_sell_sub_label"))
		setText(arg0_12._tf:Find("panel/buyBtn/text"), i18n("island_trade_sell_sub_label"))
		GetImageSpriteFromAtlasAsync("island/" .. var1_12:GetIcon(), "", arg0_12.consumeIcon)
		table.insert(arg0_12.awards, var2_12)
	end

	GetImageSpriteFromAtlasAsync("island/" .. var1_12:GetIcon(), "", arg0_12.icon)

	arg0_12.name.text = var1_12:getConfig("name")
	arg0_12.desc.text = var1_12:getConfig("desc")

	arg0_12:UpdateCount(arg0_12.curCount)
end

function var0_0.UpdateCount(arg0_13, arg1_13)
	arg0_13.curCount = math.min(arg0_13.maxCnt, math.max(0, arg1_13))
	arg0_13.count.text = arg0_13.curCount

	if arg0_13.settings.mode == IslandConst.TRADE_PURCHASE then
		arg0_13.consumeCount.text = arg0_13.curCount * arg0_13.price
	elseif arg0_13.settings.mode == IslandConst.TRADE_SELL then
		arg0_13.consumeCount.text = arg0_13.curCount
	end

	arg0_13.bottomItemList:align(#arg0_13.awards)
end

function var0_0.OnHide(arg0_14)
	return
end

return var0_0
