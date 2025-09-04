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

function var0_0.GetPointOffset(arg0_6, arg1_6, arg2_6)
	if arg2_6 % 2 == 0 then
		return arg0_6 + Vector3(arg1_6 * 2, 0, 0) * math.ceil(arg2_6 * 0.5)
	else
		return arg0_6 - Vector3(arg1_6 * 2, 0, 0) * math.ceil(arg2_6 * 0.5)
	end
end

function var0_0.GetTypeAndIdByUniqueId(arg0_7)
	local var0_7 = WorldObjectItem.GetTypeAndIdByUniqueId(arg0_7)

	return var0_7[0], var0_7[1]
end

function var0_0.GetUnReHexPoints(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8 * 0.5
	local var1_8 = arg1_8 * 0.5
	local var2_8 = {}
	local var3_8 = arg2_8 * math.pi / 180
	local var4_8 = arg0_8 * math.tan(var3_8) * 0.5

	table.insert(var2_8, Vector2(0, var1_8))
	table.insert(var2_8, Vector2(var0_8, var4_8))
	table.insert(var2_8, Vector2(var0_8, -var4_8))
	table.insert(var2_8, Vector2(0, -var1_8))
	table.insert(var2_8, Vector2(-var0_8, -var4_8))
	table.insert(var2_8, Vector2(-var0_8, var4_8))

	return var2_8
end

function var0_0.Vetor3Table2Array(arg0_9)
	local var0_9 = System.Array.CreateInstance(typeof(UnityEngine.Vector3), #arg0_9)

	for iter0_9, iter1_9 in ipairs(arg0_9) do
		var0_9[iter0_9 - 1] = iter1_9
	end

	return var0_9
end

function var0_0.ClampRect(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	local var0_10 = arg0_10 * 0.5 - arg2_10 * 0.5
	local var1_10 = arg1_10 * 0.5 - arg3_10 * 0.5

	if var0_10 < arg4_10.x then
		arg4_10.x = var0_10
	elseif arg4_10.x < -var0_10 then
		arg4_10.x = -var0_10
	end

	if var1_10 < arg4_10.y then
		arg4_10.y = var1_10
	elseif arg4_10.y < -var1_10 then
		arg4_10.y = -var1_10
	end

	return arg4_10
end

function var0_0.IsBehindCamera(arg0_11)
	local var0_11 = IslandCameraMgr.instance._mainCamera

	return Vector3.Dot(var0_11.transform.forward, arg0_11 - var0_11.transform.position) < 0
end

return var0_0
