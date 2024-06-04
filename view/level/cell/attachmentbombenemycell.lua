local var0 = class("AttachmentBombEnemyCell", import("view.level.cell.StaticCellView"))

var0.StateLive = 1
var0.StateDead = 2

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("bomb_enemy_" .. var0.attachmentId)
	end

	local var1 = arg0.state

	if var0.flag == ChapterConst.CellFlagActive and arg0.state ~= var0.StateLive then
		arg0.state = var0.StateLive
		arg0.dead = nil

		arg0:ClearLoader()

		local var2 = pg.specialunit_template[var0.attachmentId]

		assert(var2, "specialunit_template not exist: " .. var0.attachmentId)
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition = Vector2(0, 10)

			arg0:GetLoader():GetSprite("enemies/" .. var2.prefab, "", findTF(arg0, "icon"))
			setActive(findTF(arg0, "titleContain/bg_s"), var2.enemy_point == 5)
			setActive(findTF(arg0, "titleContain/bg_m"), var2.enemy_point == 8)
			setActive(findTF(arg0, "titleContain/bg_h"), var2.enemy_point == 10)

			arg0.enemy = arg0

			arg0:ResetCanvasOrder()
			arg0:Update()
		end)
	elseif var0.flag == ChapterConst.CellFlagDisabled and arg0.state ~= var0.StateDead then
		arg0.state = var0.StateDead
		arg0.enemy = nil

		arg0:ClearLoader()

		local var3 = pg.land_based_template[var0.attachmentId]

		assert(var3, "land_based_template not exist: " .. var0.attachmentId)
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition = Vector2(0, 10)

			arg0:GetLoader():GetSprite("enemies/" .. var3.prefab .. "_d_blue", "", findTF(arg0, "icon"))
			setActive(findTF(arg0, "effect_not_open"), false)
			setActive(findTF(arg0, "effect_open"), false)
			setActive(findTF(arg0, "huoqiubaozha"), var1 == var0.StateLive)

			arg0.dead = arg0

			arg0:ResetCanvasOrder()
			arg0:Update()
		end)
	end

	if var0.flag == ChapterConst.CellFlagActive and arg0.enemy then
		setActive(findTF(arg0.enemy, "effect_found"), var0.trait == ChapterConst.TraitVirgin)

		if var0.trait == ChapterConst.TraitVirgin then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
		end
	end
end

return var0
