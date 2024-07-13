local var0_0 = class("WorldMapTheme", import("...BaseEntity"))

var0_0.Fields = {
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

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.assetSea = arg1_1[1]
	arg0_1.angle = arg1_1[2]
	arg0_1.fov = arg1_1[3]
	arg0_1.offsetx = arg1_1[4]
	arg0_1.offsety = arg1_1[5]
	arg0_1.cellSize = Vector2.New(arg1_1[6], arg1_1[7])
	arg0_1.cellSpace = Vector2.New(arg1_1[8], arg1_1[9])
	arg0_1.offsetz = arg1_1[10] or 0

	local var0_1 = arg0_1.angle / 180 * math.pi

	arg0_1.cosAngle = math.cos(var0_1)
	arg0_1.sinAngle = math.sin(var0_1)
end

function var0_0.GetLinePosition(arg0_2, arg1_2, arg2_2)
	local var0_2 = Vector2(arg2_2 + 0.5, WorldConst.MaxRow * 0.5 - arg1_2 - 0.5)

	return Vector3(var0_2.x * (arg0_2.cellSize.x + arg0_2.cellSpace.x), var0_2.y * (arg0_2.cellSize.y + arg0_2.cellSpace.y), 0)
end

function var0_0.X2Column(arg0_3, arg1_3)
	return math.round(arg1_3 / (arg0_3.cellSize.x + arg0_3.cellSpace.x) - 0.5)
end

function var0_0.Y2Row(arg0_4, arg1_4)
	return math.round(WorldConst.MaxRow * 0.5 - 0.5 - arg1_4 / (arg0_4.cellSize.y + arg0_4.cellSpace.y))
end

return var0_0
