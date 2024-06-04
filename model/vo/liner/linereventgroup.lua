local var0 = class("LinerEventGroup", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.events = {}

	for iter0, iter1 in ipairs(arg0:GetIds()) do
		arg0.events[iter1] = LinerEvent.New(iter1)
	end
end

function var0.bindConfigTable(arg0)
	return pg.activity_liner_event_group
end

function var0.GetTitle(arg0)
	return HXSet.hxLan(arg0:getConfig("title"))
end

function var0.GetPic(arg0)
	return arg0:getConfig("pic")
end

function var0.GetEvent(arg0, arg1)
	return arg0.events[arg1]
end

function var0.GetEvents(arg0)
	return arg0.events
end

function var0.GetIds(arg0)
	return arg0:getConfig("ids")
end

function var0.GetEventList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.events) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetConclusions(arg0)
	return arg0:getConfig("conclusion")
end

function var0.GetDrop(arg0)
	return Drop.Create(arg0:getConfig("drop_display"))
end

return var0
