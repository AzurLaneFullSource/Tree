local var0_0 = class("Dorm3dBaseScene", import("view.base.BaseUI"))

function var0_0.GetDefaultSystemClasses()
	return DormConst.GetDefaultSystemClasses()
end

function var0_0.InitExtraSystem(arg0_2, arg1_2)
	if not arg0_2.systemManager then
		arg0_2.systemManager = ExtraSystemManager.New(arg0_2.event, arg0_2)
	end

	arg1_2 = arg1_2 or arg0_2.GetDefaultSystemClasses()

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		arg0_2.systemManager:Register(iter1_2)
	end
end

function var0_0.RemoveExtraSystem(arg0_3, arg1_3)
	if not arg0_3.systemManager then
		return
	end

	arg1_3 = arg1_3 or arg0_3.GetDefaultSystemClasses()

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		arg0_3.systemManager:Remove(iter1_3)
	end
end

function var0_0.GetExtraSystem(arg0_4, arg1_4)
	if not arg0_4.systemManager then
		return nil
	end

	return arg0_4.systemManager:Get(arg1_4)
end

function var0_0.willExit(arg0_5)
	arg0_5:RemoveExtraSystem()

	if arg0_5.systemManager then
		arg0_5.systemManager:Dispose()

		arg0_5.systemManager = nil
	end
end

return var0_0
