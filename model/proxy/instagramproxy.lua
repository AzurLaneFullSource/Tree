local var0 = class("InstagramProxy", import(".NetProxy"))
local var1 = pg.activity_ins_language
local var2 = pg.activity_ins_npc_template

function var0.register(arg0)
	arg0.caches = {}
	arg0.messages = {}
	arg0.allReply = {}

	local function var0(arg0)
		local var0 = arg0.npc_reply_persist

		if type(arg0.npc_reply_persist) == "string" then
			var0 = {}
		end

		local var1 = ""
		local var2 = pg.TimeMgr.GetInstance():GetServerTime()

		if var1[arg0.message_persist] then
			var1 = var1[arg0.message_persist].value
			var2 = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0.time_persist)
		end

		return {
			id = arg0.id,
			time = var2,
			text = var1,
			npc_reply = var0
		}
	end

	for iter0, iter1 in ipairs(var2.all) do
		local var1 = var0(var2[iter1])

		arg0.allReply[iter1] = var1
	end

	arg0:on(11700, function(arg0)
		for iter0, iter1 in ipairs(arg0.ins_message_list) do
			if pg.activity_ins_template[iter1.id].is_active == 1 then
				local var0 = Instagram.New(iter1)

				arg0.messages[var0.id] = var0
			else
				table.insert(arg0.caches, iter1)
			end
		end
	end)
end

function var0.GetAllReply(arg0)
	return arg0.allReply
end

function var0.InitLocalConfigs(arg0)
	if #arg0.caches > 0 then
		for iter0, iter1 in ipairs(arg0.caches) do
			local var0 = Instagram.New(iter1)

			arg0.messages[var0.id] = var0
		end
	end

	arg0.caches = {}
end

function var0.GetMessages(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.messages) do
		table.insert(var0, iter1)
	end

	return var0
end

function var0.ExistMessage(arg0)
	return table.getCount(arg0.messages) > 0
end

function var0.GetData(arg0)
	return arg0.messages
end

function var0.GetMessageById(arg0, arg1)
	return arg0.messages[arg1]
end

function var0.AddMessage(arg0, arg1)
	arg0.messages[arg1.id] = arg1
end

function var0.UpdateMessage(arg0, arg1)
	if not arg0.messages[arg1.id] then
		arg0:AddMessage(arg1)
	else
		arg0.messages[arg1.id] = arg1
	end
end

function var0.ShouldShowTip(arg0)
	local var0 = arg0:GetMessages()

	return _.any(var0, function(arg0)
		return arg0:ShouldShowTip()
	end)
end

function var0.ExistMsg(arg0)
	return arg0.messages and table.getCount(arg0.messages) > 0 or arg0.caches and #arg0.caches > 0
end

function var0.ExistGroup(arg0, arg1)
	for iter0, iter1 in pairs(arg0.messages) do
		if iter1:getConfig("group_id") == arg1 then
			return true
		end
	end

	return false
end

return var0
