local var0 = class("NetTerrainUpdate", import("....BaseEntity"))

var0.Fields = {
	row = "number",
	terrain = "number",
	terrainDir = "number",
	column = "number",
	terrainStrong = "number"
}

function var0.DebugPrint(arg0)
	return "{" .. arg0.row .. "," .. arg0.column .. "} " .. arg0.terrain
end

function var0.Setup(arg0, arg1)
	arg0.row = arg1.pos.row
	arg0.column = arg1.pos.column
	arg0.terrain = arg1.type

	if arg0.terrain == WorldMapCell.TerrainStream then
		arg0.terrainDir = WorldConst.ParseConfigDir(arg1.dir.row - 1, arg1.dir.column - 1)
	elseif arg0.terrain == WorldMapCell.TerrainWind then
		arg0.terrainDir = WorldConst.ParseConfigDir(arg1.dir.row - 1, arg1.dir.column - 1)
		arg0.terrainStrong = arg1.distance
	elseif arg0.terrain == WorldMapCell.TerrainFog then
		arg0.terrainStrong = arg1.distance
	elseif arg0.terrain == WorldMapCell.TerrainPoison then
		arg0.terrainStrong = arg1.distance
	end
end

function var0.GetTerrain(arg0)
	return arg0.terrain
end

return var0
