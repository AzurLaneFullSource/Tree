local var0_0 = class("GetMailListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.cmd
	local var2_1 = var0_1.callback
	local var3_1, var4_1, var5_1 = switch(var1_1, {
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

	if var5_1 < var4_1 then
		warning("without mail can require")

		return
	end

	pg.ConnectionMgr.GetInstance():Send(30002, {
		type = var3_1,
		index_begin = var4_1,
		index_end = var5_1
	}, 30003, function(arg0_6)
		local var0_6 = underscore.map(arg0_6.mail_list, function(arg0_7)
			return Mail.New(arg0_7)
		end)

		switch(var1_1, {
			new = function()
				getProxy(MailProxy):AddNewMails(var0_6)
			end,
			next = function()
				getProxy(MailProxy):AddNextMails(var0_6)
			end,
			important = function()
				getProxy(MailProxy):SetImportantMails(var0_6)
			end,
			rare = function()
				getProxy(MailProxy):SetRareMails(var0_6)
			end
		})
		existCall(var2_1)
		arg0_1:sendNotification(GAME.GET_MAIL_LIST_DONE)
	end)
end

return var0_0
