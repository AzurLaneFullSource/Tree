local var0 = class("OtherWorldTaskPage")
local var1 = 3
local var2 = 1
local var3 = "other_world_task_type_daily"
local var4 = "other_world_task_type_main"
local var5 = "other_world_task_type_repeat"
local var6 = "other_world_task_get_all"
local var7 = "other_world_task_go"
local var8 = "other_world_task_got"
local var9 = "other_world_task_get"
local var10 = "other_world_task_tag_main"
local var11 = "other_world_task_tag_daily"
local var12 = "other_world_task_tag_all"

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.taskPage = arg1
	arg0.contextData = arg2
	arg0.taskItemTpl = findTF(arg3, "taskItemTpl")
	arg0.iconTpl = findTF(arg3, "IconTpl")
	arg0._event = arg4

	setText(findTF(arg0.taskItemTpl, "btnGo/text"), i18n(var7))
	setText(findTF(arg0.taskItemTpl, "btnGot/text"), i18n(var8))
	setText(findTF(arg0.taskItemTpl, "btnGet/text"), i18n(var9))
	setText(findTF(arg0.taskPage, "leftBtns/btnAll/text"), i18n(var12))
	setText(findTF(arg0.taskPage, "leftBtns/btnMain/text"), i18n(var10))
	setText(findTF(arg0.taskPage, "leftBtns/btnDaily/text"), i18n(var11))
	setText(findTF(arg0.taskPage, "leftBtns/btnAll/text_selected"), i18n(var12))
	setText(findTF(arg0.taskPage, "leftBtns/btnMain/text_selected"), i18n(var10))
	setText(findTF(arg0.taskPage, "leftBtns/btnDaily/text_selected"), i18n(var11))
	setText(findTF(arg0.taskPage, "btnGetAll/text"), i18n(var6))
	setActive(arg0.taskItemTpl, false)
	setActive(arg0.iconTpl, false)

	arg0.enterTaskId = nil
	arg0.enterTaskIds = nil

	if arg0.contextData.task_id then
		arg0.enterTaskId = arg0.contextData.task_id or nil
	elseif arg0.contextData.task_ids then
		arg0.enterTaskIds = arg0.contextData.task_ids or nil
	end

	arg0.activityId = ActivityConst.OTHER_WORLD_TASK_ID
	arg0.hideTask = {}

	if pg.activity_template[arg0.activityId] then
		arg0.hideTask = pg.activity_template[arg0.activityId].config_client.hide_task or {}
	end

	arg0.btnGetAll = findTF(arg0.taskPage, "btnGetAll")
	arg0.taskTagPanel = findTF(arg0.taskPage, "taskTagPanel")
	arg0.taskListPanel = findTF(arg0.taskPage, "taskListPanel")
	arg0.scrollRect = findTF(arg0.taskPage, "taskListPanel/Content"):GetComponent("LScrollRect")

	function arg0.scrollRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateTaskItem(arg0, arg1)
	end

	arg0.btnAll = findTF(arg0.taskPage, "leftBtns/btnAll")
	arg0.btnDaily = findTF(arg0.taskPage, "leftBtns/btnDaily")
	arg0.btnMain = findTF(arg0.taskPage, "leftBtns/btnMain")

	onButton(arg0._event, arg0.btnAll, function()
		arg0:clearTagBtn()
		setActive(findTF(arg0.btnAll, "bg_selected"), true)
		setActive(findTF(arg0.btnAll, "text_selected"), true)
		setActive(findTF(arg0.btnAll, "text"), false)
		setImageColor(findTF(arg0.btnAll, "bg"), Color.New(1, 0.988235294117647, 0.909803921568627, 1))
		arg0:showTaskByType()
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnDaily, function()
		arg0:clearTagBtn()
		setActive(findTF(arg0.btnDaily, "bg_selected"), true)
		setActive(findTF(arg0.btnDaily, "text_selected"), true)
		setActive(findTF(arg0.btnDaily, "text"), false)
		setImageColor(findTF(arg0.btnDaily, "bg"), Color.New(1, 0.988235294117647, 0.909803921568627, 1))
		arg0:showTaskByType(var1)
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnMain, function()
		arg0:clearTagBtn()
		setActive(findTF(arg0.btnMain, "bg_selected"), true)
		setActive(findTF(arg0.btnMain, "text_selected"), true)
		setActive(findTF(arg0.btnMain, "text"), false)
		setImageColor(findTF(arg0.btnMain, "bg"), Color.New(1, 0.988235294117647, 0.909803921568627, 1))
		arg0:showTaskByType(var2)
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnGetAll, function()
		local var0 = arg0.getAllTasks

		arg0._event:emit(OtherWorldTaskMediator.SUBMIT_TASK_ALL, {
			activityId = arg0.activityId,
			ids = var0
		})
	end, SFX_CONFIRM)

	arg0.iconTfs = {}
	arg0.awards = {}

	arg0:updateTask()
	triggerButton(arg0.btnAll, true)
end

function var0.showTaskByType(arg0, arg1)
	arg0.tagType = arg1
	arg0.showTasks = {}

	if arg1 then
		for iter0, iter1 in ipairs(arg0.allDisplayTask) do
			if iter1:getConfig("priority_type") == arg1 then
				table.insert(arg0.showTasks, iter1)
			end
		end
	else
		arg0.showTasks = arg0.allDisplayTask
	end

	if arg0.enterTaskId and arg0.enterTaskId > 0 then
		for iter2 = 1, #arg0.showTasks do
			if arg0.showTasks[iter2].id == arg0.enterTaskId then
				arg0.scrollIndex = iter2
			end
		end
	end

	arg0.scrollRect:SetTotalCount(#arg0.showTasks, 0)

	if arg0.scrollIndex ~= nil then
		local var0 = arg0.scrollRect:HeadIndexToValue(arg0.scrollIndex - 1)

		arg0.scrollRect:ScrollTo(var0)
	end
end

function var0.clearTagBtn(arg0)
	setActive(findTF(arg0.btnAll, "bg_selected"), false)
	setActive(findTF(arg0.btnDaily, "bg_selected"), false)
	setActive(findTF(arg0.btnMain, "bg_selected"), false)
	setActive(findTF(arg0.btnMain, "text_selected"), false)
	setActive(findTF(arg0.btnDaily, "text_selected"), false)
	setActive(findTF(arg0.btnAll, "text_selected"), false)
	setActive(findTF(arg0.btnMain, "text"), true)
	setActive(findTF(arg0.btnDaily, "text"), true)
	setActive(findTF(arg0.btnAll, "text"), true)
	setImageColor(findTF(arg0.btnMain, "bg"), Color.New(0.737254901960784, 0.635294117647059, 0.588235294117647, 1))
	setImageColor(findTF(arg0.btnDaily, "bg"), Color.New(0.737254901960784, 0.635294117647059, 0.588235294117647, 1))
	setImageColor(findTF(arg0.btnAll, "bg"), Color.New(0.737254901960784, 0.635294117647059, 0.588235294117647, 1))
end

function var0.onUpdateTaskItem(arg0, arg1, arg2)
	if arg0.exitFlag then
		return
	end

	arg1 = arg1 + 1

	local var0 = arg0.showTasks[arg1]
	local var1 = var0.id
	local var2 = var0:getProgress()
	local var3 = var0:getConfig("desc")
	local var4 = var0:getConfig("ryza_icon")
	local var5 = var0:isOver()
	local var6 = var0:isFinish()
	local var7 = var0:getTarget()
	local var8 = var0:isCircle()
	local var9 = var0:isDaily()
	local var10 = var0:isSubmit()
	local var11 = var0:getConfig("sub_type")
	local var12 = var0:getConfig("type")
	local var13 = var0:getConfig("priority_type")

	setScrollText(findTF(arg2, "desc/text"), var3)

	if PLATFORM_CODE ~= PLATFORM_CH then
		-- block empty
	end

	if not var5 then
		setText(findTF(arg2, "progressDesc/text"), setColorStr(var2, "#51382E") .. " / " .. setColorStr(var7, "#51382E"))
	else
		setText(findTF(arg2, "progressDesc/text"), "--/--")
	end

	setSlider(findTF(arg2, "progressBar"), 0, 1, var5 and 1 or var2 / var7)

	local var14 = pg.task_data_template[var1].award_display
	local var15 = findTF(arg2, "awardDisplay/viewport/content")
	local var16 = var15.childCount

	if var16 < #var14 then
		local var17 = #var14 - var16

		for iter0 = 1, var17 do
			local var18 = tf(Instantiate(arg0.iconTpl))

			setParent(var18, var15)
			setActive(var18, true)
		end
	end

	for iter1 = 1, var15.childCount do
		local var19 = var15:GetChild(iter1 - 1)

		if iter1 <= #var14 then
			local var20 = var14[iter1]
			local var21 = {
				type = var20[1],
				id = var20[2],
				count = var20[3]
			}

			updateDrop(var19, var21)
			onButton(arg0._event, var19, function()
				arg0._event:emit(BaseUI.ON_DROP, var21)
			end, SFX_PANEL)
			setActive(var19, true)
		else
			setActive(var19, false)
		end
	end

	setActive(findTF(arg2, "btnGo"), not var5 and not var6 and var11 ~= 1006)
	setActive(findTF(arg2, "btnGet"), not var5 and var6 and not var10)
	setActive(findTF(arg2, "btnGot"), var6)
	setSlider(findTF(arg2, "progressBar"), 0, 1, var2 / var7)

	local var22

	if var13 == var1 then
		if var12 == 16 and var11 == 20 then
			var22 = var5
		else
			var22 = var3
		end
	else
		var22 = var4
	end

	setText(findTF(arg2, "tag/text"), i18n(var22))
	onButton(arg0._event, findTF(arg2, "btnGo"), function()
		arg0._event:emit(OtherWorldTaskMediator.TASK_GO, {
			taskVO = var0
		})
	end, SFX_CONFIRM)
	onButton(arg0._event, findTF(arg2, "btnGet"), function()
		local var0 = var0:getConfig("priority_type")
		local var1 = var0:getConfig("sub_type")

		arg0._event:emit(OtherWorldTaskMediator.SUBMIT_TASK, {
			activityId = arg0.activityId,
			id = var0.id
		})
	end, SFX_CONFIRM)

	if arg1 == 1 then
		arg0.scrollIndex = nil
	end

	if arg0.enterTaskId ~= nil and arg0.enterTaskId > 0 then
		if var1 == arg0.enterTaskId then
			arg0.enterTaskId = nil
			arg0.scrollIndex = nil
		end
	elseif arg0.enterTaskIds and #arg0.enterTaskIds > 0 then
		for iter2, iter3 in ipairs(arg0.enterTaskIds) do
			if var1 == iter3 then
				arg0.enterTaskIds = nil
				arg0.scrollIndex = nil
			end
		end
	end
end

function var0.updateTask(arg0, arg1)
	arg0.displayTask = {}
	arg0.allDisplayTask = {}

	local var0 = getProxy(ActivityTaskProxy):getTaskById(arg0.activityId)

	arg0.getAllTasks = {}

	for iter0 = 1, #var0 do
		local var1 = var0[iter0]
		local var2 = var1.id

		if not table.contains(arg0.hideTask, var2) then
			local var3 = var1:getProgress()
			local var4 = var1:getTarget()
			local var5 = var1:getConfig("priority_type")

			if not arg0.displayTask[var5] then
				arg0.displayTask[var5] = {}
			end

			table.insert(arg0.displayTask[var5], var1)
			table.insert(arg0.allDisplayTask, var1)

			if var1:isFinish() and not var1:isOver() then
				table.insert(arg0.getAllTasks, var2)
			end
		end
	end

	local var6 = getProxy(ActivityProxy):getActivityById(arg0.activityId)
	local var7 = {}

	if var6 then
		var7 = var6.data1_list
	end

	if var7 and #var7 > 0 then
		for iter1 = 1, #var7 do
			local var8 = var7[iter1]
			local var9 = ActivityTask.New(arg0.activityId, {
				progress = 0,
				id = var8
			})

			var9:setOver()

			local var10 = var9:getConfig("ryza_type")

			if var10 > 0 then
				if not arg0.displayTask[var10] then
					arg0.displayTask[var10] = {}
				end

				table.insert(arg0.displayTask[var10], var9)
				table.insert(arg0.allDisplayTask, var9)
			end
		end
	end

	local function var11(arg0, arg1)
		if arg0:isOver() and not arg1:isOver() then
			return false
		elseif not arg0:isOver() and arg1:isOver() then
			return true
		end

		if arg0:isFinish() and not arg1:isFinish() then
			return true
		elseif not arg0:isFinish() and arg1:isFinish() then
			return false
		end

		local var0 = arg0:getConfig("priority_type")
		local var1 = arg1:getConfig("priority_type")

		if var0 == var2 and var1 == var1 then
			return true
		elseif var0 == var1 and var1 == var2 then
			return false
		end

		if arg0:isNew() and not arg1:isNew() then
			return true
		elseif not arg0:isNew() and arg1:isNew() then
			return false
		end

		if arg0.id > arg1.id then
			return false
		elseif arg0.id < arg1.id then
			return true
		end
	end

	for iter2, iter3 in pairs(arg0.displayTask) do
		table.sort(iter3, var11)
	end

	table.sort(arg0.allDisplayTask, var11)

	if arg1 then
		arg0:showTaskByType(arg0.tagType)
	end

	if #arg0.getAllTasks > 0 then
		setActive(arg0.btnGetAll, true)
	else
		setActive(arg0.btnGetAll, false)
	end
end

function var0.setActive(arg0, arg1)
	setActive(arg0.taskPage, arg1)
end

function var0.dispose(arg0)
	arg0.exitFlag = true

	for iter0 = 1, #arg0.allDisplayTask do
		local var0 = arg0.allDisplayTask[iter0]

		if var0:isNew() then
			var0:changeNew()
		end
	end
end

return var0
