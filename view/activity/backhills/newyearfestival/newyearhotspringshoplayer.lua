local var0_0 = class("NewYearHotSpringShopLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewYearHotSpringShopUI"
end

function var0_0.init(arg0_2)
	arg0_2.goodsContainer = arg0_2._tf:Find("Box/Container/Goods")
	arg0_2.chat = arg0_2._tf:Find("Box/Bubble")
	arg0_2.chatAnimator = GetComponent(arg0_2.chat, typeof(Animator))
	arg0_2.chatAnimEvent = GetComponent(arg0_2.chat, typeof(DftAniEvent))
	arg0_2.chatText = arg0_2.chat:Find("BubbleText")
	arg0_2.chatClick = arg0_2.chat:Find("BubbleClick")

	setActive(arg0_2.chat, false)
	setLocalScale(arg0_2.chat, {
		x = 0,
		y = 0
	})
	setActive(arg0_2.chat, true)

	arg0_2.msgbox = arg0_2._tf:Find("Msgbox")

	setActive(arg0_2.msgbox, false)

	arg0_2.contentText = arg0_2.msgbox:Find("window/msg_panel/content"):GetComponent("RichText")
end

function var0_0.SetShop(arg0_3, arg1_3)
	arg0_3.shop = arg1_3
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("Top/Back"), function()
		arg0_4:closeView()
	end, SOUND_BACK)
	onButton(arg0_4, arg0_4._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hotspring_shop_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.msgbox:Find("BG"), function()
		setActive(arg0_4.msgbox, false)
	end)
	onButton(arg0_4, arg0_4.msgbox:Find("window/button_container/Button1"), function()
		setActive(arg0_4.msgbox, false)
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.chatClick, function()
		arg0_4:HideChat()
	end)
	onButton(arg0_4, arg0_4._tf:Find("Box/Spine"), function()
		arg0_4:DisplayChat({
			"hotspring_shop_touch1",
			"hotspring_shop_touch2",
			"hotspring_shop_touch3"
		})
		arg0_4.role:SetActionOnce("touch")
	end)
	arg0_4:ShowEnterMsg()

	arg0_4.role = SpineRole.New()

	arg0_4.role:SetData("mingshi_2")
	arg0_4:LoadingOn()
	arg0_4.role:Load(function()
		arg0_4.role:SetParent(arg0_4._tf:Find("Box/Spine"))
		arg0_4.role:SetAction("stand")
		arg0_4.role:SetActionCallBack(function(arg0_12)
			if arg0_12 == "finish" then
				arg0_4.role:SetAction("stand")
			end
		end)
		arg0_4:LoadingOff()
	end, true)
	arg0_4:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)
end

function var0_0.ShowEnterMsg(arg0_13)
	local var0_13 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	if not var0_13 or var0_13:isEnd() then
		arg0_13:DisplayChat({
			"hotspring_shop_end"
		})

		return
	end

	if _.all(_.values(arg0_13.shop.goods), function(arg0_14)
		return not arg0_14:canPurchase()
	end) then
		arg0_13:DisplayChat({
			"hotspring_shop_finish"
		})

		return
	end

	arg0_13:DisplayChat({
		"hotspring_shop_enter1",
		"hotspring_shop_enter2"
	})
end

function var0_0.UpdateView(arg0_15)
	local var0_15 = arg0_15.shop:getResId()
	local var1_15 = getProxy(PlayerProxy):getRawData()[id2res(var0_15)] or 0

	setText(arg0_15._tf:Find("Top/Ticket/TicketText"), var1_15)
	arg0_15:UpdateGoods()
end

function var0_0.UpdateGoods(arg0_16)
	local var0_16 = _.values(arg0_16.shop.goods)

	table.sort(var0_16, function(arg0_17, arg1_17)
		return arg0_17.id < arg1_17.id
	end)
	UIItemList.StaticAlign(arg0_16.goodsContainer, arg0_16.goodsContainer:GetChild(0), #var0_16, function(arg0_18, arg1_18, arg2_18)
		if arg0_18 ~= UIItemList.EventUpdate then
			return
		end

		local var0_18 = var0_16[arg1_18 + 1]
		local var1_18 = var0_18:canPurchase()

		setActive(arg2_18:Find("mask"), not var1_18)

		local var2_18 = var0_18:getConfig("commodity_type")
		local var3_18 = var0_18:getConfig("commodity_id")
		local var4_18 = {
			type = var2_18,
			id = var3_18,
			count = var0_18:getConfig("num")
		}

		updateDrop(arg2_18:Find("Icon"), var4_18)
		onButton(arg0_16, arg2_18, function()
			arg0_16:OnClickCommodity(var0_18, function(arg0_20, arg1_20)
				arg0_16:OnPurchase(var0_18, arg1_20)
			end)
		end, SFX_PANEL)
	end)
end

function var0_0.CheckRes(arg0_21, arg1_21, arg2_21)
	if not arg1_21:canPurchase() then
		arg0_21:DisplayChat({
			"hotspring_shop_exchanged"
		})

		return false
	end

	if Drop.New({
		type = arg1_21:getConfig("resource_category"),
		id = arg1_21:getConfig("resource_type")
	}):getOwnedCount() < arg1_21:getConfig("resource_num") * arg2_21 then
		arg0_21:DisplayChat({
			"hotspring_shop_insufficient"
		})

		return false
	end

	return true
end

function var0_0.Purchase(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	arg0_22:ShowMsgbox({
		content = i18n("hotspring_shop_exchange", arg1_22:getConfig("resource_num") * arg2_22, arg1_22:getConfig("num") * arg2_22, arg3_22),
		onYes = function()
			if arg0_22:CheckRes(arg1_22, arg2_22) then
				arg4_22(arg1_22, arg2_22)
			end
		end
	})
end

function var0_0.OnClickCommodity(arg0_24, arg1_24, arg2_24)
	if not arg0_24:CheckRes(arg1_24, 1) then
		return
	end

	local var0_24 = Drop.New({
		id = arg1_24:getConfig("commodity_id"),
		type = arg1_24:getConfig("commodity_type")
	})

	arg0_24:Purchase(arg1_24, 1, var0_24:getConfig("name"), arg2_24)
end

function var0_0.OnPurchase(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.shop.activityId

	arg0_25:emit(NewYearHotSpringShopMediator.ON_ACT_SHOPPING, var0_25, 1, arg1_25.id, arg2_25)
end

function var0_0.OnShoppingDone(arg0_26)
	arg0_26:DisplayChat({
		"hotspring_shop_success1",
		"hotspring_shop_success2"
	})
end

function var0_0.ShowMsgbox(arg0_27, arg1_27)
	setActive(arg0_27.msgbox, true)

	arg0_27.contentText.text = arg1_27.content

	local var0_27 = arg0_27.msgbox:Find("window/button_container/Button2")

	onButton(arg0_27, var0_27, function()
		setActive(arg0_27.msgbox, false)
		existCall(arg1_27.onYes)
	end, SFX_CONFIRM)
end

function var0_0.DisplayChat(arg0_29, arg1_29)
	arg0_29:HideChat()
	onNextTick(function()
		local var0_30 = LeanTween.delayedCall(go(arg0_29.chat), 10, System.Action(function()
			arg0_29:HideChat()
		end))

		arg0_29.chatTween = var0_30.uniqueId

		local var1_30 = arg1_29[math.random(#arg1_29)]
		local var2_30 = i18n(var1_30)

		arg0_29.chatAnimator:ResetTrigger("Shrink")
		arg0_29.chatAnimator:SetTrigger("Pop")
		arg0_29.chatAnimEvent:SetTriggerEvent(function()
			setText(arg0_29.chatText, var2_30)
		end)
	end)
end

function var0_0.HideChat(arg0_33)
	if arg0_33.chatTween then
		arg0_33.chatAnimator:ResetTrigger("Pop")
		arg0_33.chatAnimator:SetTrigger("Shrink")
		arg0_33.chatAnimEvent:SetTriggerEvent(nil)
		LeanTween.cancel(arg0_33.chatTween)

		arg0_33.chatTween = nil
	end
end

function var0_0.LoadingOn(arg0_34)
	if arg0_34.animating then
		return
	end

	arg0_34.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0_0.LoadingOff(arg0_35)
	if not arg0_35.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0_35.animating = false
end

function var0_0.willExit(arg0_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36._tf)
	arg0_36:HideChat()
	arg0_36.role:Dispose()
	arg0_36:LoadingOff()
end

return var0_0
