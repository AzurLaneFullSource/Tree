local var0_0 = class("AttachmentTransportTargetCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("transport_target")
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_TransportTarget", "Tpl_TransportTarget", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition3D = Vector3.zero

			local var0_3 = LeanTween.moveY(tf(arg0_3), 10, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

			arg0_2.attachTw = var0_3.uniqueId

			arg0_2:ResetCanvasOrder()
			arg0_2:Update()
		end)
	end
end

function var0_0.RemoveTween(arg0_4)
	if arg0_4.attachTw then
		LeanTween.cancel(arg0_4.attachTw)
	end

	arg0_4.attachTw = nil
end

function var0_0.Clear(arg0_5)
	arg0_5:RemoveTween()
	var0_0.super.Clear(arg0_5)
end

return var0_0
