local var0 = class("JamaicaSkinRePage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.slider = arg0:findTF("slider", arg0.bg)
	arg0.step = arg0:findTF("step", arg0.bg)
	arg0.progress = arg0:findTF("progress", arg0.bg)
	arg0.awardTF = arg0:findTF("award", arg0.bg)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = arg0.activity:getConfig("config_data")

	arg0.taskIDList = _.flatten(var0)
	arg0.dropList = {}
	arg0.descs = {}

	for iter0, iter1 in ipairs(arg0.taskIDList) do
		local var1 = pg.task_data_template[iter1].award_display[1]

		table.insert(arg0.dropList, Clone(var1))

		local var2 = pg.task_data_template[iter1].desc

		table.insert(arg0.descs, var2)
	end

	return updateActivityTaskStatus(arg0.activity)
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg0.curTaskVO)
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0, var1 = getActivityTask(arg0.activity)

	arg0.curTaskVO = var1

	local var2 = var1:getConfig("award_display")[1]
	local var3 = {
		type = var2[1],
		id = var2[2],
		count = var2[3]
	}

	updateDrop(arg0.awardTF, var3)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var3)
	end, SFX_PANEL)

	local var4 = var1:getProgress()
	local var5 = var1:getConfig("target_num")

	setText(arg0.progress, (var5 <= var4 and setColorStr(var4, COLOR_GREEN) or var4) .. "/" .. var5)
	setSlider(arg0.slider, 0, var5, var4)

	local var6 = table.indexof(arg0.taskIDList, var0, 1)

	setText(arg0.step, var6 .. "/" .. #arg0.taskIDList)

	local var7 = var1:getTaskStatus()

	setActive(arg0.battleBtn, var7 == 0)
	setActive(arg0.getBtn, var7 == 1)
	setActive(arg0.gotBtn, var7 == 2)

	if var7 == 2 then
		arg0.finishedIndex = var6
	else
		arg0.finishedIndex = var6 - 1
	end
end

function var0.OnDestroy(arg0)
	return
end

return var0
