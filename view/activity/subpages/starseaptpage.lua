local var0 = class("StarSeaPtPage", import(".TemplatePage.PtTemplatePage"))
local var1 = "#CCB5FF"

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

	if arg0.step then
		local var2, var3, var4 = arg0.ptData:GetLevelProgress()

		setText(arg0.step, setColorStr(var2, var1) .. "/" .. var3)
	end

	local var5, var6, var7 = arg0.ptData:GetResProgress()

	setText(arg0.progress, (var7 >= 1 and setColorStr(var5, var1) or var5) .. "/" .. var6)
	setSlider(arg0.slider, 0, 1, var7)

	local var8 = arg0.ptData:CanGetAward()
	local var9 = arg0.ptData:CanGetNextAward()
	local var10 = arg0.ptData:CanGetMorePt()

	setActive(arg0.battleBtn, var10 and not var8 and var9)
	setActive(arg0.getBtn, var8)
	setActive(arg0.gotBtn, not var9)

	local var11 = arg0.ptData:GetAward()

	updateDrop(arg0.awardTF, var11)
	onButton(arg0, arg0.awardTF, function()
		arg0:emit(BaseUI.ON_DROP, var11)
	end, SFX_PANEL)
end

return var0
