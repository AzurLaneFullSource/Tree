local var0_0 = class("InstagramProxy", import(".NetProxy"))
local var1_0 = pg.activity_ins_language
local var2_0 = pg.activity_ins_npc_template

function var0_0.register(arg0_1)
	arg0_1.caches = {}
	arg0_1.messages = {}
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

	arg0_1:on(11700, function(arg0_3)
		for iter0_3, iter1_3 in ipairs(arg0_3.ins_message_list) do
			if pg.activity_ins_template[iter1_3.id].is_active == 1 then
				local var0_3 = Instagram.New(iter1_3)

				arg0_1.messages[var0_3.id] = var0_3
			else
				table.insert(arg0_1.caches, iter1_3)
			end
		end
	end)
end

function var0_0.GetAllReply(arg0_4)
	return arg0_4.allReply
end

function var0_0.InitLocalConfigs(arg0_5)
	if #arg0_5.caches > 0 then
		for iter0_5, iter1_5 in ipairs(arg0_5.caches) do
			local var0_5 = Instagram.New(iter1_5)

			arg0_5.messages[var0_5.id] = var0_5
		end
	end

	arg0_5.caches = {}
end

function var0_0.GetMessages(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6.messages) do
		table.insert(var0_6, iter1_6)
	end

	return var0_6
end

function var0_0.ExistMessage(arg0_7)
	return table.getCount(arg0_7.messages) > 0
end

function var0_0.GetData(arg0_8)
	return arg0_8.messages
end

function var0_0.GetMessageById(arg0_9, arg1_9)
	return arg0_9.messages[arg1_9]
end

function var0_0.AddMessage(arg0_10, arg1_10)
	arg0_10.messages[arg1_10.id] = arg1_10
end

function var0_0.UpdateMessage(arg0_11, arg1_11)
	if not arg0_11.messages[arg1_11.id] then
		arg0_11:AddMessage(arg1_11)
	else
		arg0_11.messages[arg1_11.id] = arg1_11
	end
end

function var0_0.ShouldShowTip(arg0_12)
	local var0_12 = arg0_12:GetMessages()

	return _.any(var0_12, function(arg0_13)
		return arg0_13:ShouldShowTip()
	end)
end

function var0_0.ExistMsg(arg0_14)
	return arg0_14.messages and table.getCount(arg0_14.messages) > 0 or arg0_14.caches and #arg0_14.caches > 0
end

function var0_0.ExistGroup(arg0_15, arg1_15)
	for iter0_15, iter1_15 in pairs(arg0_15.messages) do
		if iter1_15:getConfig("group_id") == arg1_15 then
			return true
		end
	end

	return false
end

return var0_0
