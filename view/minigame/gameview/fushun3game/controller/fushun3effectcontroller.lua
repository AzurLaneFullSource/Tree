local var0 = class("Fushun3EffectController")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._effectTpl = arg1
	arg0._effectPos = arg2
	arg0._event = arg3
	arg0._effects = {}
	arg0._effectPool = {}
end

function var0.start(arg0)
	for iter0 = #arg0._effects, 1, -1 do
		arg0:returnEffectToPool(table.remove(arg0._effects, iter0))
	end
end

function var0.step(arg0)
	return
end

function var0.returnEffectToPool(arg0, arg1)
	setActive(arg1.tf, false)
	table.insert(arg0._effectPool, arg1)
end

function var0.addEffectByName(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	local var0 = arg0:getOrCreateEffect(nil, arg1)

	if var0 then
		arg0:addEffectToTarget(var0, arg2)
		table.insert(arg0._effects, var0)
	end
end

function var0.addEffectByAnim(arg0, arg1, arg2)
	if not arg1 then
		return
	end

	local var0 = arg0:getOrCreateEffect(arg1)

	if var0 then
		arg0:addEffectToTarget(var0, arg2)
		table.insert(arg0._effects, var0)
	end
end

function var0.addEffectToTarget(arg0, arg1, arg2)
	if arg1.data.parent then
		SetParent(arg1.tf, arg2)

		arg1.tf.localScale = arg2.localScale
		arg1.tf.anchoredPosition = Vector2(0, 0)

		setActive(arg1.tf, true)
		table.insert(arg0._effects, arg1)
	else
		setParent(arg1.tf, arg0._effectPos)

		arg1.tf.localScale = Fushun3GameConst.game_scale_v3
		arg1.tf.position = arg2.position

		setActive(arg1.tf, true)
	end
end

function var0.getOrCreateEffect(arg0, arg1, arg2)
	for iter0 = 1, #arg0._effectPool do
		if arg1 and arg0._effectPool[iter0].data.trigger == arg1 or arg2 and arg0._effectPool[iter0].data.name == arg2 then
			return table.remove(arg0._effectPool, iter0)
		end
	end

	local var0 = arg0:getEffectData(arg1, arg2)

	return arg0:instiateEffect(var0)
end

function var0.instiateEffect(arg0, arg1)
	if arg1 then
		local var0 = tf(instantiate(findTF(arg0._effectTpl, arg1.name)))
		local var1 = {
			tf = var0,
			data = arg1
		}

		GetOrAddComponent(findTF(var0, "efAnim"), typeof(DftAniEvent)):SetEndEvent(function()
			arg0:removeEffect(var1)
		end)

		return var1
	end
end

function var0.removeEffect(arg0, arg1)
	for iter0 = #arg0._effects, 1, -1 do
		if arg0._effects[iter0] == arg1 then
			setActive(arg0._effects[iter0].tf, false)
			arg0:returnEffectToPool(table.remove(arg0._effects, iter0))
		end
	end
end

function var0.getEffectData(arg0, arg1, arg2)
	if arg1 then
		for iter0 = 1, #Fushun3GameConst.effect_data do
			if Fushun3GameConst.effect_data[iter0].trigger == arg1 then
				return Clone(Fushun3GameConst.effect_data[iter0])
			end
		end
	elseif arg2 then
		for iter1 = 1, #Fushun3GameConst.effect_data do
			if Fushun3GameConst.effect_data[iter1].name == arg2 then
				return Clone(Fushun3GameConst.effect_data[iter1])
			end
		end
	end
end

return var0
