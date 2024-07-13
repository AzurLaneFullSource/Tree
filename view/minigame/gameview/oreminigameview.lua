local var0_0 = class("OreMiniGameView", import("view.miniGame.MiniGameTemplateView"))

function var0_0.getUIName(arg0_1)
	return "OreMiniGameUI"
end

function var0_0.getGameController(arg0_2)
	return OreMiniGameController
end

function var0_0.getShowSide(arg0_3)
	return false
end

function var0_0.initPageUI(arg0_4)
	var0_0.super.initPageUI(arg0_4)
	onButton(arg0_4, arg0_4.rtTitlePage:Find("main/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ore_minigame_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.rtTitlePage:Find("result/window/btn_finish"), function()
		arg0_4:openUI("main")
		arg0_4.gameController:ResetGame()
	end, SFX_CONFIRM)

	local var0_4 = arg0_4.rtTitlePage:Find("main/res_bar")
	local var1_4 = pg.activity_template[ActivityConst.ISLAND_GAME_ID].config_client.item_id

	LoadImageSpriteAsync(Item.getConfigData(var1_4).icon, var0_4:Find("icon"), true)
	setText(var0_4:Find("num"), arg0_4:GetMGHubData().count)
	onButton(arg0_4, var0_4, function()
		arg0_4:emit(BaseMiniGameMediator.OPEN_SUB_LAYER, {
			mediator = IslandGameLimitMediator,
			viewComponent = IslandGameLimitLayer
		})
	end, SFX_CANCEL)
end

function var0_0.updateMainUI(arg0_8)
	var0_0.super.updateMainUI(arg0_8)

	local var0_8 = arg0_8.rtTitlePage:Find("main/res_bar")
	local var1_8 = pg.activity_template[ActivityConst.ISLAND_GAME_ID].config_client.item_id

	setText(var0_8:Find("num"), arg0_8:GetMGHubData().count)
end

function var0_0.willExit(arg0_9)
	arg0_9.gameController:willExit()
end

return var0_0
