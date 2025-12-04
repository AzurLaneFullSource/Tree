local var0_0 = class("HelenaCoreActivityUI", import("view.activity.CorePage.PSS.PSSCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "HelenaCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.topPage = arg0_2._tf:Find("adapt/TopPage")
	arg0_2.camEventId = nil

	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))
end

function var0_0.UpdateAdapt(arg0_3)
	return
end

function var0_0.ActiveScenarioLayer(arg0_4, arg1_4)
	arg0_4.contextData.activeScenario = arg1_4
end

function var0_0.verifyTabs(arg0_5, arg1_5)
	local var0_5 = arg0_5.activities[arg0_5:getActivityIndex(arg1_5) or arg0_5:getActivityIndex(arg0_5:GetActiveActivity()) or 1]

	if var0_5 == nil then
		return
	end

	local var1_5 = var0_5:getConfig("is_show")
	local var2_5 = arg0_5.tabs:Find(tostring(var1_5))

	if #arg0_5.activities == 1 then
		setActive(arg0_5._tf:Find("adapt/tabs"), false)
	else
		setActive(arg0_5._tf:Find("adapt/tabs"), true)
	end

	triggerToggle(var2_5, true)
end

function var0_0.didEnter(arg0_6)
	var0_0.super.didEnter(arg0_6)
	onButton(arg0_6, arg0_6.btnBack, function()
		local var0_7 = arg0_6.pageDic[arg0_6.activity.id]

		if var0_7:IsShowingPopWindow() then
			var0_7:ClosePopWindow()
		else
			arg0_6:emit(var0_0.ON_BACK)
		end
	end, SOUND_BACK)
end

function var0_0.OnToggleName(arg0_8, arg1_8, arg2_8)
	return
end

function var0_0.OnAnimations(arg0_9, arg1_9, arg2_9)
	SetActive(arg0_9._tf:Find("adapt/decorate"), arg2_9 == 50261 or arg2_9 == 0)
end

function var0_0.willExit(arg0_10)
	var0_0.super.willExit(arg0_10)

	if arg0_10.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_10.camEventId)

		arg0_10.camEventId = nil
	end
end

return var0_0
