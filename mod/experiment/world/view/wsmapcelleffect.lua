local var0 = class("WSMapCellEffect", import(".WSMapEffect"))

var0.Fields = {
	cell = "table",
	theme = "table"
}
var0.Listeners = {
	onUpdate = "Update"
}

function var0.GetName(arg0, arg1)
	return "cell_effect_" .. arg0 .. "_" .. arg1
end

function var0.Setup(arg0, arg1, arg2)
	assert(arg0.cell == nil)

	arg0.cell = arg1

	arg0.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:AddListener(WorldMapCell.EventUpdateDiscovered, arg0.onUpdate)
	arg0.cell:AddListener(WorldMapCell.EventUpdateFog, arg0.onUpdate)

	arg0.theme = arg2

	var0.super.Setup(arg0, WorldConst.GetTerrainEffectRes(arg0.cell:GetTerrain(), arg0.cell.terrainDir, arg0.cell.terrainStrong))
	arg0:Load(function()
		local var0 = arg0.cell
		local var1 = var0:GetTerrain()

		if var1 == WorldMapCell.TerrainStream then
			arg0:SetModelOrder(WorldConst.LOEffectB, var0.row)
		elseif var1 == WorldMapCell.TerrainWind then
			arg0:SetModelOrder(WorldConst.LOEffectC, var0.row)
			setActive(arg0.model:GetChild(0):Find("Xyz/Arrow"), var0.terrainStrong > 0)
			arg0:UpdateModelScale(WorldConst.GetWindScale(var0.terrainStrong))
		elseif var1 == WorldMapCell.TerrainIce then
			arg0:SetModelOrder(WorldConst.LOEffectA, var0.row)
		elseif var1 == WorldMapCell.TerrainPoison then
			arg0:SetModelOrder(WorldConst.LOEffectA, var0.row)
		end

		arg0:Init()
	end)
end

function var0.Dispose(arg0)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateDiscovered, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateFog, arg0.onUpdate)
	var0.super.Dispose(arg0)
end

function var0.Init(arg0)
	local var0 = arg0.cell
	local var1 = arg0.transform

	var1.name = var0.GetName(var0.row, var0.column)
	var1.anchoredPosition3D = arg0.theme:GetLinePosition(var0.row, var0.column)

	arg0:Update()
end

function var0.Update(arg0, arg1)
	local var0 = arg0.cell

	if arg1 == nil or arg1 == WorldMapCell.EventUpdateInFov or arg1 == WorldMapCell.EventUpdateFog then
		setActive(arg0.transform, var0:GetInFOV() and not var0:InFog())
	end
end

return var0
