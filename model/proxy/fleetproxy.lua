local var0 = class("FleetProxy", import(".NetProxy"))

var0.FLEET_ADDED = "fleet added"
var0.FLEET_UPDATED = "fleet updated"
var0.FLEET_RENAMED = "fleet renamed"
var0.PVP_FLEET_ID = 101
var0.CHALLENGE_FLEET_ID = 102
var0.CHALLENGE_SUB_FLEET_ID = 103

function var0.register(arg0)
	arg0.extraFleets = {}
	arg0.activityFleetData = {}

	arg0:on(12101, function(arg0)
		arg0.data = {}

		for iter0, iter1 in ipairs(arg0.group_list) do
			local var0 = var0.CreateFleet(iter1)

			var0:display("loaded")

			arg0.data[var0.id] = var0
		end

		for iter2 = 1, FormationUI.MAX_FLEET_NUM do
			if not arg0.data[iter2] then
				arg0.data[iter2] = var0.CreateFleet({
					name = "",
					id = iter2,
					ship_list = {},
					commanders = {}
				})
			end
		end

		for iter3, iter4 in pairs({
			[var0.PVP_FLEET_ID] = "",
			[var0.CHALLENGE_FLEET_ID] = "",
			[var0.CHALLENGE_SUB_FLEET_ID] = ""
		}) do
			if not arg0.data[iter3] then
				arg0.data[iter3] = var0.CreateFleet({
					id = iter3,
					name = iter4,
					ship_list = {},
					commanders = {}
				})
			end
		end

		for iter5, iter6 in ipairs({
			var0.CHALLENGE_FLEET_ID,
			var0.CHALLENGE_SUB_FLEET_ID
		}) do
			arg0.extraFleets[iter6] = arg0.data[iter6]
			arg0.data[iter6] = nil
		end

		if LOCK_SUBMARINE then
			for iter7, iter8 in pairs(arg0.data) do
				if iter8.id == 11 or iter8.id == 12 then
					arg0.data[iter7] = nil
				end
			end
		end

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChallenge")
	end)
	arg0:on(12106, function(arg0)
		local var0 = var0.CreateFleet(arg0.group)

		if arg0.data[var0.id] then
			arg0:updateFleet(var0)
		else
			arg0:addFleet(var0)
		end
	end)
end

function var0.CreateFleet(arg0)
	local var0 = arg0.id
	local var1 = CreateShell(arg0)

	var1.fleetType = FleetType.Normal

	if var0 >= Fleet.REGULAR_FLEET_ID and var0 < Fleet.REGULAR_FLEET_ID + Fleet.REGULAR_FLEET_NUMS then
		if var0 == Fleet.REGULAR_FLEET_ID then
			var1.saveLastShipFlag = true
		end
	elseif var0 >= Fleet.SUBMARINE_FLEET_ID and var0 < Fleet.SUBMARINE_FLEET_ID + Fleet.SUBMARINE_FLEET_NUMS then
		var1.fleetType = FleetType.Submarine
	elseif var0 == FleetProxy.PVP_FLEET_ID then
		var1.saveLastShipFlag = true
	elseif var0 == FleetProxy.CHALLENGE_FLEET_ID then
		-- block empty
	elseif var0 == FleetProxy.CHALLENGE_SUB_FLEET_ID then
		var1.fleetType = FleetType.Submarine
	end

	return (TypedFleet.New(var1))
end

function var0.addFleet(arg0, arg1)
	assert(isa(arg1, Fleet), "should be an instance of Fleet")
	assert(arg0.data[arg1.id] == nil, "fleet already exist, use updateFleet() instead")

	arg0.data[arg1.id] = arg1:clone()

	arg0.data[arg1.id]:display("added")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
	arg0.facade:sendNotification(var0.FLEET_ADDED, arg1:clone())
end

function var0.updateFleet(arg0, arg1)
	assert(isa(arg1, Fleet), "should be an instance of Fleet")

	if arg0.data[arg1.id] ~= nil then
		arg0.data[arg1.id] = arg1:clone()

		arg0.data[arg1.id]:display("updated")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
	elseif arg0.extraFleets[arg1.id] ~= nil then
		arg0.extraFleets[arg1.id] = arg1

		arg0.extraFleets[arg1.id]:display("updated")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inChallenge")
	else
		assert(false, "fleet should exist")
	end

	arg0.facade:sendNotification(var0.FLEET_UPDATED, arg1.id)
end

function var0.saveEdittingFleet(arg0)
	if arg0.editSrcCache == nil then
		arg0.editSrcCache = Clone(arg0.data)
	end

	if arg0.EdittingFleet ~= nil then
		arg0.data[arg0.EdittingFleet.id] = arg0.EdittingFleet

		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inFleet")
		pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inPvP")
	end
end

function var0.commitEdittingFleet(arg0, arg1)
	local var0 = {}

	if arg0.EdittingFleet ~= nil then
		table.insert(var0, function(arg0)
			arg0.facade:sendNotification(GAME.UPDATE_FLEET, {
				fleet = arg0.EdittingFleet,
				callback = function()
					arg0.editSrcCache = nil
					arg0.EdittingFleet = nil

					arg0()
				end
			})
		end)
	end

	seriesAsync(var0, function()
		if arg1 then
			arg1()
		end
	end)
end

function var0.abortEditting(arg0)
	if arg0.editSrcCache then
		arg0.data = arg0.editSrcCache
		arg0.editSrcCache = nil
	end

	arg0.EdittingFleet = nil
end

function var0.syncFleet(arg0)
	for iter0, iter1 in ipairs(arg0.data) do
		arg0.facade:sendNotification(GAME.UPDATE_FLEET, {
			fleet = iter1
		})
	end
end

function var0.getCount(arg0)
	return table.getCount(arg0.data)
end

function var0.getFleetById(arg0, arg1)
	if arg0.data[arg1] ~= nil then
		return arg0.data[arg1]:clone()
	end

	if arg0.extraFleets[arg1] then
		return arg0.extraFleets[arg1]
	end

	return nil
end

function var0.getAllShipIds(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if arg1 and not iter1:isRegularFleet() then
			-- block empty
		else
			for iter2, iter3 in ipairs(iter1.ships) do
				table.insert(var0, iter3)
			end
		end
	end

	return var0
end

function var0.getFirstFleetShipCount(arg0)
	local var0 = 0

	for iter0, iter1 in ipairs(arg0.data[1].ships) do
		var0 = var0 + 1
	end

	return var0
end

function var0.GetRegularFleets(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:isRegularFleet() then
			var0[iter0] = Clone(iter1)
		end
	end

	return var0
end

function var0.inPvPFleet(arg0, arg1)
	if arg0.data[FleetProxy.PVP_FLEET_ID]:containShip(arg1) then
		return true
	end

	return false
end

function var0.GetRegularFleetByShip(arg0, arg1)
	assert(isa(arg1, Ship), "should be an instance of Ship")

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:isRegularFleet() and iter1:containShip(arg1) then
			return iter1:clone()
		end
	end

	return nil
end

function var0.renameFleet(arg0, arg1, arg2)
	local var0 = arg0:getFleetById(arg1)

	assert(var0 ~= nil, "fleet should exist")

	var0.name = arg2

	arg0:updateFleet(var0)
	arg0.facade:sendNotification(var0.FLEET_RENAMED, var0:clone())
end

function var0.getCommandersInFleet(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:isRegularFleet() then
			for iter2, iter3 in pairs(iter1:getCommanders()) do
				table.insert(var0, iter3.id)
			end
		end
	end

	return var0
end

function var0.getCommanders(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.data) do
		if iter1:isRegularFleet() then
			for iter2, iter3 in pairs(iter1:getCommanders()) do
				table.insert(var0, {
					fleetId = iter1.id,
					pos = iter2,
					commanderId = iter3.id
				})
			end
		end
	end

	return var0
end

function var0.GetExtraCommanders(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.extraFleets) do
		for iter2, iter3 in pairs(iter1:getCommanders()) do
			table.insert(var0, {
				fleetId = iter1.id,
				pos = iter2,
				commanderId = iter3.id
			})
		end
	end

	return var0
end

function var0.getActivityFleets(arg0)
	return arg0.activityFleetData
end

function var0.addActivityFleet(arg0, arg1, arg2)
	local var0 = arg1.id

	if not arg0.activityFleetData[var0] then
		arg0.activityFleetData[var0] = {}
	end

	local var1 = arg0.activityFleetData[var0]
	local var2 = getProxy(BayProxy)
	local var3
	local var4

	local function var5()
		if var4 then
			return var4
		end

		local var0 = arg1:GetActiveSeriesIds()

		var4 = _.map(var0, function(arg0)
			return table.lastof(BossRushSeriesData.New({
				id = arg0,
				actId = arg1.id
			}):GetFleetIds())
		end)

		return var4
	end

	local var6 = pg.activity_template[var0]

	for iter0, iter1 in ipairs(arg2) do
		local var7 = CreateShell(iter1)

		if var6.type == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
			var7.fleetType = table.contains(var5(), iter1.id) and FleetType.Submarine or FleetType.Normal
		elseif var6.type == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
			var7.fleetType = iter1.id >= Fleet.SUBMARINE_FLEET_ID and FleetType.Submarine or FleetType.Normal
		elseif var6.type == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
			var7.fleetType = iter1.id >= Fleet.SUBMARINE_FLEET_ID and FleetType.Submarine or FleetType.Normal
		else
			local var8 = {
				id = iter1.id
			}

			var7.fleetType = Fleet.isSubmarineFleet(var8) and FleetType.Submarine or FleetType.Normal
		end

		local var9 = TypedFleet.New(var7)

		var1[var9.id] = var9

		for iter2, iter3 in ipairs(iter1.ship_list) do
			if not var2:RawGetShipById(iter3) then
				var3 = true

				break
			end
		end
	end

	if var3 then
		arg0:commitActivityFleet(var0)
	end

	local var10
	local var11

	if var6.type == ActivityConst.ACTIVITY_TYPE_CHALLENGE then
		var10 = 2
		var11 = 2
	elseif var6.type == ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2 then
		var10 = 0
		var11 = 0
	elseif var6.type == ActivityConst.ACTIVITY_TYPE_BOSSRUSH then
		var10 = 0
		var11 = 0
	elseif var6.type == ActivityConst.ACTIVITY_TYPE_BOSSSINGLE then
		var10 = 0
		var11 = 0
	end

	local var12 = 0

	while var12 < var10 do
		var12 = var12 + 1

		if var1[var12] == nil then
			var1[var12] = TypedFleet.New({
				id = var12,
				ship_list = {},
				fleetType = FleetType.Normal
			})
		end
	end

	local var13 = 0

	while var13 < var11 do
		local var14 = Fleet.SUBMARINE_FLEET_ID + var13

		if var1[var14] == nil then
			var1[var14] = TypedFleet.New({
				id = var14,
				ship_list = {},
				fleetType = FleetType.Submarine
			})
		end

		var13 = var13 + 1
	end

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
end

function var0.updateActivityFleet(arg0, arg1, arg2, arg3)
	arg0.activityFleetData[arg1][arg2] = arg3

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inActivity")
end

function var0.commitActivityFleet(arg0, arg1)
	arg0.editSrcCache = nil
	arg0.EdittingFleet = nil

	arg0.facade:sendNotification(GAME.EDIT_ACTIVITY_FLEET, {
		actID = arg1,
		fleets = arg0.activityFleetData[arg1]
	})
end

function var0.checkActivityFleet(arg0, arg1)
	local var0 = arg0.activityFleetData[arg1]

	for iter0, iter1 in pairs(var0) do
		if iter0 < Fleet.SUBMARINE_FLEET_ID and iter1:isLegalToFight() == true then
			return true
		end
	end

	return false
end

function var0.removeActivityFleetCommander(arg0, arg1)
	for iter0, iter1 in pairs(arg0.activityFleetData) do
		for iter2, iter3 in pairs(iter1) do
			local var0 = false
			local var1 = iter3:GetRawCommanderIds()

			for iter4, iter5 in pairs(var1) do
				if arg1 == iter5 then
					iter3:updateCommanderByPos(iter4, nil)
					iter3:updateCommanderSkills()
					arg0:updateActivityFleet(iter0, iter2, iter3)
					arg0:commitActivityFleet(iter0)

					var0 = true

					break
				end
			end

			if var0 then
				break
			end
		end
	end
end

function var0.recommendActivityFleet(arg0, arg1, arg2)
	local var0 = arg0:getActivityFleets()[arg1][arg2]
	local var1 = getProxy(BayProxy)

	local function var2(arg0, arg1)
		local var0 = TeamType.GetShipTypeListFromTeam(arg0)
		local var1 = var1:getActivityRecommendShips(var0, var0.ships, arg1, arg1)

		for iter0, iter1 in ipairs(var1) do
			var0:insertShip(iter1, nil, arg0)
		end
	end

	if arg2 >= Fleet.SUBMARINE_FLEET_ID then
		if not var0:isFull() then
			var2(TeamType.Submarine, TeamType.SubmarineMax - #var0.subShips)
		end
	else
		local var3 = TeamType.VanguardMax - #var0.vanguardShips
		local var4 = TeamType.MainMax - #var0.mainShips

		if var3 > 0 then
			var2(TeamType.Vanguard, var3)
		end

		if var4 > 0 then
			var2(TeamType.Main, var4)
		end
	end

	arg0:updateActivityFleet(arg1, arg2, var0)
end

function var0.GetBossRushFleets(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg0:getActivityFleets()[arg1]

	table.Foreach(arg2, function(arg0, arg1)
		local var0 = arg0 == #arg2

		if not var1[arg1] then
			local var1 = var0 and FleetType.Submarine or FleetType.Normal

			var1[arg1] = TypedFleet.New({
				id = arg1,
				ship_list = {},
				fleetType = var1
			})
		end

		local var2 = var1[arg1]

		var2:RemoveUnusedItems()

		var0[arg0] = var2
	end)

	return var0
end

return var0
