local var0 = class("GuildUpdateBossMissionFleetCommand", import(".GuildEventBaseCommand"))

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.editFleet
	local var2 = var0.callback
	local var3 = var0.force

	if not arg0:ExistBoss() then
		return
	end

	local function var4(arg0)
		if table.getCount(arg0) == 0 then
			if var2 then
				var2()
			end

			return
		end

		pg.ConnectionMgr.GetInstance():Send(61013, {
			fleet = arg0
		}, 61014, function(arg0)
			if arg0.result == 0 then
				local var0 = getProxy(GuildProxy)
				local var1 = var0:getData()
				local var2 = var1:GetActiveEvent():GetBossMission()

				for iter0, iter1 in pairs(var1) do
					var2:UpdateFleet(iter1)
				end

				var0:updateGuild(var1)
				arg0:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION_DONE)
				pg.ShipFlagMgr:GetInstance():UpdateFlagShips("inGuildBossEvent")

				if var2 then
					var2()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end

	local var5 = {}

	for iter0, iter1 in pairs(var1) do
		if not var3 then
			local var6, var7 = iter1:IsLegal()

			if not var6 then
				pg.TipsMgr.GetInstance():ShowTips(var7)

				return
			end
		end

		iter1:ClearInvaildShip()
		iter1:RemoveInvaildCommanders()

		local var8 = arg0:WarpData(iter1)

		table.insert(var5, var8)
	end

	var4(var5)
end

function var0.WarpData(arg0, arg1)
	local var0 = {}
	local var1 = arg1:GetShipIds()

	for iter0, iter1 in ipairs(var1) do
		if arg1:ExistMember(iter1.uid) then
			table.insert(var0, {
				user_id = iter1.uid,
				ship_id = iter1.id
			})
		end
	end

	local var2 = {}
	local var3 = arg1:getCommanders()

	for iter2, iter3 in pairs(var3) do
		table.insert(var2, {
			pos = iter2,
			id = iter3.id
		})
	end

	return {
		fleet_id = arg1.id,
		ships = var0,
		commanders = var2
	}
end

return var0
