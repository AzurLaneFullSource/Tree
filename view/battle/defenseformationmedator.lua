local var0 = class("DefenseFormationMedator", import("..base.ContextMediator"))

var0.OPEN_SHIP_INFO = "DefenseFormationMedator:OPEN_SHIP_INFO"
var0.ON_CHANGE_FLEET = "DefenseFormationMedator:ON_CHANGE_FLEET"
var0.CHANGE_FLEET_NAME = "DefenseFormationMedator:CHANGE_FLEET_NAME"
var0.CHANGE_FLEET_SHIP = "DefenseFormationMedator:CHANGE_FLEET_SHIP"
var0.REMOVE_SHIP = "DefenseFormationMedator:REMOVE_SHIP"
var0.CHANGE_FLEET_FORMATION = "DefenseFormationMedator:CHANGE_FLEET_FORMATION"
var0.CHANGE_FLEET_SHIPS_ORDER = "DefenseFormationMedator:CHANGE_FLEET_SHIPS_ORDER"
var0.COMMIT_FLEET = "DefenseFormationMedator:COMMIT_FLEET"

function var0.register(arg0)
	arg0.ships = getProxy(BayProxy):getRawData()

	arg0.viewComponent:setShips(arg0.ships)

	local var0 = getProxy(MilitaryExerciseProxy)
	local var1 = var0:getExerciseFleet()
	local var2 = getProxy(FleetProxy):getFleetById(1)

	arg0.viewComponent:SetFleet(var1)
	arg0:bind(var0.OPEN_SHIP_INFO, function(arg0, arg1, arg2, arg3)
		arg0.contextData.number = arg2.id
		arg0.contextData.toggle = arg3

		local var0 = {}

		for iter0, iter1 in ipairs(arg2:getShipIds()) do
			table.insert(var0, arg0.ships[iter1])
		end

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1,
			shipVOs = var0
		})
	end)
	arg0:bind(var0.COMMIT_FLEET, function(arg0, arg1)
		arg0:save(nil, arg1)
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIPS_ORDER, function(arg0, arg1)
		arg0:save(arg1)
		arg0:refreshView()
	end)
	arg0:bind(var0.REMOVE_SHIP, function(arg0, arg1, arg2)
		arg2:removeShip(arg1)
		arg0:save(arg2)
		arg0:refreshView()
	end)
	arg0:bind(var0.CHANGE_FLEET_SHIP, function(arg0, arg1, arg2)
		local var0 = arg1 and arg1.id or nil
		local var1 = var0:getSeasonInfo()
		local var2 = var1:getMainShipIds()
		local var3 = var1:getVanguardShipIds()
		local var4 = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true,
			inExercise = true
		})

		for iter0 = #var4, 1, -1 do
			if var4[iter0] == var0 then
				table.remove(var4, iter0)

				break
			end
		end

		local var5, var6 = arg0.configDockYardFunc(arg0.ships, var2, var3, var0, arg2, function(arg0, arg1)
			arg0:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
				fleet = arg0,
				callback = arg1
			})

			arg0 = nil
		end)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			callbackQuit = true,
			quitTeam = arg1 ~= nil,
			teamFilter = arg2,
			ignoredIds = var4,
			hideTagFlags = ShipStatus.TAG_HIDE_DEFENSE,
			leftTopInfo = i18n("word_formation"),
			onShip = var6,
			onSelected = var5
		})
	end)
end

function var0.refreshView(arg0, arg1)
	arg0.viewComponent:UpdateFleetView(arg1)
end

function var0.save(arg0, arg1, arg2)
	if arg1 then
		arg0:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
			fleet = arg1,
			callback = arg2
		})
	elseif arg2 then
		arg2()
	end
end

function var0.configDockYardFunc(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0(arg0, arg1)
		local var0 = {}

		local function var1(arg0)
			if not arg3 then
				for iter0, iter1 in ipairs(_.reverse(arg0)) do
					if not table.contains(arg0, iter1) then
						table.insert(arg0, 1, iter1)
					end
				end
			elseif arg3 and table.getCount(arg0) == 0 then
				for iter2, iter3 in ipairs(arg0) do
					if iter3 ~= arg3 and not table.contains(arg0, iter3) then
						table.insert(arg0, iter3)
					end
				end
			elseif arg3 then
				for iter4, iter5 in ipairs(arg0) do
					if iter5 == arg3 then
						arg0[iter4] = arg0[1]
					end
				end

				arg0 = arg0
			end
		end

		local function var2(arg0)
			if arg4 == TeamType.Main then
				var0.mainShips = arg0 and arg0 or arg1
				var0.vanguardShips = arg2
			elseif arg4 == TeamType.Vanguard then
				var0.mainShips = arg1
				var0.vanguardShips = arg0 and arg0 or arg2
			end

			if arg5 then
				arg5(var0, arg1)
			end
		end

		if arg4 == TeamType.Main then
			var1(arg1)
		elseif arg4 == TeamType.Vanguard then
			var1(arg2)
		end

		local function var3()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("defense_formation_tip_npc"),
				onYes = function()
					var2(false)
				end,
				onNo = function()
					var2(false)
				end
			})
		end

		if #arg0 > 0 then
			var2(true)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function()
					if not getProxy(FleetProxy):getFleetById(1):ExistActNpcShip() then
						var2(true)
					else
						var3()
					end
				end,
				onNo = function()
					var2(false)
				end
			})
		end
	end

	local function var1(arg0, arg1, arg2)
		local var0 = pg.ship_data_template[arg0.configId].group_type

		local function var1(arg0)
			for iter0, iter1 in ipairs(arg0) do
				local var0 = pg.ship_data_template[arg0[iter1].configId].group_type

				if (not arg3 or arg3 ~= iter1 or var0 ~= var0) and var0 == var0 then
					return false
				end
			end

			return true
		end

		if arg4 == TeamType.Main then
			if not var1(arg1) then
				return false, i18n("ship_vo_mainFleet_exist_same_ship")
			end
		elseif arg4 == TeamType.Vanguard and not var1(arg2) then
			return false, i18n("ship_vo_vanguardFleet_exist_same_ship")
		end

		return true
	end

	return var0, var1
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EXERCISE_FLEET_RESET
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if GAME.EXERCISE_FLEET_RESET == var0 then
		arg0.viewComponent:SetFleet(var1)
		arg0.viewComponent:UpdateFleetView(true)
	end
end

return var0
