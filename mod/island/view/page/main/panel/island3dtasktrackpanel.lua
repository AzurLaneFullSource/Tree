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

	arg0_2.contentTF = arg0_2._tf:Find("content")
	arg0_2.iconTF = arg0_2.contentTF:Find("title/icon")
	arg0_2.nameTF = arg0_2.contentTF:Find("title/name")
	arg0_2.finishedTF = arg0_2.contentTF:Find("target/finished")
	arg0_2.unFinishTF = arg0_2.contentTF:Find("target/unfinish")
	arg0_2.targetUIList = UIItemList.New(arg0_2.unFinishTF, arg0_2.unFinishTF:Find("tpl"))
end

function var0_0.OnInit(arg0_4)
	arg0_4.targetUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateTargetItem(arg1_5, arg2_5)
		end
	end)
	onButton(arg0_4, arg0_4.contentTF, function()
		if not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(IslandGuideChecker.MOVE_TASK_ID) then
			return
		end

		arg0_4:emit(IslandMediator.OPEN_PAGE, "Island3dTaskPage", {
			0,
			arg0_4.task.id
		})
	end, SFX_PANEL)

	local var0_4 = pg.island_set.main_page_function_unlock.key_value_varchar[2]

	arg0_4.unlock = getProxy(IslandProxy):GetIsland():GetAblityAgency():HasAbility(var0_4)
end

function var0_0.UpdateTargetItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.task:GetTargetList()[arg1_7 + 1]

	setText(arg2_7:Find("content/Text"), HXSet.hxLan(var0_7:getConfig("name")))

	local var1_7 = var0_7:GetProgress()
	local var2_7 = var0_7:GetTargetNum()

	setText(arg2_7:Find("content/num"), string.format("(%d/%d)", var1_7, var2_7))

	local var3_7 = var0_7:IsFinish()

	setActive(arg2_7:Find("status/unfinish"), not var3_7)
	setActive(arg2_7:Find("status/finished"), var3_7)

	if var3_7 then
		arg2_7:GetComponent(typeof(Animation)):Play("Island3dTaskTrackPanel_tpl_finish_in")
	end

	GetOrAddComponent(arg2_7:Find("content"), "CanvasGroup").alpha = var3_7 and 0.5 or 1
end

function var0_0.Show(arg0_8)
	setActive(arg0_8._tf, arg0_8.unlock)
	arg0_8:ShowOrHideResUI(true)
	arg0_8:PlayBGM()
	arg0_8:UpdateTask()
end

function var0_0.PlayShowAnim(arg0_9)
	arg0_9.uiAnim:Play("Island3dTaskTrackPanel_in")
end

function var0_0.UpdateTask(arg0_10)
	arg0_10.task = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

	local var0_10 = arg0_10.task:GetShowType()

	GetImageSpriteFromAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_10], arg0_10.iconTF)
	setText(arg0_10.nameTF, HXSet.hxLan(arg0_10.task:GetName()))
	arg0_10:UpdateTarget()
	arg0_10:TrackUI()

	if arg0_10.unlock then
		arg0_10:PlayShowAnim()
	end
end

function var0_0.UpdateTarget(arg0_11)
	local var0_11 = not arg0_11.task:IsSubmitImmediately() and arg0_11.task:IsFinish()

	setActive(arg0_11.finishedTF, var0_11)
	setActive(arg0_11.unFinishTF, not var0_11)

	if var0_11 then
		setText(arg0_11.finishedTF:Find("Text"), HXSet.hxLan(arg0_11.task:GetFinishedDesc()))
	else
		arg0_11.targetUIList:align(#arg0_11.task:GetTargetList())
	end
end

function var0_0.UpdateProgress(arg0_12)
	arg0_12.task = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

	arg0_12:UpdateTarget()
	arg0_12:TrackUI()
end

function var0_0.TrackUI(arg0_13)
	if not arg0_13.unlock then
		return
	end

	local var0_13 = arg0_13.task:GetTraceParam()
	local var1_13 = tonumber(var0_13)

	if var1_13 then
		local var2_13 = pg.island_world_objects[var1_13].mapId

		if getProxy(IslandProxy):GetIsland():GetMapId() == var2_13 then
			_IslandCore:GetController():NotifiyCore(ISLAND_EVT.TRACKING, {
				id = var1_13
			})
		else
			arg0_13.targetUIList:eachActive(function(arg0_14, arg1_14)
				if not arg0_13.task:GetTargetList()[arg0_14 + 1]:IsFinish() then
					setText(arg1_14:Find("content/Text"), i18n("island_word_go") .. pg.island_map[var2_13].name)
					setText(arg1_14:Find("content/num"), "")
				end
			end)
			arg0_13:UnTrackUI()
		end
	end
end

function var0_0.UnTrackUI(arg0_15)
	if not arg0_15.unlock then
		return
	end

	_IslandCore:GetController():NotifiyCore(ISLAND_EVT.UNTRACKING)
end

function var0_0.RemoveTask(arg0_16)
	arg0_16:emit(IslandMediator.ON_SET_TRACE_ID, 0)
	arg0_16:UnTrackUI()
	arg0_16.uiAnim:Play("Island3dTaskTrackPanel_out")
end

function var0_0.SetUnlock(arg0_17)
	arg0_17.unlock = true

	if arg0_17.task then
		arg0_17:UpdateTask()
	end
end

function var0_0.OnDestroy(arg0_18)
	arg0_18.uiAnimEvent:SetEndEvent(nil)
end

return var0_0
