local var0_0 = class("AttachmentBoxCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		local var1_2 = pg.box_data_template[var0_2.attachmentId]

		assert(var1_2, "box_data_template not exist: " .. var0_2.attachmentId)

		local var2_2 = "box_" .. var0_2.attachmentId

		arg0_2:PrepareBase(var2_2)

		local var3_2
		local var4_2

		parallelAsync({
			function(arg0_3)
				arg0_2:GetLoader():GetPrefab("boxprefab/" .. var1_2.icon, var1_2.icon, function(arg0_4)
					var4_2 = arg0_4

					arg0_3()
				end)
			end,
			function(arg0_5)
				arg0_2:GetLoader():GetPrefab("leveluiview/tpl_box", "tpl_box", function(arg0_6)
					var3_2 = arg0_6

					setParent(tf(var3_2), arg0_2.tf)

					tf(var3_2).anchoredPosition3D = Vector3(0, 30, 0)

					if var1_2.type ~= ChapterConst.BoxTorpedo then
						local var0_6 = LeanTween.move(tf(var3_2), Vector3(0, 40, 0), 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

						arg0_2.attachTw = var0_6.uniqueId
					end

					arg0_2.box = var3_2

					arg0_5()
				end)
			end
		}, function()
			setParent(var4_2, tf(var3_2):Find("icon"))
			arg0_2:ResetCanvasOrder()
			arg0_2:Update()
		end)
	end

	if arg0_2.box and var0_2.flag == ChapterConst.CellFlagActive then
		setActive(findTF(arg0_2.box, "effect_found"), var0_2.trait == ChapterConst.TraitVirgin)

		if var0_2.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end

	setActive(arg0_2.tf, var0_2.flag == ChapterConst.CellFlagActive)
end

function var0_0.RemoveTween(arg0_8)
	if arg0_8.attachTw then
		LeanTween.cancel(arg0_8.attachTw)
	end

	arg0_8.attachTw = nil
end

function var0_0.Clear(arg0_9)
	arg0_9:RemoveTween()
	var0_0.super.Clear(arg0_9)
end

return var0_0
