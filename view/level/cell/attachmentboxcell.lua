local var0 = class("AttachmentBoxCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		local var1 = pg.box_data_template[var0.attachmentId]

		assert(var1, "box_data_template not exist: " .. var0.attachmentId)

		local var2 = "box_" .. var0.attachmentId

		arg0:PrepareBase(var2)

		local var3
		local var4

		parallelAsync({
			function(arg0)
				arg0:GetLoader():GetPrefab("boxprefab/" .. var1.icon, var1.icon, function(arg0)
					var4 = arg0

					arg0()
				end)
			end,
			function(arg0)
				arg0:GetLoader():GetPrefab("leveluiview/tpl_box", "tpl_box", function(arg0)
					var3 = arg0

					setParent(tf(var3), arg0.tf)

					tf(var3).anchoredPosition3D = Vector3(0, 30, 0)

					if var1.type ~= ChapterConst.BoxTorpedo then
						local var0 = LeanTween.move(tf(var3), Vector3(0, 40, 0), 1.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

						arg0.attachTw = var0.uniqueId
					end

					arg0.box = var3

					arg0()
				end)
			end
		}, function()
			setParent(var4, tf(var3):Find("icon"))
			arg0:ResetCanvasOrder()
			arg0:Update()
		end)
	end

	if arg0.box and var0.flag == ChapterConst.CellFlagActive then
		setActive(findTF(arg0.box, "effect_found"), var0.trait == ChapterConst.TraitVirgin)

		if var0.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
		end
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
