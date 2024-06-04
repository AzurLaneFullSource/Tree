local var0 = class("MapWeatherCellView", import(".StaticCellView"))

function var0.Ctor(arg0, ...)
	var0.super.Ctor(arg0, ...)

	arg0.weatherPrefabs = {}
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityUpperEffect
end

function var0.Update(arg0, arg1)
	if IsNil(arg0.go) then
		arg0:PrepareBase("weathers" .. arg0.line.row .. "_" .. arg0.line.column)
	end

	for iter0, iter1 in ipairs(arg1) do
		if not arg0.weatherPrefabs[iter1] then
			arg0.weatherPrefabs[iter1] = true

			local var0 = pg.weather_data_template[iter1].icon

			if var0 and #var0 > 0 then
				arg0:GetLoader():GetPrefab("ui/" .. var0, var0, function(arg0)
					setParent(arg0, arg0.tf)
					setActive(arg0, true)
					arg0:OnLoadedPrefab(arg0, iter1)
				end, "Weather" .. iter1)
			elseif IsUnityEditor then
				local var1 = GameObject("weatherID_" .. iter1)

				arg0:GetLoader():RegisterLoaded("Weather" .. iter1, var1)
				setParent(var1, arg0.tf)
				setActive(var1, true)
			end
		end
	end

	for iter2, iter3 in pairs(arg0.weatherPrefabs) do
		if not table.contains(arg1, iter2) then
			arg0:GetLoader():ClearRequest("Weather" .. iter2)

			arg0.weatherPrefabs[iter2] = nil
		end
	end
end

function var0.OnLoadedPrefab(arg0, arg1, arg2)
	if arg2 == ChapterConst.FlagWeatherFog then
		local var0 = tf(arg1).childCount
		local var1 = math.random(1, var0)

		for iter0 = 1, var0 do
			setActive(tf(arg1):GetChild(iter0 - 1), iter0 == var1)
		end
	end
end

return var0
