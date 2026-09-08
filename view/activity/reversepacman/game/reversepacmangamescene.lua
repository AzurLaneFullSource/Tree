local var0_0 = class("ReversePacmanGameScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ReversePacmanGameUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiTopTF:Find("back"), function()
		arg0_2:onBackPressed()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiTopTF:Find("home"), function()
		arg0_2:quickExitFunc()
	end, SOUND_BACK)

	arg0_2.settleSubView = ReversePacmanSettleSubView.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
end

function var0_0.didEnter(arg0_5)
	arg0_5.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_REVERSE_PACMAN)
	arg0_5.gameControl = ReversePacmanGameController.New(arg0_5, arg0_5._tf)

	arg0_5.gameControl:SetUp(arg0_5.contextData.levelId, arg0_5.contextData.slotShipIds, arg0_5.contextData.buffIds, arg0_5.contextData.buffCnts, arg0_5.contextData.eduBuffCnt)
end

function var0_0.GameOver(arg0_6, arg1_6)
	arg0_6.settleData = arg1_6

	if arg0_6.settleData.result == ReversePacmanConst.RESULT_TYPE.SUCCESS then
		arg0_6:emit(ReversePacmanGameMediator.SETTLE_GAME, {
			actId = arg0_6.activity.id,
			levelId = arg0_6.contextData.levelId,
			time = arg0_6.settleData.useTime
		})
	else
		arg0_6:ShowSettlePanel()
	end
end

function var0_0.ShowSettlePanel(arg0_7, arg1_7)
	local var0_7 = setmetatable({
		awards = arg1_7 or {}
	}, {
		__index = arg0_7.settleData
	})

	arg0_7.settleSubView:ExecuteAction("Show", var0_7, function()
		arg0_7:onBackPressed()
	end)
end

function var0_0.willExit(arg0_9)
	if arg0_9.settleSubView then
		arg0_9.settleSubView:Destroy()

		arg0_9.settleSubView = nil
	end

	arg0_9.gameControl:Dispose()
end

return var0_0
