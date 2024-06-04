local var0 = class("GuildSendMsgCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(60007, {
		chat = var0
	})
end

return var0
