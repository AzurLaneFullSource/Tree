local var0_0 = class("SelectFleetCommanderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.fleetId
	local var2_1 = var0_1.pos
	local var3_1 = var0_1.commanderId
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(FleetProxy):getFleetById(var1_1)
	local var6_1 = var5_1:getCommanderByPos(var2_1)
	local var7_1 = var5_1:getCommanders()

	if not var6_1 or var6_1.id ~= var3_1 then
		local var8_1 = getProxy(CommanderProxy):getCommanderById(var3_1)

		for iter0_1, iter1_1 in pairs(var7_1) do
			if iter1_1.groupId == var8_1.groupId and iter0_1 ~= var2_1 and var3_1 ~= iter1_1.id then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

				return
			end
		end
	end

	local function var9_1(arg0_2)
		local var0_2 = getProxy(FleetProxy):getCommanders()

		for iter0_2, iter1_2 in ipairs(var0_2) do
			if iter1_2.fleetId ~= var1_1 and iter1_2.commanderId == arg0_2 then
				return true, iter1_2
			end
		end

		return false
	end

	local function var10_1(arg0_3)
		local var0_3 = var2_1 == 2 and 1 or 2
		local var1_3 = var7_1[var0_3]

		if var1_3 and var1_3.id == arg0_3 then
			return true, var0_3
		end

		return false
	end

	local var11_1 = {}
	local var12_1 = true
	local var13_1, var14_1 = var9_1(var3_1)

	if var13_1 then
		table.insert(var11_1, function(arg0_4)
			local var0_4 = var14_1.pos == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
			local var1_4 = Fleet.DEFAULT_NAME[var14_1.fleetId]

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("comander_repalce_tip", var1_4, var0_4),
				onYes = function()
					pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
						commanderId = 0,
						fleetId = var14_1.fleetId,
						pos = var14_1.pos,
						callback = arg0_4
					})
				end,
				onNo = function()
					var12_1 = false

					arg0_4()
				end
			})
		end)
	end

	local var15_1, var16_1 = var10_1(var3_1)

	if var15_1 then
		table.insert(var11_1, function(arg0_7)
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				commanderId = 0,
				fleetId = var1_1,
				pos = var16_1,
				callback = arg0_7
			})
		end)
	end

	table.insert(var11_1, function(arg0_8)
		if var12_1 then
			pg.m02:sendNotification(GAME.COOMMANDER_EQUIP_TO_FLEET, {
				fleetId = var1_1,
				pos = var2_1,
				commanderId = var3_1,
				callback = function(arg0_9)
					arg0_8()
				end
			})
		else
			arg0_8()
		end
	end)
	seriesAsync(var11_1, var4_1)
end

return var0_0
