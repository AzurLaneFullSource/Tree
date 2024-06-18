local var0_0 = class("FourHourCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1, var1_1 = pcall(arg0_1.mainHandler, arg0_1)

	if not var0_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("four_hour_command_error"))
		error(var1_1)
	end
end

function var0_0.mainHandler(arg0_2, arg1_2)
	getProxy(TechnologyProxy):resetPursuingTimes()
	arg0_2:sendNotification(GAME.FOUR_HOUR_OP_DONE)
end

return var0_0
