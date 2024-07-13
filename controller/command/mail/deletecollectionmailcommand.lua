local var0_0 = class("DeleteCollectionMailCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(MailProxy)

	if var1_1:getCollecitonMail(var0_1) == nil then
		print("邮件不存在: " .. var0_1)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30008, {
		mail_id = var0_1
	}, 30009, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:removeCollectionMail(var0_1)
			arg0_1:sendNotification(GAME.DELETE_COLLECTION_MAIL_DONE, var0_1)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
