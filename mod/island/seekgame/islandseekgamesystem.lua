local var0_0 = class("IslandSeekGameSystem", import("Mod.Island.Core.View.SceneObject.IslandSystem"))
local var1_0 = 10090002
local var2_0 = 10090009

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, {
		name = "seekGameSystem",
		id = arg2_1
	})
end

function var0_0.GetBehaviourTree(arg0_2)
	return "island/nodecanvas/seekgame/seekgame"
end

function var0_0.OnSceneInitEnd(arg0_3)
	for iter0_3, iter1_3 in ipairs(arg0_3:GetView():GetUnitList()) do
		if iter1_3.behaviourTreeOwner then
			LuaHelper.NodeCanvasSetIntVariableValue(iter1_3.behaviourTreeOwner, "systemId", arg0_3.id)
		end

		if iter1_3.id == var1_0 then
			iter1_3:Start()
		end
	end

	if arg0_3.behaviourTreeOwner then
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_3.behaviourTreeOwner, "mingshiId", var1_0)
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_3.behaviourTreeOwner, "doorId", var2_0)
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_3.behaviourTreeOwner, "step", 1)
	end

	arg0_3:Start()
end

function var0_0.StartGame(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4:GetView():GetUnitList()) do
		if iter1_4.id ~= var1_0 then
			iter1_4:Start()
		end
	end
end

function var0_0.StopGame(arg0_5)
	if arg0_5.behaviourTreeOwner then
		arg0_5:StopBt()
	end

	local var0_5 = arg0_5:GetView():GetUnitList()

	for iter0_5, iter1_5 in ipairs(var0_5) do
		iter1_5:StopBt()
	end
end

function var0_0.RestartGame(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6:GetView():GetUnitList()) do
		if iter1_6.behaviourTreeOwner then
			LuaHelper.NodeCanvasSetIntVariableValue(iter1_6.behaviourTreeOwner, "step", 0)
		end

		iter1_6:RestartBt()
	end

	if arg0_6.behaviourTreeOwner then
		LuaHelper.NodeCanvasSetIntVariableValue(arg0_6.behaviourTreeOwner, "step", 0)
		arg0_6:RestartBt()
	end
end

return var0_0
