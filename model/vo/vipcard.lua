local var0_0 = class("VipCard", import(".BaseVO"))

var0_0.MONTH = 1

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.type
	arg0_1.type = arg1_1.type
	arg0_1.leftDate = arg1_1.left_date
	arg0_1.data = arg1_1.data
end

function var0_0.getLeftDate(arg0_2)
	if arg0_2.type == var0_0.MONTH then
		return arg0_2.leftDate + 86400
	end
end

function var0_0.GetLeftDay(arg0_3)
	local var0_3 = arg0_3:getLeftDate()
	local var1_3 = pg.TimeMgr.GetInstance():GetServerTime()

	return (math.floor((var0_3 - var1_3) / 86400))
end

function var0_0.isExpire(arg0_4)
	if arg0_4.type == var0_0.MONTH then
		return arg0_4:getLeftDate() <= pg.TimeMgr.GetInstance():GetServerTime()
	end
end

return var0_0
