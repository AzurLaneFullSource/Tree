local var0_0 = class("EmojiProxy", import(".NetProxy"))

var0_0.NEW_EMOJI_SAVE_TAG = "new_emoji_save_tag_"

function var0_0.register(arg0_1)
	arg0_1._initedTag = false
	arg0_1._emojiIDList = {}
	arg0_1._newIDList = {}
end

function var0_0.getInitedTag(arg0_2)
	return arg0_2._initedTag
end

function var0_0.setInitedTag(arg0_3)
	arg0_3._initedTag = true
end

function var0_0.getNewEmojiIDLIst(arg0_4)
	return Clone(arg0_4._newIDList)
end

function var0_0.addToEmojiIDLIst(arg0_5, arg1_5)
	if table.indexof(arg0_5._emojiIDList, arg1_5, 1) then
		return
	end

	table.insert(arg0_5._emojiIDList, arg1_5)
end

function var0_0.saveNewEmojiIDList(arg0_6)
	local var0_6 = {}

	for iter0_6, iter1_6 in pairs(arg0_6._newIDList) do
		table.insert(var0_6, iter1_6)
	end

	local var1_6 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var0_0.NEW_EMOJI_SAVE_TAG .. var1_6, table.concat(var0_6, ":"))
end

function var0_0.loadNewEmojiIDList(arg0_7)
	arg0_7._newIDList = {}

	local var0_7 = getProxy(PlayerProxy):getRawData().id
	local var1_7 = string.split(PlayerPrefs.GetString(var0_0.NEW_EMOJI_SAVE_TAG .. var0_7) or "", ":")

	if #var1_7 > 0 then
		for iter0_7, iter1_7 in pairs(var1_7) do
			table.insert(arg0_7._newIDList, tonumber(iter1_7))
		end
	end
end

function var0_0.addNewEmojiID(arg0_8, arg1_8)
	if table.indexof(arg0_8._emojiIDList, arg1_8, 1) then
		return
	end

	table.insert(arg0_8._emojiIDList, arg1_8)
	table.insert(arg0_8._newIDList, arg1_8)
	arg0_8:saveNewEmojiIDList()
end

function var0_0.removeNewEmojiID(arg0_9, arg1_9)
	local var0_9 = table.indexof(arg0_9._newIDList, arg1_9, 1)

	if not var0_9 then
		assert(false, "new emoji list does not exit this emojiID:" .. arg1_9)
	else
		table.remove(arg0_9._newIDList, var0_9)
	end

	arg0_9:saveNewEmojiIDList()
end

function var0_0.fliteNewEmojiDataByType(arg0_10)
	local var0_10 = {}

	for iter0_10, iter1_10 in pairs(arg0_10._newIDList) do
		local var1_10 = pg.emoji_template[iter1_10]
		local var2_10 = var1_10.type[1]

		if not var0_10[var2_10] then
			var0_10[var2_10] = {
				var1_10
			}
		else
			table.insert(var0_10[var2_10], var1_10)
		end
	end

	return var0_10
end

function var0_0.getEmojiDataByType(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11._emojiIDList) do
		local var1_11 = pg.emoji_template[iter1_11]

		if table.contains(var1_11.type, arg1_11) then
			table.insert(var0_11, var1_11)
		end
	end

	return var0_11
end

function var0_0.getExEmojiDataByType(arg0_12, arg1_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in pairs(arg0_12._emojiIDList) do
		if not table.contains(arg0_12._newIDList, iter1_12) then
			local var1_12 = pg.emoji_template[iter1_12]

			if table.contains(var1_12.type, arg1_12) then
				table.insert(var0_12, var1_12)
			end
		end
	end

	return var0_12
end

return var0_0
