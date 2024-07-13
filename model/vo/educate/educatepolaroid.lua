local var0_0 = class("EducatePolaroid", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.time = arg1_1.time or {
		week = 1,
		month = 3,
		day = 7
	}
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_polaroid
end

function var0_0.GetTimeWeight(arg0_3)
	return arg0_3.time.month * 28 + arg0_3.time.week * 7 + arg0_3.time.day
end

return var0_0
