local var0_0 = class("Fushun3EffectController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._effectTpl = arg1_1
	arg0_1._effectPos = arg2_1
	arg0_1._event = arg3_1
	arg0_1._effects = {}
	arg0_1._effectPool = {}
end

function var0_0.start(arg0_2)
	for iter0_2 = #arg0_2._effects, 1, -1 do
		arg0_2:returnEffectToPool(table.remove(arg0_2._effects, iter0_2))
	end
end

function var0_0.step(arg0_3)
	return
end

function var0_0.returnEffectToPool(arg0_4, arg1_4)
	setActive(arg1_4.tf, false)
	table.insert(arg0_4._effectPool, arg1_4)
end

function var0_0.addEffectByName(arg0_5, arg1_5, arg2_5)
	if not arg1_5 then
		return
	end

	local var0_5 = arg0_5:getOrCreateEffect(nil, arg1_5)

	if var0_5 then
		arg0_5:addEffectToTarget(var0_5, arg2_5)
		table.insert(arg0_5._effects, var0_5)
	end
end

function var0_0.addEffectByAnim(arg0_6, arg1_6, arg2_6)
	if not arg1_6 then
		return
	end

	local var0_6 = arg0_6:getOrCreateEffect(arg1_6)

	if var0_6 then
		arg0_6:addEffectToTarget(var0_6, arg2_6)
		table.insert(arg0_6._effects, var0_6)
	end
end

function var0_0.addEffectToTarget(arg0_7, arg1_7, arg2_7)
	if arg1_7.data.parent then
		SetParent(arg1_7.tf, arg2_7)

		arg1_7.tf.localScale = arg2_7.localScale
		arg1_7.tf.anchoredPosition = Vector2(0, 0)

		setActive(arg1_7.tf, true)
		table.insert(arg0_7._effects, arg1_7)
	else
		setParent(arg1_7.tf, arg0_7._effectPos)

		arg1_7.tf.localScale = Fushun3GameConst.game_scale_v3
		arg1_7.tf.position = arg2_7.position

		setActive(arg1_7.tf, true)
	end
end

function var0_0.getOrCreateEffect(arg0_8, arg1_8, arg2_8)
	for iter0_8 = 1, #arg0_8._effectPool do
		if arg1_8 and arg0_8._effectPool[iter0_8].data.trigger == arg1_8 or arg2_8 and arg0_8._effectPool[iter0_8].data.name == arg2_8 then
			return table.remove(arg0_8._effectPool, iter0_8)
		end
	end

	local var0_8 = arg0_8:getEffectData(arg1_8, arg2_8)

	return arg0_8:instiateEffect(var0_8)
end

function var0_0.instiateEffect(arg0_9, arg1_9)
	if arg1_9 then
		local var0_9 = tf(instantiate(findTF(arg0_9._effectTpl, arg1_9.name)))
		local var1_9 = {
			tf = var0_9,
			data = arg1_9
		}

		GetOrAddComponent(findTF(var0_9, "efAnim"), typeof(DftAniEvent)):SetEndEvent(function()
			arg0_9:removeEffect(var1_9)
		end)

		return var1_9
	end
end

function var0_0.removeEffect(arg0_11, arg1_11)
	for iter0_11 = #arg0_11._effects, 1, -1 do
		if arg0_11._effects[iter0_11] == arg1_11 then
			setActive(arg0_11._effects[iter0_11].tf, false)
			arg0_11:returnEffectToPool(table.remove(arg0_11._effects, iter0_11))
		end
	end
end

function var0_0.getEffectData(arg0_12, arg1_12, arg2_12)
	if arg1_12 then
		for iter0_12 = 1, #Fushun3GameConst.effect_data do
			if Fushun3GameConst.effect_data[iter0_12].trigger == arg1_12 then
				return Clone(Fushun3GameConst.effect_data[iter0_12])
			end
		end
	elseif arg2_12 then
		for iter1_12 = 1, #Fushun3GameConst.effect_data do
			if Fushun3GameConst.effect_data[iter1_12].name == arg2_12 then
				return Clone(Fushun3GameConst.effect_data[iter1_12])
			end
		end
	end
end

return var0_0
