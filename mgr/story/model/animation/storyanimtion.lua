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

function var0_0.TweenValueWithEase(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19, arg5_19, arg6_19, arg7_19, arg8_19)
	local function var0_19()
		local var0_20 = LeanTween.value(go(arg1_19), arg2_19, arg3_19, arg4_19 * arg0_19.timeScale):setOnUpdate(System.Action_float(arg7_19)):setEase(arg6_19)

		if arg8_19 then
			var0_20:setOnComplete(System.Action(function()
				if arg8_19 then
					arg8_19()
				end
			end))
		end

		table.insert(arg0_19.tweens, arg1_19)
	end

	arg0_19:DelayCall(arg5_19, var0_19)
end

function var0_0.TweenValueLoop(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22, arg5_22, arg6_22, arg7_22)
	local function var0_22()
		local var0_23 = LeanTween.value(go(arg1_22), arg2_22, arg3_22, arg4_22 * arg0_22.timeScale):setOnUpdate(System.Action_float(arg6_22)):setLoopClamp()

		if arg7_22 then
			var0_23:setOnComplete(System.Action(function()
				if arg7_22 then
					arg7_22()
				end
			end))
		end

		table.insert(arg0_22.tweens, arg1_22)
	end

	arg0_22:DelayCall(arg5_22, var0_22)
end

function var0_0.TweenTextAlpha(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
	local function var0_25()
		local var0_26 = LeanTween.textAlpha(arg1_25, arg2_25, (arg3_25 or 1) * arg0_25.timeScale)

		if arg5_25 then
			var0_26:setOnComplete(System.Action(arg5_25))
		end

		table.insert(arg0_25.tweens, arg1_25)
	end

	arg0_25:DelayCall(arg4_25, var0_25)
end

function var0_0.TweenAlpha(arg0_27, arg1_27, arg2_27, arg3_27, arg4_27, arg5_27, arg6_27)
	local function var0_27()
		local var0_28 = LeanTween.alpha(arg1_27, arg3_27, arg4_27 * arg0_27.timeScale):setFrom(arg2_27)

		if arg6_27 then
			var0_28:setOnComplete(System.Action(arg6_27))
		end

		table.insert(arg0_27.tweens, arg1_27)
	end

	arg0_27:DelayCall(arg5_27, var0_27)
end

function var0_0.TweenMovex(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29, arg5_29, arg6_29, arg7_29)
	local function var0_29()
		local var0_30 = LeanTween.moveX(arg1_29, arg2_29, arg4_29 * arg0_29.timeScale):setFrom(arg3_29)

		if arg6_29 then
			var0_30:setLoopPingPong(arg6_29)
		end

		if arg7_29 then
			var0_30:setOnComplete(System.Action(arg7_29))
		end

		table.insert(arg0_29.tweens, arg1_29)
	end

	arg0_29:DelayCall(arg5_29, var0_29)
end

function var0_0.TweenMovey(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31, arg5_31, arg6_31, arg7_31)
	local function var0_31()
		local var0_32 = LeanTween.moveY(arg1_31, arg2_31, arg4_31 * arg0_31.timeScale):setFrom(arg3_31)

		if arg6_31 then
			var0_32:setLoopPingPong(arg6_31)
		end

		if arg7_31 then
			var0_32:setOnComplete(System.Action(arg7_31))
		end

		table.insert(arg0_31.tweens, arg1_31)
	end

	arg0_31:DelayCall(arg5_31, var0_31)
end

function var0_0.IsTweening(arg0_33, arg1_33)
	return LeanTween.isTweening(arg1_33)
end

function var0_0.CancelTween(arg0_34, arg1_34)
	if arg0_34:IsTweening(arg1_34) then
		LeanTween.cancel(arg1_34)
	end
end

function var0_0.DelayCall(arg0_35, arg1_35, arg2_35)
	if not arg1_35 or arg1_35 <= 0 then
		arg2_35()

		return
	end

	arg0_35.timers[arg2_35] = StoryTimer.New(function()
		arg0_35.timers[arg2_35]:Stop()

		arg0_35.timers[arg2_35] = nil

		arg2_35()
	end, arg1_35 * arg0_35.timeScale, 1)

	arg0_35.timers[arg2_35]:Start()
end

function var0_0.UnscaleDelayCall(arg0_37, arg1_37, arg2_37)
	if arg1_37 <= 0 then
		arg2_37()

		return
	end

	arg0_37.timers[arg2_37] = StoryTimer.New(function()
		arg0_37.timers[arg2_37]:Stop()

		arg0_37.timers[arg2_37] = nil

		arg2_37()
	end, arg1_37, 1)

	arg0_37.timers[arg2_37]:Start()
end

function var0_0.CreateDelayTimer(arg0_39, arg1_39, arg2_39)
	if arg1_39 == 0 then
		arg2_39()

		return nil
	end

	local var0_39 = StoryTimer.New(arg2_39, arg1_39 * arg0_39.timeScale, 1)

	var0_39:Start()

	return var0_39
end

function var0_0.PauseAllTween(arg0_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.tweens) do
		if not IsNil(iter1_40) and arg0_40:IsTweening(iter1_40.gameObject) then
			LeanTween.pause(iter1_40.gameObject)
		end
	end
end

function var0_0.ResumeAllTween(arg0_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.tweens) do
		if not IsNil(iter1_41) then
			LeanTween.resume(iter1_41.gameObject)
		end
	end
end

function var0_0.PauseAllTimer(arg0_42)
	for iter0_42, iter1_42 in pairs(arg0_42.timers) do
		iter1_42:Pause()
	end
end

function var0_0.ResumeAllTimer(arg0_43)
	for iter0_43, iter1_43 in pairs(arg0_43.timers) do
		iter1_43:Resume()
	end
end

function var0_0.ResumeAllAnimation(arg0_44)
	arg0_44:ResumeAllTween()
	arg0_44:ResumeAllTimer()
end

function var0_0.PauseAllAnimation(arg0_45)
	arg0_45:PauseAllTween()
	arg0_45:PauseAllTimer()
end

function var0_0.ClearAllTween(arg0_46)
	for iter0_46, iter1_46 in ipairs(arg0_46.tweens) do
		if not IsNil(iter1_46) and arg0_46:IsTweening(iter1_46.gameObject) then
			LeanTween.cancel(iter1_46.gameObject)
		end
	end

	arg0_46.tweens = {}
end

function var0_0.ClearAllTimers(arg0_47)
	for iter0_47, iter1_47 in pairs(arg0_47.timers) do
		iter1_47:Stop()
	end

	arg0_47.timers = {}
end

function var0_0.ClearAnimation(arg0_48)
	arg0_48:ClearAllTween()
	arg0_48:ClearAllTimers()
end

return var0_0
