local var0 = class("DockyardMediator", import("..base.ContextMediator"))

var0.ON_DESTROY_SHIPS = "DockyardMediator:ON_DESTROY_SHIPS"
var0.ON_SHIP_DETAIL = "DockyardMediator:ON_SHIP_DETAIL"
var0.ON_SHIP_REPAIR = "DockyardMediator:ON_SHIP_REPAIR"
var0.OPEN_DOCKYARD_INDEX = "DockyardMediator:OPEN_DOCKYARD_INDEX"

function var0.register(arg0)
	if arg0.contextData.selectFriend then
		local var0 = getProxy(FriendProxy):getAllFriends()

		arg0.viewComponent:setFriends(var0)
	end

	local var1 = getProxy(BayProxy)

	if arg0.contextData.shipVOs then
		arg0.shipsById = {}

		for iter0, iter1 in ipairs(arg0.contextData.shipVOs) do
			arg0.shipsById[iter1.id] = iter1
		end
	elseif arg0.contextData.mode == DockyardScene.MODE_WORLD then
		arg0.shipsById = {}

		for iter2, iter3 in ipairs(nowWorld():GetShipVOs()) do
			arg0.shipsById[iter3.id] = iter3
		end
	else
		arg0.shipsById = {}

		for iter4, iter5 in pairs(var1.data) do
			arg0.shipsById[iter4] = iter5
		end
	end

	if arg0.contextData.mode == DockyardScene.MODE_MOD then
		local var2 = arg0.contextData.ignoredIds[1]

		arg0.viewComponent:setModShip(arg0.shipsById[var2]:clone())
	end

	arg0.fleetProxy = getProxy(FleetProxy)
	arg0.fleetShipIds = arg0.fleetProxy:getAllShipIds()

	if arg0.contextData.ignoredIds then
		for iter6, iter7 in ipairs(arg0.contextData.ignoredIds) do
			arg0.shipsById[iter7] = nil
		end
	end

	arg0.viewComponent:setShips(arg0.shipsById)
	arg0.viewComponent:setShipsCount(var1:getShipCount())

	local var3 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:setPlayer(var3)
	arg0:bind(var0.ON_DESTROY_SHIPS, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.DESTROY_SHIPS, {
			destroyEquipment = arg2,
			shipIds = arg1
		})
	end)
	arg0:bind(var0.ON_SHIP_DETAIL, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg1.id,
			shipVOs = arg2,
			selectContextData = arg3
		})
	end)
	arg0:bind(var0.ON_SHIP_REPAIR, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.WORLD_SHIP_REPAIR, {
			shipIds = arg1,
			totalCost = arg2
		})
	end)
	arg0:bind(var0.OPEN_DOCKYARD_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.DESTROY_SHIP_DONE then
		if not pg.m02:hasMediator(ShipMainMediator.__cname) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardMediator_destroy"))
		end

		for iter0, iter1 in ipairs(var1.destroiedShipIds) do
			arg0.viewComponent:removeShip(iter1)
		end

		arg0.viewComponent:updateShipCount()
		arg0.viewComponent:setShipsCount(getProxy(BayProxy):getShipCount())
		arg0.viewComponent:updateBarInfo()
		arg0.viewComponent:updateSelected()
		arg0.viewComponent:updateDestroyRes()

		local function var2()
			if table.getCount(var1.equipments) > 0 then
				local var0 = {}

				for iter0, iter1 in pairs(var1.equipments) do
					table.insert(var0, iter1)
				end

				arg0:addSubLayers(Context.New({
					viewComponent = ResolveEquipmentLayer,
					mediator = ResolveEquipmentMediator,
					data = {
						Equipments = var0
					}
				}))
			end
		end

		arg0.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1.bonus,
			title = AwardInfoLayer.TITLE.ITEM,
			removeFunc = var2
		})
		arg0.viewComponent:closeDestroyPanel()
	elseif var0 == FleetProxy.FLEET_UPDATED then
		local var3 = arg0.fleetShipIds

		arg0.fleetShipIds = arg0.fleetProxy:getAllShipIds()

		local var4 = {}

		for iter2, iter3 in ipairs(var3) do
			var4[iter3] = 1
		end

		for iter4, iter5 in ipairs(arg0.fleetShipIds) do
			if var4[iter5] == 1 then
				var4[iter5] = 2
			else
				var4[iter5] = 3
			end
		end

		for iter6, iter7 in ipairs(var3) do
			if var4[iter7] == 1 then
				var4[iter7] = 0
			end
		end

		for iter8, iter9 in pairs(var4) do
			if iter9 == 0 then
				arg0:setShipFlag(iter8, "inFleet", false)
			elseif iter9 == 3 then
				arg0:setShipFlag(iter8, "inFleet", true)
			end

			arg0.viewComponent:updateShipStatusById(iter8)
		end
	elseif var0 == GAME.EXIT_SHIP_DONE then
		arg0:setShipFlag(var1.id, "inBackyard", false)
		arg0.viewComponent:updateShipStatusById(var1.id)
	elseif var0 == GAME.UPDATE_LOCK_DONE then
		arg0.shipsById[var1.id].lockState = var1.lockState

		arg0.viewComponent:updateShipStatusById(var1.id)
	elseif var0 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0:setShipFlag(var1.shipId, "inTactics", false)
		arg0.viewComponent:updateShipStatusById(var1.shipId)
	elseif var0 == GAME.UPDATE_EXERCISE_FLEET_DONE then
		local var5 = var1.oldFleet
		local var6 = var1.newFleet

		for iter10, iter11 in ipairs(var5.ships) do
			arg0:setShipFlag(iter11, "inExercise", false)
			arg0.viewComponent:updateShipStatusById(iter11)
		end

		for iter12, iter13 in ipairs(var6.ships) do
			arg0:setShipFlag(iter13, "inExercise", true)
			arg0.viewComponent:updateShipStatusById(iter13)
		end
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(var1)
	elseif var0 == GAME.WORLD_SHIP_REPAIR_DONE then
		_.each(var1.shipIds, function(arg0)
			arg0.viewComponent:updateShipStatusById(arg0)
		end)
	elseif var0 == GAME.WORLD_FLEET_REDEPLOY_DONE then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	end
end

function var0.setShipFlag(arg0, arg1, arg2, arg3)
	local var0 = arg0.shipsById[arg1]

	if var0 then
		var0[arg2] = arg3
	end
end

return var0
