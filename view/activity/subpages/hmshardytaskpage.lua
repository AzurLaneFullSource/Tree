local var0_0 = class("HMSHardyTaskPage", import(".TemplatePage.PassChaptersTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.notGetBtn = arg0_1:findTF("not_get_btn", arg0_1.bg)
	arg0_1.goHuntBtn = arg0_1:findTF("gohunt_btn", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.goHuntBtn, function()
		arg0_2:emit(ActivityMediator.SELECT_ACTIVITY, pg.activity_const.HMS_Hunter_PT_ID.act_id)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.battleBtn, function()
		arg0_2:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.notGetBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.buildBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
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
		setText(arg0_7.step, arg0_7.taskIndex)
	end

	local var2_7 = arg0_7.taskVO:getProgress()
	local var3_7 = arg0_7.taskVO:getConfig("target_num")

	setText(arg0_7.desc, arg0_7.taskVO:getConfig("desc"))
	setText(arg0_7.progress, var2_7 .. "/" .. var3_7)
	setSlider(arg0_7.slider, 0, var3_7, var2_7)

	local var4_7 = arg0_7.taskVO:getTaskStatus()

	setActive(arg0_7.notGetBtn, var4_7 == 0)
	setActive(arg0_7.getBtn, var4_7 == 1)
	setActive(arg0_7.gotBtn, var4_7 == 2)
end

return var0_0
