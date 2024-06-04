local var0 = class("EducateTargetPanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "EducateTargetPanel"
end

function var0.OnInit(arg0)
	arg0.contentTF = arg0:findTF("content")

	onButton(arg0, arg0.contentTF, function()
		arg0:emit(EducateBaseUI.EDUCATE_GO_SUBLAYER, Context.New({
			mediator = EducateTargetMediator,
			viewComponent = EducateTargetLayer
		}))
	end, SFX_PANEL)

	arg0.taskTpl = arg0:findTF("tpl", arg0.contentTF)

	setActive(arg0.taskTpl, false)

	arg0.listBg = arg0:findTF("task_list/bg", arg0.contentTF)
	arg0.lineTF = arg0:findTF("task_list/line", arg0.contentTF)
	arg0.mainTF = arg0:findTF("task_list/main", arg0.contentTF)

	setText(arg0:findTF("title/Image/Text", arg0.mainTF), i18n("child_task_system_type3"))

	arg0.mainTaskUIList = UIItemList.New(arg0:findTF("list", arg0.mainTF), arg0.taskTpl)

	arg0.mainTaskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateTaskItem(arg1, arg2, "main")
		end
	end)

	arg0.otherTF = arg0:findTF("task_list/other", arg0.contentTF)

	setText(arg0:findTF("title/Image/Text", arg0.otherTF), i18n("child_task_system_type2"))

	arg0.otherTaskUIList = UIItemList.New(arg0:findTF("list", arg0.otherTF), arg0.taskTpl)

	arg0.otherTaskUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateTaskItem(arg1, arg2, "other")
		end
	end)
	arg0:Flush()
end

function var0.updateTaskItem(arg0, arg1, arg2, arg3)
	local var0 = arg3 == "main" and arg0.mainTaskVOs[arg1 + 1] or arg0.otherTaskVOs[arg1 + 1]
	local var1 = string.format("(%s)", var0:GetProgress() .. "/" .. var0:GetFinishNum())

	setText(arg0:findTF("progress", arg2), var1)

	local var2 = GetPerceptualSize(var1)

	if PLATFORM_CODE == PLATFORM_JP then
		var2 = var2 + 2
	end

	setText(arg0:findTF("desc", arg2), shortenString(var0:getConfig("name"), 11 - var2))
end

function var0.Flush(arg0)
	if not arg0:GetLoaded() then
		return
	end

	arg0.taskProxy = getProxy(EducateProxy):GetTaskProxy()

	setActive(arg0:findTF("target_btn/tip", arg0.contentTF), arg0.taskProxy:IsShowOtherTasksTip())

	arg0.mainTaskVOs = arg0.taskProxy:FilterByGroup(arg0.taskProxy:GetMainTasksForShow())

	if not arg0.taskProxy:CanGetTargetAward() then
		arg0.otherTaskVOs = {}
	else
		arg0.otherTaskVOs = arg0.taskProxy:FilterByGroup(arg0.taskProxy:GetTargetTasksForShow(), true)
	end

	setActive(arg0.mainTF, #arg0.mainTaskVOs > 0)
	arg0.mainTaskUIList:align(#arg0.mainTaskVOs)

	local var0 = #arg0.mainTaskVOs
	local var1 = 3 - var0

	setActive(arg0.otherTF, #arg0.otherTaskVOs > 0)

	local var2 = var1 < #arg0.otherTaskVOs and var1 or #arg0.otherTaskVOs

	arg0.otherTaskUIList:align(var2)
	setActive(arg0.listBg, var0 > 0 or var2 > 0)
	setActive(arg0.lineTF, var0 > 0 and var2 > 0)
end

function var0.SetPosLeft(arg0)
	setLocalPosition(arg0.contentTF, Vector2(-650, 0))
end

function var0.SetPosRight(arg0)
	setLocalPosition(arg0.contentTF, Vector2(0, 0))
end

function var0.OnDestroy(arg0)
	return
end

return var0
