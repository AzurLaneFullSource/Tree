local var0 = class("NewYearHotSpringShopLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "NewYearHotSpringShopUI"
end

function var0.init(arg0)
	arg0.goodsContainer = arg0._tf:Find("Box/Container/Goods")
	arg0.chat = arg0._tf:Find("Box/Bubble")
	arg0.chatAnimator = GetComponent(arg0.chat, typeof(Animator))
	arg0.chatAnimEvent = GetComponent(arg0.chat, typeof(DftAniEvent))
	arg0.chatText = arg0.chat:Find("BubbleText")
	arg0.chatClick = arg0.chat:Find("BubbleClick")

	setActive(arg0.chat, false)
	setLocalScale(arg0.chat, {
		x = 0,
		y = 0
	})
	setActive(arg0.chat, true)

	arg0.msgbox = arg0._tf:Find("Msgbox")

	setActive(arg0.msgbox, false)

	arg0.contentText = arg0.msgbox:Find("window/msg_panel/content"):GetComponent("RichText")
end

function var0.SetShop(arg0, arg1)
	arg0.shop = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.hotspring_shop_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.msgbox:Find("BG"), function()
		setActive(arg0.msgbox, false)
	end)
	onButton(arg0, arg0.msgbox:Find("window/button_container/Button1"), function()
		setActive(arg0.msgbox, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.chatClick, function()
		arg0:HideChat()
	end)
	onButton(arg0, arg0._tf:Find("Box/Spine"), function()
		arg0:DisplayChat({
			"hotspring_shop_touch1",
			"hotspring_shop_touch2",
			"hotspring_shop_touch3"
		})
		arg0.role:SetActionOnce("touch")
	end)
	arg0:ShowEnterMsg()

	arg0.role = SpineRole.New()

	arg0.role:SetData("mingshi_2")
	arg0:LoadingOn()
	arg0.role:Load(function()
		arg0.role:SetParent(arg0._tf:Find("Box/Spine"))
		arg0.role:SetAction("stand")
		arg0.role:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0.role:SetAction("stand")
			end
		end)
		arg0:LoadingOff()
	end, true)
	arg0:UpdateView()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.ShowEnterMsg(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	if not var0 or var0:isEnd() then
		arg0:DisplayChat({
			"hotspring_shop_end"
		})

		return
	end

	if _.all(_.values(arg0.shop.goods), function(arg0)
		return not arg0:canPurchase()
	end) then
		arg0:DisplayChat({
			"hotspring_shop_finish"
		})

		return
	end

	arg0:DisplayChat({
		"hotspring_shop_enter1",
		"hotspring_shop_enter2"
	})
end

function var0.UpdateView(arg0)
	local var0 = arg0.shop:getResId()
	local var1 = getProxy(PlayerProxy):getRawData()[id2res(var0)] or 0

	setText(arg0._tf:Find("Top/Ticket/TicketText"), var1)
	arg0:UpdateGoods()
end

function var0.UpdateGoods(arg0)
	local var0 = _.values(arg0.shop.goods)

	table.sort(var0, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	UIItemList.StaticAlign(arg0.goodsContainer, arg0.goodsContainer:GetChild(0), #var0, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = var0[arg1 + 1]
		local var1 = var0:canPurchase()

		setActive(arg2:Find("mask"), not var1)

		local var2 = var0:getConfig("commodity_type")
		local var3 = var0:getConfig("commodity_id")
		local var4 = {
			type = var2,
			id = var3,
			count = var0:getConfig("num")
		}

		updateDrop(arg2:Find("Icon"), var4)
		onButton(arg0, arg2, function()
			arg0:OnClickCommodity(var0, function(arg0, arg1)
				arg0:OnPurchase(var0, arg1)
			end)
		end, SFX_PANEL)
	end)
end

function var0.CheckRes(arg0, arg1, arg2)
	if not arg1:canPurchase() then
		arg0:DisplayChat({
			"hotspring_shop_exchanged"
		})

		return false
	end

	if Drop.New({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getOwnedCount() < arg1:getConfig("resource_num") * arg2 then
		arg0:DisplayChat({
			"hotspring_shop_insufficient"
		})

		return false
	end

	return true
end

function var0.Purchase(arg0, arg1, arg2, arg3, arg4)
	arg0:ShowMsgbox({
		content = i18n("hotspring_shop_exchange", arg1:getConfig("resource_num") * arg2, arg1:getConfig("num") * arg2, arg3),
		onYes = function()
			if arg0:CheckRes(arg1, arg2) then
				arg4(arg1, arg2)
			end
		end
	})
end

function var0.OnClickCommodity(arg0, arg1, arg2)
	if not arg0:CheckRes(arg1, 1) then
		return
	end

	local var0 = Drop.New({
		id = arg1:getConfig("commodity_id"),
		type = arg1:getConfig("commodity_type")
	})

	arg0:Purchase(arg1, 1, var0:getConfig("name"), arg2)
end

function var0.OnPurchase(arg0, arg1, arg2)
	local var0 = arg0.shop.activityId

	arg0:emit(NewYearHotSpringShopMediator.ON_ACT_SHOPPING, var0, 1, arg1.id, arg2)
end

function var0.OnShoppingDone(arg0)
	arg0:DisplayChat({
		"hotspring_shop_success1",
		"hotspring_shop_success2"
	})
end

function var0.ShowMsgbox(arg0, arg1)
	setActive(arg0.msgbox, true)

	arg0.contentText.text = arg1.content

	local var0 = arg0.msgbox:Find("window/button_container/Button2")

	onButton(arg0, var0, function()
		setActive(arg0.msgbox, false)
		existCall(arg1.onYes)
	end, SFX_CONFIRM)
end

function var0.DisplayChat(arg0, arg1)
	arg0:HideChat()
	onNextTick(function()
		local var0 = LeanTween.delayedCall(go(arg0.chat), 10, System.Action(function()
			arg0:HideChat()
		end))

		arg0.chatTween = var0.uniqueId

		local var1 = arg1[math.random(#arg1)]
		local var2 = i18n(var1)

		arg0.chatAnimator:ResetTrigger("Shrink")
		arg0.chatAnimator:SetTrigger("Pop")
		arg0.chatAnimEvent:SetTriggerEvent(function()
			setText(arg0.chatText, var2)
		end)
	end)
end

function var0.HideChat(arg0)
	if arg0.chatTween then
		arg0.chatAnimator:ResetTrigger("Pop")
		arg0.chatAnimator:SetTrigger("Shrink")
		arg0.chatAnimEvent:SetTriggerEvent(nil)
		LeanTween.cancel(arg0.chatTween)

		arg0.chatTween = nil
	end
end

function var0.LoadingOn(arg0)
	if arg0.animating then
		return
	end

	arg0.animating = true

	pg.UIMgr.GetInstance():LoadingOn(false)
end

function var0.LoadingOff(arg0)
	if not arg0.animating then
		return
	end

	pg.UIMgr.GetInstance():LoadingOff()

	arg0.animating = false
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0:HideChat()
	arg0.role:Dispose()
	arg0:LoadingOff()
end

return var0
