local var0_0 = class("RectCollisionVertical")

var0_0.directUp = Vector3(0, 1, 0)
var0_0.directDown = Vector3(0, -1, 0)
var0_0.directRight = Vector3(1, 0, 0)
var0_0.directLeft = Vector3(-1, 0, 0)

function var0_0.DescendSlope(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg2_1.bottomLeft
	local var1_1 = arg2_1.bottomRight
	local var2_1 = Vector3(0, -1, 0)
	local var3_1 = Mathf.Abs(arg0_1.y) + arg2_1.skinWidth
	local var4_1 = arg1_1.layerMask
	local var5_1, var6_1 = Physics.Raycast(arg2_1.bottomLeft, Vector3.down, nil, var3_1, var4_1)
	local var7_1, var8_1 = Physics.Raycast(arg2_1.bottomRight, Vector3.down, nil, var3_1, var4_1)

	if var5_1 or var7_1 then
		local var9_1 = false

		if var5_1 and not var7_1 or not var5_1 and var7_1 then
			var9_1 = true
		else
			local var10_1 = Vector3.Angle(var6_1.normal, Vector3.up)
			local var11_1 = Vector3.Angle(var8_1.normal, Vector3.up)

			if var10_1 <= arg1_1.config.maxSlopeAngle and var11_1 > arg1_1.config.maxSlopeAngle then
				var9_1 = true
			elseif var10_1 > arg1_1.config.maxSlopeAngle and var11_1 <= arg1_1.config.maxSlopeAngle then
				var9_1 = true
			end
		end

		if var9_1 then
			var0_0.slideDownMaxSlope(var6_1, arg0_1, arg1_1)
			var0_0.slideDownMaxSlope(var8_1, arg0_1, arg1_1)
		end
	end

	if not arg1_1.slidingDownMaxSlope then
		local var12_1 = Mathf.Sign(arg0_1.x)
		local var13_1 = var12_1 == -1 and arg2_1.bottomRight or arg2_1.bottomLeft
		local var14_1, var15_1 = Physics.Raycast(var13_1, var0_0.directDown, nil, Mathf.Infinity, var4_1)

		if var14_1 then
			local var16_1 = Vector3.Angle(var15_1.normal, var0_0.directUp)

			if var16_1 ~= 0 and var16_1 <= arg1_1.config.maxSlopeAngle and Mathf.Sign(var15_1.normal.x) == var12_1 and var15_1.distance - arg2_1.skinWidth <= Mathf.Tan(var16_1 * Mathf.Deg2Rad) * Mathf.Abs(arg0_1.x) then
				local var17_1 = Mathf.Abs(arg0_1.x)
				local var18_1 = Mathf.Sin(var16_1 * Mathf.Deg2Rad) * var17_1

				arg0_1.x = Mathf.Cos(var16_1 * Mathf.Deg2Rad) * var17_1 * Mathf.Sign(arg0_1.x)
				arg0_1.y = arg0_1.y - var18_1
				arg1_1.slopeAngle = var16_1
				arg1_1.descendingSlope = true
				arg1_1.below = true
				arg1_1.slopeNormal = var15_1.normal
			end
		end
	end
end

function var0_0.slideDownMaxSlope(arg0_2, arg1_2, arg2_2)
	if arg0_2 and arg1_2.y ~= 0 then
		local var0_2 = Vector3.Angle(arg0_2.normal, Vector3.up)

		if var0_2 > arg2_2.config.maxSlopeAngle then
			local var1_2 = Mathf.Sign(arg1_2.y)

			if Mathf.Abs(arg1_2.y) > arg2_2.config.downMaxSlopeSpeed * Time.deltaTime then
				arg1_2.y = arg2_2.config.downMaxSlopeSpeed * Time.deltaTime * var1_2
			end

			local var2_2 = (Mathf.Abs(arg1_2.y) - arg0_2.distance) / Mathf.Tan(var0_2 * Mathf.Deg2Rad)

			arg1_2.x = Mathf.Sign(arg0_2.normal.x) * var2_2
			arg2_2.slopeAngle = var0_2
			arg2_2.slidingDownMaxSlope = true
			arg2_2.slopeNormal = arg0_2.normal
		end
	end
end

function var0_0.VerticalCollisions(arg0_3, arg1_3, arg2_3)
	local var0_3 = Mathf.Sign(arg0_3.y)
	local var1_3 = var0_3 == 1 and var0_0.directUp or var0_0.directDown
	local var2_3 = Mathf.Abs(arg0_3.y) + arg2_3.skinWidth * 2
	local var3_3 = Vector3(0, 0, 0)
	local var4_3 = var0_3 == -1 and arg2_3.bottomLeft or arg2_3.topLeft

	for iter0_3 = 1, arg2_3.verticalRayCount do
		var3_3.x = var4_3.x + (arg2_3.verticalRaySpacing * (iter0_3 - 1) + arg0_3.x)
		var3_3.y = var4_3.y
		var3_3.z = var4_3.z

		local var5_3, var6_3 = Physics.Raycast(var3_3, var1_3, nil, var2_3, arg1_3.layerMask)
		local var7_3 = false
		local var8_3 = false

		if var6_3 then
			local var9_3 = var6_3.transform.parent

			if table.contains(arg1_3.ignoreLayerMask, go(var9_3).layer) then
				var8_3 = true
			end

			if var0_3 == 1 and not arg1_3.verticalTopTfs[var9_3] then
				arg1_3.verticalTopTfs[var9_3] = var9_3
			elseif var0_3 == -1 and not arg1_3.verticalBottomTfs[var9_3] then
				arg1_3.verticalBottomTfs[var9_3] = var9_3
			end
		end

		if not var8_3 and var5_3 then
			local var10_3 = var6_3

			if not var7_3 then
				arg0_3.y = (var6_3.distance - arg2_3.skinWidth) * var0_3
				var2_3 = var6_3.distance

				if arg1_3.climbingSlope then
					arg0_3.x = arg0_3.y / Mathf.Tan(arg1_3.slopeAngle * Mathf.Deg2Rad) * Mathf.Sign(arg0_3.x)
				end

				arg1_3.below = var0_3 == -1
				arg1_3.above = var0_3 == 1
			end
		end
	end
end

return var0_0
