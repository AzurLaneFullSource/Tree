local var0 = class("NewServerTaskPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewServerTaskPage"
end

var0.TYPE_ALL = 1
var0.TYPE_DAILY = 2
var0.TYPE_TARGET = 3
var0.TXT_DESC = 1
var0.TXT_CURRENT_NUM = 2
var0.TXT_TARGET_NUM = 3

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
	arg0:onUpdateTask()
end

function var0.initData(arg0)
	arg0.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	arg0.taskGroupList = arg0.activity:getConfig("config_data")
	arg0.taskProxy = getProxy(TaskProxy)
	arg0.page = var0.TYPE_ALL
end

function var0.initUI(arg0)
	arg0.getAllBtn = arg0:findTF("get_all")
	arg0.extendTpl = arg0:findTF("extend_tpl")
	arg0.typeToggles = {
		arg0:findTF("types/all"),
		arg0:findTF("types/daily"),
		arg0:findTF("types/target")
	}
	arg0.content = arg0:findTF("view/content")
	arg0.taskGroupItemList = UIItemList.New(arg0.content, arg0:findTF("tpl", arg0.content))
end

function var0.addListener(arg0)
	onButton(arg0, arg0.getAllBtn, function()
		arg0:emit(NewServerCarnivalMediator.TASK_SUBMIT_ONESTEP, arg0.finishVOList)
	end, SFX_PANEL)
	arg0.taskGroupItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			arg0:updateTaskGroup(arg2, arg1)
		end
	end)

	for iter0, iter1 in ipairs(arg0.typeToggles) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				if iter0 == var0.TYPE_ALL then
					arg0:filterAll()
				elseif iter0 == var0.TYPE_DAILY then
					arg0:filterDaily()
				elseif iter0 == var0.TYPE_TARGET then
					arg0:filterTarget()
				end

				arg0.page = iter0
			end

			arg0:updataTaskList()
		end)
	end
end

function var0.updateTaskGroup(arg0, arg1, arg2)
	local var0 = arg0.showVOGroup[arg2]
	local var1 = arg1:Find("info")
	local var2 = {}

	for iter0, iter1 in ipairs(var0) do
		if not iter1:isReceive() then
			table.insert(var2, iter1)
		end
	end

	triggerToggle(var1, false)

	local var3 = #var2 > 0 and table.remove(var2, 1) or var0[#var0]

	SetCompomentEnabled(var1, typeof(Toggle), #var2 > 0)
	arg0:updateTaskDisplay(var1, var3)
	setActive(var1:Find("toggle_mark"), #var2 > 0)

	local var4 = var3:getTaskStatus()

	GetOrAddComponent(arg1, typeof(CanvasGroup)).alpha = var4 == 2 and 0.5 or 1

	setActive(var1:Find("mask"), var4 == 2)
	setActive(var1:Find("bg/receive"), var4 == 1)
	setActive(var1:Find("tag/tag_daily"), var3:getConfig("type") == Task.TYPE_ACTIVITY_ROUTINE)
	setActive(var1:Find("tag/tag_target"), var3:getConfig("type") ~= Task.TYPE_ACTIVITY_ROUTINE)
	onToggle(arg0, var1, function(arg0)
		if arg0 then
			local var0 = arg1:Find("content")
			local var1 = UIItemList.New(var0, arg0.extendTpl)

			var1:make(function(arg0, arg1, arg2)
				arg1 = arg1 + 1

				if arg0 == UIItemList.EventUpdate then
					arg0:updateTaskDisplay(arg2, var2[arg1])
				end
			end)
			var1:align(#var2)
			scrollTo(arg0.content, 0, 1 - (arg2 - 1) / (#arg0.showVOGroup + #var2 - 4))
		else
			removeAllChildren(arg1:Find("content"))
		end
	end)
end

function var0.updateTaskDisplay(arg0, arg1, arg2)
	local var0 = arg2:getProgress()
	local var1 = arg2:getConfig("target_num")

	setSlider(arg1:Find("Slider"), 0, var1, var0)

	local var2 = arg2:getConfig("award_display")[1]
	local var3 = {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	}

	updateDrop(arg1:Find("IconTpl"), var3)
	onButton(arg0, arg1:Find("IconTpl"), function()
		arg0:emit(BaseUI.ON_DROP, var3)
	end, SFX_PANEL)

	local var4 = arg2:getTaskStatus()

	setActive(arg1:Find("go"), var4 == 0)
	setActive(arg1:Find("get"), var4 == 1)
	setActive(arg1:Find("got"), var4 == 2)
	setText(arg1:Find("desc"), setColorStr(arg2:getConfig("desc"), arg0:getColor(var0.TXT_DESC, var4)))
	setText(arg1:Find("Slider/Text"), setColorStr(var0, arg0:getColor(var0.TXT_CURRENT_NUM, var4)) .. setColorStr("/" .. var1, arg0:getColor(var0.TXT_TARGET_NUM, var4)))
	onButton(arg0, arg1:Find("go"), function()
		arg0:emit(NewServerCarnivalMediator.TASK_GO, arg2)
	end, SFX_PANEL)
	onButton(arg0, arg1:Find("get"), function()
		arg0:emit(NewServerCarnivalMediator.TASK_SUBMIT, arg2)
	end, SFX_CONFIRM)
end

function var0.getColor(arg0, arg1, arg2)
	if arg1 == var0.TXT_DESC then
		return arg2 == 1 and "#63573c" or "#a1976e"
	elseif arg1 == var0.TXT_CURRENT_NUM then
		return arg2 == 1 and "#219215" or "#65D559"
	elseif arg1 == var0.TXT_TARGET_NUM then
		return arg2 == 1 and "#5c4212" or "#ae9363"
	end
end

function var0.filterAll(arg0)
	arg0.taskVOGroup = underscore.map(arg0.taskGroupList, function(arg0)
		return underscore.map(arg0, function(arg0)
			assert(arg0.taskProxy:getTaskVO(arg0), "without this task:" .. arg0)

			return arg0.taskProxy:getTaskVO(arg0)
		end)
	end)
	arg0.showVOGroup = arg0.taskVOGroup
end

function var0.filterDaily(arg0)
	arg0.taskVOGroup = underscore.map(arg0.taskGroupList, function(arg0)
		return underscore.map(arg0, function(arg0)
			assert(arg0.taskProxy:getTaskVO(arg0), "without this task:" .. arg0)

			return arg0.taskProxy:getTaskVO(arg0)
		end)
	end)
	arg0.showVOGroup = {}

	for iter0, iter1 in ipairs(arg0.taskVOGroup) do
		if iter1[1]:getConfig("type") == Task.TYPE_ACTIVITY_ROUTINE then
			table.insert(arg0.showVOGroup, iter1)
		end
	end
end

function var0.filterTarget(arg0)
	arg0.taskVOGroup = underscore.map(arg0.taskGroupList, function(arg0)
		return underscore.map(arg0, function(arg0)
			assert(arg0.taskProxy:getTaskVO(arg0), "without this task:" .. arg0)

			return arg0.taskProxy:getTaskVO(arg0)
		end)
	end)
	arg0.showVOGroup = {}

	for iter0, iter1 in ipairs(arg0.taskVOGroup) do
		if iter1[1]:getConfig("type") ~= Task.TYPE_ACTIVITY_ROUTINE then
			table.insert(arg0.showVOGroup, iter1)
		end
	end
end

function var0.updataTaskList(arg0)
	table.sort(arg0.showVOGroup, CompareFuncs({
		function(arg0)
			for iter0, iter1 in ipairs(arg0) do
				if iter1:getTaskStatus() == 1 then
					return 0
				end
			end

			return underscore.all(arg0, function(arg0)
				return arg0:isReceive()
			end) and 2 or 1
		end,
		function(arg0)
			return arg0[1]:getConfig("type") ~= Task.TYPE_ACTIVITY_ROUTINE and 1 or 0
		end,
		function(arg0)
			return arg0[1].id
		end
	}))
	arg0.taskGroupItemList:align(#arg0.showVOGroup)
end

function var0.onUpdateTask(arg0)
	triggerToggle(arg0.typeToggles[arg0.page], true)
	arg0:updataGetAllBtn()
end

function var0.updataGetAllBtn(arg0)
	arg0.finishVOList = {}

	for iter0, iter1 in ipairs(arg0.taskVOGroup) do
		for iter2, iter3 in ipairs(iter1) do
			if iter3:getTaskStatus() == 1 then
				table.insert(arg0.finishVOList, iter3)
			end
		end
	end

	setActive(arg0.getAllBtn, #arg0.finishVOList > 0)
end

function var0.isTip(arg0)
	if arg0.finishVOList then
		return #arg0.finishVOList > 0
	else
		local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)

		if var0 and not var0:isEnd() then
			local var1 = getProxy(TaskProxy)
			local var2 = var0:getConfig("config_data")

			for iter0, iter1 in ipairs(var2) do
				for iter2, iter3 in ipairs(iter1) do
					assert(var1:getTaskVO(iter3), "without this task:" .. iter3)

					if var1:getTaskVO(iter3):getTaskStatus() == 1 then
						return true
					end
				end
			end
		end

		return false
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
