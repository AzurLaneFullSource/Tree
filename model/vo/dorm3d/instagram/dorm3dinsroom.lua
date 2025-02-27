local var0_0 = class("Dorm3dInsRoom")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1
	arg0_1.roomConfigs = pg.dorm3d_rooms[arg1_1]
end

function var0_0.GetType(arg0_2)
	return arg0_2:GetConfig("type")
end

function var0_0.GetInMap(arg0_3)
	return arg0_3:GetConfig("in_map")
end

function var0_0.GetConfig(arg0_4, arg1_4)
	return arg0_4.roomConfigs[arg1_4]
end

function var0_0.GetIcon(arg0_5)
	return string.format("dorm3dselect/room_icon_%s", string.lower(arg0_5:GetConfig("assets_prefix")))
end

function var0_0.IsDownloaded(arg0_6)
	local var0_6 = getProxy(ApartmentProxy):getRoom(arg0_6.id)

	if not var0_6 then
		return false
	end

	return not var0_6:needDownload()
end

function var0_0.GetCard(arg0_7)
	return
end

function var0_0.IsCare(arg0_8)
	return
end

function var0_0.ShouldTip(arg0_9)
	return
end

return var0_0
