local var0_0 = class("LinerRoomGroup", import("model.vo.BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.configId = arg0_1.id
	arg0_1.rooms = {}

	for iter0_1, iter1_1 in ipairs(arg0_1:GetIds()) do
		arg0_1.rooms[iter1_1] = LinerRoom.New(iter1_1)
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.activity_liner_room_group
end

function var0_0.GetRoom(arg0_3, arg1_3)
	return arg0_3.rooms[arg1_3]
end

function var0_0.GetRooms(arg0_4, arg1_4)
	return arg0_4.rooms
end

function var0_0.GetIds(arg0_5)
	return arg0_5:getConfig("ids")
end

function var0_0.GetRoomList(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.rooms) do
		table.insert(var0_6, iter1_6)
	end

	return var0_6
end

function var0_0.GetDrop(arg0_7)
	return Drop.Create(arg0_7:getConfig("drop_display"))
end

return var0_0
