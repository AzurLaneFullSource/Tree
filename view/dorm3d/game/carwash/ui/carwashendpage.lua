local var0_0 = class("CarWashEndPage", import("view.dorm3d.Game.Dorm3dGameBaseSubView"))

function var0_0.Init(arg0_1)
	arg0_1:InitUI()
	arg0_1:BindEvent()
	arg0_1:Hide()
end

function var0_0.InitUI(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("btn_again"), function()
		arg0_2:emit(CarWashGameFlowSystem.REQUEST_RESTART_GAME)
	end)
	onButton(arg0_2, arg0_2._tf:Find("btn_exit"), function()
		arg0_2:emit(BaseUI.ON_BACK)
	end)

	arg0_2.cleanRank = arg0_2._tf:Find("rank")

	setText(arg0_2._tf:Find("btn_again/text"), i18n("dorm3d_carwash_retry"))
	setText(arg0_2._tf:Find("btn_exit/text"), i18n("dorm3d_carwash_exit"))
end

function var0_0.BindEvent(arg0_5)
	arg0_5:bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_6, arg1_6)
		if arg1_6.newValue == CarWashConst.GAME_STATE.END then
			arg0_5:Show()
			arg0_5:FlushCleanPersent()
		else
			arg0_5:Hide()
		end
	end)
end

function var0_0.Flush(arg0_7)
	return
end

function var0_0.FlushCleanPersent(arg0_8)
	local var0_8 = arg0_8:GetCleanPersent()
	local var1_8 = arg0_8:GetRank(var0_8)

	eachChild(arg0_8.cleanRank, function(arg0_9)
		setActive(arg0_9, arg0_9.name == var1_8)
	end)
end

function var0_0.GetCleanPersent(arg0_10)
	if arg0_10.contextData.gameStatus.stainsCountMax == 0 then
		return 0
	end

	local var0_10 = 1 - arg0_10.contextData.gameStatus.stainsCount / arg0_10.contextData.gameStatus.stainsCountMax

	return (math.floor(var0_10 * 100))
end

function var0_0.GetRank(arg0_11, arg1_11)
	return CarWashConst.GetScoreRank(arg1_11)
end

return var0_0
