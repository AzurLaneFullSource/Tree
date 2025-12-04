local var0_0 = class("IslandDelegationFishBuilder", import(".IslandGenericBuilder"))

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandDelegationFishUnit.New(arg1_1, arg2_1)
end

function var0_0.LoadAsset(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2.modelId
	local var1_2 = arg1_2:GetAssetPath()
	local var2_2 = arg1_2:GetAnimator()
	local var3_2 = arg1_2:GetBehaviourTree()

	arg0_2:GetPoolMgr():GetSceneDelegateItem(var1_2, var2_2, var3_2, arg2_2)
end

function var0_0.Recycle(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:GetAssetPath()
	local var1_3 = arg1_3:GetAnimator()
	local var2_3 = arg1_3:GetBehaviourTree()

	arg0_3:GetPoolMgr():ReturnSceneDelegateItem(var0_3, var1_3, var2_3, arg2_3)
end

function var0_0.SetTag(arg0_4, arg1_4)
	arg1_4.tag = IslandConst.TAG_NPC
end

return var0_0
