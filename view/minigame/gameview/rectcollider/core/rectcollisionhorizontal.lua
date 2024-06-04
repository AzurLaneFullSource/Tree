local var0 = class("RectCollisionHorizontal")

var0.directUp = Vector3(0, 1, 0)
var0.directDown = Vector3(0, -1, 0)
var0.directRight = Vector3(1, 0, 0)
var0.directLeft = Vector3(-1, 0, 0)

function var0.HorizontalCollisions(arg0, arg1, arg2)
	local var0 = arg0.x ~= 0 and Mathf.Sign(arg0.x) or arg1.MoveDir
	local var1 = var0 == 1 and var0.directRight or var0.directLeft
	local var2 = var0 == -1 and arg2.bottomLeft or arg2.bottomRight
	local var3 = Mathf.Abs(arg0.x) + arg2.skinWidth

	if Mathf.Abs(arg0.x) < arg2.skinWidth then
		var3 = 2 * arg2.skinWidth
	end

	local var4 = false
	local var5 = Vector3.zero

	for iter0 = 1, arg2.horizontalRayCount do
		var5.x = var2.x
		var5.y = var2.y + arg2.horizontalRaySpacing * (iter0 - 1)
		var5.z = var2.z

		local var6, var7 = Physics.Raycast(var5, var1, nil, var3, arg1.layerMask)
		local var8 = false

		if var7 then
			local var9 = var7.transform.parent

			if table.contains(arg1.ignoreLayerMask, go(var9).layer) then
				var8 = true
			end

			if var0 == 1 and not arg1.horizontalRightTfs[var9] then
				arg1.horizontalRightTfs[var9] = var9
			elseif var0 == -1 and not arg1.horizontalLeftTfs[var9] then
				arg1.horizontalLeftTfs[var9] = var9
			end
		end

		if not var8 and var6 and var7.distance ~= 0 then
			local var10 = Vector3.Angle(var7.normal, var0.directUp)

			if iter0 == 1 and var10 <= arg1.config.maxSlopeAngle then
				if arg1.descendingSlope then
					arg1.descendingSlope = false
					arg0 = arg1.moveAmountOld
				end

				local var11 = 0

				if var10 ~= arg1.slopeAngleOld then
					var11 = var7.distance - arg2.skinWidth
					arg0.x = arg0.x - var11 * var0
				end

				RectCollisionHorizontal.ClimbSlope(arg0, arg1, var10, var7.normal)

				arg0.x = arg0.x + var11 * var0
			end

			if not arg1.climbingSlope or var10 > arg1.config.maxSlopeAngle then
				arg0.x = (var7.distance - arg2.skinWidth) * var0
				var3 = var7.distance

				if arg1.climbingSlope then
					arg0.y = Mathf.Tan(arg1.slopeAngle * Mathf.Deg2Rad) * Mathf.Abs(arg0.x)
				end

				if iter0 == 1 then
					var4 = true
				end

				arg1.left = var0 == -1
				arg1.right = var0 == 1
			end
		end
	end

	if var4 then
		local var12 = 2 * arg2.skinWidth

		var5.x = var2.x
		var5.y = var2.y + arg2.horizontalRaySpacing * (arg2.horizontalRayCount - 1)
		var5.z = var2.z

		local var13, var14 = Physics.Raycast(var5, var1, nil, var12, arg1.layerMask)

		if var13 and Vector3.Angle(var14.normal, var0.directUp) > arg1.config.maxSlopeAngle then
			arg1.fullSliding = true
		end
	end
end

function var0.ClimbSlope(arg0, arg1, arg2, arg3)
	local var0 = Mathf.Abs(arg0.x)
	local var1 = Mathf.Sin(arg2 * Mathf.Deg2Rad) * var0

	if var1 >= arg0.y then
		arg0.y = var1
		arg0.x = Mathf.Cos(arg2 * Mathf.Deg2Rad) * var0 * Mathf.Sign(arg0.x)
		arg1.below = true
		arg1.climbingSlope = true
		arg1.slopeAngle = arg2
		arg1.slopeNormal = arg3
	end
end

return var0
