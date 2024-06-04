local var0 = class("CourtYardMediator", import("..base.ContextMediator"))

var0.SET_UP = "CourtYardMediator:SET_UP"
var0.RENAME = "CourtYardMediator:RENAME"
var0.FOLD = "CourtYardMediator:FOLD"
var0.SWITCH = "CourtYardMediator:SWITCH"
var0.GO_SHOP = "CourtYardMediator:GO_SHOP"
var0.OPEN_DECORATION = "CourtYardMediator:OPEN_DECORATION"
var0.SEL_TRAIN_SHIP = "CourtYardMediator:SEL_TRAIN_SHIP"
var0.SEL_REST_SHIP = "CourtYardMediator:SEL_REST_SHIP"
var0.GO_GRANARY = "CourtYardMediator:GO_GRANARY"
var0.OPEN_ADD_EXP = "CourtYardMediator:OPEN_ADD_EXP"
var0.CLOSE_ADD_EXP = "CourtYardMediator:CLOSE_ADD_EXP"
var0.UN_LOCK_2FLOOR = "CourtYardMediator:UN_LOCK_2FLOOR"
var0.GO_THEME_TEMPLATE = "CourtYardMediator:GO_THEME_TEMPLATE"
var0.ON_ADD_VISITOR_SHIP = "CourtYardMediator:ON_ADD_VISITOR_SHIP"
var0.ONE_KEY = "CourtYardMediator:ONE_KEY"

function var0.register(arg0)
	arg0:bind(var0.ONE_KEY, function(arg0)
		arg0:sendNotification(GAME.BACKYARD_ONE_KEY)
	end)
	arg0:bind(var0.ON_ADD_VISITOR_SHIP, function(arg0)
		local function var0(arg0)
			if arg0 then
				_courtyard:GetController():AddVisitorShip(arg0)
			end
		end

		local var1 = getProxy(DormProxy)
		local var2 = var1:GetVisitorShip()

		if var2 then
			var0(var2)

			return
		end

		arg0:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP, {
			callback = function()
				var0(var1:GetVisitorShip())
			end
		})
	end)
	arg0:bind(var0.GO_THEME_TEMPLATE, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BACKYARD_THEME_TEMPLATE)
	end)
	arg0:bind(var0.UN_LOCK_2FLOOR, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.SHOPPING, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.GO_GRANARY, function()
		arg0:addSubLayers(Context.New({
			mediator = BackyardFeedMediator,
			viewComponent = BackyardFeedLayer
		}))
	end)
	arg0:bind(var0.SEL_TRAIN_SHIP, function(arg0)
		local var0 = _courtyard:GetController():GetMaxCntForShip()

		arg0:addSubLayers(Context.New({
			mediator = NewBackYardShipInfoMediator,
			viewComponent = NewBackYardShipInfoLayer,
			data = {
				type = Ship.STATE_TRAIN,
				MaxRsetPos = var0
			}
		}))
	end)
	arg0:bind(var0.SEL_REST_SHIP, function(arg0)
		local var0 = _courtyard:GetController():GetMaxCntForShip()

		arg0:addSubLayers(Context.New({
			mediator = NewBackYardShipInfoMediator,
			viewComponent = NewBackYardShipInfoLayer,
			data = {
				type = Ship.STATE_REST,
				MaxRsetPos = var0
			}
		}))
	end)
	arg0:bind(var0.GO_SHOP, function(arg0, arg1)
		local var0 = arg1 and {
			onDeattch = function()
				arg0.viewComponent:emit(var0.OPEN_DECORATION)
			end
		}

		arg0:addSubLayers(Context.New({
			mediator = NewBackYardShopMediator,
			viewComponent = NewBackYardShopLayer,
			data = var0
		}))
	end)
	arg0:bind(var0.OPEN_DECORATION, function(arg0)
		_courtyard:GetController():EnterEditMode()
	end)
	arg0:bind(var0.SWITCH, function(arg0, arg1)
		if getProxy(DormProxy).floor == arg1 then
			return
		end

		_courtyard:Dispose()

		_courtyard = nil

		gcAll()
		arg0.viewComponent:emit(var0.SET_UP, arg1)
		arg0.viewComponent:SwitchFloorDone()
	end)
	arg0:bind(var0.FOLD, function(arg0, arg1)
		arg0.viewComponent:FoldPanel(arg1)
	end)
	arg0:bind(var0.RENAME, function(arg0, arg1)
		arg0:sendNotification(GAME.BACKYARD_RENAME, arg1)
	end)
	arg0:bind(var0.SET_UP, function(arg0, arg1)
		getProxy(DormProxy).floor = arg1
		arg0.contextData.floor = arg1
		_courtyard = CourtYardBridge.New(arg0:GenCourtYardData(arg1))
	end)

	local var0 = arg0.contextData.dorm or getProxy(DormProxy):getRawData()

	arg0.viewComponent:SetDorm(var0)
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = arg1:getType()

	if var0 == DormProxy.SHIPS_EXP_ADDED then
		if arg0.contextData.OpenShop then
			return
		end

		if not CourtYardMediator.firstTimeAddExp and not pg.NewGuideMgr.GetInstance():IsBusy() then
			CourtYardMediator.firstTimeAddExp = true

			arg0:SettleExp(var1)
		elseif not arg0.isTipFood then
			arg0.viewComponent:ShowAddFoodTip()
		end

		arg0.isTipFood = true
	elseif var0 == GAME.LOAD_LAYERS then
		CourtYardMediator.firstTimeAddExp = true
	elseif var0 == GAME.REMOVE_LAYERS then
		arg0.viewComponent:OnRemoveLayer(var1)
	elseif var0 == CourtYardEvent._NO_POS_TO_ADD_SHIP then
		arg0:sendNotification(GAME.EXIT_SHIP, {
			shipId = var1
		})
		pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_notPosition_shipExit"))
		arg0.viewComponent:UpdateDorm(getProxy(DormProxy):getRawData(), BackYardConst.DORM_UPDATE_TYPE_SHIP)
	elseif var0 == CourtYardEvent._ADD_ITEM_FAILED then
		getProxy(DormProxy):getRawData():GetTheme(getProxy(DormProxy).floor):DeleteFurniture(var1)
	end

	arg0:handleCourtyardNotification(var0, var1, var2)
end

function var0.handleCourtyardNotification(arg0, arg1, arg2, arg3)
	if not _courtyard or not _courtyard:IsLoaed() then
		return
	end

	if arg1 == CourtYardEvent._QUIT then
		arg0.viewComponent:emit(BaseUI.ON_BACK)
	elseif arg1 == CourtYardEvent._INITED then
		arg0.viewComponent:OnCourtYardLoaded()
	elseif arg1 == GAME.LOAD_LAYERS then
		local var0 = arg2.context.mediator == NewBackYardShipInfoMediator

		_courtyard:GetController():OnOpenLayerOrCloseLayer(true, var0)
	elseif arg1 == GAME.REMOVE_LAYERS then
		local var1 = arg2.context.mediator == NewBackYardShipInfoMediator

		_courtyard:GetController():OnOpenLayerOrCloseLayer(false, var1)
	elseif arg1 == GAME.ON_APPLICATION_PAUSE and arg2 then
		_courtyard:GetController():OnApplicationPaused()
	end

	if arg0.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	if arg1 == GAME.BACKYARD_ADD_MONEY_DONE then
		_courtyard:GetController():ClearShipCoin(arg2.id)
	elseif arg1 == GAME.EXIT_SHIP_DONE then
		_courtyard:GetController():ExitShip(arg2.id)
	elseif arg1 == GAME.BUY_FURNITURE_DONE then
		arg0.viewComponent:OnAddFurniture()
	elseif arg1 == GAME.ON_RECONNECTION then
		arg0.viewComponent:OnReconnection()
	elseif arg1 == GAME.ADD_SHIP_DONE then
		local var2 = getProxy(BayProxy):getShipById(arg2.id)

		if ({
			Ship.STATE_TRAIN,
			Ship.STATE_REST
		})[getProxy(DormProxy).floor] == var2.state then
			_courtyard:GetController():AddShip(var2)
		end
	elseif arg1 == GAME.BACKYARD_ADD_INTIMACY_DONE then
		_courtyard:GetController():ClearShipIntimacy(arg2.id)
	elseif arg1 == GAME.BACKYARD_ONE_KEY_DONE then
		for iter0, iter1 in ipairs(arg2.shipIds) do
			_courtyard:GetController():ClearShipCoin(iter1)
			_courtyard:GetController():ClearShipIntimacy(iter1)
		end
	elseif arg1 == GAME.EXTEND_BACKYARD_AREA_DONE then
		_courtyard:GetController():LevelUp()
	elseif arg1 == DormProxy.INIMACY_AND_MONEY_ADD then
		local var3 = arg2.id
		local var4 = arg2.money
		local var5 = arg2.intimacy

		_courtyard:GetController():UpdateShipCoinAndIntimacy(var3, var4, var5)
	elseif arg1 == GAME.BACKYARD_SHIP_EXP_ADDED then
		_courtyard:GetController():AddShipExp(arg2.id, arg2.exp)
	elseif arg1 == DormProxy.DORM_UPDATEED then
		arg0.viewComponent:UpdateDorm(getProxy(DormProxy):getRawData(), arg3)
	elseif arg1 == CourtYardEvent._ENTER_MODE then
		arg0:addSubLayers(Context.New({
			mediator = BackYardDecorationMediator,
			viewComponent = BackYardDecrationLayer
		}))
		arg0.viewComponent:OnEnterOrExitEdit(true)
	elseif arg1 == CourtYardEvent._EXIT_MODE then
		arg0.viewComponent:OnEnterOrExitEdit(false)
	elseif arg1 == GAME.OPEN_BACKYARD_SHOP then
		arg0.viewComponent:emit(var0.GO_SHOP, true)
	elseif arg1 == CourtYardEvent._EXTEND then
		arg0:OnExtend()
	elseif arg1 == BackYardDecorationMediator.START_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0.viewComponent.mainTF, typeof(CanvasGroup)).alpha = 0

		_courtyard:GetController():OnTakeThemePhoto()
	elseif arg1 == BackYardDecorationMediator.END_TAKE_THEME_PHOTO then
		GetOrAddComponent(arg0.viewComponent.mainTF, typeof(CanvasGroup)).alpha = 1

		_courtyard:GetController():OnEndTakeThemePhoto()
	elseif arg1 == CourtYardEvent._DRAG_ITEM then
		arg0.viewComponent:BlockEvents()
	elseif arg1 == CourtYardEvent._DRAG_ITEM_END then
		arg0.viewComponent:UnBlockEvents()
	elseif arg1 == CourtYardEvent._TOUCH_SHIP then
		local var6 = getProxy(TaskProxy):GetBackYardInterActionTaskList()

		if var6 and #var6 > 0 then
			for iter2, iter3 in ipairs(var6) do
				pg.m02:sendNotification(GAME.UPDATE_TASK_PROGRESS, {
					taskId = iter3.id
				})
			end
		end
	end
end

function var0.SettleExp(arg0, arg1)
	if arg0.contextData.mode == CourtYardConst.SYSTEM_VISIT then
		return
	end

	local var0 = getProxy(DormProxy):getRawData()
	local var1 = getProxy(BayProxy)
	local var2 = 0

	for iter0, iter1 in ipairs(var0.shipIds) do
		local var3 = var1:RawGetShipById(iter1)

		if var3 and var3.state == Ship.STATE_TRAIN then
			var2 = var2 + 1
		end
	end

	local var4 = var0.load_exp * var2

	if var2 ~= 0 and (var4 ~= 0 or var0.food ~= 0) then
		onNextTick(function()
			arg0:addSubLayers(Context.New({
				mediator = BackYardSettlementMediator,
				viewComponent = BackYardSettlementLayer,
				data = {
					oldShips = arg1.oldShips,
					newShips = arg1.newShips
				}
			}))
		end)

		arg0.contextData.settleShipExp = true
	end
end

function var0.OnExtend(arg0)
	if getProxy(BagProxy):getItemCountById(ITEM_BACKYARD_AREA_EXTEND) <= 0 then
		local var0 = getProxy(DormProxy):getRawData():GetExpandId()
		local var1 = pg.shop_template[var0]
		local var2 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var1.resource_type
		}):getName()

		_BackyardMsgBoxMgr:Show({
			content = i18n("backyard_buyExtendItem_question", var1.resource_num .. var2),
			onYes = function()
				arg0:sendNotification(GAME.SHOPPING, {
					count = 1,
					id = var0
				})
			end
		})
	else
		arg0:sendNotification(GAME.USE_ITEM, {
			count = 1,
			id = ITEM_BACKYARD_AREA_EXTEND
		})
	end
end

function var0.remove(arg0)
	if _courtyard then
		_courtyard:Dispose()

		_courtyard = nil
	end
end

function var0.GenCourtYardData(arg0, arg1)
	local var0 = arg0.contextData.mode or CourtYardConst.SYSTEM_DEFAULT
	local var1
	local var2

	if var0 == CourtYardConst.SYSTEM_VISIT then
		var1 = arg0.contextData.dorm
		var2 = CourtYardConst.STYLE_INNER
	elseif var0 == CourtYardConst.SYSTEM_DEFAULT then
		var1 = getProxy(DormProxy):getRawData()
		var2 = CourtYardConst.STYLE_INNER
	elseif var0 == CourtYardConst.SYSTEM_FEAST then
		var1 = getProxy(FeastProxy):getRawData()
		var2 = CourtYardConst.STYLE_FEAST
	elseif var0 == CourtYardConst.SYSTEM_OUTSIDE then
		assert(false)

		var2 = CourtYardConst.STYLE_OUTSIDE
	elseif var0 == CourtYardConst.SYSTEM_EDIT_FEAST then
		var1 = getProxy(DormProxy):getRawData()
		var2 = CourtYardConst.STYLE_FEAST
	end

	local var3 = var1:GetMapSize()

	if var0 == CourtYardConst.SYSTEM_EDIT_FEAST then
		var3 = getProxy(FeastProxy):getRawData():GetMapSize()
	end

	local var4 = {
		[arg1] = {
			id = arg1,
			level = var1.level,
			furnitures = var1:GetPutFurnitureList(arg1),
			ships = var1:GetPutShipList(arg1)
		}
	}

	return {
		system = var0,
		storeys = var4,
		storeyId = arg1,
		style = var2,
		mapSize = var3,
		name = arg0.viewComponent:getUIName(),
		core = pg.m02
	}
end

return var0
