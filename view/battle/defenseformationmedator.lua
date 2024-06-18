local var0_0 = class("DefenseFormationMedator", import("..base.ContextMediator"))

var0_0.OPEN_SHIP_INFO = "DefenseFormationMedator:OPEN_SHIP_INFO"
var0_0.ON_CHANGE_FLEET = "DefenseFormationMedator:ON_CHANGE_FLEET"
var0_0.CHANGE_FLEET_NAME = "DefenseFormationMedator:CHANGE_FLEET_NAME"
var0_0.CHANGE_FLEET_SHIP = "DefenseFormationMedator:CHANGE_FLEET_SHIP"
var0_0.REMOVE_SHIP = "DefenseFormationMedator:REMOVE_SHIP"
var0_0.CHANGE_FLEET_FORMATION = "DefenseFormationMedator:CHANGE_FLEET_FORMATION"
var0_0.CHANGE_FLEET_SHIPS_ORDER = "DefenseFormationMedator:CHANGE_FLEET_SHIPS_ORDER"
var0_0.COMMIT_FLEET = "DefenseFormationMedator:COMMIT_FLEET"

function var0_0.register(arg0_1)
	arg0_1.ships = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:setShips(arg0_1.ships)

	local var0_1 = getProxy(MilitaryExerciseProxy)
	local var1_1 = var0_1:getExerciseFleet()
	local var2_1 = getProxy(FleetProxy):getFleetById(1)

	arg0_1.viewComponent:SetFleet(var1_1)
	arg0_1:bind(var0_0.OPEN_SHIP_INFO, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1.contextData.number = arg2_2.id
		arg0_1.contextData.toggle = arg3_2

		local var0_2 = {}

		for iter0_2, iter1_2 in ipairs(arg2_2:getShipIds()) do
			table.insert(var0_2, arg0_1.ships[iter1_2])
		end

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_2,
			shipVOs = var0_2
		})
	end)
	arg0_1:bind(var0_0.COMMIT_FLEET, function(arg0_3, arg1_3)
		arg0_1:save(nil, arg1_3)
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIPS_ORDER, function(arg0_4, arg1_4)
		arg0_1:save(arg1_4)
		arg0_1:refreshView()
	end)
	arg0_1:bind(var0_0.REMOVE_SHIP, function(arg0_5, arg1_5, arg2_5)
		arg2_5:removeShip(arg1_5)
		arg0_1:save(arg2_5)
		arg0_1:refreshView()
	end)
	arg0_1:bind(var0_0.CHANGE_FLEET_SHIP, function(arg0_6, arg1_6, arg2_6)
		local var0_6 = arg1_6 and arg1_6.id or nil
		local var1_6 = var0_1:getSeasonInfo()
		local var2_6 = var1_6:getMainShipIds()
		local var3_6 = var1_6:getVanguardShipIds()
		local var4_6 = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true,
			inExercise = true
		})

		for iter0_6 = #var4_6, 1, -1 do
			if var4_6[iter0_6] == var0_6 then
				table.remove(var4_6, iter0_6)

				break
			end
		end

		local var5_6, var6_6 = arg0_1.configDockYardFunc(arg0_1.ships, var2_6, var3_6, var0_6, arg2_6, function(arg0_7, arg1_7)
			arg0_1:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
				fleet = arg0_7,
				callback = arg1_7
			})

			arg0_7 = nil
		end)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			callbackQuit = true,
			quitTeam = arg1_6 ~= nil,
			teamFilter = arg2_6,
			ignoredIds = var4_6,
			hideTagFlags = ShipStatus.TAG_HIDE_DEFENSE,
			leftTopInfo = i18n("word_formation"),
			onShip = var6_6,
			onSelected = var5_6
		})
	end)
end

function var0_0.refreshView(arg0_8, arg1_8)
	arg0_8.viewComponent:UpdateFleetView(arg1_8)
end

function var0_0.save(arg0_9, arg1_9, arg2_9)
	if arg1_9 then
		arg0_9:sendNotification(GAME.UPDATE_EXERCISE_FLEET, {
			fleet = arg1_9,
			callback = arg2_9
		})
	elseif arg2_9 then
		arg2_9()
	end
end

function var0_0.configDockYardFunc(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10)
	local function var0_10(arg0_11, arg1_11)
		local var0_11 = {}

		local function var1_11(arg0_12)
			if not arg3_10 then
				for iter0_12, iter1_12 in ipairs(_.reverse(arg0_12)) do
					if not table.contains(arg0_11, iter1_12) then
						table.insert(arg0_11, 1, iter1_12)
					end
				end
			elseif arg3_10 and table.getCount(arg0_11) == 0 then
				for iter2_12, iter3_12 in ipairs(arg0_12) do
					if iter3_12 ~= arg3_10 and not table.contains(arg0_11, iter3_12) then
						table.insert(arg0_11, iter3_12)
					end
				end
			elseif arg3_10 then
				for iter4_12, iter5_12 in ipairs(arg0_12) do
					if iter5_12 == arg3_10 then
						arg0_12[iter4_12] = arg0_11[1]
					end
				end

				arg0_11 = arg0_12
			end
		end

		local function var2_11(arg0_13)
			if arg4_10 == TeamType.Main then
				var0_11.mainShips = arg0_13 and arg0_11 or arg1_10
				var0_11.vanguardShips = arg2_10
			elseif arg4_10 == TeamType.Vanguard then
				var0_11.mainShips = arg1_10
				var0_11.vanguardShips = arg0_13 and arg0_11 or arg2_10
			end

			if arg5_10 then
				arg5_10(var0_11, arg1_11)
			end
		end

		if arg4_10 == TeamType.Main then
			var1_11(arg1_10)
		elseif arg4_10 == TeamType.Vanguard then
			var1_11(arg2_10)
		end

		local function var3_11()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("defense_formation_tip_npc"),
				onYes = function()
					var2_11(false)
				end,
				onNo = function()
					var2_11(false)
				end
			})
		end

		if #arg0_11 > 0 then
			var2_11(true)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("exercise_clear_fleet_tip"),
				onYes = function()
					if not getProxy(FleetProxy):getFleetById(1):ExistActNpcShip() then
						var2_11(true)
					else
						var3_11()
					end
				end,
				onNo = function()
					var2_11(false)
				end
			})
		end
	end

	local function var1_10(arg0_19, arg1_19, arg2_19)
		local var0_19 = pg.ship_data_template[arg0_19.configId].group_type

		local function var1_19(arg0_20)
			for iter0_20, iter1_20 in ipairs(arg0_20) do
				local var0_20 = pg.ship_data_template[arg0_10[iter1_20].configId].group_type

				if (not arg3_10 or arg3_10 ~= iter1_20 or var0_20 ~= var0_19) and var0_20 == var0_19 then
					return false
				end
			end

			return true
		end

		if arg4_10 == TeamType.Main then
			if not var1_19(arg1_10) then
				return false, i18n("ship_vo_mainFleet_exist_same_ship")
			end
		elseif arg4_10 == TeamType.Vanguard and not var1_19(arg2_10) then
			return false, i18n("ship_vo_vanguardFleet_exist_same_ship")
		end

		return true
	end

	return var0_10, var1_10
end

function var0_0.listNotificationInterests(arg0_21)
	return {
		GAME.EXERCISE_FLEET_RESET
	}
end

function var0_0.handleNotification(arg0_22, arg1_22)
	local var0_22 = arg1_22:getName()
	local var1_22 = arg1_22:getBody()

	if GAME.EXERCISE_FLEET_RESET == var0_22 then
		arg0_22.viewComponent:SetFleet(var1_22)
		arg0_22.viewComponent:UpdateFleetView(true)
	end
end

return var0_0
