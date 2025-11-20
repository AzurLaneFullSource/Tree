local var0_0 = class("BossRushDALBattleResultLayer", import("..BossRushBattleResultLayer"))

function var0_0.didEnter(arg0_1)
	var0_0.super.didEnter(arg0_1)
	removeOnButton(arg0_1.rightBottomPanel:Find("confirmBtn"))
	onButton(arg0_1, arg0_1.rightBottomPanel:Find("confirmBtn"), function()
		arg0_1:emit(BossRushDALBattleResultMediator.ON_SETTLE)
	end, SFX_PANEL)
end

return var0_0
