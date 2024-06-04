local var0 = class("OreMiniGameView", import("view.miniGame.MiniGameTemplateView"))

function var0.getUIName(arg0)
	return "OreMiniGameUI"
end

function var0.getGameController(arg0)
	return OreMiniGameController
end

function var0.getShowSide(arg0)
	return false
end

function var0.initPageUI(arg0)
	var0.super.initPageUI(arg0)
	onButton(arg0, arg0.rtTitlePage:Find("main/btn_help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.ore_minigame_help.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.rtTitlePage:Find("result/window/btn_finish"), function()
		arg0:openUI("main")
		arg0.gameController:ResetGame()
	end, SFX_CONFIRM)

	local var0 = arg0.rtTitlePage:Find("main/res_bar")
	local var1 = pg.activity_template[ActivityConst.ISLAND_GAME_ID].config_client.item_id

	LoadImageSpriteAsync(Item.getConfigData(var1).icon, var0:Find("icon"), true)
	setText(var0:Find("num"), arg0:GetMGHubData().count)
	onButton(arg0, var0, function()
		arg0:emit(BaseMiniGameMediator.OPEN_SUB_LAYER, {
			mediator = IslandGameLimitMediator,
			viewComponent = IslandGameLimitLayer
		})
	end, SFX_CANCEL)
end

function var0.updateMainUI(arg0)
	var0.super.updateMainUI(arg0)

	local var0 = arg0.rtTitlePage:Find("main/res_bar")
	local var1 = pg.activity_template[ActivityConst.ISLAND_GAME_ID].config_client.item_id

	setText(var0:Find("num"), arg0:GetMGHubData().count)
end

function var0.willExit(arg0)
	arg0.gameController:willExit()
end

return var0
