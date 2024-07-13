local var0_0 = class("CarouselStep", import(".StoryStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.bgs = arg1_1.bgs
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_CAROUSE
end

function var0_0.GetBgs(arg0_3)
	return arg0_3.bgs
end

return var0_0
