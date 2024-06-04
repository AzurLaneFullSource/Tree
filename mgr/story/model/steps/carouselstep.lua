local var0 = class("CarouselStep", import(".StoryStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.bgs = arg1.bgs
end

function var0.GetMode(arg0)
	return Story.MODE_CAROUSE
end

function var0.GetBgs(arg0)
	return arg0.bgs
end

return var0
