local var0 = class("GuildEventMediator", import("...base.ContextMediator"))

var0.ON_ACTIVE_EVENT = "GuildEventMediator:ON_ACTIVE_EVENT"
var0.ON_OPEN_REPORT = "GuildEventMediator:ON_OPEN_REPORT"
var0.ON_GET_FORMATION = "GuildEventMediator:ON_GET_FORMATION"
var0.UPDATE_FORMATION = "GuildEventMediator:UPDATE_FORMATION"
var0.ON_SELECT_SHIP = "GuildEventMediator:ON_SELECT_SHIP"
var0.ON_SELECT_MISSION_SHIP = "GuildEventMediator:ON_SELECT_MISSION_SHIP"
var0.REFRESH_MISSION = "GuildEventMediator:REFRESH_MISSION"
var0.JOIN_MISSION = "GuildEventMediator:JOIN_MISSION"
var0.ON_GET_BOSS_INFO = "GuildEventMediator:ON_GET_BOSS_INFO"
var0.ON_REFRESH_BOSS_RANK = "GuildEventMediator:ON_REFRESH_BOSS_RANK"
var0.ON_UPDATE_NODE_ANIM_FLAG = "GuildEventMediator:ON_UPDATE_NODE_ANIM_FLAG"
var0.ON_SELECT_BOSS_SHIP = "GuildEventMediator:ON_SELECT_BOSS_SHIP"
var0.ON_UPDATE_BOSS_FLEET = "GuildEventMediator:ON_UPDATE_BOSS_FLEET"
var0.ON_RECOMM_BOSS_BATTLE_SHIPS = "GuildEventMediator:ON_RECOMM_BOSS_BATTLE_SHIPS"
var0.ON_GET_ALL_ASSULT_FLEET = "GuildEventMediator:ON_GET_ALL_ASSULT_FLEET"
var0.ON_SELECT_COMMANDER = "GuildEventMediator:ON_SELECT_COMMANDER"
var0.FORCE_REFRESH_MISSION = "GuildEventMediator:FORCE_REFRESH_MISSION"
var0.ON_SAVE_FORMATION = "GuildEventMediator:ON_SAVE_FORMATION"
var0.ON_JOIN_EVENT = "GuildEventMediator:ON_JOIN_EVENT"
var0.ON_RECOMM_ASSULT_SHIP = "GuildEventMediator:ON_RECOMM_ASSULT_SHIP"
var0.REFRESH_RECOMMAND_SHIPS = "GuildEventMediator:REFRESH_RECOMMAND_SHIPS"
var0.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP = "GuildEventMediator:ON_CLEAR_BOSS_FLEET_INVAILD_SHIP"
var0.ON_CMD_SKILL = "GuildEventMediator:ON_CMD_SKILL"
var0.COMMANDER_FORMATION_OP = "GuildEventMediator:COMMANDER_FORMATION_OP"

function var0.register(arg0)
	arg0:bind(var0.COMMANDER_FORMATION_OP, function(arg0, arg1)
		arg0:OnComanderOP(arg1)
	end)
	arg0:bind(var0.ON_CMD_SKILL, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				skill = arg1
			}
		}))
	end)
	arg0:bind(var0.REFRESH_RECOMMAND_SHIPS, function(arg0, arg1)
		arg0:sendNotification(GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE, {
			callback = arg1
		})
	end)
	arg0:bind(var0.ON_RECOMM_ASSULT_SHIP, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_RECOMMAND_ASSULT_SHIP, {
			shipId = arg1,
			cmd = arg2
		})
	end)
	arg0:bind(var0.ON_JOIN_EVENT, function()
		arg0:sendNotification(GAME.ON_GUILD_JOIN_EVENT)
	end)
	arg0:bind(var0.ON_SELECT_COMMANDER, function(arg0, arg1, arg2, arg3)
		arg0:SelectBossBattleCommander(arg1, arg2, arg3)
	end)
	arg0:bind(var0.ON_GET_ALL_ASSULT_FLEET, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {
			callback = arg1
		})
	end)
	arg0:bind(var0.ON_RECOMM_BOSS_BATTLE_SHIPS, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {
			callback = function()
				arg0:RecommShipsForBossBattle(arg1)
			end
		})
	end)
	arg0:bind(var0.ON_SAVE_FORMATION, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
			editFleet = arg0.contextData.editBossFleet,
			callback = arg1
		})
	end)
	arg0:bind(var0.ON_CLEAR_BOSS_FLEET_INVAILD_SHIP, function(arg0)
		arg0:sendNotification(GAME.GUILD_UPDATE_BOSS_FORMATION, {
			force = true,
			editFleet = arg0.contextData.editBossFleet
		})
	end)
	arg0:bind(var0.ON_UPDATE_BOSS_FLEET, function(arg0)
		if not arg0.contextData.editBossFleet then
			arg0:StartBossBattle()
		else
			arg0.viewComponent:emit(var0.ON_SAVE_FORMATION, function()
				arg0:StartBossBattle()
			end)
		end
	end)
	arg0:bind(var0.ON_SELECT_BOSS_SHIP, function(arg0, arg1, arg2, arg3)
		arg0:sendNotification(GAME.GUILD_GET_ASSAULT_FLEET, {
			callback = function()
				arg0:SelectBossBattleShip(arg1, arg2, arg3)
			end
		})
	end)
	arg0:bind(var0.ON_UPDATE_NODE_ANIM_FLAG, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_UPDATE_NODE_ANIM_FLAG, {
			id = arg1,
			position = arg2
		})
	end)
	arg0:bind(var0.ON_REFRESH_BOSS_RANK, function(arg0)
		arg0:sendNotification(GAME.GET_GUILD_BOSS_RANK, {})
	end)
	arg0:bind(var0.ON_GET_BOSS_INFO, function(arg0)
		arg0:sendNotification(GAME.GUILD_GET_BOSS_INFO)
	end)
	arg0:bind(var0.JOIN_MISSION, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_JOIN_MISSION, {
			id = arg1,
			shipIds = arg2
		})
	end)
	arg0:bind(var0.ON_SELECT_MISSION_SHIP, function(arg0, arg1, arg2, arg3)
		arg0.viewComponent:emit(var0.ON_GET_FORMATION, function()
			arg0:OnSelectMissionShips(arg1, arg2, arg3)
		end)
	end)
	arg0:bind(var0.REFRESH_MISSION, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = false,
			id = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.FORCE_REFRESH_MISSION, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = arg1,
			callback = arg2
		})
	end)
	arg0:bind(var0.ON_SELECT_SHIP, function(arg0, arg1, arg2, arg3)
		arg0:OnSelectShips(arg1, arg2, arg3)
	end)
	arg0:bind(var0.ON_GET_FORMATION, function(arg0, arg1)
		local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()
		local var1 = {}

		if var0 then
			table.insert(var1, function(arg0)
				arg0.viewComponent:emit(var0.ON_GET_ALL_ASSULT_FLEET, arg0)
			end)
		end

		if not getProxy(GuildProxy).isFetchAssaultFleet then
			table.insert(var1, function(arg0)
				arg0:sendNotification(GAME.GUILD_GET_MY_ASSAULT_FLEET, {
					callback = arg0
				})
			end)
		end

		seriesAsync(var1, arg1)
	end)
	arg0:bind(var0.UPDATE_FORMATION, function(arg0)
		if not arg0.contextData.editFleet then
			return
		end

		arg0:sendNotification(GAME.GUILD_UPDATE_MY_ASSAULT_FLEET, {
			fleet = arg0.contextData.editFleet
		})
	end)
	arg0:bind(var0.ON_ACTIVE_EVENT, function(arg0, arg1)
		arg0:sendNotification(GAME.GUILD_ACTIVE_EVENT, {
			eventId = arg1
		})
	end)
	arg0:bind(var0.ON_OPEN_REPORT, function(arg0)
		arg0:sendNotification(GAME.GUILD_OPEN_EVENT_REPORT)
	end)
	arg0.viewComponent:SetPlayer(getProxy(PlayerProxy):getRawData())

	local var0 = getProxy(GuildProxy)

	arg0.viewComponent:SetGuild(var0:getData())
end

function var0.StartBossBattle(arg0)
	local var0 = getProxy(GuildProxy):getRawData():GetActiveEvent()

	if not var0 or var0 and var0:IsExpired() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_battle_is_end"))

		return
	end

	local var1 = var0:GetBossMission()

	if not var1 then
		return
	end

	local var2 = var1:GetMainFleet()
	local var3, var4 = var2:IsLegal()

	if not var3 then
		pg.TipsMgr.GetInstance():ShowTips(var4)

		return
	end

	local var5, var6 = var1:GetSubFleet():IsLegal()

	if not var5 then
		pg.TipsMgr.GetInstance():ShowTips(var6)

		return
	end

	local var7 = var2:GetDownloadResShips()
	local var8 = {}

	for iter0, iter1 in ipairs(var7) do
		PaintingGroupConst.AddPaintingNameWithFilteMap(var8, iter1)
	end

	local function var9()
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_GUILD
		})
	end

	PaintingGroupConst.PaintingDownload({
		isShowBox = true,
		paintingNameList = var8,
		finishFunc = var9
	})
end

function var0.SelectBossBattleCommander(arg0, arg1, arg2, arg3)
	if not arg0.contextData.editBossFleet then
		arg0.contextData.editBossFleet = {}
	end

	local var0 = getProxy(GuildProxy):getData():GetActiveEvent()

	if not var0 then
		return
	end

	local var1 = var0:GetBossMission()

	if not arg0.contextData.editBossFleet[arg1] then
		arg0.contextData.editBossFleet[arg1] = Clone(var1:GetFleetByIndex(arg1))
	end

	local var2 = arg0.contextData.editBossFleet[arg1]
	local var3 = var2:getCommanders()
	local var4 = {}

	if arg3 then
		table.insert(var4, arg3.id)
	end

	pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COMMANDERCAT, {
		maxCount = 1,
		mode = CommanderCatScene.MODE_SELECT,
		fleetType = CommanderCatScene.FLEET_TYPE_GUILDBOSS,
		activeCommander = arg3,
		ignoredIds = var4,
		fleets = arg0.contextData.editBossFleet,
		onCommander = function(arg0)
			return true
		end,
		onSelected = function(arg0, arg1)
			arg0:OnDockSelectCommander(true, var2, arg2, var1, arg0, arg1)
		end,
		onQuit = function(arg0)
			var2:RemoveCommander(arg2)
			arg0()
		end
	})
end

function var0.OnDockSelectCommander(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg5[1]
	local var1 = getProxy(CommanderProxy):getCommanderById(var0)

	if not var1 then
		arg6()

		return
	end

	local var2 = {}
	local var3 = {}
	local var4 = arg0.contextData.editBossFleet[GuildBossMission.SUB_FLEET_ID] or arg4:GetSubFleet()
	local var5 = arg0.contextData.editBossFleet[GuildBossMission.MAIN_FLEET_ID] or arg4:GetMainFleet()
	local var6 = arg2:IsMainFleet()
	local var7 = var6 and var5 or var4
	local var8 = var7:getCommanders()

	if arg1 then
		for iter0, iter1 in pairs(var8) do
			if arg3 ~= iter0 and iter1:isSameGroup(var1.groupId) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("commander_can_not_select_same_group"))

				return
			end
		end
	end

	local var9 = var6 and var4 or var5
	local var10 = var9:getCommanders()

	for iter2, iter3 in pairs(var10) do
		if iter3.id == var1.id then
			arg0:SwopCommanderForBossBattle(arg4, var1, arg3, iter2, var7, var9, arg6)

			return
		end
	end

	arg2:AddCommander(arg3, var1)
	arg6()
end

function var0.SwopCommanderForBossBattle(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	if not arg0.contextData.editBossFleet[arg6.id] then
		arg0.contextData.editBossFleet[arg6.id] = Clone(arg1:GetFleetByIndex(arg6.id))
		arg6 = arg0.contextData.editBossFleet[arg6.id]
	end

	local var0 = arg4 == 1 and i18n("commander_main_pos") or i18n("commander_assistant_pos")
	local var1 = arg5:GetName()

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("comander_repalce_tip", var1, var0),
		onYes = function()
			arg6:RemoveCommander(arg4)
			arg5:AddCommander(arg3, arg2)

			if arg7 then
				arg7()
			end
		end
	})
end

function var0.RecommShipsForBossBattle(arg0, arg1)
	if not arg0.contextData.editBossFleet then
		arg0.contextData.editBossFleet = {}
	end

	local var0 = {}
	local var1 = {}
	local var2 = {}
	local var3 = getProxy(GuildProxy):getData()
	local var4 = getProxy(PlayerProxy):getRawData()
	local var5 = var3:GetActiveEvent()

	if not var5 then
		return
	end

	local var6 = var5:GetBossMission()

	if not arg0.contextData.editBossFleet[arg1] then
		arg0.contextData.editBossFleet[arg1] = Clone(var6:GetFleetByIndex(arg1))
	end

	local var7 = arg0.contextData.editBossFleet[arg1]

	var7:RemoveAll()

	local function var8(arg0, arg1)
		if arg0 == TeamType.Main then
			table.insert(var0, arg1)
		elseif arg0 == TeamType.Vanguard then
			table.insert(var1, arg1)
		elseif arg0 == TeamType.Submarine then
			table.insert(var2, arg1)
		end
	end

	local var9 = getProxy(BayProxy):getData()

	for iter0, iter1 in pairs(var9) do
		if not pg.ShipFlagMgr.GetInstance():GetShipFlag(iter1.id, "inEvent") and not iter1:isActivityNpc() then
			iter1.id = GuildAssaultFleet.GetVirtualId(var4.id, iter1.id)

			local var10 = iter1:getShipCombatPower()

			var8(iter1:getTeamType(), {
				power = var10,
				id = iter1.id
			})
		end
	end

	local var11 = 0
	local var12 = 0
	local var13 = 0

	local function var14(arg0, arg1)
		local var0 = GuildAssaultFleet.GetRealId(arg0)
		local var1 = var9[var0]

		if not var7:ExistSameKindShip(var1) then
			local var2 = GuildAssaultFleet.GetUserId(arg0)

			var7:AddUserShip(var2, var0)

			if arg1 == TeamType.Main then
				var11 = var11 + 1
			end

			if arg1 == TeamType.Vanguard then
				var12 = var12 + 1
			end

			if arg1 == TeamType.Submarine then
				var13 = var13 + 1
			end
		end
	end

	if var7:IsMainFleet() then
		table.sort(var0, function(arg0, arg1)
			return arg0.power > arg1.power
		end)
		table.sort(var1, function(arg0, arg1)
			return arg0.power > arg1.power
		end)

		for iter2 = 1, #var0 do
			if var11 == 3 then
				break
			end

			var14(var0[iter2].id, TeamType.Main)
		end

		for iter3 = 1, #var1 do
			if var12 == 3 then
				break
			end

			var14(var1[iter3].id, TeamType.Vanguard)
		end
	else
		table.sort(var2, function(arg0, arg1)
			return arg0.power > arg1.power
		end)

		for iter4 = 1, #var2 do
			if var13 == 3 then
				break
			end

			var14(var2[iter4].id, TeamType.Submarine)
		end
	end

	local var15 = arg0.viewComponent.missBossForamtionPage

	if var15 and var15:GetLoaded() then
		var15:UpdateFleet(arg1)
	end
end

function var0.SelectBossBattleShip(arg0, arg1, arg2, arg3)
	if not arg0.contextData.editBossFleet then
		arg0.contextData.editBossFleet = {}
	end

	local var0 = {}
	local var1 = getProxy(GuildProxy):getData()
	local var2 = var1:GetActiveEvent()

	if not var2 then
		return
	end

	local var3 = var2:GetBossMission()
	local var4 = var3:GetFleetByIndex(arg2)

	assert(var4, arg2)

	local var5

	if not arg0.contextData.editBossFleet[arg2] then
		var5 = Clone(var4)
	else
		var5 = Clone(arg0.contextData.editBossFleet[arg2])
	end

	local var6

	if arg3 then
		local var7 = arg3.member.id
		local var8 = GuildAssaultFleet.GetRealId(arg3.ship.id)

		var6 = var5:RemoveUserShip(var7, var8)
	end

	local var9 = getProxy(PlayerProxy):getRawData()
	local var10 = 0

	if var5:IsMainFleet() then
		var10 = (arg0.contextData.editBossFleet[GuildBossMission.SUB_FLEET_ID] or var3:GetFleetByIndex(GuildBossMission.SUB_FLEET_ID)):GetOtherMemberShipCnt(var9.id)
	else
		var10 = (arg0.contextData.editBossFleet[GuildBossMission.MAIN_FLEET_ID] or var3:GetFleetByIndex(GuildBossMission.MAIN_FLEET_ID)):GetOtherMemberShipCnt(var9.id)
	end

	local var11

	for iter0, iter1 in pairs(var1.member) do
		local var12 = iter1:GetAssaultFleet()

		if var9.id ~= iter1.id then
			local var13 = var12:GetShipList()

			for iter2, iter3 in pairs(var13) do
				if iter3:getTeamType() == arg1 then
					iter3.user = iter1

					table.insert(var0, iter3)
				end
			end
		else
			var11 = var12
		end
	end

	local var14 = getProxy(BayProxy):getData()

	for iter4, iter5 in pairs(var14) do
		iter5.user = var9

		local var15 = var11:GetShipByRealId(var9.id, iter5.id)

		iter5.id = GuildAssaultFleet.GetVirtualId(var9.id, iter5.id)

		if var15 then
			iter5.guildRecommand = var15.guildRecommand
		end

		table.insert(var0, GuildAssaultShip.ConverteFromShip(iter5))
	end

	local var16 = {}

	if arg3 then
		table.insert(var16, arg3.ship.id)
	end

	for iter6, iter7 in ipairs(var5:GetShipIds()) do
		if iter7 then
			table.insert(var16, GuildAssaultFleet.GetVirtualId(iter7.uid, iter7.id))
		end
	end

	local var17 = var5:GetShips()

	arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		selectedMin = 1,
		selectedMax = 1,
		quitTeam = arg3,
		ignoredIds = var16,
		teamFilter = arg1,
		shipVOs = var0,
		mode = DockyardScene.MODE_GUILD_BOSS,
		hideTagFlags = ShipStatus.TAG_HIDE_CHALLENGE,
		onShip = function(arg0, arg1, arg2)
			if var5:GetOtherMemberShipCnt(var9.id) + var10 >= 3 and arg0.user.id ~= var9.id then
				return false, i18n("guild_boss_formation_1")
			end

			if arg0.user.id ~= var9.id and var5:ExistUserShip(arg0.user.id) then
				return false, i18n("guild_boss_formation_2")
			end

			if _.any(var17, function(arg0)
				return arg0.ship:isSameKind(arg0)
			end) then
				return false, i18n("guild_boss_formation_3")
			end

			local var0 = GuildAssaultFleet.GetRealId(arg0.id)

			if pg.ShipFlagMgr.GetInstance():GetShipFlag(var0, "inEvent") then
				return false, i18n("word_shipState_collect")
			end

			if arg0:isActivityNpc() then
				return false, i18n("common_npc_formation_tip")
			end

			return true
		end,
		onSelected = function(arg0, arg1)
			local var0 = arg0[1]

			if var0 then
				local var1 = GuildAssaultFleet.GetRealId(var0)
				local var2 = GuildAssaultFleet.GetUserId(var0)

				var5:AddUserShip(var2, var1, var6)
			end

			arg0.contextData.editBossFleet[arg2] = var5
		end
	})
end

function var0.OnSelectShips(arg0, arg1, arg2, arg3)
	local var0 = arg3:GetShipList()

	arg0.contextData.editFleet = Clone(arg3)

	local var1 = getProxy(BayProxy):getData()
	local var2 = {}

	if arg2 then
		table.insert(var2, arg2.id)
	end

	arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		selectedMin = 1,
		selectedMax = 1,
		ignoredIds = var2,
		onShip = function(arg0, arg1, arg2)
			for iter0, iter1 in pairs(var0) do
				local var0 = GuildAssaultFleet.GetRealId(iter1.id)

				if iter0 ~= arg1 and var0 == arg0.id then
					return false, i18n("guild_fleet_exist_same_kind_ship")
				end
			end

			if arg0:isActivityNpc() then
				return false, i18n("common_npc_formation_tip")
			end

			return true
		end,
		onSelected = function(arg0, arg1)
			local var0 = arg0[1]
			local var1 = var1[var0]

			arg0.contextData.editFleet:InsertBayShip(arg1, var1)
		end
	})
end

function var0.OnCheckMissionShip(arg0, arg1, arg2)
	local var0 = getProxy(GuildProxy):getData()
	local var1 = getProxy(PlayerProxy):getRawData().id
	local var2 = var0:getMemberById(var1)
	local var3 = var2:GetAssaultFleet()
	local var4 = var2:GetExternalAssaultFleet()
	local var5 = var0:GetActiveEvent()
	local var6 = var5:GetJoinShips()
	local var7 = getProxy(BayProxy):getData()
	local var8 = _.map(arg1, function(arg0)
		return var7[arg0]
	end)

	if arg2:isActivityNpc() then
		return false, i18n("common_npc_formation_tip")
	end

	local var9 = var5:GetMissionById(arg0):GetMyShips()

	if _.any(var9, function(arg0)
		return var7[arg0] and var7[arg0]:isSameKind(arg2)
	end) then
		return false, i18n("guild_event_exist_same_kind_ship")
	end

	if _.any(var8, function(arg0)
		return arg0:isSameKind(arg2)
	end) then
		return false, i18n("guild_event_exist_same_kind_ship")
	end

	local var10 = GuildAssaultFleet.GetVirtualId(var1, arg2.id)

	if var3:ExistShip(var10) then
		return false, i18n("guild_event_exist_assult_ship")
	end

	if var4:ExistShip(var10) then
		return false, i18n("guild_event_exist_assult_ship")
	end

	if _.any(var6, function(arg0)
		return arg2.id == arg0
	end) then
		return false, i18n("guidl_event_ship_in_event")
	end

	return true
end

function var0.OnSelectMissionShips(arg0, arg1, arg2, arg3)
	if not arg0.contextData.missionShips then
		arg0.contextData.missionShips = Clone(arg3)
	end

	local var0 = getProxy(GuildProxy):getData()
	local var1 = getProxy(PlayerProxy):getRawData().id
	local var2 = var0:getMemberById(var1):GetAssaultFleet()
	local var3 = _.map(var2:GetShipIds(), function(arg0)
		return GuildAssaultFleet.GetRealId(arg0)
	end)

	_.each(arg3, function(arg0)
		table.insert(var3, arg0)
	end)

	local var4 = var0:GetActiveEvent():GetJoinShips()

	_.each(var4, function(arg0)
		table.insert(var3, arg0)
	end)
	arg0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
		selectedMin = 1,
		selectedMax = 1,
		quitTeam = arg3[arg2],
		ignoredIds = var3,
		onShip = function(arg0)
			return var0.OnCheckMissionShip(arg1, arg3, arg0)
		end,
		onSelected = function(arg0, arg1)
			if arg3[arg2] then
				for iter0, iter1 in ipairs(arg0.contextData.missionShips) do
					if iter1 == arg3[arg2] then
						table.remove(arg0.contextData.missionShips, iter0)
					end
				end
			end

			table.insert(arg0.contextData.missionShips, arg0[1])
		end
	})
end

function var0.OnComanderOP(arg0, arg1)
	local var0 = arg1.data

	if var0.type == LevelUIConst.COMMANDER_OP_RENAME then
		local var1 = var0.id
		local var2 = var0.str
		local var3 = var0.onFailed

		arg0:sendNotification(GAME.SET_COMMANDER_PREFAB_NAME, {
			id = var1,
			name = var2,
			onFailed = var3
		})
	elseif var0.type == LevelUIConst.COMMANDER_OP_RECORD_PREFAB then
		local var4 = var0.id
		local var5 = var0.fleet:getCommanders()

		arg0:sendNotification(GAME.SET_COMMANDER_PREFAB, {
			id = var4,
			commanders = Clone(var5)
		})
	else
		local var6 = var0.id
		local var7 = var0.fleet

		if not arg0.contextData.editBossFleet then
			arg0.contextData.editBossFleet = {}
		end

		if not arg0.contextData.editBossFleet[var7.id] then
			arg0.contextData.editBossFleet[var7.id] = Clone(var7)
		end

		local var8 = arg0.contextData.editBossFleet[var7.id]

		if var0.type == LevelUIConst.COMMANDER_OP_USE_PREFAB then
			local var9 = getProxy(GuildProxy):getData():GetActiveEvent():GetBossMission()

			var8:ClearCommanders()

			local var10 = getProxy(CommanderProxy):getPrefabFleetById(var6):getCommander()
			local var11 = {}

			for iter0, iter1 in pairs(var10) do
				table.insert(var11, function(arg0)
					arg0:OnDockSelectCommander(false, var8, iter0, var9, {
						iter1.id
					}, arg0)
				end)
			end

			seriesAsync(var11, function()
				arg0.viewComponent:OnBossCommanderFormationChange()
			end)
		elseif var0.type == LevelUIConst.COMMANDER_OP_REST_ALL then
			var8:ClearCommanders()
			arg0.viewComponent:OnBossCommanderFormationChange()
		end
	end
end

function var0.listNotificationInterests(arg0)
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

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:SetPlayer(var1)
	elseif var0 == GuildProxy.GUILD_UPDATED then
		arg0.viewComponent:UpdateGuild(var1)
	elseif var0 == GAME.GUILD_ACTIVE_EVENT_DONE then
		arg0:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
			force = true,
			callback = function()
				arg0.viewComponent:EnterEvent()
			end
		})
	elseif var0 == GAME.GUILD_UPDATE_MY_ASSAULT_FLEET_DONE then
		arg0.contextData.editFleet = nil

		arg0.viewComponent:OnMyAssultFleetFormationDone()
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_event_start_done"))
	elseif var0 == GAME.GUILD_JOIN_MISSION_DONE then
		arg0.contextData.missionShips = nil

		arg0:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = var1.id
		})
		arg0.viewComponent:OnMissionFormationDone()
	elseif var0 == GAME.GUILD_REFRESH_MISSION_DONE then
		arg0.viewComponent:RefreshMission(var1.id)
	elseif var0 == GAME.GUILD_GET_BOSS_INFO_DONE then
		arg0.viewComponent:RefreshBossMission()
	elseif var0 == GAME.GET_GUILD_BOSS_RANK_DONE then
		arg0.viewComponent:OnBossRankUpdate()
	elseif var0 == GAME.GUILD_UPDATE_NODE_ANIM_FLAG_DONE then
		arg0.viewComponent:RefreshMission(var1.id)
	elseif var0 == GAME.GUILD_UPDATE_BOSS_FORMATION_DONE then
		arg0.contextData.editBossFleet = nil

		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_fleet_update_done"))
		arg0.viewComponent:OnBossMissionFormationChanged()
	elseif var0 == GAME.GUILD_GET_ASSAULT_FLEET_DONE then
		arg0.viewComponent:OnMemberAssultFleetUpdate()
	elseif var0 == GAME.GUILD_GET_MY_ASSAULT_FLEET_DONE then
		arg0.viewComponent:OnMyAssultFleetUpdate()
	elseif var0 == GAME.SUBMIT_GUILD_REPORT_DONE then
		arg0.viewComponent:OnReportUpdated()
	elseif var0 == GuildProxy.GUILD_BATTLE_STARTED then
		local var2 = getProxy(GuildProxy):getRawData():IsAdministrator()
		local var3 = i18n("guild_event_start_tip1")

		if var2 and arg0.viewComponent.eventInfoPage and arg0.viewComponent.eventInfoPage:GetLoaded() and arg0.viewComponent.eventInfoPage:isShowing() then
			var3 = i18n("guild_event_start_tip2")
		end

		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			hideNo = true,
			content = var3,
			onYes = function()
				arg0:sendNotification(GAME.GUILD_GET_ACTIVATION_EVENT, {
					force = true,
					callback = function()
						arg0.viewComponent:EnterEvent()
					end
				})
			end
		})
	elseif var0 == GAME.ON_GUILD_JOIN_EVENT_DONE then
		arg0.viewComponent:EnterEvent()
	elseif var0 == GAME.GUILD_END_BATTLE then
		arg0.viewComponent:EnterEvent()
	elseif var0 == GuildProxy.ON_EXIST_DELETED_MEMBER then
		arg0.viewComponent:OnMemberDeleted()
	elseif var0 == GAME.GUILD_RECOMMAND_ASSULT_SHIP_DONE then
		arg0.viewComponent:OnAssultShipBeRecommanded(var1.shipId)
	elseif var0 == GAME.REFRESH_ALL_ASSULT_SHIP_RECOMMAND_STATE_DONE then
		arg0.viewComponent:OnRefreshAllAssultShipRecommandState()
	elseif var0 == TaskProxy.TASK_PROGRESS_UPDATE then
		pg.GuildMsgBoxMgr.GetInstance():NotificationForGuildEvent(var1)
	elseif var0 == GAME.SET_COMMANDER_PREFAB_NAME_DONE or var0 == GAME.SET_COMMANDER_PREFAB_DONE then
		arg0.viewComponent:OnBossCommanderPrefabFormationChange()
	elseif var0 == GAME.ON_GUILD_EVENT_END then
		arg0.viewComponent:OnEventEnd()
	end
end

return var0
