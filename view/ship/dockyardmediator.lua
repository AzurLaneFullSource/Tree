local var0_0 = class("DockyardMediator", import("..base.ContextMediator"))

var0_0.ON_DESTROY_SHIPS = "DockyardMediator:ON_DESTROY_SHIPS"
var0_0.ON_SHIP_DETAIL = "DockyardMediator:ON_SHIP_DETAIL"
var0_0.ON_SHIP_REPAIR = "DockyardMediator:ON_SHIP_REPAIR"
var0_0.OPEN_DOCKYARD_INDEX = "DockyardMediator:OPEN_DOCKYARD_INDEX"

function var0_0.register(arg0_1)
	if arg0_1.contextData.selectFriend then
		local var0_1 = getProxy(FriendProxy):getAllFriends()

		arg0_1.viewComponent:setFriends(var0_1)
	end

	local var1_1 = getProxy(BayProxy)

	if arg0_1.contextData.shipVOs then
		arg0_1.shipsById = {}

		for iter0_1, iter1_1 in ipairs(arg0_1.contextData.shipVOs) do
			arg0_1.shipsById[iter1_1.id] = iter1_1
		end
	elseif arg0_1.contextData.mode == DockyardScene.MODE_WORLD then
		arg0_1.shipsById = {}

		for iter2_1, iter3_1 in ipairs(nowWorld():GetShipVOs()) do
			arg0_1.shipsById[iter3_1.id] = iter3_1
		end
	else
		arg0_1.shipsById = {}

		for iter4_1, iter5_1 in pairs(var1_1.data) do
			arg0_1.shipsById[iter4_1] = iter5_1
		end
	end

	if arg0_1.contextData.mode == DockyardScene.MODE_MOD then
		local var2_1 = arg0_1.contextData.ignoredIds[1]

		arg0_1.viewComponent:setModShip(arg0_1.shipsById[var2_1]:clone())
	end

	arg0_1.fleetProxy = getProxy(FleetProxy)
	arg0_1.fleetShipIds = arg0_1.fleetProxy:getAllShipIds()

	if arg0_1.contextData.ignoredIds then
		for iter6_1, iter7_1 in ipairs(arg0_1.contextData.ignoredIds) do
			arg0_1.shipsById[iter7_1] = nil
		end
	end

	arg0_1.viewComponent:setShips(arg0_1.shipsById)
	arg0_1.viewComponent:setShipsCount(var1_1:getShipCount())

	local var3_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var3_1)
	arg0_1:bind(var0_0.ON_DESTROY_SHIPS, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.DESTROY_SHIPS, {
			destroyEquipment = arg2_2,
			shipIds = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_SHIP_DETAIL, function(arg0_3, arg1_3, arg2_3, arg3_3)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1_3.id,
			shipVOs = arg2_3,
			selectContextData = arg3_3
		})
	end)
	arg0_1:bind(var0_0.ON_SHIP_REPAIR, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.WORLD_SHIP_REPAIR, {
			shipIds = arg1_4,
			totalCost = arg2_4
		})
	end)
	arg0_1:bind(var0_0.OPEN_DOCKYARD_INDEX, function(arg0_5, arg1_5)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_5
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_6)
	return {
		GAME.DESTROY_SHIP_DONE,
		FleetProxy.FLEET_UPDATED,
		GAME.EXIT_SHIP_DONE,
		GAME.UPDATE_EXERCISE_FLEET_DONE,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		PlayerProxy.UPDATED,
		GAME.WORLD_SHIP_REPAIR_DONE,
		GAME.UPDATE_LOCK_DONE,
		GAME.WORLD_FLEET_REDEPLOY_DONE
	}
end

function var0_0.handleNotification(arg0_7, arg1_7)
	local var0_7 = arg1_7:getName()
	local var1_7 = arg1_7:getBody()

	if var0_7 == GAME.DESTROY_SHIP_DONE then
		if not pg.m02:hasMediator(ShipMainMediator.__cname) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardMediator_destroy"))
		end

		for iter0_7, iter1_7 in ipairs(var1_7.destroiedShipIds) do
			arg0_7.viewComponent:removeShip(iter1_7)
		end

		arg0_7.viewComponent:updateShipCount()
		arg0_7.viewComponent:setShipsCount(getProxy(BayProxy):getShipCount())
		arg0_7.viewComponent:updateBarInfo()
		arg0_7.viewComponent:updateSelected()
		arg0_7.viewComponent:updateDestroyRes()

		local function var2_7()
			if table.getCount(var1_7.equipments) > 0 then
				local var0_8 = {}

				for iter0_8, iter1_8 in pairs(var1_7.equipments) do
					table.insert(var0_8, iter1_8)
				end

				arg0_7:addSubLayers(Context.New({
					viewComponent = ResolveEquipmentLayer,
					mediator = ResolveEquipmentMediator,
					data = {
						Equipments = var0_8
					}
				}))
			end
		end

		arg0_7.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1_7.bonus,
			title = AwardInfoLayer.TITLE.ITEM,
			removeFunc = var2_7
		})
		arg0_7.viewComponent:closeDestroyPanel()
	elseif var0_7 == FleetProxy.FLEET_UPDATED then
		local var3_7 = arg0_7.fleetShipIds

		arg0_7.fleetShipIds = arg0_7.fleetProxy:getAllShipIds()

		local var4_7 = {}

		for iter2_7, iter3_7 in ipairs(var3_7) do
			var4_7[iter3_7] = 1
		end

		for iter4_7, iter5_7 in ipairs(arg0_7.fleetShipIds) do
			if var4_7[iter5_7] == 1 then
				var4_7[iter5_7] = 2
			else
				var4_7[iter5_7] = 3
			end
		end

		for iter6_7, iter7_7 in ipairs(var3_7) do
			if var4_7[iter7_7] == 1 then
				var4_7[iter7_7] = 0
			end
		end

		for iter8_7, iter9_7 in pairs(var4_7) do
			if iter9_7 == 0 then
				arg0_7:setShipFlag(iter8_7, "inFleet", false)
			elseif iter9_7 == 3 then
				arg0_7:setShipFlag(iter8_7, "inFleet", true)
			end

			arg0_7.viewComponent:updateShipStatusById(iter8_7)
		end
	elseif var0_7 == GAME.EXIT_SHIP_DONE then
		arg0_7:setShipFlag(var1_7.id, "inBackyard", false)
		arg0_7.viewComponent:updateShipStatusById(var1_7.id)
	elseif var0_7 == GAME.UPDATE_LOCK_DONE then
		arg0_7.shipsById[var1_7.id].lockState = var1_7.lockState

		arg0_7.viewComponent:updateShipStatusById(var1_7.id)
	elseif var0_7 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0_7:setShipFlag(var1_7.shipId, "inTactics", false)
		arg0_7.viewComponent:updateShipStatusById(var1_7.shipId)
	elseif var0_7 == GAME.UPDATE_EXERCISE_FLEET_DONE then
		local var5_7 = var1_7.oldFleet
		local var6_7 = var1_7.newFleet

		for iter10_7, iter11_7 in ipairs(var5_7.ships) do
			arg0_7:setShipFlag(iter11_7, "inExercise", false)
			arg0_7.viewComponent:updateShipStatusById(iter11_7)
		end

		for iter12_7, iter13_7 in ipairs(var6_7.ships) do
			arg0_7:setShipFlag(iter13_7, "inExercise", true)
			arg0_7.viewComponent:updateShipStatusById(iter13_7)
		end
	elseif var0_7 == PlayerProxy.UPDATED then
		arg0_7.viewComponent:setPlayer(var1_7)
	elseif var0_7 == GAME.WORLD_SHIP_REPAIR_DONE then
		_.each(var1_7.shipIds, function(arg0_9)
			arg0_7.viewComponent:updateShipStatusById(arg0_9)
		end)
	elseif var0_7 == GAME.WORLD_FLEET_REDEPLOY_DONE then
		arg0_7.viewComponent:emit(BaseUI.ON_BACK)
	end
end

function var0_0.setShipFlag(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10.shipsById[arg1_10]

	if var0_10 then
		var0_10[arg2_10] = arg3_10
	end
end

return var0_0
