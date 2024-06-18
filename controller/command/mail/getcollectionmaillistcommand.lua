local var0_0 = class("GetCollectionMailListCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback
	local var1_1 = getProxy(MailProxy)

	if var1_1.collectionIds then
		return
	end

	var1_1.collectionIds = {}

	local var2_1

	local function var3_1(arg0_2)
		local var0_2 = #var1_1.collectionIds + 1
		local var1_2 = #var1_1.collectionIds + SINGLE_MAIL_REQUIRE_SIZE

		pg.ConnectionMgr.GetInstance():Send(30004, {
			index_begin = var0_2,
			index_end = var1_2
		}, 30005, function(arg0_3)
			local var0_3 = underscore.map(arg0_3.mail_list, function(arg0_4)
				return BaseMail.New(arg0_4)
			end)

			var1_1:AddCollectionMails(var0_3)

			if #var0_3 < SINGLE_MAIL_REQUIRE_SIZE then
				arg0_2()
			else
				var3_1(arg0_2)
			end
		end)
	end

	var3_1(function()
		existCall(var0_1)
		arg0_1:sendNotification(GAME.GET_COLLECTION_MAIL_LIST_DONE)
	end)
end

return var0_0
