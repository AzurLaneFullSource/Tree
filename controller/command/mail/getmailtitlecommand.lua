local var0 = class("GetMailTitleCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.callback
	local var2 = var0.mailList

	pg.ConnectionMgr.GetInstance():Send(30014, {
		id_list = var2
	}, 30015, function(arg0)
		var1(arg0.mail_title_list)
	end)
end

return var0
