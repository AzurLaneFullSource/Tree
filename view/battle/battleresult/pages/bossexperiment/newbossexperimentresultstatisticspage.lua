local var0 = class("NewBossExperimentResultStatisticsPage", import("..hpShareActBoss.NewHpShareActBossResultStatisticsPage"))

function var0.GetTicketUseCount(arg0)
	return 0
end

function var0.UpdateTicket(arg0, arg1)
	var0.super.UpdateTicket(arg0, arg1)

	local var0 = arg1:Find("playAgain/ticket/checkbox")

	triggerToggle(var0, false)
	setToggleEnabled(var0, false)
end

function var0.OnPlayAgain(arg0, arg1)
	arg0:emit(NewBattleResultMediator.REENTER_STAGE)
end

return var0
