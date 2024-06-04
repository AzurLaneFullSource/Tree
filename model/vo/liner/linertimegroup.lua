local var0 = class("LinerTimeGroup", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.times = {}

	for iter0, iter1 in ipairs(arg0:GetIds()) do
		arg0.times[iter1] = LinerTime.New(iter1)
	end
end

function var0.bindConfigTable(arg0)
	return pg.activity_liner_time_group
end

function var0.GetTime(arg0, arg1)
	return arg0.times[arg1]
end

function var0.GetTimes(arg0)
	return arg0.times
end

function var0.GetIds(arg0)
	return arg0:getConfig("ids")
end

function var0.GetTimeList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.times) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetDrop(arg0)
	return Drop.Create(arg0:getConfig("drop_display"))
end

return var0
