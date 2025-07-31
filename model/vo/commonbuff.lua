local var0_0 = class("CommonBuff", import(".BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.timestamp = arg1_1.timestamp
end

function var0_0.IsActiveType(arg0_2)
	return false
end

function var0_0.bindConfigTable(arg0_3)
	return pg.benefit_buff_template
end

function var0_0.checkShow(arg0_4)
	return arg0_4:getConfig("hide") ~= 1
end

function var0_0.isActivate(arg0_5)
	return pg.TimeMgr.GetInstance():GetServerTime() <= arg0_5.timestamp
end

function var0_0.getLeftTime(arg0_6)
	local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_6.timestamp - var0_6
end

return var0_0
