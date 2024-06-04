local var0 = class("NewShipMediator", import("..base.ContextMediator"))

var0.ON_LOCK = "NewShipMediator:ON_LOCK"
var0.ON_EXIT = "NewShipMediator:ON_EXIT"
var0.ON_SKILLINFO = "NewShipMediator:ON_SKILLINFO"
var0.ON_EVALIATION = "NewShipMediator:ON_EVALIATION"
var0.ON_SKIP_BATCH = "NewShipMediator:ON_SKIP_BATCH"

function var0.register(arg0)
	local var0 = arg0.contextData.ship

	arg0.fromRemould = arg0.contextData.fromRemould

	assert(var0, "必须存在船")

	arg0.showTrans = var0:isRemoulded()

	arg0.viewComponent:setShip(var0)
	arg0:bind(var0.ON_EXIT, function(arg0, arg1, arg2)
		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0.class)

		arg0:sendNotification(arg0.contextData.onExit or GAME.REMOVE_LAYERS, {
			context = var0
		})
	end)
	arg0:bind(var0.ON_SKIP_BATCH, function(arg0, arg1, arg2)
		getProxy(BuildShipProxy):setSkipBatchBuildFlag(true)

		local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0.class)

		arg0:sendNotification(arg0.contextData.onExit or GAME.REMOVE_LAYERS, {
			context = var0
		})
	end)
	arg0:bind(var0.ON_LOCK, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.UPDATE_LOCK, {
			ship_id_list = arg1,
			is_locked = arg2
		})
	end)
	arg0:bind(var0.ON_SKILLINFO, function(arg0, arg1, arg2)
		arg0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				fromNewShip = true,
				skillOnShip = arg2,
				skillId = arg1,
				LayerWeightMgr_weight = arg0.viewComponent:getWeightFromData()
			}
		}))
	end)
	arg0:bind(var0.ON_EVALIATION, function(arg0, arg1)
		arg0:sendNotification(GAME.FETCH_EVALUATION, arg1)
	end)

	local var1 = getProxy(PlayerProxy):getData()

	if var0:getRarity() >= 4 and not var1:GetCommonFlag(GAME_RESTOREVIEW_ALREADY) then
		pg.SdkMgr.GetInstance():StoreReview()
		arg0:sendNotification(GAME.COMMON_FLAG, {
			flagID = GAME_RESTOREVIEW_ALREADY
		})
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.UPDATE_LOCK_DONE,
		GAME.FETCH_EVALUATION_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.UPDATE_LOCK_DONE then
		arg0.viewComponent:UpdateLockButton(var1:GetLockState())
		arg0.viewComponent:updateShip(var1)
	elseif var0 == GAME.FETCH_EVALUATION_DONE then
		if arg0.fromRemould then
			return
		end

		arg0:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1,
				showTrans = arg0.showTrans,
				LayerWeightMgr_weight = arg0.viewComponent:getWeightFromData()
			}
		}))
	end
end

return var0
