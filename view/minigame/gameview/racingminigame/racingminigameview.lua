local var0_0 = class("RacingMiniGameView", import("view.miniGame.MiniGameTemplateView"))

var0_0.canSelectStage = false

function var0_0.getUIName(arg0_1)
	return "RacingMiniGameUI"
end

function var0_0.getGameController(arg0_2)
	return RacingMiniGameController
end

function var0_0.getShowSide(arg0_3)
	return false
end

function var0_0.initPageUI(arg0_4)
	arg0_4.rtTitlePage = arg0_4._tf:Find("TitlePage")

	arg0_4.rtTitlePage:Find("countdown"):Find("bg"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		arg0_4:openUI()
		arg0_4.gameController:StartGame()
		pg.BgmMgr.GetInstance():ContinuePlay()
	end)

	local var0_4 = arg0_4.rtTitlePage:Find("pause")

	onButton(arg0_4, var0_4:Find("window/btn_confirm"), function()
		arg0_4:openUI()
		arg0_4.gameController:ResumeGame()
	end, SFX_CONFIRM)

	local var1_4 = arg0_4.rtTitlePage:Find("exit")

	onButton(arg0_4, var1_4:Find("window/btn_cancel"), function()
		arg0_4:openUI()
		arg0_4.gameController:ResumeGame()
	end, SFX_CANCEL)
	onButton(arg0_4, var1_4:Find("window/btn_confirm"), function()
		arg0_4:openUI()
		arg0_4.gameController:EndGame()
	end, SFX_CONFIRM)

	local var2_4 = arg0_4.rtTitlePage:Find("result")

	onButton(arg0_4, var2_4:Find("window/btn_finish"), function()
		arg0_4:closeView()
	end, SFX_CONFIRM)
end

function var0_0.didEnter(arg0_10)
	arg0_10:initPageUI()
	arg0_10:initControllerUI()

	arg0_10.gameController = arg0_10:getGameController().New(arg0_10, arg0_10._tf)

	arg0_10.gameController:ResetGame()
	arg0_10.gameController:ReadyGame(getProxy(MiniGameProxy):GetRank(arg0_10:GetMGData().id))
	pg.BgmMgr.GetInstance():StopPlay()
	arg0_10:openUI("countdown")
end

function var0_0.initOpenUISwich(arg0_11)
	var0_0.super.initOpenUISwich(arg0_11)

	arg0_11.openSwitchDic.main = nil

	function arg0_11.openSwitchDic.result()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-streamers")

		local var0_12 = arg0_11:GetMGData().id
		local var1_12 = arg0_11.gameController.point
		local var2_12 = getProxy(MiniGameProxy):GetHighScore(var0_12) / 100
		local var3_12 = arg0_11.rtTitlePage:Find("result")

		setActive(var3_12:Find("window/now/new"), var2_12 < var1_12)

		if var2_12 <= var1_12 then
			var2_12 = var1_12

			getProxy(MiniGameProxy):UpdataHighScore(var0_12, math.floor(var1_12 * 100))
		end

		setText(var3_12:Find("window/high/Text"), string.format("%.2fm", var2_12))
		setText(var3_12:Find("window/now/Text"), string.format("%.2fm", var1_12))

		local var4_12 = arg0_11:GetMGHubData()

		arg0_11:emit(BaseMiniGameMediator.GAME_FINISH_TRACKING, {
			game_id = var0_12,
			hub_id = var4_12.id,
			isComplete = arg0_11.gameController.result
		})

		if (not arg0_11:getShowSide() or arg0_11.stageIndex == var4_12.usedtime + 1) and var4_12.count > 0 then
			arg0_11:SendSuccess(0)
		end
	end

	function arg0_11.openSwitchDic.countdown()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_STEP_PILE_COUNTDOWN)
	end
end

function var0_0.willExit(arg0_14)
	arg0_14.gameController:willExit()
end

return var0_0
