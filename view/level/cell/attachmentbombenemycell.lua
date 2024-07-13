local var0_0 = class("AttachmentBombEnemyCell", import("view.level.cell.StaticCellView"))

var0_0.StateLive = 1
var0_0.StateDead = 2

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("bomb_enemy_" .. var0_2.attachmentId)
	end

	local var1_2 = arg0_2.state

	if var0_2.flag == ChapterConst.CellFlagActive and arg0_2.state ~= var0_0.StateLive then
		arg0_2.state = var0_0.StateLive
		arg0_2.dead = nil

		arg0_2:ClearLoader()

		local var2_2 = pg.specialunit_template[var0_2.attachmentId]

		assert(var2_2, "specialunit_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition = Vector2(0, 10)

			arg0_2:GetLoader():GetSprite("enemies/" .. var2_2.prefab, "", findTF(arg0_3, "icon"))
			setActive(findTF(arg0_3, "titleContain/bg_s"), var2_2.enemy_point == 5)
			setActive(findTF(arg0_3, "titleContain/bg_m"), var2_2.enemy_point == 8)
			setActive(findTF(arg0_3, "titleContain/bg_h"), var2_2.enemy_point == 10)

			arg0_2.enemy = arg0_3

			arg0_2:ResetCanvasOrder()
			arg0_2:Update()
		end)
	elseif var0_2.flag == ChapterConst.CellFlagDisabled and arg0_2.state ~= var0_0.StateDead then
		arg0_2.state = var0_0.StateDead
		arg0_2.enemy = nil

		arg0_2:ClearLoader()

		local var3_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var3_2, "land_based_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function(arg0_4)
			setParent(arg0_4, arg0_2.tf)

			tf(arg0_4).anchoredPosition = Vector2(0, 10)

			arg0_2:GetLoader():GetSprite("enemies/" .. var3_2.prefab .. "_d_blue", "", findTF(arg0_4, "icon"))
			setActive(findTF(arg0_4, "effect_not_open"), false)
			setActive(findTF(arg0_4, "effect_open"), false)
			setActive(findTF(arg0_4, "huoqiubaozha"), var1_2 == var0_0.StateLive)

			arg0_2.dead = arg0_4

			arg0_2:ResetCanvasOrder()
			arg0_2:Update()
		end)
	end

	if var0_2.flag == ChapterConst.CellFlagActive and arg0_2.enemy then
		setActive(findTF(arg0_2.enemy, "effect_found"), var0_2.trait == ChapterConst.TraitVirgin)

		if var0_2.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end
end

return var0_0
