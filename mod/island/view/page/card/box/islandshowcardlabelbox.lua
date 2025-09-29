local var0_0 = class("IslandShowCardLabelBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandShowCardLabelBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("frame/title"), i18n("island_card_label_list"))

	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")
	arg0_2.emptyTF = arg0_2._tf:Find("empty")

	setText(arg0_2.emptyTF, i18n("island_card_no_label_tip"))

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

	arg0_5.cards = {}
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = IslandCardShowLabelCard.New(arg1_7)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.cards[arg2_8]

	if not var0_8 then
		arg0_8:OnInitItem(arg2_8)

		var0_8 = arg0_8.cards[arg2_8]
	end

	local var1_8 = arg0_8.labelList[arg1_8 + 1]

	if var1_8 then
		var0_8:Update(var1_8.id, var1_8.num)
	end
end

function var0_0.Show(arg0_9, arg1_9)
	var0_0.super.Show(arg0_9)

	arg0_9.labelList = arg1_9

	arg0_9.scrollRect:SetTotalCount(#arg0_9.labelList, -1)
	setActive(arg0_9.emptyTF, #arg0_9.labelList == 0)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10._tf, arg0_10._parentTf)
end

function var0_0.OnDestroy(arg0_11)
	ClearLScrollrect(arg0_11.scrollRect)

	for iter0_11, iter1_11 in pairs(arg0_11.cards) do
		iter1_11:Dispose()
	end

	arg0_11.cards = {}

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
end

return var0_0
