local var0_0 = class("IslandTicketExpiredMsgBoxWindow", import(".IslandCommonMsgboxWindow"))

var0_0.TYPES = {
	EXPIRED = 1,
	REMIND = 2
}

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForTicketExpired"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.contentText = arg0_2._tf:Find("Text")
	arg0_2.scrollRect = arg0_2._tf:Find("scrollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.cards = {}
end

function var0_0.OnShow(arg0_5)
	var0_0.super.OnShow(arg0_5)
	arg0_5:FlushInfo()
end

function var0_0.FlushBtn(arg0_6, arg1_6)
	setActive(arg0_6.cancelBtn, false)
	setActive(arg0_6.confirmBtn, true)

	arg0_6.confirmTxt.text = i18n("word_ok")
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = IslandTicketCard.New(arg1_7)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cards[arg2_8]

	if not var0_8 then
		arg0_8:OnInitItem(arg2_8)

		var0_8 = arg0_8.cards[arg2_8]
	end

	local var1_8 = arg0_8.displays[arg1_8 + 1]

	var0_8:Update(var1_8)
end

function var0_0.FlushInfo(arg0_9)
	local var0_9 = arg0_9.settings.body

	if var0_9.type == var0_0.TYPES.EXPIRED then
		setText(arg0_9.contentText, i18n("island_ticket_expiration_tip2"))
	elseif var0_9.type == var0_0.TYPES.REMIND then
		setText(arg0_9.contentText, i18n("island_ticket_expiration_tip1"))
	end

	arg0_9.displays = var0_9.tickets

	arg0_9.scrollRect:SetTotalCount(#arg0_9.displays, -1)
end

function var0_0.OnDestroy(arg0_10)
	if arg0_10.cards then
		for iter0_10, iter1_10 in pairs(arg0_10.cards) do
			iter1_10:Dispose()
		end

		arg0_10.cards = nil
	end
end

return var0_0
