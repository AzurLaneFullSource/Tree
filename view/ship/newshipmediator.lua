local var0_0 = class("NewShipMediator", import("..base.ContextMediator"))

var0_0.ON_LOCK = "NewShipMediator:ON_LOCK"
var0_0.ON_EXIT = "NewShipMediator:ON_EXIT"
var0_0.ON_SKILLINFO = "NewShipMediator:ON_SKILLINFO"
var0_0.ON_EVALIATION = "NewShipMediator:ON_EVALIATION"
var0_0.ON_SKIP_BATCH = "NewShipMediator:ON_SKIP_BATCH"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.ship

	arg0_1.fromRemould = arg0_1.contextData.fromRemould

	assert(var0_1, "必须存在船")

	arg0_1.showTrans = var0_1:isRemoulded()

	arg0_1.viewComponent:setShip(var0_1)
	arg0_1:bind(var0_0.ON_EXIT, function(arg0_2, arg1_2, arg2_2)
		local var0_2 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_1.class)

		arg0_1:sendNotification(arg0_1.contextData.onExit or GAME.REMOVE_LAYERS, {
			context = var0_2
		})
	end)
	arg0_1:bind(var0_0.ON_SKIP_BATCH, function(arg0_3, arg1_3, arg2_3)
		getProxy(BuildShipProxy):setSkipBatchBuildFlag(true)

		local var0_3 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(arg0_1.class)

		arg0_1:sendNotification(arg0_1.contextData.onExit or GAME.REMOVE_LAYERS, {
			context = var0_3
		})
	end)
	arg0_1:bind(var0_0.ON_LOCK, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.UPDATE_LOCK, {
			ship_id_list = arg1_4,
			is_locked = arg2_4
		})
	end)
	arg0_1:bind(var0_0.ON_SKILLINFO, function(arg0_5, arg1_5, arg2_5)
		arg0_1:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = SkillInfoLayer,
			data = {
				fromNewShip = true,
				skillOnShip = arg2_5,
				skillId = arg1_5,
				LayerWeightMgr_weight = arg0_1.viewComponent:getWeightFromData()
			}
		}))
	end)
	arg0_1:bind(var0_0.ON_EVALIATION, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.FETCH_EVALUATION, arg1_6)
	end)

	local var1_1 = getProxy(PlayerProxy):getData()

	if var0_1:getRarity() >= 4 and not var1_1:GetCommonFlag(GAME_RESTOREVIEW_ALREADY) then
		pg.SdkMgr.GetInstance():StoreReview()
		arg0_1:sendNotification(GAME.COMMON_FLAG, {
			flagID = GAME_RESTOREVIEW_ALREADY
		})
	end
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.UPDATE_LOCK_DONE,
		GAME.FETCH_EVALUATION_DONE
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.UPDATE_LOCK_DONE then
		arg0_8.viewComponent:UpdateLockButton(var1_8:GetLockState())
		arg0_8.viewComponent:updateShip(var1_8)
	elseif var0_8 == GAME.FETCH_EVALUATION_DONE then
		if arg0_8.fromRemould then
			return
		end

		arg0_8:addSubLayers(Context.New({
			mediator = ShipEvaluationMediator,
			viewComponent = ShipEvaluationLayer,
			data = {
				groupId = var1_8,
				showTrans = arg0_8.showTrans,
				LayerWeightMgr_weight = arg0_8.viewComponent:getWeightFromData()
			}
		}))
	end
end

return var0_0
