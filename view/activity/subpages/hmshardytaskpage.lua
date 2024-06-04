local var0 = class("HMSHardyTaskPage", import(".TemplatePage.PassChaptersTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.notGetBtn = arg0:findTF("not_get_btn", arg0.bg)
	arg0.goHuntBtn = arg0:findTF("gohunt_btn", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.goHuntBtn, function()
		arg0:emit(ActivityMediator.SELECT_ACTIVITY, pg.activity_const.HMS_Hunter_PT_ID.act_id)
	end, SFX_PANEL)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(arg0, arg0.notGetBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.TASK)
	end, SFX_PANEL)
	onButton(arg0, arg0.buildBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
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
		setText(arg0.step, arg0.taskIndex)
	end

	local var2 = arg0.taskVO:getProgress()
	local var3 = arg0.taskVO:getConfig("target_num")

	setText(arg0.desc, arg0.taskVO:getConfig("desc"))
	setText(arg0.progress, var2 .. "/" .. var3)
	setSlider(arg0.slider, 0, var3, var2)

	local var4 = arg0.taskVO:getTaskStatus()

	setActive(arg0.notGetBtn, var4 == 0)
	setActive(arg0.getBtn, var4 == 1)
	setActive(arg0.gotBtn, var4 == 2)
end

return var0
