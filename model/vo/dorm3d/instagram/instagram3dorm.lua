local var0_0 = class("Instagram3Dorm", import("...BaseVO"))

var0_0.OP_DISCUSS = 2
var0_0.OP_READ = 3
var0_0.OP_LIKE = 4
var0_0.OP_SHARE = 5
var0_0.OP_EXIT = 6

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.time = arg1_1.time or 0
	arg0_1.isRead = defaultValue(arg1_1.read_flag, 0) == 1
	arg0_1.isGood = defaultValue(arg1_1.good_flag, 0) == 1
	arg0_1.isLock = defaultValue(arg2_1, true)
	arg0_1.exitTime = arg1_1.exit_time or 0

	local var0_1 = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.reply_list or {}) do
		if not var0_1[iter1_1.key] then
			var0_1[iter1_1.key] = {}
		end

		table.insert(var0_1[iter1_1.key], {
			index = iter1_1.value,
			time = iter1_1.time
		})
	end

	arg0_1.replyedList = arg0_1:BuildReplyedList(var0_1)
	arg0_1.replyableList = arg0_1:BuildReplyableList(var0_1)
	arg0_1.unlockDesc = arg0_1.isLock and arg0_1:BuildUnlockDesc() or ""
end

function var0_0.BuildUnlockDesc(arg0_2)
	local var0_2 = pg.dorm3d_ins_unlock.get_id_list_by_type[Dorm3dInsProxy.UNLOCK_TYPE_INS] or {}
	local var1_2 = _.detect(var0_2, function(arg0_3)
		return pg.dorm3d_ins_unlock[arg0_3].content == arg0_2.configId
	end)

	if not var1_2 then
		return ""
	end

	local var2_2 = pg.dorm3d_ins_unlock[var1_2].text

	return (HXSet.hxLan(var2_2))
end

function var0_0.GetUnLockConditionDesc(arg0_4)
	return arg0_4.unlockDesc
end

function var0_0.IsLock(arg0_5)
	return arg0_5.isLock
end

function var0_0.Unlock(arg0_6, arg1_6)
	arg0_6.isLock = false
	arg0_6.time = arg1_6
end

function var0_0.GetReplyedList(arg0_7)
	return arg0_7.replyedList
end

function var0_0.ExistAnyReplyable(arg0_8)
	return #arg0_8.replyableList > 0
end

function var0_0.GetReplyableList(arg0_9)
	return arg0_9.replyableList
end

function var0_0.MarkReply(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.replyableList
	local var1_10

	for iter0_10 = #var0_10, 1, -1 do
		if var0_10[iter0_10].id == arg1_10 then
			table.remove(var0_10, iter0_10)
		end
	end

	local var2_10 = pg.TimeMgr.GetInstance():GetServerTime()
	local var3_10 = arg0_10:BuildPlayerComment(arg1_10, arg2_10, var2_10)

	table.insert(arg0_10.replyedList, var3_10)
end

function var0_0.BuildPlayerComment(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = pg.dorm3d_ins_player_template[arg1_11]
	local var1_11 = var0_11.message[arg2_11]
	local var2_11 = var0_11.npc_reply[arg2_11]

	return InstagramPlayerComment3Dorm.New(arg1_11, arg2_11, 10000, var1_11, arg3_11, {
		var2_11
	})
end

function var0_0.BuildReplyedList(arg0_12, arg1_12)
	local var0_12 = {}
	local var1_12 = pg.dorm3d_ins_player_template

	for iter0_12, iter1_12 in pairs(arg1_12) do
		for iter2_12, iter3_12 in ipairs(iter1_12) do
			local var2_12 = arg0_12:BuildPlayerComment(iter0_12, iter3_12.index, iter3_12.time)

			table.insert(var0_12, var2_12)
		end
	end

	local var3_12 = arg0_12:getConfig("npc_discuss")
	local var4_12 = InstagramComment3Dorm.BuildNpcReplayList(var3_12, arg0_12.time)

	for iter4_12, iter5_12 in ipairs(var4_12) do
		table.insert(var0_12, iter5_12)
	end

	return var0_12
end

function var0_0.BuildReplyableList(arg0_13, arg1_13)
	local var0_13 = {}
	local var1_13 = pg.dorm3d_ins_player_template

	for iter0_13, iter1_13 in pairs(arg0_13:getConfig("discuss")) do
		if not arg1_13[iter1_13] then
			local var2_13 = var1_13[iter1_13]

			for iter2_13, iter3_13 in ipairs(var2_13.message) do
				local var3_13 = pg.TimeMgr.GetInstance():GetServerTime()
				local var4_13 = arg0_13:BuildPlayerComment(iter1_13, iter2_13, var3_13)

				table.insert(var0_13, var4_13)
			end
		end
	end

	return var0_13
end

function var0_0.bindConfigTable(arg0_14)
	return pg.dorm3d_ins_template
end

function var0_0.GetBackground(arg0_15)
	return arg0_15:getConfig("background")
end

function var0_0.IsRead(arg0_16)
	return arg0_16.isRead
end

function var0_0.IsGood(arg0_17)
	return arg0_17.isGood
end

function var0_0.GetText(arg0_18)
	local var0_18 = arg0_18:getConfig("message")
	local var1_18 = pg.dorm3d_ins_language[var0_18].value

	return (HXSet.hxLan(var1_18))
end

function var0_0.GetPicture(arg0_19)
	return arg0_19:getConfig("picture")
end

function var0_0.GetName(arg0_20)
	return arg0_20:getConfig("name")
end

function var0_0.GetIcon(arg0_21)
	return arg0_21:getConfig("sculpture")
end

function var0_0.GetPushTime(arg0_22)
	return InstagramTimeStamp(arg0_22.time)
end

function var0_0.LockState(arg0_23)
	return arg0_23.isLock and 0 or 1
end

function var0_0.MarkRead(arg0_24)
	arg0_24.isRead = true
end

function var0_0.MarkLike(arg0_25)
	arg0_25.isGood = true
end

function var0_0.CanShow(arg0_26)
	return true
end

function var0_0.SetExitTime(arg0_27, arg1_27)
	arg0_27.exitTime = arg1_27
end

function var0_0.ShouldTip(arg0_28)
	if arg0_28:IsLock() or not arg0_28:CanShow() then
		return false
	end

	if not arg0_28:IsRead() then
		return true
	end

	if _.any(arg0_28.replyedList, function(arg0_29)
		return arg0_29:CanShow() and arg0_29:ShouldTip(arg0_28.exitTime)
	end) then
		return true
	end

	return false
end

return var0_0
