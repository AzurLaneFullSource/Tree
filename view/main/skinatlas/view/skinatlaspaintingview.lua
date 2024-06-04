local var0 = class("SkinAtlasPaintingView")

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0.parentTF = arg0._tf.parent
	arg0.hideGos = {
		arg0.parentTF:Find("main/right"),
		arg0.parentTF:Find("main/left")
	}
	arg0.zoom = GetOrAddComponent(arg0.parentTF, typeof(PinchZoom))
	arg0.event = GetOrAddComponent(arg0.parentTF, typeof(EventTriggerListener))
	arg0.zoom.enabled = false
	arg0.event.enabled = false
	arg0.lpos = arg0._tf.localPosition
	arg0.scale = arg0._tf.localScale
	arg0.isEnter = false
end

function var0.IsEnter(arg0)
	return arg0.isEnter
end

function var0.Enter(arg0)
	arg0.isEnter = true

	arg0:ShowOrHideGo(false)
	arg0:EnableDragAndZoom()
end

function var0.ShowOrHideGo(arg0, arg1)
	for iter0, iter1 in pairs(arg0.hideGos) do
		setActive(iter1, arg1)
	end
end

function var0.EnableDragAndZoom(arg0)
	arg0.isEnableDrag = true

	local var0 = arg0.parentTF.gameObject
	local var1 = arg0.zoom
	local var2 = arg0.event
	local var3 = Vector3(0, 0, 0)

	var2:AddBeginDragFunc(function(arg0, arg1)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1.processing then
			return
		end

		setButtonEnabled(var0, false)

		if Input.touchCount > 1 then
			return
		end

		local var0 = var0.Screen2Local(var0.transform.parent, arg1.position)

		var3 = arg0._tf.localPosition - var0
	end)
	var2:AddDragFunc(function(arg0, arg1)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0 = var0.Screen2Local(var0.transform.parent, arg1.position)

		arg0._tf.localPosition = arg0:IslimitYPos() and Vector3(var0.x, var0.transform.localPosition.y, 0) + Vector3(var3.x, 0, 0) or Vector3(var0.x, var0.y, 0) + var3
	end)
	var2:AddDragEndFunc(function()
		setButtonEnabled(var0, true)
	end)

	if not arg0:IslimitYPos() then
		var1.enabled = true
	end

	var2.enabled = true
	Input.multiTouchEnabled = true
end

function var0.IslimitYPos(arg0)
	return false
end

function var0.Exit(arg0)
	if arg0.isEnter then
		arg0.isEnter = false

		arg0:ShowOrHideGo(true)
		arg0:DisableDragAndZoom()

		arg0._tf.localPosition = arg0.lpos
		arg0._tf.localScale = arg0.scale
	end
end

function var0.DisableDragAndZoom(arg0)
	if arg0.isEnableDrag then
		local var0 = arg0.event

		ClearEventTrigger(var0)

		var0.enabled = false
		arg0.zoom.enabled = false
		arg0.isEnableDrag = false
	end
end

function var0.Dispose(arg0)
	if arg0.isEnter then
		arg0:Exit()
	end
end

function var0.Screen2Local(arg0, arg1)
	local var0 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")
	local var2 = LuaHelper.ScreenToLocal(var1, arg1, var0)

	return Vector3(var2.x, var2.y, 0)
end

return var0
