local var0 = class("GuildMissionBossFormationPage", import(".GuildEventBasePage"))

function var0.getUIName(arg0)
	return "GuildBossFormationPage"
end

function var0.OnLoaded(arg0)
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.descTxt = arg0:findTF("frame/bottom/target/scrollrect/Text"):GetComponent(typeof(Text))
	arg0.awardList = UIItemList.New(arg0:findTF("frame/bottom/award/list"), arg0:findTF("frame/bottom/award/list/item"))
	arg0.titleTxt = arg0:findTF("frame/title"):GetComponent(typeof(Text))
	arg0.goBtn = arg0:findTF("frame/bottom/go")
	arg0.consumeTxt = arg0:findTF("oil/Text", arg0.goBtn):GetComponent(typeof(Text))
	arg0.recomBtn = arg0:findTF("frame/recom")
	arg0.clearBtn = arg0:findTF("frame/clear")
	arg0.grids = arg0:findTF("frame/double")
	arg0.subGrids = arg0:findTF("frame/single")
	arg0.nextBtn = arg0:findTF("frame/next")
	arg0.prevBtn = arg0:findTF("frame/prev")
	arg0._autoToggle = arg0:findTF("frame/auto_toggle")
	arg0._autoSubToggle = arg0:findTF("frame/sub_toggle")
	arg0.commanderPage = GuildCommanderFormationPage.New(arg0:findTF("frame/commanders"), arg0.event, arg0.contextData)

	setText(arg0:findTF("oil/label", arg0.goBtn), i18n("text_consume"))

	arg0.flag = arg0:findTF("frame/double/1/flag")
	arg0.subFlag = arg0:findTF("frame/single/1/flag")
	arg0.shipCards = {}
end

function var0.Show(arg0, arg1, arg2, arg3)
	var0.super.Show(arg0, arg1, arg2, arg3)

	Input.multiTouchEnabled = false
end

function var0.Hide(arg0, arg1)
	var0.super.Hide(arg0, arg1)

	Input.multiTouchEnabled = true
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.nextBtn, function()
		arg0:UpdateFleet(GuildBossMission.SUB_FLEET_ID)
	end, SFX_PANEL)
	onButton(arg0, arg0.prevBtn, function()
		arg0:UpdateFleet(GuildBossMission.MAIN_FLEET_ID)
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		if arg0.contextData.editBossFleet then
			arg0:emit(GuildEventMediator.ON_SAVE_FORMATION, function()
				arg0:Hide()
			end)
		else
			arg0:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		arg0:emit(GuildEventMediator.ON_UPDATE_BOSS_FLEET)
	end, SFX_PANEL)
	onButton(arg0, arg0.recomBtn, function()
		arg0:emit(GuildEventMediator.ON_RECOMM_BOSS_BATTLE_SHIPS, arg0.fleet.id)
	end, SFX_PANEL)
	onButton(arg0, arg0.clearBtn, function()
		if not arg0.contextData.editBossFleet then
			arg0.contextData.editBossFleet = {}
		end

		local var0 = arg0.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID
		local var1 = Clone(arg0.fleet)

		var1:RemoveAll()

		arg0.contextData.editBossFleet[var0] = var1

		arg0:UpdateFleet(var0)
	end, SFX_PANEL)
end

function var0.UpdateMission(arg0, arg1, arg2)
	arg0.bossMission = arg1

	if arg2 then
		local var0 = arg0.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID

		arg0:UpdateFleet(var0)
	end
end

function var0.OnBossCommanderFormationChange(arg0)
	local var0 = arg0.fleet.id

	arg0.fleet = arg0.contextData.editBossFleet[var0]

	arg0:UpdateCommanders(arg0.fleet)
end

function var0.OnBossCommanderPrefabFormationChange(arg0)
	arg0:UpdateCommanders(arg0.fleet)
end

function var0.OnShow(arg0)
	arg0.isOpenCommander = arg0:CheckCommanderPanel()
	arg0.guild = arg0.guild

	arg0:UpdateMission(arg0.extraData.mission, true)
	arg0:UpdateDesc()

	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.guildset.use_oil.key_value
	local var2 = var0:getResource(2)
	local var3 = var1 <= var2 and COLOR_GREEN or COLOR_RED

	arg0.consumeTxt.text = string.format("<color=%s>%d</color>/%d", var3, var2, var1)
	arg0.isOpenAuto = ys.Battle.BattleState.IsAutoBotActive(SYSTEM_GUILD)

	local var4 = AutoBotCommand.GetAutoBotMark(SYSTEM_GUILD)

	arg0:OnSwitch(arg0._autoToggle, arg0.isOpenAuto, function(arg0)
		arg0.isOpenAuto = arg0

		arg0:UpdateSubToggle()
		PlayerPrefs.SetInt("autoBotIsAcitve" .. var4, arg0 and 1 or 0)
		PlayerPrefs.Save()
	end)

	local var5 = ys.Battle.BattleState.IsAutoSubActive(SYSTEM_GUILD)
	local var6 = AutoSubCommand.GetAutoSubMark(SYSTEM_GUILD)

	arg0:OnSwitch(arg0._autoSubToggle, var5, function(arg0)
		PlayerPrefs.SetInt("autoSubIsAcitve" .. var6, arg0 and 1 or 0)
		PlayerPrefs.Save()
	end)
	arg0:UpdateSubToggle()
end

function var0.GetFleet(arg0, arg1)
	local var0

	if arg0.contextData.editBossFleet then
		var0 = arg0.contextData.editBossFleet[arg1]
	end

	var0 = var0 or arg0.bossMission:GetFleetByIndex(arg1)

	return var0
end

function var0.UpdateSubToggle(arg0)
	local var0 = arg0:GetFleet(GuildBossMission.SUB_FLEET_ID)
	local var1 = arg0:GetFleet(GuildBossMission.MAIN_FLEET_ID):IsLegal()

	setActive(arg0._autoSubToggle, arg0.isOpenAuto and var1 and var0 and var0:ExistSubShip())
	setActive(arg0._autoToggle, AutoBotCommand.autoBotSatisfied() and var1)
end

function var0.OnSwitch(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("on")
	local var1 = arg1:Find("off")

	local function var2(arg0)
		setActive(var0, arg0)
		setActive(var1, not arg0)
	end

	removeOnToggle(arg1)
	var2(arg2)
	triggerToggle(arg1, arg2)
	onToggle(arg0, arg1, function(arg0)
		var2(arg0)
		arg3(arg0)
	end, SFX_PANEL)
end

function var0.CheckCommanderPanel(arg0)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0.player.level, "CommanderCatMediator") and not LOCK_COMMANDER
end

function var0.UpdateDesc(arg0)
	local var0 = arg0.bossMission

	arg0.descTxt.text = i18n("guild_boss_fleet_desc")

	local var1 = var0:GetAwards()

	arg0.awardList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]
			local var1 = {
				type = var0[1],
				id = var0[2],
				count = var0[3]
			}

			updateDrop(arg2, var1)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.awardList:align(#var1)

	arg0.titleTxt.text = var0:GetName()
end

function var0.UpdateFleet(arg0, arg1)
	local var0 = arg0.bossMission
	local var1

	if arg0.contextData.editBossFleet and arg0.contextData.editBossFleet[arg1] then
		var1 = arg0.contextData.editBossFleet[arg1]
	else
		var1 = var0:GetFleetByIndex(arg1)
	end

	arg0.fleet = var1

	arg0:UpdateShips(var1)
	arg0:UpdateCommanders(var1)

	arg0.contextData.bossFormationIndex = arg1

	setActive(arg0.nextBtn, arg1 == GuildBossMission.MAIN_FLEET_ID)
	setActive(arg0.prevBtn, arg1 == GuildBossMission.SUB_FLEET_ID)
	arg0:UpdateSubToggle()
end

function var0.UpdateCommanders(arg0, arg1)
	if arg0.isOpenCommander then
		local var0 = getProxy(CommanderProxy):getPrefabFleet()

		arg0.commanderPage:ExecuteAction("Update", arg1, var0)
	end
end

function var0.UpdateShips(arg0, arg1)
	arg0:ClearShips()

	local var0 = arg1:GetShips()
	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		if iter1 and iter1.ship then
			local var4 = iter1.ship:getTeamType()

			if var4 == TeamType.Vanguard then
				table.insert(var2, iter1)
			elseif var4 == TeamType.Main then
				table.insert(var1, iter1)
			elseif var4 == TeamType.Submarine then
				table.insert(var3, iter1)
			end
		end
	end

	local var5 = arg1:IsMainFleet()

	if var5 then
		arg0:UpdateMainFleetShips(var1, var2)
	else
		arg0:UpdateSubFleetShips(var3)
	end

	setActive(arg0.flag, var5 and #var1 > 0)
	setActive(arg0.subFlag, not var5 and #var3 > 0)
	setActive(arg0.grids, var5)
	setActive(arg0.subGrids, not var5)
end

function var0.UpdateMainFleetShips(arg0, arg1, arg2)
	for iter0 = 1, 3 do
		local var0 = arg0.grids:Find(iter0)
		local var1 = arg1[iter0]

		arg0:UpdateShip(iter0, var0, TeamType.Main, var1)
	end

	for iter1 = 4, 6 do
		local var2 = arg0.grids:Find(iter1)
		local var3 = arg2[iter1 - 3]

		arg0:UpdateShip(iter1, var2, TeamType.Vanguard, var3)
	end
end

function var0.UpdateSubFleetShips(arg0, arg1)
	for iter0 = 1, 3 do
		local var0 = arg0.subGrids:Find(iter0)
		local var1 = arg1[iter0]

		arg0:UpdateShip(iter0, var0, TeamType.Submarine, var1)
	end
end

function var0.UpdateShip(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg2:Find("Image")

	if arg4 then
		local var1 = arg4.ship
		local var2 = var1:getPrefab()

		PoolMgr.GetInstance():GetSpineChar(var2, true, function(arg0)
			arg0.name = var2

			SetParent(arg0, arg2.parent)

			local var0 = GuildBossFormationShipCard.New(arg0)

			var0:Update(var1, arg1)
			SetAction(arg0, "stand")

			local var1 = GetOrAddComponent(arg0, "EventTriggerListener")

			var1:AddPointClickFunc(function(arg0, arg1)
				if arg0.dragging then
					return
				end

				arg0:emit(GuildEventMediator.ON_SELECT_BOSS_SHIP, arg3, arg0.fleet.id, arg4)
			end)
			var1:AddBeginDragFunc(function(arg0, arg1)
				arg0.dragging = true

				arg0.transform:SetAsLastSibling()
				SetAction(arg0, "tuozhuai")
			end)
			var1:AddDragFunc(function(arg0, arg1)
				local var0 = var0.Scr2Lpos(arg2.parent, arg1.position)

				var0:SetLocalPosition(var0)

				local var1 = arg0:GetNearestCard(var0)

				if var1 then
					arg0:SwopCardSolt(var1, var0)
				end
			end)
			var1:AddDragEndFunc(function(arg0, arg1)
				arg0.dragging = false

				var0:RefreshPosition(var0:GetSoltIndex(), true)
				SetAction(arg0, "stand")
				arg0:RefreshFleet()
			end)
			table.insert(arg0.shipCards, var0)
		end)
	else
		onButton(arg0, var0, function()
			arg0:emit(GuildEventMediator.ON_SELECT_BOSS_SHIP, arg3, arg0.fleet.id)
		end, SFX_PANEL)
	end

	setActive(var0, not arg4)
end

function var0.GetNearestCard(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.shipCards) do
		if iter1:GetSoltIndex() ~= arg1:GetSoltIndex() and iter1.teamType == arg1.teamType and Vector2.Distance(arg1:GetLocalPosition(), iter1:GetLocalPosition()) <= 50 then
			return iter1
		end
	end

	return nil
end

function var0.SwopCardSolt(arg0, arg1, arg2)
	local var0 = arg1:GetSoltIndex()

	arg1:RefreshPosition(arg2:GetSoltIndex(), true)
	arg2:RefreshPosition(var0, false)
end

function var0.RefreshFleet(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.shipCards) do
		table.insert(var0, {
			index = iter1:GetSoltIndex(),
			shipId = iter1.shipId
		})
	end

	table.sort(var0, function(arg0, arg1)
		return arg0.index < arg1.index
	end)

	if not arg0.contextData.editBossFleet then
		arg0.contextData.editBossFleet = {}
	end

	if not arg0.contextData.editBossFleet[arg0.fleet.id] then
		arg0.contextData.editBossFleet[arg0.fleet.id] = Clone(arg0.fleet)
		arg0.fleet = arg0.contextData.editBossFleet[arg0.fleet.id]
	end

	arg0.fleet:ResortShips(var0)
end

function var0.ClearShips(arg0)
	for iter0, iter1 in ipairs(arg0.shipCards) do
		iter1:Dispose()
	end

	arg0.shipCards = {}
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
	arg0:ClearShips()
	arg0.commanderPage:Destroy()
end

function var0.Scr2Lpos(arg0, arg1)
	local var0 = GameObject.Find("OverlayCamera"):GetComponent("Camera")
	local var1 = arg0:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1, arg1, var0))
end

return var0
