local var0 = class("NewBattleResultMediator", import("view.base.ContextMediator"))

var0.GET_NEW_SHIP = "NewBattleResultMediator:GET_NEW_SHIP"
var0.OPEN_FIALED_HELP = "NewBattleResultMediator:OPEN_FIALED_HELP"
var0.ON_ENTER_BATTLE_RESULT = "NewBattleResultMediator:ON_ENTER_BATTLE_RESULT"
var0.ON_COMPLETE_BATTLE_RESULT = "NewBattleResultMediator:ON_COMPLETE_BATTLE_RESULT"
var0.SET_SKIP_FLAG = "NewBattleResultMediator:SET_SKIP_FLAG"
var0.REENTER_STAGE = "NewBattleResultMediator:REENTER_STAGE"
var0.CHALLENGE_SHARE = "NewBattleResultMediator:ON_CHALLENGE_SHARE"
var0.CHALLENGE_DEFEAT_SCENE = "NewBattleResultMediator:CHALLENGE_DEFEAT_SCENE"

function var0.register(arg0)
	arg0:bind(var0.GET_NEW_SHIP, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1,
				autoExitTime = arg3
			},
			onRemoved = arg2
		}))
	end)
	arg0:bind(var0.OPEN_FIALED_HELP, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = arg0.contextData.newMainShips,
				battleSystem = arg0.contextData.system
			},
			onRemoved = arg1
		}))
	end)
	arg0:bind(var0.REENTER_STAGE, function(arg0)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0.contextData.stageId,
			mainFleetId = arg0.contextData.mainFleetId,
			system = arg0.contextData.system,
			actId = arg0.contextData.actId,
			rivalId = arg0.contextData.rivalId,
			continuousBattleTimes = arg0.contextData.continuousBattleTimes,
			totalBattleTimes = arg0.contextData.totalBattleTimes
		})
	end)
	arg0:bind(var0.CHALLENGE_SHARE, function(arg0)
		arg0:addSubLayers(Context.New({
			mediator = ChallengeShareMediator,
			viewComponent = ChallengeShareLayer,
			data = {
				mode = arg0.contextData.mode
			}
		}))
	end)
	arg0:bind(var0.CHALLENGE_DEFEAT_SCENE, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = ChallengePassedMediator,
			viewComponent = ChallengePassedLayer,
			data = {
				mode = arg0.contextData.mode
			},
			onRemoved = arg1.callback
		}))
	end)
	arg0:sendNotification(var0.ON_ENTER_BATTLE_RESULT)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.BEGIN_STAGE_DONE,
		NewBattleResultMediator.SET_SKIP_FLAG,
		ContinuousOperationMediator.CONTINUE_OPERATION,
		GAME.ACT_BOSS_EXCHANGE_TICKET_DONE,
		BossSingleContinuousOperationMediator.CONTINUE_OPERATION
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1)
	elseif var0 == ContinuousOperationMediator.CONTINUE_OPERATION then
		arg0.contextData.continuousBattleTimes = arg0.contextData.continuousBattleTimes - 1
	elseif var0 == NewBattleResultMediator.SET_SKIP_FLAG then
		arg0.contextData.autoSkipFlag = var1
	elseif var0 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		arg0.viewComponent:emit(var0.REENTER_STAGE)
	elseif var0 == BossSingleContinuousOperationMediator.CONTINUE_OPERATION then
		arg0.contextData.continuousBattleTimes = arg0.contextData.continuousBattleTimes - 1
	end
end

return var0
