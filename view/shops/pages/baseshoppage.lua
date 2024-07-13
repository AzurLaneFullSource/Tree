local var0_0 = class("BaseShopPage", import("...base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.lScrollrect = arg4_1
	arg0_1.scrollbar = arg1_1:Find("Scrollbar")

	assert(arg0_1.lScrollrect)
end

function var0_0.Load(arg0_2)
	if arg0_2._state ~= var0_0.STATES.NONE then
		return
	end

	arg0_2._state = var0_0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0_2 = GameObject.Find("__Pool__")
	local var1_2 = findTF(var0_2, arg0_2:getUIName())

	if IsNil(var1_2) then
		PoolMgr.GetInstance():GetUI(arg0_2:getUIName(), true, function(arg0_3)
			arg0_2:Loaded(arg0_3)
			arg0_2:Init()
		end)
	else
		arg0_2:Loaded(var1_2.gameObject)
		arg0_2:Init()
	end
end

function var0_0.Loaded(arg0_4, arg1_4)
	arg0_4.canvasGroup = arg1_4:GetComponent(typeof(CanvasGroup))

	assert(arg0_4.canvasGroup)
	var0_0.super.Loaded(arg0_4, arg1_4)
end

function var0_0.SetShop(arg0_5, arg1_5)
	arg0_5.shop = arg1_5
end

function var0_0.SetPlayer(arg0_6, arg1_6)
	arg0_6.player = arg1_6

	arg0_6:OnUpdatePlayer()
end

function var0_0.SetItems(arg0_7, arg1_7)
	arg0_7.items = arg1_7

	arg0_7:OnUpdateItems()
end

function var0_0.SetUp(arg0_8, arg1_8, arg2_8, arg3_8)
	arg0_8:SetShop(arg1_8)
	arg0_8:Show()
	arg0_8:SetPlayer(arg2_8)
	arg0_8:SetItems(arg3_8)
	arg0_8:InitCommodities()
	arg0_8:OnSetUp()
	arg0_8:SetPainting()
end

function var0_0.InitCommodities(arg0_9)
	arg0_9.displays, arg0_9.cards = arg0_9.shop:GetCommodities(), {}

	arg0_9.lScrollrect:SetTotalCount(#arg0_9.displays, 0)
	setActive(arg0_9.scrollbar, #arg0_9.displays > 10)
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

	arg0_10:ShowOrHideResUI(true)
end

function var0_0.Hide(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13.cards) do
		iter1_13:Dispose()
	end

	arg0_13.displays = {}
	arg0_13.cards = {}

	ClearLScrollrect(arg0_13.lScrollrect)

	arg0_13.canvasGroup.alpha = 0
	arg0_13.canvasGroup.blocksRaycasts = false

	arg0_13:ShowOrHideResUI(false)
end

function var0_0.Destroy(arg0_14)
	if arg0_14:isShowing() then
		arg0_14:Hide()
	end

	var0_0.super.Destroy(arg0_14)
end

function var0_0.SetPainting(arg0_15)
	local var0_15, var1_15, var2_15 = arg0_15:GetPaintingName()

	if arg0_15.contextData.paintingView.name ~= var0_15 then
		arg0_15.contextData.paintingView:Init(var0_15, var1_15, var2_15, function()
			local var0_16, var1_16, var2_16 = arg0_15:GetPaintingEnterVoice()

			arg0_15.contextData.paintingView:Chat(var0_16, var1_16, var2_16, true)
		end)
		onButton(arg0_15, arg0_15.contextData.paintingView.touch, function()
			local var0_17, var1_17, var2_17 = arg0_15:GetPaintingTouchVoice()

			arg0_15.contextData.paintingView:Chat(var0_17, var1_17, var2_17, false)
		end, SFX_PANEL)
	end
end

function var0_0.UpdateShop(arg0_18, arg1_18)
	arg0_18:SetShop(arg1_18)
	pg.MsgboxMgr.GetInstance():hide()

	if arg0_18.contextData.singleWindow:GetLoaded() and arg0_18.contextData.singleWindow:isShowing() then
		arg0_18.contextData.singleWindow:ExecuteAction("Close")
	end

	if arg0_18.contextData.multiWindow:GetLoaded() and arg0_18.contextData.multiWindow:isShowing() then
		arg0_18.contextData.multiWindow:ExecuteAction("Close")
	end

	arg0_18:OnUpdateAll()
end

function var0_0.UpdateCommodity(arg0_19, arg1_19, arg2_19)
	arg0_19:SetShop(arg1_19)

	local var0_19 = arg1_19:GetCommodityById(arg2_19)

	if DROP_TYPE_SHIP == var0_19:getConfig("commodity_type") then
		arg0_19:OnUpdateAll()
	else
		arg0_19:OnUpdateCommodity(var0_19)
	end

	local var1_19
	local var2_19
	local var3_19

	if arg1_19:IsPurchaseAll() then
		var1_19, var2_19, var3_19 = arg0_19:GetPaintingAllPurchaseVoice()
	else
		var1_19, var2_19, var3_19 = arg0_19:GetPaintingCommodityUpdateVoice()
	end

	arg0_19.contextData.paintingView:Chat(var1_19, var2_19, var3_19, true)
end

function var0_0.OnClickCommodity(arg0_20, arg1_20, arg2_20)
	local var0_20 = Drop.New({
		type = arg1_20:getConfig("commodity_type"),
		id = arg1_20:getConfig("commodity_id"),
		count = arg1_20:getConfig("num")
	})

	if var0_20.type == DROP_TYPE_VITEM and var0_20:getConfig("virtual_type") == 22 then
		local var1_20 = getProxy(ActivityProxy):getActivityById(var0_20:getConfig("link_id"))

		if not var1_20 or var1_20:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_exchange_expired", var0_20:getName()))

			return
		end
	end

	local var2_20

	if var0_20.type == DROP_TYPE_EQUIPMENT_SKIN then
		var2_20 = arg0_20.contextData.singleWindowForESkin
	elseif arg1_20:getConfig("num_limit") == 1 or arg1_20:getConfig("commodity_type") == 4 or isa(arg1_20, QuotaCommodity) and arg1_20:GetLimitGoodCount() == 1 then
		var2_20 = arg0_20.contextData.singleWindow
	else
		var2_20 = arg0_20.contextData.multiWindow
	end

	var2_20:ExecuteAction("Open", arg1_20, function(arg0_21, arg1_21, arg2_21)
		local var0_21 = {}

		if arg0_21:getConfig("commodity_type") == 4 or arg0_20.shop.type == ShopArgs.ShopActivity then
			table.insert(var0_21, function(arg0_22)
				arg0_20:TipPurchase(arg0_21, arg1_21, arg2_21, arg0_22)
			end)
		else
			table.insert(var0_21, function(arg0_23)
				if arg0_20:getSpecialRule(arg0_21) then
					arg0_23()
				end
			end)
		end

		table.insert(var0_21, function(arg0_24)
			if not arg0_21:canPurchase() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			local var0_24 = Drop.New({
				type = arg0_21:getConfig("resource_category"),
				id = arg0_21:getConfig("resource_type")
			})

			if var0_24:getOwnedCount() < arg0_21:getConfig("resource_num") * arg1_21 then
				if not ItemTipPanel.ShowItemTip(arg0_21:getConfig("resource_category"), arg0_21:getConfig("resource_type")) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var0_24:getName()))
				end

				return
			end

			arg0_24()
		end)
		seriesAsync(var0_21, function()
			arg2_20(arg0_21, arg1_21)
		end)
	end)
end

function var0_0.TipPurchase(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("pt_reconfirm", arg3_26 or "??"),
		onYes = arg4_26
	})
end

function var0_0.getSpecialRule(arg0_27, arg1_27)
	if arg1_27:getConfig("commodity_type") == DROP_TYPE_ITEM and arg0_27.shop.type == ShopArgs.ShopFragment then
		local var0_27 = arg1_27:getConfig("commodity_id")
		local var1_27 = Item.getConfigData(var0_27)

		if var1_27 and var1_27.type == 7 and #var1_27.shiptrans_id > 0 then
			local var2_27 = getProxy(BayProxy)

			if getProxy(BagProxy):getItemCountById(var0_27) > 0 or underscore.any(var1_27.shiptrans_id, function(arg0_28)
				return var2_27:getConfigShipCount(arg0_28) > 0
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("special_transform_limit_reach"))

				return false
			end
		end
	end

	return true
end

function var0_0.CanOpen(arg0_29, arg1_29, arg2_29)
	return true
end

function var0_0.GetPaintingName(arg0_30)
	return "buzhihuo_shop"
end

function var0_0.GetPaintingEnterVoice(arg0_31)
	local var0_31 = pg.navalacademy_shoppingstreet_template[1].words_enter
	local var1_31 = string.split(var0_31, "|")
	local var2_31 = math.random(#var1_31)

	return var1_31[var2_31], "enter_" .. var2_31, false
end

function var0_0.GetPaintingCommodityUpdateVoice(arg0_32)
	local var0_32 = pg.navalacademy_shoppingstreet_template[1].words_buy
	local var1_32 = string.split(var0_32, "|")
	local var2_32 = math.random(#var1_32)

	return var1_32[var2_32], "buy_" .. var2_32, false
end

function var0_0.GetPaintingAllPurchaseVoice(arg0_33)
	return nil, nil, nil
end

function var0_0.GetPaintingTouchVoice(arg0_34)
	local var0_34 = pg.navalacademy_shoppingstreet_template[1].words_touch
	local var1_34 = string.split(var0_34, "|")
	local var2_34 = math.random(#var1_34)

	return var1_34[var2_34], "touch_" .. var2_34, false
end

function var0_0.GetBg(arg0_35, arg1_35)
	return
end

function var0_0.OnSetUp(arg0_36)
	return
end

function var0_0.OnUpdateAll(arg0_37)
	return
end

function var0_0.OnUpdateCommodity(arg0_38, arg1_38)
	return
end

function var0_0.OnUpdatePlayer(arg0_39)
	return
end

function var0_0.OnUpdateItems(arg0_40)
	return
end

function var0_0.OnInitItem(arg0_41, arg1_41)
	return
end

function var0_0.OnUpdateItem(arg0_42, arg1_42, arg2_42)
	return
end

function var0_0.CanOpenPurchaseWindow(arg0_43, arg1_43)
	return arg1_43:canPurchase()
end

return var0_0
