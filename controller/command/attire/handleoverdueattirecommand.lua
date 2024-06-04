local var0 = class("HandleOverDueAttireCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = getProxy(AttireProxy):getExpiredChaces()

	if #var0 > 0 then
		arg0:sendNotification(GAME.HANDLE_OVERDUE_ATTIRE_DONE, var0)
	end
end

return var0
