local var0 = class("MilitaryExerciseMediator", import("..base.ContextMediator"))

var0.OPEN_RANK = "MilitaryExerciseMediator:OPEN_RANK"
var0.OPEN_SHOP = "MilitaryExerciseMediator:OPEN_SHOP"
var0.OPEN_DOCKYARD = "MilitaryExerciseMediator:OPEN_DOCKYARD"
var0.REPLACE_RIVALS = "MilitaryExerciseMediator:REPLACE_RIVALS"
var0.RECOVER_UP = "MilitaryExerciseMediator:RECOVER_UP"
var0.START_BATTLE = "MilitaryExerciseMediator:START_BATTLE"
var0.OPEN_RIVAL_INFO = "MilitaryExerciseMediator:OPEN_RIVAL_INFO"

function var0.register(arg0)
	local var0 = getProxy(MilitaryExerciseProxy)
	local var1 = getProxy(PlayerProxy):getData()

	arg0.viewComponent:updatePlayer(var1)

	local var2 = getProxy(BayProxy):getRawData()

	arg0.viewComponent:setShips(var2)
	arg0:bind(var0.OPEN_RANK, function(arg0)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_MILITARY_RANK
		})
	end)
	arg0:bind(var0.OPEN_RIVAL_INFO, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = RivalInfoLayer,
			mediator = RivalInfoMediator,
			data = {
				rival = arg1,
				type = RivalInfoLayer.TYPE_BATTLE
			}
		}))
	end)
	arg0:bind(var0.OPEN_DOCKYARD, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.EXERCISEFORMATION)
	end)
	arg0:bind(var0.OPEN_SHOP, function(arg0, arg1)
		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1 or {
			warp = NewShopsScene.TYPE_MILITARY_SHOP
		})
	end)
	arg0:bind(var0.REPLACE_RIVALS, function(arg0)
		arg0:sendNotification(GAME.REPLACE_RIVALS)
	end)

	local var3 = getProxy(ActivityProxy):getMilitaryExerciseActivity()

	assert(var3, "不存在该活动")
	arg0.viewComponent:setActivity(var3)

	local var4 = var0:getSeasonInfo()

	if var4 then
		arg0.viewComponent:setSeasonInfo(var4)
	else
		arg0:sendNotification(GAME.GET_SEASON_INFO)
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.REPLACE_RIVALS_DONE,
		GAME.GET_SEASON_INFO_DONE,
		MilitaryExerciseProxy.EXERCISE_FLEET_UPDATED,
		PlayerProxy.UPDATED,
		MilitaryExerciseProxy.SEASON_INFO_UPDATED,
		GAME.MILITARY_STARTED,
		ActivityProxy.ACTIVITY_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.REPLACE_RIVALS_DONE then
		arg0.viewComponent:setRivals(var1)
		arg0.viewComponent:updateRivals()
		pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_replace_rivals_ok_tip"))
	elseif var0 == GAME.GET_SEASON_INFO_DONE then
		arg0.viewComponent:setSeasonInfo(var1)
	elseif var0 == MilitaryExerciseProxy.EXERCISE_FLEET_UPDATED then
		arg0.viewComponent:setFleet(var1)
		arg0.viewComponent:initPlayerFleet()
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:updatePlayer(var1)
	elseif var0 == MilitaryExerciseProxy.SEASON_INFO_UPDATED then
		arg0.viewComponent:updateSeaInfoVO(var1)
		arg0.viewComponent:updateSeasonTime()
	elseif var0 == GAME.MILITARY_STARTED then
		arg0:addSubLayers(Context.New({
			mediator = ExercisePreCombatMediator,
			viewComponent = ExercisePreCombatLayer,
			data = {
				stageId = 80000,
				system = var1.system,
				rivalId = var1.rivalId
			}
		}))
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED and var1.id == ActivityConst.MILITARY_EXERCISE_ACTIVITY_ID then
		arg0.viewComponent:setActivity(var1)
		arg0.viewComponent:updateSeasonLeftTime(var1.stopTime)
	end
end

return var0
