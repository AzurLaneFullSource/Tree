local var0_0 = class("IslandGoundLayerSystem", import("Mod.Island.Core.View.SceneObject.IslandSceneUnit"))

function var0_0.OnAttach(arg0_1, arg1_1)
	arg0_1.floorTileRenderer = arg1_1:GetComponent(typeof(BLHX.Rendering.FloorTileRenderer))
end

function var0_0.OnStart(arg0_2)
	return
end

function var0_0.FillFloorCell(arg0_3, arg1_3)
	local var0_3 = arg0_3.data:MapPoint2GroundPoint(arg1_3:GetPosition())
	local var1_3 = arg1_3:GetShapeId()
	local var2_3 = arg0_3:ItemID2TextureId(arg1_3)
	local var3_3 = IslandConst.AGORA_LAYER_FLOOR

	arg0_3.floorTileRenderer:SetTexture(var3_3, var2_3, var1_3, var0_3.x, var0_3.y)
end

function var0_0.ClearFloorCell(arg0_4, arg1_4)
	local var0_4 = IslandConst.AGORA_LAYER_FLOOR
	local var1_4 = arg0_4.data:MapPoint2GroundPoint(arg1_4)

	arg0_4.floorTileRenderer:RemoveTexture(var0_4, var1_4.x, var1_4.y)
end

function var0_0.FillTileCell(arg0_5, arg1_5)
	local var0_5 = arg0_5.data:MapPoint2GroundPoint(arg1_5:GetPosition())
	local var1_5 = arg1_5:GetShapeId()
	local var2_5 = arg0_5:ItemID2TextureId(arg1_5)
	local var3_5 = IslandConst.AGORA_LAYER_TILE

	arg0_5.floorTileRenderer:SetTexture(var3_5, var2_5, var1_5, var0_5.x, var0_5.y)
end

function var0_0.ClearTileCell(arg0_6, arg1_6)
	local var0_6 = IslandConst.AGORA_LAYER_TILE
	local var1_6 = arg0_6.data:MapPoint2GroundPoint(arg1_6)

	arg0_6.floorTileRenderer:RemoveTexture(var0_6, var1_6.x, var1_6.y)
end

function var0_0.ItemID2TextureId(arg0_7, arg1_7)
	local var0_7 = arg1_7:GetID()
	local var1_7 = arg1_7:GetModel()
	local var2_7 = LuaHelper.GetFloorTileRendererLayerIndex(arg0_7.floorTileRenderer, var1_7)

	assert(var2_7 >= 0, "cant found textureId>>>>>>>>>" .. var1_7)

	return var2_7
end

function var0_0.Enable(arg0_8)
	return
end

function var0_0.Disable(arg0_9)
	return
end

function var0_0.OnDetach(arg0_10)
	return
end

return var0_0
