local var0_0 = class("LittleChaijunRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.helpBtn = arg0_1:findTF("help_btn", arg0_1.bg)

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.littleChaijun_npc.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetLevelProgress()
	local var3_3, var4_3, var5_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.step, setColorStr(var0_3, "ebced8") .. " / " .. var1_3)
	setText(arg0_3.progress, (var5_3 >= 1 and setColorStr(var3_3, COLOR_GREEN) or setColorStr(var3_3, "ebced8")) .. "/" .. var4_3)

	if arg0_3.firstSliderInit then
		if LeanTween.isTweening(go(arg0_3.slider)) then
			LeanTween.cancel(go(arg0_3.slider))
		end

		local var6_3 = GetComponent(arg0_3.slider, typeof(Slider)).value
		local var7_3 = arg0_3.l1 ~= var0_3 and 0 or arg0_3.sliderValue

		LeanTween.value(go(arg0_3.slider), var7_3, var5_3, 1):setOnUpdate(System.Action_float(function(arg0_4)
			setSlider(arg0_3.slider, 0, 1, arg0_4)

			arg0_3.sliderValue = arg0_4
		end))
	else
		setSlider(arg0_3.slider, 0, 1, var5_3)

		arg0_3.firstSliderInit = true
		arg0_3.sliderValue = var5_3
	end

	arg0_3.l1 = var0_3

	arg0_3:updataTask()
	arg0_3:sortTaskGroups()
	arg0_3:updateTaskUI()
end

function var0_0.updataTask(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.taskGroups) do
		for iter2_5, iter3_5 in ipairs(iter1_5.tasks) do
			local var0_5 = arg0_5.taskProxy:getFinishTaskById(iter3_5.id) and 1 or 0
			local var1_5 = arg0_5.taskProxy:getTaskById(iter3_5.id)
			local var2_5 = 0

			if var1_5 then
				var2_5 = var1_5:getProgress()
				iter1_5.progress = var2_5 == 0 and iter1_5.progress or var2_5
			else
				var2_5 = iter1_5.progress
			end

			iter3_5.progress = var2_5

			if iter3_5.finish ~= var0_5 and iter3_5.tf then
				setActive(iter3_5.tf, false)
				table.insert(arg0_5.taskTplPool, iter3_5.tf)

				iter3_5.tf = nil
			end

			iter3_5.finish = var0_5
		end
	end
end

function var0_0.OnFirstFlush(arg0_6)
	var0_0.super.OnFirstFlush(arg0_6)
	onButton(arg0_6, arg0_6.displayBtn, function()
		arg0_6:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			type = 5,
			dropList = arg0_6.ptData.dropList,
			targets = arg0_6.ptData.targets,
			level = arg0_6.ptData.level,
			count = arg0_6.ptData.count,
			resId = arg0_6.ptData.resId
		})
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.battleBtn, function()
		arg0_6:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
	arg0_6:initTask()
	arg0_6:sortTaskGroups()
	arg0_6:updateTaskUI()
	arg0_6:tryClaimTaskReward()
end

function var0_0.tryClaimTaskReward(arg0_9)
	local var0_9 = {}

	for iter0_9 = 1, #arg0_9.taskGroups do
		local var1_9 = arg0_9.taskGroups[iter0_9].tasks

		for iter1_9, iter2_9 in ipairs(var1_9) do
			local var2_9 = iter2_9.targetNum
			local var3_9 = iter2_9.progress
			local var4_9 = iter2_9.finish == 1

			if var2_9 <= var3_9 and not var4_9 then
				local var5_9 = arg0_9.taskProxy:getTaskById(iter2_9.id)

				if var5_9 then
					table.insert(var0_9, var5_9)
				end
			end
		end
	end

	if #var0_9 > 0 then
		arg0_9:emit(ActivityMediator.ON_TASK_SUBMIT_ONESTEP, var0_9)
	end
end

function var0_0.initTask(arg0_10)
	arg0_10.missionTpl = findTF(arg0_10.bg, "missionTpl")

	setActive(arg0_10.missionTpl, false)

	arg0_10.missionContainer = findTF(arg0_10.bg, "mission/content")

	local var0_10 = arg0_10.activity:getConfig("config_client").task_act_id
	local var1_10 = pg.activity_template[var0_10].config_data[1]

	arg0_10.taskProxy = getProxy(TaskProxy)
	arg0_10.taskTplPool = {}
	arg0_10.taskScroll = GetComponent(findTF(arg0_10.bg, "mission"), typeof(ScrollRect))
	arg0_10.taskGroups = {}

	for iter0_10 = 1, #var1_10 do
		local var2_10 = var1_10[iter0_10]
		local var3_10 = pg.task_data_template[var2_10]
		local var4_10 = var3_10.type
		local var5_10 = var3_10.sub_type

		if var4_10 == 26 then
			local var6_10 = arg0_10:getTaskGroup(var4_10, var5_10)

			arg0_10:insertTaskToGroup(var2_10, var3_10, var6_10)
		end
	end
end

function var0_0.updateTaskUI(arg0_11)
	local var0_11 = 0

	for iter0_11 = 1, #arg0_11.taskGroups do
		local var1_11 = arg0_11.taskGroups[iter0_11]
		local var2_11 = var1_11.tasks

		for iter1_11, iter2_11 in ipairs(var2_11) do
			arg0_11:updateTaskList(iter1_11, var0_11, iter2_11, var1_11)

			var0_11 = var0_11 + 1
		end
	end

	local var3_11 = 0
	local var4_11 = 0

	if arg0_11.scrollToGroup then
		for iter3_11, iter4_11 in ipairs(arg0_11.taskGroups) do
			if iter4_11 == arg0_11.scrollToGroup then
				var4_11 = var3_11
			end

			if iter4_11.opening then
				var3_11 = var3_11 + #iter4_11.tasks
			else
				var3_11 = var3_11 + 1
			end
		end

		arg0_11.scrollToGroup = nil
	end

	if var4_11 ~= 0 and var3_11 ~= 0 then
		scrollTo(arg0_11.taskScroll, 0, 1 - var4_11 / var3_11)
	else
		scrollTo(arg0_11.taskScroll, 0, 1)
	end
end

function var0_0.updateTaskList(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	if not arg3_12.show then
		return
	end

	local var0_12 = arg3_12.targetNum
	local var1_12 = arg3_12.progress
	local var2_12 = arg3_12.finish == 1
	local var3_12 = arg1_12 == 1
	local var4_12 = arg3_12.desc
	local var5_12 = arg3_12.drop
	local var6_12 = arg4_12.opening
	local var7_12 = #arg4_12.tasks == 1

	if not arg3_12.tf then
		arg3_12.tf = arg0_12:getTaskTfFromPool()
	end

	local var8_12 = findTF(arg3_12.tf, "AD")

	arg3_12.tf.sizeDelta = Vector2(778, var3_12 and 120 or 110)

	setActive(findTF(var8_12, "bg1"), var3_12)
	setActive(findTF(var8_12, "bg2"), not var3_12)

	if var3_12 then
		setActive(findTF(var8_12, "mask1"), var2_12)
	else
		setActive(findTF(var8_12, "mask2"), var2_12)
	end

	if var2_12 then
		setActive(findTF(var8_12, "pahase"), false)
		setSlider(findTF(var8_12, "slider"), 0, 1, 1)
	else
		setActive(findTF(var8_12, "pahase"), true)
		setSlider(findTF(var8_12, "slider"), 0, 1, var1_12 / var0_12)
	end

	setText(findTF(var8_12, "desc"), var4_12)

	if arg4_12.subType ~= 33 then
		setText(findTF(var8_12, "pahase"), setColorStr(var1_12, "#b35845") .. "/" .. var0_12)
	else
		setText(findTF(var8_12, "pahase"), "")
	end

	updateDrop(findTF(var8_12, "award"), var5_12)
	onButton(arg0_12, findTF(var8_12, "award"), function()
		arg0_12:emit(BaseUI.ON_DROP, var5_12)
	end, SFX_PANEL)
	setActive(findTF(var8_12, "got"), false)
	setActive(findTF(var8_12, "get"), false)
	setActive(findTF(var8_12, "go"), false)

	if not var3_12 then
		setActive(findTF(var8_12, "go"), not var2_12)
		setActive(findTF(var8_12, "got"), var2_12)
	elseif var2_12 then
		setActive(findTF(var8_12, "got"), true)
	elseif var0_12 <= var1_12 then
		setActive(findTF(var8_12, "get"), true)
		onButton(arg0_12, findTF(var8_12, "get"), function()
			local var0_14 = arg0_12.taskProxy:getTaskById(arg3_12.id)

			if var0_14 then
				arg0_12:emit(ActivityMediator.ON_TASK_SUBMIT, var0_14)
			end
		end, SFX_CONFIRM)
	else
		setActive(findTF(var8_12, "go"), true)
		onButton(arg0_12, findTF(var8_12, "go"), function()
			local var0_15 = arg0_12.taskProxy:getTaskById(arg3_12.id)

			if var0_15 then
				arg0_12:emit(ActivityMediator.ON_TASK_GO, var0_15)
			end
		end, SFX_CONFIRM)
	end

	if var7_12 or not var3_12 or var2_12 and var3_12 then
		setActive(findTF(var8_12, "show"), false)
	else
		setActive(findTF(var8_12, "show"), true)
		setActive(findTF(var8_12, "show/on"), var6_12)
		setActive(findTF(var8_12, "show/off"), not var6_12)
	end

	if var3_12 then
		onButton(arg0_12, findTF(var8_12, "show"), function()
			arg0_12:changeGroupOpening(arg4_12)
		end, SFX_CONFIRM)
	end

	setActive(arg3_12.tf, true)
	arg3_12.tf:SetSiblingIndex(arg2_12)
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
