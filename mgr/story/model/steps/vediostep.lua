local var0_0 = class("VedioStep", import(".StoryStep"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.cpkPath = arg1_1.cpkPath
	arg0_1.skippable = defaultValue(arg1_1.skippable, true)
	arg0_1.blackFg = 1
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_VEDIO
end

function var0_0.GetVedioPath(arg0_3)
	return arg0_3.cpkPath
end

function var0_0.GetSkipFlag(arg0_4)
	return arg0_4.skippable
end

return var0_0
