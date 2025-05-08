local var0_0 = class("IslandInteractionUntil")

var0_0.TYPE_STORY = 1
var0_0.TYPE_BUBBLE = 2
var0_0.TYPE_ACTION = 3
var0_0.TYPE_AGORA = 4
var0_0.TYPE_AGORA_CANCEL = 5
var0_0.TYPE_OPEN_PAGE = 6
var0_0.TYPE_TRANSFER = 7
var0_0.TYPE_BT_VALUE = 8

function var0_0.GetInteractionOptions(arg0_1)
	local var0_1 = pg.island_interaction.get_id_list_by_groupId[arg0_1] or {}

	return _.map(var0_1, function(arg0_2)
		return pg.island_interaction[arg0_2]
	end)
end

local function var1_0(arg0_3)
	require("nodecanvas.Task.NcPlayStory").New(nil, {}):DoAction(arg0_3)
end

local function var2_0(arg0_4)
	require("nodecanvas.Task.NcPlayChatBubble").New(nil, {}):DoAction(arg0_4)
end

local function var3_0(arg0_5)
	assert(false, "未处理类型:" .. var0_0.TYPE_ACTION)
end

local function var4_0(arg0_6, arg1_6)
	local var0_6 = arg1_6.view.player.id

	arg1_6:Op("InterAction", arg0_6, var0_6)
end

local function var5_0(arg0_7, arg1_7)
	local var0_7 = arg1_7.view.player.id

	arg1_7:Op("InterActionEnd", arg0_7, var0_7)
end

local function var6_0(arg0_8, arg1_8, arg2_8)
	arg1_8:Op("NotifiyIsland", ISLAND_EX_EVT.OPEN_PAGE, _G[arg0_8], arg2_8)
end

local function var7_0(arg0_9, arg1_9)
	arg1_9:Op("NotifiyIsland", ISLAND_EX_EVT.SWITCH_MAP, tonumber(arg0_9))
end

local function var8_0(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg2_10:GetView():GetUnitModule(arg1_10)

	if var0_10.behaviourTreeOwner then
		if tonumber(arg0_10[2]) then
			LuaHelper.NodeCanvasSetIntVariableValue(var0_10.behaviourTreeOwner, arg0_10[1], arg0_10[2])
		else
			var0_10.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg0_10[1], arg0_10[2])
		end
	end
end

function var0_0.Response(arg0_11, arg1_11, arg2_11)
	local var0_11 = pg.island_interaction[arg2_11]

	if var0_11.type == var0_0.TYPE_STORY then
		var1_0(var0_11.param)
	elseif var0_11.type == var0_0.TYPE_BUBBLE then
		var2_0(var0_11.param)
	elseif var0_11.type == var0_0.TYPE_ACTION then
		var3_0(var0_11.param)
	elseif var0_11.type == var0_0.TYPE_AGORA then
		var4_0(arg1_11, arg0_11)
	elseif var0_11.type == var0_0.TYPE_AGORA_CANCEL then
		var5_0(arg1_11, arg0_11)
	elseif var0_11.type == var0_0.TYPE_OPEN_PAGE then
		var6_0(var0_11.param, arg0_11, arg1_11)
	elseif var0_11.type == var0_0.TYPE_TRANSFER then
		var7_0(var0_11.param, arg0_11)
	elseif var0_11.type == var0_0.TYPE_BT_VALUE then
		var8_0(var0_11.param, arg1_11, arg0_11)
	end
end

return var0_0
