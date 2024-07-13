local var0_0 = class("WorldTrigger", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	progress = "number",
	id = "number",
	maxProgress = "number",
	desc = "string"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.id = arg1_1
end

function var0_0.GetProgress(arg0_2)
	return arg0_2.progress
end

function var0_0.GetMaxProgress(arg0_3)
	return arg0_3.maxProgress
end

function var0_0.GetDesc(arg0_4)
	return string.format("%s(%s/%s)", arg0_4.desc, arg0_4.progress, arg0_4.maxProgress)
end

function var0_0.IsAchieved(arg0_5)
	return arg0_5:GetProgress() >= arg0_5:GetMaxProgress()
end

return var0_0
