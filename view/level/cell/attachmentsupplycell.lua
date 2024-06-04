local var0 = class("AttachmentSupplyCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("supply")
		arg0:GetLoader():GetPrefab("leveluiview/tpl_supply", "Tpl_Supply", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition3D = Vector3(0, 30, 0)

			local var0 = LeanTween.moveY(tf(arg0), 40, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

			arg0.attachTw = var0.uniqueId
			arg0.supply = arg0

			arg0:Update()
		end)
	end

	if arg0.supply then
		setActive(findTF(arg0.supply, "normal"), var0.attachmentId > 0)
		setActive(findTF(arg0.supply, "empty"), false)
	end

	setActive(arg0.tf, var0.flag == ChapterConst.CellFlagActive)
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
