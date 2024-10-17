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

function var0_0.ShowBuyWindow(arg0_9)
	setActive(arg0_9.buyWindow, true)
	setActive(arg0_9.unlcokWindow, false)
	arg0_9:Show()

	local var0_9 = var0_0.GetPassID()

	if arg0_9.passId and arg0_9.passId == var0_9 then
		return
	end

	arg0_9.passId = var0_0.GetPassID()

	local var1_9 = Goods.Create({
		shop_id = arg0_9.passId
	}, Goods.TYPE_CHARGE)
	local var2_9 = Drop.Create(var1_9:getConfig("display")[1])

	LoadImageSpriteAtlasAsync(var2_9:getIcon(), "", arg0_9.buyWindow:Find("left/got/award/icon"))
	setText(arg0_9.buyWindow:Find("left/got/award/count"), "x" .. var2_9.count)
	setText(arg0_9.buyWindow:Find("right/tip"), var1_9:getConfig("descrip_extra"))

	local var3_9 = var1_9:getConfig("money")

	if PLATFORM_CODE == PLATFORM_CHT and var1_9:IsLocalPrice() then
		-- block empty
	else
		var3_9 = GetMoneySymbol() .. var3_9
	end

	setText(arg0_9.priceTF, var3_9)

	arg0_9.itemList = var1_9:GetExtraServiceItem()

	arg0_9.uiItemList:align(#arg0_9.itemList)
end

function var0_0.GetPassID()
	local var0_10 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	if var0_10 and not var0_10:isEnd() then
		for iter0_10, iter1_10 in ipairs(pg.pay_data_display.all) do
			local var1_10 = pg.pay_data_display[iter1_10]

			if var1_10.sub_display and type(var1_10.sub_display) == "table" and var1_10.sub_display[1] == var0_10.id then
				return iter1_10
			end
		end
	end
end

function var0_0.ShowUnlockWindow(arg0_11, arg1_11)
	setActive(arg0_11.buyWindow, false)
	setActive(arg0_11.unlcokWindow, true)
	arg0_11:Show()

	local var0_11 = arg1_11:getConfig("display")
	local var1_11 = Drop.Create(var0_11[1])

	updateDrop(arg0_11.unlockItem, var1_11)
	onButton(arg0_11, arg0_11.unlockItem, function()
		arg0_11:emit(BaseUI.ON_NEW_STYLE_DROP, {
			drop = var1_11
		})
	end, SFX_CONFIRM)
end

function var0_0.Show(arg0_13)
	pg.UIMgr.GetInstance():BlurPanel(arg0_13._tf)
	var0_0.super.Show(arg0_13)
end

function var0_0.Hide(arg0_14)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)
	var0_0.super.Hide(arg0_14)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
