local var0_0 = import(".EnemyCellView")
local var1_0 = import(".SpineCellView")
local var2_0 = class("ChampionCellView", DecorateClass(var0_0, var1_0))

function var2_0.Ctor(arg0_1)
	var0_0.Ctor(arg0_1)
	var1_0.Ctor(arg0_1)

	arg0_1.autoLoader = AutoLoader.New()
end

function var2_0.InitChampionCellTransform(arg0_2)
	var1_0.InitCellTransform(arg0_2)

	arg0_2.tfEffectFound = arg0_2.tf:Find("effect_found")
	arg0_2.tfFighting = arg0_2.tf:Find("fighting")

	setText(findTF(arg0_2.tfFighting, "Text"), i18n("ui_word_levelui2_inevent"))

	arg0_2.tfDamageCount = arg0_2.tf:Find("damage_count")
	arg0_2.tfBufficons = arg0_2.tf:Find("random_buff_container")
end

function var2_0.UpdateChampionCell(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg2_3.trait ~= ChapterConst.TraitLurk and arg2_3.flag == ChapterConst.CellFlagActive and not arg1_3:existFleet(FleetType.Transport, arg2_3.row, arg2_3.column)
	local var1_3 = arg1_3:existEnemy(ChapterConst.SubjectChampion, arg2_3.row, arg2_3.column)

	setActive(arg0_3.tfFighting, var0_3 and var1_3)
	setActive(arg0_3.tfEffectFound, var0_3 and arg2_3.trait == ChapterConst.TraitVirgin)
	setActive(arg0_3.tfDamageCount, var0_3 and arg2_3.data > 0)
	setActive(arg0_3.tf:Find("huoqiubaozha"), false)

	if arg2_3.trait == ChapterConst.TraitVirgin then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	arg0_3.tfShadow.localEulerAngles = Vector3(arg1_3.theme.angle, 0, 0)

	if var0_3 then
		var0_0.RefreshEnemyTplIcons(arg0_3, arg2_3:getConfigTable(), arg1_3)
	end

	arg0_3:SetActive(var0_3)
	existCall(arg3_3)
end

function var2_0.LoadSpine(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
	var1_0.LoadSpine(arg0_4, arg1_4, arg2_4, nil, function()
		existCall(arg4_4)
		arg0_4.LoadExtraEffects(arg0_4, arg3_4)
	end)
end

function var2_0.LoadExtraEffects(arg0_6, arg1_6)
	if arg1_6 and #arg1_6 > 0 then
		local var0_6 = "effect/" .. arg1_6

		arg0_6.autoLoader:LoadPrefab(var0_6, arg1_6, function(arg0_7)
			arg0_6._extraEffectList[var0_6] = arg0_7

			local var0_7 = arg0_7.transform.localScale

			setParent(arg0_7, arg0_6.tf, false)

			arg0_7.transform.localScale = var0_7

			arg0_6:ResetCanvasOrder()
		end)
	end
end

function var2_0.Clear(arg0_8)
	var1_0.ClearSpine(arg0_8)
	var0_0.Clear(arg0_8)

	if arg0_8.autoLoader then
		arg0_8.autoLoader:ClearRequests()
	end
end

return var2_0
