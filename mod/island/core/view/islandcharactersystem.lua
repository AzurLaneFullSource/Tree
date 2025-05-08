local var0_0 = class("IslandCharacterSystem", import("Mod.Island.Core.View.SceneObject.IslandSystem"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scheduleList = {}
	arg0_1.workerCnt = arg0_1.data:GetWorkerCnt()
end

function var0_0.OnStart(arg0_2)
	if arg0_2.behaviourTreeOwner then
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_2.behaviourTreeOwner, "worker", arg0_2.workerCnt)
	end
end

function var0_0.StartDelegation(arg0_3, arg1_3)
	if not arg0_3.behaviourTreeOwner then
		return
	end

	table.insert(arg0_3.scheduleList, arg1_3)
end

function var0_0.ExecuteDelegation(arg0_4, arg1_4)
	arg0_4.workerCnt = arg0_4.workerCnt + 1

	local var0_4 = arg0_4:GetView():GetSystemUnitModule(arg1_4.ship_id)
	local var1_4 = arg0_4.data:GetObjId(arg1_4.area_id)
	local var2_4 = arg0_4:GetView():GetUnitModule(var1_4)

	if var0_4 and var0_4:IsLoaded() and var2_4 and var2_4:IsLoaded() and arg0_4:IsLoaded() then
		local var3_4 = System.Collections.Generic.List_int()

		var3_4:Add(arg1_4.ship_id)
		var3_4:Add(var1_4)
		var3_4:Add(arg0_4.id)
		arg0_4.behaviourTreeOwner:SendEvent("system_unit_add", var3_4, nil)
	end
end

function var0_0.EndDelegation(arg0_5, arg1_5)
	if not arg0_5.behaviourTreeOwner then
		return
	end

	arg0_5.workerCnt = arg0_5.workerCnt - 1

	LuaHelper.NodeCanvasSetIntVariableValue(arg0_5.behaviourTreeOwner, "worker", arg0_5.workerCnt)
end

function var0_0.OnUpdate(arg0_6)
	if #arg0_6.scheduleList <= 0 then
		return
	end

	if not arg0_6:GetView():IsLoaded() then
		return
	end

	local var0_6 = table.remove(arg0_6.scheduleList, 1)

	arg0_6:ExecuteDelegation(var0_6)
end

function var0_0.OnDestroy(arg0_7)
	table.clear(arg0_7.scheduleList)
end

return var0_0
