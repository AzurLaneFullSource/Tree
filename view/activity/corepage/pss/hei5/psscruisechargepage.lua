local var0_0 = class("PSSCruiseChargePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "PSSCruiseChargePage"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.initTplVar(arg0_3)
	arg0_3.descTip = "blackfriday_battlepass_pay_acquire"
	arg0_3.payTip = "blackfriday_battlepass_pay_tip"
	arg0_3.tplMaskName = nil
end

function var0_0.OnInit(arg0_4)
	arg0_4:initTplVar()

	arg0_4.buyWindow = arg0_4._tf:Find("buy_window")
	arg0_4.cancelBtn = arg0_4.buyWindow:Find("button_container/button_cancel")

	setText(arg0_4.cancelBtn:Find("Image"), i18n("text_cancel"))

	arg0_4.confirmBtn = arg0_4.buyWindow:Find("button_container/button_ok")
	arg0_4.priceTF = arg0_4.confirmBtn:Find("Image")

	setText(arg0_4.buyWindow:Find("left/got/desc"), i18n(arg0_4.descTip))

	local var0_4 = arg0_4.buyWindow:Find("right/items/scrollview/list")

	setText(arg0_4.buyWindow:Find("right/items/Text"), i18n(arg0_4.payTip))

	arg0_4.uiItemList = UIItemList.New(var0_4, var0_4:Find("tpl"))

	arg0_4.uiItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg0_4.itemList[arg1_5]

			if not arg0_4.tplMaskName then
				updateDrop(arg2_5, var0_5)
			else
				updateDrop(arg2_5:Find(arg0_4.tplMaskName), var0_5)
			end

			setText(arg2_5:Find("name"), shortenString(var0_5:getConfig("name"), 4))
			onButton(arg0_4, arg2_5, function()
				arg0_4:emit(BaseUI.ON_NEW_STYLE_DROP, {
					drop = var0_5
				})
			end, SFX_CONFIRM)
		end
	end)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.cancelBtn, function()
		arg0_4:Hide()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.confirmBtn, function()
		if ChargeConst.isNeedSetBirth() then
			arg0_4:emit(PSSHei5Mediator.EVENT_OPEN_BIRTHDAY)
		else
			pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
				shopId = arg0_4.passId
			})
		end
	end, SFX_PANEL)
end

function var0_0.ShowBuyWindow(arg0_10)
	setActive(arg0_10.buyWindow, true)
	arg0_10:Show()

	local var0_10 = var0_0.GetPassID()

	if arg0_10.passId and arg0_10.passId == var0_10 then
		return
	end

	arg0_10.passId = var0_0.GetPassID()

	local var1_10 = Goods.Create({
		shop_id = arg0_10.passId
	}, Goods.TYPE_CHARGE)
	local var2_10 = Drop.Create(var1_10:getConfig("display")[1])

	LoadImageSpriteAtlasAsync(var2_10:getIcon(), "", arg0_10.buyWindow:Find("left/got/award/icon"))
	setText(arg0_10.buyWindow:Find("left/got/award/count"), "x" .. var2_10.count)
	setText(arg0_10.buyWindow:Find("right/tip"), var1_10:getConfig("descrip_extra"))

	local var3_10 = var1_10:getConfig("money")

	if PLATFORM_CODE == PLATFORM_CHT and var1_10:IsLocalPrice() then
		-- block empty
	else
		var3_10 = GetMoneySymbol() .. var3_10
	end

	setText(arg0_10.priceTF, var3_10)

	arg0_10.itemList = var1_10:GetExtraServiceItem()

	arg0_10.uiItemList:align(#arg0_10.itemList)
end

function var0_0.GetPassID()
	local var0_11 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_HEI5)

	if var0_11 and not var0_11:isEnd() then
		for iter0_11, iter1_11 in ipairs(pg.pay_data_display.all) do
			local var1_11 = pg.pay_data_display[iter1_11]

			if var1_11.sub_display and type(var1_11.sub_display) == "table" and var1_11.sub_display[1] == var0_11.id then
				return iter1_11
			end
		end
	end
end

function var0_0.ShowUnlockWindow(arg0_12, arg1_12)
	arg0_12:Hide()
end

function var0_0.Show(arg0_13)
	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
	var0_0.super.Show(arg0_13)
end

function var0_0.Hide(arg0_14)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf)
	var0_0.super.Hide(arg0_14)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
