local var0_0 = class("NewBattleResultMediator", import("view.base.ContextMediator"))

var0_0.GET_NEW_SHIP = "NewBattleResultMediator:GET_NEW_SHIP"
var0_0.OPEN_FIALED_HELP = "NewBattleResultMediator:OPEN_FIALED_HELP"
var0_0.ON_ENTER_BATTLE_RESULT = "NewBattleResultMediator:ON_ENTER_BATTLE_RESULT"
var0_0.ON_COMPLETE_BATTLE_RESULT = "NewBattleResultMediator:ON_COMPLETE_BATTLE_RESULT"
var0_0.SET_SKIP_FLAG = "NewBattleResultMediator:SET_SKIP_FLAG"
var0_0.REENTER_STAGE = "NewBattleResultMediator:REENTER_STAGE"
var0_0.CHALLENGE_SHARE = "NewBattleResultMediator:ON_CHALLENGE_SHARE"
var0_0.CHALLENGE_DEFEAT_SCENE = "NewBattleResultMediator:CHALLENGE_DEFEAT_SCENE"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.GET_NEW_SHIP, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:addSubLayers(Context.New({
			mediator = NewShipMediator,
			viewComponent = NewShipLayer,
			data = {
				ship = arg1_2,
				autoExitTime = arg3_2
			},
			onRemoved = arg2_2
		}))
	end)
	arg0_1:bind(var0_0.OPEN_FIALED_HELP, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = BattleFailTipMediator,
			viewComponent = BattleFailTipLayer,
			data = {
				mainShips = arg0_1.contextData.newMainShips,
				battleSystem = arg0_1.contextData.system
			},
			onRemoved = arg1_3
		}))
	end)
	arg0_1:bind(var0_0.REENTER_STAGE, function(arg0_4)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			stageId = arg0_1.contextData.stageId,
			mainFleetId = arg0_1.contextData.mainFleetId,
			system = arg0_1.contextData.system,
			actId = arg0_1.contextData.actId,
			rivalId = arg0_1.contextData.rivalId,
			continuousBattleTimes = arg0_1.contextData.continuousBattleTimes,
			totalBattleTimes = arg0_1.contextData.totalBattleTimes
		})
	end)
	arg0_1:bind(var0_0.CHALLENGE_SHARE, function(arg0_5)
		arg0_1:addSubLayers(Context.New({
			mediator = ChallengeShareMediator,
			viewComponent = ChallengeShareLayer,
			data = {
				mode = arg0_1.contextData.mode
			}
		}))
	end)
	arg0_1:bind(var0_0.CHALLENGE_DEFEAT_SCENE, function(arg0_6, arg1_6)
		arg0_1:addSubLayers(Context.New({
			mediator = ChallengePassedMediator,
			viewComponent = ChallengePassedLayer,
			data = {
				mode = arg0_1.contextData.mode
			},
			onRemoved = arg1_6.callback
		}))
	end)
	arg0_1:sendNotification(var0_0.ON_ENTER_BATTLE_RESULT)
end

function var0_0.listNotificationInterests(arg0_7)
	return {
		GAME.BEGIN_STAGE_DONE,
		NewBattleResultMediator.SET_SKIP_FLAG,
		ContinuousOperationMediator.CONTINUE_OPERATION,
		GAME.ACT_BOSS_EXCHANGE_TICKET_DONE,
		BossSingleContinuousOperationMediator.CONTINUE_OPERATION
	}
end

function var0_0.handleNotification(arg0_8, arg1_8)
	local var0_8 = arg1_8:getName()
	local var1_8 = arg1_8:getBody()

	if var0_8 == GAME.BEGIN_STAGE_DONE then
		arg0_8:sendNotification(GAME.CHANGE_SCENE, SCENE.COMBATLOAD, var1_8)
	elseif var0_8 == ContinuousOperationMediator.CONTINUE_OPERATION then
		arg0_8.contextData.continuousBattleTimes = arg0_8.contextData.continuousBattleTimes - 1
	elseif var0_8 == NewBattleResultMediator.SET_SKIP_FLAG then
		arg0_8.contextData.autoSkipFlag = var1_8
	elseif var0_8 == GAME.ACT_BOSS_EXCHANGE_TICKET_DONE then
		arg0_8.viewComponent:emit(var0_0.REENTER_STAGE)
	elseif var0_8 == BossSingleContinuousOperationMediator.CONTINUE_OPERATION then
		arg0_8.contextData.continuousBattleTimes = arg0_8.contextData.continuousBattleTimes - 1
	end
end

return var0_0
