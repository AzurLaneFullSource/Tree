local var0_0 = class("EducateTargetPanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "EducateTargetPanel"
end

function var0_0.OnInit(arg0_2)
	arg0_2.contentTF = arg0_2:findTF("content")

	onButton(arg0_2, arg0_2.contentTF, function()
		arg0_2:emit(EducateBaseUI.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateTargetMediator,
			viewComponent = EducateTargetLayer
		}))
	end, SFX_PANEL)

	arg0_2.taskTpl = arg0_2:findTF("tpl", arg0_2.contentTF)

	setActive(arg0_2.taskTpl, false)

	arg0_2.listBg = arg0_2:findTF("task_list/bg", arg0_2.contentTF)
	arg0_2.lineTF = arg0_2:findTF("task_list/line", arg0_2.contentTF)
	arg0_2.mainTF = arg0_2:findTF("task_list/main", arg0_2.contentTF)

	setText(arg0_2:findTF("title/Image/Text", arg0_2.mainTF), i18n("child_task_system_type3"))

	arg0_2.mainTaskUIList = UIItemList.New(arg0_2:findTF("list", arg0_2.mainTF), arg0_2.taskTpl)

	arg0_2.mainTaskUIList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_2:updateTaskItem(arg1_4, arg2_4, "main")
		end
	end)

	arg0_2.otherTF = arg0_2:findTF("task_list/other", arg0_2.contentTF)

	setText(arg0_2:findTF("title/Image/Text", arg0_2.otherTF), i18n("child_task_system_type2"))

	arg0_2.otherTaskUIList = UIItemList.New(arg0_2:findTF("list", arg0_2.otherTF), arg0_2.taskTpl)

	arg0_2.otherTaskUIList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_2:updateTaskItem(arg1_5, arg2_5, "other")
		end
	end)
	arg0_2:Flush()
end

function var0_0.updateTaskItem(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg3_6 == "main" and arg0_6.mainTaskVOs[arg1_6 + 1] or arg0_6.otherTaskVOs[arg1_6 + 1]
	local var1_6 = string.format("(%s)", var0_6:GetProgress() .. "/" .. var0_6:GetFinishNum())

	setText(arg0_6:findTF("progress", arg2_6), var1_6)

	local var2_6 = GetPerceptualSize(var1_6)

	if PLATFORM_CODE == PLATFORM_JP then
		var2_6 = var2_6 + 2
	end

	setText(arg0_6:findTF("desc", arg2_6), shortenString(var0_6:getConfig("name"), 11 - var2_6))
end

function var0_0.Flush(arg0_7)
	if not arg0_7:GetLoaded() then
		return
	end

	arg0_7.taskProxy = getProxy(EducateProxy):GetTaskProxy()

	setActive(arg0_7:findTF("target_btn/tip", arg0_7.contentTF), arg0_7.taskProxy:IsShowOtherTasksTip())

	arg0_7.mainTaskVOs = arg0_7.taskProxy:FilterByGroup(arg0_7.taskProxy:GetMainTasksForShow())

	if not arg0_7.taskProxy:CanGetTargetAward() then
		arg0_7.otherTaskVOs = {}
	else
		arg0_7.otherTaskVOs = arg0_7.taskProxy:FilterByGroup(arg0_7.taskProxy:GetTargetTasksForShow(), true)
	end

	setActive(arg0_7.mainTF, #arg0_7.mainTaskVOs > 0)
	arg0_7.mainTaskUIList:align(#arg0_7.mainTaskVOs)

	local var0_7 = #arg0_7.mainTaskVOs
	local var1_7 = 3 - var0_7

	setActive(arg0_7.otherTF, #arg0_7.otherTaskVOs > 0)

	local var2_7 = var1_7 < #arg0_7.otherTaskVOs and var1_7 or #arg0_7.otherTaskVOs

	arg0_7.otherTaskUIList:align(var2_7)
	setActive(arg0_7.listBg, var0_7 > 0 or var2_7 > 0)
	setActive(arg0_7.lineTF, var0_7 > 0 and var2_7 > 0)
end

function var0_0.SetPosLeft(arg0_8)
	setLocalPosition(arg0_8.contentTF, Vector2(-650, 0))
end

function var0_0.SetPosRight(arg0_9)
	setLocalPosition(arg0_9.contentTF, Vector2(0, 0))
end

function var0_0.OnDestroy(arg0_10)
	return
end

return var0_0
