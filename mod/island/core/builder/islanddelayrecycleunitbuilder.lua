local var0_0 = class("IslandDelayRecycleUnitBuilder", import(".IslandBaseBuilder"))

var0_0.RecycleType = {
	NormalSceneItem = 1,
	ProductEffect = 2
}

function var0_0.GetModule(arg0_1, arg1_1, arg2_1)
	return IslandDelayRecycleUnit.New(arg1_1, arg2_1)
end

function var0_0.Load(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg1_2:GetAssetPath()
	local var1_2 = arg1_2.recycleAssetType

	if var1_2 == var0_0.RecycleType.NormalSceneItem then
		arg0_2:GetPoolMgr():GetSceneProductItem(var0_2, arg2_2)
	elseif var1_2 == var0_0.RecycleType.ProductEffect then
		arg0_2:GetPoolMgr():GetSceneProductEffect(var0_2, arg2_2)
	end
end

function var0_0.Recycle(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg1_3:GetAssetPath()
	local var1_3 = arg1_3.recycleAssetType

	if var1_3 == IslandDelayRecycleUnitBuilder.RecycleType.NormalSceneItem then
		arg0_3:GetPoolMgr():ReturnSceneProductItem(var0_3, arg2_3)
	elseif var1_3 == IslandDelayRecycleUnitBuilder.RecycleType.ProductEffect then
		arg0_3:GetPoolMgr():ReturnSceneProductEffect(var0_3, arg2_3)
	end
end

return var0_0
