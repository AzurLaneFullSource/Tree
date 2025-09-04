local var0_0 = class("IslandShipMainPage", import(".IslandBaseShipDisplayPage"))

var0_0.OPEN_PAGE = "IslandShipMainPage:OPEN_PAGE"
var0_0.SELECT_SHIP = "IslandShipMainPage:SELECT_SHIP"
var0_0.CLOSE_DOCK = "IslandShipMainPage:CLOSE_DOCK"
var0_0.PAGE_DRESS = 1
var0_0.PAGE_INFO = 2
var0_0.PAGE_STATUS = 3
var0_0.PAGE_PROFILE = 4

function var0_0.getUIName(arg0_1)
	return "IslandShipMainUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("adapt/left_panel/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/home")
	arg0_2.leftPanel = arg0_2:findTF("adapt/left_panel")
	arg0_2.dockBtn = arg0_2:findTF("adapt/left_panel/dock_btn")
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
		[var0_0.PAGE_INFO] = arg0_2:findTF("adapt/toggles/info"),
		[var0_0.PAGE_DRESS] = arg0_2:findTF("adapt/toggles/dress"),
		[var0_0.PAGE_STATUS] = arg0_2:findTF("adapt/toggles/gift"),
		[var0_0.PAGE_PROFILE] = arg0_2:findTF("adapt/toggles/data")
	}
	arg0_2.pages = {
		[var0_0.PAGE_INFO] = IslandShipInfoPage,
		[var0_0.PAGE_DRESS] = IslandShipDressUpPageNew,
		[var0_0.PAGE_STATUS] = IslandShipStatusPage,
		[var0_0.PAGE_PROFILE] = IslandShipProfilePage
	}
	arg0_2.cards = {}

	setActive(arg0_2.togglePanel, true)
	setText(arg0_2:findTF("adapt/left_panel/title/Text"), i18n("island_word_ship_desc"))
end

function var0_0.GetSmoothRotateObject(arg0_5)
	return GetOrAddComponent(arg0_5:findTF("adapt/char"), typeof(SmoothRotateObject))
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(var0_0.CLOSE_DOCK, arg0_6.OnCloseDock)
	arg0_6:AddListener(var0_0.OPEN_PAGE, arg0_6.OnTriggerPage)
	arg0_6:AddListener(IslandShipMainPage.SELECT_SHIP, arg0_6.OnSelectShip)
	arg0_6:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_6.OnAddShip)
	arg0_6:AddListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_6.OnSkillUpgrade)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(var0_0.CLOSE_DOCK, arg0_7.OnCloseDock)
	arg0_7:RemoveListener(var0_0.OPEN_PAGE, arg0_7.OnTriggerPage)
	arg0_7:RemoveListener(IslandShipMainPage.SELECT_SHIP, arg0_7.OnSelectShip)
	arg0_7:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_7.OnAddShip)
	arg0_7:RemoveListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_7.OnSkillUpgrade)
end

function var0_0.OnCloseDock(arg0_8)
	arg0_8:SetVisible(arg0_8.leftPanel, true)
end

function var0_0.OnSkillUpgrade(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.cards) do
		iter1_9:FlushRedDot()
	end
end

function var0_0.OnGotExtra(arg0_10)
	if not arg0_10.contextData.selectedId then
		return
	end

	local var0_10 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_10.contextData.selectedId)

	arg0_10:FlushExtraAward(var0_10)
end

function var0_0.OnAddShip(arg0_11)
	arg0_11:Flush()

	if not arg0_11.contextData.selectedId then
		-- block empty
	end
end

function var0_0.OnSelectShip(arg0_12, arg1_12)
	local var0_12 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_12)

	arg0_12:ClickCard(var0_12, arg1_12)
end

function var0_0.OnTriggerPage(arg0_13, arg1_13)
	arg0_13:TriggerPage(arg1_13)
end

function var0_0.OnInit(arg0_14)
	onButton(arg0_14, arg0_14.homeBtn, function()
		arg0_14:OnHome()
	end, SFX_PANEL)
	setActive(arg0_14.homeBtn, not ISLAND_PLAYER_TESTING)
	onButton(arg0_14, arg0_14.backBtn, function()
		if arg0_14.childPage then
			arg0_14.childPage:CheckInReturn(function()
				arg0_14:Hide()

				arg0_14.childPage = nil
			end)
		else
			arg0_14:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.dockBtn, function()
		arg0_14:OpenPage(IslandDockPage)
		arg0_14:SetVisible(arg0_14.leftPanel, false)
	end, SFX_PANEL)

	for iter0_14, iter1_14 in ipairs(arg0_14.toggles) do
		onToggle(arg0_14, iter1_14, function(arg0_19)
			if arg0_19 then
				if arg0_14.childPage then
					arg0_14.childPage:CheckInReturn(function()
						arg0_14:SwitchPage(iter0_14)
					end)
				else
					arg0_14:SwitchPage(iter0_14)
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.SwitchPage(arg0_21, arg1_21)
	if not arg0_21.contextData.selectedId then
		return
	end

	if arg0_21.page then
		arg0_21:ClosePage(arg0_21.page)

		arg0_21.page = nil
	end

	local var0_21 = arg0_21.pages[arg1_21]

	if arg1_21 == 1 then
		if not arg0_21.shipDressHelper then
			arg0_21.shipDressHelper = IslandShipDressHelperNew.New()
		end

		arg0_21.shipDressHelper:SetShipId(arg0_21.contextData.selectedId)
		arg0_21.shipDressHelper:OnRoleLoaded(arg0_21.role.transform, arg0_21.modelData)

		arg0_21.childPage = arg0_21:OpenPage(var0_21, arg0_21.contextData.selectedId, false, arg0_21.shipDressHelper, function(arg0_22)
			arg0_21:SetObjInitRotaion(arg0_22)
		end)
	else
		arg0_21:OpenPage(var0_21, arg0_21.contextData.selectedId)

		arg0_21.childPage = nil
	end

	arg0_21.page = var0_21
end

function var0_0.TriggerPage(arg0_23, arg1_23)
	local var0_23 = arg0_23.toggles[arg1_23]

	triggerToggle(var0_23, true)
end

function var0_0.Show(arg0_24)
	var0_0.super.Show(arg0_24)
	arg0_24:Flush()
end

function var0_0.Flush(arg0_25)
	local var0_25 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	arg0_25:FlushShips(var0_25)
	arg0_25:ActiveDefaultCard()
end

function var0_0.ActiveDefaultCard(arg0_26)
	if arg0_26.contextData.selectedId then
		local var0_26 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_26.contextData.selectedId)

		arg0_26.contextData.selectedId = nil

		arg0_26:UpdateMainView(var0_26)
		setActive(arg0_26.togglePanel, true)
	end
end

function var0_0.OnInitItem(arg0_27, arg1_27)
	local var0_27 = IslandMiniShipCard.New(arg1_27)

	onButton(arg0_27, var0_27.go, function()
		if arg0_27.childPage then
			arg0_27.childPage:CheckInReturn(function()
				arg0_27.childPage = nil

				arg0_27:ClickCard(var0_27.ship, var0_27.configId)
			end)
		else
			arg0_27:ClickCard(var0_27.ship, var0_27.configId)
		end
	end, SFX_PANEL)

	arg0_27.cards[arg1_27] = var0_27
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
		var0_34 = arg1_34:GetShipById(arg0_34.displays[1])
	end

	arg0_34.contextData.selectedId = arg0_34.contextData.selectedId or var0_34 and var0_34.configId

	arg0_34.shipRect:SetTotalCount(#arg0_34.displays)
end

function var0_0.CalcShipLayout(arg0_35)
	local var0_35 = arg0_35.shipContainer.rect.height
	local var1_35 = arg0_35.shipRect.gameObject.transform

	if var0_35 < var1_35.rect.height then
		local var2_35 = (arg0_35._tf.rect.height - var0_35) * 0.5

		var1_35.offsetMax = Vector2(var1_35.offsetMax.x, -var2_35)
		var1_35.offsetMin = Vector2(var1_35.offsetMin.x, var2_35)
	end
end

function var0_0.UpdateMainView(arg0_36, arg1_36)
	if arg0_36.contextData.selectedId == arg1_36.configId then
		return
	end

	arg0_36:LoadCharacter(arg1_36:GetModel())

	arg0_36.contextData.selectedId = arg1_36.configId

	arg0_36:TriggerPage(var0_0.PAGE_INFO)
end

function var0_0.UpdateUnlockView(arg0_37, arg1_37)
	local var0_37 = pg.island_chara_template[arg1_37].name

	arg0_37:ShowMsgBox({
		content = i18n("island_open_ship_tip"),
		onYes = function()
			arg0_37:Hide()
			arg0_37:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.LABORATORY_MAP_ID, IslandConst.LETTEROFINVITATION_SP)
		end
	})
end

function var0_0.OnDestroy(arg0_39)
	var0_0.super.OnDestroy(arg0_39)

	for iter0_39, iter1_39 in pairs(arg0_39.cards or {}) do
		iter1_39:Dispose()
	end

	arg0_39.cards = nil

	if arg0_39.timer then
		arg0_39.timer:Stop()
	end

	if arg0_39.shipDressHelper then
		arg0_39.shipDressHelper:Destroy()
	end
end

function var0_0.OnCharLoaded(arg0_40)
	if arg0_40.shipDressHelper then
		arg0_40.shipDressHelper:OnRoleLoaded(arg0_40.role.transform, arg0_40.modelData)
	end
end

function var0_0.SetObjInitRotaion(arg0_41, arg1_41)
	local var0_41 = arg0_41:GetSmoothRotateObject()

	var0_41.rotationSpeed = 5

	ReflectionHelp.RefSetProperty(typeof(SmoothRotateObject), "targetRotation", var0_41, arg1_41)

	if arg0_41.timer then
		arg0_41.timer:Stop()
	end

	arg0_41.timer = Timer.New(function()
		local var0_42 = pg.island_set.character_detail_camera_speed.key_value_int

		var0_41.rotationSpeed = var0_42
	end, 0.5, 1)

	arg0_41.timer:Start()
end

return var0_0
