local var0_0 = class("LittleChaijunPage", import(".TemplatePage.PtTemplatePage"))

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

			if iter3_5.finish ~= var0_5 then
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
end

function var0_0.initTask(arg0_9)
	arg0_9.missionTpl = findTF(arg0_9.bg, "missionTpl")

	setActive(arg0_9.missionTpl, false)

	arg0_9.missionContainer = findTF(arg0_9.bg, "mission/content")

	local var0_9 = arg0_9.activity:getConfig("config_client").task_act_id
	local var1_9 = pg.activity_template[var0_9].config_data

	arg0_9.taskProxy = getProxy(TaskProxy)
	arg0_9.taskTplPool = {}
	arg0_9.taskScroll = GetComponent(findTF(arg0_9.bg, "mission"), typeof(ScrollRect))
	arg0_9.taskGroups = {}

	for iter0_9 = 1, #var1_9 do
		local var2_9 = var1_9[iter0_9]
		local var3_9 = pg.task_data_template[var2_9]
		local var4_9 = var3_9.type
		local var5_9 = var3_9.sub_type

		if var4_9 == 26 then
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
		setText(findTF(var8_11, "pahase"), setColorStr(var1_11, "#b35845") .. "/" .. var0_11)
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
	else
		setActive(findTF(var8_11, "go"), true)
		onButton(arg0_11, findTF(var8_11, "go"), function()
			local var0_14 = arg0_11.taskProxy:getTaskById(arg3_11.id)

			if var0_14 then
				arg0_11:emit(ActivityMediator.ON_TASK_GO, var0_14)
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

function var0_0.changeGroupOpening(arg0_16, arg1_16)
	arg1_16.opening = not arg1_16.opening

	for iter0_16 = 1, #arg1_16.tasks do
		local var0_16 = arg1_16.tasks[iter0_16]

		if iter0_16 == 1 then
			var0_16.show = true
		else
			var0_16.show = arg1_16.opening
		end

		if not var0_16.show and var0_16.tf then
			setActive(var0_16.tf, false)
			table.insert(arg0_16.taskTplPool, var0_16.tf)

			var0_16.tf = nil
		end
	end

	arg0_16.scrollToGroup = arg1_16

	arg0_16:updateTaskUI()
end

function var0_0.getTaskTfFromPool(arg0_17)
	if #arg0_17.taskTplPool > 0 then
		return table.remove(arg0_17.taskTplPool, 1)
	end

	local var0_17 = tf(Instantiate(arg0_17.missionTpl))

	SetParent(var0_17, arg0_17.missionContainer)

	return var0_17
end

function var0_0.getTaskGroup(arg0_18, arg1_18, arg2_18)
	for iter0_18 = 1, #arg0_18.taskGroups do
		local var0_18 = arg0_18.taskGroups[iter0_18]

		if var0_18.type == arg1_18 and var0_18.subType == arg2_18 then
			return var0_18
		end
	end

	local var1_18 = {
		opening = false,
		progress = 0,
		type = arg1_18,
		subType = arg2_18,
		tasks = {}
	}

	table.insert(arg0_18.taskGroups, var1_18)

	return var1_18
end

function var0_0.insertTaskToGroup(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg3_19.tasks

	for iter0_19 = 1, #var0_19 do
		if var0_19[iter0_19].id == arg1_19 then
			return
		end
	end

	local var1_19 = arg2_19.target_num
	local var2_19 = arg2_19.desc
	local var3_19 = {
		type = arg2_19.award_display[1][1],
		id = arg2_19.award_display[1][2],
		count = arg2_19.award_display[1][3]
	}
	local var4_19 = false

	if #arg3_19.tasks == 0 then
		var4_19 = true
	end

	local var5_19 = arg0_19.taskProxy:getFinishTaskById(arg1_19) and 1 or 0
	local var6_19 = arg0_19.taskProxy:getTaskById(arg1_19)
	local var7_19 = 0

	if var6_19 then
		var7_19 = var6_19:getProgress()
		arg3_19.progress = var7_19 == 0 and arg3_19.progress or var7_19
	else
		var7_19 = arg3_19.progress
	end

	table.insert(arg3_19.tasks, {
		id = arg1_19,
		targetNum = var1_19,
		show = var4_19,
		finish = var5_19,
		progress = var7_19,
		desc = var2_19,
		drop = var3_19
	})
end

function var0_0.sortTaskGroups(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20.taskGroups) do
		table.sort(iter1_20.tasks, function(arg0_21, arg1_21)
			if arg0_21.finish ~= arg1_21.finish then
				return arg0_21.finish < arg1_21.finish
			end

			return arg0_21.targetNum < arg1_21.targetNum
		end)
	end

	table.sort(arg0_20.taskGroups, function(arg0_22, arg1_22)
		local var0_22 = arg0_22.tasks
		local var1_22 = arg1_22.tasks
		local var2_22 = 0
		local var3_22 = arg0_22.tasks[1].id
		local var4_22 = 0
		local var5_22 = 0
		local var6_22 = 0
		local var7_22 = arg1_22.tasks[1].id
		local var8_22 = 0
		local var9_22 = 0

		for iter0_22, iter1_22 in ipairs(var0_22) do
			if var2_22 == 0 and iter1_22.finish == 0 and iter1_22.progress >= iter1_22.targetNum then
				var2_22 = 1
				var3_22 = iter1_22.id
			end

			var4_22 = iter1_22.finish == 1 and var4_22 + 1 or var4_22
		end

		local var10_22 = var4_22 == #var0_22 and 1 or 0

		for iter2_22, iter3_22 in ipairs(var1_22) do
			if var6_22 == 0 and iter3_22.finish == 0 and iter3_22.progress >= iter3_22.targetNum then
				var6_22 = 1
				var7_22 = iter3_22.id
			end

			var8_22 = iter3_22.finish == 1 and var8_22 + 1 or var8_22
		end

		local var11_22 = var8_22 == #var1_22 and 1 or 0

		if var2_22 ~= var6_22 then
			return var6_22 < var2_22
		elseif var10_22 ~= var11_22 then
			return var10_22 < var11_22
		else
			return var3_22 < var7_22
		end
	end)

	for iter2_20, iter3_20 in ipairs(arg0_20.taskGroups) do
		local var0_20 = iter3_20.opening
		local var1_20 = iter3_20.tasks

		for iter4_20 = 1, #var1_20 do
			local var2_20 = var1_20[iter4_20]

			if iter4_20 == 1 then
				var2_20.show = true
			elseif var0_20 then
				var2_20.show = true
			else
				var2_20.show = false
			end
		end
	end
end

function var0_0.OnDestroy(arg0_23)
	if LeanTween.isTweening(go(arg0_23.slider)) then
		LeanTween.cancel(go(arg0_23.slider))
	end
end

return var0_0
