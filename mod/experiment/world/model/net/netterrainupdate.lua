local var0_0 = class("NetTerrainUpdate", import("....BaseEntity"))

var0_0.Fields = {
	row = "number",
	terrain = "number",
	terrainDir = "number",
	column = "number",
	terrainStrong = "number"
}

function var0_0.DebugPrint(arg0_1)
	return "{" .. arg0_1.row .. "," .. arg0_1.column .. "} " .. arg0_1.terrain
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.row = arg1_2.pos.row
	arg0_2.column = arg1_2.pos.column
	arg0_2.terrain = arg1_2.type

	if arg0_2.terrain == WorldMapCell.TerrainStream then
		arg0_2.terrainDir = WorldConst.ParseConfigDir(arg1_2.dir.row - 1, arg1_2.dir.column - 1)
	elseif arg0_2.terrain == WorldMapCell.TerrainWind then
		arg0_2.terrainDir = WorldConst.ParseConfigDir(arg1_2.dir.row - 1, arg1_2.dir.column - 1)
		arg0_2.terrainStrong = arg1_2.distance
	elseif arg0_2.terrain == WorldMapCell.TerrainFog then
		arg0_2.terrainStrong = arg1_2.distance
	elseif arg0_2.terrain == WorldMapCell.TerrainPoison then
		arg0_2.terrainStrong = arg1_2.distance
	end
end

function var0_0.GetTerrain(arg0_3)
	return arg0_3.terrain
end

return var0_0
