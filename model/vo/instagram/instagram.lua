local var0_0 = class("Instagram", import("..BaseVO"))

var0_0.TYPE_PLAYER_COMMENT = 1
var0_0.TYPE_NPC_COMMENT = 2

local var1_0 = pg.activity_ins_language

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id

	if arg0_1:getConfig("is_active") == 1 then
		arg0_1:InitByServer(arg1_1)
	else
		arg0_1:InitByConfig(arg1_1)
	end

	arg0_1.good = arg1_1.good
	arg0_1.isLike = arg1_1.is_good == 1
	arg0_1.isRead = arg1_1.is_read == 1
end

function var0_0.InitByServer(arg0_2, arg1_2)
	arg0_2.text = arg1_2.text
	arg0_2.picture = arg1_2.picture
	arg0_2.time = arg1_2.time

	print(pg.TimeMgr.GetInstance():GetServerTime(), "------------", arg0_2.time)

	arg0_2.optionDiscuss = {}
	arg0_2.discussList = {}
	arg0_2.allReply = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.npc_reply) do
		local var0_2 = {}

		for iter2_2, iter3_2 in ipairs(iter1_2.npc_reply) do
			table.insert(var0_2, iter3_2)
		end

		arg0_2.allReply[iter1_2.id] = {
			id = iter1_2.id,
			time = iter1_2.time,
			text = iter1_2.text,
			npc_reply = var0_2
		}
	end

	for iter4_2, iter5_2 in ipairs(arg1_2.player_discuss) do
		if iter5_2.text == "" then
			for iter6_2, iter7_2 in ipairs(iter5_2.text_list) do
				table.insert(arg0_2.optionDiscuss, 1, {
					id = iter5_2.id,
					index = iter6_2,
					text = iter7_2
				})
			end
		else
			table.insert(arg0_2.discussList, InstagramPlayerComment.New(iter5_2, arg0_2, 1))
		end
	end

	for iter8_2, iter9_2 in ipairs(arg1_2.npc_discuss) do
		table.insert(arg0_2.discussList, InstagramNpcComment.New(iter9_2, arg0_2, 1))
	end
end

function var0_0.InitByConfig(arg0_3, arg1_3)
	local var0_3 = arg0_3:getConfig("message_persist")

	assert(var1_0[var0_3], var0_3)

	arg0_3.text = var1_0[var0_3].value
	arg0_3.picture = arg0_3:getConfig("picture_persist")
	arg0_3.time = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0_3:getConfig("time_persist"))
	arg0_3.optionDiscuss = {}
	arg0_3.discussList = {}
	arg0_3.allReply = getProxy(InstagramProxy):GetAllReply()

	for iter0_3, iter1_3 in ipairs(arg1_3.player_discuss) do
		if iter1_3.text == "" then
			for iter2_3, iter3_3 in ipairs(iter1_3.text_list) do
				table.insert(arg0_3.optionDiscuss, 1, {
					id = iter1_3.id,
					index = iter2_3,
					text = iter3_3
				})
			end
		else
			table.insert(arg0_3.discussList, InstagramPlayerComment.New(iter1_3, arg0_3, 1))
		end
	end

	local var1_3 = arg0_3:getConfig("npc_discuss_persist")

	if type(var1_3) == "table" then
		for iter4_3, iter5_3 in ipairs(var1_3) do
			local var2_3 = arg0_3.allReply[iter5_3]

			table.insert(arg0_3.discussList, InstagramNpcComment.New(var2_3, arg0_3, 1))
		end
	end
end

function var0_0.GetLasterUpdateTime(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.discussList) do
		local var1_4 = iter1_4:GetLasterUpdateTime()

		table.insert(var0_4, var1_4)
	end

	table.sort(var0_4, function(arg0_5, arg1_5)
		return arg1_5 < arg0_5
	end)

	return var0_4[1] or 0
end

function var0_0.AnyCommentUnread(arg0_6)
	return _.any(arg0_6.discussList, function(arg0_7)
		return arg0_7:AnyReplyTimeOut()
	end)
end

function var0_0.GetAllReply(arg0_8)
	return arg0_8.allReply
end

function var0_0.IsReaded(arg0_9)
	return arg0_9.isRead
end

function var0_0.bindConfigTable(arg0_10)
	return pg.activity_ins_template
end

function var0_0.GetIcon(arg0_11)
	return arg0_11:getConfig("sculpture")
end

function var0_0.GetName(arg0_12)
	return arg0_12:getConfig("name")
end

function var0_0.GetSortIndex(arg0_13)
	local var0_13 = arg0_13:bindConfigTable()

	if var0_13[var0_13.all[1]].order then
		return arg0_13:getConfig("order")
	else
		return 0
	end
end

function var0_0.GetImage(arg0_14)
	return arg0_14.picture
end

function var0_0.GetContent(arg0_15)
	return HXSet.hxLan(arg0_15.text)
end

function var0_0.GetLikeCnt(arg0_16)
	if arg0_16.good > 999 then
		return "999+"
	else
		return arg0_16.good
	end
end

function var0_0.IsLiking(arg0_17)
	return arg0_17.isLike
end

function var0_0.UpdateIsLike(arg0_18)
	arg0_18.isLike = 1
end

function var0_0.GetPushTime(arg0_19)
	return InstagramTimeStamp(arg0_19.time)
end

function var0_0.GetCanDisplayComments(arg0_20)
	local var0_20 = {}
	local var1_20 = 0

	for iter0_20, iter1_20 in ipairs(arg0_20.discussList) do
		if not iter1_20:ShouldWaitForShow() then
			table.insert(var0_20, iter1_20)

			var1_20 = var1_20 + 1
		end
	end

	return var0_20, var1_20
end

function var0_0.GetFastestRefreshTime(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.discussList) do
		local var1_21 = iter1_21:GetFasterRefreshTime()

		if var1_21 then
			table.insert(var0_21, var1_21)
		end
	end

	if #var0_21 > 0 then
		table.sort(var0_21, function(arg0_22, arg1_22)
			return arg0_22 < arg1_22
		end)

		return var0_21[1]
	end
end

function var0_0.GetOptionComment(arg0_23)
	return arg0_23.optionDiscuss
end

function var0_0.CanOpenComment(arg0_24)
	return #arg0_24.optionDiscuss > 0
end

function var0_0.ShouldShowTip(arg0_25)
	return not arg0_25:IsReaded() or arg0_25:AnyCommentUnread()
end

return var0_0
