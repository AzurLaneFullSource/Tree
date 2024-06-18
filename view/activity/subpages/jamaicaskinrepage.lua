local var0_0 = class("JamaicaSkinRePage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.bg)
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg)
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg)
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = arg0_2.activity:getConfig("config_data")

	arg0_2.taskIDList = _.flatten(var0_2)
	arg0_2.dropList = {}
	arg0_2.descs = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.taskIDList) do
		local var1_2 = pg.task_data_template[iter1_2].award_display[1]

		table.insert(arg0_2.dropList, Clone(var1_2))

		local var2_2 = pg.task_data_template[iter1_2].desc

		table.insert(arg0_2.descs, var2_2)
	end

	return updateActivityTaskStatus(arg0_2.activity)
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.curTaskVO)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6, var1_6 = getActivityTask(arg0_6.activity)

	arg0_6.curTaskVO = var1_6

	local var2_6 = var1_6:getConfig("award_display")[1]
	local var3_6 = {
		type = var2_6[1],
		id = var2_6[2],
		count = var2_6[3]
	}

	updateDrop(arg0_6.awardTF, var3_6)
	onButton(arg0_6, arg0_6.awardTF, function()
		arg0_6:emit(BaseUI.ON_DROP, var3_6)
	end, SFX_PANEL)

	local var4_6 = var1_6:getProgress()
	local var5_6 = var1_6:getConfig("target_num")

	setText(arg0_6.progress, (var5_6 <= var4_6 and setColorStr(var4_6, COLOR_GREEN) or var4_6) .. "/" .. var5_6)
	setSlider(arg0_6.slider, 0, var5_6, var4_6)

	local var6_6 = table.indexof(arg0_6.taskIDList, var0_6, 1)

	setText(arg0_6.step, var6_6 .. "/" .. #arg0_6.taskIDList)

	local var7_6 = var1_6:getTaskStatus()

	setActive(arg0_6.battleBtn, var7_6 == 0)
	setActive(arg0_6.getBtn, var7_6 == 1)
	setActive(arg0_6.gotBtn, var7_6 == 2)

	if var7_6 == 2 then
		arg0_6.finishedIndex = var6_6
	else
		arg0_6.finishedIndex = var6_6 - 1
	end
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
