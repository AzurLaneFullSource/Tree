local var0 = class("MaidAzurlanePage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.bg:Find("help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.maid_task_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.bg:Find("ClickIron"), function()
		local var0 = Context.New()

		SCENE.SetSceneInfo(var0, SCENE.NEWYEAR_BACKHILL_2022)
		var0:addChild(Context.New({
			mediator = BuildingUpgradeMediator,
			viewComponent = BuildingCafeUpgradeLayer,
			data = {
				buildingID = 18,
				isLayer = true
			}
		}))
		pg.m02:sendNotification(GAME.LOAD_SCENE, {
			context = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.bg:Find("ClickRoyal"), function()
		local var0 = Context.New()

		SCENE.SetSceneInfo(var0, SCENE.NEWYEAR_BACKHILL_2022)
		var0:addChild(Context.New({
			mediator = BuildingUpgradeMediator,
			viewComponent = BuildingCafeUpgradeLayer,
			data = {
				buildingID = 17,
				isLayer = true
			}
		}))
		pg.m02:sendNotification(GAME.LOAD_SCENE, {
			context = var0
		})
	end, SFX_PANEL)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(tostring(arg0.nday), "#7B3B2C"))
end

return var0
