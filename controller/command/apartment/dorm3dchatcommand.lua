local var0_0 = class("Dorm3dChatCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(Dorm3dChatProxy)

	if var0_1.operation == Dorm3dChatProxy.APARTMENT_CHAT_REPLY then
		pg.ConnectionMgr.GetInstance():Send(28028, {
			type = 1,
			ship_id = var0_1.characterId,
			id = var0_1.topicId,
			chat_id = var0_1.wordId,
			value = var0_1.replyId
		}, 28029, function(arg0_2)
			if arg0_2.result == 0 then
				var1_1:SetTopicReaded(var0_1.topicId, 0)
				var1_1:UpdateTopicDisplayWordList(var0_1.topicId, var0_1.wordId, var0_1.replyId)

				if var0_1.isRedPacket then
					local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

					arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP_DONE, {
						operation = var0_1.operation,
						awards = var0_2,
						redPacketId = var0_1.replyId
					})
				else
					arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP_DONE, {
						operation = var0_1.operation
					})
				end

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
			end
		end)
	elseif var0_1.operation == Dorm3dChatProxy.APARTMENT_CHAT_SET_SKIN then
		pg.ConnectionMgr.GetInstance():Send(28030, {
			ship_id = var0_1.characterId,
			back_id = var0_1.skinId
		}, 28031, function(arg0_3)
			if arg0_3.result == 0 then
				var1_1:SetChatSkin(var0_1.characterId, var0_1.skinId)
				arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	elseif var0_1.operation == Dorm3dChatProxy.APARTMENT_CHAT_SET_CARE then
		pg.ConnectionMgr.GetInstance():Send(28032, {
			ship_id = var0_1.characterId,
			value = var0_1.care
		}, 28033, function(arg0_4)
			if arg0_4.result == 0 then
				var1_1:GetCharacterChatById(var0_1.characterId):SetCare(var0_1.care)
				arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end)
	elseif var0_1.operation == Dorm3dChatProxy.APARTMENT_CHAT_SET_TOPIC then
		pg.ConnectionMgr.GetInstance():Send(28034, {
			ship_id = var0_1.characterId,
			comm_id = var0_1.topicId
		}, 28035, function(arg0_5)
			if arg0_5.result == 0 then
				var1_1:SetCurrentTopic(var0_1.topicId)
				arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
			end
		end)
	elseif var0_1.operation == Dorm3dChatProxy.APARTMENT_CHAT_SET_READTIP then
		pg.ConnectionMgr.GetInstance():Send(28026, {
			type = 1,
			ship_id = var0_1.characterId,
			id_list = var0_1.topicIdList
		}, 28027, function(arg0_6)
			if arg0_6.result == 0 then
				if var0_1.topicIdList and #var0_1.topicIdList > 0 then
					for iter0_6, iter1_6 in ipairs(var0_1.topicIdList) do
						var1_1:SetTopicReaded(iter1_6, 1)
					end
				end

				arg0_1:sendNotification(GAME.APARTMENT_CHAT_OP_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_6.result] .. arg0_6.result)
			end
		end)
	elseif var0_1.operation == Dorm3dChatProxy.APARTMENT_CHAT_TRIGGER_EVENT then
		pg.ConnectionMgr.GetInstance():Send(28023, {
			event_list = var0_1.eventList
		}, 28024, function(arg0_7)
			if arg0_7.result == 0 then
				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.result)
			end
		end)
	end
end

return var0_0
