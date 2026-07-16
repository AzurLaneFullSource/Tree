local var0_0 = class("AuctionGameMainRightInfoItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	return
end

function var0_0.didEnter(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = pg.auction_round[arg1_3.round].name

	if arg1_3.type == AuctionGameConst.EVENT_TYPE_GROUP.COMMON then
		var0_3 = var0_3 .. i18n("auction_main_public_event")

		setActive(arg0_3._go, arg3_3)
	else
		var0_3 = var0_3 .. i18n("auction_main_personal_event")

		setActive(arg0_3._go, arg2_3)
	end

	setText(arg0_3.uiTitleText, var0_3)

	local var1_3 = getProxy(AuctionGameProxy):GetRound() == arg1_3.round
	local var2_3 = pg.auction_event[arg1_3.eventData.eventID]
	local var3_3 = var1_3 and "#324bca" or "#676c7d"

	if var2_3.information_bar == 1 then
		setText(arg0_3.uiResultText, string.format("<color=%s>%s</color>", var3_3, var2_3.describe))
	else
		local var4_3 = arg1_3.eventData.value

		if var2_3.type == AuctionGameConst.EVENT_TYPE.MAX_RARITY then
			var4_3 = i18n("auction_game_rarity_" .. var4_3)
		elseif var2_3.type == AuctionGameConst.EVENT_TYPE.RARITY_ITEMS_CELL_COUNT then
			var4_3 = var4_3 / 100
		else
			var4_3 = StringHelper.ForamtNumber(var4_3)
		end

		setText(arg0_3.uiResultText, string.format("<color=%s>%s</color>", var3_3, var2_3.describe .. "   " .. var4_3))
	end

	local var5_3 = arg0_3.uiResultBg.color

	var5_3.a = var1_3 and 0.3 or 0.1
	arg0_3.uiResultBg.color = var5_3
end

function var0_0.willExit(arg0_4)
	arg0_4:detach()
	Object.Destroy(arg0_4._go)
end

return var0_0
