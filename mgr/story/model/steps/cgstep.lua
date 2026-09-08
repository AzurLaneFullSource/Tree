local var0_0 = class("CGStep", import(".StoryStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bgs = arg1_1.bgs or {}
	arg0_1.hideBgAlpha = true
	arg0_1.reflux = arg1_1.reflux
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_CG
end

function var0_0.GetBgs(arg0_3)
	if arg0_3.reflux then
		return getProxy(RefluxProxy):GetRefluxBgs()
	end

	return arg0_3.bgs
end

return var0_0
