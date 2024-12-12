local var0_0 = class("BlackFridaySalesTaskPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BlackFridaySalesTaskPage"
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
	local var0_3 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASKS)

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if iter1_3:getConfig("config_client").blackFriday then
			arg0_3.activity = iter1_3

			break
		end
	end

	arg0_3.taskGroupList = arg0_3.activity:getConfig("config_client").taskGroup
	arg0_3.taskProxy = getProxy(TaskProxy)
	arg0_3.page = var0_0.TYPE_ALL
end

function var0_0.initUI(arg0_4)
	arg0_4.getAllBtn = arg0_4:findTF("get_all")
	arg0_4.extendTpl = arg0_4:findTF("extend_tpl")
	arg0_4.content = arg0_4:findTF("view/content")
	arg0_4.taskGroupItemList = UIItemList.New(arg0_4.content, arg0_4:findTF("tpl", arg0_4.content))

	setActive(arg0_4.getAllBtn, false)
end

function var0_0.addListener(arg0_5)
	onButton(arg0_5, arg0_5.getAllBtn, function()
		arg0_5:emit(BlackFridaySalesMediator.TASK_SUBMIT_ONESTEP, arg0_5.finishVOList)
	end, SFX_PANEL)
	arg0_5.taskGroupItemList:make(function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			arg0_5:updateTaskGroup(arg2_7, arg1_7)
		end
	end)
end

function var0_0.updateTaskGroup(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.showVOGroup[arg2_8]
	local var1_8 = arg1_8:Find("info")
	local var2_8 = {}

	for iter0_8, iter1_8 in ipairs(var0_8) do
		if not iter1_8:isReceive() then
			table.insert(var2_8, iter1_8)
		end
	end

	triggerToggle(var1_8, false)

	local var3_8 = #var2_8 > 0 and table.remove(var2_8, 1) or var0_8[#var0_8]

	SetCompomentEnabled(var1_8, typeof(Toggle), #var2_8 > 0)
	arg0_8:updateTaskDisplay(var1_8, var3_8)
	setActive(var1_8:Find("toggle_mark"), #var2_8 > 0)

	local var4_8 = var3_8:getTaskStatus()

	GetOrAddComponent(arg1_8, typeof(CanvasGroup)).alpha = var4_8 == 2 and 0.5 or 1

	setActive(var1_8:Find("mask"), var4_8 == 2)
	setActive(var1_8:Find("bg/receive"), var4_8 == 1)
	onToggle(arg0_8, var1_8, function(arg0_9)
		if arg0_9 then
			local var0_9 = arg1_8:Find("content")
			local var1_9 = UIItemList.New(var0_9, arg0_8.extendTpl)

			var1_9:make(function(arg0_10, arg1_10, arg2_10)
				arg1_10 = arg1_10 + 1

				if arg0_10 == UIItemList.EventUpdate then
					arg0_8:updateTaskDisplay(arg2_10, var2_8[arg1_10])
				end
			end)
			var1_9:align(#var2_8)
			scrollTo(arg0_8.content, 0, 1 - (arg2_8 - 1) / (#arg0_8.showVOGroup + #var2_8 - 4))
		else
			removeAllChildren(arg1_8:Find("content"))
		end
	end)
end

function var0_0.updateTaskDisplay(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg2_11:getProgress()
	local var1_11 = arg2_11:getConfig("target_num")

	setSlider(arg1_11:Find("Slider"), 0, var1_11, var0_11)

	local var2_11 = arg2_11:getConfig("award_display")[1]
	local var3_11 = {
		type = var2_11[1],
		id = var2_11[2],
		count = var2_11[3]
	}

	updateDrop(arg1_11:Find("IconTpl"), var3_11)
	onButton(arg0_11, arg1_11:Find("IconTpl"), function()
		arg0_11:emit(BaseUI.ON_DROP, var3_11)
	end, SFX_PANEL)

	local var4_11 = arg2_11:getTaskStatus()

	setActive(arg1_11:Find("go"), var4_11 == 0)
	setActive(arg1_11:Find("get"), var4_11 == 1)
	setActive(arg1_11:Find("got"), var4_11 == 2)
	setText(arg1_11:Find("desc"), setColorStr(arg2_11:getConfig("desc"), arg0_11:getColor(var0_0.TXT_DESC, var4_11)))
	setText(arg1_11:Find("Slider/Text"), setColorStr(var0_11, arg0_11:getColor(var0_0.TXT_CURRENT_NUM, var4_11)) .. setColorStr("/" .. var1_11, arg0_11:getColor(var0_0.TXT_TARGET_NUM, var4_11)))
	onButton(arg0_11, arg1_11:Find("go"), function()
		arg0_11:emit(BlackFridaySalesMediator.TASK_GO, arg2_11)
	end, SFX_PANEL)
	onButton(arg0_11, arg1_11:Find("get"), function()
		arg0_11:emit(BlackFridaySalesMediator.TASK_SUBMIT, arg2_11)
	end, SFX_CONFIRM)
end

function var0_0.getColor(arg0_15, arg1_15, arg2_15)
	if arg1_15 == var0_0.TXT_DESC then
		return arg2_15 == 1 and "#393a3c" or "#ffffff"
	elseif arg1_15 == var0_0.TXT_CURRENT_NUM then
		return "#30ec80"
	elseif arg1_15 == var0_0.TXT_TARGET_NUM then
		return "#393a3c"
	end
end

function var0_0.filterAll(arg0_16)
	arg0_16.taskVOGroup = underscore.map(arg0_16.taskGroupList, function(arg0_17)
		return underscore.map(arg0_17, function(arg0_18)
			assert(arg0_16.taskProxy:getTaskVO(arg0_18), "without this task:" .. arg0_18)

			return arg0_16.taskProxy:getTaskVO(arg0_18)
		end)
	end)
	arg0_16.showVOGroup = arg0_16.taskVOGroup
end

function var0_0.updataTaskList(arg0_19)
	table.sort(arg0_19.showVOGroup, CompareFuncs({
		function(arg0_20)
			for iter0_20, iter1_20 in ipairs(arg0_20) do
				if iter1_20:getTaskStatus() == 1 then
					return 0
				end
			end

			return underscore.all(arg0_20, function(arg0_21)
				return arg0_21:isReceive()
			end) and 2 or 1
		end,
		function(arg0_22)
			return arg0_22[1].id
		end
	}))
	arg0_19.taskGroupItemList:align(#arg0_19.showVOGroup)
end

function var0_0.onUpdateTask(arg0_23)
	arg0_23:filterAll()
	arg0_23:updataTaskList()
	arg0_23:updataGetAllBtn()
end

function var0_0.updataGetAllBtn(arg0_24)
	return
end

function var0_0.isTip(arg0_25)
	if arg0_25.finishVOList then
		return #arg0_25.finishVOList > 0
	else
		local var0_25
		local var1_25 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_TASKS)

		for iter0_25, iter1_25 in ipairs(var1_25) do
			if iter1_25:getConfig("config_client").blackFriday then
				var0_25 = iter1_25

				break
			end
		end

		if var0_25 and not var0_25:isEnd() then
			local var2_25 = getProxy(TaskProxy)
			local var3_25 = var0_25:getConfig("config_client").taskGroup

			for iter2_25, iter3_25 in ipairs(var3_25) do
				for iter4_25, iter5_25 in ipairs(iter3_25) do
					assert(var2_25:getTaskVO(iter5_25), "without this task:" .. iter5_25)

					if var2_25:getTaskVO(iter5_25):getTaskStatus() == 1 then
						return true
					end
				end
			end
		end

		return false
	end
end

function var0_0.OnDestroy(arg0_26)
	return
end

return var0_0
