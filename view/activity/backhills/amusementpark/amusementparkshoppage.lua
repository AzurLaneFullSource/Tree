local var0_0 = class("AmusementParkShopPage", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AmusementParkShopPage"
end

function var0_0.init(arg0_2)
	arg0_2.goodsContainer = arg0_2._tf:Find("Box/Container/Goods")
	arg0_2.specialsContainer = arg0_2._tf:Find("Box/Container/SpecialList")
	arg0_2.specailsDecoration = arg0_2._tf:Find("Box/Container/Specials")
	arg0_2.specailsOtherDecoration = arg0_2._tf:Find("Box/Container/SpecialsOther")

	setActive(arg0_2.specailsOtherDecoration, false)

	arg0_2.chat = arg0_2._tf:Find("Box/Bubble")
	arg0_2.chatText = arg0_2.chat:Find("BubbleText")
	arg0_2.chatClick = arg0_2._tf:Find("Box/BubbleClick")
	arg0_2.chatActive = false
	arg0_2.pollText = {
		i18n("amusementpark_shop_carousel1"),
		i18n("amusementpark_shop_carousel2"),
		i18n("amusementpark_shop_carousel3"),
		i18n("amusementpark_shop_0")
	}
	arg0_2.pollIndex = math.random(0, math.max(0, #arg0_2.pollText - 1))
	arg0_2.msgbox = arg0_2._tf:Find("Msgbox")

	setActive(arg0_2.msgbox, false)

	arg0_2.contentText = arg0_2.msgbox:Find("window/msg_panel/content"):GetComponent("RichText")
end

function var0_0.SetShop(arg0_3, arg1_3)
	arg0_3.shop = arg1_3
end

function var0_0.SetSpecial(arg0_4, arg1_4)
	arg0_4.specialLists = arg1_4
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("Top/Back"), function()
		arg0_5:closeView()
	end, SOUND_BACK)
	onButton(arg0_5, arg0_5._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.amusementpark_shop_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.msgbox:Find("BG"), function()
		setActive(arg0_5.msgbox, false)
	end)
	onButton(arg0_5, arg0_5.msgbox:Find("window/button_container/Button1"), function()
		setActive(arg0_5.msgbox, false)
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.chatClick, function()
		arg0_5:SetActiveBubble(not arg0_5.chatActive)
	end)

	local var0_5 = arg0_5.shop:getResId()
	local var1_5 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var0_5
	}):getIcon()

	arg0_5.contentText:AddSprite(var1_5, LoadSprite(var1_5, ""))
	arg0_5:UpdateView()
	arg0_5:ShowEnterMsg()
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5._tf)
end

function var0_0.ShowEnterMsg(arg0_11)
	if _.all(_.values(arg0_11.shop.goods), function(arg0_12)
		return not arg0_12:canPurchase()
	end) then
		arg0_11:ShowShipWord(i18n("amusementpark_shop_end"))

		return
	end

	arg0_11:ShowShipWord(i18n("amusementpark_shop_enter"))
end

function var0_0.UpdateView(arg0_13)
	local var0_13 = arg0_13.shop:getResId()
	local var1_13 = getProxy(PlayerProxy):getRawData()[id2res(var0_13)] or 0

	setText(arg0_13._tf:Find("Box/TicketText"), "X" .. var1_13)
	arg0_13:UpdateGoods()
end

function var0_0.UpdateGoods(arg0_14)
	local var0_14 = _.values(arg0_14.shop.goods)

	table.sort(var0_14, function(arg0_15, arg1_15)
		return arg0_15.id < arg1_15.id
	end)
	UIItemList.StaticAlign(arg0_14.goodsContainer, arg0_14.goodsContainer:GetChild(0), #var0_14, function(arg0_16, arg1_16, arg2_16)
		if arg0_16 ~= UIItemList.EventUpdate then
			return
		end

		local var0_16 = var0_14[arg1_16 + 1]
		local var1_16 = var0_16:canPurchase()

		setActive(arg2_16:Find("mask"), not var1_16)

		local var2_16 = var0_16:getConfig("commodity_type")
		local var3_16 = var0_16:getConfig("commodity_id")
		local var4_16 = {
			type = var2_16,
			id = var3_16,
			count = var0_16:getConfig("num")
		}

		updateDrop(arg2_16, var4_16)
		setText(arg2_16:Find("Price"), var0_16:getConfig("resource_num"))
		onButton(arg0_14, arg2_16, function()
			arg0_14:OnClickCommodity(var0_16, function(arg0_18, arg1_18)
				arg0_14:OnPurchase(var0_16, arg1_18)
			end)
		end, SFX_PANEL)
	end)
	setActive(arg0_14.specailsDecoration, #arg0_14.specialLists > 0)
	setActive(arg0_14.specailsOtherDecoration, #arg0_14.specialLists <= 0)
	UIItemList.StaticAlign(arg0_14.specialsContainer, arg0_14.specialsContainer:GetChild(0), 3, function(arg0_19, arg1_19, arg2_19)
		if arg0_19 ~= UIItemList.EventUpdate then
			return
		end

		local var0_19 = arg0_14.specialLists[arg1_19 + 1]

		setActive(arg2_19, var0_19)

		if not var0_19 then
			return
		end

		setActive(arg2_19:Find("mask"), var0_19.HasGot)
		onButton(arg0_14, arg2_19, function()
			arg0_14:emit(BaseUI.ON_DROP, var0_19)
		end, SFX_PANEL)
	end)
end

function var0_0.CheckRes(arg0_21, arg1_21, arg2_21)
	if not arg1_21:canPurchase() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return false
	end

	if ({
		type = arg1_21:getConfig("resource_category"),
		id = arg1_21:getConfig("resource_type")
	}):getOwnedCount() < arg1_21:getConfig("resource_num") * arg2_21 then
		arg0_21:ShowMsgbox({
			useGO = true,
			content = i18n("amusementpark_shop_exchange"),
			onYes = function()
				arg0_21:emit(AmusementParkShopMediator.GO_SCENE, SCENE.TASK)
			end
		})

		return false
	end

	return true
end

function var0_0.Purchase(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	arg0_23:ShowMsgbox({
		content = i18n("amusementpark_shop_exchange2", arg1_23:getConfig("resource_num") * arg2_23, arg1_23:getConfig("num") * arg2_23, arg3_23),
		onYes = function()
			if arg0_23:CheckRes(arg1_23, arg2_23) then
				arg4_23(arg1_23, arg2_23)
			end
		end
	})
end

function var0_0.OnClickCommodity(arg0_25, arg1_25, arg2_25)
	if not arg0_25:CheckRes(arg1_25, 1) then
		return
	end

	local var0_25 = Drop.New({
		id = arg1_25:getConfig("commodity_id"),
		type = arg1_25:getConfig("commodity_type")
	})

	arg0_25:Purchase(arg1_25, 1, var0_25:getConfig("name"), arg2_25)
end

function var0_0.OnPurchase(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg0_26.shop.activityId

	arg0_26:emit(AmusementParkShopMediator.ON_ACT_SHOPPING, var0_26, 1, arg1_26.id, arg2_26)
end

function var0_0.ShowMsgbox(arg0_27, arg1_27)
	setActive(arg0_27.msgbox, true)

	arg0_27.contentText.text = arg1_27.content

	local var0_27 = arg0_27.msgbox:Find("window/button_container/Button2")
	local var1_27 = arg0_27.msgbox:Find("window/button_container/Button3")
	local var2_27 = arg1_27.useGO

	setActive(var0_27, not var2_27)
	setActive(var1_27, var2_27)

	local var3_27 = var2_27 and var1_27 or var0_27

	onButton(arg0_27, var3_27, function()
		setActive(arg0_27.msgbox, false)
		existCall(arg1_27.onYes)
	end, SFX_CONFIRM)
end

function var0_0.SetActiveBubble(arg0_29, arg1_29, arg2_29)
	if arg0_29.chatActive == tobool(arg1_29) and not arg2_29 then
		return
	end

	LeanTween.cancel(go(arg0_29.chat))

	local var0_29 = 0.3

	arg0_29.chatActive = tobool(arg1_29)

	if arg1_29 then
		setActive(arg0_29.chat, true)
		LeanTween.scale(arg0_29.chat.gameObject, Vector3.New(1, 1, 1), var0_29):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack)
	else
		setActive(arg0_29.chat, true)
		LeanTween.scale(arg0_29.chat.gameObject, Vector3.New(0, 0, 0), var0_29):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
			setActive(arg0_29.chat, false)
		end))
	end
end

function var0_0.ShowShipWord(arg0_31, arg1_31)
	arg0_31:SetActiveBubble(true, true)
	setText(arg0_31.chatText, arg1_31)
	arg0_31:AddPollingChat()
end

function var0_0.AddPollingChat(arg0_32)
	arg0_32:StopPolling()

	arg0_32.pollTimer = Timer.New(function()
		local var0_33 = arg0_32.pollText[arg0_32.pollIndex + 1]

		arg0_32:ShowShipWord(var0_33)

		arg0_32.pollIndex = (arg0_32.pollIndex + 1) % #arg0_32.pollText
	end, 6)

	arg0_32.pollTimer:Start()
end

function var0_0.StopPolling(arg0_34)
	if not arg0_34.pollTimer then
		return
	end

	arg0_34.pollTimer:Stop()

	arg0_34.pollTimer = nil
end

function var0_0.StopChat(arg0_35)
	if LeanTween.isTweening(go(arg0_35.chat)) then
		LeanTween.cancel(go(arg0_35.chat))
	end

	setActive(arg0_35.chat, false)
end

function var0_0.willExit(arg0_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36._tf)
	arg0_36:StopPolling()
end

function var0_0.GetActivityShopTip()
	local var0_37 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD)

	if not var0_37 or var0_37:isEnd() then
		return
	end

	local var1_37 = pg.activity_shop_template

	for iter0_37, iter1_37 in ipairs(var1_37.all) do
		if var0_37.id == var1_37[iter1_37].activity then
			local var2_37 = table.indexof(var0_37.data1_list, iter1_37)
			local var3_37 = var2_37 and var0_37.data2_list[var2_37] or 0
			local var4_37 = var1_37[iter1_37]
			local var5_37 = var4_37.num_limit == 0 or var3_37 < var4_37.num_limit
			local var6_37 = Drop.New({
				type = var4_37.resource_category,
				id = var4_37.resource_type
			}):getOwnedCount() >= var4_37.resource_num

			if var5_37 and var6_37 then
				return true
			end
		end
	end

	return false
end

return var0_0
