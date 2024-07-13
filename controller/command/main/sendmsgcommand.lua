local var0_0 = class("SendMsgCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(50102, {
		type = 1,
		content = var0_1
	})
end

return var0_0
