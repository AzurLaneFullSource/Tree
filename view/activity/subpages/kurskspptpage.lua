local var0 = class("KurskSPPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		local var0
		local var1
		local var2 = arg0.activity:getConfig("config_client").linkActID

		if var2 then
			var1 = getProxy(ActivityProxy):getActivityById(var2)
		end

		if not var2 then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.BOSSRUSH_MAIN)
		elseif var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.BOSSRUSH_MAIN)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("build_btn", arg0.bg), function()
		local var0
		local var1
		local var2 = arg0.activity:getConfig("config_client").linkActID

		if var2 then
			var1 = getProxy(ActivityProxy):getActivityById(var2)
		end

		if not var2 then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		elseif var1 and not var1:isEnd() then
			arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
				page = BuildShipScene.PAGE_BUILD,
				projectName = BuildShipScene.PROJECTS.ACTIVITY
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))
		end
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setActive(arg0.battleBtn, true)
end

return var0
