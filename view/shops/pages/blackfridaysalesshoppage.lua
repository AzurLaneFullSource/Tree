local var0_0 = class("BlackFridaySalesShopPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BlackFridaySalesShopPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollrect = arg0_2:findTF("scrollView"):GetComponent("LScrollRect")
	arg0_2.resTxt = arg0_2:findTF("res_pt/Text"):GetComponent(typeof(Text))
	arg0_2.resIcon = arg0_2:findTF("res_pt/icon")
	arg0_2.pagefooters = {
		arg0_2:findTF("pagefooter/ptShop"),
		arg0_2:findTF("pagefooter/gemShop"),
		arg0_2:findTF("pagefooter/coinShop")
	}
	arg0_2.ress = {
		arg0_2:findTF("res_pt/icon_pt"),
		arg0_2:findTF("res_pt/icon_gem"),
		arg0_2:findTF("res_pt/icon_coin")
	}
	arg0_2.resText = arg0_2:findTF("res_pt/Text")
	arg0_2.pagefooterWid = arg0_2.pagefooters[1].rect.width
	arg0_2.pagefooterStartPosX = arg0_2.pagefooters[1].anchoredPosition.x
	arg0_2.purchasePage = BlackFridayServerShopPurchasePanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.multiWindow = NewServerShopMultiWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2.singleWindow = NewServerShopSingleWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2._tf.localPosition = Vector3(-6, -25)
end

function var0_0.UpdateRes(arg0_3)
	local var0_3 = arg0_3.openIndex or 1
	local var1_3 = arg0_3.shop:GetResID(var0_3)
	local var2_3 = getProxy(PlayerProxy):getRawData():getResource(var1_3)

	arg0_3.resTxt.text = var2_3

	if not arg0_3.isInitResIcon then
		arg0_3.isInitResIcon = true

		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var1_3
		}):getIcon(), "", arg0_3.resIcon)
	end
end

function var0_0.OnInit(arg0_4)
	arg0_4.cards = {}

	function arg0_4.scrollrect.onInitItem(arg0_5)
		arg0_4:OnInitItem(arg0_5)
	end

	function arg0_4.scrollrect.onUpdateItem(arg0_6, arg1_6)
		arg0_4:OnUpdateItem(arg0_6, arg1_6)
	end

	arg0_4:Flush()
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = BlackFridayGoodsCard.New(arg1_7)

	onButton(arg0_7, var0_7._tf, function()
		arg0_7:OnClickCard(var0_7)
	end, SFX_PANEL)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnClickCard(arg0_9, arg1_9)
	local var0_9 = arg1_9.commodity

	if var0_9:Selectable() then
		arg0_9.purchasePage:ExecuteAction("Show", var0_9)
	else
		local var1_9

		if var0_9:getConfig("goods_purchase_limit") == 1 or var0_9:getConfig("type") == 4 then
			var1_9 = arg0_9.singleWindow
		else
			var1_9 = arg0_9.multiWindow
		end

		var1_9:ExecuteAction("Open", var0_9, function(arg0_10, arg1_10, arg2_10)
			if not arg0_10:CanPurchase() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			pg.m02:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING, {
				actType = ActivityConst.ACTIVITY_TYPE_BLACK_FRIDAY_SHOP,
				id = arg0_10.id,
				selectedList = arg0_10:getConfig("goods"),
				count = arg1_10
			})
		end)
	end
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	if not arg0_11.cards[arg2_11] then
		arg0_11:OnInitItem(arg2_11)
	end

	local var0_11 = arg0_11.cards[arg2_11]
	local var1_11 = arg0_11.displays[arg1_11 + 1]

	var0_11:Update(var1_11, arg0_11.shop)
end

function var0_0.FetchShop(arg0_12, arg1_12)
	local var0_12 = getProxy(ShopsProxy):GetNewServerShop(ActivityConst.ACTIVITY_TYPE_BLACK_FRIDAY_SHOP)

	if not var0_12 then
		pg.m02:sendNotification(GAME.GET_NEW_SERVER_SHOP, {
			callback = arg1_12
		})
	else
		arg1_12(var0_12)
	end
end

function var0_0.SetShop(arg0_13, arg1_13)
	arg0_13.shop = arg1_13
end

function var0_0.Flush(arg0_14)
	if arg0_14.shop then
		arg0_14:Show()
		arg0_14:UpdatePageFooters()
		arg0_14:UpdateRes()
	else
		arg0_14:FetchShop(function(arg0_15)
			if not arg0_15 then
				return
			end

			arg0_14.shop = arg0_15

			arg0_14:Show()
			arg0_14:UpdatePageFooters()
			arg0_14:UpdateRes()
		end)
	end
end

function var0_0.UpdatePageFooters(arg0_16)
	local var0_16 = arg0_16.shop:GetTabCount()

	arg0_16.pagefooterTrs = {}

	for iter0_16 = 1, var0_16 do
		local var1_16 = arg0_16.pagefooters[iter0_16]

		arg0_16:UpdatePageFooter(var1_16, iter0_16)

		arg0_16.pagefooterTrs[iter0_16] = var1_16
	end

	local var2_16 = arg0_16.contextData.index or 1

	triggerButton(arg0_16.pagefooterTrs[var2_16])
end

local var1_0 = 0

function var0_0.UpdatePageFooter(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.pagefooterStartPosX + (var1_0 + arg0_17.pagefooterWid) * (arg2_17 - 1)

	setAnchoredPosition(arg1_17, {
		x = var0_17
	})
	arg0_17:OnSwitch(arg1_17, function()
		arg0_17:SwitchTab(arg2_17)
	end)
end

function var0_0.OnSwitch(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg1_19:Find("mark")

	local function var1_19()
		if arg0_19.markTr then
			setActive(arg0_19.markTr, false)
		end

		arg0_19.markTr = var0_19

		setActive(var0_19, true)
	end

	onButton(arg0_19, arg1_19, function()
		var1_19()
		arg2_19()
	end, SFX_PANEL)
end

function var0_0.SwitchTab(arg0_22, arg1_22)
	arg0_22.openIndex = arg1_22

	if arg0_22.resTF then
		setActive(arg0_22.resTF, false)
	end

	arg0_22.resTF = arg0_22.ress[arg1_22]

	setActive(arg0_22.resTF, true)
	arg0_22:UpdateRes()

	arg0_22.displays = arg0_22.shop:GetGoodsByTabs(arg1_22)

	table.sort(arg0_22.displays, function(arg0_23, arg1_23)
		return arg0_23.id < arg1_23.id
	end)
	arg0_22.scrollrect:SetTotalCount(#arg0_22.displays)
end

function var0_0.Refresh(arg0_24)
	arg0_24:SwitchTab(arg0_24.openIndex)
	arg0_24:UpdateRes()
end

function var0_0.updateLocalRedDotData(arg0_25, arg1_25)
	if arg0_25:isPhaseTip(arg1_25) then
		PlayerPrefs.SetInt("newserver_shop_phase_" .. arg1_25 .. "_" .. arg0_25.playerId, 1)
		arg0_25:emit(NewServerCarnivalMediator.UPDATE_SHOP_RED_DOT)
	end
end

function var0_0.isTip(arg0_26)
	return false
end

function var0_0.OnDestroy(arg0_27)
	arg0_27.scrollrect.onInitItem = nil
	arg0_27.scrollrect.onUpdateItem = nil

	for iter0_27, iter1_27 in pairs(arg0_27.cards) do
		iter1_27:Dispose()
	end

	arg0_27.cards = nil

	arg0_27.purchasePage:Destroy()

	arg0_27.purchasePage = nil

	arg0_27.multiWindow:Destroy()

	arg0_27.multiWindow = nil

	arg0_27.singleWindow:Destroy()

	arg0_27.singleWindow = nil
end

return var0_0
