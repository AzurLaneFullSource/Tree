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
	onButton(arg0_5, arg0_5._tf:Find("frame/close"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("mask"), function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.ascToggleTF, function(arg0_9)
		arg0_5.isAsc = arg0_9

		arg0_5:SetTotalCount()
	end, SFX_PANEL)
	onToggle(arg0_5, arg0_5.sortToggleTF, function(arg0_10)
		local var0_10 = arg0_10 and "anim_IslandTicketStorageUI_sort_in" or "anim_IslandTicketStorageUI_sort_out"

		arg0_5.sortPanelAnim:Play(var0_10)
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

function var0_0.OnInitItem(arg0_13, arg1_13)
	local var0_13 = IslandTicketCard.New(arg1_13)

	arg0_13.cards[arg1_13] = var0_13
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.cards[arg2_14]

	if not var0_14 then
		arg0_14:OnInitItem(arg2_14)

		var0_14 = arg0_14.cards[arg2_14]
	end

	local var1_14 = arg0_14.displays[arg1_14 + 1]

	var0_14:Update(var1_14)
end

function var0_0.OnShow(arg0_15)
	arg0_15:BlurPanel()

	arg0_15.ticketAgency = getProxy(IslandProxy):GetIsland():GetTicketAgency()
	arg0_15.displays = arg0_15.ticketAgency:GetAllTicketList()
	arg0_15.isAsc = true
	arg0_15.sortType = var0_0.SORT_TYPES.SPEED_UP

	triggerButton(arg0_15.sortBySpeedupBtn)
end

function var0_0.SetTotalCount(arg0_16)
	if arg0_16.sortType == var0_0.SORT_TYPES.VALID then
		arg0_16:SortByValid()
	elseif arg0_16.sortType == var0_0.SORT_TYPES.SPEED_UP then
		arg0_16:SortBySpeedup()
	end

	arg0_16.scrollRect:SetTotalCount(#arg0_16.displays, -1)
end

function var0_0.SortBySpeedup(arg0_17)
	local var0_17 = arg0_17.isAsc and 1 or -1

	table.sort(arg0_17.displays, CompareFuncs({
		function(arg0_18)
			return var0_17 * arg0_18:GetTime()
		end,
		function(arg0_19)
			return var0_17 * (arg0_19:IsForever() and 1 or 0)
		end,
		function(arg0_20)
			return var0_17 * arg0_20:GetEndTime()
		end,
		function(arg0_21)
			return var0_17 * arg0_21.id
		end
	}))
end

function var0_0.SortByValid(arg0_22)
	local var0_22 = arg0_22.isAsc and 1 or -1

	table.sort(arg0_22.displays, CompareFuncs({
		function(arg0_23)
			return var0_22 * (arg0_23:IsForever() and 1 or 0)
		end,
		function(arg0_24)
			return var0_22 * arg0_24:GetEndTime()
		end,
		function(arg0_25)
			return var0_22 * arg0_25:GetTime()
		end,
		function(arg0_26)
			return var0_22 * arg0_26.id
		end
	}))
end

function var0_0.OnHide(arg0_27)
	arg0_27:UnBlurPanel()
end

function var0_0.OnDestroy(arg0_28)
	ClearLScrollrect(arg0_28.scrollRect)

	for iter0_28, iter1_28 in pairs(arg0_28.cards) do
		iter1_28:Dispose()
	end

	arg0_28.cards = {}
end

return var0_0
