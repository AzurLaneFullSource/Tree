local var0_0 = class("YidaliPTRePage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.progresses = arg0_1:findTF("progresses", arg0_1.bg)
	arg0_1.progress_r = arg0_1:findTF("progress_r", arg0_1.progresses)
	arg0_1.progress_l = arg0_1:findTF("progress_l", arg0_1.progresses)
end

function var0_0.OnUpdateFlush(arg0_2)
	local var0_2 = arg0_2.ptData:getTargetLevel()
	local var1_2 = arg0_2.activity:getConfig("config_client").story

	if checkExist(var1_2, {
		var0_2
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1_2[var0_2][1])
	end

	local var2_2, var3_2, var4_2 = arg0_2.ptData:GetLevelProgress()
	local var5_2, var6_2, var7_2 = arg0_2.ptData:GetResProgress()

	setText(arg0_2.step, var2_2 .. "/" .. var3_2)
	setText(arg0_2.progress_l, var7_2 >= 1 and setColorStr(var5_2, COLOR_GREEN) or var5_2)
	setText(arg0_2.progress_r, "/" .. var6_2)
	setSlider(arg0_2.slider, 0, 1, var7_2)

	local var8_2 = arg0_2.ptData:CanGetAward()
	local var9_2 = arg0_2.ptData:CanGetNextAward()
	local var10_2 = arg0_2.ptData:CanGetMorePt()

	setActive(arg0_2.battleBtn, var10_2 and not var8_2 and var9_2)
	setActive(arg0_2.getBtn, var8_2)
	setActive(arg0_2.gotBtn, not var9_2)

	local var11_2 = arg0_2.ptData:GetAward()

	updateDrop(arg0_2.awardTF, var11_2)
	onButton(arg0_2, arg0_2.awardTF, function()
		arg0_2:emit(BaseUI.ON_DROP, var11_2)
	end, SFX_PANEL)
end

return var0_0
