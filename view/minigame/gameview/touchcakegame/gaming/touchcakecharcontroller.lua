local var0_0 = class("TouchCakeCharController")
local var1_0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 3
local var5_0 = 4
local var6_0 = {
	315,
	-315
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = TouchCakeGameVo
	arg0_1._content = arg1_1
	arg0_1._event = arg2_1
	arg0_1._char = findTF(arg0_1._content, "char")
	arg0_1._charAnimUI = GetComponent(arg0_1._char, typeof(SpineAnimUI))
	arg0_1._guardEffectTf = findTF(arg0_1._char, "dangaota_wudihudun")
	arg0_1._effectDizziTf = findTF(arg0_1._char, "dangaota_xuanyun")
end

function var0_0.start(arg0_2)
	arg0_2.actionAble = true
	arg0_2.freezeTime = -1
	arg0_2.direct = -1
	arg0_2.guardTime = -1

	arg0_2:clearActionDelay()

	local var0_2 = arg0_2:getCharAnimName(var3_0, arg0_2.direct)

	arg0_2:setAnimation(arg0_2._charAnimUI, var0_2)
	setActive(arg0_2._guardEffectTf, false)
	setActive(arg0_2._effectDizziTf, false)
end

function var0_0.step(arg0_3)
	arg0_3:applyActionDelay()

	local var0_3
	local var1_3

	arg0_3.freezeTime, var1_3 = arg0_3:countDelta(arg0_3.freezeTime)

	if var1_3 then
		arg0_3:addActionDelay(var3_0, function()
			return
		end, function()
			return
		end, 0)
		setActive(arg0_3._effectDizziTf, false)
	end

	local var2_3
	local var3_3

	arg0_3.guardTime, var3_3 = arg0_3:countDelta(arg0_3.guardTime)

	if var3_3 then
		setActive(arg0_3._guardEffectTf, false)
	end
end

function var0_0.stop(arg0_6)
	if isActive(arg0_6._char) then
		arg0_6._charAnimUI:Pause()
	end
end

function var0_0.resume(arg0_7)
	if isActive(arg0_7._char) then
		arg0_7._charAnimUI:Resume()
	end
end

function var0_0.applyActionDelay(arg0_8)
	if arg0_8.actionDelay then
		local var0_8 = arg0_8.actionDelay

		if not var0_8.start then
			var0_8.start = true

			arg0_8:setAnimation(arg0_8._charAnimUI, var0_8.action, function()
				if not var0_8.finish then
					var0_8.finishCall()

					var0_8.finish = true
				end
			end, function()
				if var0_8.actionCall then
					var0_8.actionCall()
				end
			end)
		end

		if var0_8.time and var0_8.time >= 0 then
			local var1_8
			local var2_8

			var0_8.time, var2_8 = arg0_8:countDelta(var0_8.time)

			if var2_8 and not var0_8.finish then
				var0_8.finishCall()

				var0_8.finish = true
			end
		end
	end

	if arg0_8.actionDelay and arg0_8.actionDelay.finish then
		arg0_8.actionDelay = nil
	end

	if not arg0_8.actionDelay and #arg0_8.actionDelays > 0 then
		arg0_8.actionDelay = table.remove(arg0_8.actionDelays, 1)

		arg0_8:applyActionDelay()
	end
end

function var0_0.countDelta(arg0_11, arg1_11)
	if arg1_11 and arg1_11 >= 0 then
		arg1_11 = arg1_11 - var1_0.deltaTime

		if arg1_11 <= 0 then
			arg1_11 = -1

			return arg1_11, true
		end
	end

	return arg1_11, false
end

function var0_0.getCharAnimName(arg0_12, arg1_12, arg2_12)
	local var0_12
	local var1_12 = arg2_12 == 1 and "right" or "left"

	if arg1_12 == var2_0 then
		var1_12 = arg2_12 == 1 and "left" or "right"

		return "move_" .. var1_12
	elseif arg1_12 == var3_0 then
		return "stand_" .. var1_12
	elseif arg1_12 == var4_0 then
		return "wield_" .. var1_12
	elseif arg1_12 == var5_0 then
		return "yun_" .. var1_12
	end

	warning("不存在的角色动画类型 =" .. tostring(arg1_12))

	return "move_" .. var1_12
end

function var0_0.setAnimation(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg1_13:SetActionCallBack(nil)
	arg1_13:SetAction(arg2_13, 0)
	arg1_13:SetActionCallBack(function(arg0_14)
		if arg0_14 == "action" and arg4_13 then
			arg4_13()
		end

		if arg0_14 == "finish" then
			arg1_13:SetActionCallBack(nil)

			if arg3_13 then
				arg3_13()
			end
		end
	end)
end

function var0_0.onTouchLeft(arg0_15)
	if not arg0_15:getTouchAble() then
		return
	end

	arg0_15.actionAble = false

	arg0_15:touchAction(-1)
end

function var0_0.onTouchRight(arg0_16)
	if not arg0_16:getTouchAble() then
		return
	end

	arg0_16.actionAble = false

	arg0_16:touchAction(1)
end

function var0_0.touchAction(arg0_17, arg1_17)
	if arg0_17.direct ~= arg1_17 then
		arg0_17.direct = arg1_17

		arg0_17:hideEffect()
		arg0_17:addActionDelay(var2_0, function()
			arg0_17:showEffect()
			arg0_17._event(TouchCakeScene.EVENT_ACTION_WIELD, arg0_17.direct, function()
				return
			end)
		end, function()
			local var0_20 = arg0_17:getCharAnimName(var3_0, arg0_17.direct)

			arg0_17:setAnimation(arg0_17._charAnimUI, var0_20)
		end)
	else
		arg0_17:addActionDelay(var4_0, function()
			arg0_17._event(TouchCakeScene.EVENT_ACTION_WIELD, arg0_17.direct, function()
				return
			end)
		end, function()
			local var0_23 = arg0_17:getCharAnimName(var3_0, arg0_17.direct)

			arg0_17:setAnimation(arg0_17._charAnimUI, var0_23)
		end)
	end
end

function var0_0.addActionDelay(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	local var0_24 = arg0_24:getCharAnimName(arg1_24, arg0_24.direct)

	table.insert(arg0_24.actionDelays, {
		action = var0_24,
		time = arg4_24,
		actionCall = arg2_24,
		finishCall = arg3_24
	})
end

function var0_0.hideEffect(arg0_25)
	setActive(arg0_25._guardEffectTf, false)
	setActive(arg0_25._effectDizziTf, false)
end

function var0_0.showEffect(arg0_26)
	if arg0_26.freezeTime > 0 then
		setActive(arg0_26._effectDizziTf, true)

		local var0_26 = arg0_26._effectDizziTf.anchoredPosition

		var0_26.x = arg0_26.direct == -1 and var6_0[1] or var6_0[2]
		arg0_26._effectDizziTf.anchoredPosition = var0_26
	end

	if arg0_26.guardTime > 0 then
		setActive(arg0_26._guardEffectTf, true)

		local var1_26 = arg0_26._guardEffectTf.anchoredPosition

		var1_26.x = arg0_26.direct == -1 and var6_0[1] or var6_0[2]
		arg0_26._guardEffectTf.anchoredPosition = var1_26
	end
end

function var0_0.guard(arg0_27, arg1_27)
	arg0_27.guardTime = arg1_27

	arg0_27:showEffect()
end

function var0_0.getGuard(arg0_28)
	return arg0_28.guardTime and arg0_28.guardTime > 0
end

function var0_0.dizzi(arg0_29, arg1_29)
	if arg0_29.guardTime and arg0_29.guardTime > 0 then
		return false
	end

	arg0_29:clearActionDelay()

	arg0_29.freezeTime = arg1_29

	arg0_29:showEffect()
	arg0_29:addActionDelay(var5_0, function()
		return
	end, function()
		return
	end)

	return true
end

function var0_0.getDirect(arg0_32)
	return arg0_32.direct
end

function var0_0.clearActionDelay(arg0_33)
	arg0_33.actionDelay = nil
	arg0_33.actionDelays = {}
end

function var0_0.getTouchAble(arg0_34)
	if arg0_34.actionDelay then
		return false
	end

	if arg0_34.freezeTime > 0 then
		return false
	end

	return true
end

function var0_0.clear(arg0_35)
	return
end

function var0_0.dispose(arg0_36)
	return
end

return var0_0
