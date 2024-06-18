local var0_0 = class("HandleOverDueAttireCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = getProxy(AttireProxy):getExpiredChaces()

	if #var0_1 > 0 then
		arg0_1:sendNotification(GAME.HANDLE_OVERDUE_ATTIRE_DONE, var0_1)
	end
end

return var0_0
