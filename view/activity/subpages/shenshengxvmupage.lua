local var0_0 = class("ShenshengxvmuPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	setActive(arg0_1.displayBtn, false)
	setActive(arg0_1.awardTF, false)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3 = arg0_3.activity:getConfig("config_client")
	local var1_3 = pg.TimeMgr.GetInstance():inTime(var0_3)

	setActive(arg0_3.battleBtn, isActive(arg0_3.battleBtn) and var1_3)

	local var2_3, var3_3, var4_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.step, var4_3 >= 1 and setColorStr(var2_3, COLOR_GREEN) or var2_3)
	setText(arg0_3.progress, "/" .. var3_3)
end

return var0_0
