local var0_0 = class("GetPhantomQuestProgressCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipIds
	local var2_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(12212, {
		ship_id_list = var1_1
	}, 12213, function(arg0_2)
		local var0_2 = {}

		underscore.each(arg0_2.ship_count_list, function(arg0_3)
			var0_2[arg0_3.key] = arg0_3.value
		end)
		getProxy(TechnologyProxy):updatePhantomQuestProgress(3, var0_2)
		existCall(var2_1)
		arg0_1:sendNotification(GAME.GET_PHANTOM_QUEST_PROGRESS_DONE)
	end)
end

return var0_0
