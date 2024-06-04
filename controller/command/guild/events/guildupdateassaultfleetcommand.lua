local var0 = class("GuildUpdateAssaultFleetCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.fleet
	local var2 = var0.callBack
	local var3 = getProxy(GuildProxy)
	local var4 = var3:getData()
	local var5 = var4:GetActiveEvent()

	if var5 then
		local var6 = var5:GetBossMission()

		if var6 and var6:IsActive() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end
	end

	local var7 = getProxy(PlayerProxy):getRawData().id
	local var8 = var4:getMemberById(var7)
	local var9 = var8:GetExternalAssaultFleet()

	if not var9 then
		return
	end

	if not var1 then
		return
	end

	if not var9:AnyShipChanged(var1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_must_edit_fleet"))

		return
	end

	local var10 = {}
	local var11 = var1:GetShipList()

	for iter0, iter1 in pairs(var11) do
		if var9:PositionIsChanged(var1, iter0) then
			local var12 = GuildAssaultFleet.GetRealId(iter1.id)

			table.insert(var10, {
				pos = iter0,
				shipId = var12
			})
		end
	end

	pg.ConnectionMgr.GetInstance():Send(61003, {
		shipIds = var10
	}, 61004, function(arg0)
		if arg0.result == 0 then
			for iter0, iter1 in ipairs(var10) do
				local var0 = pg.TimeMgr.GetInstance():GetServerTime()

				var3:UpdatePosCdTime(iter1.pos, var0)
			end

			var8:UpdateAssaultFleet(var1)
			var8:UpdateExternalAssaultFleet(var1)
			var3:updateGuild(var4)
			arg0:sendNotification(GAME.GUILD_UPDATE_MY_ASSAULT_FLEET_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end

		if var2 then
			var2()
		end
	end)
end

return var0
