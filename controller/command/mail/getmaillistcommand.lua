local var0 = class("GetMailListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.cmd
	local var2 = var0.callback
	local var3, var4, var5 = switch(var1, {
		new = function()
			return 1, getProxy(MailProxy):GetNewIndex()
		end,
		next = function()
			return 1, getProxy(MailProxy):GetNextIndex()
		end,
		important = function()
			return 2, 0, 0
		end,
		rare = function()
			return 3, 0, 0
		end
	})

	if var5 < var4 then
		warning("without mail can require")

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30002, {
		type = var3,
		index_begin = var4,
		index_end = var5
	}, 30003, function(arg0)
		local var0 = underscore.map(arg0.mail_list, function(arg0)
			return Mail.New(arg0)
		end)

		switch(var1, {
			new = function()
				getProxy(MailProxy):AddNewMails(var0)
			end,
			next = function()
				getProxy(MailProxy):AddNextMails(var0)
			end,
			important = function()
				getProxy(MailProxy):SetImportantMails(var0)
			end,
			rare = function()
				getProxy(MailProxy):SetRareMails(var0)
			end
		})
		existCall(var2)
		arg0:sendNotification(GAME.GET_MAIL_LIST_DONE)
	end)
end

return var0
