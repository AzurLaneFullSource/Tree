local var0_0 = class("FranceSpRePage", import("...base.BaseActivityPage"))

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
	arg0_1.buildBtn = arg0_1:findTF("build_btn", arg0_1.bg)
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
	onButton(arg0_3, arg0_3.buildBtn, function()
		arg0_3:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.LIGHT
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_7)
	local var0_7 = arg0_7.taskVO:getConfig("award_display")[1]
	local var1_7 = {
		type = var0_7[1],
		id = var0_7[2],
		count = var0_7[3]
	}

	updateDrop(arg0_7.awardTF, var1_7)
	onButton(arg0_7, arg0_7.awardTF, function()
		arg0_7:emit(BaseUI.ON_DROP, var1_7)
	end, SFX_PANEL)

	if arg0_7.step then
		setText(arg0_7.step, arg0_7.taskIndex .. "/" .. #arg0_7.taskList)
	end

	local var2_7 = arg0_7.taskVO:getProgress()
	local var3_7 = arg0_7.taskVO:getConfig("target_num")

	setText(arg0_7.desc, arg0_7.taskVO:getConfig("desc"))
	setText(arg0_7.progress, var2_7 .. "/" .. var3_7)
	setSlider(arg0_7.slider, 0, var3_7, var2_7)

	local var4_7 = arg0_7.taskVO:getTaskStatus()

	setActive(arg0_7.battleBtn, var4_7 == 0)
	setActive(arg0_7.getBtn, var4_7 == 1)
	setActive(arg0_7.gotBtn, var4_7 == 2)
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
