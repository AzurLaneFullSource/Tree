local var0_0 = class("SkinAtlasPaintingView")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.parentTF = arg0_1._tf.parent
	arg0_1.hideGos = {
		arg0_1.parentTF:Find("main/right"),
		arg0_1.parentTF:Find("main/left")
	}
	arg0_1.zoom = GetOrAddComponent(arg0_1.parentTF, typeof(PinchZoom))
	arg0_1.event = GetOrAddComponent(arg0_1.parentTF, typeof(EventTriggerListener))
	arg0_1.zoom.enabled = false
	arg0_1.event.enabled = false
	arg0_1.lpos = arg0_1._tf.localPosition
	arg0_1.scale = arg0_1._tf.localScale
	arg0_1.isEnter = false
end

function var0_0.IsEnter(arg0_2)
	return arg0_2.isEnter
end

function var0_0.Enter(arg0_3)
	arg0_3.isEnter = true

	arg0_3:ShowOrHideGo(false)
	arg0_3:EnableDragAndZoom()
end

function var0_0.ShowOrHideGo(arg0_4, arg1_4)
	for iter0_4, iter1_4 in pairs(arg0_4.hideGos) do
		setActive(iter1_4, arg1_4)
	end
end

function var0_0.EnableDragAndZoom(arg0_5)
	arg0_5.isEnableDrag = true

	local var0_5 = arg0_5.parentTF.gameObject
	local var1_5 = arg0_5.zoom
	local var2_5 = arg0_5.event
	local var3_5 = Vector3(0, 0, 0)

	var2_5:AddBeginDragFunc(function(arg0_6, arg1_6)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_5.processing then
			return
		end

		setButtonEnabled(var0_5, false)

		if Input.touchCount > 1 then
			return
		end

		local var0_6 = var0_0.Screen2Local(var0_5.transform.parent, arg1_6.position)

		var3_5 = arg0_5._tf.localPosition - var0_6
	end)
	var2_5:AddDragFunc(function(arg0_7, arg1_7)
		if Application.isEditor and Input.GetMouseButton(2) then
			return
		end

		if var1_5.processing then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		local var0_7 = var0_0.Screen2Local(var0_5.transform.parent, arg1_7.position)

		arg0_5._tf.localPosition = arg0_5:IslimitYPos() and Vector3(var0_7.x, var0_5.transform.localPosition.y, 0) + Vector3(var3_5.x, 0, 0) or Vector3(var0_7.x, var0_7.y, 0) + var3_5
	end)
	var2_5:AddDragEndFunc(function()
		setButtonEnabled(var0_5, true)
	end)

	if not arg0_5:IslimitYPos() then
		var1_5.enabled = true
	end

	var2_5.enabled = true
	Input.multiTouchEnabled = true
end

function var0_0.IslimitYPos(arg0_9)
	return false
end

function var0_0.Exit(arg0_10)
	if arg0_10.isEnter then
		arg0_10.isEnter = false

		arg0_10:ShowOrHideGo(true)
		arg0_10:DisableDragAndZoom()

		arg0_10._tf.localPosition = arg0_10.lpos
		arg0_10._tf.localScale = arg0_10.scale
	end
end

function var0_0.DisableDragAndZoom(arg0_11)
	if arg0_11.isEnableDrag then
		local var0_11 = arg0_11.event

		ClearEventTrigger(var0_11)

		var0_11.enabled = false
		arg0_11.zoom.enabled = false
		arg0_11.isEnableDrag = false
	end
end

function var0_0.Dispose(arg0_12)
	if arg0_12.isEnter then
		arg0_12:Exit()
	end
end

function var0_0.Screen2Local(arg0_13, arg1_13)
	local var0_13 = GameObject.Find("UICamera"):GetComponent("Camera")
	local var1_13 = arg0_13:GetComponent("RectTransform")
	local var2_13 = LuaHelper.ScreenToLocal(var1_13, arg1_13, var0_13)

	return Vector3(var2_13.x, var2_13.y, 0)
end

return var0_0
