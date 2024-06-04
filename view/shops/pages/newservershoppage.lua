local var0 = class("NewServerShopPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewServerShopPage"
end

function var0.OnLoaded(arg0)
	arg0.scrollrect = arg0:findTF("scrollView"):GetComponent("LScrollRect")
	arg0.resTxt = arg0:findTF("res_pt/Text"):GetComponent(typeof(Text))
	arg0.resIcon = arg0:findTF("res_pt/icon")
	arg0.pagefooters = {
		arg0:findTF("pagefooter/tpl")
	}
	arg0.pagefooterWid = arg0.pagefooters[1].rect.width
	arg0.pagefooterStartPosX = arg0.pagefooters[1].anchoredPosition.x
	arg0.purchasePage = NewServerShopPurchasePanel.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.multiWindow = NewServerShopMultiWindow.New(arg0._tf, arg0.event)
	arg0.singleWindow = NewServerShopSingleWindow.New(arg0._tf, arg0.event)
	arg0._tf.localPosition = Vector3(-6, -25)
end

function var0.UpdateRes(arg0)
	local var0 = arg0.shop:GetPtId()
	local var1 = getProxy(PlayerProxy):getRawData():getResource(var0)

	arg0.resTxt.text = var1

	if not arg0.isInitResIcon then
		arg0.isInitResIcon = true

		GetImageSpriteFromAtlasAsync(Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var0
		}):getIcon(), "", arg0.resIcon)
	end
end

function var0.OnInit(arg0)
	arg0.cards = {}

	function arg0.scrollrect.onInitItem(arg0)
		arg0:OnInitItem(arg0)
	end

	function arg0.scrollrect.onUpdateItem(arg0, arg1)
		arg0:OnUpdateItem(arg0, arg1)
	end

	arg0:Flush()
end

function var0.OnInitItem(arg0, arg1)
	local var0 = NewServerGoodsCard.New(arg1)

	onButton(arg0, var0._tf, function()
		arg0:OnClickCard(var0)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnClickCard(arg0, arg1)
	local var0 = arg1.commodity
	local var1, var2 = var0:IsOpening(arg0.shop:GetStartTime())

	if not var1 then
		local var3 = (var2.day > 0 and var2.day .. i18n("word_date") or "") .. var2.hour .. i18n("word_hour")

		pg.TipsMgr.GetInstance():ShowTips(i18n("newserver_shop_timelimit", var3))

		return
	end

	if var0:Selectable() then
		arg0.purchasePage:ExecuteAction("Show", var0)
	else
		local var4

		if var0:getConfig("goods_purchase_limit") == 1 or var0:getConfig("type") == 4 then
			var4 = arg0.singleWindow
		else
			var4 = arg0.multiWindow
		end

		var4:ExecuteAction("Open", var0, function(arg0, arg1, arg2)
			if not arg0:CanPurchase() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			pg.m02:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING, {
				id = arg0.id,
				selectedList = arg0:getConfig("goods"),
				count = arg1
			})
		end)
	end
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	if not arg0.cards[arg2] then
		arg0:OnInitItem(arg2)
	end

	local var0 = arg0.cards[arg2]
	local var1 = arg0.displays[arg1 + 1]

	var0:Update(var1, arg0.shop)
end

function var0.FetchShop(arg0, arg1)
	local var0 = getProxy(ShopsProxy):GetNewServerShop()

	if not var0 then
		pg.m02:sendNotification(GAME.GET_NEW_SERVER_SHOP, {
			callback = arg1
		})
	else
		arg1(var0)
	end
end

function var0.SetShop(arg0, arg1)
	arg0.shop = arg1
end

function var0.Flush(arg0)
	if arg0.shop then
		arg0:Show()
		arg0:UpdatePageFooters()
		arg0:UpdateRes()
	else
		arg0:FetchShop(function(arg0)
			if not arg0 then
				return
			end

			arg0.shop = arg0

			arg0:Show()
			arg0:UpdatePageFooters()
			arg0:UpdateRes()
		end)
	end
end

local function var1(arg0, arg1)
	local var0 = arg0.pagefooters[arg1]

	if not var0 then
		local var1 = arg0.pagefooters[1]

		var0 = Object.Instantiate(var1, var1.parent)
		arg0.pagefooters[arg1] = var0
	end

	setActive(var0, true)

	return var0
end

function var0.UpdatePageFooters(arg0)
	local var0 = arg0.shop:GetPhases()

	arg0.pagefooterTrs = {}

	for iter0 = 1, #var0 do
		local var1 = var1(arg0, iter0)

		arg0:UpdatePageFooter(var1, iter0)

		arg0.pagefooterTrs[iter0] = var1
	end

	for iter1 = #var0 + 1, #arg0.pagefooters do
		setActive(arg0.pagefooters[iter1], false)
	end

	local var2 = arg0.contextData.index or 1

	triggerButton(arg0.pagefooterTrs[var2])
end

local var2 = 0

function var0.UpdatePageFooter(arg0, arg1, arg2)
	local var0 = arg0.pagefooterStartPosX + (var2 + arg0.pagefooterWid) * (arg2 - 1)

	setAnchoredPosition(arg1, {
		x = var0
	})

	local var1 = GetSpriteFromAtlas("ui/newservershopui_atlas", "p" .. arg2)

	arg1:Find("Text"):GetComponent(typeof(Image)).sprite = var1

	local var2 = GetSpriteFromAtlas("ui/newservershopui_atlas", "p" .. arg2 .. "_s")

	arg1:Find("mark"):GetComponent(typeof(Image)).sprite = var2

	local var3 = arg1:Find("lock")

	if arg2 ~= 1 then
		local var4 = GetSpriteFromAtlas("ui/newservershopui_atlas", "p" .. arg2 .. "_l")

		var3:GetComponent(typeof(Image)).sprite = var4
	end

	setActive(var3, not arg0.shop:IsOpenPhase(arg2))
	setActive(arg1:Find("tip"), arg0:isPhaseTip(arg2))
	arg0:OnSwitch(arg1, function()
		return arg0.openIndex ~= arg2
	end, function()
		arg0:SwitchPhase(arg2)
		setActive(arg1:Find("tip"), arg0:isPhaseTip(arg2))
	end)
end

function var0.OnSwitch(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("mark")

	local function var1()
		if arg0.markTr then
			setActive(arg0.markTr, false)
		end

		arg0.markTr = var0

		setActive(var0, true)
	end

	onButton(arg0, arg1, function()
		if not arg2() then
			return
		end

		var1()
		arg3()
	end, SFX_PANEL)
end

function var0.SwitchPhase(arg0, arg1)
	local var0 = arg0.shop
	local var1 = var0:GetPhases()[arg1]

	arg0.displays = var0:GetOpeningGoodsList(var1)

	table.sort(arg0.displays, function(arg0, arg1)
		local var0 = arg0:CanPurchase() and 1 or 0
		local var1 = arg1:CanPurchase() and 1 or 0

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var1 < var0
		end
	end)
	arg0.scrollrect:SetTotalCount(#arg0.displays)

	arg0.openIndex = arg1

	arg0:updateLocalRedDotData(arg1)
end

function var0.Refresh(arg0)
	arg0:SwitchPhase(arg0.openIndex)
	arg0:UpdateRes()
end

function var0.isPhaseTip(arg0, arg1)
	if not arg0.playerId then
		arg0.playerId = getProxy(PlayerProxy):getData().id
	end

	return arg1 ~= 1 and arg0.shop:IsOpenPhase(arg1) and PlayerPrefs.GetInt("newserver_shop_phase_" .. arg1 .. "_" .. arg0.playerId) == 0
end

function var0.updateLocalRedDotData(arg0, arg1)
	if arg0:isPhaseTip(arg1) then
		PlayerPrefs.SetInt("newserver_shop_phase_" .. arg1 .. "_" .. arg0.playerId, 1)
		arg0:emit(NewServerCarnivalMediator.UPDATE_SHOP_RED_DOT)
	end
end

function var0.isTip(arg0)
	if not arg0.playerId then
		arg0.playerId = getProxy(PlayerProxy):getData().id
	end

	if PlayerPrefs.GetInt("newserver_shop_first_" .. arg0.playerId) == 0 then
		return true
	end

	for iter0, iter1 in pairs(arg0.shop:GetPhases()) do
		if arg0:isPhaseTip(iter0) then
			return true
		end
	end

	return false
end

function var0.OnDestroy(arg0)
	arg0.scrollrect.onInitItem = nil
	arg0.scrollrect.onUpdateItem = nil

	for iter0, iter1 in pairs(arg0.cards) do
		iter1:Dispose()
	end

	arg0.cards = nil

	arg0.purchasePage:Destroy()

	arg0.purchasePage = nil

	arg0.multiWindow:Destroy()

	arg0.multiWindow = nil

	arg0.singleWindow:Destroy()

	arg0.singleWindow = nil
end

return var0
