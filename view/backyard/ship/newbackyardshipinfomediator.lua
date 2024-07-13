local var0_0 = class("NewBackYardShipInfoMediator", import("...base.ContextMediator"))

var0_0.EXTEND = "NewBackYardShipInfoMediator:EXTEND"
var0_0.OPEN_CHUANWU = "NewBackYardShipInfoMediator:OPEN_CHUANWU"
var0_0.UPDATE_SHIPS = "NewBackYardShipInfoMediator:UPDATE_SHIPS"
var0_0.LOOG_PRESS_SHIP = "NewBackYardShipInfoMediator:LOOG_PRESS_SHIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EXTEND, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1_2
		})
	end)
	arg0_1:bind(var0_0.LOOG_PRESS_SHIP, function(arg0_3, arg1_3, arg2_3)
		arg0_1.contextData.type = arg1_3

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = arg2_3.id
		})
	end)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_4, arg1_4, arg2_4)
		arg0_1.contextData.type = arg1_4

		arg0_1:OnSelShips(arg1_4, arg2_4)
	end)
end

function var0_0.OnSelShips(arg0_5, arg1_5, arg2_5)
	local var0_5 = getProxy(DormProxy):getRawData()
	local var1_5, var2_5, var3_5 = arg0_5:GetSelectedShips(var0_5, arg1_5, arg2_5)
	local var4_5 = {
		callbackQuit = true,
		selectedMax = arg0_5:GetMaxSel(var0_5, arg1_5),
		quitTeam = arg2_5 ~= nil,
		ignoredIds = pg.ShipFlagMgr.GetInstance():FilterShips({
			isActivityNpc = true
		}),
		selectedIds = var3_5,
		preView = arg0_5.viewComponent.__cname,
		hideTagFlags = ShipStatus.TAG_HIDE_BACKYARD,
		blockTagFlags = ShipStatus.TAG_BLOCK_BACKYARD,
		onShip = function(arg0_6, arg1_6, arg2_6)
			return arg0_5:OnShip(var2_5, arg0_6, arg1_6, arg2_6)
		end,
		onSelected = function(arg0_7, arg1_7)
			arg0_5:OnSelected(arg1_5, arg2_5, arg0_7, function()
				arg0_5:sendNotification(var0_0.UPDATE_SHIPS)
				arg1_7()
			end)
		end,
		priorEquipUpShipIDList = {}
	}

	for iter0_5, iter1_5 in pairs(var1_5) do
		table.insert(var4_5.priorEquipUpShipIDList, iter1_5)
	end

	for iter2_5, iter3_5 in pairs(var2_5) do
		table.insert(var4_5.priorEquipUpShipIDList, iter3_5)
	end

	var4_5.leftTopWithFrameInfo = i18n("backyard_longpress_ship_tip")
	var4_5.isLayer = true
	var4_5.energyDisplay = true

	arg0_5:addSubLayers(Context.New({
		viewComponent = DockyardScene,
		mediator = DockyardMediator,
		data = var4_5
	}))
end

function var0_0.GetMaxSel(arg0_9, arg1_9, arg2_9)
	local var0_9 = 0

	if arg2_9 == Ship.STATE_TRAIN then
		var0_9 = arg1_9.exp_pos
	elseif arg2_9 == Ship.STATE_REST then
		var0_9 = arg1_9.rest_pos
	end

	return var0_9
end

function var0_0.GetSelectedShips(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg3_10 and arg3_10.id or -1
	local var1_10 = {}
	local var2_10 = {}
	local var3_10 = {}

	for iter0_10, iter1_10 in ipairs(arg1_10.shipIds) do
		local var4_10 = getProxy(BayProxy):RawGetShipById(iter1_10)

		if var4_10.state == arg2_10 then
			table.insert(var1_10, var4_10.id)

			if var4_10.id ~= var0_10 then
				table.insert(var3_10, var4_10.id)
			end
		else
			table.insert(var2_10, var4_10.id)
		end
	end

	return var1_10, var2_10, var3_10
end

function var0_0.OnShip(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	if #arg4_11 > arg0_11.contextData.MaxRsetPos then
		return false, i18n("backyard_no_pos_for_ship")
	end

	if table.contains(arg1_11, arg2_11.id) then
		return false, i18n("backyard_backyardShipInfoMediator_shipState_rest")
	end

	local var0_11, var1_11 = ShipStatus.ShipStatusCheck("inBackyard", arg2_11, function(arg0_12)
		arg3_11()
	end)

	return var0_11, var1_11
end

function var0_0.OnSelected(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	local var0_13 = getProxy(DormProxy):getRawData():GetStateShipsById(arg1_13)

	pg.UIMgr.GetInstance():LoadingOn()

	if arg3_13 == nil or #arg3_13 == 0 then
		if arg2_13 then
			arg0_13:sendNotification(GAME.EXIT_SHIP, {
				shipId = arg2_13.id,
				callback = arg4_13
			})
		else
			arg4_13()
		end

		pg.UIMgr.GetInstance():LoadingOff()

		return
	end

	local var1_13 = {}

	for iter0_13, iter1_13 in pairs(var0_13) do
		if not table.contains(arg3_13, iter0_13) then
			table.insert(var1_13, function(arg0_14)
				arg0_13:sendNotification(GAME.EXIT_SHIP, {
					shipId = iter0_13,
					callback = arg0_14
				})
			end)
		end
	end

	arg0_13.contextData.shipIdToAdd = {}

	for iter2_13, iter3_13 in ipairs(arg3_13) do
		if not var0_13[iter3_13] then
			local var2_13 = arg1_13 == Ship.STATE_TRAIN and 1 or 2

			table.insert(arg0_13.contextData.shipIdToAdd, {
				iter3_13,
				var2_13
			})
		end
	end

	if arg0_13.contextData.shipIdToAdd and #arg0_13.contextData.shipIdToAdd > 0 then
		for iter4_13, iter5_13 in ipairs(arg0_13.contextData.shipIdToAdd) do
			table.insert(var1_13, function(arg0_15)
				arg0_13:sendNotification(GAME.ADD_SHIP, {
					id = iter5_13[1],
					type = iter5_13[2],
					callBack = arg0_15
				})
			end)
		end
	end

	if #var1_13 > 0 then
		seriesAsync(var1_13, function()
			arg0_13.contextData.shipIdToAdd = nil

			pg.UIMgr.GetInstance():LoadingOff()
			arg4_13()
		end)
	else
		pg.UIMgr.GetInstance():LoadingOff()
		arg4_13()
	end
end

function var0_0.listNotificationInterests(arg0_17)
	return {
		GAME.EXTEND_BACKYARD_DONE,
		var0_0.UPDATE_SHIPS
	}
end

function var0_0.handleNotification(arg0_18, arg1_18)
	local var0_18 = arg1_18:getName()
	local var1_18 = arg1_18:getBody()

	if var0_18 == GAME.EXTEND_BACKYARD_DONE then
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_backyardShipInfoMediator_ok_unlock"))
		arg0_18.viewComponent:UpdateSlots()
	elseif var0_18 == var0_0.UPDATE_SHIPS then
		arg0_18.viewComponent:UpdateSlots()
	end
end

return var0_0
