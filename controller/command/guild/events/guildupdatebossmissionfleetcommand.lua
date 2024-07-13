local var0_0 = class("GuildUpdateBossMissionFleetCommand", import(".GuildEventBaseCommand"))

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.editFleet
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.force

	if not arg0_1:ExistBoss() then
		return
	end

	local function var4_1(arg0_2)
		if table.getCount(arg0_2) == 0 then
			if var2_1 then
				var2_1()
			end

			return
		end

		pg.ConnectionMgr.GetInstance():Send(61013, {
			fleet = arg0_2
		}, 61014, function(arg0_3)
			if arg0_3.result == 0 then
				local var0_3 = getProxy(GuildProxy)
				local var1_3 = var0_3:getData()
				local var2_3 = var1_3:GetActiveEvent():GetBossMission()

				for iter0_3, iter1_3 in pairs(var1_1) do
					var2_3:UpdateFleet(iter1_3)
				end

				var0_3:updateGuild(var1_3)
				arg0_1:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION_DONE)
				pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildBossEvent")

				if var2_1 then
					var2_1()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
			end
		end)
	end

	local var5_1 = {}

	for iter0_1, iter1_1 in pairs(var1_1) do
		if not var3_1 then
			local var6_1, var7_1 = iter1_1:IsLegal()

			if not var6_1 then
				pg.TipsMgr.GetInstance():ShowTips(var7_1)

				return
			end
		end

		iter1_1:ClearInvaildShip()
		iter1_1:RemoveInvaildCommanders()

		local var8_1 = arg0_1:WarpData(iter1_1)

		table.insert(var5_1, var8_1)
	end

	var4_1(var5_1)
end

function var0_0.WarpData(arg0_4, arg1_4)
	local var0_4 = {}
	local var1_4 = arg1_4:GetShipIds()

	for iter0_4, iter1_4 in ipairs(var1_4) do
		if arg1_4:ExistMember(iter1_4.uid) then
			table.insert(var0_4, {
				user_id = iter1_4.uid,
				ship_id = iter1_4.id
			})
		end
	end

	local var2_4 = {}
	local var3_4 = arg1_4:getCommanders()

	for iter2_4, iter3_4 in pairs(var3_4) do
		table.insert(var2_4, {
			pos = iter2_4,
			id = iter3_4.id
		})
	end

	return {
		fleet_id = arg1_4.id,
		ships = var0_4,
		commanders = var2_4
	}
end

return var0_0
