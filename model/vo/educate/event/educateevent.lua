local var0_0 = class("EducateEvent", import("model.vo.BaseVO"))

var0_0.TYPE_PLAN = 1
var0_0.TYPE_OPTION = 2
var0_0.TYPE_BUBBLE = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_event
end

function var0_0.GetPerformance(arg0_3)
	return arg0_3:getConfig("performance")
end

return var0_0
