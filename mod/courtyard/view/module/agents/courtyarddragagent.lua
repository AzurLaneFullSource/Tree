local var0_0 = class("CourtYardDragAgent", import(".CourtYardAgent"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.rect = arg2_1
	arg0_1.trigger = GetOrAddComponent(arg0_1._tf, "EventTriggerListener")
	arg0_1.dragging = false

	arg0_1:RegisterEvent()
end

function var0_0.Enable(arg0_2, arg1_2)
	arg0_2.trigger.enabled = arg1_2
end

function var0_0.RegisterEvent(arg0_3)
	arg0_3.trigger:AddBeginDragFunc(function(arg0_4, arg1_4)
		if not arg0_3:CanDrag(arg0_4) then
			return
		end

		arg0_3.dragging = true

		arg0_3:OnBeginDrag()
	end)
	arg0_3.trigger:AddDragFunc(function(arg0_5, arg1_5)
		if arg0_3.dragging and arg0_3._go == arg0_5 then
			local var0_5 = CourtYardCalcUtil.Screen2Local(arg0_3.rect, arg1_5.position)
			local var1_5 = CourtYardCalcUtil.Local2Map(var0_5)

			arg0_3:OnDragging(var1_5)
		end
	end)
	arg0_3.trigger:AddDragEndFunc(function(arg0_6, arg1_6)
		if arg0_3.dragging and arg0_6 == arg0_3._go then
			arg0_3.dragging = false

			local var0_6 = CourtYardCalcUtil.Screen2Local(arg0_3.rect, arg1_6.position)
			local var1_6 = CourtYardCalcUtil.Local2Map(var0_6)

			arg0_3:OnDragEnd(var1_6)
		end
	end)
end

function var0_0.CanDrag(arg0_7, arg1_7)
	return Input.touchCount <= 1 and arg0_7._go == arg1_7
end

function var0_0.UnRegisterEvent(arg0_8)
	arg0_8.dragging = false

	ClearEventTrigger(arg0_8.trigger)
end

function var0_0.Dispose(arg0_9)
	var0_0.super.Dispose(arg0_9)
	arg0_9:UnRegisterEvent()
	Object.Destroy(arg0_9.trigger)
end

return var0_0
