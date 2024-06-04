local var0 = class("LinerRoomGroup", import("model.vo.BaseVO"))

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg0.id
	arg0.rooms = {}

	for iter0, iter1 in ipairs(arg0:GetIds()) do
		arg0.rooms[iter1] = LinerRoom.New(iter1)
	end
end

function var0.bindConfigTable(arg0)
	return pg.activity_liner_room_group
end

function var0.GetRoom(arg0, arg1)
	return arg0.rooms[arg1]
end

function var0.GetRooms(arg0, arg1)
	return arg0.rooms
end

function var0.GetIds(arg0)
	return arg0:getConfig("ids")
end

function var0.GetRoomList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.rooms) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.GetDrop(arg0)
	return Drop.Create(arg0:getConfig("drop_display"))
end

return var0
