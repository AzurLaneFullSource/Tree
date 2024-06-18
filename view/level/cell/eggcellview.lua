local var0_0 = class("EggCellView", import(".EnemyCellView"))

function var0_0.InitEggCellTransform(arg0_1)
	arg0_1.tfIcon = arg0_1.tf:Find("icon")
	arg0_1.tfBufficons = arg0_1.tf:Find("random_buff_container")
	arg0_1.tfBossIcon = arg0_1.tf:Find("titleContain/bg_boss")
	arg0_1.textLV = arg0_1.tf:Find("lv/Text")
	arg0_1.tfEffectFound = arg0_1.tf:Find("effect_found")
	arg0_1.tfEffectFoundBoss = arg0_1.tf:Find("effect_found_boss")
	arg0_1.tfFighting = arg0_1.tf:Find("fighting")

	setText(findTF(arg0_1.tfFighting, "Text"), i18n("ui_word_levelui2_inevent"))

	arg0_1.tfDamageCount = arg0_1.tf:Find("damage_count")
	arg0_1.animator = GetComponent(arg0_1.go, typeof(Animator))
	arg0_1.effectFireball = arg0_1.tf:Find("huoqiubaozha")
end

function var0_0.StartEggCellView(arg0_2, arg1_2, arg2_2)
	if ChapterConst.EnemySize[arg1_2.type] == 99 then
		setActive(arg0_2.tfBossIcon, true)
		arg0_2:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_boss", arg0_2.tfBossIcon)
	elseif ChapterConst.EnemySize[arg1_2.type] == 98 then
		setActive(arg0_2.tfBossIcon, true)
		arg0_2:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_elite", arg0_2.tfBossIcon)
	else
		setActive(arg0_2.tfBossIcon, false)
	end

	if ChapterConst.EnemySize[arg1_2.type] == 98 then
		arg0_2.tfBossIcon.localScale = Vector3(0.5, 0.5, 1)
		arg0_2.tfBossIcon.anchoredPosition = Vector2(61.1, -30.6)
	else
		arg0_2.tfBossIcon.localScale = Vector3(1, 1, 1)
		arg0_2.tfBossIcon.anchoredPosition = Vector2(39.5, -23)
	end

	var0_0.ClearExtraEffects(arg0_2)
	var0_0.LoadExtraEffects(arg0_2, arg1_2.effect_prefab)
	arg0_2:GetLoader():GetSprite("enemies/" .. arg1_2.icon, "", arg0_2.tfIcon)
	setText(arg0_2.textLV, arg1_2.level)
	existCall(arg2_2)
end

function var0_0.UpdateEggCell(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	local var0_3 = arg2_3.row
	local var1_3 = arg2_3.column
	local var2_3 = arg2_3.trait ~= ChapterConst.TraitLurk and arg2_3.flag == ChapterConst.CellFlagActive and not arg1_3:existFleet(FleetType.Transport, var0_3, var1_3)
	local var3_3 = arg1_3:existEnemy(ChapterConst.SubjectChampion, var0_3, var1_3)

	setActive(arg0_3.tfFighting, var2_3 and var3_3)

	arg0_3.animator.enabled = var2_3 and arg2_3.data > 0

	setActive(arg0_3.tfDamageCount, var2_3 and arg2_3.data > 0)
	setActive(arg0_3.effectFireball, false)

	if arg2_3.trait == ChapterConst.TraitVirgin then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	if var2_3 then
		EnemyCellView.RefreshEnemyTplIcons(arg0_3, arg3_3, arg1_3)
	end

	arg0_3:SetActive(var2_3)

	local var4_3 = arg2_3.trait == ChapterConst.TraitVirgin
	local var5_3 = ChapterConst.IsBossCell(arg2_3)

	setActive(arg0_3.tfEffectFound, var4_3 and not var5_3)
	setActive(arg0_3.tfEffectFoundBoss, var4_3 and var5_3)

	if var4_3 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	existCall(arg4_3)
end

return var0_0
