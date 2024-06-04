local var0 = class("Fushun3GameVo")

var0.TimeType = Fushun3GameConst.day_type
var0.TimeFlag = true

function var0.ChangeTimeType(arg0)
	var0.TimeType = arg0

	local var0 = (var0.TimeType == Fushun3GameConst.day_type or var0.TimeType == Fushun3GameConst.sunset_type) and true or false

	var0.SetTimeFlag(var0)
end

function var0.GetTimeTypeData()
	return Clone(Fushun3GameConst.time_data[var0.TimeType])
end

function var0.SetTimeFlag(arg0)
	var0.TimeFlag = arg0
end

function var0.GetTimeFlag()
	return var0.TimeFlag
end

function var0.Clear()
	if var0.TypeType == Fushun3GameConst.sunset_type then
		var0.ChangeTimeType(Fushun3GameConst.day_type)
	end
end

return var0
