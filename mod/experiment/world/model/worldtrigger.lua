local var0 = class("WorldTrigger", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	progress = "number",
	id = "number",
	maxProgress = "number",
	desc = "string"
}

function var0.Setup(arg0, arg1)
	arg0.id = arg1
end

function var0.GetProgress(arg0)
	return arg0.progress
end

function var0.GetMaxProgress(arg0)
	return arg0.maxProgress
end

function var0.GetDesc(arg0)
	return string.format("%s(%s/%s)", arg0.desc, arg0.progress, arg0.maxProgress)
end

function var0.IsAchieved(arg0)
	return arg0:GetProgress() >= arg0:GetMaxProgress()
end

return var0
