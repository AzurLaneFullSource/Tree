local var0_0 = class("ChatConst")

var0_0.CODE_BANED = 100
var0_0.CODE_ACTOBSS_MSG_WORD = 1000
var0_0.ChannelAll = 1
var0_0.ChannelWorld = 2
var0_0.ChannelPublic = 3
var0_0.ChannelFriend = 4
var0_0.ChannelGuild = 5
var0_0.ChannelWorldBoss = 6
var0_0.SendChannels = {
	var0_0.ChannelWorld,
	var0_0.ChannelGuild
}
var0_0.RecvChannels = {
	var0_0.ChannelAll,
	var0_0.ChannelWorld,
	var0_0.ChannelPublic,
	var0_0.ChannelFriend,
	var0_0.ChannelGuild,
	var0_0.ChannelWorldBoss
}

function var0_0.GetChannelName(arg0_1)
	return i18n("channel_name_" .. arg0_1)
end

function var0_0.GetChannelSprite(arg0_2)
	if arg0_2 == var0_0.ChannelWorld then
		return "world"
	elseif arg0_2 == var0_0.ChannelPublic then
		return "public"
	elseif arg0_2 == var0_0.ChannelFriend then
		return "friend"
	elseif arg0_2 == var0_0.ChannelGuild then
		return "guild"
	elseif arg0_2 == var0_0.ChannelAll then
		return "total"
	elseif arg0_2 == var0_0.ChannelWorldBoss then
		return "worldboss"
	end

	assert(false)
end

var0_0.EmojiCommon = 0
var0_0.EmojiDefault = 1
var0_0.EmojiAnimate = 2
var0_0.EmojiPixel = 3
var0_0.EmojiIcon = 4
var0_0.EmojiTypes = {
	var0_0.EmojiCommon,
	var0_0.EmojiDefault,
	var0_0.EmojiAnimate,
	var0_0.EmojiPixel,
	var0_0.EmojiIcon
}

function var0_0.GetEmojiSprite(arg0_3)
	if arg0_3 == var0_0.EmojiCommon then
		return "tab_casual"
	elseif arg0_3 == var0_0.EmojiDefault then
		return "tab_default"
	elseif arg0_3 == var0_0.EmojiAnimate then
		return "tab_motive"
	elseif arg0_3 == var0_0.EmojiPixel then
		return "tab_pixel"
	end

	assert(false)
end

var0_0.EmojiCode = "{777#code#777}"
var0_0.EmojiCodeMatch = "{777#(%d+)#777}"
var0_0.EmojiIconCode = "#code#"
var0_0.EmojiIconCodeMatch = "#(%d+)#"
var0_0.EMOJI_SAVE_TAG = "emoji_regular_used_"
var0_0.EMOJI_ICON_SAVE_TAG = "emoji_icon_regular_used_"

return var0_0
