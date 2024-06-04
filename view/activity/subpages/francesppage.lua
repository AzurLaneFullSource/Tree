local var0 = class("FranceSpPage", import("...base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.slider = arg0:findTF("slider", arg0.bg):GetComponent(typeof(Slider))
	arg0.step = arg0:findTF("step", arg0.bg):GetComponent(typeof(Text))
	arg0.progress = arg0:findTF("progress", arg0.bg):GetComponent(typeof(Text))
	arg0.desc = arg0:findTF("desc", arg0.bg):GetComponent(typeof(Text))
	arg0.awardTF = arg0:findTF("award", arg0.bg)
	arg0.battleBtn = arg0:findTF("battle_btn", arg0.bg)
	arg0.getBtn = arg0:findTF("get_btn", arg0.bg)
	arg0.gotBtn = arg0:findTF("got_btn", arg0.bg)
	arg0.buildBtn = arg0:findTF("build_btn", arg0.bg)
end

function var0.OnDataSetting(arg0)
	local var0 = getProxy(TaskProxy)

	arg0.taskList = arg0.taskList or arg0.activity:getConfig("config_data")

	for iter0, iter1 in ipairs(arg0.taskList) do
		arg0.taskIndex = iter0
		arg0.taskVO = var0:getTaskVO(iter1)

		if not arg0.taskVO:isReceive() then
			break
		end
	end

	assert(arg0.taskVO, "without any taskVO!!!")
end

function var0.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.getBtn, function()
		arg0:emit(ActivityMediator.ON_TASK_SUBMIT, arg0.taskVO)
	end, SFX_PANEL)
	onButton(arg0, arg0.buildBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.LIGHT
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.taskVO:getConfig("award_display")[1]
	local var1 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	updateDrop(arg0.awardTF, var1)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var1)
	end, SFX_PANEL)

	if arg0.step then
		setText(arg0.step, arg0.taskIndex .. "/" .. #arg0.taskList)
	end

	local var2 = arg0.taskVO:getProgress()
	local var3 = arg0.taskVO:getConfig("target_num")

	setText(arg0.desc, arg0.taskVO:getConfig("desc"))
	setText(arg0.progress, var2 .. "/" .. var3)
	setSlider(arg0.slider, 0, var3, var2)

	local var4 = arg0.taskVO:getTaskStatus()

	setActive(arg0.battleBtn, var4 == 0)
	setActive(arg0.getBtn, var4 == 1)
	setActive(arg0.gotBtn, var4 == 2)
end

function var0.OnDestroy(arg0)
	return
end

return var0
