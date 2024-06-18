local var0_0 = class("BackyardFeedPurchasePage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BackYardFeedShopPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.foodItem = arg0_2._tf:Find("frame")
	arg0_2.icon = arg0_2.foodItem:Find("icon_bg/icon")
	arg0_2.foodName = arg0_2._tf:Find("frame/name"):GetComponent(typeof(Text))
	arg0_2.foodDesc = arg0_2._tf:Find("frame/desc"):GetComponent(typeof(Text))
	arg0_2.calPanel = arg0_2._tf:Find("frame/cal_panel")
	arg0_2.cancelBtn = arg0_2._tf:Find("frame/cancel_btn")
	arg0_2.countValue = arg0_2.calPanel:Find("value/Text"):GetComponent(typeof(Text))
	arg0_2.total = arg0_2.calPanel:Find("total/Text"):GetComponent(typeof(Text))
	arg0_2.totalIcon = arg0_2.calPanel:Find("total/icon"):GetComponent(typeof(Image))
	arg0_2.minusBtn = arg0_2.calPanel:Find("minus_btn")
	arg0_2.addBtn = arg0_2.calPanel:Find("add_btn")
	arg0_2.tenBtn = arg0_2.calPanel:Find("ten_btn")
	arg0_2.confirmBtn = arg0_2._tf:Find("frame/ok_btn")
	arg0_2.cancelBtn = arg0_2._tf:Find("frame/cancel_btn")
	arg0_2.closetBtn = arg0_2._tf:Find("frame/close")
	arg0_2._parentTF = arg0_2._tf.parent

	setText(arg0_2.cancelBtn:Find("text"), i18n("word_cancel"))
	setText(arg0_2.confirmBtn:Find("text"), i18n("word_ok"))
	setText(arg0_2._tf:Find("frame/title"), i18n("words_information"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closetBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	arg0_7:UpdateFood(arg1_7)

	local var0_7 = underscore.detect(getGameset("food_shop_id")[2], function(arg0_8)
		return arg0_8[1] == arg1_7
	end)[2]
	local var1_7 = pg.shop_template[var0_7]
	local var2_7 = var1_7.resource_type
	local var3_7 = var1_7.resource_num
	local var4_7 = 1

	arg0_7.total.text = var3_7 * var4_7

	LoadSpriteAtlasAsync("props/" .. id2res(var2_7), "", function(arg0_9)
		arg0_7.totalIcon.sprite = arg0_9
		tf(arg0_7.totalIcon.gameObject).sizeDelta = Vector2(50, 50)
	end)

	arg0_7.countValue.text = var4_7

	onButton(arg0_7, arg0_7.minusBtn, function()
		if var4_7 <= 1 then
			return
		end

		var4_7 = var4_7 - 1
		arg0_7.countValue.text = var4_7
		arg0_7.total.text = var3_7 * var4_7
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.addBtn, function()
		if var4_7 == 999 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buyCountLimit", var4_7))

			return
		end

		var4_7 = var4_7 > 999 and 999 or var4_7 + 1
		arg0_7.countValue.text = var4_7
		arg0_7.total.text = var3_7 * var4_7
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.tenBtn, function()
		if var4_7 == 999 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_buyCountLimit", var4_7))

			return
		end

		var4_7 = var4_7 + 10 >= 999 and 999 or var4_7 + 10
		arg0_7.countValue.text = var4_7
		arg0_7.total.text = var3_7 * var4_7
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		arg0_7:Purchase({
			count = var4_7,
			resourceType = var2_7,
			resourceNum = var3_7,
			shopId = var0_7
		})
	end, SFX_CONFIRM)
end

function var0_0.Purchase(arg0_14, arg1_14)
	if getProxy(PlayerProxy):getRawData()[id2res(arg1_14.resourceType)] < arg1_14.resourceNum * arg1_14.count then
		if arg1_14.resourceType == 4 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		elseif arg1_14.resourceType == 2 and ItemTipPanel.ShowOilBuyTip(arg1_14.resourceNum * arg1_14.count) then
			-- block empty
		else
			local var0_14 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg1_14.resourceType
			}):getName()

			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardGranaryLayer_error_noResource", var0_14))
		end

		arg0_14:Hide()

		return
	end

	arg0_14:emit(BackyardFeedMediator.BUY_FOOD, arg1_14.shopId, arg1_14.count)
	arg0_14:Hide()
end

function var0_0.UpdateFood(arg0_15, arg1_15)
	local var0_15 = Item.getConfigData(arg1_15)
	local var1_15 = var0_15.name
	local var2_15 = var0_15.display

	updateItem(arg0_15.foodItem, Item.New({
		id = arg1_15,
		cnt = getProxy(BagProxy):getItemCountById(arg1_15)
	}))

	arg0_15.foodName.text = var1_15
	arg0_15.foodDesc.text = var2_15
end

function var0_0.Hide(arg0_16)
	var0_0.super.Hide(arg0_16)
end

function var0_0.OnDestroy(arg0_17)
	arg0_17:Hide()
end

return var0_0
