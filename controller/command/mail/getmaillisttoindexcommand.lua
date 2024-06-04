local var0 = class("GetMailListToIndexCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.index
	local var2 = var0.callback
	local var3 = getProxy(MailProxy)
	local var4

	local function var5(arg0)
		local var0 = 1
		local var1, var2 = getProxy(MailProxy):GetNextIndex()

		pg.ConnectionMgr.GetInstance():Send(30002, {
			type = 1,
			index_begin = var1,
			index_end = var2
		}, 30003, function(arg0)
			local var0 = underscore.map(arg0.mail_list, function(arg0)
				return Mail.New(arg0)
			end)

			var3:AddNextMails(var0)

			if #var3.ids < var1 then
				var5(arg0)
			else
				arg0()
			end
		end)
	end

	var5(function()
		existCall(var2)
		arg0:sendNotification(GAME.GET_MAIL_LIST_TO_INDEX_DONE)
	end)
end

return var0
