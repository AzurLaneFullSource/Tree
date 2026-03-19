local var0_0 = class("EducateSelEndingLayer", import(".base.EducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "EducateSelEndingUI"
end

function var0_0.init(arg0_2)
	arg0_2.rootTF = arg0_2._tf:Find("root")
	arg0_2.blurPanel = arg0_2.rootTF:Find("bg")
	arg0_2.scrollrect = arg0_2.blurPanel:Find("window/view")

	local var0_2 = arg0_2.blurPanel:Find("window/view/content")

	arg0_2.uiList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	arg0_2.uiList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventInit then
			arg0_2:InitItem(arg1_3, arg2_3)
		elseif arg0_3 == UIItemList.EventUpdate then
			setActive(arg2_3:Find("selected"), arg0_2.selectedIdx == arg1_3 + 1)
		end
	end)

	arg0_2.sureBtn = arg0_2.blurPanel:Find("window/sure_btn")

	setText(arg0_2.sureBtn:Find("Image"), i18n("word_ok"))
end

function var0_0.didEnter(arg0_4)
	arg0_4:OverlayPanel(arg0_4.blurPanel, {
		groupDelta = 1,
		pbList = {
			arg0_4.blurPanel
		}
	})
	onButton(arg0_4, arg0_4.sureBtn, function()
		arg0_4:emit(EducateSelEndingMediator.ON_SELECT_ENDING, arg0_4.endingList[arg0_4.selectedIdx], arg0_4.endingList)
	end, SFX_PANEL)

	arg0_4.selectedIdx = 1

	arg0_4:RefreshView()
end

function var0_0.InitItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6 + 1
	local var1_6 = arg0_6.endingList[var0_6]
	local var2_6 = pg.child_ending[var1_6]

	setScrollText(arg2_6:Find("name_mask/name"), var2_6.name)
	LoadImageSpriteAsync("educatepicture/" .. var2_6.pic_preview, arg2_6:Find("Image"))
	setActive(arg2_6:Find("complete"), table.contains(arg0_6.completeList, var1_6))
	onButton(arg0_6, arg2_6, function()
		arg0_6.selectedIdx = var0_6

		arg0_6.uiList:align(#arg0_6.endingList)
	end, SFX_PANEL)
end

function var0_0.RefreshView(arg0_8)
	arg0_8.endingList = getProxy(EducateProxy):GetEndingResult()
	arg0_8.completeList = getProxy(EducateProxy):GetCompleteEndings()

	table.sort(arg0_8.endingList, CompareFuncs({
		function(arg0_9)
			return table.contains(arg0_8.completeList, arg0_9) and 1 or 0
		end,
		function(arg0_10)
			return -arg0_10
		end
	}))
	arg0_8.uiList:align(#arg0_8.endingList)
	scrollTo(arg0_8.scrollrect, arg0_8.uiList.container.rect.width / 2, 0)
end

function var0_0.onBackPressed(arg0_11)
	return
end

function var0_0.willExit(arg0_12)
	existCall(arg0_12.contextData.onExit)
	arg0_12:UnOverlayPanel(arg0_12.blurPanel, arg0_12._tf)
end

return var0_0
