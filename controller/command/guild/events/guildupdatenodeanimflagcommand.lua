local var0 = class("GuildUpdateNodeAnimFlagCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.position

	if not arg0:ExistMission(var1) then
		return
	end

	local var3 = {
		event_id = var1,
		index = var2
	}

	pg.ConnectionMgr.GetInstance():Send(61025, {
		perf = {
			var3
		}
	}, 61026, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(GuildProxy)
			local var1 = var0:getData()

			var1:GetActiveEvent():GetMissionById(var1):UpdateNodeAnimFlagIndex(var2)
			var0:updateGuild(var1)
			arg0:sendNotification(GAME.GUILD_UPDATE_NODE_ANIM_FLAG_DONE, {
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
