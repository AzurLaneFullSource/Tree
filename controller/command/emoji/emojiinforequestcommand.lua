local var0 = class("EmojiInfoRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11601, {
		type = 0
	}, 11602, function(arg0)
		if arg0.emoji_list then
			print("request emoji info success")

			local var0 = getProxy(EmojiProxy)

			for iter0, iter1 in ipairs(arg0.emoji_list) do
				if pg.emoji_template[iter1].achieve == 1 then
					var0:addToEmojiIDLIst(iter1)
				end
			end

			var0:loadNewEmojiIDList()
			var0:setInitedTag()
			arg0:sendNotification(GAME.REQUEST_EMOJI_INFO_FROM_SERVER_DONE)
		end
	end)
end

return var0
