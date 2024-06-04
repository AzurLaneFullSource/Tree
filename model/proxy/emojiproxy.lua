local var0 = class("EmojiProxy", import(".NetProxy"))

var0.NEW_EMOJI_SAVE_TAG = "new_emoji_save_tag_"

function var0.register(arg0)
	arg0._initedTag = false
	arg0._emojiIDList = {}
	arg0._newIDList = {}
end

function var0.getInitedTag(arg0)
	return arg0._initedTag
end

function var0.setInitedTag(arg0)
	arg0._initedTag = true
end

function var0.getNewEmojiIDLIst(arg0)
	return Clone(arg0._newIDList)
end

function var0.addToEmojiIDLIst(arg0, arg1)
	if table.indexof(arg0._emojiIDList, arg1, 1) then
		return
	end

	table.insert(arg0._emojiIDList, arg1)
end

function var0.saveNewEmojiIDList(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._newIDList) do
		table.insert(var0, iter1)
	end

	local var1 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetString(var0.NEW_EMOJI_SAVE_TAG .. var1, table.concat(var0, ":"))
end

function var0.loadNewEmojiIDList(arg0)
	arg0._newIDList = {}

	local var0 = getProxy(PlayerProxy):getRawData().id
	local var1 = string.split(PlayerPrefs.GetString(var0.NEW_EMOJI_SAVE_TAG .. var0) or "", ":")

	if #var1 > 0 then
		for iter0, iter1 in pairs(var1) do
			table.insert(arg0._newIDList, tonumber(iter1))
		end
	end
end

function var0.addNewEmojiID(arg0, arg1)
	if table.indexof(arg0._emojiIDList, arg1, 1) then
		return
	end

	table.insert(arg0._emojiIDList, arg1)
	table.insert(arg0._newIDList, arg1)
	arg0:saveNewEmojiIDList()
end

function var0.removeNewEmojiID(arg0, arg1)
	local var0 = table.indexof(arg0._newIDList, arg1, 1)

	if not var0 then
		assert(false, "new emoji list does not exit this emojiID:" .. arg1)
	else
		table.remove(arg0._newIDList, var0)
	end

	arg0:saveNewEmojiIDList()
end

function var0.fliteNewEmojiDataByType(arg0)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._newIDList) do
		local var1 = pg.emoji_template[iter1]
		local var2 = var1.type[1]

		if not var0[var2] then
			var0[var2] = {
				var1
			}
		else
			table.insert(var0[var2], var1)
		end
	end

	return var0
end

function var0.getEmojiDataByType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._emojiIDList) do
		local var1 = pg.emoji_template[iter1]

		if table.contains(var1.type, arg1) then
			table.insert(var0, var1)
		end
	end

	return var0
end

function var0.getExEmojiDataByType(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in pairs(arg0._emojiIDList) do
		if not table.contains(arg0._newIDList, iter1) then
			local var1 = pg.emoji_template[iter1]

			if table.contains(var1.type, arg1) then
				table.insert(var0, var1)
			end
		end
	end

	return var0
end

return var0
