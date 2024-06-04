local var0 = class("ShenshengxvmuPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.displayBtn, false)
	setActive(arg0.awardTF, false)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client")
	local var1 = pg.TimeMgr.GetInstance():inTime(var0)

	setActive(arg0.battleBtn, isActive(arg0.battleBtn) and var1)

	local var2, var3, var4 = arg0.ptData:GetResProgress()

	setText(arg0.step, var4 >= 1 and setColorStr(var2, COLOR_GREEN) or var2)
	setText(arg0.progress, "/" .. var3)
end

return var0
