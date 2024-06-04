local var0 = class("ChapterCommonAction")

function var0.Ctor(arg0, arg1)
	arg0.command = setmetatable({}, ChapterOpCommand)

	arg0.command:initData(arg1.op, arg1.data, arg1.chapter)
end

function var0.applyTo(arg0, arg1, arg2)
	if arg2 then
		return true
	end

	arg0.command.chapter = arg1

	arg0.command:doMapUpdate()
	arg0.command:doAIUpdate()
	arg0.command:doShipUpdate()
	arg0.command:doBuffUpdate()
	arg0.command:doCellFlagUpdate()
	arg0.command:doExtraFlagUpdate()

	return true, arg0.command.flag, arg0.command.extraFlag
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	existCall(arg3)
end

return var0
