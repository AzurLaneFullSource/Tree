local var0_0 = class("IslandSendChatCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.channel
	local var2_1 = var0_1.islandId
	local var3_1 = var0_1.msg

	if var3_1 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("main_notificationLayer_sendButton"))

		return
	end

	local var4_1 = getProxy(PlayerProxy):getRawData()
	local var5_1 = 0

	if var1_1 == IslandChatConst.CHANNEL_ISLAND then
		local var6_1 = getProxy(IslandProxy):GetChatMsgList(var2_1)

		for iter0_1 = #var6_1, 1, -1 do
			if var6_1[iter0_1].player.id == var4_1.id then
				var5_1 = var6_1[iter0_1].timestamp

				break
			end
		end
	else
		local var7_1 = getProxy(ChatProxy):getRawData()

		for iter1_1 = #var7_1, 1, -1 do
			if var7_1[iter1_1].type == ChatConst.ChannelWorld and var7_1[iter1_1].player.id == var4_1.id then
				var5_1 = var7_1[iter1_1].timestamp

				break
			end
		end
	end

	local var8_1 = pg.TimeMgr.GetInstance():GetServerTime()

	if var8_1 < var4_1.chatMsgBanTime then
		local var9_1 = os.date("%Y/%m/%d %H:%M:%S", var4_1.chatMsgBanTime)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("chat_msg_ban", var9_1)
		})
	elseif PLATFORM_CODE == PLATFORM_CH and LuaHelper.GetCHPackageType() ~= PACKAGE_TYPE_BILI and var4_1.level < 70 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("chat_level_not_enough", 70))
	elseif var4_1.level < 10 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("chat_level_not_enough", 10))
	elseif var8_1 - var5_1 < 10 then
		local var10_1 = 10 - (var8_1 - var5_1)

		pg.TipsMgr.GetInstance():ShowTips(i18n("dont_send_message_frequently", var10_1))
	else
		arg0_1:Send(var1_1, var2_1, var3_1)
	end
end

function var0_0.Send(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2, var1_2 = wordVer(arg3_2, {
		isReplace = true
	})

	if arg1_2 == IslandChatConst.CHANNEL_ISLAND then
		pg.ConnectionMgr.GetInstance():Send(21323, {
			island_id = arg2_2,
			content = var1_2
		}, 21324, function(arg0_3)
			if arg0_3.result == 0 then
				-- block empty
			else
				pg.TipsMgr.GetInstance():ShowTips(arg0_3.tip)
			end
		end)
	elseif arg1_2 == IslandChatConst.CHANNEL_WORLD then
		arg0_2:sendNotification(GAME.SEND_MSG, var1_2)
	elseif arg1_2 == IslandChatConst.CHANNEL_GUILD then
		arg0_2:sendNotification(GAME.GUILD_SEND_MSG, var1_2)
	end
end

return var0_0
