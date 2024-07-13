local var0_0 = class("NewBossExperimentResultStatisticsPage", import("..hpShareActBoss.NewHpShareActBossResultStatisticsPage"))

function var0_0.GetTicketUseCount(arg0_1)
	return 0
end

function var0_0.UpdateTicket(arg0_2, arg1_2)
	var0_0.super.UpdateTicket(arg0_2, arg1_2)

	local var0_2 = arg1_2:Find("playAgain/ticket/checkbox")

	triggerToggle(var0_2, false)
	setToggleEnabled(var0_2, false)
end

function var0_0.OnPlayAgain(arg0_3, arg1_3)
	arg0_3:emit(NewBattleResultMediator.REENTER_STAGE)
end

return var0_0
