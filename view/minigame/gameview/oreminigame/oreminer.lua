local var0 = class("OreMiner")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.binder = arg1
	arg0._tf = arg2
	arg0.interval = arg3
	arg0.animator = findTF(arg0._tf, "Image"):GetComponent(typeof(Animator))

	arg0:Init()
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_ORE_EF_MINED, function(arg0, arg1)
		arg0:PlayEFMined(arg1.index)
	end)
end

function var0.AddDftAniEvent(arg0)
	findTF(arg0._tf, "Image"):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0.binder:emit(OreGameConfig.EVENT_ORE_NEW, {
			index = arg0.index,
			pos = arg0._tf.parent.anchoredPosition
		})
	end)
	findTF(arg0._tf, "EF"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(findTF(arg0._tf, "EF"), false)
	end)
end

function var0.Init(arg0)
	arg0:AddListener()
	arg0:AddDftAniEvent()

	arg0.time = 1.5
	arg0.index = arg0._tf.name
end

function var0.Reset(arg0)
	arg0.interval = 1.5 + math.random()
	arg0.time = 1.5
end

function var0.PlayEFMined(arg0, arg1)
	if arg0.index == arg1 then
		setActive(findTF(arg0._tf, "EF"), true)
	end
end

function var0.OnTimer(arg0, arg1)
	if arg0.time >= arg0.interval then
		arg0.animator:Play("Mining")

		arg0.time = 0
	end

	arg0.time = arg0.time + arg1
end

return var0
