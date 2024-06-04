local var0 = class("MainPaintingShift")

function var0.Ctor(arg0, arg1, arg2)
	arg0.meshImageShift = Vector3(arg1[1], arg1[2], 0) + (arg2 or Vector3.zero)
	arg0.l2dShift = Vector3(arg1[3], arg1[4], 0)
	arg0.spineShift = Vector3(arg1[5], arg1[6], 0)
	arg0.scale = Vector3(arg1[7], arg1[7], 1)
	arg0.l2dScale = Vector3(arg1[8], arg1[8], 1)
	arg0.spineScale = Vector3(arg1[9], arg1[9], 1)
end

function var0.GetMeshImageShift(arg0)
	return arg0.meshImageShift, arg0.scale
end

function var0.GetL2dShift(arg0)
	return arg0.l2dShift, arg0.l2dScale
end

function var0.GetSpineShift(arg0)
	return arg0.spineShift, arg0.spineScale
end

return var0
