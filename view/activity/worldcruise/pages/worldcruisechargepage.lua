local var0_0 = class("WorldCruiseChargePage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldCruiseChargePage"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	arg0_3.buyWindow = arg0_3._tf:Find("buy_window")
	arg0_3.cancelBtn = arg0_3.buyWindow:Find("button_container/button_cancel")

	setText(arg0_3.cancelBtn:Find("Image"), i18n("text_cancel"))

	arg0_3.confirmBtn = arg0_3.buyWindow:Find("button_container/button_ok")
	arg0_3.priceTF = arg0_3.confirmBtn:Find("Image")

	setText(arg0_3.buyWindow:Find("left/got/desc"), i18n("battlepass_pay_acquire"))

	local var0_3 = arg0_3.buyWindow:Find("right/items/scrollview/list")

	arg0_3.uiItemList = UIItemList.New(var0_3, var0_3:Find("tpl"))

	arg0_3.uiItemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.itemList[arg1_4]

			updateDrop(arg2_4, var0_4)
			setText(arg2_4:Find("name"), shortenString(var0_4:getConfig("name"), 4))
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(BaseUI.ON_NEW_STYLE_DROP, {
					drop = var0_4
				})
			end, SFX_CONFIRM)
		end
	end)

	arg0_3.unlcokWindow = arg0_3._tf:Find("unlock_window")

	setText(arg0_3.unlcokWindow:Find("tip"), i18n("word_click_to_close"))

	arg0_3.unlockItem = arg0_3.unlcokWindow:Find("IconTpl")

	onButton(arg0_3, arg0_3._tf:Find("bg"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if ChargeConst.isNeedSetBirth() then
			arg0_3:emit(WorldCruiseMediator.EVENT_OPEN_BIRTHDAY)
		else
			pg.m02:sendNotification(GAME.CHARGE_OPERATION, {
				shopId = arg0_3.passId
			})
		end
	end, SFX_PANEL)
end

function var0_0.GetPassId(arg0_9)
	return var0_0.GetPassID()
end

function var0_0.ShowBuyWindow(arg0_10)
	setActive(arg0_10.buyWindow, true)
	setActive(arg0_10.unlcokWindow, false)
	arg0_10:Show()

	local var0_10 = arg0_10:GetPassId()

	if arg0_10.passId and arg0_10.passId == var0_10 then
		return
	end

	arg0_10.passId = arg0_10:GetPassId()

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
	local var0_11 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_11 and not var0_11:isEnd() then
		for iter0_11, iter1_11 in ipairs(pg.pay_data_display.all) do
			local var1_11 = pg.pay_data_display[iter1_11]

			if var1_11.sub_display and type(var1_11.sub_display) == "table" and var1_11.sub_display[1] == var0_11.id then
				return iter1_11
			end
		end
	end
end

function var0_0.ShowUnlockWindow(arg0_12, arg1_12, arg2_12)
	setActive(arg0_12.buyWindow, false)
	setActive(arg0_12.unlcokWindow, true)
	arg0_12:Show()

	local var0_12 = arg1_12:getConfig("display")
	local var1_12 = Drop.Create(var0_12[1])

	updateDrop(arg0_12.unlockItem, var1_12)
	onButton(arg0_12, arg0_12.unlockItem, function()
		arg0_12:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var1_12
		})
	end, SFX_CONFIRM)

	arg0_12.onHide = arg2_12
end

function var0_0.Show(arg0_14)
	pg.UIMgr.GetInstance():BlurPanel(arg0_14._tf)
	var0_0.super.Show(arg0_14)
end

function var0_0.Hide(arg0_15)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_15._tf)
	var0_0.super.Hide(arg0_15)

	if arg0_15.onHide then
		arg0_15.onHide()

		arg0_15.onHide = nil
	end
end

function var0_0.OnDestroy(arg0_16)
	if arg0_16:isShowing() then
		arg0_16:Hide()
	end
end

return var0_0
