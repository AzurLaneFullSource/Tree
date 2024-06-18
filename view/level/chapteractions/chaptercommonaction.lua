local var0_0 = class("ChapterCommonAction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.command = setmetatable({}, ChapterOpCommand)

	arg0_1.command:initData(arg1_1.op, arg1_1.data, arg1_1.chapter)
end

function var0_0.applyTo(arg0_2, arg1_2, arg2_2)
	if arg2_2 then
		return true
	end

	arg0_2.command.chapter = arg1_2

	arg0_2.command:doMapUpdate()
	arg0_2.command:doAIUpdate()
	arg0_2.command:doShipUpdate()
	arg0_2.command:doBuffUpdate()
	arg0_2.command:doCellFlagUpdate()
	arg0_2.command:doExtraFlagUpdate()

	return true, arg0_2.command.flag, arg0_2.command.extraFlag
end

function var0_0.PlayAIAction(arg0_3, arg1_3, arg2_3, arg3_3)
	existCall(arg3_3)
end

return var0_0
