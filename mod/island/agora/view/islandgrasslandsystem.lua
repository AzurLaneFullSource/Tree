local var0_0 = class("IslandGrassLandSystem", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))

function var0_0.OnLaterAttach(arg0_1, arg1_1)
	local var0_1 = arg0_1._go.transform.position
	local var1_1 = arg0_1.data:GetSize()

	BLHX.Rendering.TerrainDetailTileMask.Instance:Init(var0_1.x, var0_1.z, var1_1.x, var1_1.y, 1)
end

function var0_0.SetVisible(arg0_2, arg1_2, arg2_2)
	if arg1_2:IsBuildingType() then
		return
	end

	local var0_2 = arg1_2:GetPosition()
	local var1_2 = arg1_2:GetSizeWithRotation()
	local var2_2 = arg0_2.data:MapPoint2GroundPoint(var0_2)

	BLHX.Rendering.TerrainDetailTileMask.Instance:SetVisible(var2_2.x, var2_2.y, var1_2.x, var1_2.y, arg2_2)
end

function var0_0.OnDetach(arg0_3)
	BLHX.Rendering.TerrainDetailTileMask.Instance:Dispose()
end

return var0_0
