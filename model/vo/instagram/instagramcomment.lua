local var0 = class("InstagramComment", import("..BaseVO"))

function var0.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0.time = arg1.time
	arg0.text = arg1.text
	arg0.instagram = arg2
	arg0.parentComment = arg4
	arg0.id = arg1.id
	arg0.level = arg3 or 1
	arg0.isRoot = false

	if not arg0.parentComment then
		arg0.isRoot = true
	end

	arg0.allReply = arg2:GetAllReply()
	arg0.replyList = {}
end

function var0.GetLasterUpdateTime(arg0)
	local var0 = {}

	local function var1(arg0)
		if arg0 <= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0, arg0)
		end
	end

	var1(arg0.time)

	local var2 = arg0:GetAllReplys()

	for iter0, iter1 in pairs(var2) do
		var1(iter1.time)
	end

	table.sort(var0, function(arg0, arg1)
		return arg1 < arg0
	end)

	return var0[1] or 0
end

function var0.GetName(arg0)
	assert(false)
end

function var0.GetPainting(arg0)
	assert(false)
end

function var0.GetType(arg0)
	assert(false)
end

function var0.GetFasterRefreshTime(arg0)
	local var0 = {}

	if arg0:ShouldWaitForShow() then
		table.insert(var0, arg0.time)
	end

	local var1 = arg0:GetAllReplys()

	for iter0, iter1 in ipairs(var1) do
		if iter1:ShouldWaitForShow() then
			table.insert(var0, iter1.time)
		end
	end

	if #var0 > 0 then
		table.sort(var0, function(arg0, arg1)
			return arg0 < arg1
		end)

		return var0[1]
	end
end

function var0.AnyReplyTimeOut(arg0)
	local var0 = arg0:GetAllReplys()

	return _.any(var0, function(arg0)
		return arg0:TimeOutAndTxtIsEmpty()
	end) or arg0:TimeOutAndTxtIsEmpty()
end

function var0.TimeOutAndTxtIsEmpty(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.time and arg0.text == ""
end

function var0.ShouldWaitForShow(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0.time or arg0:TimeOutAndTxtIsEmpty()
end

function var0.GetReplyTimeOffset(arg0)
	local var0 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0.time - var0
end

function var0.GetReplyList(arg0)
	return arg0.replyList
end

function var0.GetAllReplys(arg0)
	local var0 = {}
	local var1

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			var2(iter1.replyList)
			table.insert(var0, iter1)
		end
	end

	var2(arg0.replyList)

	return var0
end

function var0.GetCanDisplayReply(arg0)
	local var0 = {}
	local var1 = 0
	local var2 = arg0:GetAllReplys()

	for iter0, iter1 in ipairs(var2) do
		if not iter1:ShouldWaitForShow() then
			table.insert(var0, iter1)

			var1 = var1 + 1
		end
	end

	return var0, var1
end

function var0.GetParentCommentName(arg0)
	return arg0.parentComment:GetName()
end

function var0.HasReply(arg0)
	local var0 = arg0:GetAllReplys()

	return _.any(var0, function(arg0)
		return not arg0:ShouldWaitForShow()
	end) and #var0 > 0
end

function var0.GetContent(arg0)
	local var0 = arg0:GetName()

	if arg0.isRoot then
		return string.format("<color=#000000FF>%s.</color>%s", var0, arg0.text)
	else
		local var1 = arg0:GetParentCommentName()

		return string.format("<color=#000000FF>%s.</color>%s", var0, arg0.text)
	end
end

function var0.GetReplyCnt(arg0)
	local var0 = 0
	local var1 = arg0:GetAllReplys()

	for iter0, iter1 in ipairs(var1) do
		if not iter1:ShouldWaitForShow() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var0.GetTime(arg0)
	return InstagramReplyTimeStamp(arg0.time) .. " reply"
end

function var0.GetIcon(arg0)
	return arg0:GetPainting()
end

function var0.GetReplyBtnTxt(arg0)
	return "reply"
end

return var0
