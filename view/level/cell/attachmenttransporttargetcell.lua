local var0 = class("AttachmentTransportTargetCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("transport_target")
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_TransportTarget", "Tpl_TransportTarget", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition3D = Vector3.zero

			local var0 = LeanTween.moveY(tf(arg0), 10, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

			arg0.attachTw = var0.uniqueId

			arg0:ResetCanvasOrder()
			arg0:Update()
		end)
	end
end

function var0.RemoveTween(arg0)
	if arg0.attachTw then
		LeanTween.cancel(arg0.attachTw)
	end

	arg0.attachTw = nil
end

function var0.Clear(arg0)
	arg0:RemoveTween()
	var0.super.Clear(arg0)
end

return var0
