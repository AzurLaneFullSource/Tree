local var0_0 = class("WorldMapPort", import("...BaseEntity"))

var0_0.Fields = {
	config = "table",
	zeroHourTime = "number",
	goods = "table",
	taskIds = "table",
	id = "number",
	expiredTime = "number"
}
var0_0.EventUpdateTaskIds = "WorldMapPort.UpdateTaskIds"
var0_0.EventUpdateGoods = "WorldMapPort.EventUpdateGoods"

function var0_0.Build(arg0_1)
	arg0_1.taskIds = {}
	arg0_1.goods = {}
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.id = arg1_2
	arg0_2.config = pg.world_port_data[arg0_2.id]

	assert(arg0_2.config, "world_port_data not exist: " .. arg0_2.id)
end

function var0_0.Dispose(arg0_3)
	arg0_3:ClearGoods()
	arg0_3:Clear()
end

function var0_0.IsValid(arg0_4)
	local var0_4 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_4.expiredTime and var0_4 <= arg0_4.expiredTime and arg0_4.zeroHourTime and var0_4 <= arg0_4.zeroHourTime
end

function var0_0.UpdateExpiredTime(arg0_5, arg1_5)
	arg0_5.expiredTime = arg1_5
	arg0_5.zeroHourTime = pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function var0_0.UpdateTaskIds(arg0_6, arg1_6)
	if arg0_6.taskIds ~= arg1_6 then
		arg0_6.taskIds = arg1_6

		arg0_6:DispatchEvent(var0_0.EventUpdateTaskIds)
	end
end

function var0_0.UpdateGoods(arg0_7, arg1_7)
	if arg0_7.goods ~= arg1_7 then
		arg0_7.goods = arg1_7

		local var0_7 = underscore.filter(arg0_7.goods, function(arg0_8)
			return arg0_8.count > 0
		end)

		nowWorld():GetAtlas():UpdatePortMark(arg0_7.id, #var0_7 > 0)
		arg0_7:DispatchEvent(var0_0.EventUpdateGoods)
	end
end

function var0_0.ClearGoods(arg0_9)
	WPool:ReturnArray(arg0_9.goods)

	arg0_9.goods = {}
end

function var0_0.GetRealm(arg0_10)
	return arg0_10.config.port_camp
end

function var0_0.IsOpen(arg0_11, arg1_11, arg2_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.config.open_condition) do
		if iter1_11[1] == arg1_11 and arg2_11 >= iter1_11[2] then
			return true
		end
	end

	return false
end

function var0_0.IsTempPort(arg0_12)
	return arg0_12.config.port_camp == 0
end

return var0_0
