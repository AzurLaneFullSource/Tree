AuctionGameMainRightView = import("view.activity.AuctionGame.game.main.right.AuctionGameMainRightView")

local var0_0 = class("AuctionGameMainRightGuideView", AuctionGameMainRightView)

function var0_0.OnPopBidLayer(arg0_1)
	arg0_1:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainBidGuideLayer,
		mediator = AuctionGameMainBidMediator
	}))
end

function var0_0.OnPopEventLayer(arg0_2)
	if getProxy(AuctionGameProxy):GetRound() > 1 then
		return
	end

	arg0_2:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = AuctionGameMainEventGuideLayer,
		mediator = AuctionGameMainEventMediator
	}))
end

return var0_0
