local var0_0 = class("MiniGameTimeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id or 0
	local var2_1 = var0_1.time

	pg.ConnectionMgr.GetInstance():Send(26110, {
		gameid = var1_1,
		time = math.floor(var2_1)
	})
end

return var0_0
