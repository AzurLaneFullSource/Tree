local var0_0 = class("IslandBookAwardListBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandBookAwardListBox"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.titleTxt = arg0_2._tf:Find("title"):GetComponent(typeof(Text))
	arg0_2.titleTxt.text = i18n("island_book_award_title")
	arg0_2.closeBtn = arg0_2._tf:Find("close")

	setActive(arg0_2._tf:Find("tpl"), false)

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
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	return
end

function var0_0.OnUpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.ids[arg1_8 + 1]
	local var1_8 = arg2_8.transform
	local var2_8 = pg.island_collection_reward[var0_8]
	local var3_8 = Drop.Create(var2_8.award_display)

	updateCustomDrop(var1_8:Find("drop"), var3_8, {
		style = "island"
	})
	onButton(arg0_8, var1_8, function()
		arg0_8.contextData:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var3_8
		})
	end)
	setText(var1_8:Find("level"), string.format("%02d", var2_8.level))
	setText(var1_8:Find("desc"), var2_8.describe)

	local var4_8 = table.contains(arg0_8.gotIds, var0_8)

	setActive(var1_8:Find("drop/got"), var4_8)
	setGray(var1_8, not var4_8, true)
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)

	local var0_10 = getProxy(IslandProxy):GetIsland():GetBookAgency()

	arg0_10.ids = var0_10:GetPointAwardIds(arg0_10.contextData.type)
	arg0_10.gotIds = var0_10:GetPointAwardGotIds(arg0_10.contextData.type)

	arg0_10.scrollRect:SetTotalCount(#arg0_10.ids, -1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf, arg0_11._parentTf)
end

function var0_0.OnDestroy(arg0_12)
	arg0_12:Hide()
	ClearLScrollrect(arg0_12.scrollRect)
end

return var0_0
