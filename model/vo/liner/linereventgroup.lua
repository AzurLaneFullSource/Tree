local var0_0 = class("LinerEventGroup", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.events = {}

	for iter0_1, iter1_1 in ipairs(arg0_1:GetIds()) do
		arg0_1.events[iter1_1] = LinerEvent.New(iter1_1)
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_liner_event_group
end

function var0_0.GetTitle(arg0_3)
	return HXSet.hxLan(arg0_3:getConfig("title"))
end

function var0_0.GetPic(arg0_4)
	return arg0_4:getConfig("pic")
end

function var0_0.GetEvent(arg0_5, arg1_5)
	return arg0_5.events[arg1_5]
end

function var0_0.GetEvents(arg0_6)
	return arg0_6.events
end

function var0_0.GetIds(arg0_7)
	return arg0_7:getConfig("ids")
end

function var0_0.GetEventList(arg0_8)
	local var0_8 = {}

	for iter0_8, iter1_8 in pairs(arg0_8.events) do
		table.insert(var0_8, iter1_8)
	end

	return var0_8
end

function var0_0.GetConclusions(arg0_9)
	return arg0_9:getConfig("conclusion")
end

function var0_0.GetDrop(arg0_10)
	return Drop.Create(arg0_10:getConfig("drop_display"))
end

return var0_0
