local var0 = class("FeastInvitationPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "FeastInvitationUI"
end

function var0.OnLoaded(arg0)
	arg0.backBtn = arg0:findTF("return")
	arg0.scrollrect = arg0:findTF("left/scrollrect")
	arg0.uilist = UIItemList.New(arg0:findTF("left/scrollrect/conent"), arg0:findTF("left/scrollrect/conent/tpl"))
	arg0.resTicketTr = arg0:findTF("res/ticket")
	arg0.resGiftTr = arg0:findTF("res/gift")
	arg0.resTicket = arg0:findTF("res/ticket/Text"):GetComponent(typeof(Text))
	arg0.resGift = arg0:findTF("res/gift/Text"):GetComponent(typeof(Text))
	arg0.ticketTr = arg0:findTF("main/ticket")
	arg0.ticketMarkTr = arg0:findTF("main/ticket/finish")
	arg0.giftTr = arg0:findTF("main/gift")
	arg0.giftImg = arg0.giftTr:Find("icon"):GetComponent(typeof(Image))
	arg0.giftMarkTr = arg0:findTF("main/gift/finish")
	arg0.ticketTxt = arg0.ticketTr:Find("make/Text"):GetComponent(typeof(Text))

	setText(arg0.giftTr:Find("make/Text"), i18n("feast_label_give_gift"))
	setText(arg0.ticketTr:Find("finish/frame/label"), i18n("feast_label_give_invitation_finish"))
	setText(arg0.giftTr:Find("finish/frame/label"), i18n("feast_label_give_gift_finish"))

	arg0.painting = arg0:findTF("main/painting"):GetComponent(typeof(Image))
	arg0.puzzlePage = FeastMakeTicketPage.New(arg0._tf, arg0.event)
	arg0.giveTicketPage = FeastGiveTicketPage.New(arg0._tf, arg0.event)
	arg0.giveGiftPage = FeastGiveGiftPage.New(arg0._tf, arg0.event)
	arg0.resWindow = FeastResWindow.New(arg0._tf, arg0.event)
	arg0.homeBtn = arg0:findTF("home")
end

function var0.OnInit(arg0)
	arg0:bind(FeastScene.ON_SKIP_GIVE_GIFT, function(arg0, arg1)
		arg0.giveTicketPage:ExecuteAction("Show", arg1)
	end)
	arg0:bind(FeastScene.ON_MAKE_TICKET, function(arg0)
		arg0:OnFlush()
		arg0:UpdateRes()
	end)
	arg0:bind(FeastScene.ON_GOT_TICKET, function(arg0)
		arg0:OnFlush()
	end)
	arg0:bind(FeastScene.ON_GOT_GIFT, function(arg0)
		arg0:OnFlush()
		arg0:UpdateRes()
	end)
	onButton(arg0, arg0.backBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
end

function var0.OnFlush(arg0)
	if arg0.feastShip then
		arg0:UpdateMain(arg0.feastShip)
	end

	local var0 = getProxy(FeastProxy):getRawData():GetInvitedFeastShipList()

	arg0:UpdateFeastShips(var0)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0._tf)

	local var0 = getProxy(FeastProxy):getRawData():GetInvitedFeastShipList()

	arg0:UpdateFeastShips(var0)
	arg0:UpdateRes()
	triggerToggle(arg0.toggles[1], true)
	scrollTo(arg0.scrollrect, 0, 1)
end

function var0.UpdateRes(arg0)
	local var0, var1 = getProxy(FeastProxy):GetConsumeList()
	local var2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_VIRTUAL_BAG)

	arg0.ticketCnt = var2:getVitemNumber(var0)
	arg0.giftCnt = var2:getVitemNumber(var1)
	arg0.resTicket.text = arg0.ticketCnt
	arg0.resGift.text = arg0.giftCnt

	onButton(arg0, arg0.resTicketTr, function()
		arg0.resWindow:ExecuteAction("Show", var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.resGiftTr, function()
		arg0.resWindow:ExecuteAction("Show", var1)
	end, SFX_PANEL)
end

function var0.UpdateFeastShips(arg0, arg1)
	arg0.toggles = {}

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]
			local var1 = var0:GetPrefab()

			LoadSpriteAsync("FeastIcon/" .. var1, function(arg0)
				local var0 = arg2:Find("icon"):GetComponent(typeof(Image))

				var0.sprite = arg0

				var0:SetNativeSize()
			end)
			setActive(arg2:Find("finish"), var0:GotGift() and var0:GotTicket())
			onToggle(arg0, arg2, function(arg0)
				if arg0 then
					arg0:UpdateMain(var0)
				end
			end, SFX_PANEL)
			table.insert(arg0.toggles, arg2)
		end
	end)
	arg0.uilist:align(#arg1)
end

local var1 = {
	[0] = i18n("feast_label_make_invitation"),
	(i18n("feast_label_give_invitation"))
}

function var0.UpdateMain(arg0, arg1)
	setActive(arg0.ticketMarkTr, arg1:GotTicket())
	setActive(arg0.giftMarkTr, arg1:GotGift())

	arg0.ticketTxt.text = var1[arg1:GetInvitationState()]

	local var0 = arg1:GetPrefab()

	LoadSpriteAsync("FeastPainting/" .. var0, function(arg0)
		arg0.painting.sprite = arg0

		arg0.painting:SetNativeSize()
	end)
	LoadSpriteAsync("FeastCharGift/" .. var0, function(arg0)
		arg0.giftImg.sprite = arg0

		arg0.giftImg:SetNativeSize()
	end)
	onButton(arg0, arg0.ticketTr, function()
		if arg1:HasTicket() then
			arg0.giveTicketPage:ExecuteAction("Show", arg1)
		elseif not arg1:GotTicket() then
			if arg0.ticketCnt <= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("feast_no_invitation"))

				return
			end

			arg0.puzzlePage:ExecuteAction("Show", arg1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.giftTr, function()
		if not arg1:GotTicket() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("feast_cant_give_gift_tip"))

			return
		end

		if arg0.giftCnt <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("feast_no_gift"))

			return
		end

		if not arg1:GotGift() then
			arg0.giveGiftPage:ExecuteAction("Show", arg1)
		end
	end, SFX_PANEL)

	arg0.feastShip = arg1
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf, arg0._parentTf)

	if arg0.puzzlePage and arg0.puzzlePage:GetLoaded() and arg0.puzzlePage:isShowing() then
		arg0.puzzlePage:Hide()
	end

	if arg0.giveTicketPage and arg0.giveTicketPage:GetLoaded() and arg0.giveTicketPage:isShowing() then
		arg0.giveTicketPage:Hide()
	end

	if arg0.giveGiftPage and arg0.giveGiftPage:GetLoaded() and arg0.giveGiftPage:isShowing() then
		arg0.giveGiftPage:Hide()
	end

	if arg0.resWindow and arg0.resWindow:GetLoaded() and arg0.resWindow:isShowing() then
		arg0.resWindow:Hide()
	end

	var0.super.Hide(arg0)

	arg0.feastShip = nil
end

function var0.onBackPressed(arg0)
	if arg0.puzzlePage and arg0.puzzlePage:GetLoaded() and arg0.puzzlePage:isShowing() then
		arg0.puzzlePage:Hide()

		return
	end

	if arg0.giveTicketPage and arg0.giveTicketPage:GetLoaded() and arg0.giveTicketPage:isShowing() then
		if not arg0.giveTicketPage:CanInterAction() then
			return
		end

		arg0.giveTicketPage:Hide()

		return
	end

	if arg0.giveGiftPage and arg0.giveGiftPage:GetLoaded() and arg0.giveGiftPage:isShowing() then
		if not arg0.giveGiftPage:CanInterAction() then
			return
		end

		arg0.giveGiftPage:Hide()

		return
	end

	if arg0.resWindow and arg0.resWindow:GetLoaded() and arg0.resWindow:isShowing() then
		arg0.resWindow:Hide()

		return
	end

	if arg0:isShowing() then
		arg0:Hide()
	end
end

function var0.OnDestroy(arg0)
	if arg0.puzzlePage then
		arg0.puzzlePage:Destroy()

		arg0.puzzlePage = nil
	end

	if arg0.giveTicketPage then
		arg0.giveTicketPage:Destroy()

		arg0.giveTicketPage = nil
	end

	if arg0.giveGiftPage then
		arg0.giveGiftPage:Destroy()

		arg0.giveGiftPage = nil
	end

	if arg0.resWindow then
		arg0.resWindow:Destroy()

		arg0.resWindow = nil
	end

	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
