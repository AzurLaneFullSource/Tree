local var0 = class("MapEventStoryCellView", import("view.level.cell.StaticCellView"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.attachTw = nil
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		local var1 = var0.row
		local var2 = var0.column
		local var3 = var0.data
		local var4 = pg.map_event_template[var0.attachmentId].icon
		local var5 = "story_" .. var1 .. "_" .. var2 .. "_" .. var0.attachmentId

		arg0:PrepareBase(var5)
		setAnchoredPosition(arg0.tf, Vector2(0, 30))

		arg0.attachTw = LeanTween.moveY(rtf(arg0.go), 40, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		arg0:GetLoader():GetPrefab("leveluiview/tpl_box", "tpl_box", function(arg0)
			arg0.name = var4

			setParent(arg0, arg0.tf)
			setAnchoredPosition(arg0, Vector2.zero)
			arg0:GetLoader():GetPrefab("boxprefab/" .. var4, var4, function(arg0)
				setParent(arg0, tf(arg0):Find("icon"))
			end)
		end)
	end

	local var6 = var0.flag == ChapterConst.CellFlagActive

	setActive(arg0.tf, var6)
end

function var0.DestroyGO(arg0)
	if arg0.attachTw then
		LeanTween.cancel(arg0.attachTw.uniqueId)

		arg0.attachTw = nil
	end

	var0.super.DestroyGO(arg0)
end

return var0
