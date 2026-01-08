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
	arg0_1:bind(var0_0.ON_ADD_VISITOR_SHIP, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP, {
			callback = arg1_3
		})
	end)
	arg0_1:bind(var0_0.GO_THEME_TEMPLATE, function(arg0_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BACKYARD_THEME_TEMPLATE)
	end)
	arg0_1:bind(var0_0.UN_LOCK_2FLOOR, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.SHOPPING, {
			id = arg1_5,
			count = arg2_5
		})
	end)
	arg0_1:bind(var0_0.GO_GRANARY, function()
		arg0_1:addSubLayers(Context.New({
			mediator = BackyardFeedMediator,
			viewComponent = BackyardFeedLayer
		}))
	end)
	arg0_1:bind(var0_0.SEL_TRAIN_SHIP, function(arg0_7)
		local var0_7 = _courtyard:GetController():GetMaxCntForShip()

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShipInfoMediator,
			viewComponent = NewBackYardShipInfoLayer,
			data = {
				type = Ship.STATE_TRAIN,
				MaxRsetPos = var0_7
			}
		}))
	end)
	arg0_1:bind(var0_0.SEL_REST_SHIP, function(arg0_8)
		local var0_8 = _courtyard:GetController():GetMaxCntForShip()

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShipInfoMediator,
			viewComponent = NewBackYardShipInfoLayer,
			data = {
				type = Ship.STATE_REST,
				MaxRsetPos = var0_8
			}
		}))
	end)
	arg0_1:bind(var0_0.GO_SHOP, function(arg0_9, arg1_9)
		local var0_9 = arg1_9 and {
			onDeattch = function()
				arg0_1.viewComponent:emit(var0_0.OPEN_DECORATION)
			end
		}

		arg0_1:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = var0_9
		}))
	end)
	arg0_1:bind(var0_0.OPEN_DECORATION, function(arg0_11)
		_courtyard:GetController():EnterEditMode()
	end)
	arg0_1:bind(var0_0.SWITCH, function(arg0_12, arg1_12)
		if getProxy(DormProxy).floor == arg1_12 then
			return
		end

		_courtyard:Dispose()

		_courtyard = nil

		gcAll()
		arg0_1.viewComponent:emit(var0_0.SET_UP, arg1_12)
		arg0_1.viewComponent:SwitchFloorDone()
	end)
	arg0_1:bind(var0_0.FOLD, function(arg0_13, arg1_13)
		arg0_1.viewComponent:FoldPanel(arg1_13)
	end)
	arg0_1:bind(var0_0.RENAME, function(arg0_14, arg1_14)
		arg0_1:sendNotification(GAME.BACKYARD_RENAME, arg1_14)
	end)
	arg0_1:bind(var0_0.SET_UP, function(arg0_15, arg1_15)
		getProxy(DormProxy).floor = arg1_15
		arg0_1.contextData.floor = arg1_15
		_courtyard = CourtYardBridge.New(arg0_1:GenCourtYardData(arg1_15))
	end)

	local var0_1 = arg0_1.contextData.dorm or getProxy(DormProxy):getRawData()

	arg0_1.viewComponent:SetDorm(var0_1)
end

function var0_0.listNotificationInterests(arg0_16)
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

function var0_0.handleNotification(arg0_17, arg1_17)
	local var0_17 = arg1_17:getName()
	local var1_17 = arg1_17:getBody()
	local var2_17 = arg1_17:getType()

	if var0_17 == DormProxy.SHIPS_EXP_ADDED then
		if arg0_17.contextData.OpenShop then
			return
		end

		if not CourtYardMediator.firstTimeAddExp and not pg.NewGuideMgr.GetInstance():IsBusy() then
			CourtYardMediator.firstTimeAddExp = true

			arg0_17:SettleExp(var1_17)
		elseif not arg0_17.isTipFood then
			arg0_17.viewComponent:ShowAddFoodTip()
		end

		arg0_17.isTipFood = true
	elseif var0_17 == GAME.LOAD_LAYERS then
		CourtYardMediator.firstTimeAddExp = true
	elseif var0_17 == GAME.REMOVE_LAYERS then
		arg0_17.viewComponent:OnRemoveLayer(var1_17)
	elseif var0_17 == CourtYardEvent._NO_POS_TO_ADD_SHIP then
		arg0_17:sendNotification(GAME.EXIT_SHIP, {
			shipId = var1_17
		})
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_notPosition_shipExit"))
		arg0_17.viewComponent:UpdateDorm(getProxy(DormProxy):getRawData(), BackYardConst.DORM_UPDATE_TYPE_SHIP)
	elseif var0_17 == CourtYardEvent._ADD_ITEM_FAILED then
		getProxy(DormProxy):getRawData():GetTheme(getProxy(DormProxy).floor):DeleteFurniture(var1_17)
	end

	arg0_17:handleCourtyardNotification(var0_17, var1_17, var2_17)
end

function var0_0.handleCourtyardNotification(arg0_18, arg1_18, arg2_18, arg3_18)
	if not _courtyard or not _courtyard:IsLoaed() then
		return
	end

	if arg1_18 == CourtYardEvent._QUIT then
		arg0_18.viewComponent:emit(BaseUI.ON_BACK)
	elseif arg1_18 == CourtYardEvent._INITED then
		arg0_18.viewComponent:OnCourtYardLoaded()
	elseif arg1_18 == GAME.LOAD_LAYERS then
		local var0_18 = arg2_18.context.mediator == NewBackYardShipInfoMediator

		_courtyard:GetController():OnOpenLayerOrCloseLayer(true, var0_18)
	elseif arg1_18 == GAME.REMOVE_LAYERS then
		local var1_18 = arg2_18.context.mediator == NewBackYardShipInfoMediator

		_courtyard:GetController():OnOpenLayerOrCloseLayer(false, var1_18)
	elseif arg1_18 == GAME.ON_APPLICATION_PAUSE and arg2_18 then
		_courtyard:GetController():OnApplicationPaused()
	end

	if arg0_18.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg1_18 == GAME.BACKYARD_ADD_MONEY_DONE then
		_courtyard:GetController():ClearShipCoin(arg2_18.id)
	elseif arg1_18 == GAME.EXIT_SHIP_DONE then
		_courtyard:GetController():ExitShip(arg2_18.id)
	elseif arg1_18 == GAME.BUY_FURNITURE_DONE then
		arg0_18.viewComponent:OnAddFurniture()
	elseif arg1_18 == GAME.ON_RECONNECTION then
		arg0_18.viewComponent:OnReconnection()
	elseif arg1_18 == GAME.ADD_SHIP_DONE then
		local var2_18 = getProxy(BayProxy):getShipById(arg2_18.id)

		if ({
			Ship.STATE_TRAIN,
			Ship.STATE_REST
		})[getProxy(DormProxy).floor] == var2_18.state then
			_courtyard:GetController():AddShip(var2_18)
		end
	elseif arg1_18 == GAME.BACKYARD_ADD_INTIMACY_DONE then
		_courtyard:GetController():ClearShipIntimacy(arg2_18.id)
	elseif arg1_18 == GAME.BACKYARD_ONE_KEY_DONE then
		for iter0_18, iter1_18 in ipairs(arg2_18.shipIds) do
			_courtyard:GetController():ClearShipCoin(iter1_18)
			_courtyard:GetController():ClearShipIntimacy(iter1_18)
		end
	elseif arg1_18 == GAME.EXTEND_BACKYARD_AREA_DONE then
		_courtyard:GetController():LevelUp()
	elseif arg1_18 == DormProxy.INIMACY_AND_MONEY_ADD then
		local var3_18 = arg2_18.id
		local var4_18 = arg2_18.money
		local var5_18 = arg2_18.intimacy

		_courtyard:GetController():UpdateShipCoinAndIntimacy(var3_18, var4_18, var5_18)
	elseif arg1_18 == GAME.BACKYARD_SHIP_EXP_ADDED then
		_courtyard:GetController():AddShipExp(arg2_18.id, arg2_18.exp)
	elseif arg1_18 == DormProxy.DORM_UPDATEED then
		arg0_18.viewComponent:UpdateDorm(getProxy(DormProxy):getRawData(), arg3_18)
	elseif arg1_18 == CourtYardEvent._ENTER_MODE then
		arg0_18:addSubLayers(Context.New({
			mediator = BackYardDecorationMediator,
			viewComponent = BackYardDecrationLayer
		}))
		arg0_18.viewComponent:OnEnterOrExitEdit(true)
	elseif arg1_18 == CourtYardEvent._EXIT_MODE then
		arg0_18.viewComponent:OnEnterOrExitEdit(false)
	elseif arg1_18 == GAME.OPEN_BACKYARD_SHOP then
		arg0_18.viewComponent:emit(var0_0.GO_SHOP, true)
	elseif arg1_18 == CourtYardEvent._EXTEND then
		arg0_18:OnExtend()
	elseif arg1_18 == BackYardDecorationMediator.START_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_18.viewComponent.mainTF, typeof(CanvasGroup)).alpha = 0

		_courtyard:GetController():OnTakeThemePhoto()
	elseif arg1_18 == BackYardDecorationMediator.END_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0_18.viewComponent.mainTF, typeof(CanvasGroup)).alpha = 1

		_courtyard:GetController():OnEndTakeThemePhoto()
	elseif arg1_18 == CourtYardEvent._DRAG_ITEM then
		arg0_18.viewComponent:BlockEvents()
	elseif arg1_18 == CourtYardEvent._DRAG_ITEM_END then
		arg0_18.viewComponent:UnBlockEvents()
	elseif arg1_18 == CourtYardEvent._TOUCH_SHIP then
		local var6_18 = getProxy(TaskProxy):GetBackYardInterActionTaskList()

		if var6_18 and #var6_18 > 0 then
			for iter2_18, iter3_18 in ipairs(var6_18) do
				pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
					taskId = iter3_18.id
				})
			end
		end
	end
end

function var0_0.SettleExp(arg0_19, arg1_19)
	if arg0_19.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	local var0_19 = getProxy(DormProxy):getRawData()
	local var1_19 = getProxy(BayProxy)
	local var2_19 = 0

	for iter0_19, iter1_19 in ipairs(var0_19.shipIds) do
		local var3_19 = var1_19:RawGetShipById(iter1_19)

		if var3_19 and var3_19.state == Ship.STATE_TRAIN then
			var2_19 = var2_19 + 1
		end
	end

	local var4_19 = var0_19.load_exp * var2_19

	if var2_19 ~= 0 and (var4_19 ~= 0 or var0_19.food ~= 0) then
		onNextTick(function()
			arg0_19:addSubLayers(Context.New({
				mediator = BackYardSettlementMediator,
				viewComponent = BackYardSettlementLayer,
				data = {
					oldShips = arg1_19.oldShips,
					newShips = arg1_19.newShips
				}
			}))
		end)

		arg0_19.contextData.settleShipExp = true
	end
end

function var0_0.OnExtend(arg0_21)
	if getProxy(BagProxy):getItemCountById(ITEM_BACKYARD_AREA_EXTEND) <= 0 then
		local var0_21 = getProxy(DormProxy):getRawData():GetExpandId()
		local var1_21 = pg.shop_template[var0_21]
		local var2_21 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var1_21.resource_type
		}):getName()

		_BackyardMsgBoxMgr:Show({
			content = i18n("backyard_buyExtendItem_question", var1_21.resource_num .. var2_21),
			onYes = function()
				arg0_21:sendNotification(GAME.SHOPPING, {
					count = 1,
					id = var0_21
				})
			end
		})
	else
		arg0_21:sendNotification(GAME.USE_ITEM, {
			count = 1,
			id = ITEM_BACKYARD_AREA_EXTEND
		})
	end
end

function var0_0.remove(arg0_23)
	if _courtyard then
		_courtyard:Dispose()

		_courtyard = nil
	end
end

function var0_0.GenCourtYardData(arg0_24, arg1_24)
	local var0_24 = arg0_24.contextData.mode or CourtYardConst.SYSTEM_DEFAULT
	local var1_24
	local var2_24

	if var0_24 == CourtYardConst.SYSTEM_VISIT then
		var1_24 = arg0_24.contextData.dorm
		var2_24 = CourtYardConst.STYLE_INNER
	elseif var0_24 == CourtYardConst.SYSTEM_DEFAULT then
		var1_24 = getProxy(DormProxy):getRawData()
		var2_24 = CourtYardConst.STYLE_INNER
	elseif var0_24 == CourtYardConst.SYSTEM_FEAST then
		var1_24 = getProxy(FeastProxy):getRawData()
		var2_24 = CourtYardConst.STYLE_FEAST
	elseif var0_24 == CourtYardConst.SYSTEM_OUTSIDE then
		assert(false)

		var2_24 = CourtYardConst.STYLE_OUTSIDE
	elseif var0_24 == CourtYardConst.SYSTEM_EDIT_FEAST then
		var1_24 = getProxy(DormProxy):getRawData()
		var2_24 = CourtYardConst.STYLE_FEAST
	end

	local var3_24 = var1_24:GetMapSize()

	if var0_24 == CourtYardConst.SYSTEM_EDIT_FEAST then
		var3_24 = getProxy(FeastProxy):getRawData():GetMapSize()
	end

	local var4_24 = {
		[arg1_24] = {
			id = arg1_24,
			level = var1_24.level,
			furnitures = var1_24:GetPutFurnitureList(arg1_24),
			ships = var1_24:GetPutShipList(arg1_24)
		}
	}

	return {
		system = var0_24,
		storeys = var4_24,
		storeyId = arg1_24,
		style = var2_24,
		mapSize = var3_24,
		name = arg0_24.viewComponent:getUIName(),
		core = pg.m02
	}
end

return var0_0
