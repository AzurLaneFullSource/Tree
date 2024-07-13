local var0_0 = class("RectCollisionHorizontal")

var0_0.directUp = Vector3(0, 1, 0)
var0_0.directDown = Vector3(0, -1, 0)
var0_0.directRight = Vector3(1, 0, 0)
var0_0.directLeft = Vector3(-1, 0, 0)

function var0_0.HorizontalCollisions(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg0_1.x ~= 0 and Mathf.Sign(arg0_1.x) or arg1_1.MoveDir
	local var1_1 = var0_1 == 1 and var0_0.directRight or var0_0.directLeft
	local var2_1 = var0_1 == -1 and arg2_1.bottomLeft or arg2_1.bottomRight
	local var3_1 = Mathf.Abs(arg0_1.x) + arg2_1.skinWidth

	if Mathf.Abs(arg0_1.x) < arg2_1.skinWidth then
		var3_1 = 2 * arg2_1.skinWidth
	end

	local var4_1 = false
	local var5_1 = Vector3.zero

	for iter0_1 = 1, arg2_1.horizontalRayCount do
		var5_1.x = var2_1.x
		var5_1.y = var2_1.y + arg2_1.horizontalRaySpacing * (iter0_1 - 1)
		var5_1.z = var2_1.z

		local var6_1, var7_1 = Physics.Raycast(var5_1, var1_1, nil, var3_1, arg1_1.layerMask)
		local var8_1 = false

		if var7_1 then
			local var9_1 = var7_1.transform.parent

			if table.contains(arg1_1.ignoreLayerMask, go(var9_1).layer) then
				var8_1 = true
			end

			if var0_1 == 1 and not arg1_1.horizontalRightTfs[var9_1] then
				arg1_1.horizontalRightTfs[var9_1] = var9_1
			elseif var0_1 == -1 and not arg1_1.horizontalLeftTfs[var9_1] then
				arg1_1.horizontalLeftTfs[var9_1] = var9_1
			end
		end

		if not var8_1 and var6_1 and var7_1.distance ~= 0 then
			local var10_1 = Vector3.Angle(var7_1.normal, var0_0.directUp)

			if iter0_1 == 1 and var10_1 <= arg1_1.config.maxSlopeAngle then
				if arg1_1.descendingSlope then
					arg1_1.descendingSlope = false
					arg0_1 = arg1_1.moveAmountOld
				end

				local var11_1 = 0

				if var10_1 ~= arg1_1.slopeAngleOld then
					var11_1 = var7_1.distance - arg2_1.skinWidth
					arg0_1.x = arg0_1.x - var11_1 * var0_1
				end

				RectCollisionHorizontal.ClimbSlope(arg0_1, arg1_1, var10_1, var7_1.normal)

				arg0_1.x = arg0_1.x + var11_1 * var0_1
			end

			if not arg1_1.climbingSlope or var10_1 > arg1_1.config.maxSlopeAngle then
				arg0_1.x = (var7_1.distance - arg2_1.skinWidth) * var0_1
				var3_1 = var7_1.distance

				if arg1_1.climbingSlope then
					arg0_1.y = Mathf.Tan(arg1_1.slopeAngle * Mathf.Deg2Rad) * Mathf.Abs(arg0_1.x)
				end

				if iter0_1 == 1 then
					var4_1 = true
				end

				arg1_1.left = var0_1 == -1
				arg1_1.right = var0_1 == 1
			end
		end
	end

	if var4_1 then
		local var12_1 = 2 * arg2_1.skinWidth

		var5_1.x = var2_1.x
		var5_1.y = var2_1.y + arg2_1.horizontalRaySpacing * (arg2_1.horizontalRayCount - 1)
		var5_1.z = var2_1.z

		local var13_1, var14_1 = Physics.Raycast(var5_1, var1_1, nil, var12_1, arg1_1.layerMask)

		if var13_1 and Vector3.Angle(var14_1.normal, var0_0.directUp) > arg1_1.config.maxSlopeAngle then
			arg1_1.fullSliding = true
		end
	end
end

function var0_0.ClimbSlope(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = Mathf.Abs(arg0_2.x)
	local var1_2 = Mathf.Sin(arg2_2 * Mathf.Deg2Rad) * var0_2

	if var1_2 >= arg0_2.y then
		arg0_2.y = var1_2
		arg0_2.x = Mathf.Cos(arg2_2 * Mathf.Deg2Rad) * var0_2 * Mathf.Sign(arg0_2.x)
		arg1_2.below = true
		arg1_2.climbingSlope = true
		arg1_2.slopeAngle = arg2_2
		arg1_2.slopeNormal = arg3_2
	end
end

return var0_0
