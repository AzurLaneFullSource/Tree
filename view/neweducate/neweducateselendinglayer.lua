local var0_0 = class("NewEducateSelEndingLayer", import("view.newEducate.base.NewEducateBaseUI"))

function var0_0.getUIName(arg0_1)
	return "NewEducateSelEndingUI"
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
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_4.blurPanel, {
		pbList = {
			arg0_4.blurPanel
		},
		groupName = LayerWeightConst.GROUP_EDUCATE,
		weight = arg0_4:getWeightFromData() + 1
	})
	onButton(arg0_4, arg0_4.sureBtn, function()
		arg0_4:emit(NewEducateSelEndingMediator.ON_SELECT_ENDING, arg0_4.endingList[arg0_4.selectedIdx])
	end, SFX_PANEL)

	arg0_4.selectedIdx = 1

	arg0_4:RefreshView()
end

function var0_0.InitItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6 + 1
	local var1_6 = arg0_6.endingList[var0_6]
	local var2_6 = pg.child2_ending[var1_6]

	setText(arg2_6:Find("name"), var2_6.name)
	LoadImageSpriteAsync("neweducateicon/" .. var2_6.pic_preview, arg2_6:Find("Image"))
	setActive(arg2_6:Find("complete"), table.contains(arg0_6.completeList, var1_6))
	onButton(arg0_6, arg2_6, function()
		arg0_6.selectedIdx = var0_6

		arg0_6.uiList:align(#arg0_6.endingList)
	end, SFX_PANEL)
end

function var0_0.RefreshView(arg0_8)
	arg0_8.endingList = arg0_8.contextData.char:GetFSM():GetState(NewEducateFSM.STYSTEM.ENDING):GetEndings()
	arg0_8.completeList = arg0_8.contextData.char:GetPermanentData():GetFinishedEndings()

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

function var0_0.OnSelDone(arg0_11, arg1_11)
	local var0_11 = pg.child2_ending[arg1_11].performance

	NewEducateHelper.PlaySpecialStory(var0_11, function()
		arg0_11:closeView()
	end, true)
end

function var0_0.onBackPressed(arg0_13)
	return
end

function var0_0.willExit(arg0_14)
	existCall(arg0_14.contextData.onExit)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_14.blurPanel, arg0_14._tf)
end

return var0_0
