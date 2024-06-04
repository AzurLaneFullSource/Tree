local var0 = class("SailBoatEffectControl")
local var1

function var0.Ctor(arg0, arg1, arg2)
	var1 = SailBoatGameVo
	arg0._tf = arg1
	arg0._event = arg2
	arg0._content = findTF(arg0._tf, "scene_front/content")
	arg0._effects = {}
	arg0._effectPool = {}
end

function var0.start(arg0)
	for iter0 = #arg0._effects, 1, -1 do
		local var0 = table.remove(arg0._effects, iter0)

		setActive(var0.tf, false)
		table.insert(arg0._effectPool, var0)
	end
end

function var0.step(arg0, arg1)
	return
end

function var0.getEffect(arg0, arg1)
	if #arg0._effectPool > 0 then
		for iter0 = 1, #arg0._effectPool do
			if #arg0._effectPool[iter0].name == arg1 then
				return (table.remove(arg0._effectPool, iter0))
			end
		end
	end

	local var0 = var1.GetGameEffectTf(arg1)
	local var1 = {
		tf = var0,
		name = arg1
	}

	GetComponent(findTF(var0, "img"), typeof(DftAniEvent)):SetEndEvent(function()
		arg0:effectEnd(var1)
	end)

	return var1
end

function var0.onEventCall(arg0, arg1, arg2)
	if arg1 == SailBoatGameEvent.CREATE_EFFECT then
		local var0 = arg2.effect
		local var1 = arg2.direct
		local var2 = arg2.position
		local var3 = arg2.content

		arg0:createEffect(var0, var1, var2, var3)
	end
end

function var0.createEffect(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:getEffect(arg1)

	if arg2 then
		var0.tf.localScale = arg2
	end

	if arg3 then
		var0.tf.anchoredPosition = arg3
	end

	if arg4 then
		SetParent(var0.tf, arg4)
	else
		SetParent(var0.tf, arg0._content)
	end

	setActive(var0.tf, true)
	table.insert(arg0._effects, var0)
end

function var0.effectEnd(arg0, arg1)
	for iter0 = 1, #arg0._effects do
		if arg0._effects[iter0] == arg1 then
			local var0 = table.remove(arg0._effects, iter0)

			setActive(var0.tf, false)
			table.insert(arg0._effectPool, var0)

			return
		end
	end
end

function var0.dispose(arg0)
	return
end

function var0.clear(arg0)
	return
end

return var0
