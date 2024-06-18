local var0_0 = class("OreMiner")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.interval = arg3_1
	arg0_1.animator = findTF(arg0_1._tf, "Image"):GetComponent(typeof(Animator))

	arg0_1:Init()
end

function var0_0.AddListener(arg0_2)
	arg0_2.binder:bind(OreGameConfig.EVENT_ORE_EF_MINED, function(arg0_3, arg1_3)
		arg0_2:PlayEFMined(arg1_3.index)
	end)
end

function var0_0.AddDftAniEvent(arg0_4)
	findTF(arg0_4._tf, "Image"):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0_4.binder:emit(OreGameConfig.EVENT_ORE_NEW, {
			index = arg0_4.index,
			pos = arg0_4._tf.parent.anchoredPosition
		})
	end)
	findTF(arg0_4._tf, "EF"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(findTF(arg0_4._tf, "EF"), false)
	end)
end

function var0_0.Init(arg0_7)
	arg0_7:AddListener()
	arg0_7:AddDftAniEvent()

	arg0_7.time = 1.5
	arg0_7.index = arg0_7._tf.name
end

function var0_0.Reset(arg0_8)
	arg0_8.interval = 1.5 + math.random()
	arg0_8.time = 1.5
end

function var0_0.PlayEFMined(arg0_9, arg1_9)
	if arg0_9.index == arg1_9 then
		setActive(findTF(arg0_9._tf, "EF"), true)
	end
end

function var0_0.OnTimer(arg0_10, arg1_10)
	if arg0_10.time >= arg0_10.interval then
		arg0_10.animator:Play("Mining")

		arg0_10.time = 0
	end

	arg0_10.time = arg0_10.time + arg1_10
end

return var0_0
