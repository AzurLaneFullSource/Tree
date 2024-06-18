local var0_0 = class("GuildUpdateNodeAnimFlagCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.position

	if not arg0_1:ExistMission(var1_1) then
		return
	end

	local var3_1 = {
		event_id = var1_1,
		index = var2_1
	}

	pg.ConnectionMgr.GetInstance():Send(61025, {
		perf = {
			var3_1
		}
	}, 61026, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(GuildProxy)
			local var1_2 = var0_2:getData()

			var1_2:GetActiveEvent():GetMissionById(var1_1):UpdateNodeAnimFlagIndex(var2_1)
			var0_2:updateGuild(var1_2)
			arg0_1:sendNotification(GAME.GUILD_UPDATE_NODE_ANIM_FLAG_DONE, {
				id = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
