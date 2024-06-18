local var0_0 = class("Fushun3GameVo")

var0_0.TimeType = Fushun3GameConst.day_type
var0_0.TimeFlag = true

function var0_0.ChangeTimeType(arg0_1)
	var0_0.TimeType = arg0_1

	local var0_1 = (var0_0.TimeType == Fushun3GameConst.day_type or var0_0.TimeType == Fushun3GameConst.sunset_type) and true or false

	var0_0.SetTimeFlag(var0_1)
end

function var0_0.GetTimeTypeData()
	return Clone(Fushun3GameConst.time_data[var0_0.TimeType])
end

function var0_0.SetTimeFlag(arg0_3)
	var0_0.TimeFlag = arg0_3
end

function var0_0.GetTimeFlag()
	return var0_0.TimeFlag
end

function var0_0.Clear()
	if var0_0.TypeType == Fushun3GameConst.sunset_type then
		var0_0.ChangeTimeType(Fushun3GameConst.day_type)
	end
end

return var0_0
