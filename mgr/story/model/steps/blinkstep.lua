local var0_0 = class("BlinkStep", import(".StoryStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.openRange = arg1_1.openRange or {
		1,
		0.6
	}
	arg0_1.openTime = arg1_1.open or 1
	arg0_1.closeRange = arg1_1.closeRange or {
		0.6,
		1
	}
	arg0_1.closeTime = arg1_1.close or 1
	arg0_1.holdRange = arg1_1.holdRange or {
		1,
		1
	}
	arg0_1.holdTime = arg1_1.hold or 1
	arg0_1.ease = arg1_1.ease or LeanTweenType.easeInOutQuad
	arg0_1.nextBgName = arg1_1.nextBgName
	arg0_1.blurTimeFactor = arg1_1.blurTimeFactor or {
		0.7,
		0.9
	}
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_BLINK
end

function var0_0.GetOpenEyeData(arg0_3)
	return {
		open = Vector3(arg0_3.openRange[1], arg0_3.openRange[2], arg0_3.openTime),
		close = Vector3(arg0_3.closeRange[1], arg0_3.closeRange[2], arg0_3.closeTime),
		hold = Vector3(arg0_3.holdRange[1], arg0_3.holdRange[2], arg0_3.holdTime),
		ease = arg0_3.ease
	}
end

function var0_0.GetNextBgName(arg0_4)
	return arg0_4.nextBgName
end

return var0_0
