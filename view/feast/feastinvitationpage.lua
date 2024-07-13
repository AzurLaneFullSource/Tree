local var0_0 = class("FeastInvitationPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FeastInvitationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("return")
	arg0_2.scrollrect = arg0_2:findTF("left/scrollrect")
	arg0_2.uilist = UIItemList.New(arg0_2:findTF("left/scrollrect/conent"), arg0_2:findTF("left/scrollrect/conent/tpl"))
	arg0_2.resTicketTr = arg0_2:findTF("res/ticket")
	arg0_2.resGiftTr = arg0_2:findTF("res/gift")
	arg0_2.resTicket = arg0_2:findTF("res/ticket/Text"):GetComponent(typeof(Text))
	arg0_2.resGift = arg0_2:findTF("res/gift/Text"):GetComponent(typeof(Text))
	arg0_2.ticketTr = arg0_2:findTF("main/ticket")
	arg0_2.ticketMarkTr = arg0_2:findTF("main/ticket/finish")
	arg0_2.giftTr = arg0_2:findTF("main/gift")
	arg0_2.giftImg = arg0_2.giftTr:Find("icon"):GetComponent(typeof(Image))
	arg0_2.giftMarkTr = arg0_2:findTF("main/gift/finish")
	arg0_2.ticketTxt = arg0_2.ticketTr:Find("make/Text"):GetComponent(typeof(Text))

	setText(arg0_2.giftTr:Find("make/Text"), i18n("feast_label_give_gift"))
	setText(arg0_2.ticketTr:Find("finish/frame/label"), i18n("feast_label_give_invitation_finish"))
	setText(arg0_2.giftTr:Find("finish/frame/label"), i18n("feast_label_give_gift_finish"))

	arg0_2.painting = arg0_2:findTF("main/painting"):GetComponent(typeof(Image))
	arg0_2.puzzlePage = FeastMakeTicketPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.giveTicketPage = FeastGiveTicketPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.giveGiftPage = FeastGiveGiftPage.New(arg0_2._tf, arg0_2.event)
	arg0_2.resWindow = FeastResWindow.New(arg0_2._tf, arg0_2.event)
	arg0_2.homeBtn = arg0_2:findTF("home")
end

function var0_0.OnInit(arg0_3)
	arg0_3:bind(FeastScene.ON_SKIP_GIVE_GIFT, function(arg0_4, arg1_4)
		arg0_3.giveTicketPage:ExecuteAction("Show", arg1_4)
	end)
	arg0_3:bind(FeastScene.ON_MAKE_TICKET, function(arg0_5)
		arg0_3:OnFlush()
		arg0_3:UpdateRes()
	end)
	arg0_3:bind(FeastScene.ON_GOT_TICKET, function(arg0_6)
		arg0_3:OnFlush()
	end)
	arg0_3:bind(FeastScene.ON_GOT_GIFT, function(arg0_7)
		arg0_3:OnFlush()
		arg0_3:UpdateRes()
	end)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0_0.OnFlush(arg0_10)
	if arg0_10.feastShip then
		arg0_10:UpdateMain(arg0_10.feastShip)
	end

	local var0_10 = getProxy(FeastProxy):getRawData():GetInvitedFeastShipList()

	arg0_10:UpdateFeastShips(var0_10)
end

function var0_0.Show(arg0_11)
	var0_0.super.Show(arg0_11)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_11._tf)

	local var0_11 = getProxy(FeastProxy):getRawData():GetInvitedFeastShipList()

	arg0_11:UpdateFeastShips(var0_11)
	arg0_11:UpdateRes()
	triggerToggle(arg0_11.toggles[1], true)
	scrollTo(arg0_11.scrollrect, 0, 1)
end

function var0_0.UpdateRes(arg0_12)
	local var0_12, var1_12 = getProxy(FeastProxy):GetConsumeList()
	local var2_12 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0_12.ticketCnt = var2_12:getVitemNumber(var0_12)
	arg0_12.giftCnt = var2_12:getVitemNumber(var1_12)
	arg0_12.resTicket.text = arg0_12.ticketCnt
	arg0_12.resGift.text = arg0_12.giftCnt

	onButton(arg0_12, arg0_12.resTicketTr, function()
		arg0_12.resWindow:ExecuteAction("Show", var0_12)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.resGiftTr, function()
		arg0_12.resWindow:ExecuteAction("Show", var1_12)
	end, SFX_PANEL)
end

function var0_0.UpdateFeastShips(arg0_15, arg1_15)
	arg0_15.toggles = {}

	arg0_15.uilist:make(function(arg0_16, arg1_16, arg2_16)
		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg1_15[arg1_16 + 1]
			local var1_16 = var0_16:GetPrefab()

			LoadSpriteAsync("FeastIcon/" .. var1_16, function(arg0_17)
				local var0_17 = arg2_16:Find("icon"):GetComponent(typeof(Image))

				var0_17.sprite = arg0_17

				var0_17:SetNativeSize()
			end)
			setActive(arg2_16:Find("finish"), var0_16:GotGift() and var0_16:GotTicket())
			onToggle(arg0_15, arg2_16, function(arg0_18)
				if arg0_18 then
					arg0_15:UpdateMain(var0_16)
				end
			end, SFX_PANEL)
			table.insert(arg0_15.toggles, arg2_16)
		end
	end)
	arg0_15.uilist:align(#arg1_15)
end

local var1_0 = {
	[0] = i18n("feast_label_make_invitation"),
	(i18n("feast_label_give_invitation"))
}

function var0_0.UpdateMain(arg0_19, arg1_19)
	setActive(arg0_19.ticketMarkTr, arg1_19:GotTicket())
	setActive(arg0_19.giftMarkTr, arg1_19:GotGift())

	arg0_19.ticketTxt.text = var1_0[arg1_19:GetInvitationState()]

	local var0_19 = arg1_19:GetPrefab()

	LoadSpriteAsync("FeastPainting/" .. var0_19, function(arg0_20)
		arg0_19.painting.sprite = arg0_20

		arg0_19.painting:SetNativeSize()
	end)
	LoadSpriteAsync("FeastCharGift/" .. var0_19, function(arg0_21)
		arg0_19.giftImg.sprite = arg0_21

		arg0_19.giftImg:SetNativeSize()
	end)
	onButton(arg0_19, arg0_19.ticketTr, function()
		if arg1_19:HasTicket() then
			arg0_19.giveTicketPage:ExecuteAction("Show", arg1_19)
		elseif not arg1_19:GotTicket() then
			if arg0_19.ticketCnt <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("feast_no_invitation"))

				return
			end

			arg0_19.puzzlePage:ExecuteAction("Show", arg1_19)
		end
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.giftTr, function()
		if not arg1_19:GotTicket() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("feast_cant_give_gift_tip"))

			return
		end

		if arg0_19.giftCnt <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("feast_no_gift"))

			return
		end

		if not arg1_19:GotGift() then
			arg0_19.giveGiftPage:ExecuteAction("Show", arg1_19)
		end
	end, SFX_PANEL)

	arg0_19.feastShip = arg1_19
end

function var0_0.Hide(arg0_24)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_24._tf, arg0_24._parentTf)

	if arg0_24.puzzlePage and arg0_24.puzzlePage:GetLoaded() and arg0_24.puzzlePage:isShowing() then
		arg0_24.puzzlePage:Hide()
	end

	if arg0_24.giveTicketPage and arg0_24.giveTicketPage:GetLoaded() and arg0_24.giveTicketPage:isShowing() then
		arg0_24.giveTicketPage:Hide()
	end

	if arg0_24.giveGiftPage and arg0_24.giveGiftPage:GetLoaded() and arg0_24.giveGiftPage:isShowing() then
		arg0_24.giveGiftPage:Hide()
	end

	if arg0_24.resWindow and arg0_24.resWindow:GetLoaded() and arg0_24.resWindow:isShowing() then
		arg0_24.resWindow:Hide()
	end

	var0_0.super.Hide(arg0_24)

	arg0_24.feastShip = nil
end

function var0_0.onBackPressed(arg0_25)
	if arg0_25.puzzlePage and arg0_25.puzzlePage:GetLoaded() and arg0_25.puzzlePage:isShowing() then
		arg0_25.puzzlePage:Hide()

		return
	end

	if arg0_25.giveTicketPage and arg0_25.giveTicketPage:GetLoaded() and arg0_25.giveTicketPage:isShowing() then
		if not arg0_25.giveTicketPage:CanInterAction() then
			return
		end

		arg0_25.giveTicketPage:Hide()

		return
	end

	if arg0_25.giveGiftPage and arg0_25.giveGiftPage:GetLoaded() and arg0_25.giveGiftPage:isShowing() then
		if not arg0_25.giveGiftPage:CanInterAction() then
			return
		end

		arg0_25.giveGiftPage:Hide()

		return
	end

	if arg0_25.resWindow and arg0_25.resWindow:GetLoaded() and arg0_25.resWindow:isShowing() then
		arg0_25.resWindow:Hide()

		return
	end

	if arg0_25:isShowing() then
		arg0_25:Hide()
	end
end

function var0_0.OnDestroy(arg0_26)
	if arg0_26.puzzlePage then
		arg0_26.puzzlePage:Destroy()

		arg0_26.puzzlePage = nil
	end

	if arg0_26.giveTicketPage then
		arg0_26.giveTicketPage:Destroy()

		arg0_26.giveTicketPage = nil
	end

	if arg0_26.giveGiftPage then
		arg0_26.giveGiftPage:Destroy()

		arg0_26.giveGiftPage = nil
	end

	if arg0_26.resWindow then
		arg0_26.resWindow:Destroy()

		arg0_26.resWindow = nil
	end

	if arg0_26:isShowing() then
		arg0_26:Hide()
	end
end

return var0_0
