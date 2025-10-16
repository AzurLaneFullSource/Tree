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

	arg0_5.ids = Clone(pg.island_collection_reward.all)

	table.sort(arg0_5.ids, CompareFuncs({
		function(arg0_7)
			return pg.island_collection_reward[arg0_7].level
		end,
		function(arg0_8)
			return arg0_8
		end
	}))
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	return
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.ids[arg1_10 + 1]
	local var1_10 = arg2_10.transform
	local var2_10 = pg.island_collection_reward[var0_10]
	local var3_10 = Drop.Create(var2_10.award_display)

	updateCustomDrop(var1_10:Find("drop"), var3_10, {
		style = "island"
	})
	onButton(arg0_10, var1_10, function()
		arg0_10.contextData:ShowMsgBox({
			title = i18n("island_word_desc"),
			type = IslandMsgBox.TYPE_COMMON_DROP_DESCRIBE,
			dropData = var3_10
		})
	end)
	setText(var1_10:Find("level"), string.format("%02d", var2_10.level))
	setText(var1_10:Find("desc"), var2_10.describe)

	local var4_10 = table.contains(arg0_10.gotIds, var0_10)

	setActive(var1_10:Find("drop/got"), var4_10)
	setGray(var1_10, not var4_10, true)
end

function var0_0.Show(arg0_12)
	var0_0.super.Show(arg0_12)

	arg0_12.gotIds = getProxy(IslandProxy):GetIsland():GetBookAgency():GetPointAwardGotIds()

	arg0_12.scrollRect:SetTotalCount(#arg0_12.ids, -1)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
end

function var0_0.OnDestroy(arg0_14)
	ClearLScrollrect(arg0_14.scrollRect)
end

return var0_0
