local var0 = class("EducatePolaroid", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.time = arg1.time or {
		week = 1,
		month = 3,
		day = 7
	}
end

function var0.bindConfigTable(arg0)
	return pg.child_polaroid
end

function var0.GetTimeWeight(arg0)
	return arg0.time.month * 28 + arg0.time.week * 7 + arg0.time.day
end

return var0
