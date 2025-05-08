local var0_0 = class("Island3dTaskTrackPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "Island3dTaskTrackPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.emptyTF = arg0_2._tf:Find("empty")
	arg0_2.contentTF = arg0_2._tf:Find("content")
	arg0_2.iconTF = arg0_2.contentTF:Find("title/icon")
	arg0_2.nameTF = arg0_2.contentTF:Find("title/name")
	arg0_2.finishedTF = arg0_2.contentTF:Find("target/finished")
	arg0_2.unFinishTF = arg0_2.contentTF:Find("target/unfinish")
	arg0_2.targetUIList = UIItemList.New(arg0_2.unFinishTF, arg0_2.unFinishTF:Find("tpl"))
end

function var0_0.OnInit(arg0_3)
	arg0_3.targetUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_3:UpdateTargetItem(arg1_4, arg2_4)
		end
	end)
	onButton(arg0_3, arg0_3.emptyTF, function()
		existCall(arg0_3.contextData.onClick)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.contentTF, function()
		existCall(arg0_3.contextData.onClick)
	end, SFX_PANEL)
end

function var0_0.UpdateTargetItem(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.trackTask:GetTargetList()[arg1_7 + 1]

	setText(arg2_7:Find("content/Text"), var0_7:getConfig("name"))

	local var1_7 = var0_7:GetProgress()
	local var2_7 = var0_7:GetTargetNum()

	setText(arg2_7:Find("content/num"), string.format("(%d/%d)", var1_7, var2_7))

	local var3_7 = var0_7:IsFinish()

	setActive(arg2_7:Find("status/unfinish"), not var3_7)
	setActive(arg2_7:Find("status/finished"), var3_7)

	GetOrAddComponent(arg2_7:Find("content"), "CanvasGroup").alpha = var3_7 and 0.5 or 1
end

function var0_0.UpdateTrackTask(arg0_8, arg1_8)
	setActive(arg0_8.emptyTF, arg1_8 == 0)
	setActive(arg0_8.contentTF, arg1_8 ~= 0)

	if arg1_8 ~= 0 then
		arg0_8.trackTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

		local var0_8 = arg0_8.trackTask:GetShowType()

		LoadImageSpriteAsync("islandtasktype/" .. IslandTaskType.ShowTypeFields[var0_8], arg0_8.iconTF)
		setText(arg0_8.nameTF, arg0_8.trackTask:GetName())
		arg0_8:UpdateTarget()

		local var1_8 = arg0_8.trackTask:GetTraceParam()
		local var2_8 = tonumber(var1_8)

		if var2_8 then
			_IslandCore:GetController():NotifiyCore(ISLAND_EVT.TRACKING, {
				id = var2_8
			})
		end
	else
		_IslandCore:GetController():NotifiyCore(ISLAND_EVT.UNTRACKING)
	end
end

function var0_0.UpdateTarget(arg0_9)
	local var0_9 = not arg0_9.trackTask:IsSubmitImmediately() and arg0_9.trackTask:IsFinish()

	setActive(arg0_9.finishedTF, var0_9)
	setActive(arg0_9.unFinishTF, not var0_9)

	if var0_9 then
		setText(arg0_9.finishedTF, arg0_9.trackTask:GetFinishedDesc())
	else
		arg0_9.targetUIList:align(#arg0_9.trackTask:GetTargetList())
	end
end

function var0_0.UpdateTask(arg0_10, arg1_10)
	if arg0_10.trackTask and arg0_10.trackTask.id == arg1_10.id then
		arg0_10.trackTask = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTask(arg1_10.id)

		setActive(arg0_10.emptyTF, not arg0_10.trackTask)
		setActive(arg0_10.contentTF, arg0_10.trackTask)

		if arg0_10.trackTask then
			arg0_10:UpdateTarget()
		end
	end
end

function var0_0.Show(arg0_11)
	var0_0.super.Show(arg0_11)

	local var0_11 = getProxy(IslandProxy):GetIsland():GetTaskAgency():GetTraceTask()

	arg0_11:UpdateTrackTask(var0_11 and var0_11.id or 0)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
