local var0_0 = class("InstagramComment", import("..BaseVO"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1.time = arg1_1.time
	arg0_1.text = arg1_1.text
	arg0_1.instagram = arg2_1
	arg0_1.parentComment = arg4_1
	arg0_1.id = arg1_1.id
	arg0_1.level = arg3_1 or 1
	arg0_1.isRoot = false

	if not arg0_1.parentComment then
		arg0_1.isRoot = true
	end

	arg0_1.allReply = arg2_1:GetAllReply()
	arg0_1.replyList = {}
end

function var0_0.GetLasterUpdateTime(arg0_2)
	local var0_2 = {}

	local function var1_2(arg0_3)
		if arg0_3 <= pg.TimeMgr.GetInstance():GetServerTime() then
			table.insert(var0_2, arg0_3)
		end
	end

	var1_2(arg0_2.time)

	local var2_2 = arg0_2:GetAllReplys()

	for iter0_2, iter1_2 in pairs(var2_2) do
		var1_2(iter1_2.time)
	end

	table.sort(var0_2, function(arg0_4, arg1_4)
		return arg1_4 < arg0_4
	end)

	return var0_2[1] or 0
end

function var0_0.GetName(arg0_5)
	assert(false)
end

function var0_0.GetPainting(arg0_6)
	assert(false)
end

function var0_0.GetType(arg0_7)
	assert(false)
end

function var0_0.GetFasterRefreshTime(arg0_8)
	local var0_8 = {}

	if arg0_8:ShouldWaitForShow() then
		table.insert(var0_8, arg0_8.time)
	end

	local var1_8 = arg0_8:GetAllReplys()

	for iter0_8, iter1_8 in ipairs(var1_8) do
		if iter1_8:ShouldWaitForShow() then
			table.insert(var0_8, iter1_8.time)
		end
	end

	if #var0_8 > 0 then
		table.sort(var0_8, function(arg0_9, arg1_9)
			return arg0_9 < arg1_9
		end)

		return var0_8[1]
	end
end

function var0_0.AnyReplyTimeOut(arg0_10)
	local var0_10 = arg0_10:GetAllReplys()

	return _.any(var0_10, function(arg0_11)
		return arg0_11:TimeOutAndTxtIsEmpty()
	end) or arg0_10:TimeOutAndTxtIsEmpty()
end

function var0_0.TimeOutAndTxtIsEmpty(arg0_12)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_12.time and arg0_12.text == ""
end

function var0_0.ShouldWaitForShow(arg0_13)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_13.time or arg0_13:TimeOutAndTxtIsEmpty()
end

function var0_0.GetReplyTimeOffset(arg0_14)
	local var0_14 = pg.TimeMgr.GetInstance():GetServerTime()

	return arg0_14.time - var0_14
end

function var0_0.GetReplyList(arg0_15)
	return arg0_15.replyList
end

function var0_0.GetAllReplys(arg0_16)
	local var0_16 = {}
	local var1_16

	local function var2_16(arg0_17)
		for iter0_17, iter1_17 in ipairs(arg0_17) do
			var2_16(iter1_17.replyList)
			table.insert(var0_16, iter1_17)
		end
	end

	var2_16(arg0_16.replyList)

	return var0_16
end

function var0_0.GetCanDisplayReply(arg0_18)
	local var0_18 = {}
	local var1_18 = 0
	local var2_18 = arg0_18:GetAllReplys()

	for iter0_18, iter1_18 in ipairs(var2_18) do
		if not iter1_18:ShouldWaitForShow() then
			table.insert(var0_18, iter1_18)

			var1_18 = var1_18 + 1
		end
	end

	return var0_18, var1_18
end

function var0_0.GetParentCommentName(arg0_19)
	return arg0_19.parentComment:GetName()
end

function var0_0.HasReply(arg0_20)
	local var0_20 = arg0_20:GetAllReplys()

	return _.any(var0_20, function(arg0_21)
		return not arg0_21:ShouldWaitForShow()
	end) and #var0_20 > 0
end

function var0_0.GetContent(arg0_22)
	local var0_22 = arg0_22:GetName()

	if arg0_22.isRoot then
		return string.format("<color=#000000FF>%s.</color>%s", var0_22, arg0_22.text)
	else
		local var1_22 = arg0_22:GetParentCommentName()

		return string.format("<color=#000000FF>%s.</color>%s", var0_22, arg0_22.text)
	end
end

function var0_0.GetReplyCnt(arg0_23)
	local var0_23 = 0
	local var1_23 = arg0_23:GetAllReplys()

	for iter0_23, iter1_23 in ipairs(var1_23) do
		if not iter1_23:ShouldWaitForShow() then
			var0_23 = var0_23 + 1
		end
	end

	return var0_23
end

function var0_0.GetTime(arg0_24)
	return InstagramReplyTimeStamp(arg0_24.time) .. " reply"
end

function var0_0.GetIcon(arg0_25)
	return arg0_25:GetPainting()
end

function var0_0.GetReplyBtnTxt(arg0_26)
	return "reply"
end

return var0_0
