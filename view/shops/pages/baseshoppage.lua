local var0 = class("BaseShopPage", import("...base.BaseSubView"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	var0.super.Ctor(arg0, arg1, arg2, arg3)

	arg0.lScrollrect = arg4
	arg0.scrollbar = arg1:Find("Scrollbar")

	assert(arg0.lScrollrect)
end

function var0.Load(arg0)
	if arg0._state ~= var0.STATES.NONE then
		return
	end

	arg0._state = var0.STATES.LOADING

	pg.UIMgr.GetInstance():LoadingOn()

	local var0 = GameObject.Find("__Pool__")
	local var1 = findTF(var0, arg0:getUIName())

	if IsNil(var1) then
		PoolMgr.GetInstance():GetUI(arg0:getUIName(), true, function(arg0)
			arg0:Loaded(arg0)
			arg0:Init()
		end)
	else
		arg0:Loaded(var1.gameObject)
		arg0:Init()
	end
end

function var0.Loaded(arg0, arg1)
	arg0.canvasGroup = arg1:GetComponent(typeof(CanvasGroup))

	assert(arg0.canvasGroup)
	var0.super.Loaded(arg0, arg1)
end

function var0.SetShop(arg0, arg1)
	arg0.shop = arg1
end

function var0.SetPlayer(arg0, arg1)
	arg0.player = arg1

	arg0:OnUpdatePlayer()
end

function var0.SetItems(arg0, arg1)
	arg0.items = arg1

	arg0:OnUpdateItems()
end

function var0.SetUp(arg0, arg1, arg2, arg3)
	arg0:SetShop(arg1)
	arg0:Show()
	arg0:SetPlayer(arg2)
	arg0:SetItems(arg3)
	arg0:InitCommodities()
	arg0:OnSetUp()
	arg0:SetPainting()
end

function var0.InitCommodities(arg0)
	arg0.displays, arg0.cards = arg0.shop:GetCommodities(), {}

	arg0.lScrollrect:SetTotalCount(#arg0.displays, 0)
	setActive(arg0.scrollbar, #arg0.displays > 10)
end

function var0.Show(arg0)
	function arg0.lScrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.lScrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0.canvasGroup.alpha = 1
	arg0.canvasGroup.blocksRaycasts = true

	arg0:ShowOrHideResUI(true)
end

function var0.Hide(arg0)
	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.displays = {}
	arg0.cards = {}

	ClearLScrollrect(arg0.lScrollrect)

	arg0.canvasGroup.alpha = 0
	arg0.canvasGroup.blocksRaycasts = false

	arg0:ShowOrHideResUI(false)
end

function var0.Destroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	var0.super.Destroy(arg0)
end

function var0.SetPainting(arg0)
	local var0, var1, var2 = arg0:GetPaintingName()

	if arg0.contextData.paintingView.name ~= var0 then
		arg0.contextData.paintingView:Init(var0, var1, var2, function()
			local var0, var1, var2 = arg0:GetPaintingEnterVoice()

			arg0.contextData.paintingView:Chat(var0, var1, var2, true)
		end)
		onButton(arg0, arg0.contextData.paintingView.touch, function()
			local var0, var1, var2 = arg0:GetPaintingTouchVoice()

			arg0.contextData.paintingView:Chat(var0, var1, var2, false)
		end, SFX_PANEL)
	end
end

function var0.UpdateShop(arg0, arg1)
	arg0:SetShop(arg1)
	pg.MsgboxMgr.GetInstance():hide()

	if arg0.contextData.singleWindow:GetLoaded() and arg0.contextData.singleWindow:isShowing() then
		arg0.contextData.singleWindow:ExecuteAction("Close")
	end

	if arg0.contextData.multiWindow:GetLoaded() and arg0.contextData.multiWindow:isShowing() then
		arg0.contextData.multiWindow:ExecuteAction("Close")
	end

	arg0:OnUpdateAll()
end

function var0.UpdateCommodity(arg0, arg1, arg2)
	arg0:SetShop(arg1)

	local var0 = arg1:GetCommodityById(arg2)

	if DROP_TYPE_SHIP == var0:getConfig("commodity_type") then
		arg0:OnUpdateAll()
	else
		arg0:OnUpdateCommodity(var0)
	end

	local var1
	local var2
	local var3

	if arg1:IsPurchaseAll() then
		var1, var2, var3 = arg0:GetPaintingAllPurchaseVoice()
	else
		var1, var2, var3 = arg0:GetPaintingCommodityUpdateVoice()
	end

	arg0.contextData.paintingView:Chat(var1, var2, var3, true)
end

function var0.OnClickCommodity(arg0, arg1, arg2)
	local var0 = Drop.New({
		type = arg1:getConfig("commodity_type"),
		id = arg1:getConfig("commodity_id"),
		count = arg1:getConfig("num")
	})

	if var0.type == DROP_TYPE_VITEM and var0:getConfig("virtual_type") == 22 then
		local var1 = getProxy(ActivityProxy):getActivityById(var0:getConfig("link_id"))

		if not var1 or var1:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tip_build_ticket_exchange_expired", var0:getName()))

			return
		end
	end

	local var2

	if var0.type == DROP_TYPE_EQUIPMENT_SKIN then
		var2 = arg0.contextData.singleWindowForESkin
	elseif arg1:getConfig("num_limit") == 1 or arg1:getConfig("commodity_type") == 4 or isa(arg1, QuotaCommodity) and arg1:GetLimitGoodCount() == 1 then
		var2 = arg0.contextData.singleWindow
	else
		var2 = arg0.contextData.multiWindow
	end

	var2:ExecuteAction("Open", arg1, function(arg0, arg1, arg2)
		local var0 = {}

		if arg0:getConfig("commodity_type") == 4 or arg0.shop.type == ShopArgs.ShopActivity then
			table.insert(var0, function(arg0)
				arg0:TipPurchase(arg0, arg1, arg2, arg0)
			end)
		else
			table.insert(var0, function(arg0)
				if arg0:getSpecialRule(arg0) then
					arg0()
				end
			end)
		end

		table.insert(var0, function(arg0)
			if not arg0:canPurchase() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			local var0 = Drop.New({
				type = arg0:getConfig("resource_category"),
				id = arg0:getConfig("resource_type")
			})

			if var0:getOwnedCount() < arg0:getConfig("resource_num") * arg1 then
				if not ItemTipPanel.ShowItemTip(arg0:getConfig("resource_category"), arg0:getConfig("resource_type")) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var0:getName()))
				end

				return
			end

			arg0()
		end)
		seriesAsync(var0, function()
			arg2(arg0, arg1)
		end)
	end)
end

function var0.TipPurchase(arg0, arg1, arg2, arg3, arg4)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("pt_reconfirm", arg3 or "??"),
		onYes = arg4
	})
end

function var0.getSpecialRule(arg0, arg1)
	if arg1:getConfig("commodity_type") == DROP_TYPE_ITEM and arg0.shop.type == ShopArgs.ShopFragment then
		local var0 = arg1:getConfig("commodity_id")
		local var1 = Item.getConfigData(var0)

		if var1 and var1.type == 7 and #var1.shiptrans_id > 0 then
			local var2 = getProxy(BayProxy)

			if getProxy(BagProxy):getItemCountById(var0) > 0 or underscore.any(var1.shiptrans_id, function(arg0)
				return var2:getConfigShipCount(arg0) > 0
			end) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("special_transform_limit_reach"))

				return false
			end
		end
	end

	return true
end

function var0.CanOpen(arg0, arg1, arg2)
	return true
end

function var0.GetPaintingName(arg0)
	return "buzhihuo_shop"
end

function var0.GetPaintingEnterVoice(arg0)
	local var0 = pg.navalacademy_shoppingstreet_template[1].words_enter
	local var1 = string.split(var0, "|")
	local var2 = math.random(#var1)

	return var1[var2], "enter_" .. var2, false
end

function var0.GetPaintingCommodityUpdateVoice(arg0)
	local var0 = pg.navalacademy_shoppingstreet_template[1].words_buy
	local var1 = string.split(var0, "|")
	local var2 = math.random(#var1)

	return var1[var2], "buy_" .. var2, false
end

function var0.GetPaintingAllPurchaseVoice(arg0)
	return nil, nil, nil
end

function var0.GetPaintingTouchVoice(arg0)
	local var0 = pg.navalacademy_shoppingstreet_template[1].words_touch
	local var1 = string.split(var0, "|")
	local var2 = math.random(#var1)

	return var1[var2], "touch_" .. var2, false
end

function var0.GetBg(arg0, arg1)
	return
end

function var0.OnSetUp(arg0)
	return
end

function var0.OnUpdateAll(arg0)
	return
end

function var0.OnUpdateCommodity(arg0, arg1)
	return
end

function var0.OnUpdatePlayer(arg0)
	return
end

function var0.OnUpdateItems(arg0)
	return
end

function var0.OnInitItem(arg0, arg1)
	return
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	return
end

function var0.CanOpenPurchaseWindow(arg0, arg1)
	return arg1:canPurchase()
end

return var0
