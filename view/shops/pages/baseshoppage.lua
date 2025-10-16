local var0_0 = class("BaseShopPage", import("...base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg2_1)
	arg0_1:attach(arg1_1)

	arg0_1.event = arg1_1.event

	arg0_1:CustomInit()
end

function var0_0.init(arg0_2)
	arg0_2.canvasGroup = arg0_2._go:GetComponent(typeof(CanvasGroup))
	arg0_2.lScrollrect = GetComponent(arg0_2._tf:Find("scroll"), "LScrollRect")
	arg0_2.scrollbar = arg0_2._tf:Find("scroll/Scrollbar")
	arg0_2.tipTextGo = arg0_2._tf:Find("bg/tipBg")
	arg0_2.tipText = arg0_2._tf:Find("bg/tipBg/tipText"):GetComponent(typeof(Text))
	arg0_2.helpBtn = arg0_2._tf:Find("bg/resList/helpBtn")
	arg0_2.refreshBtn = arg0_2._tf:Find("timeBtn")
	arg0_2.timerText = arg0_2._tf:Find("timeBtn/Text"):GetComponent(typeof(Text))
	arg0_2.resolveBtn = arg0_2._tf:Find("resolveBtn")

	setText(arg0_2._tf:Find("resolveBtn/Text"), i18n("shop_fragment_resolve"))
end

function var0_0.CustomInit(arg0_3)
	return
end

function var0_0.SetShop(arg0_4, arg1_4)
	arg0_4.shop = arg1_4
end

function var0_0.SetPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5

	arg0_5:OnUpdatePlayer()
end

function var0_0.SetItems(arg0_6, arg1_6)
	arg0_6.items = arg1_6

	arg0_6:OnUpdateItems()
end

function var0_0.SetUp(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7:SetShop(arg1_7)
	arg0_7:Show()
	arg0_7:SetPlayer(arg2_7)
	arg0_7:SetItems(arg3_7)
	arg0_7:InitCommodities()
	arg0_7:OnSetUp()
	arg0_7:SetPainting()
	arg0_7:RefreshUI()
end

function var0_0.InitCommodities(arg0_8)
	arg0_8.displays, arg0_8.cards = arg0_8.shop:GetCommodities(), {}
	arg0_8.lScrollrect.enabled = true

	arg0_8.lScrollrect:SetTotalCount(#arg0_8.displays, 0)
end

function var0_0.RefreshUI(arg0_9)
	setActive(arg0_9.tipTextGo, false)
	setActive(arg0_9.helpBtn, false)
	setActive(arg0_9.resolveBtn, false)
	setActive(arg0_9.refreshBtn, false)
end

function var0_0.Show(arg0_10)
	function arg0_10.lScrollrect.onInitItem(arg0_11)
		arg0_10:OnInitItem(arg0_11)
	end

	function arg0_10.lScrollrect.onUpdateItem(arg0_12, arg1_12)
		arg0_10:OnUpdateItem(arg0_12, arg1_12)
	end

	arg0_10.canvasGroup.alpha = 1
	arg0_10.canvasGroup.blocksRaycasts = true

	arg0_10:PlayBGM()
end

function var0_0.Hide(arg0_13)
	arg0_13:StopBGM()

	for iter0_13, iter1_13 in pairs(arg0_13.cards) do
		iter1_13:Dispose()
	end

	arg0_13.displays = {}
	arg0_13.cards = {}

	ClearLScrollrect(arg0_13.lScrollrect)

	arg0_13.canvasGroup.alpha = 0
	arg0_13.canvasGroup.blocksRaycasts = false
end

function var0_0.GetResDataList(arg0_14)
	return {}
end

function var0_0.RefreshResItemList(arg0_15)
	local var0_15 = arg0_15:GetResDataList() or {}

	arg0_15.parent:RefreshResItemList(var0_15)
end

function var0_0.OnDestroy(arg0_16)
	arg0_16:detach()
end

function var0_0.SetPainting(arg0_17)
	local var0_17, var1_17, var2_17 = arg0_17:GetPaintingName()

	if arg0_17.contextData.paintingView.name ~= var0_17 then
		arg0_17.contextData.paintingView:Init(var0_17, var1_17, var2_17, function()
			local var0_18, var1_18, var2_18 = arg0_17:GetPaintingEnterVoice()

			arg0_17.contextData.paintingView:Chat(var0_18, var1_18, var2_18, true)
		end, function()
			local var0_19, var1_19, var2_19 = arg0_17:GetPaintingTouchVoice()

			arg0_17.contextData.paintingView:Chat(var0_19, var1_19, var2_19, false)
		end)
	end
end

function var0_0.UpdateShop(arg0_20, arg1_20)
	arg0_20:SetShop(arg1_20)
	pg.MsgboxMgr.GetInstance():hide()

	if arg0_20.contextData.singleWindow:GetLoaded() and arg0_20.contextData.singleWindow:isShowing() then
		arg0_20.contextData.singleWindow:ExecuteAction("Close")
	end

	if arg0_20.contextData.multiWindow:GetLoaded() and arg0_20.contextData.multiWindow:isShowing() then
		arg0_20.contextData.multiWindow:ExecuteAction("Close")
	end

	arg0_20:OnUpdateAll()
end

function var0_0.UpdateCommodity(arg0_21, arg1_21, arg2_21)
	arg0_21:SetShop(arg1_21)

	local var0_21 = arg1_21:GetCommodityById(arg2_21)

	if DROP_TYPE_SHIP == var0_21:getConfig("commodity_type") then
		arg0_21:OnUpdateAll()
	else
		arg0_21:OnUpdateCommodity(var0_21)
	end

	local var1_21
	local var2_21
	local var3_21

	if arg1_21:IsPurchaseAll() then
		var1_21, var2_21, var3_21 = arg0_21:GetPaintingAllPurchaseVoice()
	else
		var1_21, var2_21, var3_21 = arg0_21:GetPaintingCommodityUpdateVoice()
	end

	arg0_21.contextData.paintingView:Chat(var1_21, var2_21, var3_21, true)
end

function var0_0.OnClickCommodity(arg0_22, arg1_22, arg2_22)
	local var0_22 = Drop.New({
		type = arg1_22:getConfig("commodity_type"),
		id = arg1_22:getConfig("commodity_id"),
		count = arg1_22:getConfig("num")
	})

	if var0_22.type == DROP_TYPE_VITEM and var0_22:getConfig("virtual_type") == 22 then
		local var1_22 = getProxy(ActivityProxy):getActivityById(var0_22:getConfig("link_id"))

		if not var1_22 or var1_22:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_exchange_expired", var0_22:getName()))

			return
		end
	end

	local var2_22

	if var0_22.type == DROP_TYPE_EQUIPMENT_SKIN then
		var2_22 = arg0_22.contextData.singleWindowForESkin
	elseif arg1_22:getConfig("num_limit") == 1 or arg1_22:getConfig("commodity_type") == 4 or isa(arg1_22, QuotaCommodity) and arg1_22:GetLimitGoodCount() == 1 then
		var2_22 = arg0_22.contextData.singleWindow
	else
		var2_22 = arg0_22.contextData.multiWindow
	end

	var2_22:ExecuteAction("Open", arg1_22, function(arg0_23, arg1_23, arg2_23)
		local var0_23 = {}

		if arg0_23:getConfig("commodity_type") == 4 or arg0_22.shop.type == ShopArgs.ShopActivity then
			table.insert(var0_23, function(arg0_24)
				arg0_22:TipPurchase(arg0_23, arg1_23, arg2_23, arg0_24)
			end)
		else
			table.insert(var0_23, function(arg0_25)
				if arg0_22:getSpecialRule(arg0_23) then
					arg0_25()
				end
			end)
		end

		table.insert(var0_23, function(arg0_26)
			if not arg0_23:canPurchase() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			local var0_26 = Drop.New({
				type = arg0_23:getConfig("resource_category"),
				id = arg0_23:getConfig("resource_type")
			})

			if var0_26:getOwnedCount() < arg0_23:getConfig("resource_num") * arg1_23 then
				if not ItemTipPanel.ShowItemTip(arg0_23:getConfig("resource_category"), arg0_23:getConfig("resource_type")) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var0_26:getName()))
				end

				return
			end

			arg0_26()
		end)
		seriesAsync(var0_23, function()
			arg2_22(arg0_23, arg1_23)
		end)
	end)
end

function var0_0.TipPurchase(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("pt_reconfirm", arg3_28 or "??"),
		onYes = arg4_28
	})
end

function var0_0.getSpecialRule(arg0_29, arg1_29)
	if arg1_29:getConfig("commodity_type") == DROP_TYPE_ITEM and arg0_29.shop.type == ShopArgs.ShopFragment then
		local var0_29 = arg1_29:getConfig("commodity_id")
		local var1_29 = Item.getConfigData(var0_29)

		if var1_29 and var1_29.type == 7 and #var1_29.shiptrans_id > 0 then
			local var2_29 = getProxy(BayProxy)

			if getProxy(BagProxy):getItemCountById(var0_29) > 0 or underscore.any(var1_29.shiptrans_id, function(arg0_30)
				return var2_29:getConfigShipCount(arg0_30) > 0
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("special_transform_limit_reach"))

				return false
			end
		end
	end

	return true
end

function var0_0.CanOpen(arg0_31, arg1_31, arg2_31)
	return true
end

function var0_0.GetPaintingName(arg0_32)
	return "buzhihuo_shop"
end

function var0_0.GetPaintingEnterVoice(arg0_33)
	local var0_33 = pg.navalacademy_shoppingstreet_template[1].words_enter
	local var1_33 = string.split(var0_33, "|")
	local var2_33 = math.random(#var1_33)

	return var1_33[var2_33], "enter_" .. var2_33, false
end

function var0_0.GetPaintingCommodityUpdateVoice(arg0_34)
	local var0_34 = pg.navalacademy_shoppingstreet_template[1].words_buy
	local var1_34 = string.split(var0_34, "|")
	local var2_34 = math.random(#var1_34)

	return var1_34[var2_34], "buy_" .. var2_34, false
end

function var0_0.GetPaintingAllPurchaseVoice(arg0_35)
	return nil, nil, nil
end

function var0_0.GetPaintingTouchVoice(arg0_36)
	local var0_36 = pg.navalacademy_shoppingstreet_template[1].words_touch
	local var1_36 = string.split(var0_36, "|")
	local var2_36 = math.random(#var1_36)

	return var1_36[var2_36], "touch_" .. var2_36, false
end

function var0_0.GetBg(arg0_37, arg1_37)
	return
end

function var0_0.OnSetUp(arg0_38)
	return
end

function var0_0.getBGM(arg0_39)
	return nil
end

function var0_0.PlayBGM(arg0_40)
	local var0_40 = arg0_40:getBGM()
	local var1_40 = pg.voice_bgm[var0_40]

	if var0_40 and var1_40 then
		pg.BgmMgr.GetInstance():Push(var0_40, var1_40.bgm)
	end
end

function var0_0.StopBGM(arg0_41)
	local var0_41 = arg0_41:getBGM()
	local var1_41 = pg.voice_bgm[var0_41]

	if var0_41 and var1_41 then
		pg.BgmMgr.GetInstance():Pop(var0_41)
	end
end

function var0_0.OnUpdateAll(arg0_42)
	return
end

function var0_0.OnUpdateCommodity(arg0_43, arg1_43)
	return
end

function var0_0.OnUpdatePlayer(arg0_44)
	return
end

function var0_0.OnUpdateItems(arg0_45)
	return
end

function var0_0.OnInitItem(arg0_46, arg1_46)
	return
end

function var0_0.OnUpdateItem(arg0_47, arg1_47, arg2_47)
	return
end

function var0_0.CanOpenPurchaseWindow(arg0_48, arg1_48)
	return arg1_48:canPurchase()
end

return var0_0
