local var0_0 = class("IslandCalcUtil")

function var0_0.SignedAngle(arg0_1, arg1_1)
	local var0_1 = Vector2.Angle(arg0_1, arg1_1)
	local var1_1 = arg0_1.x * arg1_1.y - arg0_1.y * arg1_1.x
	local var2_1 = var0_1 * math.sign(var1_1)

	if var2_1 == -0 then
		var2_1 = 180
	end

	return var2_1
end

function var0_0.WorldPosition2LocalPosition(arg0_2, arg1_2)
	local var0_2 = pg.UIMgr.GetInstance().overlayCameraComp
	local var1_2 = IslandCameraMgr.instance._mainCamera:WorldToViewportPoint(arg1_2)
	local var2_2 = var0_2:ViewportToScreenPoint(var1_2)
	local var3_2 = arg0_2:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var3_2, var2_2, var0_2))
end

function var0_0.IsInViewport(arg0_3)
	local var0_3 = IslandCameraMgr.instance._mainCamera:WorldToViewportPoint(arg0_3)

	if var0_3.x > 0 and var0_3.x < 1 and var0_3.y > 0 and var0_3.y < 1 and var0_3.z > 0 then
		return true
	end

	return false
end

function var0_0.GetNavPath(arg0_4, arg1_4)
	local var0_4 = GetOrAddComponent(arg0_4, typeof(UnityEngine.AI.NavMeshAgent))

	var0_4.nextPosition = arg0_4.transform.position

	local var1_4 = UnityEngine.AI.NavMeshPath.New()

	var0_4:CalculatePath(arg1_4, var1_4)

	return (var1_4.corners:ToTable())
end

function var0_0.GetRandomPointOnCircle(arg0_5, arg1_5)
	local var0_5 = UnityEngine.Random.insideUnitCircle.normalized

	return arg0_5 + Vector3(var0_5.x, 0, var0_5.y) * arg1_5
end

function var0_0.GetRandomPointInSector(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	arg4_6 = arg4_6 or 0.7

	local var0_6 = Vector3.New(arg1_6.x, 0, arg1_6.z)

	if var0_6.magnitude < 0.01 then
		var0_6 = Vector3.New(1, 0, 0)
	else
		var0_6 = var0_6.normalized
	end

	local var1_6 = math.atan2(var0_6.z, var0_6.x)
	local var2_6 = arg3_6 * 0.5
	local var3_6 = -var2_6 + UnityEngine.Random.value * (2 * var2_6)
	local var4_6 = var1_6 + math.rad(var3_6)
	local var5_6 = arg2_6 * arg4_6
	local var6_6 = var5_6 + UnityEngine.Random.value * (arg2_6 - var5_6)

	return arg0_6 + Vector3.New(math.cos(var4_6), 0, math.sin(var4_6)) * var6_6
end

function var0_0.GetPointOffset(arg0_7, arg1_7, arg2_7)
	if arg2_7 % 2 == 0 then
		return arg0_7 + Vector3(arg1_7 * 2, 0, 0) * math.ceil(arg2_7 * 0.5)
	else
		return arg0_7 - Vector3(arg1_7 * 2, 0, 0) * math.ceil(arg2_7 * 0.5)
	end
end

function var0_0.GetTypeAndIdByUniqueId(arg0_8)
	local var0_8 = WorldObjectItem.GetTypeAndIdByUniqueId(arg0_8)

	return var0_8[0], var0_8[1]
end

function var0_0.GetUnReHexPoints(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9 * 0.5
	local var1_9 = arg1_9 * 0.5
	local var2_9 = {}
	local var3_9 = arg2_9 * math.pi / 180
	local var4_9 = arg0_9 * math.tan(var3_9) * 0.5

	table.insert(var2_9, Vector2(0, var1_9))
	table.insert(var2_9, Vector2(-var0_9, var4_9))
	table.insert(var2_9, Vector2(-var0_9, -var4_9))
	table.insert(var2_9, Vector2(0, -var1_9))
	table.insert(var2_9, Vector2(var0_9, -var4_9))
	table.insert(var2_9, Vector2(var0_9, var4_9))

	return var2_9
end

function var0_0.Vetor3Table2Array(arg0_10)
	local var0_10 = System.Array.CreateInstance(typeof(UnityEngine.Vector3), #arg0_10)

	for iter0_10, iter1_10 in ipairs(arg0_10) do
		var0_10[iter0_10 - 1] = iter1_10
	end

	return var0_10
end

function var0_0.ClampRect(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	local var0_11 = arg0_11 * 0.5 - arg2_11 * 0.5
	local var1_11 = arg1_11 * 0.5 - arg3_11 * 0.5

	if var0_11 < arg4_11.x then
		arg4_11.x = var0_11
	elseif arg4_11.x < -var0_11 then
		arg4_11.x = -var0_11
	end

	if var1_11 < arg4_11.y then
		arg4_11.y = var1_11
	elseif arg4_11.y < -var1_11 then
		arg4_11.y = -var1_11
	end

	return arg4_11
end

function var0_0.IsBehindCamera(arg0_12)
	local var0_12 = IslandCameraMgr.instance._mainCamera.transform.forward

	return Vector3.Dot(var0_12, arg0_12) > 0
end

function var0_0.GetSurroundPoints(arg0_13)
	local var0_13 = {}

	table.insert(var0_13, arg0_13)
	table.insert(var0_13, Vector3(arg0_13.x * -1, arg0_13.y, arg0_13.z * -1))
	table.insert(var0_13, Vector3(arg0_13.x, arg0_13.y, arg0_13.z * -1))
	table.insert(var0_13, Vector3(arg0_13.x * -1, arg0_13.y, arg0_13.z))

	return var0_13
end

function var0_0.GetRandomSurroundPoints(arg0_14)
	local var0_14 = Vector2(arg0_14.x, arg0_14.z).magnitude
	local var1_14 = math.Random(1, 360)
	local var2_14 = Vector2(Mathf.Cos(var1_14) * var0_14, Mathf.Sin(var1_14) * var0_14)

	return Vector3(var2_14.x, arg0_14.y, var2_14.y)
end

function var0_0.IsHappen(arg0_15)
	return arg0_15 >= math.random(0, 100)
end

function var0_0.IsCircleInsideNavMesh(arg0_16, arg1_16, arg2_16, arg3_16)
	return #IslandHelper.CircleInsideNavMesh(arg0_16, arg1_16, arg2_16, arg3_16):ToTable() > 0
end

function var0_0.GetCanReachPoints(arg0_17, arg1_17, arg2_17, arg3_17, arg4_17)
	local var0_17 = IslandHelper.CircleInsideNavMesh(arg2_17, arg3_17, arg1_17, arg4_17):ToTable()
	local var1_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if IslandHelper.CanReachPoint(arg0_17, iter1_17) then
			table.insert(var1_17, iter1_17)
		end
	end

	return var1_17
end

function var0_0.GetCanReachOptPoint(arg0_18, arg1_18, arg2_18, arg3_18, arg4_18, arg5_18)
	local var0_18 = var0_0.GetCanReachPoints(arg0_18, arg1_18, arg2_18, arg3_18, arg5_18)

	if #var0_18 <= 0 then
		return nil
	end

	table.sort(var0_18, function(arg0_19, arg1_19)
		return Vector3.Distance(arg0_19, arg4_18) < Vector3.Distance(arg1_19, arg4_18)
	end)

	return var0_18[1]
end

function var0_0.CanReachPoint(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	return #var0_0.GetCanReachPoints(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20) > 0
end

function var0_0.RotationOffset(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg1_21 - arg0_21

	var0_21.y = 0

	local var1_21 = Vector3.Normalize(var0_21)
	local var2_21 = arg2_21 - arg0_21

	var2_21.y = 0

	local var3_21 = Vector3.Normalize(var2_21)
	local var4_21 = Quaternion.FromToRotation(var1_21, var3_21).eulerAngles

	return (Quaternion.Euler(0, var4_21.y, 0))
end

return var0_0
