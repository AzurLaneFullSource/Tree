local var0 = class("EducateCharDockScene", import("view.base.BaseUI"))

var0.ON_CLOSE_VIEW = "EducateCharDockScene.ON_CLOSE_VIEW"
var0.ON_SELECT = "EducateCharDockScene.ON_SELECT"
var0.ON_CONFIRM = "EducateCharDockScene.ON_CONFIRM"
var0.MSG_CLEAR_TIP = "EducateCharDockScene.MSG_CLEAR_TIP"

function var0.getUIName(arg0)
	return "EducateCharDockUI"
end

function var0.init(arg0)
	arg0.backBtn = arg0:findTF("adapt/top/back")
	arg0.homeBtn = arg0:findTF("adapt/top/home")
	arg0.selectPage = EducateCharSelectPage.New(arg0._tf:Find("adapt/pages"), arg0.event)
	arg0.groupPage = EducateCharGroupPage.New(arg0._tf:Find("adapt/pages/groupPage"), arg0.event, arg0.contextData)
end

function var0.didEnter(arg0)
	arg0.groupPage:Update()
	onButton(arg0, arg0.backBtn, function()
		if arg0.selectPage and arg0.selectPage:GetLoaded() and arg0.selectPage:isShowing() then
			arg0.selectPage:Back(function()
				arg0.groupPage:Show()
				arg0.selectPage:Hide()
			end)

			return
		end

		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.homeBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	arg0:bind(var0.ON_CLOSE_VIEW, function()
		arg0:closeView()
	end)
	arg0:bind(var0.ON_SELECT, function(arg0, arg1, arg2)
		arg0.groupPage:Hide()
		arg0.selectPage:ExecuteAction("Update", arg1, arg2)
	end)
	arg0:bind(var0.ON_CONFIRM, function(arg0, arg1)
		arg0.groupPage:Show()
		arg0.selectPage:Hide()
		arg0.groupPage:FlushList(arg1)
		arg0:emit(EducateCharDockMediator.ON_SELECTED, arg1)
	end)
end

function var0.onBackPressed(arg0)
	if arg0.selectPage and arg0.selectPage:GetLoaded() and arg0.selectPage:isShowing() then
		triggerButton(arg0.backBtn)

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	if arg0.selectPage then
		arg0.selectPage:Destroy()

		arg0.selectPage = nil
	end

	if arg0.groupPage then
		arg0.groupPage:Destroy()

		arg0.groupPage = nil
	end
end

return var0
