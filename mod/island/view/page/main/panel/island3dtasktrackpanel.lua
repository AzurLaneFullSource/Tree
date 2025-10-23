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
	local var1_7 = var0_7:IsFinish()

	setActive(arg2_7:Find("status/unfinish"), not var1_7)
	setActive(arg2_7:Find("status/finished"), var1_7)

	if var1_7 then
		arg2_7:GetComponent(typeof(Animation)):Play("Island3dTaskTrackPanel_tpl_finish_in")
	else
		arg2_7:GetComponent(typeof(Animation)):Play("Island3dTaskTrackPanel_tpl_unfinished_in")
	end

	GetOrAddComponent(arg2_7:Find("content"), "CanvasGroup").alpha = var1_7 and 0.5 or 1

	local var2_7 = arg0_7:GetMapTip(tonumber(var0_7:GetTrackParma()))

	if var2_7 and not var1_7 then
		setText(arg2_7:Find("content/Text"), var2_7)
		setText(arg2_7:Find("content/num"), "")
	else
		setText(arg2_7:Find("content/Text"), HXSet.hxLan(var0_7:getConfig("name")))

		local var3_7 = var0_7:GetProgress()
		local var4_7 = var0_7:GetTargetNum()

		setText(arg2_7:Find("content/num"), string.format("(%d/%d)", var3_7, var4_7))
	end
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

	if not arg0_10.task then
		return
	end

	local var0_10 = arg0_10.task:GetShowType()

	GetImageSpriteFromAtlasAsync("island/islandtasktype", IslandTaskType.ShowTypeFields[var0_10], arg0_10.iconTF)
	setImageColor(arg0_10.contentTF:Find("title/bg"), Color.NewHex(IslandTaskType.ShowTypeColors[var0_10]))
	setText(arg0_10.nameTF, HXSet.hxLan(arg0_10.task:GetName()))
	arg0_10:UpdateTarget()
	arg0_10:TrackUI()

	if arg0_10.unlock then
		arg0_10:PlayShowAnim()
	end
end

function var0_0.UpdateTarget(arg0_11)
	local var0_11 = not arg0_11.task:IsSubmitImmediately() and arg0_11.task:IsFinish()

	arg0_11.targetUIList:align(#arg0_11.task:GetTargetList())
	setActive(arg0_11.finishedTF, var0_11)

	if var0_11 then
		local var1_11 = arg0_11:GetMapTip(tonumber(arg0_11.task:GetTraceParam()))

		if var1_11 then
			setText(arg0_11.finishedTF:Find("Text"), var1_11)
		else
			setText(arg0_11.finishedTF:Find("Text"), HXSet.hxLan(arg0_11.task:GetFinishedDesc()))
		end
	end
end

function var0_0.UpdateProgress(arg0_12)
	arg0_12.task = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

	if not arg0_12.task then
		return
	end

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
		if _IslandCore then
			_IslandCore:GetController():NotifiyCore(ISLAND_EVT.TRACKING, {
				id = var1_13,
				typ = arg0_13.task:GetType()
			})
		end
	else
		arg0_13:UnTrackUI()
	end
end

function var0_0.GetMapTip(arg0_14, arg1_14)
	if not arg1_14 then
		return nil
	end

	local var0_14 = pg.island_world_objects[arg1_14]

	if not var0_14 then
		return nil
	end

	if getProxy(IslandProxy):GetIsland():GetMapId() == var0_14.mapId then
		return nil
	end

	return i18n("island_word_go") .. pg.island_map[var0_14.mapId].name
end

function var0_0.UnTrackUI(arg0_15)
	if not arg0_15.unlock then
		return
	end

	if _IslandCore then
		_IslandCore:GetController():NotifiyCore(ISLAND_EVT.UNTRACKING)
	end
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

function var0_0.Hide(arg0_18)
	var0_0.super.Hide(arg0_18)
	arg0_18:UnTrackUI()
end

function var0_0.OnDestroy(arg0_19)
	arg0_19.uiAnimEvent:SetEndEvent(nil)
end

return var0_0
