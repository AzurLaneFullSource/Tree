local var0_0 = class("WSDragProxy", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	transform = "userdata",
	leftExtend = "number",
	gid = "number",
	longPressTrigger = "userdata",
	topExtend = "number",
	twFocusId = "number",
	dragTrigger = "userdata",
	wsTimer = "table",
	onDragFunction = "function",
	isDraging = "boolean",
	rightExtend = "number",
	callInfo = "table",
	bottomExtend = "number"
}

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.callInfo = arg1_1
	arg0_1.dragTrigger = GetOrAddComponent(arg0_1.transform, typeof(EventTriggerListener))

	arg0_1.dragTrigger:AddBeginDragFunc(function()
		arg0_1.isDraging = true
	end)
	arg0_1.dragTrigger:AddDragEndFunc(function()
		arg0_1.isDraging = false
	end)
	arg0_1.dragTrigger:AddPointClickFunc(function(arg0_4, arg1_4)
		if not arg0_1.isDraging then
			arg0_1.callInfo.clickCall(arg0_4, arg1_4)
		end
	end)

	arg0_1.dragTrigger.enabled = true
	arg0_1.longPressTrigger = GetOrAddComponent(arg0_1.transform, typeof(UILongPressTrigger))

	local var0_1 = arg0_1.callInfo.longPressCall

	function arg0_1.callInfo.longPressCall(...)
		if arg0_1.isDraging then
			return
		end

		var0_1(...)
	end

	arg0_1.longPressTrigger.onLongPressed:AddListener(arg0_1.callInfo.longPressCall)

	arg0_1.longPressTrigger.enabled = true
end

function var0_0.Dispose(arg0_6)
	arg0_6.transform.localPosition = Vector3.zero

	if arg0_6.map then
		arg0_6.dragTrigger:RemoveDragFunc()
	end

	arg0_6.dragTrigger:RemoveBeginDragFunc()
	arg0_6.dragTrigger:RemoveDragEndFunc()
	arg0_6.dragTrigger:RemovePointClickFunc()

	arg0_6.dragTrigger.enabled = true

	arg0_6.longPressTrigger.onLongPressed:RemoveListener(arg0_6.callInfo.longPressCall)

	arg0_6.longPressTrigger.enabled = true

	arg0_6:Clear()
end

function var0_0.Focus(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7)
	local var0_7 = arg0_7.map.theme
	local var1_7 = arg0_7.transform:Find("plane")

	assert(var1_7, "plane not exist.")

	local var2_7 = arg0_7.transform.parent:InverseTransformVector(arg1_7 - var1_7.position)

	var2_7.x = var2_7.x + var1_7.localPosition.x
	var2_7.y = var2_7.y + var1_7.localPosition.y - var1_7.localPosition.z * math.tan(math.pi / 180 * var0_7.angle)
	var2_7.x = math.clamp(-var2_7.x, -arg0_7.rightExtend, arg0_7.leftExtend)
	var2_7.y = math.clamp(-var2_7.y, -arg0_7.topExtend, arg0_7.bottomExtend)
	var2_7.z = 0

	if arg0_7.twFocusId then
		arg0_7.wsTimer:RemoveInMapTween(arg0_7.twFocusId)
	end

	local var3_7 = {}

	if arg3_7 then
		table.insert(var3_7, function(arg0_8)
			if arg0_7.isDraging then
				arg0_7.isDraging = false
			end

			arg0_7.dragTrigger.enabled = false
			arg0_7.longPressTrigger.enabled = false

			if not arg2_7 then
				local var0_8 = (arg0_7.transform.localPosition - var2_7).magnitude

				arg2_7 = var0_8 > 0 and var0_8 / (40 * math.sqrt(var0_8)) or 0
			end

			arg0_7.twFocusId = LeanTween.moveLocal(arg0_7.transform.gameObject, var2_7, arg2_7):setEase(arg3_7):setOnComplete(System.Action(arg0_8)).uniqueId

			arg0_7.wsTimer:AddInMapTween(arg0_7.twFocusId)
		end)
	else
		arg0_7.transform.localPosition = var2_7
	end

	seriesAsync(var3_7, function()
		arg0_7.dragTrigger.enabled = true
		arg0_7.longPressTrigger.enabled = true

		if arg4_7 then
			arg4_7()
		end
	end)
end

function var0_0.UpdateMap(arg0_10, arg1_10)
	if arg0_10.map ~= arg1_10 or arg0_10.gid ~= arg1_10.gid then
		arg0_10.map = arg1_10
		arg0_10.gid = arg1_10.gid

		arg0_10:UpdateDrag()
	end
end

function var0_0.UpdateDrag(arg0_11)
	local var0_11, var1_11, var2_11 = getSizeRate()
	local var3_11 = arg0_11.map.theme
	local var4_11 = var2_11 * 0.5 / math.tan(math.deg2Rad * var3_11.fov * 0.5)
	local var5_11 = math.deg2Rad * var3_11.angle
	local var6_11 = Vector3(0, -math.sin(var5_11), -math.cos(var5_11))
	local var7_11 = Vector3(var3_11.offsetx, var3_11.offsety, var3_11.offsetz) + WorldConst.DefaultMapOffset
	local var8_11 = Vector3.Dot(var6_11, var7_11)
	local var9_11 = var0_11 * math.clamp((var4_11 - var8_11) / var4_11, 0, 1)

	arg0_11.leftExtend, arg0_11.rightExtend, arg0_11.topExtend, arg0_11.bottomExtend = arg0_11:GetDragExtend(var1_11, var2_11)
	arg0_11.transform.sizeDelta = Vector2(var1_11 + math.max(arg0_11.leftExtend, arg0_11.rightExtend) * 2, var2_11 + math.max(arg0_11.topExtend, arg0_11.bottomExtend) * 2)

	arg0_11.dragTrigger:RemoveDragFunc()
	arg0_11.dragTrigger:AddDragFunc(function(arg0_12, arg1_12)
		if arg0_11.onDragFunction then
			arg0_11.onDragFunction()
		end

		local var0_12 = arg0_11.transform.localPosition

		var0_12.x = math.clamp(var0_12.x + arg1_12.delta.x * var9_11.x, -arg0_11.rightExtend, arg0_11.leftExtend)
		var0_12.y = math.clamp(var0_12.y + arg1_12.delta.y * var9_11.y / math.cos(var5_11), -arg0_11.topExtend, arg0_11.bottomExtend)
		arg0_11.transform.localPosition = var0_12
	end)
end

function var0_0.GetDragExtend(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.map
	local var1_13 = var0_13.theme
	local var2_13 = arg0_13.transform:Find("plane")

	assert(var2_13, "plane not exist.")

	local var3_13 = var2_13.localPosition.x
	local var4_13 = var2_13.localPosition.y - var2_13.localPosition.z * math.tan(math.pi / 180 * var1_13.angle)
	local var5_13 = 99999999
	local var6_13 = 0
	local var7_13 = 0

	for iter0_13, iter1_13 in pairs(var0_13.cells) do
		if var5_13 > iter1_13.row then
			var5_13 = iter1_13.row
		end

		if var6_13 < iter1_13.row then
			var6_13 = iter1_13.row
		end

		if var7_13 < iter1_13.column then
			var7_13 = iter1_13.column
		end
	end

	local var8_13 = var0_13.theme.cellSize + var0_13.theme.cellSpace
	local var9_13 = math.max(var7_13 * var8_13.x - arg1_13 * 0.5, 0)
	local var10_13 = math.max((WorldConst.MaxRow * 0.5 - var5_13) * var8_13.y, 0)
	local var11_13 = math.max((var6_13 - WorldConst.MaxRow * 0.5) * var8_13.y, 0)

	return 1000 - var3_13, var9_13 + var3_13, var10_13 + var4_13, var11_13 - var4_13
end

function var0_0.ShakePlane(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14, arg5_14)
	arg2_14 = math.clamp(arg2_14, 0, 90)
	arg3_14 = math.max(arg3_14, 1)
	arg4_14 = math.max(arg4_14, 1)

	local var0_14 = math.pi / 180 * arg2_14
	local var1_14 = Vector3(math.cos(var0_14), math.sin(var0_14), 0) * arg1_14
	local var2_14 = arg0_14.transform.anchoredPosition3D
	local var3_14 = var2_14 + var1_14
	local var4_14 = var2_14 - var1_14
	local var5_14 = 0.0333
	local var6_14 = var5_14 * arg3_14 * 0.5
	local var7_14 = var5_14 * arg3_14
	local var8_14 = var5_14 * arg3_14 * 0.5

	arg0_14.dragTrigger.enabled = false
	arg0_14.longPressTrigger.enabled = false

	local var9_14 = LeanTween.moveLocal(arg0_14.transform.gameObject, var3_14, var6_14)
	local var10_14 = LeanTween.moveLocal(arg0_14.transform.gameObject, var4_14, var7_14):setDelay(var6_14):setLoopPingPong(arg4_14)
	local var11_14 = LeanTween.moveLocal(arg0_14.transform.gameObject, var2_14, var8_14):setDelay(var6_14 + var7_14 * arg4_14 * 2):setOnComplete(System.Action(function()
		arg0_14.dragTrigger.enabled = true
		arg0_14.longPressTrigger.enabled = true

		arg5_14()
	end))

	arg0_14.wsTimer:AddInMapTween(var9_14.uniqueId)
	arg0_14.wsTimer:AddInMapTween(var10_14.uniqueId)
	arg0_14.wsTimer:AddInMapTween(var11_14.uniqueId)
end

return var0_0
