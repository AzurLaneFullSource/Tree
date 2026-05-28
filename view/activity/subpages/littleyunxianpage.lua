local var0_0 = class("LittleYunXianPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.adPhase1 = arg0_1.bg:Find("PHASE1")
	arg0_1.adPhase2 = arg0_1.bg:Find("PHASE2")
	arg0_1.helpBtn = arg0_1.bg:Find("help_btn")

	onButton(arg0_1, arg0_1.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = arg0_1:GetHelpTip()
		})
	end, SFX_PANEL)
end

function var0_0.GetHelpTip(arg0_3)
	return pg.gametip.littleyunxian_npc.tip
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)
	setText(arg0_4.adPhase1, i18n("littleyunxian_tip1"))
	setText(arg0_4.adPhase2, i18n("littleyunxian_tip2"))
	setActive(arg0_4.battleBtn, false)

	local var0_4, var1_4, var2_4 = arg0_4.ptData:GetLevelProgress()
	local var3_4, var4_4, var5_4 = arg0_4.ptData:GetResProgress()

	setText(arg0_4.step, setColorStr(var0_4, "#b9aef8") .. " / " .. setColorStr(var1_4, "#666176"))
	setText(arg0_4.progress, (var5_4 >= 1 and setColorStr(var3_4, COLOR_GREEN) or setColorStr(var3_4, "#b9aef8")) .. "/" .. setColorStr(var4_4, "#666176"))

	if arg0_4.firstSliderInit then
		if LeanTween.isTweening(go(arg0_4.slider)) then
			LeanTween.cancel(go(arg0_4.slider))
		end

		local var6_4 = GetComponent(arg0_4.slider, typeof(Slider)).value
		local var7_4 = arg0_4.l1 ~= var0_4 and 0 or arg0_4.sliderValue

		LeanTween.value(go(arg0_4.slider), var7_4, var5_4, 1):setOnUpdate(System.Action_float(function(arg0_5)
			setSlider(arg0_4.slider, 0, 1, arg0_5)

			arg0_4.sliderValue = arg0_5
		end))
	else
		setSlider(arg0_4.slider, 0, 1, var5_4)

		arg0_4.firstSliderInit = true
		arg0_4.sliderValue = var5_4
	end

	arg0_4.l1 = var0_4

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
	onButton(arg0_7, arg0_7.displayBtn, function()
		arg0_7:emit(ActivityMediator.SHOW_AWARD_WINDOW, PtAwardWindow, {
			blur = true,
			type = 5,
			dropList = arg0_7.ptData.dropList,
			targets = arg0_7.ptData.targets,
			level = arg0_7.ptData.level,
			count = arg0_7.ptData.count,
			resId = arg0_7.ptData.resId,
			resIcon = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = arg0_7.ptData.resId
			}):getIcon()
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.battleBtn, function()
		arg0_7:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
	arg0_7:initTask()
	arg0_7:sortTaskGroups()
	arg0_7:updateTaskUI()
end

function var0_0.initTask(arg0_10)
	arg0_10.missionTpl = findTF(arg0_10.bg, "missionTpl")

	setActive(arg0_10.missionTpl, false)

	arg0_10.missionContainer = findTF(arg0_10.bg, "mission/content")

	local var0_10 = arg0_10.activity:getConfig("config_client").task_act_id
	local var1_10 = pg.activity_template[var0_10].config_data

	arg0_10.taskProxy = getProxy(TaskProxy)
	arg0_10.taskTplPool = {}
	arg0_10.taskScroll = GetComponent(findTF(arg0_10.bg, "mission"), typeof(ScrollRect))
	arg0_10.taskGroups = {}

	for iter0_10 = 1, #var1_10 do
		local var2_10 = var1_10[iter0_10]
		local var3_10 = pg.task_data_template[var2_10]
		local var4_10 = var3_10.type
		local var5_10 = var3_10.sub_type

		if var4_10 == Task.TYPE_ACTIVITY or var4_10 == Task.TYPE_ACTIVITY_BRANCH then
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

	if var2_12 then
		setActive(findTF(var8_12, "pahase"), false)
		setSlider(findTF(var8_12, "slider"), 0, 1, 1)
	else
		setActive(findTF(var8_12, "pahase"), true)
		setSlider(findTF(var8_12, "slider"), 0, 1, var1_12 / var0_12)
	end

	setText(findTF(var8_12, "desc"), var4_12)

	if arg4_12.subType ~= 33 then
		setText(findTF(var8_12, "pahase"), setColorStr(var1_12, "#b1a2d3") .. "/" .. setColorStr(var0_12, "#b1a2d3"))
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
		onButton(arg0_12, findTF(var8_12, "go"), function()
			local var0_14 = arg0_12.taskProxy:getTaskById(arg3_12.id) or Task.New({
				id = arg3_12.id
			})

			if var0_14 then
				arg0_12:emit(ActivityMediator.ON_TASK_GO, var0_14)
			end
		end, SFX_CONFIRM)
		setActive(findTF(var8_12, "got"), var2_12)
	elseif var2_12 then
		setActive(findTF(var8_12, "got"), true)
	elseif var0_12 <= var1_12 then
		setActive(findTF(var8_12, "get"), true)
		onButton(arg0_12, findTF(var8_12, "get"), function()
			local var0_15 = arg0_12.taskProxy:getTaskById(arg3_12.id)

			if var0_15 then
				arg0_12:emit(ActivityMediator.ON_TASK_SUBMIT, var0_15)
			end
		end, SFX_CONFIRM)
	else
		setActive(findTF(var8_12, "go"), true)
		onButton(arg0_12, findTF(var8_12, "go"), function()
			local var0_16 = arg0_12.taskProxy:getTaskById(arg3_12.id) or Task.New({
				id = arg3_12.id
			})

			if var0_16 then
				arg0_12:emit(ActivityMediator.ON_TASK_GO, var0_16)
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

function var0_0.changeGroupOpening(arg0_18, arg1_18)
	arg1_18.opening = not arg1_18.opening

	for iter0_18 = 1, #arg1_18.tasks do
		local var0_18 = arg1_18.tasks[iter0_18]

		if iter0_18 == 1 then
			var0_18.show = true
		else
			var0_18.show = arg1_18.opening
		end

		if not var0_18.show and var0_18.tf then
			setActive(var0_18.tf, false)
			table.insert(arg0_18.taskTplPool, var0_18.tf)

			var0_18.tf = nil
		end
	end

	arg0_18.scrollToGroup = arg1_18

	arg0_18:updateTaskUI()
end

function var0_0.getTaskTfFromPool(arg0_19)
	if #arg0_19.taskTplPool > 0 then
		return table.remove(arg0_19.taskTplPool, 1)
	end

	local var0_19 = tf(Instantiate(arg0_19.missionTpl))

	SetParent(var0_19, arg0_19.missionContainer)

	return var0_19
end

function var0_0.getTaskGroup(arg0_20, arg1_20, arg2_20)
	for iter0_20 = 1, #arg0_20.taskGroups do
		local var0_20 = arg0_20.taskGroups[iter0_20]

		if var0_20.type == arg1_20 and var0_20.subType == arg2_20 then
			return var0_20
		end
	end

	local var1_20 = {
		opening = false,
		progress = 0,
		type = arg1_20,
		subType = arg2_20,
		tasks = {}
	}

	table.insert(arg0_20.taskGroups, var1_20)

	return var1_20
end

function var0_0.insertTaskToGroup(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg3_21.tasks

	for iter0_21 = 1, #var0_21 do
		if var0_21[iter0_21].id == arg1_21 then
			return
		end
	end

	local var1_21 = arg2_21.target_num
	local var2_21 = arg2_21.desc
	local var3_21 = {
		type = arg2_21.award_display[1][1],
		id = arg2_21.award_display[1][2],
		count = arg2_21.award_display[1][3]
	}
	local var4_21 = false

	if #arg3_21.tasks == 0 then
		var4_21 = true
	end

	local var5_21 = arg0_21.taskProxy:getFinishTaskById(arg1_21) and 1 or 0
	local var6_21 = arg0_21.taskProxy:getTaskById(arg1_21)
	local var7_21 = 0

	if var6_21 then
		var7_21 = var6_21:getProgress()
		arg3_21.progress = var7_21 == 0 and arg3_21.progress or var7_21
	else
		var7_21 = arg3_21.progress
	end

	table.insert(arg3_21.tasks, {
		id = arg1_21,
		targetNum = var1_21,
		show = var4_21,
		finish = var5_21,
		progress = var7_21,
		desc = var2_21,
		drop = var3_21
	})
end

function var0_0.sortTaskGroups(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.taskGroups) do
		table.sort(iter1_22.tasks, function(arg0_23, arg1_23)
			if arg0_23.finish ~= arg1_23.finish then
				return arg0_23.finish < arg1_23.finish
			end

			return arg0_23.targetNum < arg1_23.targetNum
		end)
	end

	table.sort(arg0_22.taskGroups, function(arg0_24, arg1_24)
		local var0_24 = arg0_24.tasks
		local var1_24 = arg1_24.tasks
		local var2_24 = 0
		local var3_24 = arg0_24.tasks[1].id
		local var4_24 = 0
		local var5_24 = 0
		local var6_24 = 0
		local var7_24 = arg1_24.tasks[1].id
		local var8_24 = 0
		local var9_24 = 0

		for iter0_24, iter1_24 in ipairs(var0_24) do
			if var2_24 == 0 and iter1_24.finish == 0 and iter1_24.progress >= iter1_24.targetNum then
				var2_24 = 1
				var3_24 = iter1_24.id
			end

			var4_24 = iter1_24.finish == 1 and var4_24 + 1 or var4_24
		end

		local var10_24 = var4_24 == #var0_24 and 1 or 0

		for iter2_24, iter3_24 in ipairs(var1_24) do
			if var6_24 == 0 and iter3_24.finish == 0 and iter3_24.progress >= iter3_24.targetNum then
				var6_24 = 1
				var7_24 = iter3_24.id
			end

			var8_24 = iter3_24.finish == 1 and var8_24 + 1 or var8_24
		end

		local var11_24 = var8_24 == #var1_24 and 1 or 0

		if var2_24 ~= var6_24 then
			return var6_24 < var2_24
		elseif var10_24 ~= var11_24 then
			return var10_24 < var11_24
		else
			return var3_24 < var7_24
		end
	end)

	for iter2_22, iter3_22 in ipairs(arg0_22.taskGroups) do
		local var0_22 = iter3_22.opening
		local var1_22 = iter3_22.tasks

		for iter4_22 = 1, #var1_22 do
			local var2_22 = var1_22[iter4_22]

			if iter4_22 == 1 then
				var2_22.show = true
			elseif var0_22 then
				var2_22.show = true
			else
				var2_22.show = false
			end
		end
	end
end

function var0_0.OnDestroy(arg0_25)
	if LeanTween.isTweening(go(arg0_25.slider)) then
		LeanTween.cancel(go(arg0_25.slider))
	end
end

return var0_0
