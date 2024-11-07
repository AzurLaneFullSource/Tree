local var0_0 = class("GameTrackingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().infos

	pg.ConnectionMgr.GetInstance():Send(10991, {
		infos = var0_1
	})
end

return var0_0
