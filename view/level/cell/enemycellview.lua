local var0_0 = class("EnemyCellView")

function var0_0.Ctor(arg0_1)
	arg0_1._extraEffectList = {}
end

function var0_0.SetPoolType(arg0_2, arg1_2)
	arg0_2.poolType = arg1_2
end

function var0_0.GetPoolType(arg0_3)
	return arg0_3.poolType
end

function var0_0.ClearExtraEffects(arg0_4)
	for iter0_4, iter1_4 in pairs(arg0_4._extraEffectList) do
		if not IsNil(iter1_4) then
			Destroy(iter1_4)
		end
	end

	table.clear(arg0_4._extraEffectList)
end

function var0_0.LoadExtraEffects(arg0_5, arg1_5)
	if arg1_5 and #arg1_5 > 0 then
		local var0_5 = "effect/" .. arg1_5

		arg0_5:GetLoader():LoadPrefab(var0_5, arg1_5, function(arg0_6)
			arg0_5._extraEffectList[var0_5] = arg0_6

			local var0_6 = arg0_6.transform.localScale

			setParent(arg0_6, arg0_5.tf, false)

			arg0_6.transform.localScale = var0_6

			arg0_5:ResetCanvasOrder()
		end)
	end
end

function var0_0.RefreshEnemyTplIcons(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.tf:Find("random_buff_container")

	if not var0_7 then
		return
	end

	local var1_7 = {}

	if arg1_7.icon_type == 1 then
		local var2_7 = arg1_7.type

		if ChapterConst.EnemySize[var2_7] == 1 or not ChapterConst.EnemySize[var2_7] then
			table.insert(var1_7, "xiao")
		elseif ChapterConst.EnemySize[var2_7] == 2 then
			table.insert(var1_7, "zhong")
		elseif ChapterConst.EnemySize[var2_7] == 3 then
			table.insert(var1_7, "da")
		end
	end

	if arg1_7.bufficon and #arg1_7.bufficon > 0 then
		table.insertto(var1_7, arg1_7.bufficon)
	end

	_.each(_.filter(arg2_7:GetWeather(arg0_7.line.row, arg0_7.line.column), function(arg0_8)
		return arg0_8 == ChapterConst.FlagWeatherFog
	end), function(arg0_9)
		table.insert(var1_7, pg.weather_data_template[arg0_9].buff_icon)
	end)
	setActive(var0_7, true)
	LevelGrid.AlignListContainer(var0_7, #var1_7)

	for iter0_7, iter1_7 in ipairs(var1_7) do
		if #iter1_7 > 0 then
			local var3_7 = var0_7:GetChild(iter0_7 - 1)

			arg0_7:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", iter1_7, var3_7)
		end
	end
end

function var0_0.Clear(arg0_10)
	LevelCellView.Clear(arg0_10)
	arg0_10.ClearExtraEffects(arg0_10)
end

return var0_0
