local var0_0 = class("NewServerShopPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewServerShopPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.scrollrect = arg0_2:findTF("scrollView"):GetComponent("LScrollRect")
	arg0_2.resTxt = arg0_2:findTF("res_pt/Text"):GetComponent(typeof(Text))
	arg0_2.resIcon = arg0_2:findTF("res_pt/icon")
	arg0_2.pagefooters = {
		arg0_2:findTF("pagefooter/tpl")
	}
	arg0_2.pagefooterWid = arg0_2.pagefooters[1].rect.width
	arg0_2.pagefooterStartPosX = arg0_2.pagefooters[1].anchoredPosition.x
	arg0_2.purchasePage = NewServerShopPurchasePanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.multiWindow = NewServerShopMultiWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2.singleWindow = NewServerShopSingleWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2._tf.localPosition = Vector3(-6, -25)
end

function var0_0.UpdateRes(arg0_3)
	local var0_3 = arg0_3.shop:GetPtId()
	local var1_3 = getProxy(PlayerProxy):getRawData():getResource(var0_3)

	arg0_3.resTxt.text = var1_3

	if not arg0_3.isInitResIcon then
		arg0_3.isInitResIcon = true

		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var0_3
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
	local var0_7 = NewServerGoodsCard.New(arg1_7)

	onButton(arg0_7, var0_7._tf, function()
		arg0_7:OnClickCard(var0_7)
	end, SFX_PANEL)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnClickCard(arg0_9, arg1_9)
	local var0_9 = arg1_9.commodity
	local var1_9, var2_9 = var0_9:IsOpening(arg0_9.shop:GetStartTime())

	if not var1_9 then
		local var3_9 = (var2_9.day > 0 and var2_9.day .. i18n("word_date") or "") .. var2_9.hour .. i18n("word_hour")

		pg.TipsMgr.GetInstance():ShowTips(i18n("newserver_shop_timelimit", var3_9))

		return
	end

	if var0_9:Selectable() then
		arg0_9.purchasePage:ExecuteAction("Show", var0_9)
	else
		local var4_9

		if var0_9:getConfig("goods_purchase_limit") == 1 or var0_9:getConfig("type") == 4 then
			var4_9 = arg0_9.singleWindow
		else
			var4_9 = arg0_9.multiWindow
		end

		var4_9:ExecuteAction("Open", var0_9, function(arg0_10, arg1_10, arg2_10)
			if not arg0_10:CanPurchase() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			pg.m02:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING, {
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
	local var0_12 = getProxy(ShopsProxy):GetNewServerShop()

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

local function var1_0(arg0_16, arg1_16)
	local var0_16 = arg0_16.pagefooters[arg1_16]

	if not var0_16 then
		local var1_16 = arg0_16.pagefooters[1]

		var0_16 = Object.Instantiate(var1_16, var1_16.parent)
		arg0_16.pagefooters[arg1_16] = var0_16
	end

	setActive(var0_16, true)

	return var0_16
end

function var0_0.UpdatePageFooters(arg0_17)
	local var0_17 = arg0_17.shop:GetPhases()

	arg0_17.pagefooterTrs = {}

	for iter0_17 = 1, #var0_17 do
		local var1_17 = var1_0(arg0_17, iter0_17)

		arg0_17:UpdatePageFooter(var1_17, iter0_17)

		arg0_17.pagefooterTrs[iter0_17] = var1_17
	end

	for iter1_17 = #var0_17 + 1, #arg0_17.pagefooters do
		setActive(arg0_17.pagefooters[iter1_17], false)
	end

	local var2_17 = arg0_17.contextData.index or 1

	triggerButton(arg0_17.pagefooterTrs[var2_17])
end

local var2_0 = 0

function var0_0.UpdatePageFooter(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.pagefooterStartPosX + (var2_0 + arg0_18.pagefooterWid) * (arg2_18 - 1)

	setAnchoredPosition(arg1_18, {
		x = var0_18
	})

	local var1_18 = GetSpriteFromAtlas("ui/newservershopui_atlas", "p" .. arg2_18)

	arg1_18:Find("Text"):GetComponent(typeof(Image)).sprite = var1_18

	local var2_18 = GetSpriteFromAtlas("ui/newservershopui_atlas", "p" .. arg2_18 .. "_s")

	arg1_18:Find("mark"):GetComponent(typeof(Image)).sprite = var2_18

	local var3_18 = arg1_18:Find("lock")

	if arg2_18 ~= 1 then
		local var4_18 = GetSpriteFromAtlas("ui/newservershopui_atlas", "p" .. arg2_18 .. "_l")

		var3_18:GetComponent(typeof(Image)).sprite = var4_18
	end

	setActive(var3_18, not arg0_18.shop:IsOpenPhase(arg2_18))
	setActive(arg1_18:Find("tip"), arg0_18:isPhaseTip(arg2_18))
	arg0_18:OnSwitch(arg1_18, function()
		return arg0_18.openIndex ~= arg2_18
	end, function()
		arg0_18:SwitchPhase(arg2_18)
		setActive(arg1_18:Find("tip"), arg0_18:isPhaseTip(arg2_18))
	end)
end

function var0_0.OnSwitch(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg1_21:Find("mark")

	local function var1_21()
		if arg0_21.markTr then
			setActive(arg0_21.markTr, false)
		end

		arg0_21.markTr = var0_21

		setActive(var0_21, true)
	end

	onButton(arg0_21, arg1_21, function()
		if not arg2_21() then
			return
		end

		var1_21()
		arg3_21()
	end, SFX_PANEL)
end

function var0_0.SwitchPhase(arg0_24, arg1_24)
	local var0_24 = arg0_24.shop
	local var1_24 = var0_24:GetPhases()[arg1_24]

	arg0_24.displays = var0_24:GetOpeningGoodsList(var1_24)

	table.sort(arg0_24.displays, function(arg0_25, arg1_25)
		local var0_25 = arg0_25:CanPurchase() and 1 or 0
		local var1_25 = arg1_25:CanPurchase() and 1 or 0

		if var0_25 == var1_25 then
			return arg0_25.id < arg1_25.id
		else
			return var1_25 < var0_25
		end
	end)
	arg0_24.scrollrect:SetTotalCount(#arg0_24.displays)

	arg0_24.openIndex = arg1_24

	arg0_24:updateLocalRedDotData(arg1_24)
end

function var0_0.Refresh(arg0_26)
	arg0_26:SwitchPhase(arg0_26.openIndex)
	arg0_26:UpdateRes()
end

function var0_0.isPhaseTip(arg0_27, arg1_27)
	if not arg0_27.playerId then
		arg0_27.playerId = getProxy(PlayerProxy):getData().id
	end

	return arg1_27 ~= 1 and arg0_27.shop:IsOpenPhase(arg1_27) and PlayerPrefs.GetInt("newserver_shop_phase_" .. arg1_27 .. "_" .. arg0_27.playerId) == 0
end

function var0_0.updateLocalRedDotData(arg0_28, arg1_28)
	if arg0_28:isPhaseTip(arg1_28) then
		PlayerPrefs.SetInt("newserver_shop_phase_" .. arg1_28 .. "_" .. arg0_28.playerId, 1)
		arg0_28:emit(NewServerCarnivalMediator.UPDATE_SHOP_RED_DOT)
	end
end

function var0_0.isTip(arg0_29)
	if not arg0_29.playerId then
		arg0_29.playerId = getProxy(PlayerProxy):getData().id
	end

	if PlayerPrefs.GetInt("newserver_shop_first_" .. arg0_29.playerId) == 0 then
		return true
	end

	for iter0_29, iter1_29 in pairs(arg0_29.shop:GetPhases()) do
		if arg0_29:isPhaseTip(iter0_29) then
			return true
		end
	end

	return false
end

function var0_0.OnDestroy(arg0_30)
	arg0_30.scrollrect.onInitItem = nil
	arg0_30.scrollrect.onUpdateItem = nil

	for iter0_30, iter1_30 in pairs(arg0_30.cards) do
		iter1_30:Dispose()
	end

	arg0_30.cards = nil

	arg0_30.purchasePage:Destroy()

	arg0_30.purchasePage = nil

	arg0_30.multiWindow:Destroy()

	arg0_30.multiWindow = nil

	arg0_30.singleWindow:Destroy()

	arg0_30.singleWindow = nil
end

return var0_0
