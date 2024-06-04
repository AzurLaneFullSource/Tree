local var0 = class("WSDragProxy", import("...BaseEntity"))

var0.Fields = {
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

function var0.Setup(arg0, arg1)
	arg0.callInfo = arg1
	arg0.dragTrigger = GetOrAddComponent(arg0.transform, typeof(EventTriggerListener))

	arg0.dragTrigger:AddBeginDragFunc(function()
		arg0.isDraging = true
	end)
	arg0.dragTrigger:AddDragEndFunc(function()
		arg0.isDraging = false
	end)
	arg0.dragTrigger:AddPointClickFunc(function(arg0, arg1)
		if not arg0.isDraging then
			arg0.callInfo.clickCall(arg0, arg1)
		end
	end)

	arg0.dragTrigger.enabled = true
	arg0.longPressTrigger = GetOrAddComponent(arg0.transform, typeof(UILongPressTrigger))

	local var0 = arg0.callInfo.longPressCall

	function arg0.callInfo.longPressCall(...)
		if arg0.isDraging then
			return
		end

		var0(...)
	end

	arg0.longPressTrigger.onLongPressed:AddListener(arg0.callInfo.longPressCall)

	arg0.longPressTrigger.enabled = true
end

function var0.Dispose(arg0)
	arg0.transform.localPosition = Vector3.zero

	if arg0.map then
		arg0.dragTrigger:RemoveDragFunc()
	end

	arg0.dragTrigger:RemoveBeginDragFunc()
	arg0.dragTrigger:RemoveDragEndFunc()
	arg0.dragTrigger:RemovePointClickFunc()

	arg0.dragTrigger.enabled = true

	arg0.longPressTrigger.onLongPressed:RemoveListener(arg0.callInfo.longPressCall)

	arg0.longPressTrigger.enabled = true

	arg0:Clear()
end

function var0.Focus(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.map.theme
	local var1 = arg0.transform:Find("plane")

	assert(var1, "plane not exist.")

	local var2 = arg0.transform.parent:InverseTransformVector(arg1 - var1.position)

	var2.x = var2.x + var1.localPosition.x
	var2.y = var2.y + var1.localPosition.y - var1.localPosition.z * math.tan(math.pi / 180 * var0.angle)
	var2.x = math.clamp(-var2.x, -arg0.rightExtend, arg0.leftExtend)
	var2.y = math.clamp(-var2.y, -arg0.topExtend, arg0.bottomExtend)
	var2.z = 0

	if arg0.twFocusId then
		arg0.wsTimer:RemoveInMapTween(arg0.twFocusId)
	end

	local var3 = {}

	if arg3 then
		table.insert(var3, function(arg0)
			if arg0.isDraging then
				arg0.isDraging = false
			end

			arg0.dragTrigger.enabled = false
			arg0.longPressTrigger.enabled = false

			if not arg2 then
				local var0 = (arg0.transform.localPosition - var2).magnitude

				arg2 = var0 > 0 and var0 / (40 * math.sqrt(var0)) or 0
			end

			arg0.twFocusId = LeanTween.moveLocal(arg0.transform.gameObject, var2, arg2):setEase(arg3):setOnComplete(System.Action(arg0)).uniqueId

			arg0.wsTimer:AddInMapTween(arg0.twFocusId)
		end)
	else
		arg0.transform.localPosition = var2
	end

	seriesAsync(var3, function()
		arg0.dragTrigger.enabled = true
		arg0.longPressTrigger.enabled = true

		if arg4 then
			arg4()
		end
	end)
end

function var0.UpdateMap(arg0, arg1)
	if arg0.map ~= arg1 or arg0.gid ~= arg1.gid then
		arg0.map = arg1
		arg0.gid = arg1.gid

		arg0:UpdateDrag()
	end
end

function var0.UpdateDrag(arg0)
	local var0, var1, var2 = getSizeRate()
	local var3 = arg0.map.theme
	local var4 = var2 * 0.5 / math.tan(math.deg2Rad * var3.fov * 0.5)
	local var5 = math.deg2Rad * var3.angle
	local var6 = Vector3(0, -math.sin(var5), -math.cos(var5))
	local var7 = Vector3(var3.offsetx, var3.offsety, var3.offsetz) + WorldConst.DefaultMapOffset
	local var8 = Vector3.Dot(var6, var7)
	local var9 = var0 * math.clamp((var4 - var8) / var4, 0, 1)

	arg0.leftExtend, arg0.rightExtend, arg0.topExtend, arg0.bottomExtend = arg0:GetDragExtend(var1, var2)
	arg0.transform.sizeDelta = Vector2(var1 + math.max(arg0.leftExtend, arg0.rightExtend) * 2, var2 + math.max(arg0.topExtend, arg0.bottomExtend) * 2)

	arg0.dragTrigger:RemoveDragFunc()
	arg0.dragTrigger:AddDragFunc(function(arg0, arg1)
		if arg0.onDragFunction then
			arg0.onDragFunction()
		end

		local var0 = arg0.transform.localPosition

		var0.x = math.clamp(var0.x + arg1.delta.x * var9.x, -arg0.rightExtend, arg0.leftExtend)
		var0.y = math.clamp(var0.y + arg1.delta.y * var9.y / math.cos(var5), -arg0.topExtend, arg0.bottomExtend)
		arg0.transform.localPosition = var0
	end)
end

function var0.GetDragExtend(arg0, arg1, arg2)
	local var0 = arg0.map
	local var1 = var0.theme
	local var2 = arg0.transform:Find("plane")

	assert(var2, "plane not exist.")

	local var3 = var2.localPosition.x
	local var4 = var2.localPosition.y - var2.localPosition.z * math.tan(math.pi / 180 * var1.angle)
	local var5 = 99999999
	local var6 = 0
	local var7 = 0

	for iter0, iter1 in pairs(var0.cells) do
		if var5 > iter1.row then
			var5 = iter1.row
		end

		if var6 < iter1.row then
			var6 = iter1.row
		end

		if var7 < iter1.column then
			var7 = iter1.column
		end
	end

	local var8 = var0.theme.cellSize + var0.theme.cellSpace
	local var9 = math.max(var7 * var8.x - arg1 * 0.5, 0)
	local var10 = math.max((WorldConst.MaxRow * 0.5 - var5) * var8.y, 0)
	local var11 = math.max((var6 - WorldConst.MaxRow * 0.5) * var8.y, 0)

	return 1000 - var3, var9 + var3, var10 + var4, var11 - var4
end

function var0.ShakePlane(arg0, arg1, arg2, arg3, arg4, arg5)
	arg2 = math.clamp(arg2, 0, 90)
	arg3 = math.max(arg3, 1)
	arg4 = math.max(arg4, 1)

	local var0 = math.pi / 180 * arg2
	local var1 = Vector3(math.cos(var0), math.sin(var0), 0) * arg1
	local var2 = arg0.transform.anchoredPosition3D
	local var3 = var2 + var1
	local var4 = var2 - var1
	local var5 = 0.0333
	local var6 = var5 * arg3 * 0.5
	local var7 = var5 * arg3
	local var8 = var5 * arg3 * 0.5

	arg0.dragTrigger.enabled = false
	arg0.longPressTrigger.enabled = false

	local var9 = LeanTween.moveLocal(arg0.transform.gameObject, var3, var6)
	local var10 = LeanTween.moveLocal(arg0.transform.gameObject, var4, var7):setDelay(var6):setLoopPingPong(arg4)
	local var11 = LeanTween.moveLocal(arg0.transform.gameObject, var2, var8):setDelay(var6 + var7 * arg4 * 2):setOnComplete(System.Action(function()
		arg0.dragTrigger.enabled = true
		arg0.longPressTrigger.enabled = true

		arg5()
	end))

	arg0.wsTimer:AddInMapTween(var9.uniqueId)
	arg0.wsTimer:AddInMapTween(var10.uniqueId)
	arg0.wsTimer:AddInMapTween(var11.uniqueId)
end

return var0
