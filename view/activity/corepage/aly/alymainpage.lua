local var0_0 = class("ALYMainPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.AD = arg0_1._tf:Find("bg")
	arg0_1.list = arg0_1.AD:Find("list")
	arg0_1.build = arg0_1.list:Find("build")
	arg0_1.fight = arg0_1.list:Find("fight")
	arg0_1.shop = arg0_1.list:Find("shop")
end

function var0_0.OnFirstFlush(arg0_2)
	onButton(arg0_2, arg0_2.build, function()
		arg0_2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			page = BuildShipScene.PAGE_BUILD,
			projectName = BuildShipScene.PROJECTS.ACTIVITY
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.fight, function()
		arg0_2:emit(ActivityMediator.SKIP_ACTIVITY_MAP, 50054)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.shop, function()
		arg0_2:emit(ActivityMediator.GO_CHANGE_SHOP)
	end, SFX_PANEL)
	setText(arg0_2._tf:Find("Text (Legacy)", arg0_2.build), i18n("yumia_main_tip_1"))
	setText(arg0_2._tf:Find("Text (Legacy)", arg0_2.fight), i18n("yumia_main_tip_2"))
	setText(arg0_2._tf:Find("Text (Legacy)", arg0_2.shop), i18n("yumia_main_tip_3"))
end

function var0_0.OnDestroy(arg0_6)
	if arg0_6.camEventId then
		pg.CameraFixMgr.GetInstance():disconnect(arg0_6.camEventId)

		arg0_6.camEventId = nil
	end
end

return var0_0
