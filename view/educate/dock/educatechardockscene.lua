local var0_0 = class("EducateCharDockScene", import("view.base.BaseUI"))

var0_0.ON_CLOSE_VIEW = "EducateCharDockScene.ON_CLOSE_VIEW"
var0_0.ON_SELECT = "EducateCharDockScene.ON_SELECT"
var0_0.ON_CONFIRM = "EducateCharDockScene.ON_CONFIRM"
var0_0.ON_SELECTED = "EducateCharDockScene.ON_SELECTED"
var0_0.MSG_CLEAR_TIP = "EducateCharDockScene.MSG_CLEAR_TIP"

function var0_0.getUIName(arg0_1)
	return "EducateCharDockUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/educatechardockui",
		"ui/educatedockui_atlas",
		"ui/educatecharprofileui_atlas",
		"cue/story-richang-8.b"
	}

	local function var1_2()
		local var0_3 = {}

		for iter0_3, iter1_3 in ipairs(pg.secretary_special_ship.all) do
			local var1_3 = pg.secretary_special_ship[iter1_3].painting

			if var1_3 then
				table.insert(var0_3, "painting/" .. var1_3)
				table.insert(var0_3, "paintingface/" .. var1_3)
			end
		end

		return var0_3
	end

	return ResPathSupport.MergeLuaArr(var0_2, var1_2())
end

function var0_0.init(arg0_4)
	arg0_4.backBtn = arg0_4._tf:Find("adapt/top/back")
	arg0_4.homeBtn = arg0_4._tf:Find("adapt/top/home")
	arg0_4.selectPage = EducateCharSelectPage.New(arg0_4._tf:Find("adapt/pages"), arg0_4.event)
	arg0_4.groupPage = EducateCharGroupPage.New(arg0_4._tf:Find("adapt/pages/groupPage"), arg0_4.event, arg0_4.contextData)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		if arg0_5.contextData.tbSkinId then
			arg0_5:closeView()

			return
		end

		if arg0_5.selectPage and arg0_5.selectPage:GetLoaded() and arg0_5.selectPage:isShowing() then
			arg0_5.selectPage:Back(function()
				arg0_5.groupPage:Show()
				arg0_5.groupPage:InitList()
				arg0_5.selectPage:Hide()
			end)

			return
		end

		arg0_5:closeView()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.homeBtn, function()
		arg0_5:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	arg0_5:bind(var0_0.ON_CLOSE_VIEW, function()
		arg0_5:closeView()
	end)
	arg0_5:bind(var0_0.ON_SELECT, function(arg0_10, arg1_10, arg2_10)
		arg0_5.groupPage:Hide()
		arg0_5.selectPage:ExecuteAction("Update", arg1_10, arg2_10)
	end)
	arg0_5:bind(var0_0.ON_SELECTED, function(arg0_11, arg1_11)
		arg0_5:emit(EducateCharDockMediator.ON_SELECTED, arg1_11)
	end)
	arg0_5:bind(var0_0.ON_CONFIRM, function(arg0_12, arg1_12)
		if arg0_5.contextData.tbSkinId then
			arg0_5:closeView()

			return
		end

		arg0_5.groupPage:Show()
		arg0_5.selectPage:Hide()
		arg0_5.groupPage:FlushList(arg1_12)
	end)
	arg0_5.groupPage:Update()
end

function var0_0.onBackPressed(arg0_13)
	if arg0_13.selectPage and arg0_13.selectPage:GetLoaded() and arg0_13.selectPage:isShowing() then
		triggerButton(arg0_13.backBtn)

		return
	end

	var0_0.super.onBackPressed(arg0_13)
end

function var0_0.willExit(arg0_14)
	if arg0_14.selectPage then
		arg0_14.selectPage:Destroy()

		arg0_14.selectPage = nil
	end

	if arg0_14.groupPage then
		arg0_14.groupPage:Destroy()

		arg0_14.groupPage = nil
	end
end

return var0_0
