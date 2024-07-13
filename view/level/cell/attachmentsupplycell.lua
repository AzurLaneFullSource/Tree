local var0_0 = class("AttachmentSupplyCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("supply")
		arg0_2:GetLoader():GetPrefab("leveluiview/tpl_supply", "Tpl_Supply", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition3D = Vector3(0, 30, 0)

			local var0_3 = LeanTween.moveY(tf(arg0_3), 40, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

			arg0_2.attachTw = var0_3.uniqueId
			arg0_2.supply = arg0_3

			arg0_2:Update()
		end)
	end

	if arg0_2.supply then
		setActive(findTF(arg0_2.supply, "normal"), var0_2.attachmentId > 0)
		setActive(findTF(arg0_2.supply, "empty"), false)
	end

	setActive(arg0_2.tf, var0_2.flag == ChapterConst.CellFlagActive)
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
