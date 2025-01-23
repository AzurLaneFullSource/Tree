local var0_0 = class("NewEducateSelTopicCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.topicId

	pg.ConnectionMgr.GetInstance():Send(29017, {
		id = var1_1,
		chat_id = var2_1
	}, 29018, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetStystemNo(NewEducateFSM.STYSTEM.TOPIC)
			var0_2:GetState(NewEducateFSM.STYSTEM.TOPIC):MarkFinish()
			var0_2:SetCurNode(arg0_2.first_node)

			local var1_2 = NewEducateHelper.MergeDrops(arg0_2.drop)

			NewEducateHelper.UpdateDropsData(var1_2)
			arg0_1:sendNotification(GAME.NEW_EDUCATE_SEL_TOPIC_DONE, {
				drops = NewEducateHelper.FilterBenefit(var1_2),
				node = arg0_2.first_node
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("NewEducate_SelTopic", arg0_2.result))
		end
	end)
end

return var0_0
