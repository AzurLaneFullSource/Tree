local var0_0 = class("Dorm3dInsPublicRoom", import(".Dorm3dInsRoom"))

function var0_0.GetWelcomeCharList(arg0_1)
	local var0_1 = _.map(arg0_1:GetConfig("character_welcome"), function(arg0_2)
		return arg0_2[1]
	end)
	local var1_1 = getProxy(ApartmentProxy):getRoom(arg0_1.id)
	local var2_1 = var1_1 and _.select(var0_1, function(arg0_3)
		return var1_1.unlockCharacter[arg0_3]
	end) or {}
	local var3_1 = _.map(var0_1, function(arg0_4)
		return _.detect(pg.dorm3d_rooms.all, function(arg0_5)
			return pg.dorm3d_rooms[arg0_5].type == 2 and pg.dorm3d_rooms[arg0_5].character[1] == arg0_4
		end)
	end)

	return var0_1, var2_1, var3_1
end

function var0_0.GetFurnitureNum(arg0_6)
	return
end

function var0_0.GetCard(arg0_7)
	return string.format("dorm3dselect/room_ins_%s", string.lower(arg0_7:GetConfig("assets_prefix")))
end

function var0_0.IsCare(arg0_8)
	return false
end

function var0_0.GetDesc(arg0_9)
	return arg0_9:GetConfig("room_des")
end

function var0_0.ShouldTip(arg0_10)
	return false
end

return var0_0
