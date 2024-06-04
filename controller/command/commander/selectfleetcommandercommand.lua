local var0 = class("SelectFleetCommanderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.fleetId
	local var2 = var0.pos
	local var3 = var0.commanderId
	local var4 = var0.callback
	local var5 = getProxy(FleetProxy):getFleetById(var1)
	local var6 = var5:getCommanderByPos(var2)
	local var7 = var5:getCommanders()

	if not var6 or var6.id ~= var3 then
		local var8 = getProxy(CommanderProxy):getCommanderById(var3)

		for iter0, iter1 in pairs(var7) do
			if iter1.groupId == var8.groupId and iter0 ~= var2 and var3 ~= iter1.id then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

				return
			end
		end
	end

	local function var9(arg0)
		local var0 = getProxy(FleetProxy):getCommanders()

		for iter0, iter1 in ipairs(var0) do
			if iter1.fleetId ~= var1 and iter1.commanderId == arg0 then
				return true, iter1
			end
		end

		return false
	end

	local function var10(arg0)
		local var0 = var2 == 2 and 1 or 2
		local var1 = var7[var0]

		if var1 and var1.id == arg0 then
			return true, var0
		end

		return false
	end

	local var11 = {}
	local var12 = true
	local var13, var14 = var9(var3)

	if var13 then
		table.insert(var11, function(arg0)
			local var0 = var14.pos == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
			local var1 = Fleet.DEFAULT_NAME[var14.fleetId]

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("comander_repalce_tip", var1, var0),
				onYes = function()
					pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						fleetId = var14.fleetId,
						pos = var14.pos,
						callback = arg0
					})
				end,
				onNo = function()
					var12 = false

					arg0()
				end
			})
		end)
	end

	local var15, var16 = var10(var3)

	if var15 then
		table.insert(var11, function(arg0)
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var1,
				pos = var16,
				callback = arg0
			})
		end)
	end

	table.insert(var11, function(arg0)
		if var12 then
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				fleetId = var1,
				pos = var2,
				commanderId = var3,
				callback = function(arg0)
					arg0()
				end
			})
		else
			arg0()
		end
	end)
	seriesAsync(var11, var4)
end

return var0
