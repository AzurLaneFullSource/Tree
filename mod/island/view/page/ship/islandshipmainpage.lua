local var0_0 = class("IslandShipMainPage", import("...base.IslandBasePage"))

var0_0.OPEN_PAGE = "IslandShipMainPage:OPEN_PAGE"
var0_0.SELECT_SHIP = "IslandShipMainPage:SELECT_SHIP"
var0_0.PAGE_DRESS = 1
var0_0.PAGE_INFO = 2
var0_0.PAGE_SKILL = 3
var0_0.PAGE_STATUS = 4
var0_0.PAGE_PROFILE = 5

function var0_0.getUIName(arg0_1)
	return "IslandShipMainUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("adapt/left_panel/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/home")
	arg0_2.leftPanel = arg0_2:findTF("adapt/left_panel")
	arg0_2.charContainer = arg0_2:findTF("adapt/char")
	arg0_2.dockBtn = arg0_2:findTF("adapt/left_panel/dock_btn")
	arg0_2.giftBtn = arg0_2:findTF("adapt/propose_btn")
	arg0_2.togglePanel = arg0_2:findTF("adapt/toggles")
	arg0_2.shipRect = arg0_2:findTF("adapt/left_panel/ships"):GetComponent("LScrollRect")
	arg0_2.shipContainer = arg0_2:findTF("adapt/left_panel/ships/content")

	function arg0_2.shipRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.shipRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.toggles = {
		[var0_0.PAGE_DRESS] = arg0_2:findTF("adapt/toggles/dress"),
		[var0_0.PAGE_INFO] = arg0_2:findTF("adapt/toggles/info"),
		[var0_0.PAGE_SKILL] = arg0_2:findTF("adapt/toggles/skill"),
		[var0_0.PAGE_STATUS] = arg0_2:findTF("adapt/toggles/gift"),
		[var0_0.PAGE_PROFILE] = arg0_2:findTF("adapt/toggles/data")
	}
	arg0_2.pages = {
		[var0_0.PAGE_DRESS] = IslandShipDressPage,
		[var0_0.PAGE_INFO] = IslandShipInfoPage,
		[var0_0.PAGE_SKILL] = IslandShipSkillPage,
		[var0_0.PAGE_STATUS] = IslandShipStatusPage,
		[var0_0.PAGE_PROFILE] = IslandShipProfilePage
	}
	arg0_2.cards = {}

	setActive(arg0_2.togglePanel, true)
	setActive(arg0_2.giftBtn, false)
	setText(arg0_2:findTF("adapt/left_panel/title/Text"), i18n1("角色详情"))
end

function var0_0.AddListeners(arg0_5)
	arg0_5:AddListener(var0_0.OPEN_PAGE, arg0_5.OnTriggerPage)
	arg0_5:AddListener(IslandBaseScene.CLOSE_PAGE, arg0_5.OnClosePage)
	arg0_5:AddListener(IslandShipMainPage.SELECT_SHIP, arg0_5.OnSelectShip)
	arg0_5:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_5.OnAddShip)
	arg0_5:AddListener(GAME.ISLAND_GET_EXTRA_AWARD_DONE, arg0_5.OnGotExtra)
	arg0_5:AddListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_5.OnSkillUpgrade)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveListener(var0_0.OPEN_PAGE, arg0_6.OnTriggerPage)
	arg0_6:RemoveListener(IslandBaseScene.CLOSE_PAGE, arg0_6.OnClosePage)
	arg0_6:RemoveListener(IslandShipMainPage.SELECT_SHIP, arg0_6.OnSelectShip)
	arg0_6:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_6.OnAddShip)
	arg0_6:RemoveListener(GAME.ISLAND_GET_EXTRA_AWARD_DONE, arg0_6.OnGotExtra)
	arg0_6:RemoveListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_6.OnSkillUpgrade)
end

function var0_0.OnSkillUpgrade(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.cards) do
		iter1_7:FlushRedDot()
	end
end

function var0_0.OnGotExtra(arg0_8)
	if not arg0_8.contextData.selectedId then
		return
	end

	local var0_8 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg0_8.contextData.selectedId)

	arg0_8:FlushExtraAward(var0_8)
end

function var0_0.OnAddShip(arg0_9)
	arg0_9:Flush()

	if not arg0_9.contextData.selectedId then
		-- block empty
	end
end

function var0_0.OnSelectShip(arg0_10, arg1_10)
	local var0_10 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg1_10)

	arg0_10:ClickCard(var0_10, arg1_10)
end

function var0_0.OnTriggerPage(arg0_11, arg1_11)
	arg0_11:TriggerPage(arg1_11)
end

function var0_0.OnClosePage(arg0_12, arg1_12)
	if isa(arg1_12, IslandDockPage) then
		arg0_12:SetVisible(arg0_12.leftPanel, true)
	end
end

function var0_0.OnInit(arg0_13)
	onButton(arg0_13, arg0_13.homeBtn, function()
		arg0_13:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.backBtn, function()
		arg0_13:Hide()
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.dockBtn, function()
		arg0_13:OpenPage(IslandDockPage)
		arg0_13:SetVisible(arg0_13.leftPanel, false)
	end, SFX_PANEL)
	onButton(arg0_13, arg0_13.giftBtn, function()
		arg0_13:GetExtraAward()
	end, SFX_PANEL)

	for iter0_13, iter1_13 in ipairs(arg0_13.toggles) do
		onToggle(arg0_13, iter1_13, function(arg0_18)
			if arg0_18 then
				arg0_13:SwitchPage(iter0_13)
			end
		end, SFX_PANEL)
	end
end

function var0_0.GetExtraAward(arg0_19)
	if not arg0_19.contextData.selectedId then
		return
	end

	local var0_19 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg0_19.contextData.selectedId)
	local var1_19 = var0_19:CanGetOwnShipAward()
	local var2_19 = var0_19:CanGetMarriedShipAward()
	local var3_19
	local var4_19

	if var1_19 then
		var3_19 = IslandShip.GIFT_OP_SHIP
	elseif var2_19 then
		var3_19 = IslandShip.GIFT_OP_MARRIED
	end

	if not var3_19 then
		return
	end

	local var5_19 = var0_19:GetName()
	local var6_19 = var0_19:GetExtraAwardList(var3_19)
	local var7_19 = var6_19[1]

	table.remove(var6_19, 1)

	local var8_19 = _.map(var6_19, function(arg0_20)
		return Drop.New(arg0_20)
	end)
	local var9_19 = table.concat(_.map(var8_19, function(arg0_21)
		return "[" .. arg0_21:getConfigTable().name .. "]"
	end), "、")

	if var1_19 then
		var4_19 = i18n1(string.format("由于港区拥有该角色，%s获得奇妙的灵感启发,\n获得经验<color=#39BFFF>+%s</color>好感礼物<color=#39BFFF>%s</color>", var5_19, var7_19, var9_19))
	elseif var2_19 then
		var4_19 = i18n1(string.format("由于港区婚约过该角色，%s获得奇妙的灵感启发,\n获得经验<color=#39BFFF>+%s</color>好感礼物<color=#39BFFF>%ss</color>", var5_19, var7_19, var9_19))
	end

	arg0_19:ShowMsgBox({
		hideNo = true,
		title = i18n1("奇妙灵感"),
		type = IslandMsgBox.TYPE_ITEM,
		drops = var8_19,
		content = var4_19,
		onYes = function()
			arg0_19:emit(IslandMediator.GET_EXTRA_AWARD, var0_19.id, var3_19)
		end
	})
end

function var0_0.SwitchPage(arg0_23, arg1_23)
	if arg0_23.page then
		arg0_23:ClosePage(arg0_23.page)

		arg0_23.page = nil
	end

	local var0_23 = arg0_23.pages[arg1_23]

	arg0_23:OpenPage(var0_23, arg0_23.contextData.selectedId)

	arg0_23.page = var0_23
end

function var0_0.TriggerPage(arg0_24, arg1_24)
	local var0_24 = arg0_24.toggles[arg1_24]

	triggerToggle(var0_24, true)
end

function var0_0.Show(arg0_25)
	var0_0.super.Show(arg0_25)
	arg0_25:Flush()
end

function var0_0.Flush(arg0_26)
	local var0_26 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	arg0_26:FlushShips(var0_26)
	arg0_26:ActiveDefaultCard()
end

function var0_0.ActiveDefaultCard(arg0_27)
	if arg0_27.contextData.selectedId then
		local var0_27 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipByConfigId(arg0_27.contextData.selectedId)

		arg0_27.contextData.selectedId = nil

		arg0_27:UpdateMainView(var0_27)
		setActive(arg0_27.togglePanel, true)
	end
end

function var0_0.OnInitItem(arg0_28, arg1_28)
	local var0_28 = IslandMiniShipCard.New(arg1_28)

	onButton(arg0_28, var0_28.go, function()
		arg0_28:ClickCard(var0_28.ship, var0_28.configId)
	end, SFX_PANEL)

	arg0_28.cards[arg1_28] = var0_28
end

function var0_0.ClickCard(arg0_30, arg1_30, arg2_30)
	if arg1_30 then
		arg0_30:ClearSelected(arg0_30.contextData.selectedId)
		arg0_30:UpdateMainView(arg1_30)
		arg0_30:MarkSelected(arg2_30)
	else
		arg0_30:UpdateUnlockView(arg2_30)
	end
end

function var0_0.ClearSelected(arg0_31, arg1_31)
	for iter0_31, iter1_31 in pairs(arg0_31.cards) do
		if iter1_31.configId == arg1_31 then
			iter1_31:UpdateSelected(nil)

			break
		end
	end
end

function var0_0.MarkSelected(arg0_32, arg1_32)
	for iter0_32, iter1_32 in pairs(arg0_32.cards) do
		if iter1_32.configId == arg1_32 then
			iter1_32:UpdateSelected(iter1_32.configId)

			break
		end
	end
end

function var0_0.OnUpdateItem(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.cards[arg2_33]

	if not var0_33 then
		arg0_33:OnInitItem(arg2_33)

		var0_33 = arg0_33.cards[arg2_33]
	end

	local var1_33 = arg0_33.displays[arg1_33 + 1]

	if not var1_33 then
		return
	end

	var0_33:Update(var1_33, arg0_33.contextData.selectedId)
end

function var0_0.FlushShips(arg0_34, arg1_34)
	arg0_34.displays = {}
	arg0_34.displays = arg1_34:GetUnlockOrCanUnlockShipConfigIds()

	local var0_34

	if #arg0_34.displays > 0 then
		var0_34 = arg1_34:GetShipByConfigId(arg0_34.displays[1])
	end

	arg0_34.contextData.selectedId = arg0_34.contextData.selectedId or var0_34 and var0_34.configId

	arg0_34.shipRect:SetTotalCount(#arg0_34.displays)
	onNextTick(function()
		arg0_34:CalcShipLayout()
	end)
end

function var0_0.CalcShipLayout(arg0_36)
	local var0_36 = arg0_36.shipContainer.rect.height
	local var1_36 = arg0_36.shipRect.gameObject.transform

	if var0_36 < var1_36.rect.height then
		local var2_36 = (arg0_36._tf.rect.height - var0_36) * 0.5

		var1_36.offsetMax = Vector2(var1_36.offsetMax.x, -var2_36)
		var1_36.offsetMin = Vector2(var1_36.offsetMin.x, var2_36)
	end
end

function var0_0.UpdateMainView(arg0_37, arg1_37)
	arg0_37:FlushExtraAward(arg1_37)

	if arg0_37.contextData.selectedId == arg1_37.configId then
		return
	end

	arg0_37:UnloadCharacter()
	arg0_37:LoadCharacter(arg1_37:GetPrefab() .. "UI")

	arg0_37.contextData.selectedId = arg1_37.configId

	arg0_37:TriggerPage(var0_0.PAGE_INFO)
end

function var0_0.FlushExtraAward(arg0_38, arg1_38)
	setActive(arg0_38.giftBtn, arg1_38:AnyExtraAwardCanGet())
end

function var0_0.UpdateUnlockView(arg0_39, arg1_39)
	local var0_39 = IslandShip.StaticGetUnlockItemId(arg1_39)

	if not var0_39 then
		return
	end

	local var1_39 = pg.island_item_data_template[var0_39].name
	local var2_39 = pg.island_ship[arg1_39].name

	arg0_39:ShowMsgBox({
		content = i18n1("消耗" .. var1_39 .. "X1，邀请" .. var2_39 .. "\n加入队伍,是否确定？"),
		onYes = function()
			arg0_39:emit(IslandMediator.ON_USE_ITEM, var0_39, 1)
		end
	})
end

function var0_0.LoadCharacter(arg0_41, arg1_41)
	ResourceMgr.Inst:getAssetAsync("island/" .. arg1_41, arg1_41, typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_42)
		arg0_41.role = Object.Instantiate(arg0_42)

		setParent(arg0_41.role, arg0_41.charContainer)
		GetOrAddComponent(arg0_41.charContainer, typeof(SmoothRotateChildObject))
	end), true, true)
end

function var0_0.UnloadCharacter(arg0_43)
	local var0_43 = arg0_43.charContainer:GetComponent(typeof(SmoothRotateChildObject))

	if var0_43 then
		Object.Destroy(var0_43)
	end

	if arg0_43.role then
		Object.Destroy(arg0_43.role)

		arg0_43.role = nil
		arg0_43.prefab = nil
	end
end

function var0_0.Hide(arg0_44)
	var0_0.super.Hide(arg0_44)
	arg0_44:UnloadCharacter()
end

function var0_0.OnDestroy(arg0_45)
	arg0_45:UnloadCharacter()

	for iter0_45, iter1_45 in pairs(arg0_45.cards or {}) do
		iter1_45:Dispose()
	end

	arg0_45.cards = nil
end

return var0_0
