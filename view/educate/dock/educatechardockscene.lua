local var0_0 = class("EducateCharDockScene", import("view.base.BaseUI"))

var0_0.ON_CLOSE_VIEW = "EducateCharDockScene.ON_CLOSE_VIEW"
var0_0.ON_SELECT = "EducateCharDockScene.ON_SELECT"
var0_0.ON_CONFIRM = "EducateCharDockScene.ON_CONFIRM"
var0_0.ON_SELECTED = "EducateCharDockScene.ON_SELECTED"
var0_0.MSG_CLEAR_TIP = "EducateCharDockScene.MSG_CLEAR_TIP"

function var0_0.getUIName(arg0_1)
	return "EducateCharDockUI"
end

function var0_0.init(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("adapt/top/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/top/home")
	arg0_2.selectPage = EducateCharSelectPage.New(arg0_2._tf:Find("adapt/pages"), arg0_2.event)
	arg0_2.groupPage = EducateCharGroupPage.New(arg0_2._tf:Find("adapt/pages/groupPage"), arg0_2.event, arg0_2.contextData)
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		if arg0_3.contextData.tbSkinId then
			arg0_3:closeView()

			return
		end

		if arg0_3.selectPage and arg0_3.selectPage:GetLoaded() and arg0_3.selectPage:isShowing() then
			arg0_3.selectPage:Back(function()
				arg0_3.groupPage:Show()
				arg0_3.groupPage:InitList()
				arg0_3.selectPage:Hide()
			end)

			return
		end

		arg0_3:closeView()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.homeBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_3:bind(var0_0.ON_CLOSE_VIEW, function()
		arg0_3:closeView()
	end)
	arg0_3:bind(var0_0.ON_SELECT, function(arg0_8, arg1_8, arg2_8)
		arg0_3.groupPage:Hide()
		arg0_3.selectPage:ExecuteAction("Update", arg1_8, arg2_8)
	end)
	arg0_3:bind(var0_0.ON_SELECTED, function(arg0_9, arg1_9)
		arg0_3:emit(EducateCharDockMediator.ON_SELECTED, arg1_9)
	end)
	arg0_3:bind(var0_0.ON_CONFIRM, function(arg0_10, arg1_10)
		if arg0_3.contextData.tbSkinId then
			arg0_3:closeView()

			return
		end

		arg0_3.groupPage:Show()
		arg0_3.selectPage:Hide()
		arg0_3.groupPage:FlushList(arg1_10)
	end)
	arg0_3.groupPage:Update()
end

function var0_0.onBackPressed(arg0_11)
	if arg0_11.selectPage and arg0_11.selectPage:GetLoaded() and arg0_11.selectPage:isShowing() then
		triggerButton(arg0_11.backBtn)

		return
	end

	var0_0.super.onBackPressed(arg0_11)
end

function var0_0.willExit(arg0_12)
	if arg0_12.selectPage then
		arg0_12.selectPage:Destroy()

		arg0_12.selectPage = nil
	end

	if arg0_12.groupPage then
		arg0_12.groupPage:Destroy()

		arg0_12.groupPage = nil
	end
end

return var0_0
