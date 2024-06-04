local var0 = class("EskiPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.progresses = arg0:findTF("progresses", arg0.bg)
	arg0.progress_r = arg0:findTF("progress_r", arg0.progresses)
	arg0.progress_l = arg0:findTF("progress_l", arg0.progresses)
	arg0.buildBtn = arg0:findTF("build_btn", arg0.bg)
end

function var0.OnUpdateFlush(arg0)
	local var0 = arg0.ptData:getTargetLevel()
	local var1 = arg0.activity:getConfig("config_client").story

	if checkExist(var1, {
		var0
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1[var0][1])
	end

	local var2, var3, var4 = arg0.ptData:GetLevelProgress()
	local var5, var6, var7 = arg0.ptData:GetResProgress()

	setText(arg0.step, var2 .. "/" .. var3)

	local var8 = var7 >= 1 and setColorStr(var5, COLOR_GREEN) or var5

	setText(arg0.progress_r, var8 .. "/" .. var6)
	setSlider(arg0.slider, 0, 1, var7)

	local var9 = arg0.ptData:CanGetAward()
	local var10 = arg0.ptData:CanGetNextAward()
	local var11 = arg0.ptData:CanGetMorePt()

	setActive(arg0.battleBtn, var11 and not var9 and var10)
	setActive(arg0.getBtn, var9)
	setActive(arg0.gotBtn, not var10)

	local var12 = arg0.ptData:GetAward()

	updateDrop(arg0.awardTF, var12)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var12)
	end, SFX_PANEL)
	onButton(arg0, arg0.buildBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.LIGHT
		})
	end, SFX_PANEL)
end

return var0
