local var0_0 = class("BackYardOpenAddExpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	print("add exp ::", var0_1)
	pg.ConnectionMgr.GetInstance():Send(19015, {
		is_open = var0_1
	})
	arg0_1:sendNotification(GAME.OPEN_ADD_EXP_DONE)
end

return var0_0
