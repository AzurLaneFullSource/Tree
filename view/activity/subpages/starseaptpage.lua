local var0_0 = class("StarSeaPtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = "#CCB5FF"

function var0_0.OnUpdateFlush(arg0_1)
	local var0_1 = arg0_1.ptData:getTargetLevel()
	local var1_1 = arg0_1.activity:getConfig("config_client").story

	if checkExist(var1_1, {
		var0_1
	}, {
		1
	}) then
		pg.NewStoryMgr.GetInstance():Play(var1_1[var0_1][1])
	end

	if arg0_1.step then
		local var2_1, var3_1, var4_1 = arg0_1.ptData:GetLevelProgress()

		setText(arg0_1.step, setColorStr(var2_1, var1_0) .. "/" .. var3_1)
	end

	local var5_1, var6_1, var7_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, (var7_1 >= 1 and setColorStr(var5_1, var1_0) or var5_1) .. "/" .. var6_1)
	setSlider(arg0_1.slider, 0, 1, var7_1)

	local var8_1 = arg0_1.ptData:CanGetAward()
	local var9_1 = arg0_1.ptData:CanGetNextAward()
	local var10_1 = arg0_1.ptData:CanGetMorePt()

	setActive(arg0_1.battleBtn, var10_1 and not var8_1 and var9_1)
	setActive(arg0_1.getBtn, var8_1)
	setActive(arg0_1.gotBtn, not var9_1)

	local var11_1 = arg0_1.ptData:GetAward()

	updateDrop(arg0_1.awardTF, var11_1)
	onButton(arg0_1, arg0_1.awardTF, function()
		arg0_1:emit(BaseUI.ON_DROP, var11_1)
	end, SFX_PANEL)
end

return var0_0
