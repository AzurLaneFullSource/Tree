local var0_0 = class("InstagramProxy", import(".NetProxy"))
local var1_0 = pg.activity_ins_language
local var2_0 = pg.activity_ins_npc_template

function var0_0.register(arg0_1)
	arg0_1.messages = {}
	arg0_1.officialAccounts = {}
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
	if arg1_7:getConfig("type") == InstagramConst.INSTAGRAM_TYPE.OFFICIAL_ACCOUNT then
		arg0_7:AddOfficialAccounts(arg1_7)
	else
		arg0_7.messages[arg1_7.id] = arg1_7
	end
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

function var0_0.UpdateMessage(arg0_13, arg1_13)
	if arg1_13:getConfig("type") == InstagramConst.INSTAGRAM_TYPE.OFFICIAL_ACCOUNT then
		arg0_13:UpdateOfficialAccounts(arg1_13)
	elseif not arg0_13.messages[arg1_13.id] then
		arg0_13:AddInstagram(arg1_13)
	else
		arg0_13.messages[arg1_13.id] = arg1_13
	end
end

function var0_0.AddOfficialAccounts(arg0_14, arg1_14)
	arg0_14.officialAccounts[arg1_14.id] = arg1_14
end

function var0_0.UpdateOfficialAccounts(arg0_15, arg1_15)
	if not arg0_15.officialAccounts[arg1_15.id] then
		arg0_15:AddOfficialAccounts(arg1_15)
	else
		arg0_15.officialAccounts[arg1_15.id] = arg1_15
	end
end

function var0_0.GetOfficialAccounts(arg0_16)
	return arg0_16.officialAccounts
end

function var0_0.ShouldShowOfficialAccountsTip(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.officialAccounts) do
		if iter1_17:ShouldShowTip() then
			return true
		end
	end
end

function var0_0.ShouldShowTip(arg0_18)
	local var0_18 = arg0_18:GetMessages()

	return _.any(var0_18, function(arg0_19)
		return arg0_19:ShouldShowTip()
	end)
end

function var0_0.GetNewInstagramIds()
	local var0_20 = {}

	for iter0_20, iter1_20 in ipairs(pg.activity_ins_template.all) do
		if pg.activity_ins_template[iter1_20].is_active == 1 or pg.activity_ins_template[iter1_20].type == InstagramConst.INSTAGRAM_TYPE.OFFICIAL_ACCOUNT then
			table.insert(var0_20, iter1_20)
		end
	end

	return var0_20
end

function var0_0.GetOldInstagramIds()
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(pg.activity_ins_template.all) do
		if pg.activity_ins_template[iter1_21].is_active == 0 then
			table.insert(var0_21, iter1_21)
		end
	end

	return var0_21
end

function var0_0.GetNextPushTime(arg0_22)
	local var0_22 = pg.activity_ins_template.all
	local var1_22
	local var2_22

	for iter0_22, iter1_22 in ipairs(var0_22) do
		local var3_22 = pg.activity_ins_template[iter1_22]

		if var3_22.type == InstagramConst.INSTAGRAM_TYPE.OFFICIAL_ACCOUNT then
			if arg0_22.officialAccounts[iter1_22] == nil then
				local var4_22 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var3_22.time)

				if var1_22 == nil then
					var1_22 = var4_22
					var2_22 = iter1_22
				elseif var4_22 < var1_22 then
					var1_22 = var4_22
					var2_22 = iter1_22
				end
			end
		elseif var3_22.is_active == 1 and arg0_22:GetMessageById(iter1_22) == nil then
			local var5_22 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var3_22.time)

			if var1_22 == nil then
				var1_22 = var5_22
				var2_22 = iter1_22
			elseif var5_22 < var1_22 then
				var1_22 = var5_22
				var2_22 = iter1_22
			end
		end
	end

	return var1_22, var2_22
end

function var0_0.AddInstagramTimer(arg0_23)
	arg0_23:RemoveInstagramTimer()

	local var0_23, var1_23 = arg0_23:GetNextPushTime()

	if not var0_23 then
		return
	end

	local var2_23 = var0_23 - pg.TimeMgr.GetInstance():GetServerTime() + math.Random(1, 3)

	local function var3_23()
		pg.m02:sendNotification(GAME.ACT_INSTAGRAM_OP, {
			cmd = ActivityConst.INSTAGRAM_OP_ACTIVE,
			arg1 = var1_23
		})
	end

	if var2_23 <= 0 then
		var3_23()

		return
	end

	arg0_23:RemoveInstagramTimer()

	arg0_23.timer = Timer.New(function()
		arg0_23:RemoveInstagramTimer()
		var3_23()
	end, var2_23, 1)

	arg0_23.timer:Start()
end

function var0_0.RemoveInstagramTimer(arg0_26)
	if arg0_26.timer then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end
end

function var0_0.remove(arg0_27)
	arg0_27.isReqNewInstagramData = false

	arg0_27:RemoveInstagramTimer()
end

return var0_0
