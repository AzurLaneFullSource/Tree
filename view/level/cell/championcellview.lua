local var0 = import(".EnemyCellView")
local var1 = import(".SpineCellView")
local var2 = class("ChampionCellView", DecorateClass(var0, var1))

function var2.Ctor(arg0)
	var0.Ctor(arg0)
	var1.Ctor(arg0)

	arg0.autoLoader = AutoLoader.New()
end

function var2.InitChampionCellTransform(arg0)
	var1.InitCellTransform(arg0)

	arg0.tfEffectFound = arg0.tf:Find("effect_found")
	arg0.tfFighting = arg0.tf:Find("fighting")

	setText(findTF(arg0.tfFighting, "Text"), i18n("ui_word_levelui2_inevent"))

	arg0.tfDamageCount = arg0.tf:Find("damage_count")
	arg0.tfBufficons = arg0.tf:Find("random_buff_container")
end

function var2.UpdateChampionCell(arg0, arg1, arg2, arg3)
	local var0 = arg2.trait ~= ChapterConst.TraitLurk and arg2.flag == ChapterConst.CellFlagActive and not arg1:existFleet(FleetType.Transport, arg2.row, arg2.column)
	local var1 = arg1:existEnemy(ChapterConst.SubjectChampion, arg2.row, arg2.column)

	setActive(arg0.tfFighting, var0 and var1)
	setActive(arg0.tfEffectFound, var0 and arg2.trait == ChapterConst.TraitVirgin)
	setActive(arg0.tfDamageCount, var0 and arg2.data > 0)
	setActive(arg0.tf:Find("huoqiubaozha"), false)

	if arg2.trait == ChapterConst.TraitVirgin then
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_WEIGHANCHOR_ENEMY)
	end

	arg0.tfShadow.localEulerAngles = Vector3(arg1.theme.angle, 0, 0)

	if var0 then
		var0.RefreshEnemyTplIcons(arg0, arg2:getConfigTable(), arg1)
	end

	arg0:SetActive(var0)
	existCall(arg3)
end

function var2.LoadSpine(arg0, arg1, arg2, arg3, arg4)
	var1.LoadSpine(arg0, arg1, arg2, nil, function()
		existCall(arg4)
		arg0.LoadExtraEffects(arg0, arg3)
	end)
end

function var2.LoadExtraEffects(arg0, arg1)
	if arg1 and #arg1 > 0 then
		local var0 = "effect/" .. arg1

		arg0.autoLoader:LoadPrefab(var0, arg1, function(arg0)
			arg0._extraEffectList[var0] = arg0

			local var0 = arg0.transform.localScale

			setParent(arg0, arg0.tf, false)

			arg0.transform.localScale = var0

			arg0:ResetCanvasOrder()
		end)
	end
end

function var2.Clear(arg0)
	var1.ClearSpine(arg0)
	var0.Clear(arg0)

	if arg0.autoLoader then
		arg0.autoLoader:ClearRequests()
	end
end

return var2
