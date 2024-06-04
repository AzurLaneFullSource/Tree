local var0 = class("FuxuPtPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0:findTF("build_btn", arg0.bg), function()
		arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.HEAVY
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()

	setText(arg0.step, var0)
	setText(arg0.progress, (var5 >= 1 and setColorStr(var3, "#df9e38") or var3) .. "/" .. var4)

	local var6
	local var7

	if arg0.activity:getConfig("config_client") ~= "" then
		var6 = arg0.activity:getConfig("config_client").linkActID

		if var6 then
			var7 = getProxy(ActivityProxy):getActivityById(var6)
		end
	end

	if var6 and not var7 or var7 and var7:isEnd() then
		setActive(arg0.battleBtn, false)
		setActive(arg0:findTF("build_btn", arg0.bg), false)
	end
end

return var0
