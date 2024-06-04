local var0 = class("RacingMiniGameView", import("view.miniGame.MiniGameTemplateView"))

var0.canSelectStage = false

function var0.getUIName(arg0)
	return "RacingMiniGameUI"
end

function var0.getGameController(arg0)
	return RacingMiniGameController
end

function var0.getShowSide(arg0)
	return false
end

function var0.initPageUI(arg0)
	arg0.rtTitlePage = arg0._tf:Find("TitlePage")

	arg0.rtTitlePage:Find("countdown"):Find("bg"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0:openUI()
		arg0.gameController:StartGame()
		pg.BgmMgr.GetInstance():ContinuePlay()
	end)

	local var0 = arg0.rtTitlePage:Find("pause")

	onButton(arg0, var0:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0.gameController:ResumeGame()
	end, SFX_CONFIRM)

	local var1 = arg0.rtTitlePage:Find("exit")

	onButton(arg0, var1:Find("window/btn_cancel"), function()
		arg0:openUI()
		arg0.gameController:ResumeGame()
	end, SFX_CANCEL)
	onButton(arg0, var1:Find("window/btn_confirm"), function()
		arg0:openUI()
		arg0.gameController:EndGame()
	end, SFX_CONFIRM)

	local var2 = arg0.rtTitlePage:Find("result")

	onButton(arg0, var2:Find("window/btn_finish"), function()
		arg0:closeView()
	end, SFX_CONFIRM)
end

function var0.didEnter(arg0)
	arg0:initPageUI()
	arg0:initControllerUI()

	arg0.gameController = arg0:getGameController().New(arg0, arg0._tf)

	arg0.gameController:ResetGame()
	arg0.gameController:ReadyGame(getProxy(MiniGameProxy):GetRank(arg0:GetMGData().id))
	pg.BgmMgr.GetInstance():StopPlay()
	arg0:openUI("countdown")
end

function var0.initOpenUISwich(arg0)
	var0.super.initOpenUISwich(arg0)

	arg0.openSwitchDic.main = nil

	function arg0.openSwitchDic.result()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-streamers")

		local var0 = arg0:GetMGData().id
		local var1 = arg0.gameController.point
		local var2 = getProxy(MiniGameProxy):GetHighScore(var0) / 100
		local var3 = arg0.rtTitlePage:Find("result")

		setActive(var3:Find("window/now/new"), var2 < var1)

		if var2 <= var1 then
			var2 = var1

			getProxy(MiniGameProxy):UpdataHighScore(var0, math.floor(var1 * 100))
		end

		setText(var3:Find("window/high/Text"), string.format("%.2fm", var2))
		setText(var3:Find("window/now/Text"), string.format("%.2fm", var1))

		local var4 = arg0:GetMGHubData()

		arg0:emit(BaseMiniGameMediator.GAME_FINISH_TRACKING, {
			game_id = var0,
			hub_id = var4.id,
			isComplete = arg0.gameController.result
		})

		if (not arg0:getShowSide() or arg0.stageIndex == var4.usedtime + 1) and var4.count > 0 then
			arg0:SendSuccess(0)
		end
	end

	function arg0.openSwitchDic.countdown()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_COUNTDOWN)
	end
end

function var0.willExit(arg0)
	arg0.gameController:willExit()
end

return var0
