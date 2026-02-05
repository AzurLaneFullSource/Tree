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
var0_0.TYPE_SP_TRANSFER = 24
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

local function var4_0(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg1_10.view.player.id

	arg1_10:Op("AgoraVirtualInterAction", arg0_10, var0_10, tonumber(arg2_10))
end

local function var5_0(arg0_11, arg1_11)
	local var0_11 = arg1_11.view.player.id

	arg1_11:Op("AgoraVirtualInterActionEnd", arg0_11, var0_11)
end

local function var6_0(arg0_12, arg1_12)
	if not getProxy(SettingsProxy):ShouldTipIslandRestEvet() then
		return false
	end

	return arg0_12:GetManageAgency():GetRestaurant(arg1_12):GetEventInfo() ~= 0
end

local function var7_0(arg0_13, arg1_13, arg2_13)
	local var0_13 = Clone(arg0_13)
	local var1_13 = var0_13[1]

	table.remove(var0_13, 1)
	table.insert(var0_13, arg2_13)

	local var2_13 = arg1_13:GetView()
	local var3_13 = var2_13:GetIsland()

	if var1_13 == "IslandRestaurantPage" and var6_0(var3_13, unpack(var0_13)) then
		local var4_13 = var3_13:GetManageAgency():GetRestaurant(unpack(var0_13))

		var2_13:ShowMsgbox({
			blur = true,
			isNew = true,
			type = IslandMsgBox.TYPE_ISLAND_POST_EVENT,
			rest = var4_13,
			onHide = function()
				arg1_13:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE, _G[var1_13], unpack(var0_13))
			end
		})
	else
		arg1_13:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE, _G[var1_13], unpack(var0_13))
	end
end

local function var8_0(arg0_15, arg1_15)
	arg1_15:NotifiyIsland(ISLAND_EX_EVT.SWITCH_MAP, tonumber(arg0_15))
end

local function var9_0(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg2_16:GetView():GetUnitModule(arg1_16)

	if var0_16.behaviourTreeOwner then
		if tonumber(arg0_16[2]) then
			LuaHelper.NodeCanvasSetIntVariableValue(var0_16.behaviourTreeOwner, arg0_16[1], arg0_16[2])
		else
			var0_16.behaviourTreeOwner.graph.blackboard:SetVariableValue(arg0_16[1], arg0_16[2])
		end
	end
end

local function var10_0(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17.view.player.id

	arg1_17:Op("WorldObjectInterAction", arg0_17, var0_17, tonumber(arg2_17))
end

local function var11_0(arg0_18, arg1_18)
	local var0_18 = arg1_18.view.player.id

	arg1_18:Op("WorldObjectInterActionEnd", arg0_18, var0_18)
end

local function var12_0(arg0_19, arg1_19)
	arg1_19:NotifiyIsland(ISLAND_EX_EVT.TRIGGER_TASK, tonumber(arg0_19))
end

local function var13_0(arg0_20, arg1_20)
	arg1_20:NotifiyIsland(ISLAND_EX_EVT.SUBMIT_TASK, tonumber(arg0_20))
end

local function var14_0(arg0_21)
	arg0_21:NotifiyIsland(ISLAND_EX_EVT.EMIT, IslandMediator.SIGNIN)
end

local function var15_0(arg0_22)
	local var0_22 = arg0_22:GetView()
	local var1_22 = var0_22:GetUnitModule(var0_22.selectedUnitId)

	if not var1_22 then
		return
	end

	local var2_22 = var0_22:GetIsland().id

	arg0_22:NotifiyIsland(ISLAND_EX_EVT.EMIT, IslandMediator.SELECT_GIFT, var2_22, var1_22.data.index)
end

local function var16_0(arg0_23)
	arg0_23:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE)
end

function var0_0.AddInteractionTaskProgress(arg0_24, arg1_24)
	arg0_24:Op("NotifiyIsland", ISLAND_EX_EVT.ADD_TASK_PROGRESS, IslandTaskTargetType.INTERACTION, arg1_24)
end

local function var17_0(arg0_25)
	arg0_25:NotifiyIsland(ISLAND_EX_EVT.EMIT, IslandMediator.GET_THEMES, function()
		arg0_25:Op("EnterEditMode")
	end)
end

local function var18_0(arg0_27)
	local var0_27 = arg0_27:GetView()
	local var1_27 = var0_27:GetIsland()

	if not var1_27:GetAgoraAgency():CanUpgrade() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_max_level"))

		return
	end

	var0_27:ShowMsgbox({
		type = IslandMsgBox.TYPE_AGORA_UPGRADE,
		island = var1_27,
		onYes = function()
			arg0_27:Op("Upgrade")
		end
	})
end

local function var19_0(arg0_29, arg1_29)
	arg0_29:NotifiyIsland(ISLAND_EX_EVT.PLAY_PERFORMANCE, {
		name = arg1_29
	})
end

local function var20_0(arg0_30, arg1_30)
	arg0_30:GetView():GetSubView(IslandInteractionView):ShowNextInteractionBtns(arg1_30)
end

local function var21_0(arg0_31, arg1_31)
	local var0_31 = pg.island_strollnpc[arg1_31]
	local var1_31

	for iter0_31, iter1_31 in ipairs(pg.island_chara_template.all) do
		if pg.island_chara_template[iter1_31].unit_id == var0_31.unit_id then
			var1_31 = iter1_31

			break
		end
	end

	if var1_31 then
		arg0_31:NotifiyMeditor(IslandMediator.ADD_FOLLOWER, var1_31)
	end
end

function var0_0.Response(arg0_32, arg1_32, arg2_32)
	local var0_32 = pg.island_interaction[arg2_32]

	if var0_32.type == var0_0.TYPE_STORY then
		var1_0(var0_32.param, arg0_32, arg2_32)
	elseif var0_32.type == var0_0.TYPE_BUBBLE then
		var2_0(var0_32.param, arg0_32, arg2_32)
	elseif var0_32.type == var0_0.TYPE_ACTION then
		var3_0(var0_32.param[1], var0_32.param[2], arg0_32)
	elseif var0_32.type == var0_0.TYPE_AGORA then
		var4_0(arg1_32, arg0_32, var0_32.param)
	elseif var0_32.type == var0_0.TYPE_AGORA_CANCEL then
		var5_0(arg1_32, arg0_32)
	elseif var0_32.type == var0_0.TYPE_OPEN_PAGE then
		var7_0(var0_32.param, arg0_32, arg1_32)
	elseif var0_32.type == var0_0.TYPE_TRANSFER or var0_32.type == var0_0.TYPE_SP_TRANSFER then
		var8_0(var0_32.param, arg0_32)
	elseif var0_32.type == var0_0.TYPE_BT_VALUE then
		var9_0(var0_32.param, arg1_32, arg0_32)
	elseif var0_32.type == var0_0.TYPE_ITEM_INTERACT then
		var10_0(arg1_32, arg0_32, var0_32.param)
	elseif var0_32.type == var0_0.TYPE_ITEM_INTERACT_CANCEL then
		var11_0(arg1_32, arg0_32)
	elseif var0_32.type == var0_0.TYPE_ACCEPT_TASK then
		var12_0(var0_32.param, arg0_32)
	elseif var0_32.type == var0_0.TYPE_SUBMIT_TASK then
		var13_0(var0_32.param, arg0_32)
	elseif var0_32.type == var0_0.TYPE_SIGNIN then
		var14_0(arg0_32)
	elseif var0_32.type == var0_0.TYPE_SELECT_GIFT then
		var15_0(arg0_32)
	elseif var0_32.type == var0_0.TYPE_NOTHING then
		-- block empty
	elseif var0_32.type == var0_0.TYPE_DECORATION then
		var17_0(arg0_32)
	elseif var0_32.type == var0_0.TYPE_EXTEND_AGORA then
		var18_0(arg0_32)
	elseif var0_32.type == var0_0.TYPE_ECHANGE_AGORA_BASE then
		-- block empty
	elseif var0_32.type == var0_0.TYPE_PERFORMANCE then
		var19_0(arg0_32, var0_32.param)
	elseif var0_32.type == var0_0.TYPE_NEXT_INTERACTION then
		var20_0(arg0_32, var0_32.param)
	elseif var0_32.type == var0_0.TYPE_FOLLOW_PLAYER then
		var21_0(arg0_32, arg1_32)
	else
		assert(false, "未处理类型:" .. var0_32.type)
	end

	if var0_32.type ~= var0_0.TYPE_STORY and var0_32.type ~= var0_0.TYPE_BUBBLE then
		var0_0.AddInteractionTaskProgress(arg0_32, arg2_32)
	end

	if var0_32.type == var0_0.TYPE_STORY or var0_32.type == var0_0.TYPE_BUBBLE then
		local var1_32 = pg.island_world_objects[arg1_32].unitId

		IslandBookHelper.OnNpcInteract(var1_32)
	end
end

return var0_0
