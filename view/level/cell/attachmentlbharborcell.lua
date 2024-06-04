local var0 = class("AttachmentLBHarborCell", import("view.level.cell.StaticCellView"))

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("box_gangkou")
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Box", "Tpl_Box", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition3D = Vector3(0, 30, 0)

			arg0:GetLoader():GetPrefab("boxprefab/gangkou", "gangkou", function(arg0)
				tf(arg0):SetParent(tf(arg0):Find("icon"), false)
			end)

			arg0.box = arg0

			arg0:Update()
		end)
	end

	if arg0.box then
		setActive(findTF(arg0.box, "effect_found"), var0.trait == ChapterConst.TraitVirgin)

		if var0.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end

	setActive(arg0.tf, var0.flag == ChapterConst.CellFlagActive)
end

return var0
