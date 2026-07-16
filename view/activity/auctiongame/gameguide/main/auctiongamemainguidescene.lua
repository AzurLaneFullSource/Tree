AuctionGameMainScene = import("view.activity.AuctionGame.game.main.AuctionGameMainScene")

local var0_0 = class("AuctionGameMainGuideScene", AuctionGameMainScene)

function var0_0.init(arg0_1)
	AuctionGameTools.GuideInitPlayerList()
	var0_0.super.init(arg0_1)
end

function var0_0.didEnter(arg0_2)
	var0_0.super.didEnter(arg0_2)

	if not pg.NewStoryMgr.GetInstance():IsPlayed("AUCTION_GUIDE_2") then
		AuctionGameTools.GuideRound1()
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_2", nil, function()
			pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_5")
		end)
	else
		SetParent(arg0_2.uiTopPanel, pg.UIMgr.GetInstance().OverlayMain)
		AuctionGameTools.GuideSkipToRound2()
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_6", {
			0
		})
	end
end

function var0_0.InitRightView(arg0_4)
	arg0_4.rightPanelView = AuctionGameMainRightGuideView.New(arg0_4.uiRightPanel, arg0_4)
end

function var0_0.RefreshReadyPanel(arg0_5)
	return
end

function var0_0.OnStartRoundOver(arg0_6)
	arg0_6:AddRoundOverTimer()

	if getProxy(AuctionGameProxy):GetRound() == 1 then
		pg.SystemGuideMgr.GetInstance():PlayByGuideId("AUCTION_GUIDE_6", {
			1
		})
	end

	if getProxy(AuctionGameProxy):GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime() > 0 then
		arg0_6:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
			viewComponent = AuctionGameMainRoundOverLayer,
			mediator = AuctionGameMainRoundOverMediator
		}))
	end
end

function var0_0.AddTimer(arg0_7)
	local var0_7 = getProxy(AuctionGameProxy):GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime()

	setText(arg0_7.uiCdText, var0_7 .. "<size=30>s</size>")
end

function var0_0.AddRoundOverTimer(arg0_8)
	arg0_8:StopTimer()

	arg0_8.timer = Timer.New(function()
		local var0_9 = getProxy(AuctionGameProxy)
		local var1_9 = var0_9:GetTimestamp() - pg.TimeMgr.GetInstance():GetServerTime()

		if var1_9 < 0 then
			arg0_8:StopTimer()

			if var0_9:GetRound() == 1 then
				pg.NewGuideMgr.GetInstance():NextStep()
				AuctionGameTools.GuideRound2()
			else
				pg.NewGuideMgr.GetInstance():NextStep()
				AuctionGameTools.GuideSettlement()
			end

			return
		end

		setText(arg0_8.uiCdText, var1_9 .. "<size=30>s</size>")
	end, 0.5, -1)

	arg0_8.timer:Start()
	arg0_8.timer.func()
end

function var0_0.StopTimer(arg0_10)
	if arg0_10.timer then
		arg0_10.timer:Stop()

		arg0_10.timer = nil
	end
end

return var0_0
