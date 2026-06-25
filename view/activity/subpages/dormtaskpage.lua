local var0_0 = class("DormTaskPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1._tf:Find("AD")
	arg0_1.slider = arg0_1.bg:Find("slider"):GetComponent(typeof(Slider))
	arg0_1.step = arg0_1.bg:Find("step"):GetComponent(typeof(Text))
	arg0_1.stepMax = arg0_1.bg:Find("step_max"):GetComponent(typeof(Text))
	arg0_1.progress = arg0_1.bg:Find("progress"):GetComponent(typeof(Text))
	arg0_1.desc = arg0_1.bg:Find("desc"):GetComponent(typeof(Text))
	arg0_1.awardTF = arg0_1.bg:Find("award")
	arg0_1.awardGot = arg0_1.bg:Find("award_got")
	arg0_1.battleBtn = arg0_1.bg:Find("battle_btn")
	arg0_1.getBtn = arg0_1.bg:Find("get_btn")
	arg0_1.gotBtn = arg0_1.bg:Find("got_btn")
end

function var0_0.OnDataSetting(arg0_2)
	arg0_2.nday = 0
	arg0_2.taskProxy = getProxy(TaskProxy)
	arg0_2.taskGroup = arg0_2.activity:getConfig("config_client").unlock_task

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.ON_TASK_GO, arg0_3.taskVO)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.taskVO)
	end, SFX_PANEL)
	setText(arg0_3.stepMax, "/" .. #arg0_3.taskGroup)
end

function var0_0.OnUpdateFlush(arg0_6)
	arg0_6.taskIndex = arg0_6:getTaskIdx(arg0_6.activity)

	local var0_6 = arg0_6.taskGroup[arg0_6.taskIndex][1]

	arg0_6.taskVO = arg0_6.taskProxy:getTaskById(var0_6) or arg0_6.taskProxy:getFinishTaskById(var0_6)

	local var1_6 = arg0_6.taskVO:getConfig("award_display")[1]
	local var2_6 = {
		type = var1_6[1],
		id = var1_6[2],
		count = var1_6[3]
	}

	updateDrop(arg0_6.awardTF, var2_6)
	onButton(arg0_6, arg0_6.awardTF, function()
		arg0_6:emit(BaseUI.ON_DROP, var2_6)
	end, SFX_PANEL)

	if arg0_6.step then
		setText(arg0_6.step, "DAY" .. arg0_6.taskIndex)
	end

	local var3_6 = arg0_6.taskVO:getProgress()
	local var4_6 = arg0_6.taskVO:getConfig("target_num")

	setText(arg0_6.desc, arg0_6.taskVO:getConfig("desc"))
	setText(arg0_6.progress, var3_6 .. "/" .. var4_6)
	setSlider(arg0_6.slider, 0, var4_6, var3_6)

	local var5_6 = arg0_6.taskVO:getTaskStatus()

	setActive(arg0_6.battleBtn, var5_6 == 0)
	setActive(arg0_6.getBtn, var5_6 == 1)
	setActive(arg0_6.gotBtn, var5_6 == 2)
	setActive(arg0_6.awardGot, var5_6 == 2)
end

function var0_0.getTaskIdx(arg0_8, arg1_8)
	local var0_8 = 1
	local var1_8 = arg1_8:getNDay()
	local var2_8 = #arg0_8.taskGroup
	local var3_8 = math.min(var1_8, var2_8)
	local var4_8 = true

	for iter0_8 = 1, var3_8 do
		if not var4_8 then
			break
		end

		var0_8 = iter0_8

		if iter0_8 < var3_8 then
			for iter1_8, iter2_8 in ipairs(arg0_8.taskGroup[iter0_8]) do
				if not arg0_8:isTaskFinished(iter2_8) then
					var4_8 = false

					break
				end
			end
		end
	end

	return math.min(var0_8, var2_8)
end

function var0_0.isTaskFinished(arg0_9, arg1_9)
	if not arg0_9.taskProxy then
		arg0_9.taskProxy = getProxy(TaskProxy)
	end

	local var0_9 = arg0_9.taskProxy:getTaskById(arg1_9) or arg0_9.taskProxy:getFinishTaskById(arg1_9)

	return var0_9 and var0_9:getTaskStatus() == 2
end

return var0_0
