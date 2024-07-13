local var0_0 = class("OtherWorldTaskPage")
local var1_0 = 3
local var2_0 = 1
local var3_0 = "other_world_task_type_daily"
local var4_0 = "other_world_task_type_main"
local var5_0 = "other_world_task_type_repeat"
local var6_0 = "other_world_task_get_all"
local var7_0 = "other_world_task_go"
local var8_0 = "other_world_task_got"
local var9_0 = "other_world_task_get"
local var10_0 = "other_world_task_tag_main"
local var11_0 = "other_world_task_tag_daily"
local var12_0 = "other_world_task_tag_all"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.taskPage = arg1_1
	arg0_1.contextData = arg2_1
	arg0_1.taskItemTpl = findTF(arg3_1, "taskItemTpl")
	arg0_1.iconTpl = findTF(arg3_1, "IconTpl")
	arg0_1._event = arg4_1

	setText(findTF(arg0_1.taskItemTpl, "btnGo/text"), i18n(var7_0))
	setText(findTF(arg0_1.taskItemTpl, "btnGot/text"), i18n(var8_0))
	setText(findTF(arg0_1.taskItemTpl, "btnGet/text"), i18n(var9_0))
	setText(findTF(arg0_1.taskPage, "leftBtns/btnAll/text"), i18n(var12_0))
	setText(findTF(arg0_1.taskPage, "leftBtns/btnMain/text"), i18n(var10_0))
	setText(findTF(arg0_1.taskPage, "leftBtns/btnDaily/text"), i18n(var11_0))
	setText(findTF(arg0_1.taskPage, "leftBtns/btnAll/text_selected"), i18n(var12_0))
	setText(findTF(arg0_1.taskPage, "leftBtns/btnMain/text_selected"), i18n(var10_0))
	setText(findTF(arg0_1.taskPage, "leftBtns/btnDaily/text_selected"), i18n(var11_0))
	setText(findTF(arg0_1.taskPage, "btnGetAll/text"), i18n(var6_0))
	setActive(arg0_1.taskItemTpl, false)
	setActive(arg0_1.iconTpl, false)

	arg0_1.enterTaskId = nil
	arg0_1.enterTaskIds = nil

	if arg0_1.contextData.task_id then
		arg0_1.enterTaskId = arg0_1.contextData.task_id or nil
	elseif arg0_1.contextData.task_ids then
		arg0_1.enterTaskIds = arg0_1.contextData.task_ids or nil
	end

	arg0_1.activityId = ActivityConst.OTHER_WORLD_TASK_ID
	arg0_1.hideTask = {}

	if pg.activity_template[arg0_1.activityId] then
		arg0_1.hideTask = pg.activity_template[arg0_1.activityId].config_client.hide_task or {}
	end

	arg0_1.btnGetAll = findTF(arg0_1.taskPage, "btnGetAll")
	arg0_1.taskTagPanel = findTF(arg0_1.taskPage, "taskTagPanel")
	arg0_1.taskListPanel = findTF(arg0_1.taskPage, "taskListPanel")
	arg0_1.scrollRect = findTF(arg0_1.taskPage, "taskListPanel/Content"):GetComponent("LScrollRect")

	function arg0_1.scrollRect.onUpdateItem(arg0_2, arg1_2)
		arg0_1:onUpdateTaskItem(arg0_2, arg1_2)
	end

	arg0_1.btnAll = findTF(arg0_1.taskPage, "leftBtns/btnAll")
	arg0_1.btnDaily = findTF(arg0_1.taskPage, "leftBtns/btnDaily")
	arg0_1.btnMain = findTF(arg0_1.taskPage, "leftBtns/btnMain")

	onButton(arg0_1._event, arg0_1.btnAll, function()
		arg0_1:clearTagBtn()
		setActive(findTF(arg0_1.btnAll, "bg_selected"), true)
		setActive(findTF(arg0_1.btnAll, "text_selected"), true)
		setActive(findTF(arg0_1.btnAll, "text"), false)
		setImageColor(findTF(arg0_1.btnAll, "bg"), Color.New(1, 0.988235294117647, 0.909803921568627, 1))
		arg0_1:showTaskByType()
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnDaily, function()
		arg0_1:clearTagBtn()
		setActive(findTF(arg0_1.btnDaily, "bg_selected"), true)
		setActive(findTF(arg0_1.btnDaily, "text_selected"), true)
		setActive(findTF(arg0_1.btnDaily, "text"), false)
		setImageColor(findTF(arg0_1.btnDaily, "bg"), Color.New(1, 0.988235294117647, 0.909803921568627, 1))
		arg0_1:showTaskByType(var1_0)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnMain, function()
		arg0_1:clearTagBtn()
		setActive(findTF(arg0_1.btnMain, "bg_selected"), true)
		setActive(findTF(arg0_1.btnMain, "text_selected"), true)
		setActive(findTF(arg0_1.btnMain, "text"), false)
		setImageColor(findTF(arg0_1.btnMain, "bg"), Color.New(1, 0.988235294117647, 0.909803921568627, 1))
		arg0_1:showTaskByType(var2_0)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnGetAll, function()
		local var0_6 = arg0_1.getAllTasks

		arg0_1._event:emit(OtherWorldTaskMediator.SUBMIT_TASK_ALL, {
			activityId = arg0_1.activityId,
			ids = var0_6
		})
	end, SFX_CONFIRM)

	arg0_1.iconTfs = {}
	arg0_1.awards = {}

	arg0_1:updateTask()
	triggerButton(arg0_1.btnAll, true)
end

function var0_0.showTaskByType(arg0_7, arg1_7)
	arg0_7.tagType = arg1_7
	arg0_7.showTasks = {}

	if arg1_7 then
		for iter0_7, iter1_7 in ipairs(arg0_7.allDisplayTask) do
			if iter1_7:getConfig("priority_type") == arg1_7 then
				table.insert(arg0_7.showTasks, iter1_7)
			end
		end
	else
		arg0_7.showTasks = arg0_7.allDisplayTask
	end

	if arg0_7.enterTaskId and arg0_7.enterTaskId > 0 then
		for iter2_7 = 1, #arg0_7.showTasks do
			if arg0_7.showTasks[iter2_7].id == arg0_7.enterTaskId then
				arg0_7.scrollIndex = iter2_7
			end
		end
	end

	arg0_7.scrollRect:SetTotalCount(#arg0_7.showTasks, 0)

	if arg0_7.scrollIndex ~= nil then
		local var0_7 = arg0_7.scrollRect:HeadIndexToValue(arg0_7.scrollIndex - 1)

		arg0_7.scrollRect:ScrollTo(var0_7)
	end
end

function var0_0.clearTagBtn(arg0_8)
	setActive(findTF(arg0_8.btnAll, "bg_selected"), false)
	setActive(findTF(arg0_8.btnDaily, "bg_selected"), false)
	setActive(findTF(arg0_8.btnMain, "bg_selected"), false)
	setActive(findTF(arg0_8.btnMain, "text_selected"), false)
	setActive(findTF(arg0_8.btnDaily, "text_selected"), false)
	setActive(findTF(arg0_8.btnAll, "text_selected"), false)
	setActive(findTF(arg0_8.btnMain, "text"), true)
	setActive(findTF(arg0_8.btnDaily, "text"), true)
	setActive(findTF(arg0_8.btnAll, "text"), true)
	setImageColor(findTF(arg0_8.btnMain, "bg"), Color.New(0.737254901960784, 0.635294117647059, 0.588235294117647, 1))
	setImageColor(findTF(arg0_8.btnDaily, "bg"), Color.New(0.737254901960784, 0.635294117647059, 0.588235294117647, 1))
	setImageColor(findTF(arg0_8.btnAll, "bg"), Color.New(0.737254901960784, 0.635294117647059, 0.588235294117647, 1))
end

function var0_0.onUpdateTaskItem(arg0_9, arg1_9, arg2_9)
	if arg0_9.exitFlag then
		return
	end

	arg1_9 = arg1_9 + 1

	local var0_9 = arg0_9.showTasks[arg1_9]
	local var1_9 = var0_9.id
	local var2_9 = var0_9:getProgress()
	local var3_9 = var0_9:getConfig("desc")
	local var4_9 = var0_9:getConfig("ryza_icon")
	local var5_9 = var0_9:isOver()
	local var6_9 = var0_9:isFinish()
	local var7_9 = var0_9:getTarget()
	local var8_9 = var0_9:isCircle()
	local var9_9 = var0_9:isDaily()
	local var10_9 = var0_9:isSubmit()
	local var11_9 = var0_9:getConfig("sub_type")
	local var12_9 = var0_9:getConfig("type")
	local var13_9 = var0_9:getConfig("priority_type")

	setScrollText(findTF(arg2_9, "desc/text"), var3_9)

	if PLATFORM_CODE ~= PLATFORM_CH then
		-- block empty
	end

	if not var5_9 then
		setText(findTF(arg2_9, "progressDesc/text"), setColorStr(var2_9, "#51382E") .. " / " .. setColorStr(var7_9, "#51382E"))
	else
		setText(findTF(arg2_9, "progressDesc/text"), "--/--")
	end

	setSlider(findTF(arg2_9, "progressBar"), 0, 1, var5_9 and 1 or var2_9 / var7_9)

	local var14_9 = pg.task_data_template[var1_9].award_display
	local var15_9 = findTF(arg2_9, "awardDisplay/viewport/content")
	local var16_9 = var15_9.childCount

	if var16_9 < #var14_9 then
		local var17_9 = #var14_9 - var16_9

		for iter0_9 = 1, var17_9 do
			local var18_9 = tf(Instantiate(arg0_9.iconTpl))

			setParent(var18_9, var15_9)
			setActive(var18_9, true)
		end
	end

	for iter1_9 = 1, var15_9.childCount do
		local var19_9 = var15_9:GetChild(iter1_9 - 1)

		if iter1_9 <= #var14_9 then
			local var20_9 = var14_9[iter1_9]
			local var21_9 = {
				type = var20_9[1],
				id = var20_9[2],
				count = var20_9[3]
			}

			updateDrop(var19_9, var21_9)
			onButton(arg0_9._event, var19_9, function()
				arg0_9._event:emit(BaseUI.ON_DROP, var21_9)
			end, SFX_PANEL)
			setActive(var19_9, true)
		else
			setActive(var19_9, false)
		end
	end

	setActive(findTF(arg2_9, "btnGo"), not var5_9 and not var6_9 and var11_9 ~= 1006)
	setActive(findTF(arg2_9, "btnGet"), not var5_9 and var6_9 and not var10_9)
	setActive(findTF(arg2_9, "btnGot"), var6_9)
	setSlider(findTF(arg2_9, "progressBar"), 0, 1, var2_9 / var7_9)

	local var22_9

	if var13_9 == var1_0 then
		if var12_9 == 16 and var11_9 == 20 then
			var22_9 = var5_0
		else
			var22_9 = var3_0
		end
	else
		var22_9 = var4_0
	end

	setText(findTF(arg2_9, "tag/text"), i18n(var22_9))
	onButton(arg0_9._event, findTF(arg2_9, "btnGo"), function()
		arg0_9._event:emit(OtherWorldTaskMediator.TASK_GO, {
			taskVO = var0_9
		})
	end, SFX_CONFIRM)
	onButton(arg0_9._event, findTF(arg2_9, "btnGet"), function()
		local var0_12 = var0_9:getConfig("priority_type")
		local var1_12 = var0_9:getConfig("sub_type")

		arg0_9._event:emit(OtherWorldTaskMediator.SUBMIT_TASK, {
			activityId = arg0_9.activityId,
			id = var0_9.id
		})
	end, SFX_CONFIRM)

	if arg1_9 == 1 then
		arg0_9.scrollIndex = nil
	end

	if arg0_9.enterTaskId ~= nil and arg0_9.enterTaskId > 0 then
		if var1_9 == arg0_9.enterTaskId then
			arg0_9.enterTaskId = nil
			arg0_9.scrollIndex = nil
		end
	elseif arg0_9.enterTaskIds and #arg0_9.enterTaskIds > 0 then
		for iter2_9, iter3_9 in ipairs(arg0_9.enterTaskIds) do
			if var1_9 == iter3_9 then
				arg0_9.enterTaskIds = nil
				arg0_9.scrollIndex = nil
			end
		end
	end
end

function var0_0.updateTask(arg0_13, arg1_13)
	arg0_13.displayTask = {}
	arg0_13.allDisplayTask = {}

	local var0_13 = getProxy(ActivityTaskProxy):getTaskById(arg0_13.activityId)

	arg0_13.getAllTasks = {}

	for iter0_13 = 1, #var0_13 do
		local var1_13 = var0_13[iter0_13]
		local var2_13 = var1_13.id

		if not table.contains(arg0_13.hideTask, var2_13) then
			local var3_13 = var1_13:getProgress()
			local var4_13 = var1_13:getTarget()
			local var5_13 = var1_13:getConfig("priority_type")

			if not arg0_13.displayTask[var5_13] then
				arg0_13.displayTask[var5_13] = {}
			end

			table.insert(arg0_13.displayTask[var5_13], var1_13)
			table.insert(arg0_13.allDisplayTask, var1_13)

			if var1_13:isFinish() and not var1_13:isOver() then
				table.insert(arg0_13.getAllTasks, var2_13)
			end
		end
	end

	local var6_13 = getProxy(ActivityProxy):getActivityById(arg0_13.activityId)
	local var7_13 = {}

	if var6_13 then
		var7_13 = var6_13.data1_list
	end

	if var7_13 and #var7_13 > 0 then
		for iter1_13 = 1, #var7_13 do
			local var8_13 = var7_13[iter1_13]
			local var9_13 = ActivityTask.New(arg0_13.activityId, {
				progress = 0,
				id = var8_13
			})

			var9_13:setOver()

			local var10_13 = var9_13:getConfig("ryza_type")

			if var10_13 > 0 then
				if not arg0_13.displayTask[var10_13] then
					arg0_13.displayTask[var10_13] = {}
				end

				table.insert(arg0_13.displayTask[var10_13], var9_13)
				table.insert(arg0_13.allDisplayTask, var9_13)
			end
		end
	end

	local function var11_13(arg0_14, arg1_14)
		if arg0_14:isOver() and not arg1_14:isOver() then
			return false
		elseif not arg0_14:isOver() and arg1_14:isOver() then
			return true
		end

		if arg0_14:isFinish() and not arg1_14:isFinish() then
			return true
		elseif not arg0_14:isFinish() and arg1_14:isFinish() then
			return false
		end

		local var0_14 = arg0_14:getConfig("priority_type")
		local var1_14 = arg1_14:getConfig("priority_type")

		if var0_14 == var2_0 and var1_14 == var1_0 then
			return true
		elseif var0_14 == var1_0 and var1_14 == var2_0 then
			return false
		end

		if arg0_14:isNew() and not arg1_14:isNew() then
			return true
		elseif not arg0_14:isNew() and arg1_14:isNew() then
			return false
		end

		if arg0_14.id > arg1_14.id then
			return false
		elseif arg0_14.id < arg1_14.id then
			return true
		end
	end

	for iter2_13, iter3_13 in pairs(arg0_13.displayTask) do
		table.sort(iter3_13, var11_13)
	end

	table.sort(arg0_13.allDisplayTask, var11_13)

	if arg1_13 then
		arg0_13:showTaskByType(arg0_13.tagType)
	end

	if #arg0_13.getAllTasks > 0 then
		setActive(arg0_13.btnGetAll, true)
	else
		setActive(arg0_13.btnGetAll, false)
	end
end

function var0_0.setActive(arg0_15, arg1_15)
	setActive(arg0_15.taskPage, arg1_15)
end

function var0_0.dispose(arg0_16)
	arg0_16.exitFlag = true

	for iter0_16 = 1, #arg0_16.allDisplayTask do
		local var0_16 = arg0_16.allDisplayTask[iter0_16]

		if var0_16:isNew() then
			var0_16:changeNew()
		end
	end
end

return var0_0
