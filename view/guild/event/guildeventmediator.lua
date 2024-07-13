local var0_0 = class("GuildEventMediator", import("...base.ContextMediator"))

var0_0.ON_ACTIVE_EVENT = "GuildEventMediator:ON_ACTIVE_EVENT"
var0_0.ON_OPEN_REPORT = "GuildEventMediator:ON_OPEN_REPORT"
var0_0.ON_GET_FORMATION = "GuildEventMediator:ON_GET_FORMATION"
var0_0.UPDATE_FORMATION = "GuildEventMediator:UPDATE_FORMATION"
var0_0.ON_SELECT_SHIP = "GuildEventMediator:ON_SELECT_SHIP"
var0_0.ON_SELECT_MISSION_SHIP = "GuildEventMediator:ON_SELECT_MISSION_SHIP"
var0_0.REFRESH_MISSION = "GuildEventMediator:REFRESH_MISSION"
var0_0.JOIN_MISSION = "GuildEventMediator:JOIN_MISSION"
var0_0.ON_GET_BOSS_INFO = "GuildEventMediator:ON_GET_BOSS_INFO"
var0_0.ON_REFRESH_BOSS_RANK = "GuildEventMediator:ON_REFRESH_BOSS_RANK"
var0_0.ON_UPDATE_NODE_ANIM_FLAG = "GuildEventMediator:ON_UPDATE_NODE_ANIM_FLAG"
var0_0.ON_SELECT_BOSS_SHIP = "GuildEventMediator:ON_SELECT_BOSS_SHIP"
var0_0.ON_UPDATE_BOSS_FLEET = "GuildEventMediator:ON_UPDATE_BOSS_FLEET"
var0_0.ON_RECOMM_BOSS_BATTLE_SHIPS = "GuildEventMediator:ON_RECOMM_BOSS_BATTLE_SHIPS"
var0_0.ON_GET_ALL_ASSULT_FLEET = "GuildEventMediator:ON_GET_ALL_ASSULT_FLEET"
var0_0.ON_SELECT_COMMANDER = "GuildEventMediator:ON_SELECT_COMMANDER"
var0_0.FORCE_REFRESH_MISSION = "GuildEventMediator:FORCE_REFRESH_MISSION"
var0_0.ON_SAVE_FORMATION = "GuildEventMediator:ON_SAVE_FORMATION"
var0_0.ON_JOIN_EVENT = "GuildEventMediator:ON_JOIN_EVENT"
var0_0.ON_RECOMM_ASSULT_SHIP = "GuildEventMediator:ON_RECOMM_ASSULT_SHIP"
var0_0.REFRESH_RECOMMAND_SHIPS = "GuildEventMediator:REFRESH_RECOMMAND_SHIPS"
var0_0.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP = "GuildEventMediator:ON_CLEAR_BOSS_FLEET_INVAILD_SHIP"
var0_0.ON_CMD_SKILL = "GuildEventMediator:ON_CMD_SKILL"
var0_0.COMMANDER_FORMATION_OP = "GuildEventMediator:COMMANDER_FORMATION_OP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.COMMANDER_FORMATION_OP, function(arg0_2, arg1_2)
		arg0_1:OnComanderOP(arg1_2)
	end)
	arg0_1:bind(var0_0.ON_CMD_SKILL, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1_3
			}
		}))
	end)
	arg0_1:bind(var0_0.REFRESH_RECOMMAND_SHIPS, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE, {
			callback = arg1_4
		})
	end)
	arg0_1:bind(var0_0.ON_RECOMM_ASSULT_SHIP, function(arg0_5, arg1_5, arg2_5)
		arg0_1:sendNotification(GAME.GUILD_RECOMMAND_ASSULT_SHIP, {
			shipId = arg1_5,
			cmd = arg2_5
		})
	end)
	arg0_1:bind(var0_0.ON_JOIN_EVENT, function()
		arg0_1:sendNotification(GAME.ON_GUILD_JOIN_EVENT)
	end)
	arg0_1:bind(var0_0.ON_SELECT_COMMANDER, function(arg0_7, arg1_7, arg2_7, arg3_7)
		arg0_1:SelectBossBattleCommander(arg1_7, arg2_7, arg3_7)
	end)
	arg0_1:bind(var0_0.ON_GET_ALL_ASSULT_FLEET, function(arg0_8, arg1_8)
		arg0_1:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {
			callback = arg1_8
		})
	end)
	arg0_1:bind(var0_0.ON_RECOMM_BOSS_BATTLE_SHIPS, function(arg0_9, arg1_9)
		arg0_1:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {
			callback = function()
				arg0_1:RecommShipsForBossBattle(arg1_9)
			end
		})
	end)
	arg0_1:bind(var0_0.ON_SAVE_FORMATION, function(arg0_11, arg1_11)
		arg0_1:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
			editFleet = arg0_1.contextData.editBossFleet,
			callback = arg1_11
		})
	end)
	arg0_1:bind(var0_0.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP, function(arg0_12)
		arg0_1:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
			force = true,
			editFleet = arg0_1.contextData.editBossFleet
		})
	end)
	arg0_1:bind(var0_0.ON_UPDATE_BOSS_FLEET, function(arg0_13)
		if not arg0_1.contextData.editBossFleet then
			arg0_1:StartBossBattle()
		else
			arg0_1.viewComponent:emit(var0_0.ON_SAVE_FORMATION, function()
				arg0_1:StartBossBattle()
			end)
		end
	end)
	arg0_1:bind(var0_0.ON_SELECT_BOSS_SHIP, function(arg0_15, arg1_15, arg2_15, arg3_15)
		arg0_1:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {
			callback = function()
				arg0_1:SelectBossBattleShip(arg1_15, arg2_15, arg3_15)
			end
		})
	end)
	arg0_1:bind(var0_0.ON_UPDATE_NODE_ANIM_FLAG, function(arg0_17, arg1_17, arg2_17)
		arg0_1:sendNotification(GAME.GUILD_UPDATE_NODE_ANIM_FLAG, {
			id = arg1_17,
			position = arg2_17
		})
	end)
	arg0_1:bind(var0_0.ON_REFRESH_BOSS_RANK, function(arg0_18)
		arg0_1:sendNotification(GAME.GET_GUILD_BOSS_RANK, {})
	end)
	arg0_1:bind(var0_0.ON_GET_BOSS_INFO, function(arg0_19)
		arg0_1:sendNotification(GAME.GUILD_GET_BOSS_INFO)
	end)
	arg0_1:bind(var0_0.JOIN_MISSION, function(arg0_20, arg1_20, arg2_20)
		arg0_1:sendNotification(GAME.GUILD_JOIN_MISSION, {
			id = arg1_20,
			shipIds = arg2_20
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_MISSION_SHIP, function(arg0_21, arg1_21, arg2_21, arg3_21)
		arg0_1.viewComponent:emit(var0_0.ON_GET_FORMATION, function()
			arg0_1:OnSelectMissionShips(arg1_21, arg2_21, arg3_21)
		end)
	end)
	arg0_1:bind(var0_0.REFRESH_MISSION, function(arg0_23, arg1_23, arg2_23)
		arg0_1:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = false,
			id = arg1_23,
			callback = arg2_23
		})
	end)
	arg0_1:bind(var0_0.FORCE_REFRESH_MISSION, function(arg0_24, arg1_24, arg2_24)
		arg0_1:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = arg1_24,
			callback = arg2_24
		})
	end)
	arg0_1:bind(var0_0.ON_SELECT_SHIP, function(arg0_25, arg1_25, arg2_25, arg3_25)
		arg0_1:OnSelectShips(arg1_25, arg2_25, arg3_25)
	end)
	arg0_1:bind(var0_0.ON_GET_FORMATION, function(arg0_26, arg1_26)
		local var0_26 = getProxy(GuildProxy):getRawData():GetActiveEvent()
		local var1_26 = {}

		if var0_26 then
			table.insert(var1_26, function(arg0_27)
				arg0_1.viewComponent:emit(var0_0.ON_GET_ALL_ASSULT_FLEET, arg0_27)
			end)
		end

		if not getProxy(GuildProxy).isFetchAssaultFleet then
			table.insert(var1_26, function(arg0_28)
				arg0_1:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET, {
					callback = arg0_28
				})
			end)
		end

		seriesAsync(var1_26, arg1_26)
	end)
	arg0_1:bind(var0_0.UPDATE_FORMATION, function(arg0_29)
		if not arg0_1.contextData.editFleet then
			return
		end

		arg0_1:sendNotification(GAME.GUILD_UPDATE_MY_ASSAULT_FLEET, {
			fleet = arg0_1.contextData.editFleet
		})
	end)
	arg0_1:bind(var0_0.ON_ACTIVE_EVENT, function(arg0_30, arg1_30)
		arg0_1:sendNotification(GAME.GUILD_ACTIVE_EVENT, {
			eventId = arg1_30
		})
	end)
	arg0_1:bind(var0_0.ON_OPEN_REPORT, function(arg0_31)
		arg0_1:sendNotification(GAME.GUILD_OPEN_EVENT_REPORT)
	end)
	arg0_1.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())

	local var0_1 = getProxy(GuildProxy)

	arg0_1.viewComponent:SetGuild(var0_1:getData())
end

function var0_0.StartBossBattle(arg0_32)
	local var0_32 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	if not var0_32 or var0_32 and var0_32:IsExpired() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

		return
	end

	local var1_32 = var0_32:GetBossMission()

	if not var1_32 then
		return
	end

	local var2_32 = var1_32:GetMainFleet()
	local var3_32, var4_32 = var2_32:IsLegal()

	if not var3_32 then
		pg.TipsMgr.GetInstance():ShowTips(var4_32)

		return
	end

	local var5_32, var6_32 = var1_32:GetSubFleet():IsLegal()

	if not var5_32 then
		pg.TipsMgr.GetInstance():ShowTips(var6_32)

		return
	end

	local var7_32 = var2_32:GetDownloadResShips()
	local var8_32 = {}

	for iter0_32, iter1_32 in ipairs(var7_32) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var8_32, iter1_32)
	end

	local function var9_32()
		arg0_32:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_GUILD
		})
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var8_32,
		finishFunc = var9_32
	})
end

function var0_0.SelectBossBattleCommander(arg0_34, arg1_34, arg2_34, arg3_34)
	if not arg0_34.contextData.editBossFleet then
		arg0_34.contextData.editBossFleet = {}
	end

	local var0_34 = getProxy(GuildProxy):getData():GetActiveEvent()

	if not var0_34 then
		return
	end

	local var1_34 = var0_34:GetBossMission()

	if not arg0_34.contextData.editBossFleet[arg1_34] then
		arg0_34.contextData.editBossFleet[arg1_34] = Clone(var1_34:GetFleetByIndex(arg1_34))
	end

	local var2_34 = arg0_34.contextData.editBossFleet[arg1_34]
	local var3_34 = var2_34:getCommanders()
	local var4_34 = {}

	if arg3_34 then
		table.insert(var4_34, arg3_34.id)
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
		maxCount = 1,
		mode = CommanderCatScene.MODE_SELECT,
		fleetType = CommanderCatScene.FLEET_TYPE_GUILDBOSS,
		activeCommander = arg3_34,
		ignoredIds = var4_34,
		fleets = arg0_34.contextData.editBossFleet,
		onCommander = function(arg0_35)
			return true
		end,
		onSelected = function(arg0_36, arg1_36)
			arg0_34:OnDockSelectCommander(true, var2_34, arg2_34, var1_34, arg0_36, arg1_36)
		end,
		onQuit = function(arg0_37)
			var2_34:RemoveCommander(arg2_34)
			arg0_37()
		end
	})
end

function var0_0.OnDockSelectCommander(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38, arg5_38, arg6_38)
	local var0_38 = arg5_38[1]
	local var1_38 = getProxy(CommanderProxy):getCommanderById(var0_38)

	if not var1_38 then
		arg6_38()

		return
	end

	local var2_38 = {}
	local var3_38 = {}
	local var4_38 = arg0_38.contextData.editBossFleet[GuildBossMission.SUB_FLEET_ID] or arg4_38:GetSubFleet()
	local var5_38 = arg0_38.contextData.editBossFleet[GuildBossMission.MAIN_FLEET_ID] or arg4_38:GetMainFleet()
	local var6_38 = arg2_38:IsMainFleet()
	local var7_38 = var6_38 and var5_38 or var4_38
	local var8_38 = var7_38:getCommanders()

	if arg1_38 then
		for iter0_38, iter1_38 in pairs(var8_38) do
			if arg3_38 ~= iter0_38 and iter1_38:isSameGroup(var1_38.groupId) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

				return
			end
		end
	end

	local var9_38 = var6_38 and var4_38 or var5_38
	local var10_38 = var9_38:getCommanders()

	for iter2_38, iter3_38 in pairs(var10_38) do
		if iter3_38.id == var1_38.id then
			arg0_38:SwopCommanderForBossBattle(arg4_38, var1_38, arg3_38, iter2_38, var7_38, var9_38, arg6_38)

			return
		end
	end

	arg2_38:AddCommander(arg3_38, var1_38)
	arg6_38()
end

function var0_0.SwopCommanderForBossBattle(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39, arg5_39, arg6_39, arg7_39)
	if not arg0_39.contextData.editBossFleet[arg6_39.id] then
		arg0_39.contextData.editBossFleet[arg6_39.id] = Clone(arg1_39:GetFleetByIndex(arg6_39.id))
		arg6_39 = arg0_39.contextData.editBossFleet[arg6_39.id]
	end

	local var0_39 = arg4_39 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
	local var1_39 = arg5_39:GetName()

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("comander_repalce_tip", var1_39, var0_39),
		onYes = function()
			arg6_39:RemoveCommander(arg4_39)
			arg5_39:AddCommander(arg3_39, arg2_39)

			if arg7_39 then
				arg7_39()
			end
		end
	})
end

function var0_0.RecommShipsForBossBattle(arg0_41, arg1_41)
	if not arg0_41.contextData.editBossFleet then
		arg0_41.contextData.editBossFleet = {}
	end

	local var0_41 = {}
	local var1_41 = {}
	local var2_41 = {}
	local var3_41 = getProxy(GuildProxy):getData()
	local var4_41 = getProxy(PlayerProxy):getRawData()
	local var5_41 = var3_41:GetActiveEvent()

	if not var5_41 then
		return
	end

	local var6_41 = var5_41:GetBossMission()

	if not arg0_41.contextData.editBossFleet[arg1_41] then
		arg0_41.contextData.editBossFleet[arg1_41] = Clone(var6_41:GetFleetByIndex(arg1_41))
	end

	local var7_41 = arg0_41.contextData.editBossFleet[arg1_41]

	var7_41:RemoveAll()

	local function var8_41(arg0_42, arg1_42)
		if arg0_42 == TeamType.Main then
			table.insert(var0_41, arg1_42)
		elseif arg0_42 == TeamType.Vanguard then
			table.insert(var1_41, arg1_42)
		elseif arg0_42 == TeamType.Submarine then
			table.insert(var2_41, arg1_42)
		end
	end

	local var9_41 = getProxy(BayProxy):getData()

	for iter0_41, iter1_41 in pairs(var9_41) do
		if not pg.ShipFlagMgr.GetInstance():GetShipFlag(iter1_41.id, "inEvent") and not iter1_41:isActivityNpc() then
			iter1_41.id = GuildAssaultFleet.GetVirtualId(var4_41.id, iter1_41.id)

			local var10_41 = iter1_41:getShipCombatPower()

			var8_41(iter1_41:getTeamType(), {
				power = var10_41,
				id = iter1_41.id
			})
		end
	end

	local var11_41 = 0
	local var12_41 = 0
	local var13_41 = 0

	local function var14_41(arg0_43, arg1_43)
		local var0_43 = GuildAssaultFleet.GetRealId(arg0_43)
		local var1_43 = var9_41[var0_43]

		if not var7_41:ExistSameKindShip(var1_43) then
			local var2_43 = GuildAssaultFleet.GetUserId(arg0_43)

			var7_41:AddUserShip(var2_43, var0_43)

			if arg1_43 == TeamType.Main then
				var11_41 = var11_41 + 1
			end

			if arg1_43 == TeamType.Vanguard then
				var12_41 = var12_41 + 1
			end

			if arg1_43 == TeamType.Submarine then
				var13_41 = var13_41 + 1
			end
		end
	end

	if var7_41:IsMainFleet() then
		table.sort(var0_41, function(arg0_44, arg1_44)
			return arg0_44.power > arg1_44.power
		end)
		table.sort(var1_41, function(arg0_45, arg1_45)
			return arg0_45.power > arg1_45.power
		end)

		for iter2_41 = 1, #var0_41 do
			if var11_41 == 3 then
				break
			end

			var14_41(var0_41[iter2_41].id, TeamType.Main)
		end

		for iter3_41 = 1, #var1_41 do
			if var12_41 == 3 then
				break
			end

			var14_41(var1_41[iter3_41].id, TeamType.Vanguard)
		end
	else
		table.sort(var2_41, function(arg0_46, arg1_46)
			return arg0_46.power > arg1_46.power
		end)

		for iter4_41 = 1, #var2_41 do
			if var13_41 == 3 then
				break
			end

			var14_41(var2_41[iter4_41].id, TeamType.Submarine)
		end
	end

	local var15_41 = arg0_41.viewComponent.missBossForamtionPage

	if var15_41 and var15_41:GetLoaded() then
		var15_41:UpdateFleet(arg1_41)
	end
end

function var0_0.SelectBossBattleShip(arg0_47, arg1_47, arg2_47, arg3_47)
	if not arg0_47.contextData.editBossFleet then
		arg0_47.contextData.editBossFleet = {}
	end

	local var0_47 = {}
	local var1_47 = getProxy(GuildProxy):getData()
	local var2_47 = var1_47:GetActiveEvent()

	if not var2_47 then
		return
	end

	local var3_47 = var2_47:GetBossMission()
	local var4_47 = var3_47:GetFleetByIndex(arg2_47)

	assert(var4_47, arg2_47)

	local var5_47

	if not arg0_47.contextData.editBossFleet[arg2_47] then
		var5_47 = Clone(var4_47)
	else
		var5_47 = Clone(arg0_47.contextData.editBossFleet[arg2_47])
	end

	local var6_47

	if arg3_47 then
		local var7_47 = arg3_47.member.id
		local var8_47 = GuildAssaultFleet.GetRealId(arg3_47.ship.id)

		var6_47 = var5_47:RemoveUserShip(var7_47, var8_47)
	end

	local var9_47 = getProxy(PlayerProxy):getRawData()
	local var10_47 = 0

	if var5_47:IsMainFleet() then
		var10_47 = (arg0_47.contextData.editBossFleet[GuildBossMission.SUB_FLEET_ID] or var3_47:GetFleetByIndex(GuildBossMission.SUB_FLEET_ID)):GetOtherMemberShipCnt(var9_47.id)
	else
		var10_47 = (arg0_47.contextData.editBossFleet[GuildBossMission.MAIN_FLEET_ID] or var3_47:GetFleetByIndex(GuildBossMission.MAIN_FLEET_ID)):GetOtherMemberShipCnt(var9_47.id)
	end

	local var11_47

	for iter0_47, iter1_47 in pairs(var1_47.member) do
		local var12_47 = iter1_47:GetAssaultFleet()

		if var9_47.id ~= iter1_47.id then
			local var13_47 = var12_47:GetShipList()

			for iter2_47, iter3_47 in pairs(var13_47) do
				if iter3_47:getTeamType() == arg1_47 then
					iter3_47.user = iter1_47

					table.insert(var0_47, iter3_47)
				end
			end
		else
			var11_47 = var12_47
		end
	end

	local var14_47 = getProxy(BayProxy):getData()

	for iter4_47, iter5_47 in pairs(var14_47) do
		iter5_47.user = var9_47

		local var15_47 = var11_47:GetShipByRealId(var9_47.id, iter5_47.id)

		iter5_47.id = GuildAssaultFleet.GetVirtualId(var9_47.id, iter5_47.id)

		if var15_47 then
			iter5_47.guildRecommand = var15_47.guildRecommand
		end

		table.insert(var0_47, GuildAssaultShip.ConverteFromShip(iter5_47))
	end

	local var16_47 = {}

	if arg3_47 then
		table.insert(var16_47, arg3_47.ship.id)
	end

	for iter6_47, iter7_47 in ipairs(var5_47:GetShipIds()) do
		if iter7_47 then
			table.insert(var16_47, GuildAssaultFleet.GetVirtualId(iter7_47.uid, iter7_47.id))
		end
	end

	local var17_47 = var5_47:GetShips()

	arg0_47:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		selectedMin = 1,
		selectedMax = 1,
		quitTeam = arg3_47,
		ignoredIds = var16_47,
		teamFilter = arg1_47,
		shipVOs = var0_47,
		mode = DockyardScene.MODE_GUILD_BOSS,
		hideTagFlags = ShipStatus.TAG_HIDE_CHALLENGE,
		onShip = function(arg0_48, arg1_48, arg2_48)
			if var5_47:GetOtherMemberShipCnt(var9_47.id) + var10_47 >= 3 and arg0_48.user.id ~= var9_47.id then
				return false, i18n("guild_boss_formation_1")
			end

			if arg0_48.user.id ~= var9_47.id and var5_47:ExistUserShip(arg0_48.user.id) then
				return false, i18n("guild_boss_formation_2")
			end

			if _.any(var17_47, function(arg0_49)
				return arg0_49.ship:isSameKind(arg0_48)
			end) then
				return false, i18n("guild_boss_formation_3")
			end

			local var0_48 = GuildAssaultFleet.GetRealId(arg0_48.id)

			if pg.ShipFlagMgr.GetInstance():GetShipFlag(var0_48, "inEvent") then
				return false, i18n("word_shipState_collect")
			end

			if arg0_48:isActivityNpc() then
				return false, i18n("common_npc_formation_tip")
			end

			return true
		end,
		onSelected = function(arg0_50, arg1_50)
			local var0_50 = arg0_50[1]

			if var0_50 then
				local var1_50 = GuildAssaultFleet.GetRealId(var0_50)
				local var2_50 = GuildAssaultFleet.GetUserId(var0_50)

				var5_47:AddUserShip(var2_50, var1_50, var6_47)
			end

			arg0_47.contextData.editBossFleet[arg2_47] = var5_47
		end
	})
end

function var0_0.OnSelectShips(arg0_51, arg1_51, arg2_51, arg3_51)
	local var0_51 = arg3_51:GetShipList()

	arg0_51.contextData.editFleet = Clone(arg3_51)

	local var1_51 = getProxy(BayProxy):getData()
	local var2_51 = {}

	if arg2_51 then
		table.insert(var2_51, arg2_51.id)
	end

	arg0_51:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		selectedMin = 1,
		selectedMax = 1,
		ignoredIds = var2_51,
		onShip = function(arg0_52, arg1_52, arg2_52)
			for iter0_52, iter1_52 in pairs(var0_51) do
				local var0_52 = GuildAssaultFleet.GetRealId(iter1_52.id)

				if iter0_52 ~= arg1_51 and var0_52 == arg0_52.id then
					return false, i18n("guild_fleet_exist_same_kind_ship")
				end
			end

			if arg0_52:isActivityNpc() then
				return false, i18n("common_npc_formation_tip")
			end

			return true
		end,
		onSelected = function(arg0_53, arg1_53)
			local var0_53 = arg0_53[1]
			local var1_53 = var1_51[var0_53]

			arg0_51.contextData.editFleet:InsertBayShip(arg1_51, var1_53)
		end
	})
end

function var0_0.OnCheckMissionShip(arg0_54, arg1_54, arg2_54)
	local var0_54 = getProxy(GuildProxy):getData()
	local var1_54 = getProxy(PlayerProxy):getRawData().id
	local var2_54 = var0_54:getMemberById(var1_54)
	local var3_54 = var2_54:GetAssaultFleet()
	local var4_54 = var2_54:GetExternalAssaultFleet()
	local var5_54 = var0_54:GetActiveEvent()
	local var6_54 = var5_54:GetJoinShips()
	local var7_54 = getProxy(BayProxy):getData()
	local var8_54 = _.map(arg1_54, function(arg0_55)
		return var7_54[arg0_55]
	end)

	if arg2_54:isActivityNpc() then
		return false, i18n("common_npc_formation_tip")
	end

	local var9_54 = var5_54:GetMissionById(arg0_54):GetMyShips()

	if _.any(var9_54, function(arg0_56)
		return var7_54[arg0_56] and var7_54[arg0_56]:isSameKind(arg2_54)
	end) then
		return false, i18n("guild_event_exist_same_kind_ship")
	end

	if _.any(var8_54, function(arg0_57)
		return arg0_57:isSameKind(arg2_54)
	end) then
		return false, i18n("guild_event_exist_same_kind_ship")
	end

	local var10_54 = GuildAssaultFleet.GetVirtualId(var1_54, arg2_54.id)

	if var3_54:ExistShip(var10_54) then
		return false, i18n("guild_event_exist_assult_ship")
	end

	if var4_54:ExistShip(var10_54) then
		return false, i18n("guild_event_exist_assult_ship")
	end

	if _.any(var6_54, function(arg0_58)
		return arg2_54.id == arg0_58
	end) then
		return false, i18n("guidl_event_ship_in_event")
	end

	return true
end

function var0_0.OnSelectMissionShips(arg0_59, arg1_59, arg2_59, arg3_59)
	if not arg0_59.contextData.missionShips then
		arg0_59.contextData.missionShips = Clone(arg3_59)
	end

	local var0_59 = getProxy(GuildProxy):getData()
	local var1_59 = getProxy(PlayerProxy):getRawData().id
	local var2_59 = var0_59:getMemberById(var1_59):GetAssaultFleet()
	local var3_59 = _.map(var2_59:GetShipIds(), function(arg0_60)
		return GuildAssaultFleet.GetRealId(arg0_60)
	end)

	_.each(arg3_59, function(arg0_61)
		table.insert(var3_59, arg0_61)
	end)

	local var4_59 = var0_59:GetActiveEvent():GetJoinShips()

	_.each(var4_59, function(arg0_62)
		table.insert(var3_59, arg0_62)
	end)
	arg0_59:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		selectedMin = 1,
		selectedMax = 1,
		quitTeam = arg3_59[arg2_59],
		ignoredIds = var3_59,
		onShip = function(arg0_63)
			return var0_0.OnCheckMissionShip(arg1_59, arg3_59, arg0_63)
		end,
		onSelected = function(arg0_64, arg1_64)
			if arg3_59[arg2_59] then
				for iter0_64, iter1_64 in ipairs(arg0_59.contextData.missionShips) do
					if iter1_64 == arg3_59[arg2_59] then
						table.remove(arg0_59.contextData.missionShips, iter0_64)
					end
				end
			end

			table.insert(arg0_59.contextData.missionShips, arg0_64[1])
		end
	})
end

function var0_0.OnComanderOP(arg0_65, arg1_65)
	local var0_65 = arg1_65.data

	if var0_65.type == LevelUIConst.COMMANDER_OP_RENAME then
		local var1_65 = var0_65.id
		local var2_65 = var0_65.str
		local var3_65 = var0_65.onFailed

		arg0_65:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME, {
			id = var1_65,
			name = var2_65,
			onFailed = var3_65
		})
	elseif var0_65.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
		local var4_65 = var0_65.id
		local var5_65 = var0_65.fleet:getCommanders()

		arg0_65:sendNotification(GAME.SET_COMMANDER_PREFAB, {
			id = var4_65,
			commanders = Clone(var5_65)
		})
	else
		local var6_65 = var0_65.id
		local var7_65 = var0_65.fleet

		if not arg0_65.contextData.editBossFleet then
			arg0_65.contextData.editBossFleet = {}
		end

		if not arg0_65.contextData.editBossFleet[var7_65.id] then
			arg0_65.contextData.editBossFleet[var7_65.id] = Clone(var7_65)
		end

		local var8_65 = arg0_65.contextData.editBossFleet[var7_65.id]

		if var0_65.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var9_65 = getProxy(GuildProxy):getData():GetActiveEvent():GetBossMission()

			var8_65:ClearCommanders()

			local var10_65 = getProxy(CommanderProxy):getPrefabFleetById(var6_65):getCommander()
			local var11_65 = {}

			for iter0_65, iter1_65 in pairs(var10_65) do
				table.insert(var11_65, function(arg0_66)
					arg0_65:OnDockSelectCommander(false, var8_65, iter0_65, var9_65, {
						iter1_65.id
					}, arg0_66)
				end)
			end

			seriesAsync(var11_65, function()
				arg0_65.viewComponent:OnBossCommanderFormationChange()
			end)
		elseif var0_65.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			var8_65:ClearCommanders()
			arg0_65.viewComponent:OnBossCommanderFormationChange()
		end
	end
end

function var0_0.listNotificationInterests(arg0_68)
	return {
		PlayerProxy.UPDATED,
		GuildProxy.GUILD_UPDATED,
		GAME.GUILD_ACTIVE_EVENT_DONE,
		GuildProxy.GUILD_BATTLE_STARTED,
		GAME.GUILD_UPDATE_MY_ASSAULT_FLEET_DONE,
		GAME.GUILD_JOIN_MISSION_DONE,
		GAME.GUILD_REFRESH_MISSION_DONE,
		GAME.GUILD_GET_BOSS_INFO_DONE,
		GAME.GET_GUILD_BOSS_RANK_DONE,
		GAME.GUILD_UPDATE_NODE_ANIM_FLAG_DONE,
		GAME.GUILD_UPDATE_BOSS_FORMATION_DONE,
		GAME.GUILD_GET_ASSAULT_FLEET_DONE,
		GAME.GUILD_GET_MY_ASSAULT_FLEET_DONE,
		GAME.SUBMIT_GUILD_REPORT_DONE,
		GAME.ON_GUILD_JOIN_EVENT_DONE,
		GAME.GUILD_END_BATTLE,
		GuildProxy.ON_EXIST_DELETED_MEMBER,
		GAME.GUILD_RECOMMAND_ASSULT_SHIP_DONE,
		GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE_DONE,
		TaskProxy.TASK_PROGRESS_UPDATE,
		GAME.SET_COMMANDER_PREFAB_NAME_DONE,
		GAME.SET_COMMANDER_PREFAB_DONE,
		GAME.ON_GUILD_EVENT_END
	}
end

function var0_0.handleNotification(arg0_69, arg1_69)
	local var0_69 = arg1_69:getName()
	local var1_69 = arg1_69:getBody()

	if var0_69 == PlayerProxy.UPDATED then
		arg0_69.viewComponent:SetPlayer(var1_69)
	elseif var0_69 == GuildProxy.GUILD_UPDATED then
		arg0_69.viewComponent:UpdateGuild(var1_69)
	elseif var0_69 == GAME.GUILD_ACTIVE_EVENT_DONE then
		arg0_69:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
			force = true,
			callback = function()
				arg0_69.viewComponent:EnterEvent()
			end
		})
	elseif var0_69 == GAME.GUILD_UPDATE_MY_ASSAULT_FLEET_DONE then
		arg0_69.contextData.editFleet = nil

		arg0_69.viewComponent:OnMyAssultFleetFormationDone()
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_start_done"))
	elseif var0_69 == GAME.GUILD_JOIN_MISSION_DONE then
		arg0_69.contextData.missionShips = nil

		arg0_69:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = var1_69.id
		})
		arg0_69.viewComponent:OnMissionFormationDone()
	elseif var0_69 == GAME.GUILD_REFRESH_MISSION_DONE then
		arg0_69.viewComponent:RefreshMission(var1_69.id)
	elseif var0_69 == GAME.GUILD_GET_BOSS_INFO_DONE then
		arg0_69.viewComponent:RefreshBossMission()
	elseif var0_69 == GAME.GET_GUILD_BOSS_RANK_DONE then
		arg0_69.viewComponent:OnBossRankUpdate()
	elseif var0_69 == GAME.GUILD_UPDATE_NODE_ANIM_FLAG_DONE then
		arg0_69.viewComponent:RefreshMission(var1_69.id)
	elseif var0_69 == GAME.GUILD_UPDATE_BOSS_FORMATION_DONE then
		arg0_69.contextData.editBossFleet = nil

		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fleet_update_done"))
		arg0_69.viewComponent:OnBossMissionFormationChanged()
	elseif var0_69 == GAME.GUILD_GET_ASSAULT_FLEET_DONE then
		arg0_69.viewComponent:OnMemberAssultFleetUpdate()
	elseif var0_69 == GAME.GUILD_GET_MY_ASSAULT_FLEET_DONE then
		arg0_69.viewComponent:OnMyAssultFleetUpdate()
	elseif var0_69 == GAME.SUBMIT_GUILD_REPORT_DONE then
		arg0_69.viewComponent:OnReportUpdated()
	elseif var0_69 == GuildProxy.GUILD_BATTLE_STARTED then
		local var2_69 = getProxy(GuildProxy):getRawData():IsAdministrator()
		local var3_69 = i18n("guild_event_start_tip1")

		if var2_69 and arg0_69.viewComponent.eventInfoPage and arg0_69.viewComponent.eventInfoPage:GetLoaded() and arg0_69.viewComponent.eventInfoPage:isShowing() then
			var3_69 = i18n("guild_event_start_tip2")
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideNo = true,
			content = var3_69,
			onYes = function()
				arg0_69:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = true,
					callback = function()
						arg0_69.viewComponent:EnterEvent()
					end
				})
			end
		})
	elseif var0_69 == GAME.ON_GUILD_JOIN_EVENT_DONE then
		arg0_69.viewComponent:EnterEvent()
	elseif var0_69 == GAME.GUILD_END_BATTLE then
		arg0_69.viewComponent:EnterEvent()
	elseif var0_69 == GuildProxy.ON_EXIST_DELETED_MEMBER then
		arg0_69.viewComponent:OnMemberDeleted()
	elseif var0_69 == GAME.GUILD_RECOMMAND_ASSULT_SHIP_DONE then
		arg0_69.viewComponent:OnAssultShipBeRecommanded(var1_69.shipId)
	elseif var0_69 == GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE_DONE then
		arg0_69.viewComponent:OnRefreshAllAssultShipRecommandState()
	elseif var0_69 == TaskProxy.TASK_PROGRESS_UPDATE then
		pg.GuildMsgBoxMgr.GetInstance():NotificationForGuildEvent(var1_69)
	elseif var0_69 == GAME.SET_COMMANDER_PREFAB_NAME_DONE or var0_69 == GAME.SET_COMMANDER_PREFAB_DONE then
		arg0_69.viewComponent:OnBossCommanderPrefabFormationChange()
	elseif var0_69 == GAME.ON_GUILD_EVENT_END then
		arg0_69.viewComponent:OnEventEnd()
	end
end

return var0_0
