local var0_0 = class("IslandTicketStoragePage", import("...base.IslandBasePage"))

var0_0.SORT_TYPES = {
	VALID = 1,
	SPEED_UP = 2
}

function var0_0.getUIName(arg0_1)
	return "IslandTicketStorageUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("frame/title"), i18n("island_ticket_storage_title"))

	arg0_2.ascToggleTF = arg0_2._tf:Find("toggle_asc")
	arg0_2.sortToggleTF = arg0_2._tf:Find("toggle_sort")
	arg0_2.sortPanelAnim = arg0_2._tf:Find("sort_panel"):GetComponent(typeof(Animation))
	arg0_2.sortByValidBtn = arg0_2._tf:Find("sort_panel/valid")

	setText(arg0_2.sortByValidBtn:Find("Text"), i18n("island_ticket_sort_valid"))

	arg0_2.sortBySpeedupBtn = arg0_2._tf:Find("sort_panel/speedup")

	setText(arg0_2.sortBySpeedupBtn:Find("Text"), i18n("island_ticket_sort_speedup"))

	arg0_2.confirmBtn = arg0_2._tf:Find("confirm")

	setText(arg0_2.confirmBtn:Find("Text"), i18n("word_ok"))

	arg0_2.scrollRect = arg0_2._tf:Find("scrollrect"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf:Find("frame/title/help"), function()
		arg0_5:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_helpbtn_speedup")
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("frame/close"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("mask"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.ascToggleTF, function(arg0_10)
		arg0_5.isAsc = arg0_10

		arg0_5:SetTotalCount()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.sortToggleTF, function(arg0_11)
		local var0_11 = arg0_11 and "anim_IslandTicketStorageUI_sort_in" or "anim_IslandTicketStorageUI_sort_out"

		arg0_5.sortPanelAnim:Play(var0_11)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.sortByValidBtn, function()
		arg0_5.sortType = var0_0.SORT_TYPES.VALID

		setText(arg0_5.sortToggleTF:Find("Text"), i18n("island_ticket_sort_valid"))
		triggerToggle(arg0_5.sortToggleTF, false)
		arg0_5:SetTotalCount()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.sortBySpeedupBtn, function()
		arg0_5.sortType = var0_0.SORT_TYPES.SPEED_UP

		setText(arg0_5.sortToggleTF:Find("Text"), i18n("island_ticket_sort_speedup"))
		triggerToggle(arg0_5.sortToggleTF, false)
		arg0_5:SetTotalCount()
	end, SFX_PANEL)

	arg0_5.cards = {}
end

function var0_0.OnInitItem(arg0_14, arg1_14)
	local var0_14 = IslandTicketCard.New(arg1_14)

	arg0_14.cards[arg1_14] = var0_14
end

function var0_0.OnUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:OnInitItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local var1_15 = arg0_15.displays[arg1_15 + 1]

	var0_15:Update(var1_15)
end

function var0_0.OnShow(arg0_16)
	arg0_16:BlurPanel()

	arg0_16.ticketAgency = getProxy(IslandProxy):GetIsland():GetTicketAgency()
	arg0_16.displays = arg0_16.ticketAgency:GetAllTicketList()
	arg0_16.isAsc = true
	arg0_16.sortType = var0_0.SORT_TYPES.SPEED_UP

	triggerButton(arg0_16.sortBySpeedupBtn)
end

function var0_0.SetTotalCount(arg0_17)
	if arg0_17.sortType == var0_0.SORT_TYPES.VALID then
		arg0_17:SortByValid()
	elseif arg0_17.sortType == var0_0.SORT_TYPES.SPEED_UP then
		arg0_17:SortBySpeedup()
	end

	arg0_17.scrollRect:SetTotalCount(#arg0_17.displays, -1)
end

function var0_0.SortBySpeedup(arg0_18)
	local var0_18 = arg0_18.isAsc and 1 or -1

	table.sort(arg0_18.displays, CompareFuncs({
		function(arg0_19)
			return var0_18 * arg0_19:GetTime()
		end,
		function(arg0_20)
			return var0_18 * (arg0_20:IsForever() and 1 or 0)
		end,
		function(arg0_21)
			return var0_18 * arg0_21:GetEndTime()
		end,
		function(arg0_22)
			return var0_18 * arg0_22.id
		end
	}))
end

function var0_0.SortByValid(arg0_23)
	local var0_23 = arg0_23.isAsc and 1 or -1

	table.sort(arg0_23.displays, CompareFuncs({
		function(arg0_24)
			return var0_23 * (arg0_24:IsForever() and 1 or 0)
		end,
		function(arg0_25)
			return var0_23 * arg0_25:GetEndTime()
		end,
		function(arg0_26)
			return var0_23 * arg0_26:GetTime()
		end,
		function(arg0_27)
			return var0_23 * arg0_27.id
		end
	}))
end

function var0_0.OnHide(arg0_28)
	arg0_28:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_29)
	ClearLScrollrect(arg0_29.scrollRect)

	for iter0_29, iter1_29 in pairs(arg0_29.cards) do
		iter1_29:Dispose()
	end

	arg0_29.cards = {}
end

return var0_0
