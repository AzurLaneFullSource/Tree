local var0 = class("Stage", import(".BaseVO"))

var0.SubmarinStage = 15

function var0.Ctor(arg0, arg1)
	arg0.configId = arg1.id
	arg0.id = arg0.configId
	arg0.score = arg1.score
	arg0.out_time = arg1.out_time or 0
end

function var0.bindConfigTable(arg0)
	return pg.expedition_data_template
end

function var0.isFinish(arg0)
	return arg0.score and arg0.score > 1
end

return var0
