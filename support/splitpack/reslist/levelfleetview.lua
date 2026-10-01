ResList = ResList or {}
ResList.LevelFleetView = {}

local var0_0 = ResList.LevelFleetView

function var0_0.GetResource(arg0_1)
	local var0_1 = {}

	table.insertto(var0_1, var0_0.GetShipResList(arg0_1))
	table.insertto(var0_1, var0_0.GetCommanderResList(arg0_1))
	table.insertto(var0_1, var0_0.GetTicketResList(arg0_1))

	return var0_1
end

function var0_0.GetShipResList(arg0_2)
	local var0_2 = {}

	if arg0_2.mode == 1 and arg0_2.fleets then
		_.each(arg0_2.fleets, function(arg0_3)
			var0_0.InsertFleetShipResList(arg0_2, var0_2, arg0_3)
		end)
	elseif arg0_2.mode == 2 then
		_.each(arg0_2.eliteFleetList or {}, function(arg0_4)
			var0_0.InsertShipIdsResList(arg0_2, var0_2, arg0_4)
		end)
		var0_0.InsertShipIdsResList(arg0_2, var0_2, arg0_2.supportFleet)
	end

	return var0_2
end

function var0_0.InsertFleetShipResList(arg0_5, arg1_5, arg2_5)
	if not arg2_5 then
		return
	end

	local var0_5 = {}

	table.insertto(var0_5, arg2_5.mainShips or {})
	table.insertto(var0_5, arg2_5.vanguardShips or {})
	table.insertto(var0_5, arg2_5.subShips or {})
	var0_0.InsertShipIdsResList(arg0_5, arg1_5, var0_5)
end

function var0_0.InsertShipIdsResList(arg0_6, arg1_6, arg2_6)
	local var0_6 = getProxy(BayProxy)

	_.each(arg2_6 or {}, function(arg0_7)
		local var0_7 = arg0_6.shipVOs and arg0_6.shipVOs[arg0_7] or var0_6:getShipById(arg0_7)

		var0_0.InsertShipResList(arg1_6, var0_7)
	end)
end

function var0_0.InsertShipResList(arg0_8, arg1_8)
	if not arg1_8 then
		return
	end

	table.insertto(arg0_8, ResPathSupport.GetPaintingSquareIconListByPaintingName(arg1_8:getPainting()))
	table.insertto(arg0_8, ResPathSupport.GetSpineQIconListByPrefabName(arg1_8:getPrefab()))
end

function var0_0.GetCommanderResList(arg0_9)
	local var0_9 = {}

	if arg0_9.mode == 1 and arg0_9.fleets then
		_.each(arg0_9.fleets, function(arg0_10)
			if arg0_10 then
				_.each(arg0_10:getCommanders(), function(arg0_11)
					var0_0.InsertCommanderResList(var0_9, arg0_11)
				end)
			end
		end)
	elseif arg0_9.mode == 2 then
		_.each(arg0_9.eliteCommanderList or {}, function(arg0_12)
			_.each(arg0_12, function(arg0_13)
				local var0_13 = getProxy(CommanderProxy):getCommanderById(arg0_13)

				var0_0.InsertCommanderResList(var0_9, var0_13)
			end)
		end)
	end

	return var0_9
end

function var0_0.InsertCommanderResList(arg0_14, arg1_14)
	if not arg1_14 then
		return
	end

	local var0_14 = arg1_14:getPainting()

	if noEmptyStr(var0_14) then
		local var1_14 = ResPathSupport.CombinePath(ResPathSupport.ConstPath.Commander.CommanderHrz, var0_14)

		table.insert(arg0_14, var1_14)
	end
end

function var0_0.GetTicketResList(arg0_15)
	local var0_15 = {}
	local var1_15 = arg0_15.chapter and arg0_15:getLegalSPBuffList() or {}

	_.each(var1_15, function(arg0_16)
		local var0_16 = pg.benefit_buff_template[arg0_16]
		local var1_16 = ActivityBuff.GetBenefitCondition(var0_16.benefit_condition)

		if var1_16[1] == "item" then
			var0_0.InsertTicketResList(arg0_15, var0_15, var1_16[2])
		end
	end)

	return var0_15
end

function var0_0.InsertTicketResList(arg0_17, arg1_17, arg2_17)
	local var0_17

	arg2_17 = tonumber(arg2_17)

	_.each(arg0_17.spOPTicketItems or {}, function(arg0_18)
		if arg2_17 == arg0_18.configId then
			var0_17 = arg0_18
		end
	end)

	if var0_17 then
		local var1_17 = var0_17:getConfig("icon")

		if noEmptyStr(var1_17) then
			table.insert(arg1_17, var1_17)
		end
	elseif arg2_17 then
		local var2_17 = Drop.New({
			type = DROP_TYPE_ITEM,
			id = arg2_17
		}):getIcon()

		if noEmptyStr(var2_17) then
			table.insert(arg1_17, var2_17)
		end
	end
end

return var0_0
