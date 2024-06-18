local var0_0 = class("SipeiTaskPage", import("...base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
	arg0_1.slider = arg0_1:findTF("slider", arg0_1.bg):GetComponent(typeof(Slider))
	arg0_1.step = arg0_1:findTF("step", arg0_1.bg):GetComponent(typeof(Text))
	arg0_1.progress = arg0_1:findTF("progress", arg0_1.bg):GetComponent(typeof(Text))
	arg0_1.desc = arg0_1:findTF("desc", arg0_1.bg):GetComponent(typeof(Text))
	arg0_1.awardTF = arg0_1:findTF("award", arg0_1.bg)
	arg0_1.battleBtn = arg0_1:findTF("battle_btn", arg0_1.bg)
	arg0_1.getBtn = arg0_1:findTF("get_btn", arg0_1.bg)
	arg0_1.gotBtn = arg0_1:findTF("got_btn", arg0_1.bg)
end

function var0_0.OnDataSetting(arg0_2)
	local var0_2 = getProxy(TaskProxy)

	arg0_2.taskList = arg0_2.taskList or arg0_2.activity:getConfig("config_data")

	for iter0_2, iter1_2 in ipairs(arg0_2.taskList) do
		arg0_2.taskIndex = iter0_2
		arg0_2.taskVO = var0_2:getTaskVO(iter1_2)

		if not arg0_2.taskVO:isReceive() then
			break
		end
	end

	assert(arg0_2.taskVO, "without any taskVO!!!")
end

function var0_0.OnFirstFlush(arg0_3)
	onButton(arg0_3, arg0_3.battleBtn, function()
		arg0_3:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.getBtn, function()
		arg0_3:emit(ActivityMediator.ON_TASK_SUBMIT, arg0_3.taskVO)
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_6)
	local var0_6 = arg0_6.taskVO:getConfig("award_display")[1]
	local var1_6 = {
		type = var0_6[1],
		id = var0_6[2],
		count = var0_6[3]
	}

	updateDrop(arg0_6.awardTF, var1_6)
	onButton(arg0_6, arg0_6.awardTF, function()
		arg0_6:emit(BaseUI.ON_DROP, var1_6)
	end, SFX_PANEL)

	if arg0_6.step then
		setText(arg0_6.step, arg0_6.taskIndex .. "/" .. #arg0_6.taskList)
	end

	local var2_6 = arg0_6.taskVO:getProgress()
	local var3_6 = arg0_6.taskVO:getConfig("target_num")

	setText(arg0_6.desc, arg0_6.taskVO:getConfig("desc"))
	setText(arg0_6.progress, var2_6 .. "/" .. var3_6)
	setSlider(arg0_6.slider, 0, var3_6, var2_6)

	local var4_6 = arg0_6.taskVO:getTaskStatus()

	setActive(arg0_6.battleBtn, var4_6 == 0)
	setActive(arg0_6.getBtn, var4_6 == 1)
	setActive(arg0_6.gotBtn, var4_6 == 2)
end

function var0_0.OnDestroy(arg0_8)
	return
end

return var0_0
