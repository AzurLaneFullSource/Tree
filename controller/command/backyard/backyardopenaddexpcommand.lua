local var0 = class("BackYardOpenAddExpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	print("add exp ::", var0)
	pg.ConnectionMgr.GetInstance():Send(19015, {
		is_open = var0
	})
	arg0:sendNotification(GAME.OPEN_ADD_EXP_DONE)
end

return var0
