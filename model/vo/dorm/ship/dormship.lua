local var0_0 = class("DormShip")

var0_0.FLOOR_1 = 1
var0_0.FLOOR_2 = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.floor = arg1_1.floor
	arg0_1.moneny = arg1_1.pop_icon or 0
	arg0_1.intimacy = arg1_1.pop_intimacy or 0
end

function var0_0.IsSameFloor(arg0_2, arg1_2)
	return arg0_2.floor == arg1_2
end

function var0_0.AddmoneyAndIntimacy(arg0_3, arg1_3, arg2_3)
	arg0_3.moneny = arg1_3
	arg0_3.intimacy = arg2_3
end

function var0_0.GetInimacy(arg0_4)
	return arg0_4.intimacy
end

function var0_0.HasMoneyOrIntimacy(arg0_5)
	return arg0_5:HasMoney() or arg0_5:HasIntimacy()
end

function var0_0.HasMoney(arg0_6)
	return arg0_6.moneny > 0
end

function var0_0.GetMoney(arg0_7)
	return arg0_7.moneny
end

function var0_0.HasIntimacy(arg0_8)
	return arg0_8.intimacy > 0
end

function var0_0.GetIntimacy(arg0_9)
	return arg0_9.intimacy
end

function var0_0.ClearMoneyAndIntimacy(arg0_10)
	arg0_10:ClearMoney()
	arg0_10:ClearIntimacy()
end

function var0_0.ClearMoney(arg0_11)
	arg0_11.moneny = 0
end

function var0_0.ClearIntimacy(arg0_12)
	arg0_12.intimacy = 0
end

function var0_0.IsSame(arg0_13, arg1_13)
	return arg0_13.id == arg1_13
end

function var0_0.ToBayShip(arg0_14)
	return (getProxy(BayProxy):RawGetShipById(arg0_14.id))
end

return var0_0
