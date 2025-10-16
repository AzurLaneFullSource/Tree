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
		local var0_4 = arg0_3._tf:GetComponent(typeof(Animation))
		local var1_4 = arg0_3._tf:GetComponent(typeof(DftAniEvent))

		var1_4:SetEndEvent(function()
			var1_4:SetEndEvent(nil)

			if arg0_3.onExit then
				arg0_3.onExit()

				arg0_3.onExit = nil
			end

			if arg0_3.taskId == IslandGuideChecker.FIRST_TASK_ID then
				IslandGuideChecker.CheckGuide("ISLAND_GUIDE_4")
			end

			arg0_3:Hide()
		end)
		var0_4:Play("Anim_Island3dTaskAcceptUI_out")
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	var0_0.super.Show(arg0_6)

	arg0_6.taskId = arg1_6

	local var0_6 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg0_6.taskId)

	setText(arg0_6.chapterText, var0_6:getConfig("series"))
	setText(arg0_6.nameText, var0_6:getConfig("series_name"))

	arg0_6.onExit = arg2_6
end

function var0_0.OnDestroy(arg0_7)
	return
end

return var0_0
