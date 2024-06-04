local var0 = import(".StaticCellView")
local var1 = import(".ChampionCellView")
local var2 = class("StaticChampionCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0, arg1)
	var0.Ctor(arg0, arg1)
	var1.Ctor(arg0)
end

function var2.GetOrder(arg0)
	return ChapterConst.CellPriorityEnemy
end

function var2.InitChampionCellTransform(arg0)
	var1.InitChampionCellTransform(arg0)

	arg0.textLV = arg0.tf:Find("lv/Text")
	arg0.tfBossIcon = arg0.tf:Find("titleContain/bg_boss")
	arg0.tfEffectFoundBoss = arg0.tf:Find("effect_found_boss")
end

function var2.Update(arg0)
	local var0 = arg0.info
	local var1 = arg0.config
	local var2 = var0.trait ~= ChapterConst.TraitLurk

	if ChapterConst.IsEnemyAttach(var0.attachment) and var0.flag == ChapterConst.CellFlagActive and arg0.chapter:existFleet(FleetType.Transport, var0.row, var0.column) then
		var2 = false
	end

	if not IsNil(arg0.go) then
		setActive(arg0.go, var2)
	end

	if not var2 then
		return
	end

	if IsNil(arg0.go) then
		arg0:GetLoader():GetPrefab("leveluiview/Tpl_StaticChampion", "Tpl_StaticChampion", function(arg0)
			arg0.name = "enemy_" .. var0.attachmentId
			arg0.go = arg0
			arg0.tf = tf(arg0)

			setParent(arg0, arg0.parent)
			arg0:OverrideCanvas()
			arg0:ResetCanvasOrder()
			setAnchoredPosition(arg0.tf, Vector2.zero)
			arg0:InitChampionCellTransform()
			var2.StartEggCellView(arg0, var1)
			SpineCellView.SetAction(arg0, ChapterConst.ShipIdleAction)
			var1.LoadSpine(arg0, var1.icon, var1.scale, var1.effect_prefab)
			arg0:Update()
		end, "Main")

		return
	end

	arg0:UpdateChampionCell(arg0.chapter, var0)
end

function var2.UpdateChampionCell(arg0, arg1, arg2, arg3)
	local var0 = arg2.trait ~= ChapterConst.TraitLurk and arg2.flag == ChapterConst.CellFlagActive and not arg1:existFleet(FleetType.Transport, arg2.row, arg2.column)
	local var1 = arg1:existEnemy(ChapterConst.SubjectChampion, arg2.row, arg2.column)

	setActive(arg0.tfFighting, var0 and var1)
	setActive(arg0.tfDamageCount, var0 and arg2.data > 0)

	local var2 = arg2.trait == ChapterConst.TraitVirgin
	local var3 = ChapterConst.IsBossCell(arg2)

	setActive(arg0.tfEffectFound, var2 and not var3)
	setActive(arg0.tfEffectFoundBoss, var2 and var3)

	if var2 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	arg0.tfShadow.localEulerAngles = Vector3(arg1.theme.angle, 0, 0)

	if var0 then
		EnemyCellView.RefreshEnemyTplIcons(arg0, arg0.config, arg1)
	end

	arg0:SetActive(var0)
	existCall(arg3)
end

function var2.StartEggCellView(arg0, arg1, arg2)
	if ChapterConst.EnemySize[arg1.type] == 99 then
		setActive(arg0.tfBossIcon, true)
		arg0:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_boss", arg0.tfBossIcon)
	elseif ChapterConst.EnemySize[arg1.type] == 98 then
		setActive(arg0.tfBossIcon, true)
		arg0:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_elite", arg0.tfBossIcon)
	else
		setActive(arg0.tfBossIcon, false)
	end

	arg0.tfBossIcon.localScale = Vector3(0.5, 0.5, 1)
	arg0.tfBossIcon.anchoredPosition = Vector2(61.1, -30.6)

	setText(arg0.textLV, arg1.level)
	existCall(arg2)
end

function var2.Clear(arg0)
	var1.Clear(arg0)
	var0.Clear(arg0)
end

return var2
