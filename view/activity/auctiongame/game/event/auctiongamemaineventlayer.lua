local var0_0 = class("AuctionGameMainEventLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainEventUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiOkBtn, function()
		local var0_4 = getProxy(AuctionGameProxy)

		if var0_4:GetPersonalEventSelectedID() ~= 0 then
			return
		end

		if arg0_2.selectedID == 0 then
			return
		end

		local var1_4 = pg.gameset.auction_event_choose_time.key_value - (var0_4:GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime())

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildAuctionChooseEvent(var0_4:GetAuctionID(), var0_4:GetRound(), var1_4, arg0_2.selectedID))
		arg0_2:emit(AuctionGameMainEventMediator.EVENT_SELECTED_ID, arg0_2.selectedID)
	end, SFX_CONFIRM)

	arg0_2.eventItemList = {}
end

function var0_0.didEnter(arg0_5)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(AuctionGameConst.SOUND_EFFECT.EXPAND_POPUP)
	arg0_5:OverlayPanel(arg0_5._tf, {
		pbList = {
			arg0_5.uiBg
		}
	})

	local var0_5 = getProxy(AuctionGameProxy)
	local var1_5 = var0_5:GetPersonalEventList()

	for iter0_5, iter1_5 in ipairs(var1_5) do
		arg0_5.eventItemList[iter0_5] = AuctionGameMainEventItem.New(arg0_5[string.format("uiEventItemTf%s", iter0_5)], arg0_5)

		arg0_5.eventItemList[iter0_5]:didEnter(iter1_5)
	end

	arg0_5:OnSelectedID(_, var0_5:GetPersonalEventSelectedID())

	arg0_5.eventList = {
		arg0_5:bind(AuctionGameMainEventItem.AUCTION_GAME_SELECTED_EVENT, handler(arg0_5, arg0_5.OnSelectedID))
	}
end

function var0_0.OnSelectedID(arg0_6, arg1_6, arg2_6)
	arg0_6.selectedID = arg2_6

	for iter0_6, iter1_6 in ipairs(arg0_6.eventItemList) do
		iter1_6:SetSelected(arg2_6)
	end

	arg0_6:RefreshOkBtn()
end

function var0_0.RefreshOkBtn(arg0_7)
	if getProxy(AuctionGameProxy):GetPersonalEventSelectedID() ~= 0 then
		return
	end
end

function var0_0.willExit(arg0_8)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(AuctionGameConst.SOUND_EFFECT.COLLAPSE_POPUP)
	arg0_8:UnOverlayPanel(arg0_8._tf)

	for iter0_8, iter1_8 in ipairs(arg0_8.eventList) do
		arg0_8:disconnect(iter1_8)
	end

	arg0_8.eventList = nil

	for iter2_8, iter3_8 in ipairs(arg0_8.eventItemList) do
		iter3_8:willExit()
	end

	arg0_8.eventItemList = nil
end

return var0_0
