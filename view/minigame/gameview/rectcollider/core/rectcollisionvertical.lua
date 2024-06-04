local var0 = class("RectCollisionVertical")

var0.directUp = Vector3(0, 1, 0)
var0.directDown = Vector3(0, -1, 0)
var0.directRight = Vector3(1, 0, 0)
var0.directLeft = Vector3(-1, 0, 0)

function var0.DescendSlope(arg0, arg1, arg2)
	local var0 = arg2.bottomLeft
	local var1 = arg2.bottomRight
	local var2 = Vector3(0, -1, 0)
	local var3 = Mathf.Abs(arg0.y) + arg2.skinWidth
	local var4 = arg1.layerMask
	local var5, var6 = Physics.Raycast(arg2.bottomLeft, Vector3.down, nil, var3, var4)
	local var7, var8 = Physics.Raycast(arg2.bottomRight, Vector3.down, nil, var3, var4)

	if var5 or var7 then
		local var9 = false

		if var5 and not var7 or not var5 and var7 then
			var9 = true
		else
			local var10 = Vector3.Angle(var6.normal, Vector3.up)
			local var11 = Vector3.Angle(var8.normal, Vector3.up)

			if var10 <= arg1.config.maxSlopeAngle and var11 > arg1.config.maxSlopeAngle then
				var9 = true
			elseif var10 > arg1.config.maxSlopeAngle and var11 <= arg1.config.maxSlopeAngle then
				var9 = true
			end
		end

		if var9 then
			var0.slideDownMaxSlope(var6, arg0, arg1)
			var0.slideDownMaxSlope(var8, arg0, arg1)
		end
	end

	if not arg1.slidingDownMaxSlope then
		local var12 = Mathf.Sign(arg0.x)
		local var13 = var12 == -1 and arg2.bottomRight or arg2.bottomLeft
		local var14, var15 = Physics.Raycast(var13, var0.directDown, nil, Mathf.Infinity, var4)

		if var14 then
			local var16 = Vector3.Angle(var15.normal, var0.directUp)

			if var16 ~= 0 and var16 <= arg1.config.maxSlopeAngle and Mathf.Sign(var15.normal.x) == var12 and var15.distance - arg2.skinWidth <= Mathf.Tan(var16 * Mathf.Deg2Rad) * Mathf.Abs(arg0.x) then
				local var17 = Mathf.Abs(arg0.x)
				local var18 = Mathf.Sin(var16 * Mathf.Deg2Rad) * var17

				arg0.x = Mathf.Cos(var16 * Mathf.Deg2Rad) * var17 * Mathf.Sign(arg0.x)
				arg0.y = arg0.y - var18
				arg1.slopeAngle = var16
				arg1.descendingSlope = true
				arg1.below = true
				arg1.slopeNormal = var15.normal
			end
		end
	end
end

function var0.slideDownMaxSlope(arg0, arg1, arg2)
	if arg0 and arg1.y ~= 0 then
		local var0 = Vector3.Angle(arg0.normal, Vector3.up)

		if var0 > arg2.config.maxSlopeAngle then
			local var1 = Mathf.Sign(arg1.y)

			if Mathf.Abs(arg1.y) > arg2.config.downMaxSlopeSpeed * Time.deltaTime then
				arg1.y = arg2.config.downMaxSlopeSpeed * Time.deltaTime * var1
			end

			local var2 = (Mathf.Abs(arg1.y) - arg0.distance) / Mathf.Tan(var0 * Mathf.Deg2Rad)

			arg1.x = Mathf.Sign(arg0.normal.x) * var2
			arg2.slopeAngle = var0
			arg2.slidingDownMaxSlope = true
			arg2.slopeNormal = arg0.normal
		end
	end
end

function var0.VerticalCollisions(arg0, arg1, arg2)
	local var0 = Mathf.Sign(arg0.y)
	local var1 = var0 == 1 and var0.directUp or var0.directDown
	local var2 = Mathf.Abs(arg0.y) + arg2.skinWidth * 2
	local var3 = Vector3(0, 0, 0)
	local var4 = var0 == -1 and arg2.bottomLeft or arg2.topLeft

	for iter0 = 1, arg2.verticalRayCount do
		var3.x = var4.x + (arg2.verticalRaySpacing * (iter0 - 1) + arg0.x)
		var3.y = var4.y
		var3.z = var4.z

		local var5, var6 = Physics.Raycast(var3, var1, nil, var2, arg1.layerMask)
		local var7 = false
		local var8 = false

		if var6 then
			local var9 = var6.transform.parent

			if table.contains(arg1.ignoreLayerMask, go(var9).layer) then
				var8 = true
			end

			if var0 == 1 and not arg1.verticalTopTfs[var9] then
				arg1.verticalTopTfs[var9] = var9
			elseif var0 == -1 and not arg1.verticalBottomTfs[var9] then
				arg1.verticalBottomTfs[var9] = var9
			end
		end

		if not var8 and var5 then
			local var10 = var6

			if not var7 then
				arg0.y = (var6.distance - arg2.skinWidth) * var0
				var2 = var6.distance

				if arg1.climbingSlope then
					arg0.x = arg0.y / Mathf.Tan(arg1.slopeAngle * Mathf.Deg2Rad) * Mathf.Sign(arg0.x)
				end

				arg1.below = var0 == -1
				arg1.above = var0 == 1
			end
		end
	end
end

return var0
