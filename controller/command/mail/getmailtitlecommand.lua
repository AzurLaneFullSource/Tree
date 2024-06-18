local var0_0 = class("GetMailTitleCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.callback
	local var2_1 = var0_1.mailList

	pg.ConnectionMgr.GetInstance():Send(30014, {
		id_list = var2_1
	}, 30015, function(arg0_2)
		var1_1(arg0_2.mail_title_list)
	end)
end

return var0_0
