local var0 = class("SendMsgCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(50102, {
		type = 1,
		content = var0
	})
end

return var0
