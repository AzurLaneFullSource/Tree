local var0_0 = class("LittleOuGenRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.heartTpl = arg0_1:findTF("HeartTpl", arg0_1.bg)
	arg0_1.heartContainer = arg0_1:findTF("HeartContainer", arg0_1.bg)
	arg0_1.heartUIItemList = UIItemList.New(arg0_1.heartContainer, arg0_1.heartTpl)

	arg0_1.heartUIItemList:make(function(arg0_2, arg1_2, arg2_2)
		if arg0_2 == UIItemList.EventUpdate then
			local var0_2 = arg1_2 + 1
			local var1_2 = arg0_1.ptData:GetLevelProgress()
			local var2_2 = arg0_1:findTF("Full", arg2_2)

			setActive(var2_2, not (var1_2 < var0_2))
		end
	end)

	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.littleEugen_npc.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)

	local var0_4, var1_4 = arg0_4.ptData:GetLevelProgress()

	arg0_4.heartUIItemList:align(var1_4)

	local var2_4, var3_4, var4_4 = arg0_4.ptData:GetLevelProgress()
	local var5_4, var6_4, var7_4 = arg0_4.ptData:GetResProgress()

	setText(arg0_4.step, setColorStr(var2_4, "#f8e6e2") .. " / " .. setColorStr(var3_4, "#4e2c2b"))
	setText(arg0_4.progress, (var7_4 >= 1 and setColorStr(var5_4, COLOR_GREEN) or setColorStr(var5_4, "COLOR_GREEN")) .. "/" .. setColorStr(var6_4, "#4e2c2b"))

	if arg0_4.firstSliderInit then
		if LeanTween.isTweening(go(arg0_4.slider)) then
			LeanTween.cancel(go(arg0_4.slider))
		end

		local var8_4 = GetComponent(arg0_4.slider, typeof(Slider)).value
		local var9_4 = arg0_4.l1 ~= var2_4 and 0 or arg0_4.sliderValue

		LeanTween.value(go(arg0_4.slider), var9_4, var7_4, 1):setOnUpdate(System.Action_float(function(arg0_5)
			setSlider(arg0_4.slider, 0, 1, arg0_5)

			arg0_4.sliderValue = arg0_5
		end))
	else
		setSlider(arg0_4.slider, 0, 1, var7_4)

		arg0_4.firstSliderInit = true
		arg0_4.sliderValue = var7_4
	end

	arg0_4.l1 = var2_4

	arg0_4:updataTask()
	arg0_4:sortTaskGroups()
	arg0_4:updateTaskUI()
end

function var0_0.updataTask(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.taskGroups) do
		for iter2_6, iter3_6 in ipairs(iter1_6.tasks) do
			local var0_6 = arg0_6.taskProxy:getFinishTaskById(iter3_6.id) and 1 or 0
			local var1_6 = arg0_6.taskProxy:getTaskById(iter3_6.id)
			local var2_6 = 0

			if var1_6 then
				var2_6 = var1_6:getProgress()
				iter1_6.progress = var2_6 == 0 and iter1_6.progress or var2_6
			else
				var2_6 = iter1_6.progress
			end

			iter3_6.progress = var2_6

			if iter3_6.finish ~= var0_6 then
				setActive(iter3_6.tf, false)
				table.insert(arg0_6.taskTplPool, iter3_6.tf)

				iter3_6.tf = nil
			end

			iter3_6.finish = var0_6
		end
	end
end

function var0_0.OnFirstFlush(arg0_7)
	var0_0.super.OnFirstFlush(arg0_7)
	onButton(arg0_7, arg0_7.battleBtn, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
	arg0_7:initTask()
	arg0_7:sortTaskGroups()
	arg0_7:updateTaskUI()
end

function var0_0.initTask(arg0_9)
	arg0_9.missionTpl = findTF(arg0_9.bg, "missionTpl")

	setActive(arg0_9.missionTpl, false)

	arg0_9.missionContainer = findTF(arg0_9.bg, "mission/content")

	local var0_9 = arg0_9.activity:getConfig("config_client").task_act_id
	local var1_9 = pg.activity_template[var0_9].config_data[1]

	arg0_9.taskProxy = getProxy(TaskProxy)
	arg0_9.taskTplPool = {}
	arg0_9.taskScroll = GetComponent(findTF(arg0_9.bg, "mission"), typeof(ScrollRect))
	arg0_9.taskGroups = {}

	for iter0_9 = 1, #var1_9 do
		local var2_9 = var1_9[iter0_9]
		local var3_9 = pg.task_data_template[var2_9]

		if not var3_9 then
			print("task_data_template 不存在任务id : " .. tostring(var2_9))
		end

		local var4_9 = var3_9.type
		local var5_9 = var3_9.sub_type

		if var4_9 == Task.TYPE_ACTIVITY or var4_9 == Task.TYPE_ACTIVITY_BRANCH then
			local var6_9 = arg0_9:getTaskGroup(var4_9, var5_9)

			arg0_9:insertTaskToGroup(var2_9, var3_9, var6_9)
		end
	end
end

function var0_0.updateTaskUI(arg0_10)
	local var0_10 = 0

	for iter0_10 = 1, #arg0_10.taskGroups do
		local var1_10 = arg0_10.taskGroups[iter0_10]
		local var2_10 = var1_10.tasks

		for iter1_10, iter2_10 in ipairs(var2_10) do
			arg0_10:updateTaskList(iter1_10, var0_10, iter2_10, var1_10)

			var0_10 = var0_10 + 1
		end
	end

	local var3_10 = 0
	local var4_10 = 0

	if arg0_10.scrollToGroup then
		for iter3_10, iter4_10 in ipairs(arg0_10.taskGroups) do
			if iter4_10 == arg0_10.scrollToGroup then
				var4_10 = var3_10
			end

			if iter4_10.opening then
				var3_10 = var3_10 + #iter4_10.tasks
			else
				var3_10 = var3_10 + 1
			end
		end

		arg0_10.scrollToGroup = nil
	end

	if var4_10 ~= 0 and var3_10 ~= 0 then
		scrollTo(arg0_10.taskScroll, 0, 1 - var4_10 / var3_10)
	else
		scrollTo(arg0_10.taskScroll, 0, 1)
	end
end

function var0_0.updateTaskList(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	if not arg3_11.show then
		return
	end

	local var0_11 = arg3_11.targetNum
	local var1_11 = arg3_11.progress
	local var2_11 = arg3_11.finish == 1
	local var3_11 = arg1_11 == 1
	local var4_11 = arg3_11.desc
	local var5_11 = arg3_11.drop
	local var6_11 = arg4_11.opening
	local var7_11 = #arg4_11.tasks == 1

	if not arg3_11.tf then
		arg3_11.tf = arg0_11:getTaskTfFromPool()
	end

	local var8_11 = findTF(arg3_11.tf, "AD")

	arg3_11.tf.sizeDelta = Vector2(778, var3_11 and 120 or 110)

	setActive(findTF(var8_11, "bg1"), var3_11)
	setActive(findTF(var8_11, "bg2"), not var3_11)

	if var3_11 then
		setActive(findTF(var8_11, "mask1"), var2_11)
	else
		setActive(findTF(var8_11, "mask2"), var2_11)
	end

	if var2_11 then
		setActive(findTF(var8_11, "pahase"), false)
		setSlider(findTF(var8_11, "slider"), 0, 1, 1)
	else
		setActive(findTF(var8_11, "pahase"), true)
		setSlider(findTF(var8_11, "slider"), 0, 1, var1_11 / var0_11)
	end

	setText(findTF(var8_11, "desc"), var4_11)

	if arg4_11.subType ~= 33 then
		setText(findTF(var8_11, "pahase"), setColorStr(var1_11, "#95b345") .. "/" .. setColorStr(var0_11, "#e9c9bd"))
	else
		setText(findTF(var8_11, "pahase"), "")
	end

	updateDrop(findTF(var8_11, "award"), var5_11)
	onButton(arg0_11, findTF(var8_11, "award"), function()
		arg0_11:emit(BaseUI.ON_DROP, var5_11)
	end, SFX_PANEL)
	setActive(findTF(var8_11, "got"), false)
	setActive(findTF(var8_11, "get"), false)
	setActive(findTF(var8_11, "go"), false)

	if not var3_11 then
		setActive(findTF(var8_11, "go"), not var2_11)
		setActive(findTF(var8_11, "got"), var2_11)
	elseif var2_11 then
		setActive(findTF(var8_11, "got"), true)
	elseif var0_11 <= var1_11 then
		setActive(findTF(var8_11, "get"), true)
		onButton(arg0_11, findTF(var8_11, "get"), function()
			local var0_13 = arg0_11.taskProxy:getTaskById(arg3_11.id)

			if var0_13 then
				arg0_11:emit(ActivityMediator.ON_TASK_SUBMIT, var0_13)
			end
		end, SFX_CONFIRM)

		if not arg0_11.nextTickFlag then
			onNextTick(function()
				triggerButton(findTF(var8_11, "get"))

				arg0_11.nextTickFlag = false
			end)

			arg0_11.nextTickFlag = true
		end
	else
		setActive(findTF(var8_11, "go"), true)
		onButton(arg0_11, findTF(var8_11, "go"), function()
			local var0_15 = arg0_11.taskProxy:getTaskById(arg3_11.id)

			if var0_15 then
				arg0_11:emit(ActivityMediator.ON_TASK_GO, var0_15)
			end
		end, SFX_CONFIRM)
	end

	if var7_11 or not var3_11 or var2_11 and var3_11 then
		setActive(findTF(var8_11, "show"), false)
	else
		setActive(findTF(var8_11, "show"), true)
		setActive(findTF(var8_11, "show/on"), var6_11)
		setActive(findTF(var8_11, "show/off"), not var6_11)
	end

	if var3_11 then
		onButton(arg0_11, findTF(var8_11, "show"), function()
			arg0_11:changeGroupOpening(arg4_11)
		end, SFX_CONFIRM)
	end

	setActive(arg3_11.tf, true)
	arg3_11.tf:SetSiblingIndex(arg2_11)
end

function var0_0.changeGroupOpening(arg0_17, arg1_17)
	arg1_17.opening = not arg1_17.opening

	for iter0_17 = 1, #arg1_17.tasks do
		local var0_17 = arg1_17.tasks[iter0_17]

		if iter0_17 == 1 then
			var0_17.show = true
		else
			var0_17.show = arg1_17.opening
		end

		if not var0_17.show and var0_17.tf then
			setActive(var0_17.tf, false)
			table.insert(arg0_17.taskTplPool, var0_17.tf)

			var0_17.tf = nil
		end
	end

	arg0_17.scrollToGroup = arg1_17

	arg0_17:updateTaskUI()
end

function var0_0.getTaskTfFromPool(arg0_18)
	if #arg0_18.taskTplPool > 0 then
		return table.remove(arg0_18.taskTplPool, 1)
	end

	local var0_18 = tf(Instantiate(arg0_18.missionTpl))

	SetParent(var0_18, arg0_18.missionContainer)

	return var0_18
end

function var0_0.getTaskGroup(arg0_19, arg1_19, arg2_19)
	for iter0_19 = 1, #arg0_19.taskGroups do
		local var0_19 = arg0_19.taskGroups[iter0_19]

		if var0_19.type == arg1_19 and var0_19.subType == arg2_19 then
			return var0_19
		end
	end

	local var1_19 = {
		opening = false,
		progress = 0,
		type = arg1_19,
		subType = arg2_19,
		tasks = {}
	}

	table.insert(arg0_19.taskGroups, var1_19)

	return var1_19
end

function var0_0.insertTaskToGroup(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg3_20.tasks

	for iter0_20 = 1, #var0_20 do
		if var0_20[iter0_20].id == arg1_20 then
			return
		end
	end

	local var1_20 = arg2_20.target_num
	local var2_20 = arg2_20.desc
	local var3_20 = {
		type = arg2_20.award_display[1][1],
		id = arg2_20.award_display[1][2],
		count = arg2_20.award_display[1][3]
	}
	local var4_20 = false

	if #arg3_20.tasks == 0 then
		var4_20 = true
	end

	local var5_20 = arg0_20.taskProxy:getFinishTaskById(arg1_20) and 1 or 0
	local var6_20 = arg0_20.taskProxy:getTaskById(arg1_20)
	local var7_20 = 0

	if var6_20 then
		var7_20 = var6_20:getProgress()
		arg3_20.progress = var7_20 == 0 and arg3_20.progress or var7_20
	else
		var7_20 = arg3_20.progress
	end

	table.insert(arg3_20.tasks, {
		id = arg1_20,
		targetNum = var1_20,
		show = var4_20,
		finish = var5_20,
		progress = var7_20,
		desc = var2_20,
		drop = var3_20
	})
end

function var0_0.sortTaskGroups(arg0_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.taskGroups) do
		table.sort(iter1_21.tasks, function(arg0_22, arg1_22)
			if arg0_22.finish ~= arg1_22.finish then
				return arg0_22.finish < arg1_22.finish
			end

			return arg0_22.targetNum < arg1_22.targetNum
		end)
	end

	table.sort(arg0_21.taskGroups, function(arg0_23, arg1_23)
		local var0_23 = arg0_23.tasks
		local var1_23 = arg1_23.tasks
		local var2_23 = 0
		local var3_23 = arg0_23.tasks[1].id
		local var4_23 = 0
		local var5_23 = 0
		local var6_23 = 0
		local var7_23 = arg1_23.tasks[1].id
		local var8_23 = 0
		local var9_23 = 0

		for iter0_23, iter1_23 in ipairs(var0_23) do
			if var2_23 == 0 and iter1_23.finish == 0 and iter1_23.progress >= iter1_23.targetNum then
				var2_23 = 1
				var3_23 = iter1_23.id
			end

			var4_23 = iter1_23.finish == 1 and var4_23 + 1 or var4_23
		end

		local var10_23 = var4_23 == #var0_23 and 1 or 0

		for iter2_23, iter3_23 in ipairs(var1_23) do
			if var6_23 == 0 and iter3_23.finish == 0 and iter3_23.progress >= iter3_23.targetNum then
				var6_23 = 1
				var7_23 = iter3_23.id
			end

			var8_23 = iter3_23.finish == 1 and var8_23 + 1 or var8_23
		end

		local var11_23 = var8_23 == #var1_23 and 1 or 0

		if var2_23 ~= var6_23 then
			return var6_23 < var2_23
		elseif var10_23 ~= var11_23 then
			return var10_23 < var11_23
		else
			return var3_23 < var7_23
		end
	end)

	for iter2_21, iter3_21 in ipairs(arg0_21.taskGroups) do
		local var0_21 = iter3_21.opening
		local var1_21 = iter3_21.tasks

		for iter4_21 = 1, #var1_21 do
			local var2_21 = var1_21[iter4_21]

			if iter4_21 == 1 then
				var2_21.show = true
			elseif var0_21 then
				var2_21.show = true
			else
				var2_21.show = false
			end
		end
	end
end

function var0_0.OnDestroy(arg0_24)
	if LeanTween.isTweening(go(arg0_24.slider)) then
		LeanTween.cancel(go(arg0_24.slider))
	end
end

return var0_0
