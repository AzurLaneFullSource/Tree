local var0_0 = class("GetMailListToIndexCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.index
	local var2_1 = var0_1.callback
	local var3_1 = getProxy(MailProxy)
	local var4_1

	local function var5_1(arg0_2)
		local var0_2 = 1
		local var1_2, var2_2 = getProxy(MailProxy):GetNextIndex()

		pg.ConnectionMgr.GetInstance():Send(30002, {
			type = 1,
			index_begin = var1_2,
			index_end = var2_2
		}, 30003, function(arg0_3)
			local var0_3 = underscore.map(arg0_3.mail_list, function(arg0_4)
				return Mail.New(arg0_4)
			end)

			var3_1:AddNextMails(var0_3)

			if #var3_1.ids < var1_1 then
				var5_1(arg0_2)
			else
				arg0_2()
			end
		end)
	end

	var5_1(function()
		existCall(var2_1)
		arg0_1:sendNotification(GAME.GET_MAIL_LIST_TO_INDEX_DONE)
	end)
end

return var0_0
