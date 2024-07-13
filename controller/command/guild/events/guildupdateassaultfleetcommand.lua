local var0_0 = class("GuildUpdateAssaultFleetCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.fleet
	local var2_1 = var0_1.callBack
	local var3_1 = getProxy(GuildProxy)
	local var4_1 = var3_1:getData()
	local var5_1 = var4_1:GetActiveEvent()

	if var5_1 then
		local var6_1 = var5_1:GetBossMission()

		if var6_1 and var6_1:IsActive() then
			pg.TipsMgr:GetInstance():ShowTips(i18n("guild_formation_erro_in_boss_battle"))

			return
		end
	end

	local var7_1 = getProxy(PlayerProxy):getRawData().id
	local var8_1 = var4_1:getMemberById(var7_1)
	local var9_1 = var8_1:GetExternalAssaultFleet()

	if not var9_1 then
		return
	end

	if not var1_1 then
		return
	end

	if not var9_1:AnyShipChanged(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_must_edit_fleet"))

		return
	end

	local var10_1 = {}
	local var11_1 = var1_1:GetShipList()

	for iter0_1, iter1_1 in pairs(var11_1) do
		if var9_1:PositionIsChanged(var1_1, iter0_1) then
			local var12_1 = GuildAssaultFleet.GetRealId(iter1_1.id)

			table.insert(var10_1, {
				pos = iter0_1,
				shipId = var12_1
			})
		end
	end

	pg.ConnectionMgr.GetInstance():Send(61003, {
		shipIds = var10_1
	}, 61004, function(arg0_2)
		if arg0_2.result == 0 then
			for iter0_2, iter1_2 in ipairs(var10_1) do
				local var0_2 = pg.TimeMgr.GetInstance():GetServerTime()

				var3_1:UpdatePosCdTime(iter1_2.pos, var0_2)
			end

			var8_1:UpdateAssaultFleet(var1_1)
			var8_1:UpdateExternalAssaultFleet(var1_1)
			var3_1:updateGuild(var4_1)
			arg0_1:sendNotification(GAME.GUILD_UPDATE_MY_ASSAULT_FLEET_DONE)
			pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildEvent")
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end

		if var2_1 then
			var2_1()
		end
	end)
end

return var0_0
