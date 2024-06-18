local var0_0 = class("FleetProxy", import(".NetProxy"))

var0_0.FLEET_ADDED = "fleet added"
var0_0.FLEET_UPDATED = "fleet updated"
var0_0.FLEET_RENAMED = "fleet renamed"
var0_0.PVP_FLEET_ID = 101
var0_0.CHALLENGE_FLEET_ID = 102
var0_0.CHALLENGE_SUB_FLEET_ID = 103

function var0_0.register(arg0_1)
	arg0_1.extraFleets = {}
	arg0_1.activityFleetData = {}

	arg0_1:on(12101, function(arg0_2)
		arg0_1.data = {}

		for iter0_2, iter1_2 in ipairs(arg0_2.group_list) do
			local var0_2 = var0_0.CreateFleet(iter1_2)

			var0_2:display("loaded")

			arg0_1.data[var0_2.id] = var0_2
		end

		for iter2_2 = 1, FormationUI.MAX_FLEET_NUM do
			if not arg0_1.data[iter2_2] then
				arg0_1.data[iter2_2] = var0_0.CreateFleet({
					name = "",
					id = iter2_2,
					ship_list = {},
					commanders = {}
				})
			end
		end

		for iter3_2, iter4_2 in pairs({
			[var0_0.PVP_FLEET_ID] = "",
			[var0_0.CHALLENGE_FLEET_ID] = "",
			[var0_0.CHALLENGE_SUB_FLEET_ID] = ""
		}) do
			if not arg0_1.data[iter3_2] then
				arg0_1.data[iter3_2] = var0_0.CreateFleet({
					id = iter3_2,
					name = iter4_2,
					ship_list = {},
					commanders = {}
				})
			end
		end

		for iter5_2, iter6_2 in ipairs({
			var0_0.CHALLENGE_FLEET_ID,
			var0_0.CHALLENGE_SUB_FLEET_ID
		}) do
			arg0_1.extraFleets[iter6_2] = arg0_1.data[iter6_2]
			arg0_1.data[iter6_2] = nil
		end

		if LOCK_SUBMARINE then
			for iter7_2, iter8_2 in pairs(arg0_1.data) do
				if iter8_2.id == 11 or iter8_2.id == 12 then
					arg0_1.data[iter7_2] = nil
				end
			end
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChallenge")
	end)
	arg0_1:on(12106, function(arg0_3)
		local var0_3 = var0_0.CreateFleet(arg0_3.group)

		if arg0_1.data[var0_3.id] then
			arg0_1:updateFleet(var0_3)
		else
			arg0_1:addFleet(var0_3)
		end
	end)
end

function var0_0.CreateFleet(arg0_4)
	local var0_4 = arg0_4.id
	local var1_4 = CreateShell(arg0_4)

	var1_4.fleetType = FleetType.Normal

	if var0_4 >= Fleet.REGULAR_FLEET_ID and var0_4 < Fleet.REGULAR_FLEET_ID + Fleet.REGULAR_FLEET_NUMS then
		if var0_4 == Fleet.REGULAR_FLEET_ID then
			var1_4.saveLastShipFlag = true
		end
	elseif var0_4 >= Fleet.SUBMARINE_FLEET_ID and var0_4 < Fleet.SUBMARINE_FLEET_ID + Fleet.SUBMARINE_FLEET_NUMS then
		var1_4.fleetType = FleetType.Submarine
	elseif var0_4 == FleetProxy.PVP_FLEET_ID then
		var1_4.saveLastShipFlag = true
	elseif var0_4 == FleetProxy.CHALLENGE_FLEET_ID then
		-- block empty
	elseif var0_4 == FleetProxy.CHALLENGE_SUB_FLEET_ID then
		var1_4.fleetType = FleetType.Submarine
	end

	return (TypedFleet.New(var1_4))
end

function var0_0.addFleet(arg0_5, arg1_5)
	assert(isa(arg1_5, Fleet), "should be an instance of Fleet")
	assert(arg0_5.data[arg1_5.id] == nil, "fleet already exist, use updateFleet() instead")

	arg0_5.data[arg1_5.id] = arg1_5:clone()

	arg0_5.data[arg1_5.id]:display("added")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
	arg0_5.facade:sendNotification(var0_0.FLEET_ADDED, arg1_5:clone())
end

function var0_0.updateFleet(arg0_6, arg1_6)
	assert(isa(arg1_6, Fleet), "should be an instance of Fleet")

	if arg0_6.data[arg1_6.id] ~= nil then
		arg0_6.data[arg1_6.id] = arg1_6:clone()

		arg0_6.data[arg1_6.id]:display("updated")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
	elseif arg0_6.extraFleets[arg1_6.id] ~= nil then
		arg0_6.extraFleets[arg1_6.id] = arg1_6

		arg0_6.extraFleets[arg1_6.id]:display("updated")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChallenge")
	else
		assert(false, "fleet should exist")
	end

	arg0_6.facade:sendNotification(var0_0.FLEET_UPDATED, arg1_6.id)
end

function var0_0.saveEdittingFleet(arg0_7)
	if arg0_7.editSrcCache == nil then
		arg0_7.editSrcCache = Clone(arg0_7.data)
	end

	if arg0_7.EdittingFleet ~= nil then
		arg0_7.data[arg0_7.EdittingFleet.id] = arg0_7.EdittingFleet

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
	end
end

function var0_0.commitEdittingFleet(arg0_8, arg1_8)
	local var0_8 = {}

	if arg0_8.EdittingFleet ~= nil then
		table.insert(var0_8, function(arg0_9)
			arg0_8.facade:sendNotification(GAME.UPDATE_FLEET, {
				fleet = arg0_8.EdittingFleet,
				callback = function()
					arg0_8.editSrcCache = nil
					arg0_8.EdittingFleet = nil

					arg0_9()
				end
			})
		end)
	end

	seriesAsync(var0_8, function()
		if arg1_8 then
			arg1_8()
		end
	end)
end

function var0_0.abortEditting(arg0_12)
	if arg0_12.editSrcCache then
		arg0_12.data = arg0_12.editSrcCache
		arg0_12.editSrcCache = nil
	end

	arg0_12.EdittingFleet = nil
end

function var0_0.syncFleet(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.data) do
		arg0_13.facade:sendNotification(GAME.UPDATE_FLEET, {
			fleet = iter1_13
		})
	end
end

function var0_0.getCount(arg0_14)
	return table.getCount(arg0_14.data)
end

function var0_0.getFleetById(arg0_15, arg1_15)
	if arg0_15.data[arg1_15] ~= nil then
		return arg0_15.data[arg1_15]:clone()
	end

	if arg0_15.extraFleets[arg1_15] then
		return arg0_15.extraFleets[arg1_15]
	end

	return nil
end

function var0_0.getAllShipIds(arg0_16, arg1_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in pairs(arg0_16.data) do
		if arg1_16 and not iter1_16:isRegularFleet() then
			-- block empty
		else
			for iter2_16, iter3_16 in ipairs(iter1_16.ships) do
				table.insert(var0_16, iter3_16)
			end
		end
	end

	return var0_16
end

function var0_0.getFirstFleetShipCount(arg0_17)
	local var0_17 = 0

	for iter0_17, iter1_17 in ipairs(arg0_17.data[1].ships) do
		var0_17 = var0_17 + 1
	end

	return var0_17
end

function var0_0.GetRegularFleets(arg0_18)
	local var0_18 = {}

	for iter0_18, iter1_18 in pairs(arg0_18.data) do
		if iter1_18:isRegularFleet() then
			var0_18[iter0_18] = Clone(iter1_18)
		end
	end

	return var0_18
end

function var0_0.inPvPFleet(arg0_19, arg1_19)
	if arg0_19.data[FleetProxy.PVP_FLEET_ID]:containShip(arg1_19) then
		return true
	end

	return false
end

function var0_0.GetRegularFleetByShip(arg0_20, arg1_20)
	assert(isa(arg1_20, Ship), "should be an instance of Ship")

	for iter0_20, iter1_20 in pairs(arg0_20.data) do
		if iter1_20:isRegularFleet() and iter1_20:containShip(arg1_20) then
			return iter1_20:clone()
		end
	end

	return nil
end

function var0_0.renameFleet(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21:getFleetById(arg1_21)

	assert(var0_21 ~= nil, "fleet should exist")

	var0_21.name = arg2_21

	arg0_21:updateFleet(var0_21)
	arg0_21.facade:sendNotification(var0_0.FLEET_RENAMED, var0_21:clone())
end

function var0_0.getCommandersInFleet(arg0_22)
	local var0_22 = {}

	for iter0_22, iter1_22 in pairs(arg0_22.data) do
		if iter1_22:isRegularFleet() then
			for iter2_22, iter3_22 in pairs(iter1_22:getCommanders()) do
				table.insert(var0_22, iter3_22.id)
			end
		end
	end

	return var0_22
end

function var0_0.getCommanders(arg0_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(arg0_23.data) do
		if iter1_23:isRegularFleet() then
			for iter2_23, iter3_23 in pairs(iter1_23:getCommanders()) do
				table.insert(var0_23, {
					fleetId = iter1_23.id,
					pos = iter2_23,
					commanderId = iter3_23.id
				})
			end
		end
	end

	return var0_23
end

function var0_0.GetExtraCommanders(arg0_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in pairs(arg0_24.extraFleets) do
		for iter2_24, iter3_24 in pairs(iter1_24:getCommanders()) do
			table.insert(var0_24, {
				fleetId = iter1_24.id,
				pos = iter2_24,
				commanderId = iter3_24.id
			})
		end
	end

	return var0_24
end

function var0_0.getActivityFleets(arg0_25)
	return arg0_25.activityFleetData
end

function var0_0.addActivityFleet(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg1_26.id

	if not arg0_26.activityFleetData[var0_26] then
		arg0_26.activityFleetData[var0_26] = {}
	end

	local var1_26 = arg0_26.activityFleetData[var0_26]
	local var2_26 = getProxy(BayProxy)
	local var3_26
	local var4_26

	local function var5_26()
		if var4_26 then
			return var4_26
		end

		local var0_27 = arg1_26:GetActiveSeriesIds()

		var4_26 = _.map(var0_27, function(arg0_28)
			return table.lastof(BossRushSeriesData.New({
				id = arg0_28,
				actId = arg1_26.id
			}):GetFleetIds())
		end)

		return var4_26
	end

	local var6_26 = pg.activity_template[var0_26]

	for iter0_26, iter1_26 in ipairs(arg2_26) do
		local var7_26 = CreateShell(iter1_26)

		if var6_26.type == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
			var7_26.fleetType = table.contains(var5_26(), iter1_26.id) and FleetType.Submarine or FleetType.Normal
		elseif var6_26.type == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			var7_26.fleetType = iter1_26.id >= Fleet.SUBMARINE_FLEET_ID and FleetType.Submarine or FleetType.Normal
		elseif var6_26.type == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
			var7_26.fleetType = iter1_26.id >= Fleet.SUBMARINE_FLEET_ID and FleetType.Submarine or FleetType.Normal
		else
			local var8_26 = {
				id = iter1_26.id
			}

			var7_26.fleetType = Fleet.isSubmarineFleet(var8_26) and FleetType.Submarine or FleetType.Normal
		end

		local var9_26 = TypedFleet.New(var7_26)

		var1_26[var9_26.id] = var9_26

		for iter2_26, iter3_26 in ipairs(iter1_26.ship_list) do
			if not var2_26:RawGetShipById(iter3_26) then
				var3_26 = true

				break
			end
		end
	end

	if var3_26 then
		arg0_26:commitActivityFleet(var0_26)
	end

	local var10_26
	local var11_26

	if var6_26.type == ActivityConst.ACTIVITY_TYPE_CHALLENGE then
		var10_26 = 2
		var11_26 = 2
	elseif var6_26.type == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
		var10_26 = 0
		var11_26 = 0
	elseif var6_26.type == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
		var10_26 = 0
		var11_26 = 0
	elseif var6_26.type == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
		var10_26 = 0
		var11_26 = 0
	end

	local var12_26 = 0

	while var12_26 < var10_26 do
		var12_26 = var12_26 + 1

		if var1_26[var12_26] == nil then
			var1_26[var12_26] = TypedFleet.New({
				id = var12_26,
				ship_list = {},
				fleetType = FleetType.Normal
			})
		end
	end

	local var13_26 = 0

	while var13_26 < var11_26 do
		local var14_26 = Fleet.SUBMARINE_FLEET_ID + var13_26

		if var1_26[var14_26] == nil then
			var1_26[var14_26] = TypedFleet.New({
				id = var14_26,
				ship_list = {},
				fleetType = FleetType.Submarine
			})
		end

		var13_26 = var13_26 + 1
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
end

function var0_0.updateActivityFleet(arg0_29, arg1_29, arg2_29, arg3_29)
	arg0_29.activityFleetData[arg1_29][arg2_29] = arg3_29

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
end

function var0_0.commitActivityFleet(arg0_30, arg1_30)
	arg0_30.editSrcCache = nil
	arg0_30.EdittingFleet = nil

	arg0_30.facade:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
		actID = arg1_30,
		fleets = arg0_30.activityFleetData[arg1_30]
	})
end

function var0_0.checkActivityFleet(arg0_31, arg1_31)
	local var0_31 = arg0_31.activityFleetData[arg1_31]

	for iter0_31, iter1_31 in pairs(var0_31) do
		if iter0_31 < Fleet.SUBMARINE_FLEET_ID and iter1_31:isLegalToFight() == true then
			return true
		end
	end

	return false
end

function var0_0.removeActivityFleetCommander(arg0_32, arg1_32)
	for iter0_32, iter1_32 in pairs(arg0_32.activityFleetData) do
		for iter2_32, iter3_32 in pairs(iter1_32) do
			local var0_32 = false
			local var1_32 = iter3_32:GetRawCommanderIds()

			for iter4_32, iter5_32 in pairs(var1_32) do
				if arg1_32 == iter5_32 then
					iter3_32:updateCommanderByPos(iter4_32, nil)
					iter3_32:updateCommanderSkills()
					arg0_32:updateActivityFleet(iter0_32, iter2_32, iter3_32)
					arg0_32:commitActivityFleet(iter0_32)

					var0_32 = true

					break
				end
			end

			if var0_32 then
				break
			end
		end
	end
end

function var0_0.recommendActivityFleet(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33:getActivityFleets()[arg1_33][arg2_33]
	local var1_33 = getProxy(BayProxy)

	local function var2_33(arg0_34, arg1_34)
		local var0_34 = TeamType.GetShipTypeListFromTeam(arg0_34)
		local var1_34 = var1_33:getActivityRecommendShips(var0_34, var0_33.ships, arg1_34, arg1_33)

		for iter0_34, iter1_34 in ipairs(var1_34) do
			var0_33:insertShip(iter1_34, nil, arg0_34)
		end
	end

	if arg2_33 >= Fleet.SUBMARINE_FLEET_ID then
		if not var0_33:isFull() then
			var2_33(TeamType.Submarine, TeamType.SubmarineMax - #var0_33.subShips)
		end
	else
		local var3_33 = TeamType.VanguardMax - #var0_33.vanguardShips
		local var4_33 = TeamType.MainMax - #var0_33.mainShips

		if var3_33 > 0 then
			var2_33(TeamType.Vanguard, var3_33)
		end

		if var4_33 > 0 then
			var2_33(TeamType.Main, var4_33)
		end
	end

	arg0_33:updateActivityFleet(arg1_33, arg2_33, var0_33)
end

function var0_0.GetBossRushFleets(arg0_35, arg1_35, arg2_35)
	local var0_35 = {}
	local var1_35 = arg0_35:getActivityFleets()[arg1_35]

	table.Foreach(arg2_35, function(arg0_36, arg1_36)
		local var0_36 = arg0_36 == #arg2_35

		if not var1_35[arg1_36] then
			local var1_36 = var0_36 and FleetType.Submarine or FleetType.Normal

			var1_35[arg1_36] = TypedFleet.New({
				id = arg1_36,
				ship_list = {},
				fleetType = var1_36
			})
		end

		local var2_36 = var1_35[arg1_36]

		var2_36:RemoveUnusedItems()

		var0_35[arg0_36] = var2_36
	end)

	return var0_35
end

return var0_0
