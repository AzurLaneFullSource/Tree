local var0 = class("Instagram", import("..BaseVO"))

var0.TYPE_PLAYER_COMMENT = 1
var0.TYPE_NPC_COMMENT = 2

local var1 = pg.activity_ins_language

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id

	if arg0:getConfig("is_active") == 1 then
		arg0:InitByServer(arg1)
	else
		arg0:InitByConfig(arg1)
	end

	arg0.good = arg1.good
	arg0.isLike = arg1.is_good == 1
	arg0.isRead = arg1.is_read == 1
end

function var0.InitByServer(arg0, arg1)
	arg0.text = arg1.text
	arg0.picture = arg1.picture
	arg0.time = arg1.time

	print(pg.TimeMgr.GetInstance():GetServerTime(), "------------", arg0.time)

	arg0.optionDiscuss = {}
	arg0.discussList = {}
	arg0.allReply = {}

	for iter0, iter1 in ipairs(arg1.npc_reply) do
		local var0 = {}

		for iter2, iter3 in ipairs(iter1.npc_reply) do
			table.insert(var0, iter3)
		end

		arg0.allReply[iter1.id] = {
			id = iter1.id,
			time = iter1.time,
			text = iter1.text,
			npc_reply = var0
		}
	end

	for iter4, iter5 in ipairs(arg1.player_discuss) do
		if iter5.text == "" then
			for iter6, iter7 in ipairs(iter5.text_list) do
				table.insert(arg0.optionDiscuss, 1, {
					id = iter5.id,
					index = iter6,
					text = iter7
				})
			end
		else
			table.insert(arg0.discussList, InstagramPlayerComment.New(iter5, arg0, 1))
		end
	end

	for iter8, iter9 in ipairs(arg1.npc_discuss) do
		table.insert(arg0.discussList, InstagramNpcComment.New(iter9, arg0, 1))
	end
end

function var0.InitByConfig(arg0, arg1)
	local var0 = arg0:getConfig("message_persist")

	assert(var1[var0], var0)

	arg0.text = var1[var0].value
	arg0.picture = arg0:getConfig("picture_persist")
	arg0.time = pg.TimeMgr.GetInstance():parseTimeFromConfig(arg0:getConfig("time_persist"))
	arg0.optionDiscuss = {}
	arg0.discussList = {}
	arg0.allReply = getProxy(InstagramProxy):GetAllReply()

	for iter0, iter1 in ipairs(arg1.player_discuss) do
		if iter1.text == "" then
			for iter2, iter3 in ipairs(iter1.text_list) do
				table.insert(arg0.optionDiscuss, 1, {
					id = iter1.id,
					index = iter2,
					text = iter3
				})
			end
		else
			table.insert(arg0.discussList, InstagramPlayerComment.New(iter1, arg0, 1))
		end
	end

	local var1 = arg0:getConfig("npc_discuss_persist")

	if type(var1) == "table" then
		for iter4, iter5 in ipairs(var1) do
			local var2 = arg0.allReply[iter5]

			table.insert(arg0.discussList, InstagramNpcComment.New(var2, arg0, 1))
		end
	end
end

function var0.GetLasterUpdateTime(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0.discussList) do
		local var1 = iter1:GetLasterUpdateTime()

		table.insert(var0, var1)
	end

	table.sort(var0, function(arg0, arg1)
		return arg1 < arg0
	end)

	return var0[1] or 0
end

function var0.AnyCommentUnread(arg0)
	return _.any(arg0.discussList, function(arg0)
		return arg0:AnyReplyTimeOut()
	end)
end

function var0.GetAllReply(arg0)
	return arg0.allReply
end

function var0.IsReaded(arg0)
	return arg0.isRead
end

function var0.bindConfigTable(arg0)
	return pg.activity_ins_template
end

function var0.GetIcon(arg0)
	return arg0:getConfig("sculpture")
end

function var0.GetName(arg0)
	return arg0:getConfig("name")
end

function var0.GetSortIndex(arg0)
	local var0 = arg0:bindConfigTable()

	if var0[var0.all[1]].order then
		return arg0:getConfig("order")
	else
		return 0
	end
end

function var0.GetImage(arg0)
	return arg0.picture
end

function var0.GetContent(arg0)
	return HXSet.hxLan(arg0.text)
end

function var0.GetLikeCnt(arg0)
	if arg0.good > 999 then
		return "999+"
	else
		return arg0.good
	end
end

function var0.IsLiking(arg0)
	return arg0.isLike
end

function var0.UpdateIsLike(arg0)
	arg0.isLike = 1
end

function var0.GetPushTime(arg0)
	return InstagramTimeStamp(arg0.time)
end

function var0.GetCanDisplayComments(arg0)
	local var0 = {}
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.discussList) do
		if not iter1:ShouldWaitForShow() then
			table.insert(var0, iter1)

			var1 = var1 + 1
		end
	end

	return var0, var1
end

function var0.GetFastestRefreshTime(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.discussList) do
		local var1 = iter1:GetFasterRefreshTime()

		if var1 then
			table.insert(var0, var1)
		end
	end

	if #var0 > 0 then
		table.sort(var0, function(arg0, arg1)
			return arg0 < arg1
		end)

		return var0[1]
	end
end

function var0.GetOptionComment(arg0)
	return arg0.optionDiscuss
end

function var0.CanOpenComment(arg0)
	return #arg0.optionDiscuss > 0
end

function var0.ShouldShowTip(arg0)
	return not arg0:IsReaded() or arg0:AnyCommentUnread()
end

return var0
