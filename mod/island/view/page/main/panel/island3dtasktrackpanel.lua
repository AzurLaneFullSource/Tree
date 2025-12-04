local var0_0 = class("Island3dTaskTrackPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskTrackPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiAnim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.uiAnimEvent = arg0_2._tf:GetComponent(typeof(DftAniEvent))

	arg0_2.uiAnimEvent:SetEndEvent(function()
		arg0_2:Hide()
	end)

	arg0_2.mainTrackCard = IslandTaskTrackCard.New(arg0_2._tf:Find("content"), arg0_2.event, IslandTaskTrackCard.TYPES.MAIN)
	arg0_2.otherTrackCard = IslandTaskTrackCard.New(arg0_2._tf:Find("other_content"), arg0_2.event, IslandTaskTrackCard.TYPES.OTHER)
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.mainTrackCard._tf, function()
		if not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(IslandGuideChecker.MOVE_TASK_ID) then
			return
		end

		arg0_4:emit(IslandMediator.OPEN_PAGE, "Island3dTaskPage", {
			0,
			arg0_4.mainTask.id
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.otherTrackCard._tf, function()
		if not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(IslandGuideChecker.MOVE_TASK_ID) then
			return
		end

		arg0_4:emit(IslandMediator.OPEN_PAGE, "Island3dTaskPage", {
			0,
			arg0_4.otherTask.id
		})
	end, SFX_PANEL)

	local var0_4 = pg.island_set.main_page_function_unlock.key_value_varchar[2]

	arg0_4.unlock = getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_4)
end

function var0_0.Show(arg0_7)
	setActive(arg0_7._tf, arg0_7.unlock)
	arg0_7:ShowOrHideResUI(true)
	arg0_7:PlayBGM()
	arg0_7:UpdataAllTask()
end

function var0_0.UpdataAllTask(arg0_8)
	arg0_8.mainTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetMainTraceTask()

	if not arg0_8.mainTask then
		arg0_8.mainTrackCard:UnTrackUI()
	end

	arg0_8.otherTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

	if not arg0_8.otherTask then
		arg0_8.otherTrackCard:UnTrackUI()
	end

	if not arg0_8.mainTask and not arg0_8.otherTask then
		return
	end

	if arg0_8.unlock then
		arg0_8.uiAnim:Play("Island3dTaskTrackPanel_in")
	end

	arg0_8:UpdateTask(IslandTaskTrackCard.TYPES.MAIN)
	arg0_8:UpdateTask(IslandTaskTrackCard.TYPES.OTHER)
end

function var0_0.UpdateTask(arg0_9, arg1_9)
	if arg1_9 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_9.mainTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetMainTraceTask()

		arg0_9.mainTrackCard:Update(arg0_9.mainTask, arg0_9.unlock)
	elseif arg1_9 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_9.otherTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

		arg0_9.otherTrackCard:Update(arg0_9.otherTask, arg0_9.unlock)
	end
end

function var0_0.UpdateProgress(arg0_10, arg1_10)
	if arg1_10 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_10.mainTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetMainTraceTask()

		if arg0_10.mainTask then
			arg0_10.mainTrackCard:UpdateProgress(arg0_10.mainTask)
		end
	elseif arg1_10 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_10.otherTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

		if arg0_10.otherTask then
			arg0_10.otherTrackCard:UpdateProgress(arg0_10.otherTask)
		end
	end
end

function var0_0.RemoveTask(arg0_11, arg1_11)
	if arg1_11 == IslandTaskTrackCard.TYPES.MAIN then
		arg0_11.mainTrackCard:RemoveTask()
	elseif arg1_11 == IslandTaskTrackCard.TYPES.OTHER then
		arg0_11.otherTrackCard:RemoveTask()
	end

	arg0_11:emit(IslandMediator.ON_SET_TRACE_ID, 0, arg1_11)

	arg0_11.mainTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetMainTraceTask()
	arg0_11.otherTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

	if not arg0_11.mainTask and not arg0_11.otherTask then
		arg0_11:Hide()
	end
end

function var0_0.SetUnlock(arg0_12)
	arg0_12.unlock = true

	if arg0_12.mainTask then
		arg0_12.mainTrackCard:Update(arg0_12.mainTask, arg0_12.unlock)
	end

	if arg0_12.otherTask then
		arg0_12.otherTrackCard:Update(arg0_12.otherTask, arg0_12.unlock)
	end
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
	arg0_13.mainTrackCard:UnTrackUI()
	arg0_13.otherTrackCard:UnTrackUI()
end

function var0_0.OnDestroy(arg0_14)
	arg0_14.uiAnimEvent:SetEndEvent(nil)
	arg0_14.mainTrackCard:Dispose()

	arg0_14.mainTrackCard = nil

	arg0_14.otherTrackCard:Dispose()

	arg0_14.otherTrackCard = nil
end

return var0_0
