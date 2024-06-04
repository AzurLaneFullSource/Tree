local var0 = class("CommanderConst")

var0.TALENT_POINT_LEVEL = 5
var0.TALENT_POINT = 1
var0.TALENT_ADDITION_NUMBER = 1
var0.TALENT_ADDITION_RATIO = 2
var0.TALENT_ADDITION_BUFF = 3
var0.MAX_TELENT_COUNT = 5
var0.RESET_TALENT_WAIT_TIME = 86401
var0.PLAY_MAX_COUNT = 10
var0.MAX_FORMATION_POS = 2
var0.MAX_ABILITY = 255
var0.PROPERTIES = {
	AttributeType.Durability,
	AttributeType.Cannon,
	AttributeType.Torpedo,
	AttributeType.AntiAircraft,
	AttributeType.Air,
	AttributeType.Reload,
	AttributeType.Armor,
	AttributeType.Hit,
	AttributeType.Dodge,
	AttributeType.Speed,
	AttributeType.Luck,
	AttributeType.AntiSub
}
var0.DESTROY_ATTR_ID = 202

local var1 = pg.gameset.commander_get_cost.description

function var0.getBoxComsume(arg0)
	local var0

	for iter0, iter1 in ipairs(var1) do
		if arg0 < iter1[3] then
			var0 = iter1[1]

			break
		end
	end

	var0 = var0 or var1[#var1][1]

	local var1 = getProxy(GuildProxy):GetAdditionGuild()

	if var1 then
		var0 = var0 - var1:getCatBoxGoldAddition()
	end

	return math.max(var0, 0)
end

var0.MAX_GETBOX_CNT = 0

for iter0, iter1 in ipairs(var1) do
	var0.MAX_GETBOX_CNT = var0.MAX_GETBOX_CNT + iter1[3]
end

return var0
