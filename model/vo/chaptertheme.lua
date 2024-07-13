local var0_0 = class("ChapterTheme")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.assetSea = arg1_1[1]
	arg0_1.angle = arg1_1[2]
	arg0_1.fov = arg1_1[3]
	arg0_1.offsetx = arg1_1[4]
	arg0_1.offsety = arg1_1[5]
	arg0_1.offsetz = 0
	arg0_1.cellSize = Vector2.New(arg1_1[6], arg1_1[7])
	arg0_1.cellSpace = Vector2.New(arg1_1[8], arg1_1[9])
	arg0_1.seaBase = arg1_1[10]
end

function var0_0.GetLinePosition(arg0_2, arg1_2, arg2_2)
	local var0_2 = Vector2(arg2_2 + 0.5, ChapterConst.MaxRow * 0.5 - arg1_2 - 0.5)

	return Vector3(var0_2.x * (arg0_2.cellSize.x + arg0_2.cellSpace.x), var0_2.y * (arg0_2.cellSize.y + arg0_2.cellSpace.y), 0)
end

return var0_0
