local var0_0 = class("IslandSeekGameSystem", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))

function var0_0.OnSceneInitEnd(arg0_1)
	arg0_1.MONITOR_LIST = arg0_1.data:GetInteractiveObjects()

	for iter0_1, iter1_1 in ipairs(arg0_1:GetObjUnitList()) do
		if iter1_1.behaviourTreeOwner then
			LuaHelper.NodeCanvasSetIntVariableValue(iter1_1.behaviourTreeOwner, "systemId", arg0_1.id)
		end
	end

	if arg0_1.behaviourTreeOwner then
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_1.behaviourTreeOwner, "step", 0)
	end

	arg0_1:Start()
end

function var0_0.StartGame(arg0_2)
	for iter0_2, iter1_2 in ipairs(arg0_2:GetObjUnitList()) do
		iter1_2:Start()
	end
end

function var0_0.OnLateUpdate(arg0_3)
	return
end

function var0_0.StopGame(arg0_4)
	if arg0_4.behaviourTreeOwner then
		arg0_4:StopBt()
	end

	local var0_4 = arg0_4:GetObjUnitList()

	for iter0_4, iter1_4 in ipairs(var0_4) do
		if table.contains(arg0_4.MONITOR_LIST, iter1_4.id) then
			iter1_4:StopBt()
		end
	end
end

function var0_0.RestartGame(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5:GetObjUnitList()) do
		if iter1_5.behaviourTreeOwner then
			LuaHelper.NodeCanvasSetIntVariableValue(iter1_5.behaviourTreeOwner, "step", 0)
		end

		iter1_5:RestartBt()
	end

	if arg0_5.behaviourTreeOwner then
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_5.behaviourTreeOwner, "step", 0)
		arg0_5:RestartBt()
	end
end

function var0_0.GetObjUnitList(arg0_6)
	return arg0_6:GetView():GetUnitListByKey(IslandConst.UNIT_LIST_OBJ)
end

function var0_0.GetUnitById(arg0_7, arg1_7)
	return arg0_7:GetView():GetUnitModule(arg1_7)
end

return var0_0
