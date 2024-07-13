local var0_0 = class("MapWeatherCellView", import(".StaticCellView"))

function var0_0.Ctor(arg0_1, ...)
	var0_0.super.Ctor(arg0_1, ...)

	arg0_1.weatherPrefabs = {}
end

function var0_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityUpperEffect
end

function var0_0.Update(arg0_3, arg1_3)
	if IsNil(arg0_3.go) then
		arg0_3:PrepareBase("weathers" .. arg0_3.line.row .. "_" .. arg0_3.line.column)
	end

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		if not arg0_3.weatherPrefabs[iter1_3] then
			arg0_3.weatherPrefabs[iter1_3] = true

			local var0_3 = pg.weather_data_template[iter1_3].icon

			if var0_3 and #var0_3 > 0 then
				arg0_3:GetLoader():GetPrefab("ui/" .. var0_3, var0_3, function(arg0_4)
					setParent(arg0_4, arg0_3.tf)
					setActive(arg0_4, true)
					arg0_3:OnLoadedPrefab(arg0_4, iter1_3)
				end, "Weather" .. iter1_3)
			elseif IsUnityEditor then
				local var1_3 = GameObject("weatherID_" .. iter1_3)

				arg0_3:GetLoader():RegisterLoaded("Weather" .. iter1_3, var1_3)
				setParent(var1_3, arg0_3.tf)
				setActive(var1_3, true)
			end
		end
	end

	for iter2_3, iter3_3 in pairs(arg0_3.weatherPrefabs) do
		if not table.contains(arg1_3, iter2_3) then
			arg0_3:GetLoader():ClearRequest("Weather" .. iter2_3)

			arg0_3.weatherPrefabs[iter2_3] = nil
		end
	end
end

function var0_0.OnLoadedPrefab(arg0_5, arg1_5, arg2_5)
	if arg2_5 == ChapterConst.FlagWeatherFog then
		local var0_5 = tf(arg1_5).childCount
		local var1_5 = math.random(1, var0_5)

		for iter0_5 = 1, var0_5 do
			setActive(tf(arg1_5):GetChild(iter0_5 - 1), iter0_5 == var1_5)
		end
	end
end

return var0_0
