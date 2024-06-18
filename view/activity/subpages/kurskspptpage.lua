local var0_0 = class("KurskSPPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.battleBtn, function()
		local var0_2
		local var1_2
		local var2_2 = arg0_1.activity:getConfig("config_client").linkActID

		if var2_2 then
			var1_2 = getProxy(ActivityProxy):getActivityById(var2_2)
		end

		if not var2_2 then
			arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.BOSSRUSH_MAIN)
		elseif var1_2 and not var1_2:isEnd() then
			arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.BOSSRUSH_MAIN)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1:findTF("build_btn", arg0_1.bg), function()
		local var0_3
		local var1_3
		local var2_3 = arg0_1.activity:getConfig("config_client").linkActID

		if var2_3 then
			var1_3 = getProxy(ActivityProxy):getActivityById(var2_3)
		end

		if not var2_3 then
			arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		elseif var1_3 and not var1_3:isEnd() then
			arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_4)
	var0_0.super.OnUpdateFlush(arg0_4)
	setActive(arg0_4.battleBtn, true)
end

return var0_0
