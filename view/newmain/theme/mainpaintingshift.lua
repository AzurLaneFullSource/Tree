local var0_0 = class("MainPaintingShift")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.meshImageShift = Vector3(arg1_1[1], arg1_1[2], 0) + (arg2_1 or Vector3.zero)
	arg0_1.l2dShift = Vector3(arg1_1[3], arg1_1[4], 0)
	arg0_1.spineShift = Vector3(arg1_1[5], arg1_1[6], 0)
	arg0_1.scale = Vector3(arg1_1[7], arg1_1[7], 1)
	arg0_1.l2dScale = Vector3(arg1_1[8], arg1_1[8], 1)
	arg0_1.spineScale = Vector3(arg1_1[9], arg1_1[9], 1)
end

function var0_0.GetMeshImageShift(arg0_2)
	return arg0_2.meshImageShift, arg0_2.scale
end

function var0_0.GetL2dShift(arg0_3)
	return arg0_3.l2dShift, arg0_3.l2dScale
end

function var0_0.GetSpineShift(arg0_4)
	return arg0_4.spineShift, arg0_4.spineScale
end

return var0_0
