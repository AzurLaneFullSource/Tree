local var0_0 = class("EmojiInfoRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11601, {
		type = 0
	}, 11602, function(arg0_2)
		if arg0_2.emoji_list then
			print("request emoji info success")

			local var0_2 = getProxy(EmojiProxy)

			for iter0_2, iter1_2 in ipairs(arg0_2.emoji_list) do
				if pg.emoji_template[iter1_2].achieve == 1 then
					var0_2:addToEmojiIDLIst(iter1_2)
				end
			end

			var0_2:loadNewEmojiIDList()
			var0_2:setInitedTag()
			arg0_1:sendNotification(GAME.REQUEST_EMOJI_INFO_FROM_SERVER_DONE)
		end
	end)
end

return var0_0
