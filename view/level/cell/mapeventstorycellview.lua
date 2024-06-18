local var0_0 = class("MapEventStoryCellView", import("view.level.cell.StaticCellView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.attachTw = nil
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_3)
	local var0_3 = arg0_3.info

	if IsNil(arg0_3.go) then
		local var1_3 = var0_3.row
		local var2_3 = var0_3.column
		local var3_3 = var0_3.data
		local var4_3 = pg.map_event_template[var0_3.attachmentId].icon
		local var5_3 = "story_" .. var1_3 .. "_" .. var2_3 .. "_" .. var0_3.attachmentId

		arg0_3:PrepareBase(var5_3)
		setAnchoredPosition(arg0_3.tf, Vector2(0, 30))

		arg0_3.attachTw = LeanTween.moveY(rtf(arg0_3.go), 40, 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

		arg0_3:GetLoader():GetPrefab("leveluiview/tpl_box", "tpl_box", function(arg0_4)
			arg0_4.name = var4_3

			setParent(arg0_4, arg0_3.tf)
			setAnchoredPosition(arg0_4, Vector2.zero)
			arg0_3:GetLoader():GetPrefab("boxprefab/" .. var4_3, var4_3, function(arg0_5)
				setParent(arg0_5, tf(arg0_4):Find("icon"))
			end)
		end)
	end

	local var6_3 = var0_3.flag == ChapterConst.CellFlagActive

	setActive(arg0_3.tf, var6_3)
end

function var0_0.DestroyGO(arg0_6)
	if arg0_6.attachTw then
		LeanTween.cancel(arg0_6.attachTw.uniqueId)

		arg0_6.attachTw = nil
	end

	var0_0.super.DestroyGO(arg0_6)
end

return var0_0
