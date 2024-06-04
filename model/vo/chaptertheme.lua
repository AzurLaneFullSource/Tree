local var0 = class("ChapterTheme")

function var0.Ctor(arg0, arg1)
	arg0.assetSea = arg1[1]
	arg0.angle = arg1[2]
	arg0.fov = arg1[3]
	arg0.offsetx = arg1[4]
	arg0.offsety = arg1[5]
	arg0.offsetz = 0
	arg0.cellSize = Vector2.New(arg1[6], arg1[7])
	arg0.cellSpace = Vector2.New(arg1[8], arg1[9])
	arg0.seaBase = arg1[10]
end

function var0.GetLinePosition(arg0, arg1, arg2)
	local var0 = Vector2(arg2 + 0.5, ChapterConst.MaxRow * 0.5 - arg1 - 0.5)

	return Vector3(var0.x * (arg0.cellSize.x + arg0.cellSpace.x), var0.y * (arg0.cellSize.y + arg0.cellSpace.y), 0)
end

return var0
