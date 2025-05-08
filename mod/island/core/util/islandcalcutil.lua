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
	local var1_5 = arg0_5 + Vector3(var0_5.x, 0, var0_5.y) * arg1_5

	print(var1_5)

	return var1_5
end

return var0_0
