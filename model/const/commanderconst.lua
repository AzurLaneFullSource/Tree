local var0_0 = class("CommanderConst")

var0_0.TALENT_POINT_LEVEL = 5
var0_0.TALENT_POINT = 1
var0_0.TALENT_ADDITION_NUMBER = 1
var0_0.TALENT_ADDITION_RATIO = 2
var0_0.TALENT_ADDITION_BUFF = 3
var0_0.MAX_TELENT_COUNT = 5
var0_0.RESET_TALENT_WAIT_TIME = 86401
var0_0.PLAY_MAX_COUNT = 10
var0_0.MAX_FORMATION_POS = 2
var0_0.MAX_ABILITY = 255
var0_0.PROPERTIES = {
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
var0_0.DESTROY_ATTR_ID = 202

local var1_0 = pg.gameset.commander_get_cost.description

function var0_0.getBoxComsume(arg0_1)
	local var0_1

	for iter0_1, iter1_1 in ipairs(var1_0) do
		if arg0_1 < iter1_1[3] then
			var0_1 = iter1_1[1]

			break
		end
	end

	var0_1 = var0_1 or var1_0[#var1_0][1]

	local var1_1 = getProxy(GuildProxy):GetAdditionGuild()

	if var1_1 then
		var0_1 = var0_1 - var1_1:getCatBoxGoldAddition()
	end

	return math.max(var0_1, 0)
end

var0_0.MAX_GETBOX_CNT = 0

for iter0_0, iter1_0 in ipairs(var1_0) do
	var0_0.MAX_GETBOX_CNT = var0_0.MAX_GETBOX_CNT + iter1_0[3]
end

return var0_0
