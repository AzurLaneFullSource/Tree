local var0 = class("SpTemplatePage", import(".PtTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.buildBtn = arg0:findTF("build_btn", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	local var0 = arg0.activity:getConfig("config_client").linkPoolActID

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips("未配置linkPoolActID！！！")
	else
		local var1 = getProxy(ActivityProxy):getActivityById(var0)

		if var1 and not var1:isEnd() then
			setActive(arg0.buildBtn, true)

			local var2 = pg.activity_template[var0].config_client.id
			local var3 = var2 and var2 or BuildShipScene.PROJECTS.SPECIAL
			local var4 = {
				BuildShipScene.PROJECTS.SPECIAL,
				BuildShipScene.PROJECTS.LIGHT,
				BuildShipScene.PROJECTS.HEAVY,
				BuildShipScene.PROJECTS.ACTIVITY
			}

			onButton(arg0, arg0.buildBtn, function()
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = var4[var3]
				})
			end, SFX_PANEL)
		else
			setActive(arg0.buildBtn, false)
		end
	end
end

return var0
