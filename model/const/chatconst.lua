local var0 = class("ChatConst")

var0.CODE_BANED = 100
var0.CODE_ACTOBSS_MSG_WORD = 1000
var0.ChannelAll = 1
var0.ChannelWorld = 2
var0.ChannelPublic = 3
var0.ChannelFriend = 4
var0.ChannelGuild = 5
var0.ChannelWorldBoss = 6
var0.SendChannels = {
	var0.ChannelWorld,
	var0.ChannelGuild
}
var0.RecvChannels = {
	var0.ChannelAll,
	var0.ChannelWorld,
	var0.ChannelPublic,
	var0.ChannelFriend,
	var0.ChannelGuild,
	var0.ChannelWorldBoss
}

function var0.GetChannelName(arg0)
	return i18n("channel_name_" .. arg0)
end

function var0.GetChannelSprite(arg0)
	if arg0 == var0.ChannelWorld then
		return "world"
	elseif arg0 == var0.ChannelPublic then
		return "public"
	elseif arg0 == var0.ChannelFriend then
		return "friend"
	elseif arg0 == var0.ChannelGuild then
		return "guild"
	elseif arg0 == var0.ChannelAll then
		return "total"
	elseif arg0 == var0.ChannelWorldBoss then
		return "worldboss"
	end

	assert(false)
end

var0.EmojiCommon = 0
var0.EmojiDefault = 1
var0.EmojiAnimate = 2
var0.EmojiPixel = 3
var0.EmojiIcon = 4
var0.EmojiTypes = {
	var0.EmojiCommon,
	var0.EmojiDefault,
	var0.EmojiAnimate,
	var0.EmojiPixel,
	var0.EmojiIcon
}

function var0.GetEmojiSprite(arg0)
	if arg0 == var0.EmojiCommon then
		return "tab_casual"
	elseif arg0 == var0.EmojiDefault then
		return "tab_default"
	elseif arg0 == var0.EmojiAnimate then
		return "tab_motive"
	elseif arg0 == var0.EmojiPixel then
		return "tab_pixel"
	end

	assert(false)
end

var0.EmojiCode = "{777#code#777}"
var0.EmojiCodeMatch = "{777#(%d+)#777}"
var0.EmojiIconCode = "#code#"
var0.EmojiIconCodeMatch = "#(%d+)#"
var0.EMOJI_SAVE_TAG = "emoji_regular_used_"
var0.EMOJI_ICON_SAVE_TAG = "emoji_icon_regular_used_"

return var0
