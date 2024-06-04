local var0 = class("VipCard", import(".BaseVO"))

var0.MONTH = 1

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.type
	arg0.type = arg1.type
	arg0.leftDate = arg1.left_date
	arg0.data = arg1.data
end

function var0.getLeftDate(arg0)
	if arg0.type == var0.MONTH then
		return arg0.leftDate + 86400
	end
end

function var0.GetLeftDay(arg0)
	local var0 = arg0:getLeftDate()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	return (math.floor((var0 - var1) / 86400))
end

function var0.isExpire(arg0)
	if arg0.type == var0.MONTH then
		return arg0:getLeftDate() <= pg.TimeMgr.GetInstance():GetServerTime()
	end
end

return var0
