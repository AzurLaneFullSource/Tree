local var0 = class("EducateEvent", import("model.vo.BaseVO"))

var0.TYPE_PLAN = 1
var0.TYPE_OPTION = 2
var0.TYPE_BUBBLE = 3

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
end

function var0.bindConfigTable(arg0)
	return pg.child_event
end

function var0.GetPerformance(arg0)
	return arg0:getConfig("performance")
end

return var0
