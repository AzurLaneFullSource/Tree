local var0_0 = class("PlayRoomChatConst")

var0_0.CHANNEL_PLAYROOM = 1
var0_0.CHANNEL_WORLD = 2
var0_0.CHANNEL_FRIEND = 4
var0_0.CHANNEL_GUILD = 8

local var1_0 = {
	var0_0.CHANNEL_PLAYROOM,
	var0_0.CHANNEL_WORLD,
	var0_0.CHANNEL_FRIEND,
	var0_0.CHANNEL_GUILD
}
local var2_0 = {
	i18n("match_ui_chat"),
	i18n("channel_name_2"),
	i18n("island_friend"),
	i18n("channel_name_5")
}

var0_0.CHANNEL_ALL = IndexConst.BitAll(var1_0)
var0_0.CHANNELS = {}

table.insert(var0_0.CHANNELS, var0_0.CHANNEL_ALL)

for iter0_0, iter1_0 in ipairs(var1_0) do
	table.insert(var0_0.CHANNELS, iter1_0)
end

function var0_0.CHANNEL2CN(arg0_1)
	if arg0_1 == var0_0.CHANNEL_ALL then
		return i18n("channel_name_1")
	end

	local var0_1 = table.indexof(var1_0, arg0_1)

	return var2_0[var0_1]
end

var0_0.SEND_CHANNELS = {
	var0_0.CHANNEL_PLAYROOM,
	var0_0.CHANNEL_WORLD,
	var0_0.CHANNEL_GUILD
}

return var0_0
