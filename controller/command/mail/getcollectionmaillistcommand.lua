local var0 = class("GetCollectionMailListCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().callback
	local var1 = getProxy(MailProxy)

	if var1.collectionIds then
		return
	end

	var1.collectionIds = {}

	local var2

	local function var3(arg0)
		local var0 = #var1.collectionIds + 1
		local var1 = #var1.collectionIds + SINGLE_MAIL_REQUIRE_SIZE

		pg.ConnectionMgr.GetInstance():Send(30004, {
			index_begin = var0,
			index_end = var1
		}, 30005, function(arg0)
			local var0 = underscore.map(arg0.mail_list, function(arg0)
				return BaseMail.New(arg0)
			end)

			var1:AddCollectionMails(var0)

			if #var0 < SINGLE_MAIL_REQUIRE_SIZE then
				arg0()
			else
				var3(arg0)
			end
		end)
	end

	var3(function()
		existCall(var0)
		arg0:sendNotification(GAME.GET_COLLECTION_MAIL_LIST_DONE)
	end)
end

return var0
