local var0_0 = class("Dorm3dInsProxy", import(".NetProxy"))

var0_0.UNLOCK_TYPE_CHAT = 1
var0_0.UNLOCK_TYPE_PHONE = 2
var0_0.UNLOCK_TYPE_INS = 3

function var0_0.register(arg0_1)
	arg0_1.instagrams = {}
	arg0_1.insRoomList = arg0_1:BuildRoomList()
	arg0_1.insPhoneData = arg0_1:BuildPhoneData()

	arg0_1:on(28000, function(arg0_2)
		if DORM_LOCK_INS then
			return
		end

		arg0_1:HandleInsData(arg0_2.ins)
	end)
	arg0_1:on(28025, function(arg0_3)
		if DORM_LOCK_INS then
			return
		end

		for iter0_3, iter1_3 in ipairs(arg0_3.list) do
			switch(iter1_3.type, {
				[var0_0.UNLOCK_TYPE_CHAT] = function()
					getProxy(Dorm3dChatProxy):HandleAct(iter1_3)
				end,
				[var0_0.UNLOCK_TYPE_PHONE] = function()
					arg0_1:UnlockPhone(iter1_3.ship_id, iter1_3.act_id, iter1_3.time)
				end,
				[var0_0.UNLOCK_TYPE_INS] = function()
					arg0_1:UnlockInstagram(iter1_3.ship_id, iter1_3.act_id, iter1_3.time)
				end
			})
		end
	end)
end

function var0_0.HandleInsData(arg0_7, arg1_7)
	if not arg1_7 then
		return
	end

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		local var0_7 = arg0_7:BuildInstagrams(iter1_7.ship_group, iter1_7.friend_list)

		arg0_7.instagrams[iter1_7.ship_group] = var0_7

		arg0_7:ExtendPhoneData(iter1_7.ship_group, iter1_7.phone_list)
		getProxy(Dorm3dChatProxy):CreateChat(iter1_7)
	end
end

function var0_0.BuildInstagrams(arg0_8, arg1_8, arg2_8)
	local var0_8 = {}
	local var1_8 = {}

	for iter0_8, iter1_8 in ipairs(arg2_8 or {}) do
		var1_8[iter1_8.id] = iter1_8
	end

	local var2_8 = pg.dorm3d_ins_template.get_id_list_by_ship_group[arg1_8] or {}

	for iter2_8, iter3_8 in ipairs(var2_8) do
		if var1_8[iter3_8] then
			table.insert(var0_8, Instagram3Dorm.New(var1_8[iter3_8], false))
		else
			table.insert(var0_8, Instagram3Dorm.New({
				id = iter3_8
			}))
		end
	end

	return var0_8
end

function var0_0.GetInstagramList(arg0_9, arg1_9)
	return arg0_9.instagrams[arg1_9]
end

function var0_0.UnlockInstagram(arg0_10, arg1_10, arg2_10, arg3_10)
	local var0_10 = arg0_10:GetInstagramList(arg1_10)
	local var1_10 = _.detect(var0_10, function(arg0_11)
		return arg0_11.id == arg2_10
	end)

	if var1_10 then
		var1_10:Unlock(arg3_10)
	end
end

function var0_0.AnyInstagramShouldTip(arg0_12, arg1_12)
	local var0_12 = arg0_12:GetInstagramList(arg1_12)

	return _.any(var0_12, function(arg0_13)
		return arg0_13:ShouldTip()
	end)
end

function var0_0.AllInstagramShouldTip(arg0_14)
	return _.any(_.keys(arg0_14.instagrams), function(arg0_15)
		return arg0_14:AnyInstagramShouldTip(arg0_15) and arg0_14:GetRoomByGroupId(arg0_15):IsDownloaded()
	end)
end

function var0_0.BuildPhoneData(arg0_16)
	local var0_16 = {}

	for iter0_16, iter1_16 in pairs(pg.dorm3d_ins_telephone_group.get_id_list_by_ship_group) do
		local var1_16 = {}

		_.each(iter1_16, function(arg0_17)
			table.insert(var1_16, Dorm3dInsPhone.New(arg0_17))
		end)

		var0_16[iter0_16] = var1_16
	end

	return var0_16
end

function var0_0.GetPhoneListByGroup(arg0_18, arg1_18)
	return arg0_18.insPhoneData[arg1_18]
end

function var0_0.UnlockPhone(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = arg0_19:GetPhoneListByGroup(arg1_19)
	local var1_19 = _.detect(var0_19, function(arg0_20)
		return arg0_20.id == arg2_19
	end)

	if var1_19 then
		var1_19:Unlock(arg3_19)
	end
end

function var0_0.ExtendPhoneData(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21:GetPhoneListByGroup(arg1_21)

	for iter0_21, iter1_21 in ipairs(arg2_21) do
		local var1_21 = _.detect(var0_21, function(arg0_22)
			return arg0_22.id == arg2_21.id
		end)

		if var1_21 then
			var1_21:ExtendsData(iter1_21)
		end
	end
end

function var0_0.ShoudTipPhoneById(arg0_23, arg1_23)
	local var0_23 = arg0_23:GetPhoneListByGroup(arg1_23)

	if not var0_23 then
		return false
	end

	return _.any(var0_23, function(arg0_24)
		return arg0_24:ShouldTip()
	end)
end

function var0_0.AnyPhoneShouldTip(arg0_25)
	return _.any(_.keys(arg0_25.insPhoneData), function(arg0_26)
		return arg0_25:ShoudTipPhoneById(arg0_26)
	end)
end

function var0_0.BuildRoomList(arg0_27)
	local var0_27 = {}

	_.each(pg.dorm3d_rooms.all, function(arg0_28)
		if pg.dorm3d_rooms[arg0_28].type == 1 and #pg.dorm3d_rooms[arg0_28].character_pay > 0 then
			table.insert(var0_27, Dorm3dInsPublicRoom.New(arg0_28))
		elseif pg.dorm3d_rooms[arg0_28].type == 2 then
			table.insert(var0_27, Dorm3dInsCharRoom.New(arg0_28))
		end
	end)

	return var0_27
end

function var0_0.GetRoomList(arg0_29)
	return arg0_29.insRoomList
end

function var0_0.GetRoomById(arg0_30, arg1_30)
	return _.detect(arg0_30.insRoomList, function(arg0_31)
		return arg0_31.id == arg1_30
	end)
end

function var0_0.GetRoomByGroupId(arg0_32, arg1_32)
	return _.detect(arg0_32.insRoomList, function(arg0_33)
		return arg0_33:GetType() == 2 and arg0_33.groupId == arg1_32
	end)
end

return var0_0
