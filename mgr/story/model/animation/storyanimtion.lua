local var0_0 = class("StoryAnimtion")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tweens = {}
	arg0_1.timers = {}
	arg0_1.timeScale = 1
end

function var0_0.SetTimeScale(arg0_2, arg1_2)
	arg0_2.timeScale = arg1_2
end

function var0_0.moveLocal(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3, arg5_3, arg6_3, arg7_3)
	local function var0_3()
		local var0_4 = LeanTween.moveLocal(arg1_3.gameObject, arg3_3, arg4_3 * arg0_3.timeScale)

		var0_4:setFrom(arg2_3)

		if arg7_3 then
			var0_4:setOnComplete(System.Action(arg7_3))
		end

		if arg6_3 then
			var0_4:setEase(arg6_3)
		end

		table.insert(arg0_3.tweens, arg1_3)
	end

	arg0_3:DelayCall(arg5_3, var0_3)
end

function var0_0.moveLocalPath(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5, arg6_5)
	if #arg2_5 <= 3 then
		local var0_5 = arg2_5[1]
		local var1_5 = arg2_5[#arg2_5]

		arg0_5:moveLocal(arg1_5, var0_5, var1_5, arg3_5, arg4_5, arg5_5, arg6_5)

		return
	end

	local var2_5 = System.Array.CreateInstance(typeof(UnityEngine.Vector3), #arg2_5)

	for iter0_5, iter1_5 in ipairs(arg2_5) do
		var2_5[iter0_5 - 1] = iter1_5
	end

	local function var3_5()
		local var0_6 = LeanTween.moveLocal(arg1_5.gameObject, var2_5, arg3_5 * arg0_5.timeScale)

		if arg6_5 then
			var0_6:setOnComplete(System.Action(arg6_5))
		end

		if arg5_5 then
			var0_6:setEase(arg5_5)
		end

		table.insert(arg0_5.tweens, arg1_5)
	end

	arg0_5:DelayCall(arg4_5, var3_5)
end

function var0_0.TweenMove(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7, arg6_7)
	local function var0_7()
		local var0_8 = LeanTween.move(rtf(arg1_7), arg2_7, arg3_7 * arg0_7.timeScale)

		if arg4_7 > 1 then
			var0_8:setLoopPingPong(arg4_7)
		end

		if arg6_7 then
			var0_8:setOnComplete(System.Action(arg6_7))
		end

		table.insert(arg0_7.tweens, arg1_7)
	end

	arg0_7:DelayCall(arg5_7, var0_7)
end

function var0_0.TweenScale(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9)
	local function var0_9()
		local var0_10 = LeanTween.scale(rtf(arg1_9), arg2_9, arg3_9 * arg0_9.timeScale)

		if arg5_9 then
			var0_10:setOnComplete(System.Action(arg5_9))
		end

		table.insert(arg0_9.tweens, arg1_9)
	end

	arg0_9:DelayCall(arg4_9, var0_9)
end

function var0_0.TweenRotate(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11, arg6_11)
	local function var0_11()
		local var0_12 = LeanTween.rotate(rtf(arg1_11), arg2_11, arg3_11 * arg0_11.timeScale):setLoopPingPong(arg4_11)

		if arg6_11 then
			var0_12:setOnComplete(System.Action(arg6_11))
		end

		table.insert(arg0_11.tweens, arg1_11)
	end

	arg0_11:DelayCall(arg5_11, var0_11)
end

function var0_0.TweenValueForcanvasGroup(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13, arg5_13, arg6_13)
	local function var0_13()
		local var0_14 = LeanTween.value(go(arg1_13), arg2_13, arg3_13, arg4_13 * arg0_13.timeScale):setOnUpdate(System.Action_float(function(arg0_15)
			arg1_13.alpha = arg0_15
		end))

		if arg6_13 then
			var0_14:setOnComplete(System.Action(arg6_13))
		end

		table.insert(arg0_13.tweens, arg1_13.gameObject.transform)
	end

	arg0_13:DelayCall(arg5_13, var0_13)
end

function var0_0.TweenValue(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16, arg6_16, arg7_16)
	local function var0_16()
		local var0_17 = LeanTween.value(go(arg1_16), arg2_16, arg3_16, arg4_16 * arg0_16.timeScale):setOnUpdate(System.Action_float(arg6_16))

		if arg7_16 then
			var0_17:setOnComplete(System.Action(function()
				if arg7_16 then
					arg7_16()
				end
			end))
		end

		table.insert(arg0_16.tweens, arg1_16)
	end

	arg0_16:DelayCall(arg5_16, var0_16)
end

function var0_0.TweenValueLoop(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19, arg7_19)
	local function var0_19()
		local var0_20 = LeanTween.value(go(arg1_19), arg2_19, arg3_19, arg4_19 * arg0_19.timeScale):setOnUpdate(System.Action_float(arg6_19)):setLoopClamp()

		if arg7_19 then
			var0_20:setOnComplete(System.Action(function()
				if arg7_19 then
					arg7_19()
				end
			end))
		end

		table.insert(arg0_19.tweens, arg1_19)
	end

	arg0_19:DelayCall(arg5_19, var0_19)
end

function var0_0.TweenTextAlpha(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22)
	local function var0_22()
		local var0_23 = LeanTween.textAlpha(arg1_22, arg2_22, (arg3_22 or 1) * arg0_22.timeScale)

		if arg5_22 then
			var0_23:setOnComplete(System.Action(arg5_22))
		end

		table.insert(arg0_22.tweens, arg1_22)
	end

	arg0_22:DelayCall(arg4_22, var0_22)
end

function var0_0.TweenAlpha(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24, arg5_24, arg6_24)
	local function var0_24()
		local var0_25 = LeanTween.alpha(arg1_24, arg3_24, arg4_24 * arg0_24.timeScale):setFrom(arg2_24)

		if arg6_24 then
			var0_25:setOnComplete(System.Action(arg6_24))
		end

		table.insert(arg0_24.tweens, arg1_24)
	end

	arg0_24:DelayCall(arg5_24, var0_24)
end

function var0_0.TweenMovex(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26, arg5_26, arg6_26, arg7_26)
	local function var0_26()
		local var0_27 = LeanTween.moveX(arg1_26, arg2_26, arg4_26 * arg0_26.timeScale):setFrom(arg3_26)

		if arg6_26 then
			var0_27:setLoopPingPong(arg6_26)
		end

		if arg7_26 then
			var0_27:setOnComplete(System.Action(arg7_26))
		end

		table.insert(arg0_26.tweens, arg1_26)
	end

	arg0_26:DelayCall(arg5_26, var0_26)
end

function var0_0.TweenMovey(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28, arg5_28, arg6_28, arg7_28)
	local function var0_28()
		local var0_29 = LeanTween.moveY(arg1_28, arg2_28, arg4_28 * arg0_28.timeScale):setFrom(arg3_28)

		if arg6_28 then
			var0_29:setLoopPingPong(arg6_28)
		end

		if arg7_28 then
			var0_29:setOnComplete(System.Action(arg7_28))
		end

		table.insert(arg0_28.tweens, arg1_28)
	end

	arg0_28:DelayCall(arg5_28, var0_28)
end

function var0_0.IsTweening(arg0_30, arg1_30)
	return LeanTween.isTweening(arg1_30)
end

function var0_0.CancelTween(arg0_31, arg1_31)
	if arg0_31:IsTweening(arg1_31) then
		LeanTween.cancel(arg1_31)
	end
end

function var0_0.DelayCall(arg0_32, arg1_32, arg2_32)
	if not arg1_32 or arg1_32 <= 0 then
		arg2_32()

		return
	end

	arg0_32.timers[arg2_32] = StoryTimer.New(function()
		arg0_32.timers[arg2_32]:Stop()

		arg0_32.timers[arg2_32] = nil

		arg2_32()
	end, arg1_32 * arg0_32.timeScale, 1)

	arg0_32.timers[arg2_32]:Start()
end

function var0_0.UnscaleDelayCall(arg0_34, arg1_34, arg2_34)
	if arg1_34 <= 0 then
		arg2_34()

		return
	end

	arg0_34.timers[arg2_34] = StoryTimer.New(function()
		arg0_34.timers[arg2_34]:Stop()

		arg0_34.timers[arg2_34] = nil

		arg2_34()
	end, arg1_34, 1)

	arg0_34.timers[arg2_34]:Start()
end

function var0_0.CreateDelayTimer(arg0_36, arg1_36, arg2_36)
	if arg1_36 == 0 then
		arg2_36()

		return nil
	end

	local var0_36 = StoryTimer.New(arg2_36, arg1_36 * arg0_36.timeScale, 1)

	var0_36:Start()

	return var0_36
end

function var0_0.PauseAllTween(arg0_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.tweens) do
		if not IsNil(iter1_37) and arg0_37:IsTweening(iter1_37.gameObject) then
			LeanTween.pause(iter1_37.gameObject)
		end
	end
end

function var0_0.ResumeAllTween(arg0_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.tweens) do
		if not IsNil(iter1_38) then
			LeanTween.resume(iter1_38.gameObject)
		end
	end
end

function var0_0.PauseAllTimer(arg0_39)
	for iter0_39, iter1_39 in pairs(arg0_39.timers) do
		iter1_39:Pause()
	end
end

function var0_0.ResumeAllTimer(arg0_40)
	for iter0_40, iter1_40 in pairs(arg0_40.timers) do
		iter1_40:Resume()
	end
end

function var0_0.ResumeAllAnimation(arg0_41)
	arg0_41:ResumeAllTween()
	arg0_41:ResumeAllTimer()
end

function var0_0.PauseAllAnimation(arg0_42)
	arg0_42:PauseAllTween()
	arg0_42:PauseAllTimer()
end

function var0_0.ClearAllTween(arg0_43)
	for iter0_43, iter1_43 in ipairs(arg0_43.tweens) do
		if not IsNil(iter1_43) and arg0_43:IsTweening(iter1_43.gameObject) then
			LeanTween.cancel(iter1_43.gameObject)
		end
	end

	arg0_43.tweens = {}
end

function var0_0.ClearAllTimers(arg0_44)
	for iter0_44, iter1_44 in pairs(arg0_44.timers) do
		iter1_44:Stop()
	end

	arg0_44.timers = {}
end

function var0_0.ClearAnimation(arg0_45)
	arg0_45:ClearAllTween()
	arg0_45:ClearAllTimers()
end

return var0_0
