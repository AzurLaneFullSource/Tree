local var0 = class("CheaterMarkCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().reason

	pg.ConnectionMgr.GetInstance():Send(10994, {
		type = var0
	}, 10995, function(arg0)
		if var0 ~= CC_TYPE_99 and var0 ~= CC_TYPE_100 then
			pg.m02:sendNotification(GAME.LOGOUT, {
				code = 7
			})
		end
	end)
end

return var0
