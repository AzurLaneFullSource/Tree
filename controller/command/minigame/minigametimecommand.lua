local var0 = class("MiniGameTimeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id or 0
	local var2 = var0.time

	pg.ConnectionMgr.GetInstance():Send(26110, {
		gameid = var1,
		time = math.floor(var2)
	})
end

return var0
