local var0_0 = class("IslandVistorFishingPlayer", import(".IslandFishingPlayer"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:InitArgs(arg3_1, arg4_1, arg5_1)
end

function var0_0.IsSameFishPoint(arg0_2, arg1_2)
	return arg0_2.fishPointId == arg1_2
end

function var0_0.Play(arg0_3)
	local var0_3 = arg0_3.fishPointId

	seriesAsync({
		function(arg0_4)
			arg0_3:TurnToFishPoistion(var0_3, arg0_4)
		end,
		function(arg0_5)
			arg0_3:LoadFishRodModel(arg0_5)
		end,
		function(arg0_6)
			arg0_3:PreloadEffects(arg0_6)
		end,
		function(arg0_7)
			arg0_3:PlayEffect(IslandFishingEffectMgr.EFFECT_ENTER, IslandFishingEffectMgr.EFFECT_ENTER_TIME)
			arg0_3:PlayCastAnimation(arg0_7)
		end,
		function(arg0_8)
			arg0_3:PlayEffect(IslandFishingEffectMgr.EFFECT_WAITING)
			onDelayTick(arg0_8, 2)
		end,
		function(arg0_9)
			arg0_3:PlayEffect(IslandFishingEffectMgr.EFFECT_HOOKED)
			arg0_3:PlayHookedAnimation()
			onDelayTick(arg0_9, 1)
		end,
		function(arg0_10)
			arg0_3:PlayEffect(IslandFishingEffectMgr.EFFECT_SHAKE)
			arg0_10()
		end
	})
end

function var0_0.OnSuccess(arg0_11, arg1_11)
	seriesAsync({
		function(arg0_12)
			onDelayTick(arg0_12, 1)
		end,
		function(arg0_13)
			arg0_11:LoadFishModel(arg0_13)
		end,
		function(arg0_14)
			arg0_11:PlayEffect(IslandFishingEffectMgr.EFFECT_LEAVE, IslandFishingEffectMgr.EFFECT_LEAVE_TIME)
			arg0_11:PlayHookEndAnimation(arg0_14)
		end,
		function(arg0_15)
			arg0_11:WaitForExit(arg0_15)
		end
	}, arg1_11)
end

function var0_0.WaitForExit(arg0_16, arg1_16)
	arg0_16:RemoveWaitForExit()

	local var0_16 = pg.island_set.island_fishing_success_exit_time.key_value_int

	arg0_16.exitTimer = Timer.New(arg1_16, math.max(0.01, var0_16), 1)

	arg0_16.exitTimer:Start()
end

function var0_0.RemoveWaitForExit(arg0_17)
	if arg0_17.exitTimer then
		arg0_17.exitTimer:Stop()

		arg0_17.exitTimer = nil
	end
end

function var0_0.OnFailed(arg0_18, arg1_18)
	arg0_18:PlayEffect(IslandFishingEffectMgr.EFFECT_NORMAL)
	arg0_18:PlayFailAnimation(arg1_18)
end

function var0_0.OnCancel(arg0_19, arg1_19)
	arg0_19:PlayEffect(IslandFishingEffectMgr.EFFECT_NORMAL)
	arg0_19:PlayCancelAnimation(arg1_19)
end

function var0_0.OnDestroy(arg0_20)
	arg0_20:PlayEffect(IslandFishingEffectMgr.EFFECT_NORMAL)
	arg0_20:RemoveWaitForExit()
	arg0_20:UnLoadFishModel()
	arg0_20:UnLoadFishRodModel()
	arg0_20:PlayMovementAnimation()
	var0_0.super.OnDestroy(arg0_20)
end

return var0_0
