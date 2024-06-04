local var0 = class("DeleteCollectionMailCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(MailProxy)

	if var1:getCollecitonMail(var0) == nil then
		print("邮件不存在: " .. var0)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30008, {
		mail_id = var0
	}, 30009, function(arg0)
		if arg0.result == 0 then
			var1:removeCollectionMail(var0)
			arg0:sendNotification(GAME.DELETE_COLLECTION_MAIL_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
