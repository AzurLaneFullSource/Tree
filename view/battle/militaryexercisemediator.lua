local var0_0 = class("MilitaryExerciseMediator", import("..base.ContextMediator"))

var0_0.OPEN_RANK = "MilitaryExerciseMediator:OPEN_RANK"
var0_0.OPEN_SHOP = "MilitaryExerciseMediator:OPEN_SHOP"
var0_0.OPEN_DOCKYARD = "MilitaryExerciseMediator:OPEN_DOCKYARD"
var0_0.REPLACE_RIVALS = "MilitaryExerciseMediator:REPLACE_RIVALS"
var0_0.RECOVER_UP = "MilitaryExerciseMediator:RECOVER_UP"
var0_0.START_BATTLE = "MilitaryExerciseMediator:START_BATTLE"
var0_0.OPEN_RIVAL_INFO = "MilitaryExerciseMediator:OPEN_RIVAL_INFO"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(MilitaryExerciseProxy)
	local var1_1 = getProxy(PlayerProxy):getData()

	arg0_1.viewComponent:updatePlayer(var1_1)

	local var2_1 = getProxy(BayProxy):getRawData()

	arg0_1.viewComponent:setShips(var2_1)
	arg0_1:bind(var0_0.OPEN_RANK, function(arg0_2)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.BILLBOARD, {
			page = PowerRank.TYPE_MILITARY_RANK
		})
	end)
	arg0_1:bind(var0_0.OPEN_RIVAL_INFO, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = RivalInfoLayer,
			mediator = RivalInfoMediator,
			data = {
				rival = arg1_3,
				type = RivalInfoLayer.TYPE_BATTLE
			}
		}))
	end)
	arg0_1:bind(var0_0.OPEN_DOCKYARD, function(arg0_4, arg1_4, arg2_4)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.EXERCISEFORMATION)
	end)
	arg0_1:bind(var0_0.OPEN_SHOP, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHOP, arg1_5 or {
			warp = NewShopsScene.TYPE_MILITARY_SHOP
		})
	end)
	arg0_1:bind(var0_0.REPLACE_RIVALS, function(arg0_6)
		arg0_1:sendNotification(GAME.REPLACE_RIVALS)
	end)

	local var3_1 = getProxy(ActivityProxy):getMilitaryExerciseActivity()

	assert(var3_1, "不存在该活动")
	arg0_1.viewComponent:setActivity(var3_1)

	local var4_1 = var0_1:getSeasonInfo()

	if var4_1 then
		arg0_1.viewComponent:setSeasonInfo(var4_1)
	else
		arg0_1:sendNotification(GAME.GET_SEASON_INFO)
	end
end

function var0_0.listNotificationInterests(arg0_7)
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

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.REPLACE_RIVALS_DONE then
		arg0_8.viewComponent:setRivals(var1_8)
		arg0_8.viewComponent:updateRivals()
		pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_replace_rivals_ok_tip"))
	elseif var0_8 == GAME.GET_SEASON_INFO_DONE then
		arg0_8.viewComponent:setSeasonInfo(var1_8)
	elseif var0_8 == MilitaryExerciseProxy.EXERCISE_FLEET_UPDATED then
		arg0_8.viewComponent:setFleet(var1_8)
		arg0_8.viewComponent:initPlayerFleet()
	elseif var0_8 == PlayerProxy.UPDATED then
		arg0_8.viewComponent:updatePlayer(var1_8)
	elseif var0_8 == MilitaryExerciseProxy.SEASON_INFO_UPDATED then
		arg0_8.viewComponent:updateSeaInfoVO(var1_8)
		arg0_8.viewComponent:updateSeasonTime()
	elseif var0_8 == GAME.MILITARY_STARTED then
		arg0_8:addSubLayers(Context.New({
			mediator = ExercisePreCombatMediator,
			viewComponent = ExercisePreCombatLayer,
			data = {
				stageId = 80000,
				system = var1_8.system,
				rivalId = var1_8.rivalId
			}
		}))
	elseif var0_8 == ActivityProxy.ACTIVITY_UPDATED and var1_8.id == ActivityConst.MILITARY_EXERCISE_ACTIVITY_ID then
		arg0_8.viewComponent:setActivity(var1_8)
		arg0_8.viewComponent:updateSeasonLeftTime(var1_8.stopTime)
	end
end

return var0_0
