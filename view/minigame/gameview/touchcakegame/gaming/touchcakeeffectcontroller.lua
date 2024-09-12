local var0_0 = class("TouchCakeEffectController")
local var1_0
local var2_0 = 6

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = TouchCakeGameVo
	arg0_1._content = arg1_1
	arg0_1._event = arg2_1
	arg0_1._boomTf = var1_0.GetTplItemFromPool("BoomTpl", arg0_1._content)
	arg0_1._boomSpineAnims = {}

	for iter0_1 = 1, var2_0 do
		table.insert(arg0_1._boomSpineAnims, GetComponent(findTF(arg0_1._boomTf, "spine_" .. iter0_1), typeof(SpineAnimUI)))
	end
end

function var0_0.start(arg0_2)
	setActive(arg0_2._boomTf, false)

	arg0_2._boomTime = 0
	arg0_2._delayBoomTime = 0
end

function var0_0.step(arg0_3)
	local var0_3
	local var1_3

	arg0_3._delayBoomTime, var1_3 = arg0_3:countDelta(arg0_3._delayBoomTime)

	if var1_3 then
		setActive(arg0_3._boomTf, true)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_0.SFX_COUNT_CLICK3)

		for iter0_3, iter1_3 in ipairs(arg0_3._boomSpineAnims) do
			arg0_3:setAnimation(iter1_3, "action", nil, "normal")
		end
	end

	local var2_3
	local var3_3

	arg0_3._boomTime, var3_3 = arg0_3:countDelta(arg0_3._boomTime)

	if var3_3 then
		arg0_3._boomTime = 0

		for iter2_3, iter3_3 in ipairs(arg0_3._boomSpineAnims) do
			arg0_3:setAnimation(iter3_3, "action_end", function()
				if isActive(arg0_3._boomTf) then
					setActive(arg0_3._boomTf, false)
				end
			end)
		end
	end
end

function var0_0.countDelta(arg0_5, arg1_5)
	if arg1_5 and arg1_5 > 0 then
		arg1_5 = arg1_5 - var1_0.deltaTime

		if arg1_5 <= 0 then
			arg1_5 = 0

			return arg1_5, true
		end
	end

	return arg1_5, false
end

function var0_0.stop(arg0_6)
	if isActive(arg0_6._boomTf) then
		for iter0_6, iter1_6 in ipairs(arg0_6._boomSpineAnims) do
			iter1_6:Pause()
		end
	end
end

function var0_0.resume(arg0_7)
	if isActive(arg0_7._boomTf) then
		for iter0_7, iter1_7 in ipairs(arg0_7._boomSpineAnims) do
			iter1_7:Resume()
		end
	end
end

function var0_0.clear(arg0_8)
	return
end

function var0_0.showBoom(arg0_9, arg1_9, arg2_9)
	arg0_9._delayBoomTime = arg2_9
	arg0_9._boomTime = arg1_9
end

function var0_0.setAnimation(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	arg1_10:SetActionCallBack(nil)
	arg1_10:SetAction(arg2_10, 0)
	arg1_10:SetActionCallBack(function(arg0_11)
		if arg0_11 == "finish" then
			if arg4_10 then
				arg1_10:SetAction(arg4_10, 0)
			end

			arg1_10:SetActionCallBack(nil)

			if arg3_10 then
				arg3_10()
			end
		end
	end)
end

function var0_0.dispose(arg0_12)
	return
end

return var0_0
