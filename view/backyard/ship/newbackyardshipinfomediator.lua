local var0 = class("NewBackYardShipInfoMediator", import("...base.ContextMediator"))

var0.EXTEND = "NewBackYardShipInfoMediator:EXTEND"
var0.OPEN_CHUANWU = "NewBackYardShipInfoMediator:OPEN_CHUANWU"
var0.UPDATE_SHIPS = "NewBackYardShipInfoMediator:UPDATE_SHIPS"
var0.LOOG_PRESS_SHIP = "NewBackYardShipInfoMediator:LOOG_PRESS_SHIP"

function var0.register(arg0)
	arg0:bind(var0.EXTEND, function(arg0, arg1)
		arg0:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1
		})
	end)
	arg0:bind(var0.LOOG_PRESS_SHIP, function(arg0, arg1, arg2)
		arg0.contextData.type = arg1

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg2.id
		})
	end)
	arg0:bind(var0.OPEN_CHUANWU, function(arg0, arg1, arg2)
		arg0.contextData.type = arg1

		arg0:OnSelShips(arg1, arg2)
	end)
end

function var0.OnSelShips(arg0, arg1, arg2)
	local var0 = getProxy(DormProxy):getRawData()
	local var1, var2, var3 = arg0:GetSelectedShips(var0, arg1, arg2)
	local var4 = {
		callbackQuit = true,
		selectedMax = arg0:GetMaxSel(var0, arg1),
		quitTeam = arg2 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = var3,
		preView = arg0.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0, arg1, arg2)
			return arg0:OnShip(var2, arg0, arg1, arg2)
		end,
		onSelected = function(arg0, arg1)
			arg0:OnSelected(arg1, arg2, arg0, function()
				arg0:sendNotification(var0.UPDATE_SHIPS)
				arg1()
			end)
		end,
		priorEquipUpShipIDList = {}
	}

	for iter0, iter1 in pairs(var1) do
		table.insert(var4.priorEquipUpShipIDList, iter1)
	end

	for iter2, iter3 in pairs(var2) do
		table.insert(var4.priorEquipUpShipIDList, iter3)
	end

	var4.leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	var4.isLayer = true
	var4.energyDisplay = true

	arg0:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var4
	}))
end

function var0.GetMaxSel(arg0, arg1, arg2)
	local var0 = 0

	if arg2 == Ship.STATE_TRAIN then
		var0 = arg1.exp_pos
	elseif arg2 == Ship.STATE_REST then
		var0 = arg1.rest_pos
	end

	return var0
end

function var0.GetSelectedShips(arg0, arg1, arg2, arg3)
	local var0 = arg3 and arg3.id or -1
	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(arg1.shipIds) do
		local var4 = getProxy(BayProxy):RawGetShipById(iter1)

		if var4.state == arg2 then
			table.insert(var1, var4.id)

			if var4.id ~= var0 then
				table.insert(var3, var4.id)
			end
		else
			table.insert(var2, var4.id)
		end
	end

	return var1, var2, var3
end

function var0.OnShip(arg0, arg1, arg2, arg3, arg4)
	if #arg4 > arg0.contextData.MaxRsetPos then
		return false, i18n("backyard_no_pos_for_ship")
	end

	if table.contains(arg1, arg2.id) then
		return false, i18n("backyard_backyardShipInfoMediator_shipState_rest")
	end

	local var0, var1 = ShipStatus.ShipStatusCheck("inBackyard", arg2, function(arg0)
		arg3()
	end)

	return var0, var1
end

function var0.OnSelected(arg0, arg1, arg2, arg3, arg4)
	local var0 = getProxy(DormProxy):getRawData():GetStateShipsById(arg1)

	pg.UIMgr.GetInstance():LoadingOn()

	if arg3 == nil or #arg3 == 0 then
		if arg2 then
			arg0:sendNotification(GAME.EXIT_SHIP, {
				shipId = arg2.id,
				callback = arg4
			})
		else
			arg4()
		end

		pg.UIMgr.GetInstance():LoadingOff()

		return
	end

	local var1 = {}

	for iter0, iter1 in pairs(var0) do
		if not table.contains(arg3, iter0) then
			table.insert(var1, function(arg0)
				arg0:sendNotification(GAME.EXIT_SHIP, {
					shipId = iter0,
					callback = arg0
				})
			end)
		end
	end

	arg0.contextData.shipIdToAdd = {}

	for iter2, iter3 in ipairs(arg3) do
		if not var0[iter3] then
			local var2 = arg1 == Ship.STATE_TRAIN and 1 or 2

			table.insert(arg0.contextData.shipIdToAdd, {
				iter3,
				var2
			})
		end
	end

	if arg0.contextData.shipIdToAdd and #arg0.contextData.shipIdToAdd > 0 then
		for iter4, iter5 in ipairs(arg0.contextData.shipIdToAdd) do
			table.insert(var1, function(arg0)
				arg0:sendNotification(GAME.ADD_SHIP, {
					id = iter5[1],
					type = iter5[2],
					callBack = arg0
				})
			end)
		end
	end

	if #var1 > 0 then
		seriesAsync(var1, function()
			arg0.contextData.shipIdToAdd = nil

			pg.UIMgr.GetInstance():LoadingOff()
			arg4()
		end)
	else
		pg.UIMgr.GetInstance():LoadingOff()
		arg4()
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.EXTEND_BACKYARD_DONE,
		var0.UPDATE_SHIPS
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.EXTEND_BACKYARD_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoMediator_ok_unlock"))
		arg0.viewComponent:UpdateSlots()
	elseif var0 == var0.UPDATE_SHIPS then
		arg0.viewComponent:UpdateSlots()
	end
end

return var0
