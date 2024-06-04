local var0 = class("VedioStep", import(".StoryStep"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.cpkPath = arg1.cpkPath
	arg0.skippable = defaultValue(arg1.skippable, true)
	arg0.blackFg = 1
end

function var0.GetMode(arg0)
	return Story.MODE_VEDIO
end

function var0.GetVedioPath(arg0)
	return arg0.cpkPath
end

function var0.GetSkipFlag(arg0)
	return arg0.skippable
end

return var0
