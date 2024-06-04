local var0 = class("AmusementParkShopPage", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "AmusementParkShopPage"
end

function var0.init(arg0)
	arg0.goodsContainer = arg0._tf:Find("Box/Container/Goods")
	arg0.specialsContainer = arg0._tf:Find("Box/Container/SpecialList")
	arg0.specailsDecoration = arg0._tf:Find("Box/Container/Specials")
	arg0.specailsOtherDecoration = arg0._tf:Find("Box/Container/SpecialsOther")

	setActive(arg0.specailsOtherDecoration, false)

	arg0.chat = arg0._tf:Find("Box/Bubble")
	arg0.chatText = arg0.chat:Find("BubbleText")
	arg0.chatClick = arg0._tf:Find("Box/BubbleClick")
	arg0.chatActive = false
	arg0.pollText = {
		i18n("amusementpark_shop_carousel1"),
		i18n("amusementpark_shop_carousel2"),
		i18n("amusementpark_shop_carousel3"),
		i18n("amusementpark_shop_0")
	}
	arg0.pollIndex = math.random(0, math.max(0, #arg0.pollText - 1))
	arg0.msgbox = arg0._tf:Find("Msgbox")

	setActive(arg0.msgbox, false)

	arg0.contentText = arg0.msgbox:Find("window/msg_panel/content"):GetComponent("RichText")
end

function var0.SetShop(arg0, arg1)
	arg0.shop = arg1
end

function var0.SetSpecial(arg0, arg1)
	arg0.specialLists = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0._tf:Find("Top/Help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.amusementpark_shop_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.msgbox:Find("BG"), function()
		setActive(arg0.msgbox, false)
	end)
	onButton(arg0, arg0.msgbox:Find("window/button_container/Button1"), function()
		setActive(arg0.msgbox, false)
	end, SFX_CANCEL)
	onButton(arg0, arg0.chatClick, function()
		arg0:SetActiveBubble(not arg0.chatActive)
	end)

	local var0 = arg0.shop:getResId()
	local var1 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var0
	}):getIcon()

	arg0.contentText:AddSprite(var1, LoadSprite(var1, ""))
	arg0:UpdateView()
	arg0:ShowEnterMsg()
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)
end

function var0.ShowEnterMsg(arg0)
	if _.all(_.values(arg0.shop.goods), function(arg0)
		return not arg0:canPurchase()
	end) then
		arg0:ShowShipWord(i18n("amusementpark_shop_end"))

		return
	end

	arg0:ShowShipWord(i18n("amusementpark_shop_enter"))
end

function var0.UpdateView(arg0)
	local var0 = arg0.shop:getResId()
	local var1 = getProxy(PlayerProxy):getRawData()[id2res(var0)] or 0

	setText(arg0._tf:Find("Box/TicketText"), "X" .. var1)
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

		updateDrop(arg2, var4)
		setText(arg2:Find("Price"), var0:getConfig("resource_num"))
		onButton(arg0, arg2, function()
			arg0:OnClickCommodity(var0, function(arg0, arg1)
				arg0:OnPurchase(var0, arg1)
			end)
		end, SFX_PANEL)
	end)
	setActive(arg0.specailsDecoration, #arg0.specialLists > 0)
	setActive(arg0.specailsOtherDecoration, #arg0.specialLists <= 0)
	UIItemList.StaticAlign(arg0.specialsContainer, arg0.specialsContainer:GetChild(0), 3, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		local var0 = arg0.specialLists[arg1 + 1]

		setActive(arg2, var0)

		if not var0 then
			return
		end

		setActive(arg2:Find("mask"), var0.HasGot)
		onButton(arg0, arg2, function()
			arg0:emit(BaseUI.ON_DROP, var0)
		end, SFX_PANEL)
	end)
end

function var0.CheckRes(arg0, arg1, arg2)
	if not arg1:canPurchase() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

		return false
	end

	if ({
		type = arg1:getConfig("resource_category"),
		id = arg1:getConfig("resource_type")
	}):getOwnedCount() < arg1:getConfig("resource_num") * arg2 then
		arg0:ShowMsgbox({
			useGO = true,
			content = i18n("amusementpark_shop_exchange"),
			onYes = function()
				arg0:emit(AmusementParkShopMediator.GO_SCENE, SCENE.TASK)
			end
		})

		return false
	end

	return true
end

function var0.Purchase(arg0, arg1, arg2, arg3, arg4)
	arg0:ShowMsgbox({
		content = i18n("amusementpark_shop_exchange2", arg1:getConfig("resource_num") * arg2, arg1:getConfig("num") * arg2, arg3),
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

	arg0:emit(AmusementParkShopMediator.ON_ACT_SHOPPING, var0, 1, arg1.id, arg2)
end

function var0.ShowMsgbox(arg0, arg1)
	setActive(arg0.msgbox, true)

	arg0.contentText.text = arg1.content

	local var0 = arg0.msgbox:Find("window/button_container/Button2")
	local var1 = arg0.msgbox:Find("window/button_container/Button3")
	local var2 = arg1.useGO

	setActive(var0, not var2)
	setActive(var1, var2)

	local var3 = var2 and var1 or var0

	onButton(arg0, var3, function()
		setActive(arg0.msgbox, false)
		existCall(arg1.onYes)
	end, SFX_CONFIRM)
end

function var0.SetActiveBubble(arg0, arg1, arg2)
	if arg0.chatActive == tobool(arg1) and not arg2 then
		return
	end

	LeanTween.cancel(go(arg0.chat))

	local var0 = 0.3

	arg0.chatActive = tobool(arg1)

	if arg1 then
		setActive(arg0.chat, true)
		LeanTween.scale(arg0.chat.gameObject, Vector3.New(1, 1, 1), var0):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack)
	else
		setActive(arg0.chat, true)
		LeanTween.scale(arg0.chat.gameObject, Vector3.New(0, 0, 0), var0):setFrom(Vector3.New(1, 1, 1)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
			setActive(arg0.chat, false)
		end))
	end
end

function var0.ShowShipWord(arg0, arg1)
	arg0:SetActiveBubble(true, true)
	setText(arg0.chatText, arg1)
	arg0:AddPollingChat()
end

function var0.AddPollingChat(arg0)
	arg0:StopPolling()

	arg0.pollTimer = Timer.New(function()
		local var0 = arg0.pollText[arg0.pollIndex + 1]

		arg0:ShowShipWord(var0)

		arg0.pollIndex = (arg0.pollIndex + 1) % #arg0.pollText
	end, 6)

	arg0.pollTimer:Start()
end

function var0.StopPolling(arg0)
	if not arg0.pollTimer then
		return
	end

	arg0.pollTimer:Stop()

	arg0.pollTimer = nil
end

function var0.StopChat(arg0)
	if LeanTween.isTweening(go(arg0.chat)) then
		LeanTween.cancel(go(arg0.chat))
	end

	setActive(arg0.chat, false)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	arg0:StopPolling()
end

function var0.GetActivityShopTip()
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD)

	if not var0 or var0:isEnd() then
		return
	end

	local var1 = pg.activity_shop_template

	for iter0, iter1 in ipairs(var1.all) do
		if var0.id == var1[iter1].activity then
			local var2 = table.indexof(var0.data1_list, iter1)
			local var3 = var2 and var0.data2_list[var2] or 0
			local var4 = var1[iter1]
			local var5 = var4.num_limit == 0 or var3 < var4.num_limit
			local var6 = Drop.New({
				type = var4.resource_category,
				id = var4.resource_type
			}):getOwnedCount() >= var4.resource_num

			if var5 and var6 then
				return true
			end
		end
	end

	return false
end

return var0
