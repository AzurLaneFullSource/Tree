local var0_0 = class("WSMapCellEffect", import(".WSMapEffect"))

var0_0.Fields = {
	cell = "table",
	theme = "table"
}
var0_0.Listeners = {
	onUpdate = "Update"
}

function var0_0.GetName(arg0_1, arg1_1)
	return "cell_effect_" .. arg0_1 .. "_" .. arg1_1
end

function var0_0.Setup(arg0_2, arg1_2, arg2_2)
	assert(arg0_2.cell == nil)

	arg0_2.cell = arg1_2

	arg0_2.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0_2.onUpdate)
	arg0_2.cell:AddListener(WorldMapCell.EventUpdateDiscovered, arg0_2.onUpdate)
	arg0_2.cell:AddListener(WorldMapCell.EventUpdateFog, arg0_2.onUpdate)

	arg0_2.theme = arg2_2

	var0_0.super.Setup(arg0_2, WorldConst.GetTerrainEffectRes(arg0_2.cell:GetTerrain(), arg0_2.cell.terrainDir, arg0_2.cell.terrainStrong))
	arg0_2:Load(function()
		local var0_3 = arg0_2.cell
		local var1_3 = var0_3:GetTerrain()

		if var1_3 == WorldMapCell.TerrainStream then
			arg0_2:SetModelOrder(WorldConst.LOEffectB, var0_3.row)
		elseif var1_3 == WorldMapCell.TerrainWind then
			arg0_2:SetModelOrder(WorldConst.LOEffectC, var0_3.row)
			setActive(arg0_2.model:GetChild(0):Find("Xyz/Arrow"), var0_3.terrainStrong > 0)
			arg0_2:UpdateModelScale(WorldConst.GetWindScale(var0_3.terrainStrong))
		elseif var1_3 == WorldMapCell.TerrainIce then
			arg0_2:SetModelOrder(WorldConst.LOEffectA, var0_3.row)
		elseif var1_3 == WorldMapCell.TerrainPoison then
			arg0_2:SetModelOrder(WorldConst.LOEffectA, var0_3.row)
		end

		arg0_2:Init()
	end)
end

function var0_0.Dispose(arg0_4)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0_4.onUpdate)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateDiscovered, arg0_4.onUpdate)
	arg0_4.cell:RemoveListener(WorldMapCell.EventUpdateFog, arg0_4.onUpdate)
	var0_0.super.Dispose(arg0_4)
end

function var0_0.Init(arg0_5)
	local var0_5 = arg0_5.cell
	local var1_5 = arg0_5.transform

	var1_5.name = var0_0.GetName(var0_5.row, var0_5.column)
	var1_5.anchoredPosition3D = arg0_5.theme:GetLinePosition(var0_5.row, var0_5.column)

	arg0_5:Update()
end

function var0_0.Update(arg0_6, arg1_6)
	local var0_6 = arg0_6.cell

	if arg1_6 == nil or arg1_6 == WorldMapCell.EventUpdateInFov or arg1_6 == WorldMapCell.EventUpdateFog then
		setActive(arg0_6.transform, var0_6:GetInFOV() and not var0_6:InFog())
	end
end

return var0_0
