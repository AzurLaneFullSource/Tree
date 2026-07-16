AuctionGameMainEventLayer = import("view.activity.AuctionGame.game.event.AuctionGameMainEventLayer")

local var0_0 = class("AuctionGameMainEventGuideLayer", AuctionGameMainEventLayer)

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)
	onButton(arg0_1, arg0_1.uiBgBtn, function()
		if getProxy(AuctionGameProxy):GetPersonalEventSelectedID() ~= 0 then
			arg0_1:closeView()
		end
	end, SOUND_BACK)
	onButton(arg0_1, arg0_1.uiOkBtn, function()
		if getProxy(AuctionGameProxy):GetPersonalEventSelectedID() ~= 0 then
			return
		end

		if arg0_1.selectedID == 0 then
			return
		end

		AuctionGameTools.GuideSelectedEvent(arg0_1.selectedID)
	end, SFX_CONFIRM)
end

return var0_0
