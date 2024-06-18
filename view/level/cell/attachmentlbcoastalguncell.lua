local var0_0 = class("AttachmentLBCoastalGunCell", import("view.level.cell.StaticCellView"))

var0_0.StateLive = 1
var0_0.StateDead = 2

function var0_0.GetOrder(arg0_1)
	return ChapterConst.CellPriorityAttachment
end

function var0_0.Update(arg0_2)
	local var0_2 = arg0_2.info

	if IsNil(arg0_2.go) then
		arg0_2:PrepareBase("landbase_" .. var0_2.attachmentId)
	end

	local var1_2 = arg0_2.state

	if var0_2.flag == ChapterConst.CellFlagActive and arg0_2.state ~= var0_0.StateLive then
		arg0_2.state = var0_0.StateLive
		arg0_2.dead = nil

		arg0_2:ClearLoader()

		local var2_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var2_2, "land_based_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function(arg0_3)
			setParent(arg0_3, arg0_2.tf)

			tf(arg0_3).anchoredPosition = Vector2(0, 10)

			arg0_2:GetLoader():GetSprite("enemies/" .. var2_2.prefab, "", findTF(arg0_3, "icon"))
			setActive(findTF(arg0_3, "lv"), false)
			setActive(findTF(arg0_3, "titleContain/bg_boss"), false)
			setActive(findTF(arg0_3, "damage_count"), false)
			setActive(findTF(arg0_3, "fighting"), false)

			arg0_2.enemy = arg0_3

			arg0_2:Update()
		end)
	elseif var0_2.flag == ChapterConst.CellFlagDisabled and arg0_2.state ~= var0_0.StateDead then
		arg0_2.state = var0_0.StateDead

		if not IsNil(arg0_2.enemy) then
			local var3_2 = arg0_2.enemy

			setActive(findTF(var3_2, "lv"), true)
			setActive(findTF(var3_2, "titleContain"), true)
			setActive(findTF(var3_2, "damage_count"), true)
			setActive(findTF(var3_2, "fighting"), true)
		end

		arg0_2.enemy = nil

		arg0_2:ClearLoader()

		local var4_2 = pg.land_based_template[var0_2.attachmentId]

		assert(var4_2, "land_based_template not exist: " .. var0_2.attachmentId)
		arg0_2:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function(arg0_4)
			setParent(arg0_4, arg0_2.tf)

			tf(arg0_4).anchoredPosition = Vector2(0, 10)

			arg0_2:GetLoader():GetSprite("enemies/" .. var4_2.prefab .. "_d_blue", "", findTF(arg0_4, "icon"))
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

function var0_0.DestroyGO(arg0_5)
	if not IsNil(arg0_5.enemy) then
		local var0_5 = arg0_5.enemy

		setActive(findTF(var0_5, "lv"), true)
		setActive(findTF(var0_5, "titleContain"), true)
		setActive(findTF(var0_5, "damage_count"), true)
		setActive(findTF(var0_5, "fighting"), true)
	end

	var0_0.super.DestroyGO(arg0_5)
end

return var0_0
