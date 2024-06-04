local var0 = class("BackyardFeedPurchasePage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "BackYardFeedShopPanel"
end

function var0.OnLoaded(arg0)
	arg0.foodItem = arg0._tf:Find("frame")
	arg0.icon = arg0.foodItem:Find("icon_bg/icon")
	arg0.foodName = arg0._tf:Find("frame/name"):GetComponent(typeof(Text))
	arg0.foodDesc = arg0._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0.calPanel = arg0._tf:Find("frame/cal_panel")
	arg0.cancelBtn = arg0._tf:Find("frame/cancel_btn")
	arg0.countValue = arg0.calPanel:Find("value/Text"):GetComponent(typeof(Text))
	arg0.total = arg0.calPanel:Find("total/Text"):GetComponent(typeof(Text))
	arg0.totalIcon = arg0.calPanel:Find("total/icon"):GetComponent(typeof(Image))
	arg0.minusBtn = arg0.calPanel:Find("minus_btn")
	arg0.addBtn = arg0.calPanel:Find("add_btn")
	arg0.tenBtn = arg0.calPanel:Find("ten_btn")
	arg0.confirmBtn = arg0._tf:Find("frame/ok_btn")
	arg0.cancelBtn = arg0._tf:Find("frame/cancel_btn")
	arg0.closetBtn = arg0._tf:Find("frame/close")
	arg0._parentTF = arg0._tf.parent

	setText(arg0.cancelBtn:Find("text"), i18n("word_cancel"))
	setText(arg0.confirmBtn:Find("text"), i18n("word_ok"))
	setText(arg0._tf:Find("frame/title"), i18n("words_information"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closetBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:UpdateFood(arg1)

	local var0 = underscore.detect(getGameset("food_shop_id")[2], function(arg0)
		return arg0[1] == arg1
	end)[2]
	local var1 = pg.shop_template[var0]
	local var2 = var1.resource_type
	local var3 = var1.resource_num
	local var4 = 1

	arg0.total.text = var3 * var4

	LoadSpriteAtlasAsync("props/" .. id2res(var2), "", function(arg0)
		arg0.totalIcon.sprite = arg0
		tf(arg0.totalIcon.gameObject).sizeDelta = Vector2(50, 50)
	end)

	arg0.countValue.text = var4

	onButton(arg0, arg0.minusBtn, function()
		if var4 <= 1 then
			return
		end

		var4 = var4 - 1
		arg0.countValue.text = var4
		arg0.total.text = var3 * var4
	end, SFX_PANEL)
	onButton(arg0, arg0.addBtn, function()
		if var4 == 999 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buyCountLimit", var4))

			return
		end

		var4 = var4 > 999 and 999 or var4 + 1
		arg0.countValue.text = var4
		arg0.total.text = var3 * var4
	end, SFX_PANEL)
	onButton(arg0, arg0.tenBtn, function()
		if var4 == 999 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buyCountLimit", var4))

			return
		end

		var4 = var4 + 10 >= 999 and 999 or var4 + 10
		arg0.countValue.text = var4
		arg0.total.text = var3 * var4
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		arg0:Purchase({
			count = var4,
			resourceType = var2,
			resourceNum = var3,
			shopId = var0
		})
	end, SFX_CONFIRM)
end

function var0.Purchase(arg0, arg1)
	if getProxy(PlayerProxy):getRawData()[id2res(arg1.resourceType)] < arg1.resourceNum * arg1.count then
		if arg1.resourceType == 4 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		elseif arg1.resourceType == 2 and ItemTipPanel.ShowOilBuyTip(arg1.resourceNum * arg1.count) then
			-- block empty
		else
			local var0 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg1.resourceType
			}):getName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_error_noResource", var0))
		end

		arg0:Hide()

		return
	end

	arg0:emit(BackyardFeedMediator.BUY_FOOD, arg1.shopId, arg1.count)
	arg0:Hide()
end

function var0.UpdateFood(arg0, arg1)
	local var0 = Item.getConfigData(arg1)
	local var1 = var0.name
	local var2 = var0.display

	updateItem(arg0.foodItem, Item.New({
		id = arg1,
		cnt = getProxy(BagProxy):getItemCountById(arg1)
	}))

	arg0.foodName.text = var1
	arg0.foodDesc.text = var2
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
