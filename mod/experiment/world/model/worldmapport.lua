local var0 = class("WorldMapPort", import("...BaseEntity"))

var0.Fields = {
	config = "table",
	zeroHourTime = "number",
	goods = "table",
	taskIds = "table",
	id = "number",
	expiredTime = "number"
}
var0.EventUpdateTaskIds = "WorldMapPort.UpdateTaskIds"
var0.EventUpdateGoods = "WorldMapPort.EventUpdateGoods"

function var0.Build(arg0)
	arg0.taskIds = {}
	arg0.goods = {}
end

function var0.Setup(arg0, arg1)
	arg0.id = arg1
	arg0.config = pg.world_port_data[arg0.id]

	assert(arg0.config, "world_port_data not exist: " .. arg0.id)
end

function var0.Dispose(arg0)
	arg0:ClearGoods()
	arg0:Clear()
end

function var0.IsValid(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.expiredTime and var0 <= arg0.expiredTime and arg0.zeroHourTime and var0 <= arg0.zeroHourTime
end

function var0.UpdateExpiredTime(arg0, arg1)
	arg0.expiredTime = arg1
	arg0.zeroHourTime = pg.TimeMgr.GetInstance():GetNextTime(0, 0, 0)
end

function var0.UpdateTaskIds(arg0, arg1)
	if arg0.taskIds ~= arg1 then
		arg0.taskIds = arg1

		arg0:DispatchEvent(var0.EventUpdateTaskIds)
	end
end

function var0.UpdateGoods(arg0, arg1)
	if arg0.goods ~= arg1 then
		arg0.goods = arg1

		local var0 = underscore.filter(arg0.goods, function(arg0)
			return arg0.count > 0
		end)

		nowWorld():GetAtlas():UpdatePortMark(arg0.id, #var0 > 0)
		arg0:DispatchEvent(var0.EventUpdateGoods)
	end
end

function var0.ClearGoods(arg0)
	WPool:ReturnArray(arg0.goods)

	arg0.goods = {}
end

function var0.GetRealm(arg0)
	return arg0.config.port_camp
end

function var0.IsOpen(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.config.open_condition) do
		if iter1[1] == arg1 and arg2 >= iter1[2] then
			return true
		end
	end

	return false
end

function var0.IsTempPort(arg0)
	return arg0.config.port_camp == 0
end

return var0
