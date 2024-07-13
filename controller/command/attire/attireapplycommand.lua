local var0_0 = class("AttireApplyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.type

	if not getProxy(AttireProxy):getAttireFrame(var2_1, var1_1) then
		return
	end

	local var3_1 = getProxy(PlayerProxy)
	local var4_1 = var3_1:getData()

	pg.ConnectionMgr.GetInstance():Send(11005, {
		id = var1_1,
		type = var2_1
	}, 11006, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:updateAttireFrame(var2_1, var1_1)
			var3_1:updatePlayer(var4_1)
			arg0_1:sendNotification(GAME.ATTIRE_APPLY_DONE)
		else
			print(arg0_2.result)
		end
	end)
end

return var0_0
