local var0_0 = class("IslandCharUnitBuilder", import(".IslandBaseBuilder"))

function var0_0.Load(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg1_1:GetAssetPath()
	local var1_1 = arg1_1:GetAnimator()
	local var2_1 = arg1_1:GetBehaviourTree()

	arg0_1:GetPoolMgr():GetSceneCharacter(var0_1, var1_1, var2_1, arg2_1)
end

function var0_0.Recycle(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2:GetAssetPath()
	local var1_2 = arg1_2:GetAnimator()
	local var2_2 = arg1_2:GetBehaviourTree()

	arg0_2:GetPoolMgr():ReturnSceneCharacter(var0_2, var1_2, var2_2, arg2_2)
end

return var0_0
