local var0_0 = class("MaidAzurlanePage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.bg:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.maid_task_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.bg:Find("ClickIron"), function()
		local var0_3 = Context.New()

		SCENE.SetSceneInfo(var0_3, SCENE.NEWYEAR_BACKHILL_2022)
		var0_3:addChild(Context.New({
			mediator = BuildingUpgradeMediator,
			viewComponent = BuildingCafeUpgradeLayer,
			data = {
				buildingID = 18,
				isLayer = true
			}
		}))
		pg.m02:sendNotification(GAME.LOAD_SCENE, {
			context = var0_3
		})
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.bg:Find("ClickRoyal"), function()
		local var0_4 = Context.New()

		SCENE.SetSceneInfo(var0_4, SCENE.NEWYEAR_BACKHILL_2022)
		var0_4:addChild(Context.New({
			mediator = BuildingUpgradeMediator,
			viewComponent = BuildingCafeUpgradeLayer,
			data = {
				buildingID = 17,
				isLayer = true
			}
		}))
		pg.m02:sendNotification(GAME.LOAD_SCENE, {
			context = var0_4
		})
	end, SFX_PANEL)
end

function var0_0.OnUpdateFlush(arg0_5)
	var0_0.super.OnUpdateFlush(arg0_5)
	setText(arg0_5.dayTF, setColorStr(tostring(arg0_5.nday), "#7B3B2C"))
end

return var0_0
