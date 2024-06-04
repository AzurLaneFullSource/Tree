local var0 = class("FourHourCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0, var1 = pcall(arg0.mainHandler, arg0)

	if not var0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("four_hour_command_error"))
		error(var1)
	end
end

function var0.mainHandler(arg0, arg1)
	getProxy(TechnologyProxy):resetPursuingTimes()
	arg0:sendNotification(GAME.FOUR_HOUR_OP_DONE)
end

return var0
