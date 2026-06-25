local var0_0 = class("CarWashGameFlowSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.START_GAME = "CarWashGameFlowSystem.START_GAME"
var0_0.REQUEST_RESTART_GAME = "CarWashGameFlowSystem.REQUEST_RESTART_GAME"
var0_0.MODIFY_GAME_STATUS = "CarWashGameFlowSystem.MODIFY_GAME_STATUS"
var0_0.UPDATE_GAME_STATE = "CarWashGameFlowSystem.UPDATE_GAME_STATE"
var0_0.UPDATE_IS_SHOOTING = "CarWashGameFlowSystem.UPDATE_IS_SHOOTING"
var0_0.UPDATE_CURRENT_GUN_TYPE = "CarWashGameFlowSystem.UPDATE_CURRENT_GUN_TYPE"
var0_0.UPDATE_HEART_BEAT_VALUE = "CarWashGameFlowSystem.UPDATE_HEART_BEAT_VALUE"
var0_0.UPDATE_LADY_POS = "CarWashGameFlowSystem.UPDATE_LADY_POS"
var0_0.UPDATE_STAINS_COUNT_MAX = "CarWashGameFlowSystem.UPDATE_STAINS_COUNT_MAX"
var0_0.UPDATE_STAINS_COUNT = "CarWashGameFlowSystem.UPDATE_STAINS_COUNT"
var0_0.UPDATE_COUNTDOWN = "CarWashGameFlowSystem.UPDATE_COUNTDOWN"
var0_0.SWITCH_SHOOTING = "CarWashGameFlowSystem.SWITCH_SHOOTING"
var0_0.SWITCH_GUN_TYPE = "CarWashGameFlowSystem.SWITCH_GUN_TYPE"
var0_0.SWITCH_LADY_POS = "CarWashGameFlowSystem.SWITCH_LADY_POS"
var0_0.SWITCH_STATE = "CarWashGameFlowSystem.SWITCH_STATE"
var0_0.SET_STAINS_COUNT_MAX = "CarWashGameFlowSystem.SET_STAINS_COUNT_MAX"
var0_0.SET_STAINS_COUNT = "CarWashGameFlowSystem.SET_STAINS_COUNT"
var0_0.DECREASE_STAINS_COUNT = "CarWashGameFlowSystem.DECREASE_STAINS_COUNT"
var0_0.MODIFY_HEART_BEAT_VALUE = "CarWashGameFlowSystem.MODIFY_HEART_BEAT_VALUE"
var0_0.PLAY_PHASE2_REACTION = "CarWashGameFlowSystem.PLAY_PHASE2_REACTION"
var0_0.TRIGGER_HIDDEN_REACTION = "CarWashGameFlowSystem.TRIGGER_HIDDEN_REACTION"
var0_0.UPDATE_PHASE2_REACTION_PROGRESS = "CarWashGameFlowSystem.UPDATE_PHASE2_REACTION_PROGRESS"

function var0_0.OnInit(arg0_1)
	arg0_1.contextData = arg0_1:GetContextData()
	arg0_1.phase2ClickedTips = {}
	arg0_1.isPhaseTransitioning = false
	arg0_1.remainingTime = 0
	arg0_1.lastCountdownSeconds = nil
	arg0_1.isEnding = false
	arg0_1.isTimelineSequencePlaying = false
	arg0_1.isTransitionPlaying = false

	arg0_1:InitGameStatus()
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.START_GAME, function(arg0_3, arg1_3)
		arg0_2:StartGame(arg1_3)
	end)
	arg0_2:Bind(var0_0.REQUEST_RESTART_GAME, function(arg0_4)
		arg0_2:RestartGame()
	end)
	arg0_2:Bind(var0_0.MODIFY_GAME_STATUS, function(arg0_5, arg1_5, arg2_5)
		arg0_2:UpdateGameStatus(arg1_5, arg2_5)
	end)
	arg0_2:Bind(var0_0.SWITCH_SHOOTING, function(arg0_6)
		arg0_2:SetShooting(not arg0_2.contextData.gameStatus.isShooting)
	end)
	arg0_2:Bind(var0_0.SWITCH_GUN_TYPE, function(arg0_7, arg1_7)
		arg0_2:SetCurrentGunType(arg1_7)
	end)
	arg0_2:Bind(var0_0.SWITCH_LADY_POS, function(arg0_8, arg1_8)
		arg0_2:SetLadyPos(pg.dorm3d_carwash_pos[arg1_8])
	end)
	arg0_2:Bind(var0_0.SWITCH_STATE, function(arg0_9, arg1_9)
		arg0_2:SetGameState(arg1_9)
	end)
	arg0_2:Bind(var0_0.SET_STAINS_COUNT_MAX, function(arg0_10, arg1_10)
		arg0_2:SetStainsCountMax(arg1_10)
	end)
	arg0_2:Bind(var0_0.SET_STAINS_COUNT, function(arg0_11, arg1_11)
		arg0_2:SetStainsCount(arg1_11)
	end)
	arg0_2:Bind(var0_0.DECREASE_STAINS_COUNT, function(arg0_12, arg1_12)
		arg0_2:DecreaseStainsCount(arg1_12)
	end)
	arg0_2:Bind(var0_0.MODIFY_HEART_BEAT_VALUE, function(arg0_13, arg1_13)
		arg0_2:ModifyHeartBeatValue(arg1_13)
	end)
	arg0_2:Bind(var0_0.PLAY_PHASE2_REACTION, function(arg0_14, arg1_14)
		arg0_2:PlayPhase2Reaction(arg1_14)
	end)
	arg0_2:Bind(var0_0.TRIGGER_HIDDEN_REACTION, function(arg0_15, arg1_15)
		arg0_2:TriggerHiddenReaction(arg1_15)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function(arg0_16, arg1_16)
		arg0_2.isTimelineSequencePlaying = true
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function(arg0_17, arg1_17)
		arg0_2.isTimelineSequencePlaying = false
	end)
	arg0_2:Bind(CarWashTimelineSystem.TRANSITION_BEGIN, function(arg0_18, arg1_18)
		arg0_2.isTransitionPlaying = true
	end)
	arg0_2:Bind(CarWashTimelineSystem.TRANSITION_END, function(arg0_19, arg1_19)
		arg0_2.isTransitionPlaying = false
	end)
end

function var0_0.OnDispose(arg0_20)
	arg0_20.contextData = nil
	arg0_20.phase1LadyPosCache = nil
	arg0_20.phase2ClickedTips = nil
	arg0_20.isPhaseTransitioning = nil
	arg0_20.remainingTime = nil
	arg0_20.lastCountdownSeconds = nil
	arg0_20.isEnding = nil
	arg0_20.isTimelineSequencePlaying = nil
	arg0_20.isTransitionPlaying = nil
end

function var0_0.InitGameStatus(arg0_21)
	arg0_21.contextData.gameConfig = pg.dorm3d_carwash[arg0_21.contextData.groupId]
	arg0_21.contextData.gameStatus = {
		stainsCount = 0,
		stainsCountMax = 0,
		isShooting = false,
		heartBeatValue = 0,
		currentState = CarWashConst.GAME_STATE.NONE
	}
end

function var0_0.StartGame(arg0_22, arg1_22)
	arg0_22:ResetRuntimeState()
	seriesAsync({
		function(arg0_23)
			arg0_22:SetCurrentGunType(CarWashConst.GUN_TYPE.WASHER)
			arg0_22:SetLadyPos(pg.dorm3d_carwash_pos[arg0_22.contextData.gameConfig.pos[1]])
			arg0_22:Emit(CarWashDecalSystem.GENERATE_DECALS)
			arg0_23()
		end,
		function(arg0_24)
			if PlayerPrefs.GetInt("CarWashGuideShown", 0) == 0 then
				PlayerPrefs.SetInt("CarWashGuideShown", 1)
				arg0_22:Emit(CarWashMainPage.SHOW_HELP_BOX, arg0_24)
			else
				arg0_24()
			end
		end,
		function(arg0_25)
			arg0_22:SetGameState(CarWashConst.GAME_STATE.PHASE_1)
			arg0_25()
		end
	}, function()
		existCall(arg1_22)
	end)
end

function var0_0.ResetRuntimeState(arg0_27)
	arg0_27.phase1LadyPosCache = nil
	arg0_27.phase2ClickedTips = {}
	arg0_27.isPhaseTransitioning = false
	arg0_27.isEnding = false
	arg0_27.isTimelineSequencePlaying = false
	arg0_27.isTransitionPlaying = false
	arg0_27.remainingTime = CarWashConst.GAME_DURATION
	arg0_27.lastCountdownSeconds = nil

	arg0_27:EmitCountdown()
end

function var0_0.OnUpdate(arg0_28, arg1_28)
	arg0_28:UpdateCountdown(arg1_28)
end

function var0_0.IsCountdownRunning(arg0_29)
	if arg0_29.isEnding then
		return false
	end

	if arg0_29.isPhaseTransitioning then
		return false
	end

	if arg0_29.isTimelineSequencePlaying then
		return false
	end

	if arg0_29.isTransitionPlaying then
		return false
	end

	return arg0_29.contextData.gameStatus.currentState == CarWashConst.GAME_STATE.PHASE_1
end

function var0_0.UpdateCountdown(arg0_30, arg1_30)
	if not arg0_30:IsCountdownRunning() then
		return
	end

	arg0_30.remainingTime = math.max(arg0_30.remainingTime - arg1_30, 0)

	arg0_30:EmitCountdown()

	if arg0_30.remainingTime <= 0 then
		arg0_30:FinishGame()
	end
end

function var0_0.EmitCountdown(arg0_31)
	local var0_31 = math.max(math.ceil(arg0_31.remainingTime or 0), 0)

	if arg0_31.lastCountdownSeconds == var0_31 then
		return
	end

	arg0_31.lastCountdownSeconds = var0_31

	arg0_31:Emit(var0_0.UPDATE_COUNTDOWN, {
		remainingSeconds = var0_31
	})
end

function var0_0.GetGameStatusEventName(arg0_32, arg1_32)
	return switch(arg1_32, {
		currentState = function()
			return var0_0.UPDATE_GAME_STATE
		end,
		isShooting = function()
			return var0_0.UPDATE_IS_SHOOTING
		end,
		currentGunType = function()
			return var0_0.UPDATE_CURRENT_GUN_TYPE
		end,
		heartBeatValue = function()
			return var0_0.UPDATE_HEART_BEAT_VALUE
		end,
		ladyPos = function()
			return var0_0.UPDATE_LADY_POS
		end,
		stainsCountMax = function()
			return var0_0.UPDATE_STAINS_COUNT_MAX
		end,
		stainsCount = function()
			return var0_0.UPDATE_STAINS_COUNT
		end
	})
end

function var0_0.UpdateGameStatus(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40:GetGameStatusEventName(arg1_40)

	assert(var0_40, "CarWash gameStatus key not found: " .. tostring(arg1_40))

	local var1_40 = arg0_40.contextData.gameStatus[arg1_40]

	arg0_40.contextData.gameStatus[arg1_40] = arg2_40

	arg0_40:Emit(var0_40, {
		key = arg1_40,
		oldValue = var1_40,
		newValue = arg2_40
	})
end

function var0_0.SetGameState(arg0_41, arg1_41)
	local var0_41 = arg0_41.contextData.gameStatus.currentState

	if arg1_41 == CarWashConst.GAME_STATE.PHASE_2 and var0_41 ~= CarWashConst.GAME_STATE.PHASE_2 then
		arg0_41.phase1LadyPosCache = arg0_41.contextData.gameStatus.ladyPos

		arg0_41:ResetPhase2Progress()
		arg0_41:SetLadyPos(pg.dorm3d_carwash_pos[arg0_41.contextData.gameConfig.pos_phase2])
	elseif arg1_41 == CarWashConst.GAME_STATE.PHASE_1 and arg0_41.phase1LadyPosCache then
		arg0_41:SetLadyPos(arg0_41.phase1LadyPosCache)

		arg0_41.phase1LadyPosCache = nil

		arg0_41:ResetPhase2Progress()
	elseif arg1_41 == CarWashConst.GAME_STATE.END then
		arg0_41:SetShooting(false)
	end

	arg0_41:UpdateGameStatus("currentState", arg1_41)
end

function var0_0.SetShooting(arg0_42, arg1_42)
	arg0_42:UpdateGameStatus("isShooting", arg1_42)
end

function var0_0.SetCurrentGunType(arg0_43, arg1_43)
	arg0_43:UpdateGameStatus("currentGunType", arg1_43)
end

function var0_0.ModifyHeartBeatValue(arg0_44, arg1_44)
	local var0_44 = arg0_44.contextData.gameStatus.heartBeatValue
	local var1_44 = math.max(math.min(var0_44 + arg1_44, 100), 0)

	arg0_44:SetHeartBeatValue(var1_44)
end

function var0_0.SetHeartBeatValue(arg0_45, arg1_45)
	arg0_45:UpdateGameStatus("heartBeatValue", arg1_45)
	arg0_45:TryEnterPhase2ByHeartBeat(arg1_45)
end

function var0_0.TryEnterPhase2ByHeartBeat(arg0_46, arg1_46)
	local var0_46 = pg.dorm3d_carwash_pos[arg0_46.contextData.gameConfig.pos_phase2]

	if not var0_46 then
		return
	end

	if arg1_46 < var0_46.mood_value then
		return
	end

	if arg0_46.contextData.gameStatus.currentState == CarWashConst.GAME_STATE.PHASE_2 then
		return
	end

	if arg0_46.isPhaseTransitioning then
		return
	end

	arg0_46:EnterPhase2WithTransition()
end

function var0_0.EnterPhase2WithTransition(arg0_47)
	arg0_47.isPhaseTransitioning = true

	arg0_47:Emit(CarWashTimelineSystem.PLAY_TRANSITION, {
		waitHold = true,
		type = CarWashTimelineSystem.TRANSITION.WHITE,
		onHold = function(arg0_48, arg1_48)
			arg0_47:SetGameState(CarWashConst.GAME_STATE.PHASE_2)
			arg0_48()
		end,
		onFinish = function(arg0_49)
			arg0_47.isPhaseTransitioning = false
		end
	})
end

function var0_0.SetLadyPos(arg0_50, arg1_50)
	arg0_50:UpdateGameStatus("ladyPos", arg1_50)
end

function var0_0.SetStainsCountMax(arg0_51, arg1_51)
	arg0_51:UpdateGameStatus("stainsCountMax", arg1_51)
end

function var0_0.SetStainsCount(arg0_52, arg1_52)
	arg0_52:UpdateGameStatus("stainsCount", arg1_52)
	warning("Remain stains count:", arg1_52)
end

function var0_0.DecreaseStainsCount(arg0_53, arg1_53)
	local var0_53 = arg0_53.contextData.gameStatus.stainsCount

	arg0_53:SetStainsCount(math.max(var0_53 - arg1_53, 0))
end

function var0_0.ResetPhase2Progress(arg0_54)
	arg0_54.phase2ClickedTips = {}
end

function var0_0.PlayPhase2Reaction(arg0_55, arg1_55)
	assert(arg1_55, "CarWash phase2 reaction request is nil")
	assert(arg1_55.animId, "CarWash phase2 reaction animId is nil")

	if arg0_55.contextData.gameStatus.currentState ~= CarWashConst.GAME_STATE.PHASE_2 then
		return
	end

	if arg0_55.phase2ClickedTips[arg1_55.animId] then
		return
	end

	arg0_55:Emit(CarWashLadySystem.PLAY_PHASE2_REACTION, {
		animId = arg1_55.animId,
		callback = function(arg0_56)
			if not arg0_56 then
				return
			end

			arg0_55.phase2ClickedTips[arg1_55.animId] = true

			arg0_55:Emit(var0_0.UPDATE_PHASE2_REACTION_PROGRESS, {
				animId = arg1_55.animId,
				clickedTips = arg0_55.phase2ClickedTips
			})
			arg0_55:CheckAllPhase2TipsClicked()
		end
	})
end

function var0_0.CheckAllPhase2TipsClicked(arg0_57)
	local var0_57 = pg.dorm3d_carwash_pos[arg0_57.contextData.gameConfig.pos_phase2]

	assert(var0_57, "CarWash phase2 pos config not found: " .. tostring(arg0_57.contextData.gameConfig.pos_phase2))

	for iter0_57, iter1_57 in ipairs(var0_57.fury_anim) do
		if not arg0_57.phase2ClickedTips[iter1_57] then
			return
		end
	end

	arg0_57:ReturnToPhase1WithTransition()
end

function var0_0.ReturnToPhase1WithTransition(arg0_58)
	if arg0_58.isPhaseTransitioning then
		return
	end

	arg0_58.isPhaseTransitioning = true

	arg0_58:Emit(CarWashTimelineSystem.PLAY_TRANSITION, {
		waitHold = true,
		type = CarWashTimelineSystem.TRANSITION.WHITE,
		onHold = function(arg0_59, arg1_59)
			arg0_58:SetHeartBeatValue(0)
			arg0_58:SetGameState(CarWashConst.GAME_STATE.PHASE_1)
			arg0_59()
		end,
		onFinish = function(arg0_60)
			arg0_58.isPhaseTransitioning = false
		end
	})
end

function var0_0.FinishGame(arg0_61)
	if arg0_61.isEnding then
		return
	end

	if arg0_61.contextData.gameStatus.currentState == CarWashConst.GAME_STATE.END then
		return
	end

	arg0_61.isEnding = true
	arg0_61.remainingTime = 0

	arg0_61:EmitCountdown()
	arg0_61:SetGameState(CarWashConst.GAME_STATE.END)
	arg0_61:PlayEndArtTimeline()
end

function var0_0.PlayEndArtTimeline(arg0_62)
	arg0_62:Emit(CarWashTimelineSystem.PLAY_ART_TIMELINE, arg0_62.contextData.gameConfig.end_timeline)
end

function var0_0.RestartGame(arg0_63)
	if arg0_63.contextData.gameStatus.currentState ~= CarWashConst.GAME_STATE.END then
		return
	end

	arg0_63:Emit(CarWashTimelineSystem.EXIT_ART_TIMELINE, {
		onHold = function(arg0_64, arg1_64)
			arg0_63:InitGameStatus()
			arg0_63:StartGame(arg0_64)
		end,
		onFinish = function(arg0_65)
			return
		end
	})
end

function var0_0.TriggerHiddenReaction(arg0_66, arg1_66)
	if not arg1_66 then
		return
	end

	arg0_66:ModifyHeartBeatValue(arg1_66.mood_value_plus)
	arg0_66:Emit(CarWashTimelineSystem.PLAY_ART_TIMELINE, arg1_66.hidden_reaction)
end

return var0_0
