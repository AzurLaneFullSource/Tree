local var0_0 = class("AttachmentLBHarborCell", import("view.level.cell.StaticCellView"))

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("box_gangkou")
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_Box", "Tpl_Box", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition3D = Vector3(0, 30, 0)

			arg0_2:GetLoader():GetPrefab("boxprefab/gangkou", "gangkou", function(arg0_4)
				tf(arg0_4):SetParent(tf(arg0_3):Find("icon"), false)
			end)

			arg0_2.box = arg0_3

			arg0_2:Update()
		end)
	end

	if arg0_2.box then
		setActive(findTF(arg0_2.box, "effect_found"), var0_2.trait == ChapterConst.TraitVirgin)

		if var0_2.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end

	setActive(arg0_2.tf, var0_2.flag == ChapterConst.CellFlagActive)
end

return var0_0
