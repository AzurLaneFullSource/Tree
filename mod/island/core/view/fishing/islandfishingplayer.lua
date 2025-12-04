local var0_0 = class("IslandFishingPlayer", import("Mod.Island.Core.View.IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.player = arg2_1
	arg0_1.effectMgr = IslandFishingEffectMgr.New(arg0_1:GetView())
	arg0_1.animator = IslandFishingAnimator.New(arg2_1)
end

function var0_0.InitArgs(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.fishPointId = arg1_2
	arg0_2.fishRodId = arg2_2
	arg0_2.fishId = arg3_2
end

function var0_0.PreloadEffects(arg0_3, arg1_3)
	assert(arg0_3.fishPointId, "call InitArgs first")
	arg0_3.effectMgr:Preload(arg0_3.fishPointId, arg1_3)
end

function var0_0.PlayEffect(arg0_4, arg1_4, arg2_4)
	if not arg2_4 or arg2_4 <= 0 then
		arg0_4.effectMgr:Play(arg1_4)
	else
		arg0_4.effectMgr:DelayPlay(arg2_4, arg1_4)
	end
end

function var0_0.PlayCastAnimation(arg0_5, arg1_5)
	arg0_5.animator:Trigger(IslandFishingAnimator.STATE_THROW, 0.25, arg1_5)
end

function var0_0.PlayHookedAnimation(arg0_6)
	arg0_6.animator:Trigger(IslandFishingAnimator.STATE_HOOKED, 0.25)
end

function var0_0.PlayMovementAnimation(arg0_7)
	arg0_7.animator:Trigger(IslandFishingAnimator.STATE_MOVEMENT, 0)
end

function var0_0.PlayHookEndAnimation(arg0_8, arg1_8)
	arg0_8.animator:Trigger(IslandFishingAnimator.STATE_HOOKED_5, 0.25, arg1_8)
end

function var0_0.PlayHookMiddleAnimation(arg0_9)
	arg0_9.animator:Trigger(IslandFishingAnimator.STATE_HOOKED_3, 0)
end

function var0_0.PlayCancelAnimation(arg0_10, arg1_10)
	arg0_10.animator:Trigger(IslandFishingAnimator.STATE_CANCEL, 0.25, arg1_10)
end

function var0_0.PlayFailAnimation(arg0_11, arg1_11)
	arg0_11.animator:Trigger(IslandFishingAnimator.STATE_FAIL, 0.25, arg1_11)
end

function var0_0.TurnToFishPoistion(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12:GetView():GetUnitModuleWithType(IslandConst.UNIT_LIST_FISH_POINT, arg1_12)

	assert(var0_12, "unit should be exist>>>." .. arg1_12)

	local var1_12 = arg0_12.player._tf
	local var2_12 = var0_12._go.transform.position - var1_12.position

	var2_12.y = 0
	var1_12.rotation = Quaternion.LookRotation(var2_12)

	arg2_12()
end

function var0_0.LoadFishRodModel(arg0_13, arg1_13)
	assert(arg0_13.fishRodId, "call InitArgs first")

	if not arg0_13.fishRodId then
		arg1_13()

		return
	end

	local var0_13 = pg.island_animation_attachments[arg0_13.fishRodId]

	arg0_13:GetPoolMgr():GetFishRod(var0_13.model, var0_13.animator, function(arg0_14)
		arg0_13.fishRodAnimator = arg0_14:GetComponent(typeof(Animator))

		local var0_14 = arg0_14:GetComponent(typeof(FishingLineVerlet))

		if var0_14 then
			arg0_13.effectMgr:SetFishHook(var0_14.hook)
		end

		setParent(arg0_14, arg0_13.player._tf)
		arg0_13.animator:SetFishRod(arg0_13.fishRodAnimator)
		arg1_13()
	end)
end

function var0_0.UnLoadFishRodModel(arg0_15)
	if arg0_15.fishRodId and arg0_15.fishRodAnimator and arg0_15.fishRodAnimator.gameObject then
		local var0_15 = pg.island_animation_attachments[arg0_15.fishRodId]

		arg0_15:GetPoolMgr():ReturnFishRod(var0_15.model, var0_15.animator, arg0_15.fishRodAnimator.gameObject)

		arg0_15.fishRodId = nil

		arg0_15.animator:ClearFishRod()

		arg0_15.fishRodAnimator = nil
	end
end

function var0_0.LoadFishModel(arg0_16, arg1_16)
	assert(arg0_16.fishId, "call InitArgs first")

	if not arg0_16.fishId or not arg0_16.fishRodAnimator then
		arg1_16()

		return
	end

	local var0_16 = pg.island_fish[arg0_16.fishId]
	local var1_16 = pg.island_unit_character[var0_16.unit_id]

	arg0_16:GetPoolMgr():GetFish(var1_16.model, var1_16.animator, function(arg0_17)
		arg0_16.fishAnimator = arg0_17:GetComponent(typeof(Animator))

		setParent(arg0_17, arg0_16.fishRodAnimator.gameObject.transform:Find("all/fish_bone/fish1_mount"))
		arg1_16()
	end)
end

function var0_0.UnLoadFishModel(arg0_18)
	if arg0_18.fishAnimator then
		local var0_18 = pg.island_fish[arg0_18.fishId]
		local var1_18 = pg.island_unit_character[var0_18.unit_id]

		arg0_18:GetPoolMgr():ReturnFish(var1_18.model, var1_18.animator, arg0_18.fishAnimator.gameObject)

		arg0_18.fishAnimator = nil
	end
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19.effectMgr then
		arg0_19.effectMgr:Dispose()

		arg0_19.effectMgr = nil
	end

	if arg0_19.animator then
		arg0_19.animator:Dispose()

		arg0_19.animator = nil
	end
end

return var0_0
