local var0 = class("RectOriginsCom")

function var0.Ctor(arg0, arg1)
	arg0.skinWidth = 0.01
	arg0.dstBetweenRays = 0.3
	arg0.horizontalRayCount = 0
	arg0.verticalRayCount = 0
	arg0.horizontalRaySpacing = 0
	arg0.verticalRaySpacing = 0
	arg0.topLeft = Vector3.zero
	arg0.topRight = Vector3.zero
	arg0.bottomLeft = Vector3.zero
	arg0.bottomRight = Vector3.zero
	arg0.center = Vector3.zero
	arg0._collider = arg1
	arg0.initFlag = false
end

function var0.calculateRaySpacing(arg0)
	local var0 = arg0._collider.bounds

	var0:Expand(arg0.skinWidth * -2)

	local var1 = var0.size.x
	local var2 = var0.size.y

	arg0.verticalRayCount = Mathf.Round(var1 / arg0.dstBetweenRays)
	arg0.horizontalRayCount = Mathf.Round(var2 / arg0.dstBetweenRays)

	if arg0.verticalRayCount <= 1 then
		arg0.verticalRayCount = 2
	end

	arg0.horizontalRaySpacing = var0.size.y / (arg0.horizontalRayCount - 1)
	arg0.verticalRaySpacing = var0.size.x / (arg0.verticalRayCount - 1)
end

function var0.updateRaycastOrigins(arg0)
	if not arg0.initFlag then
		arg0.initFlag = true

		arg0:calculateRaySpacing()
	end

	local var0 = arg0._collider.bounds

	var0:Expand(arg0.skinWidth * -2)

	arg0.bottomLeft.x = var0.min.x
	arg0.bottomLeft.y = var0.min.y
	arg0.bottomLeft.z = var0.min.z
	arg0.bottomRight.x = var0.max.x
	arg0.bottomRight.y = var0.min.y
	arg0.bottomRight.z = var0.min.z
	arg0.topLeft.x = var0.min.x
	arg0.topLeft.y = var0.max.y
	arg0.topLeft.z = var0.max.z
	arg0.topRight.x = var0.max.x
	arg0.topRight.y = var0.max.y
	arg0.topRight.z = var0.max.z
	arg0.center.x = var0.center.x
	arg0.center.y = var0.center.y
	arg0.center.z = var0.center.z
end

function var0.createDebugImg(arg0, arg1, arg2)
	local var0 = arg0._collider.bounds

	var0:Expand(arg0.skinWidth * -2)

	arg0.bl = cloneTplTo(arg1, arg2, "bl")
	arg0.br = cloneTplTo(arg1, arg2, "br")
	arg0.tl = cloneTplTo(arg1, arg2, "tl")
	arg0.tr = cloneTplTo(arg1, arg2, "tr")
	arg0.bl.position = Vector3(var0.min.x, var0.min.y, var0.min.z)
	arg0.br.position = Vector3(var0.max.x, var0.min.y, var0.min.z)
	arg0.tl.position = Vector3(var0.min.x, var0.max.y, var0.max.z)
	arg0.tr.position = Vector3(var0.max.x, var0.max.y, var0.max.z)
end

return var0
