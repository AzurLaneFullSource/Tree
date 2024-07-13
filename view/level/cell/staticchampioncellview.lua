local var0_0 = import(".StaticCellView")
local var1_0 = import(".ChampionCellView")
local var2_0 = class("StaticChampionCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1, arg1_1)
	var0_0.Ctor(arg0_1, arg1_1)
	var1_0.Ctor(arg0_1)
end

function var2_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityEnemy
end

function var2_0.InitChampionCellTransform(arg0_3)
	var1_0.InitChampionCellTransform(arg0_3)

	arg0_3.textLV = arg0_3.tf:Find("lv/Text")
	arg0_3.tfBossIcon = arg0_3.tf:Find("titleContain/bg_boss")
	arg0_3.tfEffectFoundBoss = arg0_3.tf:Find("effect_found_boss")
end

function var2_0.Update(arg0_4)
	local var0_4 = arg0_4.info
	local var1_4 = arg0_4.config
	local var2_4 = var0_4.trait ~= ChapterConst.TraitLurk

	if ChapterConst.IsEnemyAttach(var0_4.attachment) and var0_4.flag == ChapterConst.CellFlagActive and arg0_4.chapter:existFleet(FleetType.Transport, var0_4.row, var0_4.column) then
		var2_4 = false
	end

	if not IsNil(arg0_4.go) then
		setActive(arg0_4.go, var2_4)
	end

	if not var2_4 then
		return
	end

	if IsNil(arg0_4.go) then
		arg0_4:GetLoader():GetPrefab("leveluiview/Tpl_StaticChampion", "Tpl_StaticChampion", function(arg0_5)
			arg0_5.name = "enemy_" .. var0_4.attachmentId
			arg0_4.go = arg0_5
			arg0_4.tf = tf(arg0_5)

			setParent(arg0_5, arg0_4.parent)
			arg0_4:OverrideCanvas()
			arg0_4:ResetCanvasOrder()
			setAnchoredPosition(arg0_4.tf, Vector2.zero)
			arg0_4:InitChampionCellTransform()
			var2_0.StartEggCellView(arg0_4, var1_4)
			SpineCellView.SetAction(arg0_4, ChapterConst.ShipIdleAction)
			var1_0.LoadSpine(arg0_4, var1_4.icon, var1_4.scale, var1_4.effect_prefab)
			arg0_4:Update()
		end, "Main")

		return
	end

	arg0_4:UpdateChampionCell(arg0_4.chapter, var0_4)
end

function var2_0.UpdateChampionCell(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg2_6.trait ~= ChapterConst.TraitLurk and arg2_6.flag == ChapterConst.CellFlagActive and not arg1_6:existFleet(FleetType.Transport, arg2_6.row, arg2_6.column)
	local var1_6 = arg1_6:existEnemy(ChapterConst.SubjectChampion, arg2_6.row, arg2_6.column)

	setActive(arg0_6.tfFighting, var0_6 and var1_6)
	setActive(arg0_6.tfDamageCount, var0_6 and arg2_6.data > 0)

	local var2_6 = arg2_6.trait == ChapterConst.TraitVirgin
	local var3_6 = ChapterConst.IsBossCell(arg2_6)

	setActive(arg0_6.tfEffectFound, var2_6 and not var3_6)
	setActive(arg0_6.tfEffectFoundBoss, var2_6 and var3_6)

	if var2_6 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	arg0_6.tfShadow.localEulerAngles = Vector3(arg1_6.theme.angle, 0, 0)

	if var0_6 then
		EnemyCellView.RefreshEnemyTplIcons(arg0_6, arg0_6.config, arg1_6)
	end

	arg0_6:SetActive(var0_6)
	existCall(arg3_6)
end

function var2_0.StartEggCellView(arg0_7, arg1_7, arg2_7)
	if ChapterConst.EnemySize[arg1_7.type] == 99 then
		setActive(arg0_7.tfBossIcon, true)
		arg0_7:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_boss", arg0_7.tfBossIcon)
	elseif ChapterConst.EnemySize[arg1_7.type] == 98 then
		setActive(arg0_7.tfBossIcon, true)
		arg0_7:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_elite", arg0_7.tfBossIcon)
	else
		setActive(arg0_7.tfBossIcon, false)
	end

	arg0_7.tfBossIcon.localScale = Vector3(0.5, 0.5, 1)
	arg0_7.tfBossIcon.anchoredPosition = Vector2(61.1, -30.6)

	setText(arg0_7.textLV, arg1_7.level)
	existCall(arg2_7)
end

function var2_0.Clear(arg0_8)
	var1_0.Clear(arg0_8)
	var0_0.Clear(arg0_8)
end

return var2_0
