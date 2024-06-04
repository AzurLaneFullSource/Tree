local var0 = class("LittleOuGenRePage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.heartTpl = arg0:findTF("HeartTpl", arg0.bg)
	arg0.heartContainer = arg0:findTF("HeartContainer", arg0.bg)
	arg0.heartUIItemList = UIItemList.New(arg0.heartContainer, arg0.heartTpl)

	arg0.heartUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = arg0.ptData:GetLevelProgress()
			local var2 = arg0:findTF("Full", arg2)

			setActive(var2, not (var1 < var0))
		end
	end)

	arg0.helpBtn = arg0:findTF("help_btn", arg0.bg)

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.littleEugen_npc.tip
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1 = arg0.ptData:GetLevelProgress()

	arg0.heartUIItemList:align(var1)

	local var2, var3, var4 = arg0.ptData:GetLevelProgress()
	local var5, var6, var7 = arg0.ptData:GetResProgress()

	setText(arg0.step, setColorStr(var2, "#f8e6e2") .. " / " .. setColorStr(var3, "#4e2c2b"))
	setText(arg0.progress, (var7 >= 1 and setColorStr(var5, COLOR_GREEN) or setColorStr(var5, "COLOR_GREEN")) .. "/" .. setColorStr(var6, "#4e2c2b"))

	if arg0.firstSliderInit then
		if LeanTween.isTweening(go(arg0.slider)) then
			LeanTween.cancel(go(arg0.slider))
		end

		local var8 = GetComponent(arg0.slider, typeof(Slider)).value
		local var9 = arg0.l1 ~= var2 and 0 or arg0.sliderValue

		LeanTween.value(go(arg0.slider), var9, var7, 1):setOnUpdate(System.Action_float(function(arg0)
			setSlider(arg0.slider, 0, 1, arg0)

			arg0.sliderValue = arg0
		end))
	else
		setSlider(arg0.slider, 0, 1, var7)

		arg0.firstSliderInit = true
		arg0.sliderValue = var7
	end

	arg0.l1 = var2

	arg0:updataTask()
	arg0:sortTaskGroups()
	arg0:updateTaskUI()
end

function var0.updataTask(arg0)
	for iter0, iter1 in ipairs(arg0.taskGroups) do
		for iter2, iter3 in ipairs(iter1.tasks) do
			local var0 = arg0.taskProxy:getFinishTaskById(iter3.id) and 1 or 0
			local var1 = arg0.taskProxy:getTaskById(iter3.id)
			local var2 = 0

			if var1 then
				var2 = var1:getProgress()
				iter1.progress = var2 == 0 and iter1.progress or var2
			else
				var2 = iter1.progress
			end

			iter3.progress = var2

			if iter3.finish ~= var0 then
				setActive(iter3.tf, false)
				table.insert(arg0.taskTplPool, iter3.tf)

				iter3.tf = nil
			end

			iter3.finish = var0
		end
	end
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.LEVEL)
	end, SFX_PANEL)
	arg0:initTask()
	arg0:sortTaskGroups()
	arg0:updateTaskUI()
end

function var0.initTask(arg0)
	arg0.missionTpl = findTF(arg0.bg, "missionTpl")

	setActive(arg0.missionTpl, false)

	arg0.missionContainer = findTF(arg0.bg, "mission/content")

	local var0 = arg0.activity:getConfig("config_client").task_act_id
	local var1 = pg.activity_template[var0].config_data[1]

	arg0.taskProxy = getProxy(TaskProxy)
	arg0.taskTplPool = {}
	arg0.taskScroll = GetComponent(findTF(arg0.bg, "mission"), typeof(ScrollRect))
	arg0.taskGroups = {}

	for iter0 = 1, #var1 do
		local var2 = var1[iter0]
		local var3 = pg.task_data_template[var2]

		if not var3 then
			print("task_data_template 不存在任务id : " .. tostring(var2))
		end

		local var4 = var3.type
		local var5 = var3.sub_type

		if var4 == Task.TYPE_ACTIVITY or var4 == Task.TYPE_ACTIVITY_BRANCH then
			local var6 = arg0:getTaskGroup(var4, var5)

			arg0:insertTaskToGroup(var2, var3, var6)
		end
	end
end

function var0.updateTaskUI(arg0)
	local var0 = 0

	for iter0 = 1, #arg0.taskGroups do
		local var1 = arg0.taskGroups[iter0]
		local var2 = var1.tasks

		for iter1, iter2 in ipairs(var2) do
			arg0:updateTaskList(iter1, var0, iter2, var1)

			var0 = var0 + 1
		end
	end

	local var3 = 0
	local var4 = 0

	if arg0.scrollToGroup then
		for iter3, iter4 in ipairs(arg0.taskGroups) do
			if iter4 == arg0.scrollToGroup then
				var4 = var3
			end

			if iter4.opening then
				var3 = var3 + #iter4.tasks
			else
				var3 = var3 + 1
			end
		end

		arg0.scrollToGroup = nil
	end

	if var4 ~= 0 and var3 ~= 0 then
		scrollTo(arg0.taskScroll, 0, 1 - var4 / var3)
	else
		scrollTo(arg0.taskScroll, 0, 1)
	end
end

function var0.updateTaskList(arg0, arg1, arg2, arg3, arg4)
	if not arg3.show then
		return
	end

	local var0 = arg3.targetNum
	local var1 = arg3.progress
	local var2 = arg3.finish == 1
	local var3 = arg1 == 1
	local var4 = arg3.desc
	local var5 = arg3.drop
	local var6 = arg4.opening
	local var7 = #arg4.tasks == 1

	if not arg3.tf then
		arg3.tf = arg0:getTaskTfFromPool()
	end

	local var8 = findTF(arg3.tf, "AD")

	arg3.tf.sizeDelta = Vector2(778, var3 and 120 or 110)

	setActive(findTF(var8, "bg1"), var3)
	setActive(findTF(var8, "bg2"), not var3)

	if var3 then
		setActive(findTF(var8, "mask1"), var2)
	else
		setActive(findTF(var8, "mask2"), var2)
	end

	if var2 then
		setActive(findTF(var8, "pahase"), false)
		setSlider(findTF(var8, "slider"), 0, 1, 1)
	else
		setActive(findTF(var8, "pahase"), true)
		setSlider(findTF(var8, "slider"), 0, 1, var1 / var0)
	end

	setText(findTF(var8, "desc"), var4)

	if arg4.subType ~= 33 then
		setText(findTF(var8, "pahase"), setColorStr(var1, "#95b345") .. "/" .. setColorStr(var0, "#e9c9bd"))
	else
		setText(findTF(var8, "pahase"), "")
	end

	updateDrop(findTF(var8, "award"), var5)
	onButton(arg0, findTF(var8, "award"), function()
		arg0:emit(BaseUI.ON_DROP, var5)
	end, SFX_PANEL)
	setActive(findTF(var8, "got"), false)
	setActive(findTF(var8, "get"), false)
	setActive(findTF(var8, "go"), false)

	if not var3 then
		setActive(findTF(var8, "go"), not var2)
		setActive(findTF(var8, "got"), var2)
	elseif var2 then
		setActive(findTF(var8, "got"), true)
	elseif var0 <= var1 then
		setActive(findTF(var8, "get"), true)
		onButton(arg0, findTF(var8, "get"), function()
			local var0 = arg0.taskProxy:getTaskById(arg3.id)

			if var0 then
				arg0:emit(ActivityMediator.ON_TASK_SUBMIT, var0)
			end
		end, SFX_CONFIRM)

		if not arg0.nextTickFlag then
			onNextTick(function()
				triggerButton(findTF(var8, "get"))

				arg0.nextTickFlag = false
			end)

			arg0.nextTickFlag = true
		end
	else
		setActive(findTF(var8, "go"), true)
		onButton(arg0, findTF(var8, "go"), function()
			local var0 = arg0.taskProxy:getTaskById(arg3.id)

			if var0 then
				arg0:emit(ActivityMediator.ON_TASK_GO, var0)
			end
		end, SFX_CONFIRM)
	end

	if var7 or not var3 or var2 and var3 then
		setActive(findTF(var8, "show"), false)
	else
		setActive(findTF(var8, "show"), true)
		setActive(findTF(var8, "show/on"), var6)
		setActive(findTF(var8, "show/off"), not var6)
	end

	if var3 then
		onButton(arg0, findTF(var8, "show"), function()
			arg0:changeGroupOpening(arg4)
		end, SFX_CONFIRM)
	end

	setActive(arg3.tf, true)
	arg3.tf:SetSiblingIndex(arg2)
end

function var0.changeGroupOpening(arg0, arg1)
	arg1.opening = not arg1.opening

	for iter0 = 1, #arg1.tasks do
		local var0 = arg1.tasks[iter0]

		if iter0 == 1 then
			var0.show = true
		else
			var0.show = arg1.opening
		end

		if not var0.show and var0.tf then
			setActive(var0.tf, false)
			table.insert(arg0.taskTplPool, var0.tf)

			var0.tf = nil
		end
	end

	arg0.scrollToGroup = arg1

	arg0:updateTaskUI()
end

function var0.getTaskTfFromPool(arg0)
	if #arg0.taskTplPool > 0 then
		return table.remove(arg0.taskTplPool, 1)
	end

	local var0 = tf(Instantiate(arg0.missionTpl))

	SetParent(var0, arg0.missionContainer)

	return var0
end

function var0.getTaskGroup(arg0, arg1, arg2)
	for iter0 = 1, #arg0.taskGroups do
		local var0 = arg0.taskGroups[iter0]

		if var0.type == arg1 and var0.subType == arg2 then
			return var0
		end
	end

	local var1 = {
		opening = false,
		progress = 0,
		type = arg1,
		subType = arg2,
		tasks = {}
	}

	table.insert(arg0.taskGroups, var1)

	return var1
end

function var0.insertTaskToGroup(arg0, arg1, arg2, arg3)
	local var0 = arg3.tasks

	for iter0 = 1, #var0 do
		if var0[iter0].id == arg1 then
			return
		end
	end

	local var1 = arg2.target_num
	local var2 = arg2.desc
	local var3 = {
		type = arg2.award_display[1][1],
		id = arg2.award_display[1][2],
		count = arg2.award_display[1][3]
	}
	local var4 = false

	if #arg3.tasks == 0 then
		var4 = true
	end

	local var5 = arg0.taskProxy:getFinishTaskById(arg1) and 1 or 0
	local var6 = arg0.taskProxy:getTaskById(arg1)
	local var7 = 0

	if var6 then
		var7 = var6:getProgress()
		arg3.progress = var7 == 0 and arg3.progress or var7
	else
		var7 = arg3.progress
	end

	table.insert(arg3.tasks, {
		id = arg1,
		targetNum = var1,
		show = var4,
		finish = var5,
		progress = var7,
		desc = var2,
		drop = var3
	})
end

function var0.sortTaskGroups(arg0)
	for iter0, iter1 in ipairs(arg0.taskGroups) do
		table.sort(iter1.tasks, function(arg0, arg1)
			if arg0.finish ~= arg1.finish then
				return arg0.finish < arg1.finish
			end

			return arg0.targetNum < arg1.targetNum
		end)
	end

	table.sort(arg0.taskGroups, function(arg0, arg1)
		local var0 = arg0.tasks
		local var1 = arg1.tasks
		local var2 = 0
		local var3 = arg0.tasks[1].id
		local var4 = 0
		local var5 = 0
		local var6 = 0
		local var7 = arg1.tasks[1].id
		local var8 = 0
		local var9 = 0

		for iter0, iter1 in ipairs(var0) do
			if var2 == 0 and iter1.finish == 0 and iter1.progress >= iter1.targetNum then
				var2 = 1
				var3 = iter1.id
			end

			var4 = iter1.finish == 1 and var4 + 1 or var4
		end

		local var10 = var4 == #var0 and 1 or 0

		for iter2, iter3 in ipairs(var1) do
			if var6 == 0 and iter3.finish == 0 and iter3.progress >= iter3.targetNum then
				var6 = 1
				var7 = iter3.id
			end

			var8 = iter3.finish == 1 and var8 + 1 or var8
		end

		local var11 = var8 == #var1 and 1 or 0

		if var2 ~= var6 then
			return var6 < var2
		elseif var10 ~= var11 then
			return var10 < var11
		else
			return var3 < var7
		end
	end)

	for iter2, iter3 in ipairs(arg0.taskGroups) do
		local var0 = iter3.opening
		local var1 = iter3.tasks

		for iter4 = 1, #var1 do
			local var2 = var1[iter4]

			if iter4 == 1 then
				var2.show = true
			elseif var0 then
				var2.show = true
			else
				var2.show = false
			end
		end
	end
end

function var0.OnDestroy(arg0)
	if LeanTween.isTweening(go(arg0.slider)) then
		LeanTween.cancel(go(arg0.slider))
	end
end

return var0
