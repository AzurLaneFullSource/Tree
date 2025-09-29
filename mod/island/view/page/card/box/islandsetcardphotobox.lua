local var0_0 = class("IslandSetCardPhotoBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandSetCardPhotoBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("frame/title"), i18n("island_card_choose_photo"))

	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")
	arg0_2.cancelBtn = arg0_2._tf:Find("cancel")

	setText(arg0_2.cancelBtn:Find("Text"), i18n("word_cancel"))

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
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.cancelBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confirmBtn, function()
		arg0_5:emit(IslandSelfCardMediator.SET_CARD_PHOTO, arg0_5.selectedId)
	end, SFX_PANEL)

	arg0_5.cards = {}
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = IslandCardPhotoCard.New(arg1_9)

	arg0_9.cards[arg1_9] = var0_9
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg0_10.ids[arg1_10 + 1]

	if var1_10 then
		var0_10:Update(var1_10, arg0_10.selectedId)
	end

	onButton(arg0_10, var0_10._go, function()
		for iter0_11, iter1_11 in pairs(arg0_10.cards) do
			iter1_11:UpdateSelected(nil)
		end

		arg0_10.selectedId = var1_10

		var0_10:UpdateSelected(arg0_10.selectedId)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_12, arg1_12, arg2_12)
	var0_0.super.Show(arg0_12)

	arg0_12.ids = arg1_12

	table.sort(arg0_12.ids)

	arg0_12.selectedId = arg2_12

	arg0_12.scrollRect:SetTotalCount(#arg0_12.ids, -1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
end

function var0_0.OnDestroy(arg0_14)
	ClearLScrollrect(arg0_14.scrollRect)

	for iter0_14, iter1_14 in pairs(arg0_14.cards) do
		iter1_14:Dispose()
	end

	arg0_14.cards = {}

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14._tf, arg0_14._parentTf)
end

return var0_0
