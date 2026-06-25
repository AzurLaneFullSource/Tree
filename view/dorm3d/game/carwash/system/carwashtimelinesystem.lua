local var0_0 = class("CarWashTimelineSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.PLAY_TRANSITION = "CarWashTimelineSystem.PLAY_TRANSITION"
var0_0.PLAY_ART_TIMELINE = "CarWashTimelineSystem.PLAY_ART_TIMELINE"
var0_0.EXIT_ART_TIMELINE = "CarWashTimelineSystem.EXIT_ART_TIMELINE"
var0_0.TRANSITION_BEGIN = "CarWashTimelineSystem.TRANSITION_BEGIN"
var0_0.TRANSITION_HOLD = "CarWashTimelineSystem.TRANSITION_HOLD"
var0_0.TRANSITION_END = "CarWashTimelineSystem.TRANSITION_END"
var0_0.TIMELINE_SEQUENCE_BEGIN = "CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN"
var0_0.TIMELINE_SEQUENCE_END = "CarWashTimelineSystem.TIMELINE_SEQUENCE_END"
var0_0.ART_TIMELINE_SIGNAL = "CarWashTimelineSystem.ART_TIMELINE_SIGNAL"
var0_0.TRANSITION = {
	WHITE = "white",
	BLACK = "black"
}
var0_0.SIGNAL = {
	TRANSITION_HOLD = "TransitionHold",
	EXIT_TRANSITION = "ExitTransition",
	TIMELINE_END = "TimelineEnd"
}
var0_0.DEFAULT_SEQUENCE_PATH = "[sequence]"
var0_0.DEFAULT_TRANSITION_ASSETS = {
	white = "dorm3d/scenesres/scenes/carwash/gameplayasset/pla_fade-in-out_whitetimeline",
	black = "dorm3d/scenesres/scenes/carwash/gameplayasset/pla_fade-in-out_blacktimeline"
}

function var0_0.OnInit(arg0_1)
	arg0_1.transitionAssets = {}
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.PLAY_TRANSITION, function(arg0_3, arg1_3)
		arg0_2:PlayTransition(arg1_3)
	end)
	arg0_2:Bind(var0_0.PLAY_ART_TIMELINE, function(arg0_4, arg1_4)
		arg0_2:PlayArtTimeline(arg1_4)
	end)
	arg0_2:Bind(var0_0.EXIT_ART_TIMELINE, function(arg0_5, arg1_5)
		arg0_2:StartArtExitTransition(arg1_5)
	end)
end

function var0_0.OnDispose(arg0_6)
	arg0_6.exited = true

	arg0_6:StopTransition()
	arg0_6:DisposeArtPlayer()

	if arg0_6.artSceneInfo then
		SceneOpMgr.Inst:UnloadSceneAsync(arg0_6.artSceneInfo.path, arg0_6.artSceneInfo.name)

		arg0_6.artSceneInfo = nil
	end

	if arg0_6.transitionPlayer and arg0_6.transitionPlayer.signalReceiver then
		arg0_6.transitionPlayer.signalReceiver:SetCommonEvent(nil)
	end

	if arg0_6.transitionGO then
		Destroy(arg0_6.transitionGO)
	end

	arg0_6.transitionPlayer = nil
	arg0_6.transitionDirector = nil
	arg0_6.transitionGO = nil
	arg0_6.transitionContext = nil
	arg0_6.transitionAssets = nil
	arg0_6.artContext = nil
end

function var0_0.GetOrCreateTransitionDirector(arg0_7)
	if arg0_7.transitionDirector then
		return arg0_7.transitionDirector
	end

	arg0_7.transitionGO = GameObject.New("[CarWashTransitionDirector]")
	arg0_7.transitionDirector = GetOrAddComponent(arg0_7.transitionGO, typeof(UnityEngine.Playables.PlayableDirector))
	arg0_7.transitionDirector.playOnAwake = false

	return arg0_7.transitionDirector
end

function var0_0.SetTransitionAsset(arg0_8, arg1_8)
	local var0_8 = arg0_8:GetOrCreateTransitionDirector()

	var0_8:Stop()

	var0_8.playableAsset = arg1_8

	if not arg0_8.transitionPlayer then
		arg0_8.transitionPlayer = TimelinePlayer.New(var0_8.transform, UnityEngine.Playables.DirectorWrapMode.None)
	end

	arg0_8.transitionPlayer:Register(nil, function(arg0_9, arg1_9, arg2_9)
		arg0_8:OnTransitionSignal(arg1_9)
	end)

	return arg0_8.transitionPlayer
end

function var0_0.PlayTransition(arg0_10, arg1_10)
	assert(arg1_10, "CarWash transition data is nil")
	assert(arg1_10.type, "CarWash transition type is nil")
	assert(var0_0.DEFAULT_TRANSITION_ASSETS[arg1_10.type], "CarWash transition asset config not found: " .. tostring(arg1_10.type))
	assert(not arg0_10.isTransitionPlaying, "CarWash transition is already playing: " .. tostring(arg1_10.type))
	arg0_10:LoadTransitionAsset(arg1_10, function(arg0_11)
		assert(not arg0_10.exited, "CarWash transition asset loaded after system disposed")

		local var0_11 = arg0_10:SetTransitionAsset(arg0_11)

		arg0_10.transitionContext = {
			holdResumed = false,
			type = arg1_10.type,
			data = arg1_10
		}
		arg0_10.isTransitionPlaying = true

		arg0_10:Emit(var0_0.TRANSITION_BEGIN, {
			type = arg1_10.type,
			data = arg1_10
		})
		var0_11:SetTime(0)
		var0_11:Start()
	end)
end

function var0_0.LoadTransitionAsset(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg1_12.type

	if arg0_12.transitionAssets[var0_12] then
		existCall(arg2_12, arg0_12.transitionAssets[var0_12])

		return
	end

	local var1_12 = var0_0.DEFAULT_TRANSITION_ASSETS[arg1_12.type]

	assert(var1_12, "CarWash transition asset path is nil: " .. tostring(arg1_12.type))
	arg0_12:GetLoader():LoadReference(var1_12, "", typeof(UnityEngine.Playables.PlayableAsset), function(arg0_13)
		assert(arg0_13, "CarWash transition asset load failed: " .. tostring(var1_12))

		arg0_12.transitionAssets[var0_12] = arg0_13

		existCall(arg2_12, arg0_13)
	end)
end

function var0_0.OnTransitionSignal(arg0_14, arg1_14)
	local var0_14 = arg1_14.stringParameter

	if var0_14 == var0_0.SIGNAL.TRANSITION_HOLD then
		arg0_14:OnTransitionHold(arg1_14)
	elseif var0_14 == var0_0.SIGNAL.TIMELINE_END then
		arg0_14:OnTransitionEnd(arg1_14)
	else
		assert(false, "Unknown CarWash transition signal: " .. tostring(var0_14))
	end
end

function var0_0.OnTransitionHold(arg0_15, arg1_15)
	local var0_15 = arg0_15.transitionContext

	assert(var0_15, "CarWash transition context is nil")
	assert(not var0_15.holdResumed, "CarWash transition hold signal triggered more than once")
	assert(arg0_15.transitionPlayer, "CarWash transition player is nil")

	var0_15.holdResumed = true

	arg0_15.transitionPlayer:SetSpeed(0)

	local var1_15 = false

	local function var2_15()
		assert(not var1_15, "CarWash transition resumed more than once")
		assert(arg0_15.transitionPlayer, "CarWash transition player is nil")

		var1_15 = true

		arg0_15.transitionPlayer:SetSpeed(1)
	end

	local var3_15 = var0_15.data

	arg0_15:Emit(var0_0.TRANSITION_HOLD, {
		type = var0_15.type,
		data = var3_15,
		event = arg1_15,
		resume = var2_15
	})

	if var3_15.onHold then
		var3_15.onHold(var2_15, arg1_15)
	elseif not var3_15.waitHold then
		var2_15()
	end
end

function var0_0.OnTransitionEnd(arg0_17, arg1_17)
	local var0_17 = arg0_17.transitionContext

	assert(var0_17, "CarWash transition context is nil")

	local var1_17 = var0_17.data
	local var2_17 = var0_17.type

	arg0_17.isTransitionPlaying = false
	arg0_17.transitionContext = nil

	arg0_17:Emit(var0_0.TRANSITION_END, {
		type = var2_17,
		data = var1_17,
		event = arg1_17
	})

	if var1_17 and var1_17.onFinish then
		var1_17.onFinish(arg1_17)
	end
end

function var0_0.StopTransition(arg0_18)
	if arg0_18.transitionPlayer then
		arg0_18.transitionPlayer:SetSpeed(1)
		arg0_18.transitionPlayer:Stop()
	end

	arg0_18.isTransitionPlaying = false
	arg0_18.transitionContext = nil
end

function var0_0.PlayArtTimeline(arg0_19, arg1_19)
	assert(arg1_19, "CarWash art timeline data is nil")
	assert(not arg0_19.artContext, "CarWash art timeline is already playing")

	arg0_19.artContext = {
		exitTransitionStarted = false,
		data = arg1_19
	}

	arg0_19:PlayTransition({
		waitHold = true,
		type = arg0_19.artContext.data.enter,
		onHold = function(arg0_20)
			arg0_19:LoadArtScene(arg1_19, function()
				arg0_19:Emit(var0_0.TIMELINE_SEQUENCE_BEGIN, {
					data = arg1_19
				})
				arg0_19:StartArtPlayer(arg1_19)
				arg0_20()
			end)
		end
	})
end

function var0_0.LoadArtScene(arg0_22, arg1_22, arg2_22)
	assert(arg1_22.sceneAB, "CarWash art timeline sceneAB is nil")
	assert(arg1_22.sceneName, "CarWash art timeline sceneName is nil")

	arg0_22.artSceneInfo = {
		path = arg1_22.sceneAB,
		name = arg1_22.sceneName
	}

	SceneOpMgr.Inst:LoadSceneAsync(arg1_22.sceneAB, arg1_22.sceneName, LoadSceneMode.Additive, function(arg0_23, arg1_23)
		assert(not arg0_22.exited, "CarWash art timeline scene loaded after system disposed")
		existCall(arg2_22, arg0_23, arg1_23)
	end)
end

function var0_0.StartArtPlayer(arg0_24, arg1_24)
	local var0_24 = arg0_24:FindArtDirector(arg1_24)

	assert(var0_24, "CarWash art timeline director not found")

	arg0_24.artDirector = var0_24
	arg0_24.artDirector.playOnAwake = false

	TimelineSupport.DisablePlayOnAwake(arg0_24.artDirector)

	arg0_24.artPlayer = TimelinePlayer.New(arg0_24.artDirector.transform, UnityEngine.Playables.DirectorWrapMode.Loop)

	arg0_24.artPlayer:Register(nil, function(arg0_25, arg1_25, arg2_25)
		arg0_24:OnArtTimelineSignal(arg1_25)
	end)
	arg0_24.artPlayer:SetTime(arg1_24.time or 0)
	arg0_24.artPlayer.comDirector:Evaluate()
	arg0_24.artPlayer:Start()
end

function var0_0.FindArtDirector(arg0_26, arg1_26)
	local var0_26 = arg1_26.sceneName
	local var1_26 = arg1_26.sequencePath or var0_0.DEFAULT_SEQUENCE_PATH
	local var2_26 = SceneManager.GetSceneByName(var0_26):GetRootGameObjects()
	local var3_26

	table.IpairsCArray(var2_26, function(arg0_27, arg1_27)
		if var3_26 then
			return
		end

		local var0_27 = tf(arg1_27)
		local var1_27 = var0_27.name == var1_26 and var0_27 or var0_27:Find(var1_26)

		if var1_27 then
			var3_26 = var1_27:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
		end
	end)

	return var3_26
end

function var0_0.OnArtTimelineSignal(arg0_28, arg1_28)
	assert(arg0_28.artContext, "CarWash art timeline context is nil")

	local var0_28 = arg0_28.artContext.data
	local var1_28 = arg1_28.stringParameter

	arg0_28:Emit(var0_0.ART_TIMELINE_SIGNAL, {
		data = var0_28,
		event = arg1_28,
		signal = var1_28
	})

	if var1_28 == var0_0.SIGNAL.EXIT_TRANSITION then
		arg0_28:StartArtExitTransition()
	else
		assert(false, "Unknown CarWash art timeline signal: " .. tostring(var1_28))
	end
end

function var0_0.StartArtExitTransition(arg0_29, arg1_29)
	if not arg0_29.artContext then
		if arg1_29 and arg1_29.onHold then
			arg1_29.onHold(function()
				if arg1_29.onFinish then
					arg1_29.onFinish()
				end
			end)
		elseif arg1_29 and arg1_29.onFinish then
			arg1_29.onFinish()
		end

		return
	end

	assert(arg0_29.artContext, "CarWash art timeline context is nil")
	assert(not arg0_29.artContext.exitTransitionStarted, "CarWash ExitTransition signal triggered more than once")

	arg0_29.artContext.exitTransitionStarted = true

	local var0_29 = arg0_29.artContext.data

	arg0_29:PlayTransition({
		waitHold = true,
		type = arg0_29.artContext.data.exit,
		onHold = function(arg0_31, arg1_31)
			arg0_29:UnloadArtScene(function()
				arg0_29:Emit(var0_0.TIMELINE_SEQUENCE_END, {
					data = var0_29
				})

				if arg1_29 and arg1_29.onHold then
					arg1_29.onHold(arg0_31, arg1_31)
				else
					arg0_31()
				end
			end)
		end,
		onFinish = function(arg0_33)
			if arg1_29 and arg1_29.onFinish then
				arg1_29.onFinish(arg0_33)
			end

			arg0_29:FinishArtTimeline(arg0_33)
		end
	})
end

function var0_0.UnloadArtScene(arg0_34, arg1_34)
	arg0_34:DisposeArtPlayer()
	assert(arg0_34.artSceneInfo, "CarWash art timeline scene info is nil")

	local var0_34 = arg0_34.artSceneInfo

	arg0_34.artSceneInfo = nil

	SceneOpMgr.Inst:UnloadSceneAsync(var0_34.path, var0_34.name, function()
		existCall(arg1_34)
	end)
end

function var0_0.DisposeArtPlayer(arg0_36)
	if arg0_36.artPlayer then
		if arg0_36.artPlayer.signalReceiver then
			arg0_36.artPlayer.signalReceiver:SetCommonEvent(nil)
		end

		arg0_36.artPlayer:Stop()
		arg0_36.artPlayer:Dispose()

		arg0_36.artPlayer = nil
	end

	arg0_36.artDirector = nil
end

function var0_0.FinishArtTimeline(arg0_37, arg1_37)
	local var0_37 = arg0_37.artContext

	assert(var0_37, "CarWash art timeline context is nil")

	local var1_37 = var0_37.data

	arg0_37.artContext = nil

	if var1_37.onFinish then
		var1_37.onFinish(arg1_37)
	end
end

return var0_0
