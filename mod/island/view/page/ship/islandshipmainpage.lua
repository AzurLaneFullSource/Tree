local var0_0 = class("IslandShipMainPage", import(".IslandBaseShipDisplayPage"))

var0_0.OPEN_PAGE = "IslandShipMainPage:OPEN_PAGE"
var0_0.SELECT_SHIP = "IslandShipMainPage:SELECT_SHIP"
var0_0.CLOSE_DOCK = "IslandShipMainPage:CLOSE_DOCK"
var0_0.CLEAR_ITEM_ANIMATOR = "IslandShipMainPage:CLEAR_ITEM_ANIMATOR"
var0_0.PAGE_DRESS = 1
var0_0.PAGE_INFO = 2
var0_0.PAGE_STATUS = 3
var0_0.PAGE_PROFILE = 4

function var0_0.getUIName(arg0_1)
	return "IslandShipMainUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("top/back")
	arg0_2.homeBtn = arg0_2._tf:Find("top/home")
	arg0_2.leftPanel = arg0_2._tf:Find("adapt/left_panel")
	arg0_2.dockBtn = arg0_2._tf:Find("adapt/left_panel/dock_btn")
	arg0_2.togglePanel = arg0_2._tf:Find("top/toggles")
	arg0_2.shipRect = arg0_2._tf:Find("adapt/left_panel/ships"):GetComponent("LScrollRect")
	arg0_2.shipContainer = arg0_2._tf:Find("adapt/left_panel/ships/content")

	function arg0_2.shipRect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2.shipRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	arg0_2.toggles = {
		[var0_0.PAGE_INFO] = arg0_2._tf:Find("top/toggles/info"),
		[var0_0.PAGE_DRESS] = arg0_2._tf:Find("top/toggles/dress"),
		[var0_0.PAGE_STATUS] = arg0_2._tf:Find("top/toggles/gift"),
		[var0_0.PAGE_PROFILE] = arg0_2._tf:Find("topapt/toggles/data")
	}
	arg0_2.pages = {
		[var0_0.PAGE_INFO] = IslandShipInfoPage,
		[var0_0.PAGE_DRESS] = IslandShipDressUpPageNew,
		[var0_0.PAGE_STATUS] = IslandShipStatusPage,
		[var0_0.PAGE_PROFILE] = IslandShipProfilePage
	}
	arg0_2.cards = {}

	setActive(arg0_2.togglePanel, true)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_chara_totalname"))
	setText(arg0_2._tf:Find("top/title/Text/en"), i18n("island_chara_totalname_en"))
end

function var0_0.GetSmoothRotateObject(arg0_5)
	return arg0_5._tf:Find("adapt/char")
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(var0_0.CLOSE_DOCK, arg0_6.OnCloseDock)
	arg0_6:AddListener(var0_0.OPEN_PAGE, arg0_6.OnTriggerPage)
	arg0_6:AddListener(IslandShipMainPage.SELECT_SHIP, arg0_6.OnSelectShip)
	arg0_6:AddListener(IslandCharacterAgency.ADD_SHIP, arg0_6.OnAddShip)
	arg0_6:AddListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_6.OnSkillUpgrade)
	arg0_6:AddListener(var0_0.CLEAR_ITEM_ANIMATOR, arg0_6.OnClearItemAnimator)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(var0_0.CLOSE_DOCK, arg0_7.OnCloseDock)
	arg0_7:RemoveListener(var0_0.OPEN_PAGE, arg0_7.OnTriggerPage)
	arg0_7:RemoveListener(IslandShipMainPage.SELECT_SHIP, arg0_7.OnSelectShip)
	arg0_7:RemoveListener(IslandCharacterAgency.ADD_SHIP, arg0_7.OnAddShip)
	arg0_7:RemoveListener(GAME.ISLAND_UPGRADE_SKILL_DONE, arg0_7.OnSkillUpgrade)
	arg0_7:RemoveListener(var0_0.CLEAR_ITEM_ANIMATOR, arg0_7.OnClearItemAnimator)
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
	onButton(arg0_14, arg0_14._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_character_info.tip
		})
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.homeBtn, function()
		arg0_14:OnHome()
	end, SFX_PANEL)
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
		onToggle(arg0_14, iter1_14, function(arg0_20)
			if arg0_20 then
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

function var0_0.SwitchPage(arg0_22, arg1_22)
	if not arg0_22.contextData.selectedId then
		return
	end

	if arg0_22.page then
		arg0_22:ClosePage(arg0_22.page)

		arg0_22.page = nil
	end

	local var0_22 = arg0_22.pages[arg1_22]

	if arg1_22 == 1 then
		arg0_22.childPage = arg0_22:OpenPage(var0_22, arg0_22.contextData.selectedId, false, arg0_22.shipDressHelper, function(arg0_23)
			arg0_22:SetObjInitRotaion(arg0_23)
		end)
	else
		arg0_22:OpenPage(var0_22, arg0_22.contextData.selectedId)

		arg0_22.childPage = nil
	end

	arg0_22.page = var0_22
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
		local var0_27 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_27.contextData.selectedId)

		arg0_27.contextData.selectedId = nil

		arg0_27:UpdateMainView(var0_27)
		setActive(arg0_27.togglePanel, true)
	end
end

function var0_0.OnInitItem(arg0_28, arg1_28)
	local var0_28 = IslandMiniShipCard.New(arg1_28)

	onButton(arg0_28, var0_28.go, function()
		if arg0_28.childPage then
			arg0_28.childPage:CheckInReturn(function()
				arg0_28.childPage = nil

				arg0_28:ClickCard(var0_28.ship, var0_28.configId)
			end)
		else
			arg0_28:ClickCard(var0_28.ship, var0_28.configId)
		end
	end, SFX_PANEL)

	arg0_28.cards[arg1_28] = var0_28
end

function var0_0.ClickCard(arg0_31, arg1_31, arg2_31)
	if arg1_31 then
		arg0_31:ClearSelected(arg0_31.contextData.selectedId)
		arg0_31:UpdateMainView(arg1_31)
		arg0_31:MarkSelected(arg2_31)
	else
		arg0_31:UpdateUnlockView(arg2_31)
	end
end

function var0_0.ClearSelected(arg0_32, arg1_32)
	for iter0_32, iter1_32 in pairs(arg0_32.cards) do
		if iter1_32.configId == arg1_32 then
			iter1_32:UpdateSelected(nil)

			break
		end
	end
end

function var0_0.MarkSelected(arg0_33, arg1_33)
	for iter0_33, iter1_33 in pairs(arg0_33.cards) do
		if iter1_33.configId == arg1_33 then
			iter1_33:UpdateSelected(iter1_33.configId)

			break
		end
	end
end

function var0_0.OnUpdateItem(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.cards[arg2_34]

	if not var0_34 then
		arg0_34:OnInitItem(arg2_34)

		var0_34 = arg0_34.cards[arg2_34]
	end

	local var1_34 = arg0_34.displays[arg1_34 + 1]

	if not var1_34 then
		return
	end

	var0_34:Update(var1_34, arg0_34.contextData.selectedId)
end

function var0_0.FlushShips(arg0_35, arg1_35)
	arg0_35.displays = {}
	arg0_35.displays = arg1_35:GetUnlockOrCanUnlockShipConfigIds()

	local var0_35

	if #arg0_35.displays > 0 then
		var0_35 = arg1_35:GetShipById(arg0_35.displays[1])
	end

	arg0_35.contextData.selectedId = arg0_35.contextData.selectedId or var0_35 and var0_35.configId

	arg0_35.shipRect:SetTotalCount(#arg0_35.displays)
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
	if arg0_37.contextData.selectedId == arg1_37.configId then
		return
	end

	if not arg0_37.shipDressHelper then
		arg0_37.shipDressHelper = IslandShipDressHelperNew.New()
	end

	arg0_37.shipDressHelper:SetShipId(arg1_37.configId)
	arg0_37:LoadCharacter(arg1_37:GetModel())

	arg0_37.contextData.selectedId = arg1_37.configId

	arg0_37:TriggerPage(var0_0.PAGE_INFO)
end

function var0_0.UpdateUnlockView(arg0_38, arg1_38)
	local var0_38 = pg.island_chara_template[arg1_38].name

	arg0_38:ShowMsgBox({
		content = i18n("island_open_ship_tip"),
		onYes = function()
			arg0_38:Hide()
			arg0_38:emit(IslandBaseMediator.SWITCH_MAP, IslandConst.LABORATORY_MAP_ID, IslandConst.LETTEROFINVITATION_SP)
		end
	})
end

function var0_0.OnDestroy(arg0_40)
	var0_0.super.OnDestroy(arg0_40)
	ClearLScrollrect(arg0_40.shipRect)

	for iter0_40, iter1_40 in pairs(arg0_40.cards or {}) do
		iter1_40:Dispose()
	end

	arg0_40.cards = nil

	if arg0_40.timer then
		arg0_40.timer:Stop()
	end

	if arg0_40.shipDressHelper then
		arg0_40.shipDressHelper:Destroy()
	end
end

function var0_0.OnHide(arg0_41)
	if arg0_41.shipDressHelper then
		arg0_41.shipDressHelper:Destroy()
	end
end

function var0_0.CanEsc(arg0_42)
	if arg0_42.childPage then
		arg0_42.childPage:CheckInReturn(function()
			arg0_42:Hide()

			arg0_42.childPage = nil
		end)

		return false
	else
		return true
	end
end

function var0_0.OnCharLoaded(arg0_44, arg1_44)
	if arg0_44.shipDressHelper then
		arg0_44.shipDressHelper:OnRoleLoaded(arg0_44.role.transform, arg1_44)
	end
end

function var0_0.SetObjInitRotaion(arg0_45, arg1_45)
	local var0_45 = arg0_45:GetSmoothRotateObject()
	local var1_45 = GetOrAddComponent(var0_45, typeof(SmoothRotateObject))

	var1_45.rotationSpeed = 5

	ReflectionHelp.RefSetProperty(typeof(SmoothRotateObject), "targetRotation", var1_45, arg1_45)

	if arg0_45.timer then
		arg0_45.timer:Stop()
	end

	arg0_45.timer = Timer.New(function()
		local var0_46 = pg.island_set.character_detail_camera_speed.key_value_int

		var1_45.rotationSpeed = var0_46
	end, 0.5, 1)

	arg0_45.timer:Start()
end

return var0_0
