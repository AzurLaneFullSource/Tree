local var0_0 = class("SpTemplatePage", import(".PtTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.buildBtn = arg0_1:findTF("build_btn", arg0_1.bg)
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)

	local var0_2 = arg0_2.activity:getConfig("config_client").linkPoolActID

	if not var0_2 then
		pg.TipsMgr.GetInstance():ShowTips("未配置linkPoolActID！！！")
	else
		local var1_2 = getProxy(ActivityProxy):getActivityById(var0_2)

		if var1_2 and not var1_2:isEnd() then
			setActive(arg0_2.buildBtn, true)

			local var2_2 = pg.activity_template[var0_2].config_client.id
			local var3_2 = var2_2 and var2_2 or BuildShipScene.PROJECTS.SPECIAL
			local var4_2 = {
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY,
				BuildShipScene.PROJECTS.ACTIVITY
			}

			onButton(arg0_2, arg0_2.buildBtn, function()
				arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = var4_2[var3_2]
				})
			end, SFX_PANEL)
		else
			setActive(arg0_2.buildBtn, false)
		end
	end
end

return var0_0
