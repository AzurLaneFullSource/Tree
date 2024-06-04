local var0 = class("AttachmentLBCoastalGunCell", import("view.level.cell.StaticCellView"))

var0.StateLive = 1
var0.StateDead = 2

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityAttachment
end

function var0.Update(arg0)
	local var0 = arg0.info

	if IsNil(arg0.go) then
		arg0:PrepareBase("landbase_" .. var0.attachmentId)
	end

	local var1 = arg0.state

	if var0.flag == ChapterConst.CellFlagActive and arg0.state ~= var0.StateLive then
		arg0.state = var0.StateLive
		arg0.dead = nil

		arg0:ClearLoader()

		local var2 = pg.land_based_template[var0.attachmentId]

		assert(var2, "land_based_template not exist: " .. var0.attachmentId)
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Enemy", "Tpl_Enemy", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition = Vector2(0, 10)

			arg0:GetLoader():GetSprite("enemies/" .. var2.prefab, "", findTF(arg0, "icon"))
			setActive(findTF(arg0, "lv"), false)
			setActive(findTF(arg0, "titleContain/bg_boss"), false)
			setActive(findTF(arg0, "damage_count"), false)
			setActive(findTF(arg0, "fighting"), false)

			arg0.enemy = arg0

			arg0:Update()
		end)
	elseif var0.flag == ChapterConst.CellFlagDisabled and arg0.state ~= var0.StateDead then
		arg0.state = var0.StateDead

		if not IsNil(arg0.enemy) then
			local var3 = arg0.enemy

			setActive(findTF(var3, "lv"), true)
			setActive(findTF(var3, "titleContain"), true)
			setActive(findTF(var3, "damage_count"), true)
			setActive(findTF(var3, "fighting"), true)
		end

		arg0.enemy = nil

		arg0:ClearLoader()

		local var4 = pg.land_based_template[var0.attachmentId]

		assert(var4, "land_based_template not exist: " .. var0.attachmentId)
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_Dead", "Tpl_Dead", function(arg0)
			setParent(arg0, arg0.tf)

			tf(arg0).anchoredPosition = Vector2(0, 10)

			arg0:GetLoader():GetSprite("enemies/" .. var4.prefab .. "_d_blue", "", findTF(arg0, "icon"))
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

function var0.DestroyGO(arg0)
	if not IsNil(arg0.enemy) then
		local var0 = arg0.enemy

		setActive(findTF(var0, "lv"), true)
		setActive(findTF(var0, "titleContain"), true)
		setActive(findTF(var0, "damage_count"), true)
		setActive(findTF(var0, "fighting"), true)
	end

	var0.super.DestroyGO(arg0)
end

return var0
