local var0_0 = class("IslandTicketGroupCard", import(".IslandTicketCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	setActive(arg0_1.validTimeTF, false)
	setActive(arg0_1.expiredTF, false)

	arg0_1.selectedPanel = arg0_1._tf:Find("icon_bg/selected_panel")
	arg0_1.countInput = arg0_1.selectedPanel:Find("InputField")
	arg0_1.reduceBtn = arg0_1.selectedPanel:Find("reduce")
	arg0_1.emptyTF = arg0_1._tf:Find("empty")
	arg0_1.shopBtn = arg0_1.emptyTF:Find("Image")

	setText(arg0_1.shopBtn:Find("Text"), i18n("island_ticket_shop"))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.group = arg1_2
	arg0_2.allCnt = arg3_2

	setActive(arg0_2.emptyTF, arg0_2.allCnt == 0)

	arg0_2.tickets = arg2_2

	local var0_2 = underscore.reduce(arg0_2.tickets, 0, function(arg0_3, arg1_3)
		return arg0_3 + (arg1_3:WillExpire() and arg1_3:GetCount() or 0)
	end)

	arg0_2.willExpireTxt.text = i18n("island_ticket_nearing_expiration", var0_2)

	setActive(arg0_2.willExpireTF, var0_2 > 0)

	arg0_2.showTicket = arg0_2.tickets[1] or IslandTicket.New(pg.island_speedup_ticket.get_id_list_by_speedup_time[arg1_2][1], 0, 1)

	setText(arg0_2.nameTF, arg0_2.showTicket:getConfig("name"))
	GetImageSpriteFromAtlasAsync("island/islandframe", arg0_2.showTicket:GetFrameName(), arg0_2.frameTF, true)
	GetImageSpriteFromAtlasAsync("ui/islandticketui_atlas", arg0_2.showTicket:GetBgName(), arg0_2.bgTF, true)
	GetImageSpriteFromAtlasAsync(arg0_2.showTicket:GetIconName(), "", arg0_2.iconTF, true)
	arg0_2:UpdateSelCnt(arg4_2)
end

function var0_0.UpdateSelCnt(arg0_4, arg1_4)
	arg0_4.selCnt = arg1_4

	setInputText(arg0_4.countInput, arg0_4.selCnt)
	setText(arg0_4.countTF, arg0_4.allCnt - arg0_4.selCnt)
	setActive(arg0_4.selectedPanel, arg0_4.selCnt > 0)
end

return var0_0
