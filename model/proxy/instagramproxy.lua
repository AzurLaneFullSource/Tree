local var0_0 = class("InstagramProxy", import(".NetProxy"))
local var1_0 = pg.activity_ins_language
local var2_0 = pg.activity_ins_npc_template

function var0_0.register(arg0_1)
	arg0_1.messages = {}
	arg0_1.isReqNewInstagramData = false
	arg0_1.isReqOldInstagramData = false
	arg0_1.allReply = {}

	local function var0_1(arg0_2)
		local var0_2 = arg0_2.npc_reply_persist

		if type(arg0_2.npc_reply_persist) == "string" then
			var0_2 = {}
		end

		local var1_2 = ""
		local var2_2 = pg.TimeMgr.GetInstance():GetServerTime()

		if var1_0[arg0_2.message_persist] then
			var1_2 = var1_0[arg0_2.message_persist].value
			var2_2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_2.time_persist)
		end

		return {
			id = arg0_2.id,
			time = var2_2,
			text = var1_2,
			npc_reply = var0_2
		}
	end

	for iter0_1, iter1_1 in ipairs(var2_0.all) do
		local var1_1 = var0_1(var2_0[iter1_1])

		arg0_1.allReply[iter1_1] = var1_1
	end
end

function var0_0.IsReqOldInstagramData(arg0_3)
	return arg0_3.isReqOldInstagramData
end

function var0_0.MarkOldInstagramData(arg0_4)
	arg0_4.isReqOldInstagramData = true
end

function var0_0.IsReqNewInstagramData(arg0_5)
	return arg0_5.isReqNewInstagramData
end

function var0_0.MarkNewInstagramData(arg0_6)
	arg0_6.isReqNewInstagramData = true

	arg0_6:AddInstagramTimer()
end

function var0_0.AddInstagram(arg0_7, arg1_7)
	arg0_7.messages[arg1_7.id] = arg1_7
end

function var0_0.GetAllReply(arg0_8)
	return arg0_8.allReply
end

function var0_0.GetMessages(arg0_9)
	local var0_9 = {}

	for iter0_9, iter1_9 in pairs(arg0_9.messages) do
		table.insert(var0_9, iter1_9)
	end

	return var0_9
end

function var0_0.ExistMessage(arg0_10)
	return table.getCount(arg0_10.messages) > 0
end

function var0_0.GetData(arg0_11)
	return arg0_11.messages
end

function var0_0.GetMessageById(arg0_12, arg1_12)
	return arg0_12.messages[arg1_12]
end

function var0_0.AddMessage(arg0_13, arg1_13)
	arg0_13.messages[arg1_13.id] = arg1_13
end

function var0_0.UpdateMessage(arg0_14, arg1_14)
	if not arg0_14.messages[arg1_14.id] then
		arg0_14:AddMessage(arg1_14)
	else
		arg0_14.messages[arg1_14.id] = arg1_14
	end
end

function var0_0.ShouldShowTip(arg0_15)
	local var0_15 = arg0_15:GetMessages()

	return _.any(var0_15, function(arg0_16)
		return arg0_16:ShouldShowTip()
	end)
end

function var0_0.GetNewInstagramBeginIdAndEndId()
	local var0_17 = Mathf.Infinity
	local var1_17 = Mathf.NegativeInfinity

	for iter0_17, iter1_17 in ipairs(pg.activity_ins_template.all) do
		if pg.activity_ins_template[iter1_17].is_active == 1 then
			if iter1_17 < var0_17 then
				var0_17 = iter1_17
			end

			if var1_17 < iter1_17 then
				var1_17 = iter1_17
			end
		end
	end

	return var0_17, var1_17
end

function var0_0.GetOldInstagramIds()
	local var0_18 = {}

	for iter0_18, iter1_18 in ipairs(pg.activity_ins_template.all) do
		if pg.activity_ins_template[iter1_18].is_active == 0 then
			table.insert(var0_18, iter1_18)
		end
	end

	return var0_18
end

function var0_0.GetNextPushTime(arg0_19)
	local var0_19 = pg.activity_ins_template.all

	for iter0_19, iter1_19 in ipairs(var0_19) do
		local var1_19 = pg.activity_ins_template[iter1_19]

		if var1_19.is_active == 1 and arg0_19:GetMessageById(iter1_19) == nil then
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(var1_19.time), iter1_19
		end
	end
end

function var0_0.AddInstagramTimer(arg0_20, arg1_20)
	arg0_20:RemoveInstagramTimer()

	local var0_20, var1_20 = arg0_20:GetNextPushTime()

	if not var0_20 then
		return
	end

	local var2_20 = var0_20 - pg.TimeMgr.GetInstance():GetServerTime() + math.Random(1, 3)

	local function var3_20()
		pg.m02:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
			arg1 = var1_20
		})
	end

	if var2_20 <= 0 then
		var3_20()

		return
	end

	arg0_20.timer = Timer.New(function()
		arg0_20:RemoveInstagramTimer()
		var3_20()
	end, var2_20, 1)

	arg0_20.timer:Start()
end

function var0_0.RemoveInstagramTimer(arg0_23)
	if arg0_23.timer then
		arg0_23.timer:Stop()

		arg0_23.timer = nil
	end
end

function var0_0.remove(arg0_24)
	arg0_24.isReqNewInstagramData = false

	arg0_24:RemoveInstagramTimer()
end

return var0_0
