local var0_0 = class("Island3dTaskAcceptPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskAcceptUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.chapterText = arg0_2._tf:Find("frame/chapter")
	arg0_2.nameText = arg0_2._tf:Find("frame/name")
	arg0_2.tipText = arg0_2._tf:Find("frame/tip/Text")

	setText(arg0_2.tipText, i18n("island_task_open"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:TouchEvent()
	end, SFX_PANEL)
end

function var0_0.TouchEvent(arg0_5)
	local var0_5 = arg0_5._tf:GetComponent(typeof(Animation))
	local var1_5 = arg0_5._tf:GetComponent(typeof(DftAniEvent))

	var1_5:SetEndEvent(function()
		var1_5:SetEndEvent(nil)

		if arg0_5.onExit then
			arg0_5.onExit()

			arg0_5.onExit = nil
		end

		if arg0_5.taskId == IslandGuideChecker.FIRST_TASK_ID then
			IslandGuideChecker.CheckGuide("ISLAND_GUIDE_4")
		end

		arg0_5:Hide()
	end)
	var0_5:Play("Anim_Island3dTaskAcceptUI_out")
end

function var0_0.Show(arg0_7, arg1_7, arg2_7)
	var0_0.super.Show(arg0_7)

	arg0_7.taskId = arg1_7

	local var0_7 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg0_7.taskId)

	setText(arg0_7.chapterText, var0_7:getConfig("series"))
	setText(arg0_7.nameText, var0_7:getConfig("series_name"))

	arg0_7.onExit = arg2_7
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
