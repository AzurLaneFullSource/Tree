local var0_0 = class("CourtYardMediator", import("..base.ContextMediator"))

var0_0.SET_UP = "CourtYardMediator:SET_UP"
var0_0.RENAME = "CourtYardMediator:RENAME"
var0_0.FOLD = "CourtYardMediator:FOLD"
var0_0.SWITCH = "CourtYardMediator:SWITCH"
var0_0.GO_SHOP = "CourtYardMediator:GO_SHOP"
var0_0.OPEN_DECORATION = "CourtYardMediator:OPEN_DECORATION"
var0_0.SEL_TRAIN_SHIP = "CourtYardMediator:SEL_TRAIN_SHIP"
var0_0.SEL_REST_SHIP = "CourtYardMediator:SEL_REST_SHIP"
var0_0.GO_GRANARY = "CourtYardMediator:GO_GRANARY"
var0_0.OPEN_ADD_EXP = "CourtYardMediator:OPEN_ADD_EXP"
var0_0.CLOSE_ADD_EXP = "CourtYardMediator:CLOSE_ADD_EXP"
var0_0.UN_LOCK_2FLOOR = "CourtYardMediator:UN_LOCK_2FLOOR"
var0_0.GO_THEME_TEMPLATE = "CourtYardMediator:GO_THEME_TEMPLATE"
var0_0.ON_ADD_VISITOR_SHIP = "CourtYardMediator:ON_ADD_VISITOR_SHIP"
var0_0.ONE_KEY = "CourtYardMediator:ONE_KEY"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ONE_KEY, function(arg0_2)
		arg0_1:sendNotification(GAME.BACKYARD_ONE_KEY)
	end)
	arg0_1:bind(var0_0.ON_ADD_VISITOR_SHIP, function(arg0_3)
		local function var0_3(arg0_4)
			if arg0_4 then
				_courtyard:GetController():AddVisitorShip(arg0_4)
			end
		end

		local var1_3 = getProxy(DormProxy)
		local var2_3 = var1_3:GetVisitorShip()

		if var2_3 then
			var0_3(var2_3)

			return
		end

		arg0_1:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP, {
			callback = function()
				var0_3(var1_3:GetVisitorShip())
			end
		})
	end)
	arg0_1:bind(var0_0.GO_THEME_TEMPLATE, function(arg0_6)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BACKYARD_THEME_TEMPLATE)
	end)
	arg0_1:bind(var0_0.UN_LOCK_2FLOOR, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_7,
			count = arg2_7
		})
	end)
	arg0_1:bind(var0_0.GO_GRANARY, function()
		arg0_1:addSubLayers(Context.New({
			mediator = BackyardFeedMediator,
			viewComponent = BackyardFeedLayer
		}))
	end)
	arg0_1:bind(var0_0.SEL_TRAIN_SHIP, function(arg0_9)
		local var0_9 = _courtyard:GetController():GetMaxCntForShip()

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShipInfoMediator,
			viewComponent = NewBackYardShipInfoLayer,
			data = {
				type = Ship.STATE_TRAIN,
				MaxRsetPos = var0_9
			}
		}))
	end)
	arg0_1:bind(var0_0.SEL_REST_SHIP, function(arg0_10)
		local var0_10 = _courtyard:GetController():GetMaxCntForShip()

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShipInfoMediator,
			viewComponent = NewBackYardShipInfoLayer,
			data = {
				type = Ship.STATE_REST,
				MaxRsetPos = var0_10
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_SHOP, function(arg0_11, arg1_11)
		local var0_11 = arg1_11 and {
			onDeattch = function()
				arg0_1.viewComponent:emit(var0_0.OPEN_DECORATION)
			end
		}

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = var0_11
		}))
	end)
	arg0_1:bind(var0_0.OPEN_DECORATION, function(arg0_13)
		_courtyard:GetController():EnterEditMode()
	end)
	arg0_1:bind(var0_0.SWITCH, function(arg0_14, arg1_14)
		if getProxy(DormProxy).floor == arg1_14 then
			return
		end

		_courtyard:Dispose()

		_courtyard = nil

		gcAll()
		arg0_1.viewComponent:emit(var0_0.SET_UP, arg1_14)
		arg0_1.viewComponent:SwitchFloorDone()
	end)
	arg0_1:bind(var0_0.FOLD, function(arg0_15, arg1_15)
		arg0_1.viewComponent:FoldPanel(arg1_15)
	end)
	arg0_1:bind(var0_0.RENAME, function(arg0_16, arg1_16)
		arg0_1:sendNotification(GAME.BACKYARD_RENAME, arg1_16)
	end)
	arg0_1:bind(var0_0.SET_UP, function(arg0_17, arg1_17)
		getProxy(DormProxy).floor = arg1_17
		arg0_1.contextData.floor = arg1_17
		_courtyard = CourtYardBridge.New(arg0_1:GenCourtYardData(arg1_17))
	end)

	local var0_1 = arg0_1.contextData.dorm or getProxy(DormProxy):getRawData()

	arg0_1.viewComponent:SetDorm(var0_1)
end

function var0_0.listNotificationInterests(arg0_18)
	return {
		DormProxy.DORM_UPDATEED,
		DormProxy.INIMACY_AND_MONEY_ADD,
		DormProxy.SHIPS_EXP_ADDED,
		GAME.EXTEND_BACKYARD_AREA_DONE,
		GAME.BACKYARD_ADD_MONEY_DONE,
		GAME.BACKYARD_ADD_INTIMACY_DONE,
		GAME.BACKYARD_ONE_KEY_DONE,
		GAME.BACKYARD_SHIP_EXP_ADDED,
		GAME.OPEN_BACKYARD_SHOP,
		GAME.EXIT_SHIP_DONE,
		GAME.ADD_SHIP_DONE,
		GAME.LOAD_LAYERS,
		GAME.REMOVE_LAYERS,
		GAME.ON_APPLICATION_PAUSE,
		GAME.BUY_FURNITURE_DONE,
		GAME.ON_RECONNECTION,
		CourtYardEvent._EXTEND,
		CourtYardEvent._QUIT,
		CourtYardEvent._ENTER_MODE,
		CourtYardEvent._EXIT_MODE,
		CourtYardEvent._INITED,
		CourtYardEvent._NO_POS_TO_ADD_SHIP,
		CourtYardEvent._DRAG_ITEM,
		CourtYardEvent._DRAG_ITEM_END,
		CourtYardEvent._TOUCH_SHIP,
		CourtYardEvent._ADD_ITEM_FAILED,
		BackYardDecorationMediator.START_TAKE_THEME_PHOTO,
		BackYardDecorationMediator.END_TAKE_THEME_PHOTO
	}
end

function var0_0.handleNotification(arg0_19, arg1_19)
	local var0_19 = arg1_19:getName()
	local var1_19 = arg1_19:getBody()
	local var2_19 = arg1_19:getType()

	if var0_19 == DormProxy.SHIPS_EXP_ADDED then
		if arg0_19.contextData.OpenShop then
			return
		end

		if not CourtYardMediator.firstTimeAddExp and not pg.NewGuideMgr.GetInstance():IsBusy() then
			CourtYardMediator.firstTimeAddExp = true

			arg0_19:SettleExp(var1_19)
		elseif not arg0_19.isTipFood then
			arg0_19.viewComponent:ShowAddFoodTip()
		end

		arg0_19.isTipFood = true
	elseif var0_19 == GAME.LOAD_LAYERS then
		CourtYardMediator.firstTimeAddExp = true
	elseif var0_19 == GAME.REMOVE_LAYERS then
		arg0_19.viewComponent:OnRemoveLayer(var1_19)
	elseif var0_19 == CourtYardEvent._NO_POS_TO_ADD_SHIP then
		arg0_19:sendNotification(GAME.EXIT_SHIP, {
			shipId = var1_19
		})
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_notPosition_shipExit"))
		arg0_19.viewComponent:UpdateDorm(getProxy(DormProxy):getRawData(), BackYardConst.DORM_UPDATE_TYPE_SHIP)
	elseif var0_19 == CourtYardEvent._ADD_ITEM_FAILED then
		getProxy(DormProxy):getRawData():GetTheme(getProxy(DormProxy).floor):DeleteFurniture(var1_19)
	end

	arg0_19:handleCourtyardNotification(var0_19, var1_19, var2_19)
end

function var0_0.handleCourtyardNotification(arg0_20, arg1_20, arg2_20, arg3_20)
	if not _courtyard or not _courtyard:IsLoaed() then
		return
	end

	if arg1_20 == CourtYardEvent._QUIT then
		arg0_20.viewComponent:emit(BaseUI.ON_BACK)
	elseif arg1_20 == CourtYardEvent._INITED then
		arg0_20.viewComponent:OnCourtYardLoaded()
	elseif arg1_20 == GAME.LOAD_LAYERS then
		local var0_20 = arg2_20.context.mediator == NewBackYardShipInfoMediator

		_courtyard:GetController():OnOpenLayerOrCloseLayer(true, var0_20)
	elseif arg1_20 == GAME.REMOVE_LAYERS then
		local var1_20 = arg2_20.context.mediator == NewBackYardShipInfoMediator

		_courtyard:GetController():OnOpenLayerOrCloseLayer(false, var1_20)
	elseif arg1_20 == GAME.ON_APPLICATION_PAUSE and arg2_20 then
		_courtyard:GetController():OnApplicationPaused()
	end

	if arg0_20.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg1_20 == GAME.BACKYARD_ADD_MONEY_DONE then
		_courtyard:GetController():ClearShipCoin(arg2_20.id)
	elseif arg1_20 == GAME.EXIT_SHIP_DONE then
		_courtyard:GetController():ExitShip(arg2_20.id)
	elseif arg1_20 == GAME.BUY_FURNITURE_DONE then
		arg0_20.viewComponent:OnAddFurniture()
	elseif arg1_20 == GAME.ON_RECONNECTION then
		arg0_20.viewComponent:OnReconnection()
	elseif arg1_20 == GAME.ADD_SHIP_DONE then
		local var2_20 = getProxy(BayProxy):getShipById(arg2_20.id)

		if ({
			Ship.STATE_TRAIN,
			Ship.STATE_REST
		})[getProxy(DormProxy).floor] == var2_20.state then
			_courtyard:GetController():AddShip(var2_20)
		end
	elseif arg1_20 == GAME.BACKYARD_ADD_INTIMACY_DONE then
		_courtyard:GetController():ClearShipIntimacy(arg2_20.id)
	elseif arg1_20 == GAME.BACKYARD_ONE_KEY_DONE then
		for iter0_20, iter1_20 in ipairs(arg2_20.shipIds) do
			_courtyard:GetController():ClearShipCoin(iter1_20)
			_courtyard:GetController():ClearShipIntimacy(iter1_20)
		end
	elseif arg1_20 == GAME.EXTEND_BACKYARD_AREA_DONE then
		_courtyard:GetController():LevelUp()
	elseif arg1_20 == DormProxy.INIMACY_AND_MONEY_ADD then
		local var3_20 = arg2_20.id
		local var4_20 = arg2_20.money
		local var5_20 = arg2_20.intimacy

		_courtyard:GetController():UpdateShipCoinAndIntimacy(var3_20, var4_20, var5_20)
	elseif arg1_20 == GAME.BACKYARD_SHIP_EXP_ADDED then
		_courtyard:GetController():AddShipExp(arg2_20.id, arg2_20.exp)
	elseif arg1_20 == DormProxy.DORM_UPDATEED then
		arg0_20.viewComponent:UpdateDorm(getProxy(DormProxy):getRawData(), arg3_20)
	elseif arg1_20 == CourtYardEvent._ENTER_MODE then
		arg0_20:addSubLayers(Context.New({
			mediator = BackYardDecorationMediator,
			viewComponent = BackYardDecrationLayer
		}))
		arg0_20.viewComponent:OnEnterOrExitEdit(true)
	elseif arg1_20 == CourtYardEvent._EXIT_MODE then
		arg0_20.viewComponent:OnEnterOrExitEdit(false)
	elseif arg1_20 == GAME.OPEN_BACKYARD_SHOP then
		arg0_20.viewComponent:emit(var0_0.GO_SHOP, true)
	elseif arg1_20 == CourtYardEvent._EXTEND then
		arg0_20:OnExtend()
	elseif arg1_20 == BackYardDecorationMediator.START_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_20.viewComponent.mainTF, typeof(CanvasGroup)).alpha = 0

		_courtyard:GetController():OnTakeThemePhoto()
	elseif arg1_20 == BackYardDecorationMediator.END_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_20.viewComponent.mainTF, typeof(CanvasGroup)).alpha = 1

		_courtyard:GetController():OnEndTakeThemePhoto()
	elseif arg1_20 == CourtYardEvent._DRAG_ITEM then
		arg0_20.viewComponent:BlockEvents()
	elseif arg1_20 == CourtYardEvent._DRAG_ITEM_END then
		arg0_20.viewComponent:UnBlockEvents()
	elseif arg1_20 == CourtYardEvent._TOUCH_SHIP then
		local var6_20 = getProxy(TaskProxy):GetBackYardInterActionTaskList()

		if var6_20 and #var6_20 > 0 then
			for iter2_20, iter3_20 in ipairs(var6_20) do
				pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
					taskId = iter3_20.id
				})
			end
		end
	end
end

function var0_0.SettleExp(arg0_21, arg1_21)
	if arg0_21.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	local var0_21 = getProxy(DormProxy):getRawData()
	local var1_21 = getProxy(BayProxy)
	local var2_21 = 0

	for iter0_21, iter1_21 in ipairs(var0_21.shipIds) do
		local var3_21 = var1_21:RawGetShipById(iter1_21)

		if var3_21 and var3_21.state == Ship.STATE_TRAIN then
			var2_21 = var2_21 + 1
		end
	end

	local var4_21 = var0_21.load_exp * var2_21

	if var2_21 ~= 0 and (var4_21 ~= 0 or var0_21.food ~= 0) then
		onNextTick(function()
			arg0_21:addSubLayers(Context.New({
				mediator = BackYardSettlementMediator,
				viewComponent = BackYardSettlementLayer,
				data = {
					oldShips = arg1_21.oldShips,
					newShips = arg1_21.newShips
				}
			}))
		end)

		arg0_21.contextData.settleShipExp = true
	end
end

function var0_0.OnExtend(arg0_23)
	if getProxy(BagProxy):getItemCountById(ITEM_BACKYARD_AREA_EXTEND) <= 0 then
		local var0_23 = getProxy(DormProxy):getRawData():GetExpandId()
		local var1_23 = pg.shop_template[var0_23]
		local var2_23 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var1_23.resource_type
		}):getName()

		_BackyardMsgBoxMgr:Show({
			content = i18n("backyard_buyExtendItem_question", var1_23.resource_num .. var2_23),
			onYes = function()
				arg0_23:sendNotification(GAME.SHOPPING, {
					count = 1,
					id = var0_23
				})
			end
		})
	else
		arg0_23:sendNotification(GAME.USE_ITEM, {
			count = 1,
			id = ITEM_BACKYARD_AREA_EXTEND
		})
	end
end

function var0_0.remove(arg0_25)
	if _courtyard then
		_courtyard:Dispose()

		_courtyard = nil
	end
end

function var0_0.GenCourtYardData(arg0_26, arg1_26)
	local var0_26 = arg0_26.contextData.mode or CourtYardConst.SYSTEM_DEFAULT
	local var1_26
	local var2_26

	if var0_26 == CourtYardConst.SYSTEM_VISIT then
		var1_26 = arg0_26.contextData.dorm
		var2_26 = CourtYardConst.STYLE_INNER
	elseif var0_26 == CourtYardConst.SYSTEM_DEFAULT then
		var1_26 = getProxy(DormProxy):getRawData()
		var2_26 = CourtYardConst.STYLE_INNER
	elseif var0_26 == CourtYardConst.SYSTEM_FEAST then
		var1_26 = getProxy(FeastProxy):getRawData()
		var2_26 = CourtYardConst.STYLE_FEAST
	elseif var0_26 == CourtYardConst.SYSTEM_OUTSIDE then
		assert(false)

		var2_26 = CourtYardConst.STYLE_OUTSIDE
	elseif var0_26 == CourtYardConst.SYSTEM_EDIT_FEAST then
		var1_26 = getProxy(DormProxy):getRawData()
		var2_26 = CourtYardConst.STYLE_FEAST
	end

	local var3_26 = var1_26:GetMapSize()

	if var0_26 == CourtYardConst.SYSTEM_EDIT_FEAST then
		var3_26 = getProxy(FeastProxy):getRawData():GetMapSize()
	end

	local var4_26 = {
		[arg1_26] = {
			id = arg1_26,
			level = var1_26.level,
			furnitures = var1_26:GetPutFurnitureList(arg1_26),
			ships = var1_26:GetPutShipList(arg1_26)
		}
	}

	return {
		system = var0_26,
		storeys = var4_26,
		storeyId = arg1_26,
		style = var2_26,
		mapSize = var3_26,
		name = arg0_26.viewComponent:getUIName(),
		core = pg.m02
	}
end

return var0_0
