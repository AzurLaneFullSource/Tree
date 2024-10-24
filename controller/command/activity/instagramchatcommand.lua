local var0_0 = class("InstagramChatCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(InstagramChatProxy)

	if var0_1.operation == ActivityConst.INSTAGRAM_CHAT_GET_DATA then
		pg.ConnectionMgr.GetInstance():Send(11710, {
			type = 0
		}, 11711, function(arg0_2)
			local var0_2 = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.groups) do
				local var1_2 = InstagramChat.New(iter1_2)

				table.insert(var0_2, var1_2)
			end

			var1_1:SetChatList(var0_2)
			arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
				operation = var0_1.operation
			})

			if var0_1.callback then
				var0_1.callback()
			end
		end)
	elseif var0_1.operation == ActivityConst.INSTAGRAM_CHAT_REPLY then
		pg.ConnectionMgr.GetInstance():Send(11712, {
			chat_group_id = var0_1.topicId,
			chat_id = var0_1.wordId,
			value = var0_1.replyId
		}, 11713, function(arg0_3)
			if arg0_3.result == 0 then
				var1_1:SetTopicOperationTime(var0_1.topicId, arg0_3.op_time)
				var1_1:SetTopicReaded(var0_1.topicId, 0)
				var1_1:UpdateTopicDisplayWordList(var0_1.topicId, var0_1.wordId, var0_1.replyId)

				if var0_1.isRedPacket then
					local var0_3 = PlayerConst.addTranDrop(arg0_3.drop_list)

					arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
						operation = var0_1.operation,
						awards = var0_3,
						redPacketId = var0_1.replyId
					})
				else
					arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
						operation = var0_1.operation
					})
				end

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	elseif var0_1.operation == ActivityConst.INSTAGRAM_CHAT_SET_SKIN then
		pg.ConnectionMgr.GetInstance():Send(11714, {
			group_id = var0_1.characterId,
			skin_id = var0_1.skinId
		}, 11715, function(arg0_4)
			if arg0_4.result == 0 then
				var1_1:SetChatSkin(var0_1.characterId, var0_1.skinId)
				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_4.result] .. arg0_4.result)
			end
		end)
	elseif var0_1.operation == ActivityConst.INSTAGRAM_CHAT_SET_CARE then
		pg.ConnectionMgr.GetInstance():Send(11716, {
			group_id = var0_1.characterId,
			value = var0_1.care
		}, 11717, function(arg0_5)
			if arg0_5.result == 0 then
				var1_1:GetCharacterChatById(var0_1.characterId):SetCare(var0_1.care)
				var1_1:SortChatList()
				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_5.result] .. arg0_5.result)
			end
		end)
	elseif var0_1.operation == ActivityConst.INSTAGRAM_CHAT_SET_TOPIC then
		pg.ConnectionMgr.GetInstance():Send(11718, {
			chat_group_id = var0_1.topicId
		}, 11719, function(arg0_6)
			if arg0_6.result == 0 then
				var1_1:SetCurrentTopic(var0_1.topicId)
				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_6.result] .. arg0_6.result)
			end
		end)
	elseif var0_1.operation == ActivityConst.INSTAGRAM_CHAT_SET_READTIP then
		pg.ConnectionMgr.GetInstance():Send(11720, {
			chat_group_id_list = var0_1.topicIdList
		}, 11721, function(arg0_7)
			if arg0_7.result == 0 then
				if var0_1.topicIdList and #var0_1.topicIdList > 0 then
					for iter0_7, iter1_7 in ipairs(var0_1.topicIdList) do
						var1_1:SetTopicReaded(iter1_7, 1)
					end
				else
					var1_1:SetAllTopicsReaded()
				end

				arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.result)
			end
		end)
	elseif var0_1.operation == ActivityConst.INSTAGRAM_CHAT_ACTIVATE_TOPIC then
		pg.ConnectionMgr.GetInstance():Send(11722, {
			chat_group_id_list = var0_1.topicIdList
		}, 11723, function(arg0_8)
			for iter0_8, iter1_8 in ipairs(arg0_8.result_list) do
				if iter1_8 == 0 then
					local var0_8

					if var1_1:GetCharacterChatByTopicId(var0_1.topicIdList[iter0_8]) then
						var1_1:GetTopicById(var0_1.topicIdList[iter0_8]):Activate(arg0_8.op_time)
					else
						var1_1:CreateNewChat(var0_1.topicIdList[iter0_8], arg0_8.op_time)
					end

					var1_1:RemoveNotActiveTopicId(var0_1.topicIdList[iter0_8])
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[iter1_8] .. iter1_8)
				end
			end

			var1_1:SortChatList()
			arg0_1:sendNotification(GAME.ACT_INSTAGRAM_CHAT_DONE, {
				operation = var0_1.operation
			})

			if var0_1.callback then
				var0_1.callback()
			end
		end)
	end
end

return var0_0
