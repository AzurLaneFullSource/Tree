local var0_0 = class("DockyardMediator", import("..base.ContextMediator"))

var0_0.ON_DESTROY_SHIPS = "DockyardMediator:ON_DESTROY_SHIPS"
var0_0.ON_SHIP_DETAIL = "DockyardMediator:ON_SHIP_DETAIL"
var0_0.ON_SHIP_REPAIR = "DockyardMediator:ON_SHIP_REPAIR"
var0_0.OPEN_DOCKYARD_INDEX = "DockyardMediator:OPEN_DOCKYARD_INDEX"
var0_0.CHANGE_SKIN = "DockyardMediator.CHANGE_SKIN"
var0_0.CHANGE_RANDOM_FLAG = "DockyardMediator.CHANGE_RANDOM_FLAG"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(BayProxy)

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

		for iter4_1, iter5_1 in pairs(var0_1.data) do
			arg0_1.shipsById[iter4_1] = iter5_1
		end
	end

	if arg0_1.contextData.mode == DockyardScene.MODE_MOD then
		local var1_1 = arg0_1.contextData.ignoredIds[1]

		arg0_1.viewComponent:setModShip(arg0_1.shipsById[var1_1]:clone())
	end

	arg0_1.fleetProxy = getProxy(FleetProxy)
	arg0_1.fleetShipIds = arg0_1.fleetProxy:getAllShipIds()

	if arg0_1.contextData.ignoredIds then
		for iter6_1, iter7_1 in ipairs(arg0_1.contextData.ignoredIds) do
			arg0_1.shipsById[iter7_1] = nil
		end
	end

	arg0_1.viewComponent:setShips(arg0_1.shipsById)
	arg0_1.viewComponent:setShipsCount(var0_1:getShipCount())

	local var2_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:setPlayer(var2_1)
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
	arg0_1:bind(var0_0.CHANGE_SKIN, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = SwichSkinMediator,
			viewComponent = SwichSkinLayer,
			data = {
				shipVO = arg1_6
			}
		}))
	end)
	arg0_1:bind(var0_0.CHANGE_RANDOM_FLAG, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.CHANGE_RANDOM_SHIPS, {
			addList = arg2_7 and {
				arg1_7
			} or {},
			deleteList = not arg2_7 and {
				arg1_7
			} or {}
		})
	end)
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		GAME.DESTROY_SHIP_DONE,
		FleetProxy.FLEET_UPDATED,
		GAME.EXIT_SHIP_DONE,
		GAME.UPDATE_EXERCISE_FLEET_DONE,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		PlayerProxy.UPDATED,
		GAME.WORLD_SHIP_REPAIR_DONE,
		GAME.UPDATE_LOCK_DONE,
		GAME.WORLD_FLEET_REDEPLOY_DONE,
		SetShipSkinCommand.SKIN_UPDATED
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == GAME.DESTROY_SHIP_DONE then
		if not pg.m02:hasMediator(ShipMainMediator.__cname) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardMediator_destroy"))
		end

		for iter0_9, iter1_9 in ipairs(var1_9.destroiedShipIds) do
			arg0_9.viewComponent:removeShip(iter1_9)
		end

		arg0_9.viewComponent:updateShipCount()
		arg0_9.viewComponent:setShipsCount(getProxy(BayProxy):getShipCount())
		arg0_9.viewComponent:updateBarInfo()
		arg0_9.viewComponent:updateSelected()
		arg0_9.viewComponent:updateDestroyRes()

		local function var2_9()
			if table.getCount(var1_9.equipments) > 0 then
				local var0_10 = {}

				for iter0_10, iter1_10 in pairs(var1_9.equipments) do
					table.insert(var0_10, iter1_10)
				end

				arg0_9:addSubLayers(Context.New({
					viewComponent = ResolveEquipmentLayer,
					mediator = ResolveEquipmentMediator,
					data = {
						Equipments = var0_10
					}
				}))
			end
		end

		arg0_9.viewComponent:emit(BaseUI.ON_AWARD, {
			items = var1_9.bonus,
			title = AwardInfoLayer.TITLE.ITEM,
			removeFunc = var2_9
		})
		arg0_9.viewComponent:closeDestroyPanel()
	elseif var0_9 == FleetProxy.FLEET_UPDATED then
		local var3_9 = arg0_9.fleetShipIds

		arg0_9.fleetShipIds = arg0_9.fleetProxy:getAllShipIds()

		local var4_9 = {}

		for iter2_9, iter3_9 in ipairs(var3_9) do
			var4_9[iter3_9] = 1
		end

		for iter4_9, iter5_9 in ipairs(arg0_9.fleetShipIds) do
			if var4_9[iter5_9] == 1 then
				var4_9[iter5_9] = 2
			else
				var4_9[iter5_9] = 3
			end
		end

		for iter6_9, iter7_9 in ipairs(var3_9) do
			if var4_9[iter7_9] == 1 then
				var4_9[iter7_9] = 0
			end
		end

		for iter8_9, iter9_9 in pairs(var4_9) do
			if iter9_9 == 0 then
				arg0_9:setShipFlag(iter8_9, "inFleet", false)
			elseif iter9_9 == 3 then
				arg0_9:setShipFlag(iter8_9, "inFleet", true)
			end

			arg0_9.viewComponent:updateShipStatusById(iter8_9)
		end
	elseif var0_9 == GAME.EXIT_SHIP_DONE then
		arg0_9:setShipFlag(var1_9.id, "inBackyard", false)
		arg0_9.viewComponent:updateShipStatusById(var1_9.id)
	elseif var0_9 == GAME.UPDATE_LOCK_DONE then
		arg0_9.shipsById[var1_9.id].lockState = var1_9.lockState

		arg0_9.viewComponent:updateShipStatusById(var1_9.id)
	elseif var0_9 == GAME.CANCEL_LEARN_TACTICS_DONE then
		arg0_9:setShipFlag(var1_9.shipId, "inTactics", false)
		arg0_9.viewComponent:updateShipStatusById(var1_9.shipId)
	elseif var0_9 == GAME.UPDATE_EXERCISE_FLEET_DONE then
		local var5_9 = var1_9.oldFleet
		local var6_9 = var1_9.newFleet

		for iter10_9, iter11_9 in ipairs(var5_9.ships) do
			arg0_9:setShipFlag(iter11_9, "inExercise", false)
			arg0_9.viewComponent:updateShipStatusById(iter11_9)
		end

		for iter12_9, iter13_9 in ipairs(var6_9.ships) do
			arg0_9:setShipFlag(iter13_9, "inExercise", true)
			arg0_9.viewComponent:updateShipStatusById(iter13_9)
		end
	elseif var0_9 == PlayerProxy.UPDATED then
		arg0_9.viewComponent:setPlayer(var1_9)
	elseif var0_9 == GAME.WORLD_SHIP_REPAIR_DONE then
		_.each(var1_9.shipIds, function(arg0_11)
			arg0_9.viewComponent:updateShipStatusById(arg0_11)
		end)
	elseif var0_9 == GAME.WORLD_FLEET_REDEPLOY_DONE then
		arg0_9.viewComponent:emit(BaseUI.ON_BACK)
	elseif var0_9 == SetShipSkinCommand.SKIN_UPDATED then
		if arg0_9.shipsById[var1_9.ship.id] then
			arg0_9.shipsById[var1_9.ship.id] = getProxy(BayProxy):RawGetShipById(var1_9.ship.id)
		end

		arg0_9.viewComponent:OnShipSkinChanged(var1_9.ship:GetShipPhantomMark())
	end
end

function var0_0.setShipFlag(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = arg0_12.shipsById[arg1_12]

	if var0_12 then
		var0_12[arg2_12] = arg3_12
	end
end

return var0_0
