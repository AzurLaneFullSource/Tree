local var0 = class("EnemyCellView")

function var0.Ctor(arg0)
	arg0._extraEffectList = {}
end

function var0.SetPoolType(arg0, arg1)
	arg0.poolType = arg1
end

function var0.GetPoolType(arg0)
	return arg0.poolType
end

function var0.ClearExtraEffects(arg0)
	for iter0, iter1 in pairs(arg0._extraEffectList) do
		if not IsNil(iter1) then
			Destroy(iter1)
		end
	end

	table.clear(arg0._extraEffectList)
end

function var0.LoadExtraEffects(arg0, arg1)
	if arg1 and #arg1 > 0 then
		local var0 = "effect/" .. arg1

		arg0:GetLoader():LoadPrefab(var0, arg1, function(arg0)
			arg0._extraEffectList[var0] = arg0

			local var0 = arg0.transform.localScale

			setParent(arg0, arg0.tf, false)

			arg0.transform.localScale = var0

			arg0:ResetCanvasOrder()
		end)
	end
end

function var0.RefreshEnemyTplIcons(arg0, arg1, arg2)
	local var0 = arg0.tf:Find("random_buff_container")

	if not var0 then
		return
	end

	local var1 = {}

	if arg1.icon_type == 1 then
		local var2 = arg1.type

		if ChapterConst.EnemySize[var2] == 1 or not ChapterConst.EnemySize[var2] then
			table.insert(var1, "xiao")
		elseif ChapterConst.EnemySize[var2] == 2 then
			table.insert(var1, "zhong")
		elseif ChapterConst.EnemySize[var2] == 3 then
			table.insert(var1, "da")
		end
	end

	if arg1.bufficon and #arg1.bufficon > 0 then
		table.insertto(var1, arg1.bufficon)
	end

	_.each(_.filter(arg2:GetWeather(arg0.line.row, arg0.line.column), function(arg0)
		return arg0 == ChapterConst.FlagWeatherFog
	end), function(arg0)
		table.insert(var1, pg.weather_data_template[arg0].buff_icon)
	end)
	setActive(var0, true)
	LevelGrid.AlignListContainer(var0, #var1)

	for iter0, iter1 in ipairs(var1) do
		if #iter1 > 0 then
			local var3 = var0:GetChild(iter0 - 1)

			arg0:GetLoader():GetSpriteQuiet("ui/share/ship_gizmos_atlas", iter1, var3)
		end
	end
end

function var0.Clear(arg0)
	arg0.ClearExtraEffects(arg0)
end

return var0
