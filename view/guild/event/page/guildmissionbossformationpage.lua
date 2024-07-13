local var0_0 = class("GuildMissionBossFormationPage", import(".GuildEventBasePage"))

function var0_0.getUIName(arg0_1)
	return "GuildBossFormationPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.descTxt = arg0_2:findTF("frame/bottom/target/scrollrect/Text"):GetComponent(typeof(Text))
	arg0_2.awardList = UIItemList.New(arg0_2:findTF("frame/bottom/award/list"), arg0_2:findTF("frame/bottom/award/list/item"))
	arg0_2.titleTxt = arg0_2:findTF("frame/title"):GetComponent(typeof(Text))
	arg0_2.goBtn = arg0_2:findTF("frame/bottom/go")
	arg0_2.consumeTxt = arg0_2:findTF("oil/Text", arg0_2.goBtn):GetComponent(typeof(Text))
	arg0_2.recomBtn = arg0_2:findTF("frame/recom")
	arg0_2.clearBtn = arg0_2:findTF("frame/clear")
	arg0_2.grids = arg0_2:findTF("frame/double")
	arg0_2.subGrids = arg0_2:findTF("frame/single")
	arg0_2.nextBtn = arg0_2:findTF("frame/next")
	arg0_2.prevBtn = arg0_2:findTF("frame/prev")
	arg0_2._autoToggle = arg0_2:findTF("frame/auto_toggle")
	arg0_2._autoSubToggle = arg0_2:findTF("frame/sub_toggle")
	arg0_2.commanderPage = GuildCommanderFormationPage.New(arg0_2:findTF("frame/commanders"), arg0_2.event, arg0_2.contextData)

	setText(arg0_2:findTF("oil/label", arg0_2.goBtn), i18n("text_consume"))

	arg0_2.flag = arg0_2:findTF("frame/double/1/flag")
	arg0_2.subFlag = arg0_2:findTF("frame/single/1/flag")
	arg0_2.shipCards = {}
end

function var0_0.Show(arg0_3, arg1_3, arg2_3, arg3_3)
	var0_0.super.Show(arg0_3, arg1_3, arg2_3, arg3_3)

	Input.multiTouchEnabled = false
end

function var0_0.Hide(arg0_4, arg1_4)
	var0_0.super.Hide(arg0_4, arg1_4)

	Input.multiTouchEnabled = true
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.nextBtn, function()
		arg0_5:UpdateFleet(GuildBossMission.SUB_FLEET_ID)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.prevBtn, function()
		arg0_5:UpdateFleet(GuildBossMission.MAIN_FLEET_ID)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.closeBtn, function()
		if arg0_5.contextData.editBossFleet then
			arg0_5:emit(GuildEventMediator.ON_SAVE_FORMATION, function()
				arg0_5:Hide()
			end)
		else
			arg0_5:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.goBtn, function()
		arg0_5:emit(GuildEventMediator.ON_UPDATE_BOSS_FLEET)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.recomBtn, function()
		arg0_5:emit(GuildEventMediator.ON_RECOMM_BOSS_BATTLE_SHIPS, arg0_5.fleet.id)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.clearBtn, function()
		if not arg0_5.contextData.editBossFleet then
			arg0_5.contextData.editBossFleet = {}
		end

		local var0_12 = arg0_5.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID
		local var1_12 = Clone(arg0_5.fleet)

		var1_12:RemoveAll()

		arg0_5.contextData.editBossFleet[var0_12] = var1_12

		arg0_5:UpdateFleet(var0_12)
	end, SFX_PANEL)
end

function var0_0.UpdateMission(arg0_13, arg1_13, arg2_13)
	arg0_13.bossMission = arg1_13

	if arg2_13 then
		local var0_13 = arg0_13.contextData.bossFormationIndex or GuildBossMission.MAIN_FLEET_ID

		arg0_13:UpdateFleet(var0_13)
	end
end

function var0_0.OnBossCommanderFormationChange(arg0_14)
	local var0_14 = arg0_14.fleet.id

	arg0_14.fleet = arg0_14.contextData.editBossFleet[var0_14]

	arg0_14:UpdateCommanders(arg0_14.fleet)
end

function var0_0.OnBossCommanderPrefabFormationChange(arg0_15)
	arg0_15:UpdateCommanders(arg0_15.fleet)
end

function var0_0.OnShow(arg0_16)
	arg0_16.isOpenCommander = arg0_16:CheckCommanderPanel()
	arg0_16.guild = arg0_16.guild

	arg0_16:UpdateMission(arg0_16.extraData.mission, true)
	arg0_16:UpdateDesc()

	local var0_16 = getProxy(PlayerProxy):getRawData()
	local var1_16 = pg.guildset.use_oil.key_value
	local var2_16 = var0_16:getResource(2)
	local var3_16 = var1_16 <= var2_16 and COLOR_GREEN or COLOR_RED

	arg0_16.consumeTxt.text = string.format("<color=%s>%d</color>/%d", var3_16, var2_16, var1_16)
	arg0_16.isOpenAuto = ys.Battle.BattleState.IsAutoBotActive(SYSTEM_GUILD)

	local var4_16 = AutoBotCommand.GetAutoBotMark(SYSTEM_GUILD)

	arg0_16:OnSwitch(arg0_16._autoToggle, arg0_16.isOpenAuto, function(arg0_17)
		arg0_16.isOpenAuto = arg0_17

		arg0_16:UpdateSubToggle()
		PlayerPrefs.SetInt("autoBotIsAcitve" .. var4_16, arg0_17 and 1 or 0)
		PlayerPrefs.Save()
	end)

	local var5_16 = ys.Battle.BattleState.IsAutoSubActive(SYSTEM_GUILD)
	local var6_16 = AutoSubCommand.GetAutoSubMark(SYSTEM_GUILD)

	arg0_16:OnSwitch(arg0_16._autoSubToggle, var5_16, function(arg0_18)
		PlayerPrefs.SetInt("autoSubIsAcitve" .. var6_16, arg0_18 and 1 or 0)
		PlayerPrefs.Save()
	end)
	arg0_16:UpdateSubToggle()
end

function var0_0.GetFleet(arg0_19, arg1_19)
	local var0_19

	if arg0_19.contextData.editBossFleet then
		var0_19 = arg0_19.contextData.editBossFleet[arg1_19]
	end

	var0_19 = var0_19 or arg0_19.bossMission:GetFleetByIndex(arg1_19)

	return var0_19
end

function var0_0.UpdateSubToggle(arg0_20)
	local var0_20 = arg0_20:GetFleet(GuildBossMission.SUB_FLEET_ID)
	local var1_20 = arg0_20:GetFleet(GuildBossMission.MAIN_FLEET_ID):IsLegal()

	setActive(arg0_20._autoSubToggle, arg0_20.isOpenAuto and var1_20 and var0_20 and var0_20:ExistSubShip())
	setActive(arg0_20._autoToggle, AutoBotCommand.autoBotSatisfied() and var1_20)
end

function var0_0.OnSwitch(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = arg1_21:Find("on")
	local var1_21 = arg1_21:Find("off")

	local function var2_21(arg0_22)
		setActive(var0_21, arg0_22)
		setActive(var1_21, not arg0_22)
	end

	removeOnToggle(arg1_21)
	var2_21(arg2_21)
	triggerToggle(arg1_21, arg2_21)
	onToggle(arg0_21, arg1_21, function(arg0_23)
		var2_21(arg0_23)
		arg3_21(arg0_23)
	end, SFX_PANEL)
end

function var0_0.CheckCommanderPanel(arg0_24)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg0_24.player.level, "CommanderCatMediator") and not LOCK_COMMANDER
end

function var0_0.UpdateDesc(arg0_25)
	local var0_25 = arg0_25.bossMission

	arg0_25.descTxt.text = i18n("guild_boss_fleet_desc")

	local var1_25 = var0_25:GetAwards()

	arg0_25.awardList:make(function(arg0_26, arg1_26, arg2_26)
		if arg0_26 == UIItemList.EventUpdate then
			local var0_26 = var1_25[arg1_26 + 1]
			local var1_26 = {
				type = var0_26[1],
				id = var0_26[2],
				count = var0_26[3]
			}

			updateDrop(arg2_26, var1_26)
			onButton(arg0_25, arg2_26, function()
				arg0_25:emit(BaseUI.ON_DROP, var1_26)
			end, SFX_PANEL)
		end
	end)
	arg0_25.awardList:align(#var1_25)

	arg0_25.titleTxt.text = var0_25:GetName()
end

function var0_0.UpdateFleet(arg0_28, arg1_28)
	local var0_28 = arg0_28.bossMission
	local var1_28

	if arg0_28.contextData.editBossFleet and arg0_28.contextData.editBossFleet[arg1_28] then
		var1_28 = arg0_28.contextData.editBossFleet[arg1_28]
	else
		var1_28 = var0_28:GetFleetByIndex(arg1_28)
	end

	arg0_28.fleet = var1_28

	arg0_28:UpdateShips(var1_28)
	arg0_28:UpdateCommanders(var1_28)

	arg0_28.contextData.bossFormationIndex = arg1_28

	setActive(arg0_28.nextBtn, arg1_28 == GuildBossMission.MAIN_FLEET_ID)
	setActive(arg0_28.prevBtn, arg1_28 == GuildBossMission.SUB_FLEET_ID)
	arg0_28:UpdateSubToggle()
end

function var0_0.UpdateCommanders(arg0_29, arg1_29)
	if arg0_29.isOpenCommander then
		local var0_29 = getProxy(CommanderProxy):getPrefabFleet()

		arg0_29.commanderPage:ExecuteAction("Update", arg1_29, var0_29)
	end
end

function var0_0.UpdateShips(arg0_30, arg1_30)
	arg0_30:ClearShips()

	local var0_30 = arg1_30:GetShips()
	local var1_30 = {}
	local var2_30 = {}
	local var3_30 = {}

	for iter0_30, iter1_30 in ipairs(var0_30) do
		if iter1_30 and iter1_30.ship then
			local var4_30 = iter1_30.ship:getTeamType()

			if var4_30 == TeamType.Vanguard then
				table.insert(var2_30, iter1_30)
			elseif var4_30 == TeamType.Main then
				table.insert(var1_30, iter1_30)
			elseif var4_30 == TeamType.Submarine then
				table.insert(var3_30, iter1_30)
			end
		end
	end

	local var5_30 = arg1_30:IsMainFleet()

	if var5_30 then
		arg0_30:UpdateMainFleetShips(var1_30, var2_30)
	else
		arg0_30:UpdateSubFleetShips(var3_30)
	end

	setActive(arg0_30.flag, var5_30 and #var1_30 > 0)
	setActive(arg0_30.subFlag, not var5_30 and #var3_30 > 0)
	setActive(arg0_30.grids, var5_30)
	setActive(arg0_30.subGrids, not var5_30)
end

function var0_0.UpdateMainFleetShips(arg0_31, arg1_31, arg2_31)
	for iter0_31 = 1, 3 do
		local var0_31 = arg0_31.grids:Find(iter0_31)
		local var1_31 = arg1_31[iter0_31]

		arg0_31:UpdateShip(iter0_31, var0_31, TeamType.Main, var1_31)
	end

	for iter1_31 = 4, 6 do
		local var2_31 = arg0_31.grids:Find(iter1_31)
		local var3_31 = arg2_31[iter1_31 - 3]

		arg0_31:UpdateShip(iter1_31, var2_31, TeamType.Vanguard, var3_31)
	end
end

function var0_0.UpdateSubFleetShips(arg0_32, arg1_32)
	for iter0_32 = 1, 3 do
		local var0_32 = arg0_32.subGrids:Find(iter0_32)
		local var1_32 = arg1_32[iter0_32]

		arg0_32:UpdateShip(iter0_32, var0_32, TeamType.Submarine, var1_32)
	end
end

function var0_0.UpdateShip(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	local var0_33 = arg2_33:Find("Image")

	if arg4_33 then
		local var1_33 = arg4_33.ship
		local var2_33 = var1_33:getPrefab()

		PoolMgr.GetInstance():GetSpineChar(var2_33, true, function(arg0_34)
			arg0_34.name = var2_33

			SetParent(arg0_34, arg2_33.parent)

			local var0_34 = GuildBossFormationShipCard.New(arg0_34)

			var0_34:Update(var1_33, arg1_33)
			SetAction(arg0_34, "stand")

			local var1_34 = GetOrAddComponent(arg0_34, "EventTriggerListener")

			var1_34:AddPointClickFunc(function(arg0_35, arg1_35)
				if arg0_33.dragging then
					return
				end

				arg0_33:emit(GuildEventMediator.ON_SELECT_BOSS_SHIP, arg3_33, arg0_33.fleet.id, arg4_33)
			end)
			var1_34:AddBeginDragFunc(function(arg0_36, arg1_36)
				arg0_33.dragging = true

				arg0_36.transform:SetAsLastSibling()
				SetAction(arg0_36, "tuozhuai")
			end)
			var1_34:AddDragFunc(function(arg0_37, arg1_37)
				local var0_37 = var0_0.Scr2Lpos(arg2_33.parent, arg1_37.position)

				var0_34:SetLocalPosition(var0_37)

				local var1_37 = arg0_33:GetNearestCard(var0_34)

				if var1_37 then
					arg0_33:SwopCardSolt(var1_37, var0_34)
				end
			end)
			var1_34:AddDragEndFunc(function(arg0_38, arg1_38)
				arg0_33.dragging = false

				var0_34:RefreshPosition(var0_34:GetSoltIndex(), true)
				SetAction(arg0_38, "stand")
				arg0_33:RefreshFleet()
			end)
			table.insert(arg0_33.shipCards, var0_34)
		end)
	else
		onButton(arg0_33, var0_33, function()
			arg0_33:emit(GuildEventMediator.ON_SELECT_BOSS_SHIP, arg3_33, arg0_33.fleet.id)
		end, SFX_PANEL)
	end

	setActive(var0_33, not arg4_33)
end

function var0_0.GetNearestCard(arg0_40, arg1_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.shipCards) do
		if iter1_40:GetSoltIndex() ~= arg1_40:GetSoltIndex() and iter1_40.teamType == arg1_40.teamType and Vector2.Distance(arg1_40:GetLocalPosition(), iter1_40:GetLocalPosition()) <= 50 then
			return iter1_40
		end
	end

	return nil
end

function var0_0.SwopCardSolt(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg1_41:GetSoltIndex()

	arg1_41:RefreshPosition(arg2_41:GetSoltIndex(), true)
	arg2_41:RefreshPosition(var0_41, false)
end

function var0_0.RefreshFleet(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in ipairs(arg0_42.shipCards) do
		table.insert(var0_42, {
			index = iter1_42:GetSoltIndex(),
			shipId = iter1_42.shipId
		})
	end

	table.sort(var0_42, function(arg0_43, arg1_43)
		return arg0_43.index < arg1_43.index
	end)

	if not arg0_42.contextData.editBossFleet then
		arg0_42.contextData.editBossFleet = {}
	end

	if not arg0_42.contextData.editBossFleet[arg0_42.fleet.id] then
		arg0_42.contextData.editBossFleet[arg0_42.fleet.id] = Clone(arg0_42.fleet)
		arg0_42.fleet = arg0_42.contextData.editBossFleet[arg0_42.fleet.id]
	end

	arg0_42.fleet:ResortShips(var0_42)
end

function var0_0.ClearShips(arg0_44)
	for iter0_44, iter1_44 in ipairs(arg0_44.shipCards) do
		iter1_44:Dispose()
	end

	arg0_44.shipCards = {}
end

function var0_0.OnDestroy(arg0_45)
	var0_0.super.OnDestroy(arg0_45)
	arg0_45:ClearShips()
	arg0_45.commanderPage:Destroy()
end

function var0_0.Scr2Lpos(arg0_46, arg1_46)
	local var0_46 = GameObject.Find("OverlayCamera"):GetComponent("Camera")
	local var1_46 = arg0_46:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var1_46, arg1_46, var0_46))
end

return var0_0
