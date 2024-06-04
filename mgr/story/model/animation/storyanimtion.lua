local var0 = class("StoryAnimtion")

function var0.Ctor(arg0, arg1)
	arg0.tweens = {}
	arg0.timers = {}
	arg0.timeScale = 1
end

function var0.SetTimeScale(arg0, arg1)
	arg0.timeScale = arg1
end

function var0.moveLocal(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local function var0()
		local var0 = LeanTween.moveLocal(arg1.gameObject, arg3, arg4 * arg0.timeScale)

		var0:setFrom(arg2)

		if arg7 then
			var0:setOnComplete(System.Action(arg7))
		end

		if arg6 then
			var0:setEase(arg6)
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.moveLocalPath(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if #arg2 <= 3 then
		local var0 = arg2[1]
		local var1 = arg2[#arg2]

		arg0:moveLocal(arg1, var0, var1, arg3, arg4, arg5, arg6)

		return
	end

	local var2 = System.Array.CreateInstance(typeof(UnityEngine.Vector3), #arg2)

	for iter0, iter1 in ipairs(arg2) do
		var2[iter0 - 1] = iter1
	end

	local function var3()
		local var0 = LeanTween.moveLocal(arg1.gameObject, var2, arg3 * arg0.timeScale)

		if arg6 then
			var0:setOnComplete(System.Action(arg6))
		end

		if arg5 then
			var0:setEase(arg5)
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg4, var3)
end

function var0.TweenMove(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local function var0()
		local var0 = LeanTween.move(rtf(arg1), arg2, arg3 * arg0.timeScale)

		if arg4 > 1 then
			var0:setLoopPingPong(arg4)
		end

		if arg6 then
			var0:setOnComplete(System.Action(arg6))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenScale(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0()
		local var0 = LeanTween.scale(rtf(arg1), arg2, arg3 * arg0.timeScale)

		if arg5 then
			var0:setOnComplete(System.Action(arg5))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg4, var0)
end

function var0.TweenRotate(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local function var0()
		local var0 = LeanTween.rotate(rtf(arg1), arg2, arg3 * arg0.timeScale):setLoopPingPong(arg4)

		if arg6 then
			var0:setOnComplete(System.Action(arg6))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenValueForcanvasGroup(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local function var0()
		local var0 = LeanTween.value(go(arg1), arg2, arg3, arg4 * arg0.timeScale):setOnUpdate(System.Action_float(function(arg0)
			arg1.alpha = arg0
		end))

		if arg6 then
			var0:setOnComplete(System.Action(arg6))
		end

		table.insert(arg0.tweens, arg1.gameObject.transform)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenValue(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local function var0()
		local var0 = LeanTween.value(go(arg1), arg2, arg3, arg4 * arg0.timeScale):setOnUpdate(System.Action_float(arg6))

		if arg7 then
			var0:setOnComplete(System.Action(function()
				if arg7 then
					arg7()
				end
			end))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenValueLoop(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local function var0()
		local var0 = LeanTween.value(go(arg1), arg2, arg3, arg4 * arg0.timeScale):setOnUpdate(System.Action_float(arg6)):setLoopClamp()

		if arg7 then
			var0:setOnComplete(System.Action(function()
				if arg7 then
					arg7()
				end
			end))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenTextAlpha(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0()
		local var0 = LeanTween.textAlpha(arg1, arg2, (arg3 or 1) * arg0.timeScale)

		if arg5 then
			var0:setOnComplete(System.Action(arg5))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg4, var0)
end

function var0.TweenAlpha(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local function var0()
		local var0 = LeanTween.alpha(arg1, arg3, arg4 * arg0.timeScale):setFrom(arg2)

		if arg6 then
			var0:setOnComplete(System.Action(arg6))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenMovex(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local function var0()
		local var0 = LeanTween.moveX(arg1, arg2, arg4 * arg0.timeScale):setFrom(arg3)

		if arg6 then
			var0:setLoopPingPong(arg6)
		end

		if arg7 then
			var0:setOnComplete(System.Action(arg7))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.TweenMovey(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local function var0()
		local var0 = LeanTween.moveY(arg1, arg2, arg4 * arg0.timeScale):setFrom(arg3)

		if arg6 then
			var0:setLoopPingPong(arg6)
		end

		if arg7 then
			var0:setOnComplete(System.Action(arg7))
		end

		table.insert(arg0.tweens, arg1)
	end

	arg0:DelayCall(arg5, var0)
end

function var0.IsTweening(arg0, arg1)
	return LeanTween.isTweening(arg1)
end

function var0.CancelTween(arg0, arg1)
	if arg0:IsTweening(arg1) then
		LeanTween.cancel(arg1)
	end
end

function var0.DelayCall(arg0, arg1, arg2)
	if not arg1 or arg1 <= 0 then
		arg2()

		return
	end

	arg0.timers[arg2] = StoryTimer.New(function()
		arg0.timers[arg2]:Stop()

		arg0.timers[arg2] = nil

		arg2()
	end, arg1 * arg0.timeScale, 1)

	arg0.timers[arg2]:Start()
end

function var0.UnscaleDelayCall(arg0, arg1, arg2)
	if arg1 <= 0 then
		arg2()

		return
	end

	arg0.timers[arg2] = StoryTimer.New(function()
		arg0.timers[arg2]:Stop()

		arg0.timers[arg2] = nil

		arg2()
	end, arg1, 1)

	arg0.timers[arg2]:Start()
end

function var0.CreateDelayTimer(arg0, arg1, arg2)
	if arg1 == 0 then
		arg2()

		return nil
	end

	local var0 = StoryTimer.New(arg2, arg1 * arg0.timeScale, 1)

	var0:Start()

	return var0
end

function var0.PauseAllTween(arg0)
	for iter0, iter1 in ipairs(arg0.tweens) do
		if not IsNil(iter1) and arg0:IsTweening(iter1.gameObject) then
			LeanTween.pause(iter1.gameObject)
		end
	end
end

function var0.ResumeAllTween(arg0)
	for iter0, iter1 in ipairs(arg0.tweens) do
		if not IsNil(iter1) then
			LeanTween.resume(iter1.gameObject)
		end
	end
end

function var0.PauseAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Pause()
	end
end

function var0.ResumeAllTimer(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Resume()
	end
end

function var0.ResumeAllAnimation(arg0)
	arg0:ResumeAllTween()
	arg0:ResumeAllTimer()
end

function var0.PauseAllAnimation(arg0)
	arg0:PauseAllTween()
	arg0:PauseAllTimer()
end

function var0.ClearAllTween(arg0)
	for iter0, iter1 in ipairs(arg0.tweens) do
		if not IsNil(iter1) and arg0:IsTweening(iter1.gameObject) then
			LeanTween.cancel(iter1.gameObject)
		end
	end

	arg0.tweens = {}
end

function var0.ClearAllTimers(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = {}
end

function var0.ClearAnimation(arg0)
	arg0:ClearAllTween()
	arg0:ClearAllTimers()
end

return var0
