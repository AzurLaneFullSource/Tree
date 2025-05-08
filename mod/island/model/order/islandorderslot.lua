local var0_0 = class("IslandOrderSlot")

var0_0.STATE_EMPTY = 1
var0_0.STATE_NORMAL = 2
var0_0.STATE_LOADING = 3
var0_0.STATE_CAN_FINISH = 4
var0_0.SHOW_FLAG_TODAY = 0
var0_0.SHOW_FLAG_TOMORROW = 1
var0_0.TENDENCY_TYPE_COMMON = 0
var0_0.TENDENCY_TYPE_EASY = 1
var0_0.TENDENCY_TYPE_HARD = 2

function var0_0.TENDENCY2TIP(arg0_1)
	if not var0_0.TENDENCY_2_TIP then
		var0_0.TENDENCY_2_TIP = {
			i18n1("标准订单"),
			i18n1("相较标准订单更易完成,奖励也有所降低"),
			i18n1("相较标准订单更具挑战,奖励也有所提升")
		}
	end

	return var0_0.TENDENCY_2_TIP[arg0_1 + 1]
end

function var0_0.TENDENCY2CN(arg0_2)
	if not var0_0.TENDENCY_2_CN then
		var0_0.TENDENCY_2_CN = {
			i18n1("标准"),
			i18n1("更易完成"),
			i18n1("更具挑战")
		}
	end

	return var0_0.TENDENCY_2_CN[arg0_2 + 1]
end

function var0_0.Ctor(arg0_3, arg1_3)
	arg0_3:Flush(arg1_3)
end

function var0_0.Flush(arg0_4, arg1_4)
	arg0_4.id = arg1_4.id
	arg0_4.position = arg1_4.position
	arg0_4.order = arg0_4:GenOrder(arg1_4)
end

function var0_0.GenOrder(arg0_5, arg1_5)
	if arg1_5.type == IslandOrder.TYPE_NORMAL then
		return IslandOrder.New(arg1_5)
	elseif arg1_5.type == IslandOrder.TYPE_URGENCY then
		return IslandUrgencyOrder.New(arg1_5)
	elseif arg1_5.type == IslandOrder.TYPE_FORM then
		return IslandFirmOrder.New(arg1_5)
	end

	assert(false, "order should be exist" .. arg1_5.type)
end

function var0_0.GetPosition(arg0_6)
	return pg.island_order_position[arg0_6.position] or pg.island_order_position[1]
end

function var0_0.GetState(arg0_7)
	if arg0_7:IsLoading() then
		return var0_0.STATE_LOADING
	end

	if arg0_7:IsEmpty() then
		return var0_0.STATE_EMPTY
	end

	if arg0_7:CanSubmit() then
		return var0_0.STATE_CAN_FINISH
	end

	return var0_0.STATE_NORMAL
end

function var0_0.GetCanSubmitTime(arg0_8)
	return arg0_8.order:GetCanSubmitTime()
end

function var0_0.GetDisappearTime(arg0_9)
	return arg0_9.order:GetDisappearTime()
end

function var0_0.GetTotalTime(arg0_10)
	return arg0_10.order:GetTotalTime()
end

function var0_0.CanSubmit(arg0_11)
	if arg0_11:IsEmpty() then
		return false
	end

	if arg0_11:IsLoading() then
		return false
	end

	return arg0_11.order:CanFinish()
end

function var0_0.IsEmpty(arg0_12)
	return arg0_12.order:IsEmpty()
end

function var0_0.IsLoading(arg0_13)
	return arg0_13.order:IsLoading()
end

function var0_0.CanReplace(arg0_14)
	return arg0_14.order:CanReplace()
end

function var0_0.GetOrder(arg0_15)
	return arg0_15.order
end

return var0_0
