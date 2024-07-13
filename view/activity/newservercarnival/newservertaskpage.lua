local var0_0 = class("NewServerTaskPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewServerTaskPage"
end

var0_0.TYPE_ALL = 1
var0_0.TYPE_DAILY = 2
var0_0.TYPE_TARGET = 3
var0_0.TXT_DESC = 1
var0_0.TXT_CURRENT_NUM = 2
var0_0.TXT_TARGET_NUM = 3

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:onUpdateTask()
end

function var0_0.initData(arg0_3)
	arg0_3.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)
	arg0_3.taskGroupList = arg0_3.activity:getConfig("config_data")
	arg0_3.taskProxy = getProxy(TaskProxy)
	arg0_3.page = var0_0.TYPE_ALL
end

function var0_0.initUI(arg0_4)
	arg0_4.getAllBtn = arg0_4:findTF("get_all")
	arg0_4.extendTpl = arg0_4:findTF("extend_tpl")
	arg0_4.typeToggles = {
		arg0_4:findTF("types/all"),
		arg0_4:findTF("types/daily"),
		arg0_4:findTF("types/target")
	}
	arg0_4.content = arg0_4:findTF("view/content")
	arg0_4.taskGroupItemList = UIItemList.New(arg0_4.content, arg0_4:findTF("tpl", arg0_4.content))
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5.getAllBtn, function()
		arg0_5:emit(NewServerCarnivalMediator.TASK_SUBMIT_ONESTEP, arg0_5.finishVOList)
	end, SFX_PANEL)
	arg0_5.taskGroupItemList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			arg0_5:updateTaskGroup(arg2_7, arg1_7)
		end
	end)

	for iter0_5, iter1_5 in ipairs(arg0_5.typeToggles) do
		onToggle(arg0_5, iter1_5, function(arg0_8)
			if arg0_8 then
				if iter0_5 == var0_0.TYPE_ALL then
					arg0_5:filterAll()
				elseif iter0_5 == var0_0.TYPE_DAILY then
					arg0_5:filterDaily()
				elseif iter0_5 == var0_0.TYPE_TARGET then
					arg0_5:filterTarget()
				end

				arg0_5.page = iter0_5
			end

			arg0_5:updataTaskList()
		end)
	end
end

function var0_0.updateTaskGroup(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9.showVOGroup[arg2_9]
	local var1_9 = arg1_9:Find("info")
	local var2_9 = {}

	for iter0_9, iter1_9 in ipairs(var0_9) do
		if not iter1_9:isReceive() then
			table.insert(var2_9, iter1_9)
		end
	end

	triggerToggle(var1_9, false)

	local var3_9 = #var2_9 > 0 and table.remove(var2_9, 1) or var0_9[#var0_9]

	SetCompomentEnabled(var1_9, typeof(Toggle), #var2_9 > 0)
	arg0_9:updateTaskDisplay(var1_9, var3_9)
	setActive(var1_9:Find("toggle_mark"), #var2_9 > 0)

	local var4_9 = var3_9:getTaskStatus()

	GetOrAddComponent(arg1_9, typeof(CanvasGroup)).alpha = var4_9 == 2 and 0.5 or 1

	setActive(var1_9:Find("mask"), var4_9 == 2)
	setActive(var1_9:Find("bg/receive"), var4_9 == 1)
	setActive(var1_9:Find("tag/tag_daily"), var3_9:getConfig("type") == Task.TYPE_ACTIVITY_ROUTINE)
	setActive(var1_9:Find("tag/tag_target"), var3_9:getConfig("type") ~= Task.TYPE_ACTIVITY_ROUTINE)
	onToggle(arg0_9, var1_9, function(arg0_10)
		if arg0_10 then
			local var0_10 = arg1_9:Find("content")
			local var1_10 = UIItemList.New(var0_10, arg0_9.extendTpl)

			var1_10:make(function(arg0_11, arg1_11, arg2_11)
				arg1_11 = arg1_11 + 1

				if arg0_11 == UIItemList.EventUpdate then
					arg0_9:updateTaskDisplay(arg2_11, var2_9[arg1_11])
				end
			end)
			var1_10:align(#var2_9)
			scrollTo(arg0_9.content, 0, 1 - (arg2_9 - 1) / (#arg0_9.showVOGroup + #var2_9 - 4))
		else
			removeAllChildren(arg1_9:Find("content"))
		end
	end)
end

function var0_0.updateTaskDisplay(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg2_12:getProgress()
	local var1_12 = arg2_12:getConfig("target_num")

	setSlider(arg1_12:Find("Slider"), 0, var1_12, var0_12)

	local var2_12 = arg2_12:getConfig("award_display")[1]
	local var3_12 = {
		type = var2_12[1],
		id = var2_12[2],
		count = var2_12[3]
	}

	updateDrop(arg1_12:Find("IconTpl"), var3_12)
	onButton(arg0_12, arg1_12:Find("IconTpl"), function()
		arg0_12:emit(BaseUI.ON_DROP, var3_12)
	end, SFX_PANEL)

	local var4_12 = arg2_12:getTaskStatus()

	setActive(arg1_12:Find("go"), var4_12 == 0)
	setActive(arg1_12:Find("get"), var4_12 == 1)
	setActive(arg1_12:Find("got"), var4_12 == 2)
	setText(arg1_12:Find("desc"), setColorStr(arg2_12:getConfig("desc"), arg0_12:getColor(var0_0.TXT_DESC, var4_12)))
	setText(arg1_12:Find("Slider/Text"), setColorStr(var0_12, arg0_12:getColor(var0_0.TXT_CURRENT_NUM, var4_12)) .. setColorStr("/" .. var1_12, arg0_12:getColor(var0_0.TXT_TARGET_NUM, var4_12)))
	onButton(arg0_12, arg1_12:Find("go"), function()
		arg0_12:emit(NewServerCarnivalMediator.TASK_GO, arg2_12)
	end, SFX_PANEL)
	onButton(arg0_12, arg1_12:Find("get"), function()
		arg0_12:emit(NewServerCarnivalMediator.TASK_SUBMIT, arg2_12)
	end, SFX_CONFIRM)
end

function var0_0.getColor(arg0_16, arg1_16, arg2_16)
	if arg1_16 == var0_0.TXT_DESC then
		return arg2_16 == 1 and "#63573c" or "#a1976e"
	elseif arg1_16 == var0_0.TXT_CURRENT_NUM then
		return arg2_16 == 1 and "#219215" or "#65D559"
	elseif arg1_16 == var0_0.TXT_TARGET_NUM then
		return arg2_16 == 1 and "#5c4212" or "#ae9363"
	end
end

function var0_0.filterAll(arg0_17)
	arg0_17.taskVOGroup = underscore.map(arg0_17.taskGroupList, function(arg0_18)
		return underscore.map(arg0_18, function(arg0_19)
			assert(arg0_17.taskProxy:getTaskVO(arg0_19), "without this task:" .. arg0_19)

			return arg0_17.taskProxy:getTaskVO(arg0_19)
		end)
	end)
	arg0_17.showVOGroup = arg0_17.taskVOGroup
end

function var0_0.filterDaily(arg0_20)
	arg0_20.taskVOGroup = underscore.map(arg0_20.taskGroupList, function(arg0_21)
		return underscore.map(arg0_21, function(arg0_22)
			assert(arg0_20.taskProxy:getTaskVO(arg0_22), "without this task:" .. arg0_22)

			return arg0_20.taskProxy:getTaskVO(arg0_22)
		end)
	end)
	arg0_20.showVOGroup = {}

	for iter0_20, iter1_20 in ipairs(arg0_20.taskVOGroup) do
		if iter1_20[1]:getConfig("type") == Task.TYPE_ACTIVITY_ROUTINE then
			table.insert(arg0_20.showVOGroup, iter1_20)
		end
	end
end

function var0_0.filterTarget(arg0_23)
	arg0_23.taskVOGroup = underscore.map(arg0_23.taskGroupList, function(arg0_24)
		return underscore.map(arg0_24, function(arg0_25)
			assert(arg0_23.taskProxy:getTaskVO(arg0_25), "without this task:" .. arg0_25)

			return arg0_23.taskProxy:getTaskVO(arg0_25)
		end)
	end)
	arg0_23.showVOGroup = {}

	for iter0_23, iter1_23 in ipairs(arg0_23.taskVOGroup) do
		if iter1_23[1]:getConfig("type") ~= Task.TYPE_ACTIVITY_ROUTINE then
			table.insert(arg0_23.showVOGroup, iter1_23)
		end
	end
end

function var0_0.updataTaskList(arg0_26)
	table.sort(arg0_26.showVOGroup, CompareFuncs({
		function(arg0_27)
			for iter0_27, iter1_27 in ipairs(arg0_27) do
				if iter1_27:getTaskStatus() == 1 then
					return 0
				end
			end

			return underscore.all(arg0_27, function(arg0_28)
				return arg0_28:isReceive()
			end) and 2 or 1
		end,
		function(arg0_29)
			return arg0_29[1]:getConfig("type") ~= Task.TYPE_ACTIVITY_ROUTINE and 1 or 0
		end,
		function(arg0_30)
			return arg0_30[1].id
		end
	}))
	arg0_26.taskGroupItemList:align(#arg0_26.showVOGroup)
end

function var0_0.onUpdateTask(arg0_31)
	triggerToggle(arg0_31.typeToggles[arg0_31.page], true)
	arg0_31:updataGetAllBtn()
end

function var0_0.updataGetAllBtn(arg0_32)
	arg0_32.finishVOList = {}

	for iter0_32, iter1_32 in ipairs(arg0_32.taskVOGroup) do
		for iter2_32, iter3_32 in ipairs(iter1_32) do
			if iter3_32:getTaskStatus() == 1 then
				table.insert(arg0_32.finishVOList, iter3_32)
			end
		end
	end

	setActive(arg0_32.getAllBtn, #arg0_32.finishVOList > 0)
end

function var0_0.isTip(arg0_33)
	if arg0_33.finishVOList then
		return #arg0_33.finishVOList > 0
	else
		local var0_33 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_TASK)

		if var0_33 and not var0_33:isEnd() then
			local var1_33 = getProxy(TaskProxy)
			local var2_33 = var0_33:getConfig("config_data")

			for iter0_33, iter1_33 in ipairs(var2_33) do
				for iter2_33, iter3_33 in ipairs(iter1_33) do
					assert(var1_33:getTaskVO(iter3_33), "without this task:" .. iter3_33)

					if var1_33:getTaskVO(iter3_33):getTaskStatus() == 1 then
						return true
					end
				end
			end
		end

		return false
	end
end

function var0_0.OnDestroy(arg0_34)
	return
end

return var0_0
