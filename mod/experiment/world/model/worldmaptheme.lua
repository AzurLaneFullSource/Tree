local var0 = class("WorldMapTheme", import("...BaseEntity"))

var0.Fields = {
	sinAngle = "number",
	cellSpace = "table",
	fov = "number",
	offsetx = "number",
	assetSea = "string",
	offsetz = "number",
	cosAngle = "number",
	offsety = "number",
	cellSize = "table",
	angle = "number"
}

function var0.Setup(arg0, arg1)
	arg0.assetSea = arg1[1]
	arg0.angle = arg1[2]
	arg0.fov = arg1[3]
	arg0.offsetx = arg1[4]
	arg0.offsety = arg1[5]
	arg0.cellSize = Vector2.New(arg1[6], arg1[7])
	arg0.cellSpace = Vector2.New(arg1[8], arg1[9])
	arg0.offsetz = arg1[10] or 0

	local var0 = arg0.angle / 180 * math.pi

	arg0.cosAngle = math.cos(var0)
	arg0.sinAngle = math.sin(var0)
end

function var0.GetLinePosition(arg0, arg1, arg2)
	local var0 = Vector2(arg2 + 0.5, WorldConst.MaxRow * 0.5 - arg1 - 0.5)

	return Vector3(var0.x * (arg0.cellSize.x + arg0.cellSpace.x), var0.y * (arg0.cellSize.y + arg0.cellSpace.y), 0)
end

function var0.X2Column(arg0, arg1)
	return math.round(arg1 / (arg0.cellSize.x + arg0.cellSpace.x) - 0.5)
end

function var0.Y2Row(arg0, arg1)
	return math.round(WorldConst.MaxRow * 0.5 - 0.5 - arg1 / (arg0.cellSize.y + arg0.cellSpace.y))
end

return var0
