local var0_0 = class("NewEducateGetTopicsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.id

	pg.ConnectionMgr.GetInstance():Send(29015, {
		id = var2_1
	}, 29016, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(NewEducateProxy):GetCurChar():GetFSM()

			var0_2:SetSystemNo(NewEducateFSM.SYSTEM.TOPIC)

			local var1_2 = NewEducateTopicState.New({
				finished = #arg0_2.chats == 0 and 1 or 0,
				chats = arg0_2.chats
			})

			var0_2:SetState(NewEducateFSM.SYSTEM.TOPIC, var1_2)
			existCall(var1_1)
		else
			pg.TipsMgr.GetInstance():ShowTips("NewEducate_GetTopics: " .. arg0_2.result)
		end
	end)
end

return var0_0
