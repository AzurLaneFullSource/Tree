local var0_0 = class("IslandStrollNpcUnit", import(".IslandDressupNpcUnit"))

function var0_0.SetupBt(arg0_1)
	if not arg0_1.behaviourTreeOwner then
		return
	end

	local var0_1 = arg0_1.data:GetPath()

	LuaHelper.NodeCanvasSetIntVariableValue(arg0_1.behaviourTreeOwner, "pathId", var0_1)
	var0_0.super.SetupBt(arg0_1)
end

return var0_0
