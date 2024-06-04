local var0 = class("AttireApplyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.type

	if not getProxy(AttireProxy):getAttireFrame(var2, var1) then
		return
	end

	local var3 = getProxy(PlayerProxy)
	local var4 = var3:getData()

	pg.ConnectionMgr.GetInstance():Send(11005, {
		id = var1,
		type = var2
	}, 11006, function(arg0)
		if arg0.result == 0 then
			var4:updateAttireFrame(var2, var1)
			var3:updatePlayer(var4)
			arg0:sendNotification(GAME.ATTIRE_APPLY_DONE)
		else
			print(arg0.result)
		end
	end)
end

return var0
