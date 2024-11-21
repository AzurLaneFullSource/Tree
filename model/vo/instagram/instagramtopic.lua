local var0_0 = class("InstagramTopic", import("..BaseVO"))
local var1_0 = pg.activity_ins_chat_language

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.topicConfig = arg1_1
	arg0_1.topicId = arg1_1.id
	arg0_1.characterId = arg1_1.ship_group
	arg0_1.name = arg1_1.name
	arg0_1.unlockDesc = arg1_1.unlock_desc
	arg0_1.triggerType = arg1_1.trigger_type
	arg0_1.triggerParam = arg1_1.trigger_param
	arg0_1.content = arg1_1.content

	arg0_1:SetWordList()

	arg0_1.operationTime = nil
	arg0_1.readFlag = 1
	arg0_1.replyList = nil

	if arg2_1 then
		arg0_1.active = true
		arg0_1.operationTime = arg2_1.op_time
		arg0_1.readFlag = arg2_1.read_flag
		arg0_1.replyList = arg2_1.reply_list

		arg0_1:SetDisplayWordList()
	else
		arg0_1.active = false
	end
end

function var0_0.SetWordList(arg0_2)
	arg0_2.wordList = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.content) do
		table.insert(arg0_2.wordList, var1_0[iter1_2])
	end
end

function var0_0.SetDisplayWordList(arg0_3)
	arg0_3.displayWordList = {}
	arg0_3.replyValues = {}

	if arg0_3.replyList ~= nil and #arg0_3.replyList > 0 then
		local var0_3 = arg0_3.replyList[#arg0_3.replyList].key

		for iter0_3, iter1_3 in ipairs(arg0_3.replyList) do
			table.insert(arg0_3.replyValues, iter1_3.value)
		end

		local var1_3 = 999

		for iter2_3, iter3_3 in ipairs(arg0_3.wordList) do
			if iter3_3.flag == 0 or _.contains(arg0_3.replyValues, iter3_3.flag) then
				table.insert(arg0_3.displayWordList, iter3_3)
			end

			if iter3_3.id == var0_3 then
				var1_3 = iter2_3
			end

			if (iter3_3.flag == 0 or _.contains(arg0_3.replyValues, iter3_3.flag)) and iter3_3.option ~= "" and var1_3 < iter2_3 then
				break
			end
		end
	else
		for iter4_3, iter5_3 in ipairs(arg0_3.wordList) do
			table.insert(arg0_3.displayWordList, iter5_3)

			if iter5_3.option ~= "" then
				break
			end
		end
	end
end

function var0_0.GetDisplayWordList(arg0_4)
	return arg0_4.displayWordList
end

function var0_0.GetLatestCharacterWord(arg0_5)
	local var0_5
	local var1_5 = ""

	for iter0_5 = #arg0_5.displayWordList, 1, -1 do
		if arg0_5.displayWordList[iter0_5].ship_group ~= 0 or arg0_5:IsCompleted() then
			var0_5 = arg0_5.displayWordList[iter0_5]

			break
		end
	end

	if var0_5.type == 1 then
		var1_5 = var0_5.param
	elseif var0_5.type == 2 then
		var1_5 = "<color=#ff6666>" .. i18n("juuschat_chattip1") .. "</color>"
	elseif var0_5.type == 3 then
		var1_5 = "<color=#ff6666>" .. i18n("juuschat_chattip2") .. "</color>" .. pg.activity_ins_redpackage[tonumber(var0_5.param)].desc
	elseif var0_5.type == 4 then
		local var2_5 = pg.emoji_template[tonumber(var0_5.param)].desc

		var1_5 = string.gsub(var2_5, "#%w+>", "#28af6e>")
	elseif var0_5.type == 5 then
		local var3_5 = var0_5.param

		for iter1_5 in string.gmatch(var0_5.param, "'%d+'") do
			local var4_5 = string.sub(iter1_5, 2, #iter1_5 - 1)

			var3_5 = string.gsub(var3_5, iter1_5, "<color=#46d6ff>" .. pg.activity_ins_ship_group_template[tonumber(var4_5)].name .. "</color>")
		end

		var1_5 = var3_5
	end

	if arg0_5:isWaiting() and var0_5.type ~= 2 and var0_5.type ~= 3 then
		var1_5 = "<color=#ff6666>" .. i18n("juuschat_chattip3") .. "</color>" .. var1_5
	end

	return var1_5
end

function var0_0.Activate(arg0_6, arg1_6)
	arg0_6.active = true
	arg0_6.operationTime = arg1_6
	arg0_6.readFlag = 0

	arg0_6:SetDisplayWordList()

	arg0_6.replyList = {}
end

function var0_0.RedPacketGotFlag(arg0_7, arg1_7)
	if #arg0_7.replyValues > 0 and _.contains(arg0_7.replyValues, arg1_7) then
		return true
	end

	return false
end

function var0_0.isWaiting(arg0_8)
	return arg0_8.displayWordList[#arg0_8.displayWordList].option ~= ""
end

function var0_0.IsCompleted(arg0_9)
	if not arg0_9:isWaiting() and arg0_9.readFlag == 1 then
		return true
	end

	return false
end

return var0_0
