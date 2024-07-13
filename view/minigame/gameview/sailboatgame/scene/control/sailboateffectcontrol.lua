local var0_0 = class("SailBoatEffectControl")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = SailBoatGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._content = findTF(arg0_1._tf, "scene_front/content")
	arg0_1._effects = {}
	arg0_1._effectPool = {}
end

function var0_0.start(arg0_2)
	for iter0_2 = #arg0_2._effects, 1, -1 do
		local var0_2 = table.remove(arg0_2._effects, iter0_2)

		setActive(var0_2.tf, false)
		table.insert(arg0_2._effectPool, var0_2)
	end
end

function var0_0.step(arg0_3, arg1_3)
	return
end

function var0_0.getEffect(arg0_4, arg1_4)
	if #arg0_4._effectPool > 0 then
		for iter0_4 = 1, #arg0_4._effectPool do
			if #arg0_4._effectPool[iter0_4].name == arg1_4 then
				return (table.remove(arg0_4._effectPool, iter0_4))
			end
		end
	end

	local var0_4 = var1_0.GetGameEffectTf(arg1_4)
	local var1_4 = {
		tf = var0_4,
		name = arg1_4
	}

	GetComponent(findTF(var0_4, "img"), typeof(DftAniEvent)):SetEndEvent(function()
		arg0_4:effectEnd(var1_4)
	end)

	return var1_4
end

function var0_0.onEventCall(arg0_6, arg1_6, arg2_6)
	if arg1_6 == SailBoatGameEvent.CREATE_EFFECT then
		local var0_6 = arg2_6.effect
		local var1_6 = arg2_6.direct
		local var2_6 = arg2_6.position
		local var3_6 = arg2_6.content

		arg0_6:createEffect(var0_6, var1_6, var2_6, var3_6)
	end
end

function var0_0.createEffect(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = arg0_7:getEffect(arg1_7)

	if arg2_7 then
		var0_7.tf.localScale = arg2_7
	end

	if arg3_7 then
		var0_7.tf.anchoredPosition = arg3_7
	end

	if arg4_7 then
		SetParent(var0_7.tf, arg4_7)
	else
		SetParent(var0_7.tf, arg0_7._content)
	end

	setActive(var0_7.tf, true)
	table.insert(arg0_7._effects, var0_7)
end

function var0_0.effectEnd(arg0_8, arg1_8)
	for iter0_8 = 1, #arg0_8._effects do
		if arg0_8._effects[iter0_8] == arg1_8 then
			local var0_8 = table.remove(arg0_8._effects, iter0_8)

			setActive(var0_8.tf, false)
			table.insert(arg0_8._effectPool, var0_8)

			return
		end
	end
end

function var0_0.dispose(arg0_9)
	return
end

function var0_0.clear(arg0_10)
	return
end

return var0_0
