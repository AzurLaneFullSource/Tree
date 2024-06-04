local var0 = class("CourtYardDragAgent", import(".CourtYardAgent"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1)

	arg0.rect = arg2
	arg0.trigger = GetOrAddComponent(arg0._tf, "EventTriggerListener")
	arg0.dragging = false

	arg0:RegisterEvent()
end

function var0.Enable(arg0, arg1)
	arg0.trigger.enabled = arg1
end

function var0.RegisterEvent(arg0)
	arg0.trigger:AddBeginDragFunc(function(arg0, arg1)
		if not arg0:CanDrag(arg0) then
			return
		end

		arg0.dragging = true

		arg0:OnBeginDrag()
	end)
	arg0.trigger:AddDragFunc(function(arg0, arg1)
		if arg0.dragging and arg0._go == arg0 then
			local var0 = CourtYardCalcUtil.Screen2Local(arg0.rect, arg1.position)
			local var1 = CourtYardCalcUtil.Local2Map(var0)

			arg0:OnDragging(var1)
		end
	end)
	arg0.trigger:AddDragEndFunc(function(arg0, arg1)
		if arg0.dragging and arg0 == arg0._go then
			arg0.dragging = false

			local var0 = CourtYardCalcUtil.Screen2Local(arg0.rect, arg1.position)
			local var1 = CourtYardCalcUtil.Local2Map(var0)

			arg0:OnDragEnd(var1)
		end
	end)
end

function var0.CanDrag(arg0, arg1)
	return Input.touchCount <= 1 and arg0._go == arg1
end

function var0.UnRegisterEvent(arg0)
	arg0.dragging = false

	ClearEventTrigger(arg0.trigger)
end

function var0.Dispose(arg0)
	var0.super.Dispose(arg0)
	arg0:UnRegisterEvent()
	Object.Destroy(arg0.trigger)
end

return var0
