local var0_0 = class("IslandInteractionUntil")

var0_0.TYPE_STORY = 1
var0_0.TYPE_BUBBLE = 2
var0_0.TYPE_ACTION = 3
var0_0.TYPE_AGORA = 4
var0_0.TYPE_AGORA_CANCEL = 5
var0_0.TYPE_OPEN_PAGE = 6
var0_0.TYPE_TRANSFER = 7
var0_0.TYPE_BT_VALUE = 8
var0_0.TYPE_ITEM_INTERACT = 9
var0_0.TYPE_ITEM_INTERACT_CANCEL = 10
var0_0.TYPE_ACCEPT_TASK = 11
var0_0.TYPE_SUBMIT_TASK = 12
var0_0.TYPE_SIGNIN = 13
var0_0.TYPE_SELECT_GIFT = 14
var0_0.TYPE_NOTHING = 15
var0_0.TYPE_DECORATION = 18
var0_0.TYPE_EXTEND_AGORA = 19
var0_0.TYPE_ECHANGE_AGORA_BASE = 20
var0_0.TYPE_PERFORMANCE = 21
var0_0.TYPE_NEXT_INTERACTION = 22
var0_0.TYPE_FOLLOW_PLAYER = 23
var0_0.SIGNIN_TIME_ID = 4002

function var0_0.GetInteractionOptions(arg0_1, arg1_1, arg2_1)
	local var0_1 = pg.island_interaction.get_id_list_by_groupId[arg1_1] or {}

	return _(var0_1):chain():map(function(arg0_2)
		return pg.island_interaction[arg0_2]
	end):select(function(arg0_3)
		if arg0_3.only_self == 0 and arg0_1.id ~= getProxy(IslandProxy):GetIsland().id then
			return false
		end

		return _.all(arg0_3.show_condition, function(arg0_4)
			return IslandInteractionConditionUntil.Check(arg0_1, arg0_4, arg2_1)
		end)
	end):value()
end

local function var1_0(arg0_5, arg1_5, arg2_5)
	require("nodecanvas.Task.NcPlayStory").New(nil, {}):DoAction(arg0_5, true, function()
		var0_0.AddInteractionTaskProgress(arg1_5, arg2_5)
	end)
end

local function var2_0(arg0_7, arg1_7, arg2_7)
	require("nodecanvas.Task.NcPlayChatBubble").New(nil, {}):DoAction(arg0_7, function()
		var0_0.AddInteractionTaskProgress(arg1_7, arg2_7)
	end)
end

local function var3_0(arg0_9, arg1_9, arg2_9)
	local var0_9 = (not arg0_9 or arg0_9 == 0) and arg2_9.view.player or arg2_9.view:GetUnitModule(arg0_9)

	if not var0_9 then
		return
	end

	if var0_9._tf.childCount <= 0 then
		return
	end

	local var1_9 = var0_9._tf:GetChild(0):GetComponent(typeof(Animator))

	if not var1_9 then
		return
	end

	local var2_9 = Animator.StringToHash(arg1_9)

	for iter0_9 = 1, var1_9.layerCount do
		var1_9:CrossFadeInFixedTime(var2_9, 0.2, iter0_9 - 1)
	end
end

local function var4_0(arg0_10, arg1_10)
	local var0_10 = arg1_10.view.player.id

	arg1_10:Op("InterAction", arg0_10, var0_10)
end

local function var5_0(arg0_11, arg1_11)
	local var0_11 = arg1_11.view.player.id

	arg1_11:Op("InterActionEnd", arg0_11, var0_11)
end

local function var6_0(arg0_12, arg1_12, arg2_12)
	local var0_12 = Clone(arg0_12)
	local var1_12 = var0_12[1]

	table.remove(var0_12, 1)
	table.insert(var0_12, arg2_12)
	arg1_12:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE, _G[var1_12], unpack(var0_12))
end

local function var7_0(arg0_13, arg1_13)
	arg1_13:NotifiyIsland(ISLAND_EX_EVT.SWITCH_MAP, tonumber(arg0_13))
end

local function var8_0(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg2_14:GetView():GetUnitModule(arg1_14)

	if var0_14.behaviourTreeOwner then
		if tonumber(arg0_14[2]) then
			LuaHelper.NodeCanvasSetIntVariableValue(var0_14.behaviourTreeOwner, arg0_14[1], arg0_14[2])
		else
			var0_14.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg0_14[1], arg0_14[2])
		end
	end
end

local function var9_0(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15.view.player.id

	arg1_15:Op("WorldObjectInterAction", arg0_15, var0_15, tonumber(arg2_15))
end

local function var10_0(arg0_16, arg1_16)
	local var0_16 = arg1_16.view.player.id

	arg1_16:Op("WorldObjectInterActionEnd", arg0_16, var0_16)
end

local function var11_0(arg0_17, arg1_17)
	arg1_17:NotifiyIsland(ISLAND_EX_EVT.TRIGGER_TASK, tonumber(arg0_17))
end

local function var12_0(arg0_18, arg1_18)
	arg1_18:NotifiyIsland(ISLAND_EX_EVT.SUBMIT_TASK, tonumber(arg0_18))
end

local function var13_0(arg0_19)
	arg0_19:NotifiyIsland(ISLAND_EX_EVT.EMIT, IslandMediator.SIGNIN)
end

local function var14_0(arg0_20)
	local var0_20 = arg0_20:GetView()
	local var1_20 = var0_20:GetUnitModule(var0_20.selectedUnitId)

	if not var1_20 then
		return
	end

	local var2_20 = var0_20:GetIsland().id

	arg0_20:NotifiyIsland(ISLAND_EX_EVT.EMIT, IslandMediator.SELECT_GIFT, var2_20, var1_20.data.index)
end

local function var15_0(arg0_21)
	arg0_21:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE)
end

function var0_0.AddInteractionTaskProgress(arg0_22, arg1_22)
	arg0_22:Op("NotifiyIsland", ISLAND_EX_EVT.ADD_TASK_PROGRESS, IslandTaskTargetType.INTERACTION, arg1_22)
end

local function var16_0(arg0_23)
	arg0_23:NotifiyIsland(ISLAND_EX_EVT.EMIT, IslandMediator.GET_THEMES, function()
		arg0_23:Op("EnterEditMode")
	end)
end

local function var17_0(arg0_25)
	local var0_25 = arg0_25:GetView()
	local var1_25 = var0_25:GetIsland()

	if not var1_25:GetAgoraAgency():CanUpgrade() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_max_level"))

		return
	end

	var0_25:ShowMsgbox({
		type = IslandMsgBox.TYPE_AGORA_UPGRADE,
		island = var1_25,
		onYes = function()
			arg0_25:Op("Upgrade")
		end
	})
end

local function var18_0(arg0_27, arg1_27)
	arg0_27:NotifiyIsland(ISLAND_EX_EVT.PLAY_PERFORMANCE, {
		name = arg1_27
	})
end

local function var19_0(arg0_28, arg1_28)
	arg0_28:GetView():GetSubView(IslandInteractionView):ShowNextInteractionBtns(arg1_28)
end

local function var20_0(arg0_29, arg1_29)
	local var0_29 = pg.island_strollnpc[arg1_29]
	local var1_29

	for iter0_29, iter1_29 in ipairs(pg.island_chara_template.all) do
		if pg.island_chara_template[iter1_29].unit_id == var0_29.unit_id then
			var1_29 = iter1_29

			break
		end
	end

	if var1_29 then
		arg0_29:NotifiyMeditor(IslandMediator.ADD_FOLLOWER, var1_29)
	end
end

function var0_0.Response(arg0_30, arg1_30, arg2_30)
	local var0_30 = pg.island_interaction[arg2_30]

	if var0_30.type == var0_0.TYPE_STORY then
		var1_0(var0_30.param, arg0_30, arg2_30)
	elseif var0_30.type == var0_0.TYPE_BUBBLE then
		var2_0(var0_30.param, arg0_30, arg2_30)
	elseif var0_30.type == var0_0.TYPE_ACTION then
		var3_0(var0_30.param[1], var0_30.param[2], arg0_30)
	elseif var0_30.type == var0_0.TYPE_AGORA then
		var4_0(arg1_30, arg0_30)
	elseif var0_30.type == var0_0.TYPE_AGORA_CANCEL then
		var5_0(arg1_30, arg0_30)
	elseif var0_30.type == var0_0.TYPE_OPEN_PAGE then
		var6_0(var0_30.param, arg0_30, arg1_30)
	elseif var0_30.type == var0_0.TYPE_TRANSFER then
		var7_0(var0_30.param, arg0_30)
	elseif var0_30.type == var0_0.TYPE_BT_VALUE then
		var8_0(var0_30.param, arg1_30, arg0_30)
	elseif var0_30.type == var0_0.TYPE_ITEM_INTERACT then
		var9_0(arg1_30, arg0_30, var0_30.param)
	elseif var0_30.type == var0_0.TYPE_ITEM_INTERACT_CANCEL then
		var10_0(arg1_30, arg0_30)
	elseif var0_30.type == var0_0.TYPE_ACCEPT_TASK then
		var11_0(var0_30.param, arg0_30)
	elseif var0_30.type == var0_0.TYPE_SUBMIT_TASK then
		var12_0(var0_30.param, arg0_30)
	elseif var0_30.type == var0_0.TYPE_SIGNIN then
		var13_0(arg0_30)
	elseif var0_30.type == var0_0.TYPE_SELECT_GIFT then
		var14_0(arg0_30)
	elseif var0_30.type == var0_0.TYPE_NOTHING then
		-- block empty
	elseif var0_30.type == var0_0.TYPE_DECORATION then
		var16_0(arg0_30)
	elseif var0_30.type == var0_0.TYPE_EXTEND_AGORA then
		var17_0(arg0_30)
	elseif var0_30.type == var0_0.TYPE_ECHANGE_AGORA_BASE then
		-- block empty
	elseif var0_30.type == var0_0.TYPE_PERFORMANCE then
		var18_0(arg0_30, var0_30.param)
	elseif var0_30.type == var0_0.TYPE_NEXT_INTERACTION then
		var19_0(arg0_30, var0_30.param)
	elseif var0_30.type == var0_0.TYPE_FOLLOW_PLAYER then
		var20_0(arg0_30, arg1_30)
	else
		assert(false, "未处理类型:" .. var0_30.type)
	end

	if var0_30.type ~= var0_0.TYPE_STORY and var0_30.type ~= var0_0.TYPE_BUBBLE then
		var0_0.AddInteractionTaskProgress(arg0_30, arg2_30)
	end

	if var0_30.type == var0_0.TYPE_STORY or var0_30.type == var0_0.TYPE_BUBBLE then
		local var1_30 = pg.island_world_objects[arg1_30].unitId

		IslandBookHelper.OnNpcInteract(var1_30)
	end
end

return var0_0
