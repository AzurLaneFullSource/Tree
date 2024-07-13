local var0_0 = class("CheaterMarkCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().reason

	pg.ConnectionMgr.GetInstance():Send(10994, {
		type = var0_1
	}, 10995, function(arg0_2)
		if var0_1 ~= CC_TYPE_99 and var0_1 ~= CC_TYPE_100 then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 7
			})
		end
	end)
end

return var0_0
