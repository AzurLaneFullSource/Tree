local var0 = class("EggCellView", import(".EnemyCellView"))

function var0.InitEggCellTransform(arg0)
	arg0.tfIcon = arg0.tf:Find("icon")
	arg0.tfBufficons = arg0.tf:Find("random_buff_container")
	arg0.tfBossIcon = arg0.tf:Find("titleContain/bg_boss")
	arg0.textLV = arg0.tf:Find("lv/Text")
	arg0.tfEffectFound = arg0.tf:Find("effect_found")
	arg0.tfEffectFoundBoss = arg0.tf:Find("effect_found_boss")
	arg0.tfFighting = arg0.tf:Find("fighting")

	setText(findTF(arg0.tfFighting, "Text"), i18n("ui_word_levelui2_inevent"))

	arg0.tfDamageCount = arg0.tf:Find("damage_count")
	arg0.animator = GetComponent(arg0.go, typeof(Animator))
	arg0.effectFireball = arg0.tf:Find("huoqiubaozha")
end

function var0.StartEggCellView(arg0, arg1, arg2)
	if ChapterConst.EnemySize[arg1.type] == 99 then
		setActive(arg0.tfBossIcon, true)
		arg0:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_boss", arg0.tfBossIcon)
	elseif ChapterConst.EnemySize[arg1.type] == 98 then
		setActive(arg0.tfBossIcon, true)
		arg0:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", "enemy_elite", arg0.tfBossIcon)
	else
		setActive(arg0.tfBossIcon, false)
	end

	if ChapterConst.EnemySize[arg1.type] == 98 then
		arg0.tfBossIcon.localScale = Vector3(0.5, 0.5, 1)
		arg0.tfBossIcon.anchoredPosition = Vector2(61.1, -30.6)
	else
		arg0.tfBossIcon.localScale = Vector3(1, 1, 1)
		arg0.tfBossIcon.anchoredPosition = Vector2(39.5, -23)
	end

	var0.ClearExtraEffects(arg0)
	var0.LoadExtraEffects(arg0, arg1.effect_prefab)
	arg0:GetLoader():GetSprite("enemies/" .. arg1.icon, "", arg0.tfIcon)
	setText(arg0.textLV, arg1.level)
	existCall(arg2)
end

function var0.UpdateEggCell(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg2.row
	local var1 = arg2.column
	local var2 = arg2.trait ~= ChapterConst.TraitLurk and arg2.flag == ChapterConst.CellFlagActive and not arg1:existFleet(FleetType.Transport, var0, var1)
	local var3 = arg1:existEnemy(ChapterConst.SubjectChampion, var0, var1)

	setActive(arg0.tfFighting, var2 and var3)

	arg0.animator.enabled = var2 and arg2.data > 0

	setActive(arg0.tfDamageCount, var2 and arg2.data > 0)
	setActive(arg0.effectFireball, false)

	if arg2.trait == ChapterConst.TraitVirgin then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	if var2 then
		EnemyCellView.RefreshEnemyTplIcons(arg0, arg3, arg1)
	end

	arg0:SetActive(var2)

	local var4 = arg2.trait == ChapterConst.TraitVirgin
	local var5 = ChapterConst.IsBossCell(arg2)

	setActive(arg0.tfEffectFound, var4 and not var5)
	setActive(arg0.tfEffectFoundBoss, var4 and var5)

	if var4 then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	existCall(arg4)
end

return var0
