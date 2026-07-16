local var0_0 = class("AuctionGameMainEventItem", import("view.base.BasePanel"))

var0_0.AUCTION_GAME_SELECTED_EVENT = "AuctionGameMainEventItem::AUCTION_GAME_SELECTED_EVENT"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBtn, function()
		if getProxy(AuctionGameProxy):GetPersonalEventSelectedID() ~= 0 then
			return
		end

		arg0_2:emit(var0_0.AUCTION_GAME_SELECTED_EVENT, arg0_2.id)
	end, SFX_CONFIRM)
end

function var0_0.didEnter(arg0_4, arg1_4)
	arg0_4.id = arg1_4

	local var0_4 = pg.auction_event[arg1_4]

	setText(arg0_4.uiNameText, shortenString(var0_4.name, 9))
	setText(arg0_4.uiDescText, var0_4.describe)
	LoadSpriteAsync(var0_4.icon, function(arg0_5)
		if IsNil(arg0_4.uiIconImage) then
			return
		end

		arg0_4.uiIconImage.sprite = arg0_5
	end)
end

function var0_0.SetSelected(arg0_6, arg1_6)
	setActive(arg0_6.uiSelectedGo, arg0_6.id == arg1_6)
end

function var0_0.willExit(arg0_7)
	arg0_7:detach()
end

return var0_0
