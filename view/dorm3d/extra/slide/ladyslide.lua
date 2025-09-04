local var0_0 = class("LadySlide")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1.id = arg1_1
	arg0_1.ladyEnv = arg2_1
	arg0_1._tf = arg2_1.lady
	arg0_1.animator = arg0_1._tf:GetComponent(typeof(Animator))
	arg0_1.commandConfig = arg3_1
	arg0_1.defaultPoint = arg4_1
	arg0_1.ladderTime = pg.dorm3d_minigame_slide[arg1_1].ladder_time
	arg0_1.moveSpeed = pg.dorm3d_minigame_slide[arg1_1].move_speed
	arg0_1.onPlayVFX = arg5_1
end

function var0_0.Reset(arg0_2)
	arg0_2._tf.localPosition = arg0_2.defaultPoint.position
	arg0_2._tf.localRotation = arg0_2.defaultPoint.rotation

	arg0_2.ladyEnv:PlaySingleAction(SlideConst.IDLE_ANIM)
end

function var0_0.StartMove(arg0_3)
	arg0_3:Cancel()

	arg0_3.curIndex = 1
	arg0_3.curState = nil
	arg0_3.inProgress = true

	arg0_3.ladyEnv:SetCollisible(false)
	arg0_3.ladyEnv:EnableCharacterTransparency(true)
	arg0_3.ladyEnv:BlockCanWatch(true)
end

function var0_0.EndMove(arg0_4)
	arg0_4.curIndex = nil
	arg0_4.curState = nil
	arg0_4.inProgress = false

	arg0_4.ladyEnv:SetCollisible(true)
	arg0_4.ladyEnv:EnableCharacterTransparency(false)
	arg0_4.ladyEnv:BlockCanWatch(false)
	arg0_4:Reset()
end

function var0_0.OnUpdate(arg0_5)
	if not arg0_5.inProgress or arg0_5.curIndex > #arg0_5.commandConfig then
		return
	end

	local var0_5 = arg0_5.commandConfig[arg0_5.curIndex]

	if not arg0_5.curState then
		arg0_5:EnterState(var0_5.type, var0_5)
	elseif arg0_5:Check(var0_5) then
		arg0_5.curIndex = arg0_5.curIndex + 1

		if arg0_5.curIndex > #arg0_5.commandConfig then
			arg0_5:ExitState(arg0_5.curState)
			arg0_5:EndMove()

			return
		end

		var0_5 = arg0_5.commandConfig[arg0_5.curIndex]

		if var0_5.type ~= arg0_5.curState then
			arg0_5:ExitState(arg0_5.curState)
		end

		arg0_5:EnterState(var0_5.type, var0_5)
	end

	arg0_5:UpdateState(var0_5)
end

function var0_0.Check(arg0_6, arg1_6)
	local function var0_6(arg0_7, arg1_7)
		local var0_7 = arg0_7.position - arg1_7.position

		var0_7.y = 0

		return var0_7.magnitude <= 0.1
	end

	return switch(arg0_6.curState, {
		[SlideConst.COMMAND_TYPE.WALK] = function()
			return var0_6(arg1_6.target, arg0_6._tf)
		end,
		[SlideConst.COMMAND_TYPE.LADDER] = function()
			return var0_6(arg1_6.target, arg0_6._tf)
		end,
		[SlideConst.COMMAND_TYPE.SLIDE] = function()
			return arg1_6.target.position.y >= arg0_6._tf.position.y
		end,
		[SlideConst.COMMAND_TYPE.TELEPORT] = function()
			return true
		end,
		[SlideConst.COMMAND_TYPE.ANIM] = function()
			if arg0_6.animator:IsInTransition(arg0_6.ladyEnv.ladyAnimBaseLayerIndex) then
				return false
			end

			return arg0_6.animator:GetCurrentAnimatorStateInfo(arg0_6.ladyEnv.ladyAnimBaseLayerIndex).normalizedTime >= 1
		end,
		[SlideConst.COMMAND_TYPE.ANIM_MOVE_ROTATE] = function()
			return arg0_6.walkWithRotateTime >= arg1_6.time
		end
	})
end

function var0_0.UpdateState(arg0_14, arg1_14)
	local var0_14 = arg1_14.target

	switch(arg0_14.curState, {
		[SlideConst.COMMAND_TYPE.WALK] = function()
			arg0_14.ladyEnv:MoveToTarget(var0_14.position, arg0_14.moveSpeed)
		end,
		[SlideConst.COMMAND_TYPE.LADDER] = function()
			arg0_14.ladderMoveTime = arg0_14.ladderMoveTime + Time.deltaTime

			local var0_16 = math.min(arg0_14.ladderMoveTime / arg0_14.ladderTime, 1)

			arg0_14._tf.localPosition = arg0_14.ladderStartPos + arg0_14.ladderForward * (SlideConst.LADDER_DISPLACEMENT.z * var0_16) + Vector3.up * (SlideConst.LADDER_DISPLACEMENT.y * var0_16)

			if var0_16 >= 1 then
				arg0_14.ladderMoveTime = 0
				arg0_14.ladderStartPos = arg0_14._tf.localPosition
			end
		end,
		[SlideConst.COMMAND_TYPE.SLIDE] = function()
			arg0_14.slideMoveTime = arg0_14.slideMoveTime + Time.deltaTime

			local var0_17 = arg0_14.slideMoveTime * SlideConst.SLIDE_GRAVITY
			local var1_17 = arg0_14.slideTotalDelta.normalized * var0_17

			arg0_14.ladyEnv.characterController:Move(var1_17 * Time.deltaTime)
		end,
		[SlideConst.COMMAND_TYPE.TELEPORT] = function()
			arg0_14._tf.localPosition = var0_14.position
			arg0_14._tf.localRotation = var0_14.rotation
		end,
		[SlideConst.COMMAND_TYPE.ANIM] = function()
			return
		end,
		[SlideConst.COMMAND_TYPE.ANIM_MOVE_ROTATE] = function()
			arg0_14.walkWithRotateTime = arg0_14.walkWithRotateTime + Time.deltaTime

			local var0_20 = math.min(arg0_14.walkWithRotateTime / arg1_14.time, 1)

			arg0_14._tf.localRotation = Quaternion.Slerp(arg0_14.cacheRotation, arg1_14.target.rotation, var0_20)
			arg0_14._tf.localPosition = Vector3.Lerp(arg0_14.cachePosition, arg1_14.target.position, var0_20)
		end
	})
end

function var0_0.EnterState(arg0_21, arg1_21, arg2_21)
	if arg2_21:HasEffect() then
		local var0_21, var1_21 = arg2_21:GetEffect()

		arg0_21.vfxLTId = LeanTween.delayedCall(var0_21, System.Action(function()
			arg0_21.onPlayVFX(var1_21)
		end)).uniqueId
	end

	if arg2_21:HasWet() then
		local var2_21, var3_21 = arg2_21:GetWet()

		arg0_21.wetLTId = LeanTween.delayedCall(var2_21, System.Action(function()
			arg0_21:ShowWetness(var3_21)
		end)).uniqueId
	end

	switch(arg1_21, {
		[SlideConst.COMMAND_TYPE.WALK] = function()
			arg0_21.ladyEnv:PlaySingleAction(SlideConst.WALK_ANIM, nil, arg2_21:GetFadeInTime())

			arg0_21.ladyEnv.characterController.enabled = true
		end,
		[SlideConst.COMMAND_TYPE.LADDER] = function()
			arg0_21.ladyEnv:PlaySingleAction(SlideConst.LADDER_ANIM, nil, arg2_21:GetFadeInTime())

			local var0_25 = arg2_21.target.position - arg0_21._tf.position

			var0_25.y = 0

			if var0_25.sqrMagnitude > 0 then
				arg0_21._tf.rotation = Quaternion.LookRotation(var0_25.normalized, Vector3.up)
			end

			arg0_21.ladderMoveTime = 0
			arg0_21.ladderStartPos = arg0_21._tf.localPosition
			arg0_21.ladderForward = arg0_21._tf.forward
		end,
		[SlideConst.COMMAND_TYPE.SLIDE] = function()
			arg0_21.ladyEnv.characterController.enabled = true

			arg0_21.ladyEnv:PlaySingleAction(SlideConst.SLIDE_ANIM, nil, arg2_21:GetFadeInTime())

			local var0_26 = arg2_21.target.position - arg0_21._tf.position

			if var0_26.sqrMagnitude > 0 then
				arg0_21._tf.rotation = Quaternion.LookRotation(var0_26.normalized, Vector3.up)
			end

			arg0_21.slideMoveTime = 0
			arg0_21.slideTotalDelta = arg2_21.target.position - arg0_21._tf.localPosition
		end,
		[SlideConst.COMMAND_TYPE.TELEPORT] = function()
			return
		end,
		[SlideConst.COMMAND_TYPE.ANIM] = function()
			arg0_21.ladyEnv:PlaySingleAction(arg2_21.anim, nil, arg2_21:GetFadeInTime())
		end,
		[SlideConst.COMMAND_TYPE.ANIM_MOVE_ROTATE] = function()
			arg0_21.ladyEnv:PlaySingleAction(arg2_21.anim, nil, arg2_21:GetFadeInTime())

			arg0_21.cacheRotation = arg0_21._tf.localRotation
			arg0_21.cachePosition = arg0_21._tf.localPosition
			arg0_21.walkWithRotateTime = 0
		end
	})

	arg0_21.curState = arg1_21
end

function var0_0.ExitState(arg0_30, arg1_30)
	switch(arg0_30.curState, {
		[SlideConst.COMMAND_TYPE.WALK] = function()
			arg0_30.ladyEnv.characterController.enabled = false
		end,
		[SlideConst.COMMAND_TYPE.LADDER] = function()
			arg0_30.ladderMoveTime = nil
			arg0_30.ladderStartPos = nil
			arg0_30.ladderForward = nil
		end,
		[SlideConst.COMMAND_TYPE.SLIDE] = function()
			arg0_30.ladyEnv.characterController.enabled = false

			local var0_33 = arg0_30._tf.rotation.eulerAngles

			arg0_30._tf.rotation = Quaternion.Euler(0, var0_33.y, var0_33.z)
			arg0_30.slideMoveTime = nil
			arg0_30.slideTotalDelta = nil
		end,
		[SlideConst.COMMAND_TYPE.TELEPORT] = function()
			return
		end,
		[SlideConst.COMMAND_TYPE.ANIM] = function()
			return
		end,
		[SlideConst.COMMAND_TYPE.ANIM_MOVE_ROTATE] = function()
			return
		end
	})

	arg0_30.curState = nil
end

function var0_0.ShowWetness(arg0_37, arg1_37)
	if arg0_37.wetTimer then
		arg0_37.wetTimer:Stop()
	end

	local var0_37 = 0

	arg0_37.wetTimer = Timer.New(function()
		if var0_37 >= SlideConst.WET_FADE_IN_TIME then
			arg0_37.wetTimer:Stop()

			arg0_37.wetTimer = nil

			return
		end

		var0_37 = var0_37 + 0.0166666666666667

		local var0_38 = var0_37 / SlideConst.WET_FADE_IN_TIME

		if not arg1_37 then
			var0_38 = 1 - var0_38
		end

		local var1_38 = math.min(var0_38, 1)
		local var2_38 = math.max(var1_38, 0)

		GraphicsInterface.Instance:SetWetness(go(arg0_37._tf), var2_38)
	end, 0.0166666666666667, -1)

	arg0_37.wetTimer:Start()
end

function var0_0.Cancel(arg0_39)
	if arg0_39.vfxLTId then
		LeanTween.cancel(arg0_39.vfxLTId)

		arg0_39.vfxLTId = nil
	end

	if arg0_39.wetLTId then
		LeanTween.cancel(arg0_39.wetLTId)

		arg0_39.wetLTId = nil
	end

	if arg0_39.wetTimer then
		arg0_39.wetTimer:Stop()

		arg0_39.wetTimer = nil
	end

	GraphicsInterface.Instance:SetWetness(go(arg0_39._tf), 0)
end

function var0_0.Dispose(arg0_40)
	arg0_40:Cancel()
	arg0_40.ladyEnv:SetCollisible(true)
	arg0_40.ladyEnv:EnableCharacterTransparency(false)
	arg0_40.ladyEnv:BlockCanWatch(false)
end

return var0_0
