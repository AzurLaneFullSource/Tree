local var0_0 = class("RectOriginsCom")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.skinWidth = 0.01
	arg0_1.dstBetweenRays = 0.3
	arg0_1.horizontalRayCount = 0
	arg0_1.verticalRayCount = 0
	arg0_1.horizontalRaySpacing = 0
	arg0_1.verticalRaySpacing = 0
	arg0_1.topLeft = Vector3.zero
	arg0_1.topRight = Vector3.zero
	arg0_1.bottomLeft = Vector3.zero
	arg0_1.bottomRight = Vector3.zero
	arg0_1.center = Vector3.zero
	arg0_1._collider = arg1_1
	arg0_1.initFlag = false
end

function var0_0.calculateRaySpacing(arg0_2)
	local var0_2 = arg0_2._collider.bounds

	var0_2:Expand(arg0_2.skinWidth * -2)

	local var1_2 = var0_2.size.x
	local var2_2 = var0_2.size.y

	arg0_2.verticalRayCount = Mathf.Round(var1_2 / arg0_2.dstBetweenRays)
	arg0_2.horizontalRayCount = Mathf.Round(var2_2 / arg0_2.dstBetweenRays)

	if arg0_2.verticalRayCount <= 1 then
		arg0_2.verticalRayCount = 2
	end

	arg0_2.horizontalRaySpacing = var0_2.size.y / (arg0_2.horizontalRayCount - 1)
	arg0_2.verticalRaySpacing = var0_2.size.x / (arg0_2.verticalRayCount - 1)
end

function var0_0.updateRaycastOrigins(arg0_3)
	if not arg0_3.initFlag then
		arg0_3.initFlag = true

		arg0_3:calculateRaySpacing()
	end

	local var0_3 = arg0_3._collider.bounds

	var0_3:Expand(arg0_3.skinWidth * -2)

	arg0_3.bottomLeft.x = var0_3.min.x
	arg0_3.bottomLeft.y = var0_3.min.y
	arg0_3.bottomLeft.z = var0_3.min.z
	arg0_3.bottomRight.x = var0_3.max.x
	arg0_3.bottomRight.y = var0_3.min.y
	arg0_3.bottomRight.z = var0_3.min.z
	arg0_3.topLeft.x = var0_3.min.x
	arg0_3.topLeft.y = var0_3.max.y
	arg0_3.topLeft.z = var0_3.max.z
	arg0_3.topRight.x = var0_3.max.x
	arg0_3.topRight.y = var0_3.max.y
	arg0_3.topRight.z = var0_3.max.z
	arg0_3.center.x = var0_3.center.x
	arg0_3.center.y = var0_3.center.y
	arg0_3.center.z = var0_3.center.z
end

function var0_0.createDebugImg(arg0_4, arg1_4, arg2_4)
	local var0_4 = arg0_4._collider.bounds

	var0_4:Expand(arg0_4.skinWidth * -2)

	arg0_4.bl = cloneTplTo(arg1_4, arg2_4, "bl")
	arg0_4.br = cloneTplTo(arg1_4, arg2_4, "br")
	arg0_4.tl = cloneTplTo(arg1_4, arg2_4, "tl")
	arg0_4.tr = cloneTplTo(arg1_4, arg2_4, "tr")
	arg0_4.bl.position = Vector3(var0_4.min.x, var0_4.min.y, var0_4.min.z)
	arg0_4.br.position = Vector3(var0_4.max.x, var0_4.min.y, var0_4.min.z)
	arg0_4.tl.position = Vector3(var0_4.min.x, var0_4.max.y, var0_4.max.z)
	arg0_4.tr.position = Vector3(var0_4.max.x, var0_4.max.y, var0_4.max.z)
end

return var0_0
