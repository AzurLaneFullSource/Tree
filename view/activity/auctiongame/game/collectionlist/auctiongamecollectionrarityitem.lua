local var0_0 = class("AuctionGameCollectionRarityItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.uiBtn, function()
		arg0_2:emit(AuctionGameCollectionListLayer.ON_SWITCH_RARITY, arg0_2.rarity)
	end, SFX_PANE)
end

function var0_0.didEnter(arg0_4, arg1_4)
	setText(arg0_4.uiText, i18n("auction_game_rarity_" .. arg1_4))

	arg0_4.rarity = arg1_4

	setActive(arg0_4._go, true)
	arg0_4:SetSelectedRarity(0)
end

function var0_0.SetSelectedRarity(arg0_5, arg1_5)
	local var0_5 = arg0_5.rarity == arg1_5

	setActive(arg0_5.uiSelectedGo, var0_5)
	setTextColor(arg0_5.uiText, var0_5 and Color.NewHex("#FFFFFF") or Color.NewHex("#393a3c"))
end

function var0_0.willExit(arg0_6)
	arg0_6:detach()
end

return var0_0
