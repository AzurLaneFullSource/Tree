local var0_0 = class("Stage", import(".BaseVO"))

var0_0.SubmarinStage = 15

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.configId = arg1_1.id
	arg0_1.id = arg0_1.configId
	arg0_1.score = arg1_1.score
	arg0_1.out_time = arg1_1.out_time or 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.expedition_data_template
end

function var0_0.isFinish(arg0_3)
	return arg0_3.score and arg0_3.score > 1
end

return var0_0
