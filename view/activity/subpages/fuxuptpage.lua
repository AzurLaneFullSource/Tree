local var0_0 = class("FuxuPtPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1:findTF("build_btn", arg0_1.bg), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.HEAVY
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)

	local var0_3, var1_3, var2_3 = arg0_3.ptData:GetLevelProgress()
	local var3_3, var4_3, var5_3 = arg0_3.ptData:GetResProgress()

	setText(arg0_3.step, var0_3)
	setText(arg0_3.progress, (var5_3 >= 1 and setColorStr(var3_3, "#df9e38") or var3_3) .. "/" .. var4_3)

	local var6_3
	local var7_3

	if arg0_3.activity:getConfig("config_client") ~= "" then
		var6_3 = arg0_3.activity:getConfig("config_client").linkActID

		if var6_3 then
			var7_3 = getProxy(ActivityProxy):getActivityById(var6_3)
		end
	end

	if var6_3 and not var7_3 or var7_3 and var7_3:isEnd() then
		setActive(arg0_3.battleBtn, false)
		setActive(arg0_3:findTF("build_btn", arg0_3.bg), false)
	end
end

return var0_0
