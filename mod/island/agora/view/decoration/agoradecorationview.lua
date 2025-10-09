local var0_0 = class("AgoraDecorationView", import("Mod.Island.Core.View.IslandASynLoadSubView"))

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraDecorationUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2.scrollRect = arg0_2._tf:Find("panel/main/scrollrect"):GetComponent("LScrollRect")
	arg0_2.scrollRect4Theme = arg0_2._tf:Find("panel/main/scrollrect_theme"):GetComponent("LScrollRect")
	arg0_2.emptyTr = arg0_2._tf:Find("panel/main/empty")
	arg0_2.agoraSaveBtn = arg0_2._tf:Find("panel/btns/save")
	arg0_2.agoraSaveCdBtn = arg0_2._tf:Find("panel/btns/save_cd")
	arg0_2.agoraSaveCdTxt = arg0_2._tf:Find("panel/btns/save_cd/Text"):GetComponent(typeof(Text))
	arg0_2.agoraClearBtn = arg0_2._tf:Find("panel/btns/clear")
	arg0_2.agoraRevertBtn = arg0_2._tf:Find("panel/btns/revert")
	arg0_2.topPanel = arg0_2._tf:Find("top")
	arg0_2.agoraShopBtn = arg0_2._tf:Find("top/shop")
	arg0_2.backBtn = arg0_2._tf:Find("top/back")
	arg0_2.capacityBtn = arg0_2._tf:Find("top/capacity")
	arg0_2.capacityTxt = arg0_2._tf:Find("top/capacity/Text"):GetComponent(typeof(Text))
	arg0_2.themeBtn = arg0_2._tf:Find("panel/main/bg/theme")
	arg0_2.hideBtn = arg0_2._tf:Find("panel/main/bg/hide")
	arg0_2.showBtn = arg0_2._tf:Find("panel/btns/show")
	arg0_2.tagUIItemList = UIItemList.New(arg0_2._tf:Find("panel/main/bg/tags"), arg0_2._tf:Find("panel/main/bg/tags/1_1"))
	arg0_2.searchInput = arg0_2._tf:Find("panel/main/bg/search/search")
	arg0_2.searchClearBtn = arg0_2._tf:Find("panel/main/bg/search/search/clear")
	arg0_2.sortBtn = arg0_2._tf:Find("panel/main/bg/order")
	arg0_2.orderBtn = arg0_2._tf:Find("panel/main/bg/order/icon")
	arg0_2.orderTxt = arg0_2._tf:Find("panel/main/bg/order/Text_1"):GetComponent(typeof(Text))
	arg0_2.sortPage = AgoraDecorationSortPage.New(arg0_2._tf)
	arg0_2.descPage = AgoraFurnitureDescPage.New(arg0_2._tf)
	arg0_2.shapeSelectPanel = AgoraDecorationShapePage.New(arg0_2._tf:Find("shapeTpl"))

	setText(arg0_2.agoraClearBtn:Find("Text"), i18n("island_agora_btn_label_clear"))
	setText(arg0_2.agoraRevertBtn:Find("Text"), i18n("island_agora_btn_label_revert"))
	setText(arg0_2.agoraSaveBtn:Find("Text"), i18n("island_agora_btn_label_save"))
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_agora_title"))
	setText(arg0_2._tf:Find("panel/main/bg/search/search/holder"), i18n("island_agora_label_search"))
	setText(arg0_2._tf:Find("panel/main/bg/theme/unsel/Text"), i18n("island_agora_label_theme"))
	setText(arg0_2._tf:Find("panel/main/bg/theme/sel/Text"), i18n("island_agora_label_theme"))
	setText(arg0_2.emptyTr:Find("empty_1/Text"), i18n("island_agora_label_empty_tip"))

	arg0_2.anim = arg0_2._tf:GetComponent(typeof(Animation))
	arg0_2.dftAniEvent = arg0_2.anim:GetComponent(typeof(DftAniEvent))
	arg0_2.panelAnim = arg0_2._tf:Find("panel"):GetComponent(typeof(Animation))
	arg0_2.cards = {}
	arg0_2.themeCards = {}
	arg0_2.indexData = {
		tag = 1,
		searchKey = "",
		sortKey = 1,
		order = 1
	}

	arg0_2:RegisterEvent()
	arg0_2:UpdateOrderTxt()
	arg0_2:InitTags()
	onButton(arg0_2, arg0_2._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_renovation.tip
		})
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_4)
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_27")
end

function var0_0.PlayExitAnim(arg0_5, arg1_5)
	if arg0_5.isAniming then
		return
	end

	arg0_5.isAniming = true

	arg0_5.dftAniEvent:SetEndEvent(function()
		arg0_5.isAniming = false

		var0_0.super.Hide(arg0_5)
		arg1_5()
	end)
	arg0_5.anim:Play("anim_IslandAgoraDecorationUI_Out")
end

function var0_0.OnSelectedItem(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = arg0_7.selectedId

	arg0_7.selectedId = arg1_7

	for iter0_7, iter1_7 in pairs(arg0_7.cards) do
		iter1_7:UpdateSelected(arg0_7.selectedId)
	end

	if not arg2_7 then
		arg0_7:TriggerTag(arg1_7)

		return
	end

	if arg0_7.selectedId > 0 and not arg0_7.isHideState then
		triggerButton(arg0_7.hideBtn)
		arg0_7:FoldBtnsAndTop()
	elseif arg3_7 then
		local var1_7 = _.detect(arg0_7.displays, function(arg0_8)
			return arg0_8:Contains(arg3_7)
		end)

		if var1_7 and var1_7:GetAvailableCnt() > 0 then
			return
		end

		if arg1_7 < 0 then
			triggerButton(arg0_7.showBtn)
		end
	elseif arg1_7 < 0 then
		triggerButton(arg0_7.showBtn)
	end
end

function var0_0.TriggerTag(arg0_9, arg1_9)
	if arg1_9 <= 0 then
		return
	end

	local var0_9 = arg0_9:GetView().agora:GetPlaceableItem(arg1_9)

	if not var0_9 then
		return
	end

	local var1_9 = table.indexof(AgoraFurnitureType.PLACEMENT_TYPE, var0_9:GetType())

	if var1_9 > 0 then
		triggerToggle(arg0_9.toggles[var1_9], true)
	end
end

function var0_0.OnCreateSameItem(arg0_10, arg1_10)
	local var0_10 = _.detect(arg0_10.displays, function(arg0_11)
		return arg0_11:Contains(arg1_10)
	end)

	if var0_10 and var0_10:GetAvailableCnt() > 0 then
		local var1_10 = var0_10:GetAvailableItem()

		arg0_10:Op("PlaceItemRandonPosition", var1_10.id)
	end
end

function var0_0.RegisterEvent(arg0_12)
	function arg0_12.scrollRect.onInitItem(arg0_13)
		arg0_12:OnInitItem(arg0_13)
	end

	function arg0_12.scrollRect.onUpdateItem(arg0_14, arg1_14)
		arg0_12:OnUpdateItem(arg0_14, arg1_14)
	end

	function arg0_12.scrollRect4Theme.onInitItem(arg0_15)
		arg0_12:OnInitItem4Theme(arg0_15)
	end

	function arg0_12.scrollRect4Theme.onUpdateItem(arg0_16, arg1_16)
		arg0_12:OnUpdateItem4Theme(arg0_16, arg1_16)
	end

	onButton(arg0_12, arg0_12.agoraSaveBtn, function()
		if arg0_12:TrySave() then
			arg0_12:Op("Save")
		end
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.agoraClearBtn, function()
		arg0_12:ShowMsgbox({
			content = i18n("island_agora_clear_tip"),
			onYes = function()
				arg0_12:Op("ClearAll")
			end
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.agoraRevertBtn, function()
		arg0_12:ShowMsgbox({
			content = i18n("island_agora_revert_tip"),
			onYes = function()
				arg0_12:Op("Revert")
			end
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.capacityBtn, function()
		local var0_22 = arg0_12:GetView()
		local var1_22 = var0_22.agora:GetPlacedInfoList()
		local var2_22 = var0_22.agora:GetMaxCapacity()

		arg0_12:ShowMsgbox({
			type = IslandMsgBox.TYPE_AGORA_PLACED_LIST,
			list = var1_22,
			totalCnt = var2_22
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.agoraShopBtn, function()
		if arg0_12:GetView():GetController():CheckChange() then
			arg0_12:Save()
		else
			arg0_12:PlayExitAnim(function()
				arg0_12:Op("ExitEditMode")
				arg0_12:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE, IslandShopPage, {
					1,
					2,
					3,
					4,
					5
				}, {
					10111,
					40111,
					50111,
					10122
				})
			end)
		end
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.backBtn, function()
		if arg0_12:GetView():GetController():CheckChange() then
			arg0_12:Save()
		else
			arg0_12:PlayExitAnim(function()
				arg0_12:Op("ExitEditMode")
			end)
		end
	end, SFX_PANEL)
	onInputChanged(arg0_12, arg0_12.searchInput, function()
		local var0_27 = getInputText(arg0_12.searchInput)

		setActive(arg0_12.searchClearBtn, var0_27 ~= "")
		arg0_12:OnSearch(var0_27)
	end)
	onButton(arg0_12, arg0_12.searchClearBtn, function()
		setInputText(arg0_12.searchInput, "")

		arg0_12.indexData.searchKey = ""
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.sortBtn, function()
		arg0_12.sortPage:ExecuteAction("Show", arg0_12.indexData, function(arg0_30)
			arg0_12:OnSort(arg0_30)
		end)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.orderBtn, function()
		local var0_31 = 1 - arg0_12.indexData.order

		arg0_12:OnOrder(var0_31)
	end, SFX_PANEL)

	arg0_12.isHideState = false
	arg0_12.isHideBtnAndTop = false

	onButton(arg0_12, arg0_12.hideBtn, function()
		arg0_12.isHideState = true

		arg0_12.panelAnim:Play("fold")
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.showBtn, function()
		arg0_12.isHideState = false

		arg0_12.panelAnim:Play("unfold")

		if arg0_12.isHideBtnAndTop then
			arg0_12:UnFoldBtnsAndTop()
		end
	end, SFX_PANEL)
end

function var0_0.TrySave(arg0_34)
	local var0_34 = arg0_34:GetView():GetController():CanEnterEditMode()

	if not var0_34 then
		arg0_34:ShowMsgbox({
			type = IslandMsgBox.TYPE_AOGRA_SAVE_CD,
			duetime = arg0_34:GetView():GetController().editCdTime,
			onNo = function()
				arg0_34:Op("RevertAndExit")
			end
		})
	end

	return var0_34
end

function var0_0.Save(arg0_36)
	if arg0_36:TrySave() then
		arg0_36:ShowMsgbox({
			content = i18n("island_agora_save_or_exit_tip"),
			noText = i18n("island_agora_exit_and_unsave"),
			yesText = i18n("island_agora_exit_and_save"),
			onYes = function()
				arg0_36:Op("SaveAndExit")
			end,
			onNo = function()
				arg0_36:Op("RevertAndExit")
			end
		})
	end
end

function var0_0.FoldBtnsAndTop(arg0_39)
	setActive(arg0_39.agoraSaveBtn, false)
	setActive(arg0_39.agoraClearBtn, false)
	setActive(arg0_39.agoraRevertBtn, false)
	setActive(arg0_39.topPanel, false)

	arg0_39.isHideBtnAndTop = true
end

function var0_0.UnFoldBtnsAndTop(arg0_40)
	setActive(arg0_40.agoraSaveBtn, true)
	setActive(arg0_40.agoraClearBtn, true)
	setActive(arg0_40.agoraRevertBtn, true)
	setActive(arg0_40.topPanel, true)

	arg0_40.isHideBtnAndTop = false
end

function var0_0.InitTags(arg0_41)
	arg0_41.toggles = {}

	arg0_41.tagUIItemList:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			local var0_42 = AgoraFurnitureType.PLACEMENT_TYPE[arg1_42 + 1]

			onToggle(arg0_41, arg2_42, function(arg0_43)
				if arg0_43 then
					arg0_41.selectedTagIndex = arg1_42 + 1

					arg0_41:Op("NotifiyAgora", ISLAND_AGORA_EVT.TAG_CHANGE, var0_42)
					arg0_41:OnFliter(var0_42)
				end
			end, SFX_PANEL)
			setText(arg2_42:Find("sel/Text"), AgoraFurnitureType.Type2CN(var0_42))
			table.insert(arg0_41.toggles, arg2_42)
		end
	end)
	arg0_41.tagUIItemList:align(#AgoraFurnitureType.PLACEMENT_TYPE)
	onToggle(arg0_41, arg0_41.themeBtn, function(arg0_44)
		if arg0_44 then
			arg0_41.selectedTagIndex = nil

			arg0_41:FlushThemeList()
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem4Theme(arg0_45, arg1_45)
	local var0_45 = AgoraDecorationThemeCard.New(arg1_45)

	onButton(arg0_45, var0_45.mainTr, function()
		local var0_46 = isa(var0_45.theme, AgoraSystemTheme)
		local var1_46 = var0_46 and IslandMsgBox.TYPE_SYSTEM_THEME or IslandMsgBox.TYPE_THEME

		arg0_45:ShowMsgbox({
			type = var1_46,
			theme = var0_45.theme,
			onYes = function()
				arg0_45:Op("ApplyTheme", var0_45.theme.id, var0_46)
			end,
			onDel = function()
				arg0_45:Op("DeleteTheme", var0_45.theme.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_45, var0_45.addTr, function()
		local var0_49 = arg0_45:GetView().agora:GetUseableThemeId()

		if not var0_49 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_pos_place"))

			return
		end

		seriesAsync({
			function(arg0_50)
				arg0_45:PrepareToTakeScreenshot()
				arg0_45:ShootScreen(var0_49, arg0_50)
			end,
			function()
				arg0_45:RevertTakeScreenshot()
				arg0_45:ShowMsgbox({
					type = IslandMsgBox.TYPE_SAVE_THEME,
					id = var0_49,
					onYes = function(arg0_52)
						arg0_45:Op("SaveTheme", var0_49, arg0_52)
					end
				})
			end
		})
	end, SFX_PANEL)

	arg0_45.themeCards[arg1_45] = var0_45
end

function var0_0.PrepareToTakeScreenshot(arg0_53)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_SHOOTSCREEN_NAME)
	arg0_53:GetView():ShowOrHideContainer(false)
end

function var0_0.ShootScreen(arg0_54, arg1_54, arg2_54)
	local var0_54 = IslandCameraMgr.instance._mainCamera
	local var1_54 = 426
	local var2_54 = 320

	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(var0_54, function(arg0_55)
		local var0_55

		if arg0_55.width < var1_54 or arg0_55.height < var2_54 then
			var0_55 = arg0_55
		else
			local var1_55 = arg0_55.width * 0.5 - var1_54 * 0.5
			local var2_55 = arg0_55.height * 0.5 - var2_54 * 0.5
			local var3_55 = arg0_55:GetPixels(var1_55, var2_55, var1_54, var2_54)

			var0_55 = UnityEngine.Texture2D.New(var1_54, var2_54)

			var0_55:SetPixels(var3_55)
			var0_55:Apply()
		end

		local var4_55 = Tex2DExtension.EncodeToJPG(var0_55)
		local var5_55 = AgoraCalc.BuildScreenShootSavePath(arg1_54)

		if PathMgr.FileExists(var5_55) then
			System.IO.File.Delete(var5_55)
		end

		System.IO.File.WriteAllBytes(var5_55, var4_55)
		arg2_54()
	end)
end

function var0_0.RevertTakeScreenshot(arg0_56)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_NAME)
	arg0_56:GetView():ShowOrHideContainer(true)
end

function var0_0.OnUpdateItem4Theme(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57.themeCards[arg2_57]

	if not var0_57 then
		arg0_57:OnInitItem4Theme(arg2_57)

		var0_57 = arg0_57.themeCards[arg2_57]
	end

	local var1_57 = arg0_57.displayThemes[arg1_57 + 1]

	var0_57:Update(var1_57)
end

function var0_0.GetDisplayThemes(arg0_58)
	local var0_58 = arg0_58:GetView()
	local var1_58 = var0_58.agora:GetThemes()
	local var2_58 = {}

	for iter0_58, iter1_58 in ipairs(var1_58) do
		table.insert(var2_58, iter1_58)
	end

	if var0_58.agora:GetMaxCustomThemeCnt() > #var1_58 then
		table.insert(var2_58, 1, {
			id = -1
		})
	end

	return var2_58
end

function var0_0.OnInitItem(arg0_59, arg1_59)
	local var0_59 = AgoraDecorationCard.New(arg1_59)
	local var1_59 = false

	local function var2_59()
		if var1_59 then
			arg0_59.descPage:ExecuteAction("Hide")

			var1_59 = false
		end
	end

	var0_59.onClickEvent:RemoveAllListeners()
	var0_59.onClickEvent:AddListener(function()
		if var1_59 then
			var2_59()

			return
		end

		local var0_61 = var0_59.valueObject:GetAvailableItem()

		if var0_61 then
			arg0_59:Op("ClearNew", var0_61.id)
		end

		if var0_59.valueObject:IsOptionalShapeType() then
			arg0_59.shapeSelectPanel:Show(var0_59, function(arg0_62)
				arg0_59:GetView():EnterPaveTileMode(var0_61, arg0_62)
			end)
		elseif var0_59.valueObject:IsBuilding() then
			if var0_61 then
				arg0_59:Op("ReplaceBuilding", var0_61.id)
			end
		elseif var0_59.valueObject:IsFoundation() then
			if var0_61 then
				arg0_59:Op("ReplaceFoundation", var0_61.id)
			end
		else
			if var0_59.valueObject:IsUsing() then
				local var1_61 = var0_59.valueObject:GetFirstItem()

				arg0_59:Op("TrySelectItemById", var1_61.id)

				return
			end

			if var0_61 then
				arg0_59:Op("PlaceItemRandonPosition", var0_61.id)
			end
		end
	end)
	var0_59.longPressTriggerEvent:RemoveAllListeners()
	var0_59.longPressTriggerEvent:AddListener(function()
		var1_59 = true

		arg0_59.descPage:ExecuteAction("Show", var0_59.valueObject, var0_59._go.transform.position)
	end)
	var0_59.onReleasedEvent:RemoveAllListeners()
	var0_59.onReleasedEvent:AddListener(var2_59)

	arg0_59.cards[arg1_59] = var0_59
end

function var0_0.OnUpdateItem(arg0_64, arg1_64, arg2_64)
	local var0_64 = arg0_64.cards[arg2_64]

	if not var0_64 then
		arg0_64:OnInitItem(arg2_64)

		var0_64 = arg0_64.cards[arg2_64]
	end

	local var1_64 = arg0_64.displays[arg1_64 + 1]

	var0_64:Update(var1_64, arg0_64.selectedId)
end

function var0_0.OnFliter(arg0_65, arg1_65)
	arg0_65.indexData.tag = arg1_65

	arg0_65.shapeSelectPanel:Hide()
	arg0_65:FlushList()
end

function var0_0.OnSort(arg0_66, arg1_66)
	arg0_66.indexData.sortKey = arg1_66

	arg0_66:UpdateOrderTxt()
	arg0_66:FlushList()
end

function var0_0.OnSearch(arg0_67, arg1_67)
	arg0_67.indexData.searchKey = arg1_67

	arg0_67:FlushList()
end

function var0_0.OnOrder(arg0_68, arg1_68)
	arg0_68.indexData.order = arg1_68
	arg0_68.orderBtn.localScale = Vector3(1, arg1_68 == 1 and 1 or -1, 1)

	arg0_68:FlushList()
end

function var0_0.UpdateOrderTxt(arg0_69)
	arg0_69.orderTxt.text = AgoraFurnitureType.Sort2CN(arg0_69.indexData.sortKey)
end

function var0_0.GetDisplays(arg0_70)
	local var0_70 = arg0_70:GetView()
	local var1_70 = var0_70.agora:GetPlaceableList()
	local var2_70 = {}

	for iter0_70, iter1_70 in pairs(var1_70) do
		if not var2_70[iter1_70.configId] then
			var2_70[iter1_70.configId] = AgoraDecorationVO.New(iter1_70.configId, var0_70)
		end

		var2_70[iter1_70.configId]:AddItem(iter1_70)
	end

	local var3_70 = {}

	for iter2_70, iter3_70 in pairs(var2_70) do
		if iter3_70:IsType(arg0_70.indexData.tag) and iter3_70:IsMatchSearch(arg0_70.indexData.searchKey) then
			table.insert(var3_70, iter3_70)
		end
	end

	local var4_70

	if arg0_70.indexData.sortKey == AgoraFurnitureType.SORT_DEFAULT then
		var4_70 = {
			function(arg0_71)
				return arg0_71:IsUsing() and 0 or 1
			end,
			function(arg0_72)
				return arg0_72:IsNew() and 0 or 1
			end,
			function(arg0_73)
				return -1 * arg0_73:GetRarity()
			end,
			function(arg0_74)
				return -1 * arg0_74.id
			end
		}
	else
		var4_70 = {
			function(arg0_75)
				return arg0_75:IsUsing() and 0 or 1
			end,
			function(arg0_76)
				return arg0_76:IsNew() and 0 or 1
			end,
			function(arg0_77)
				return -1 * arg0_77:GetSortValue(arg0_70.indexData.sortKey, arg0_70.indexData.order)
			end,
			function(arg0_78)
				return -1 * arg0_78.id
			end
		}
	end

	table.sort(var3_70, CompareFuncs(var4_70))

	return var3_70
end

function var0_0.Flush(arg0_79)
	local var0_79 = arg0_79.selectedTagIndex or 1

	triggerToggle(arg0_79.toggles[var0_79], true)
	arg0_79:FlushCapacity()
	arg0_79:FlushSaveBtn()
	arg0_79.anim:Play("anim_IslandAgoraDecorationUI_In")
end

function var0_0.FlushCard(arg0_80, arg1_80)
	for iter0_80, iter1_80 in pairs(arg0_80.cards or {}) do
		if iter1_80.valueObject:Contains(arg1_80) then
			iter1_80:Update(iter1_80.valueObject, arg0_80.selectedId)

			break
		end
	end
end

function var0_0.FlushList(arg0_81)
	if not isActive(arg0_81.scrollRect) then
		return
	end

	arg0_81.displays = arg0_81:GetDisplays()

	arg0_81.scrollRect:SetTotalCount(#arg0_81.displays)
	setActive(arg0_81.emptyTr, #arg0_81.displays == 0)
end

function var0_0.FlushThemeList(arg0_82)
	if not isActive(arg0_82.scrollRect4Theme) then
		return
	end

	arg0_82.displayThemes = arg0_82:GetDisplayThemes()

	arg0_82.scrollRect4Theme:SetTotalCount(#arg0_82.displayThemes)
	setActive(arg0_82.emptyTr, false)
end

function var0_0.FlushCapacity(arg0_83)
	local var0_83 = arg0_83:GetView().agora:GetCapacity()
	local var1_83 = arg0_83:GetView().agora:GetMaxCapacity()

	arg0_83.capacityTxt.text = i18n("island_agora_capacity") .. ":<color=#a0ff9d>" .. var0_83 .. "</color>/" .. var1_83
end

function var0_0.FlushSaveBtn(arg0_84)
	local var0_84 = arg0_84:GetView():GetController()

	arg0_84:AddSaveCdTimer(var0_84.editCdTime)
end

function var0_0.AddSaveCdTimer(arg0_85, arg1_85)
	arg0_85:RemoveSaveCdTimer()

	if arg1_85 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_85.agoraSaveCdTxt.text = ""

		setActive(arg0_85.agoraSaveBtn, true)
		setActive(arg0_85.agoraSaveCdBtn, false)

		return
	end

	setActive(arg0_85.agoraSaveBtn, false)
	setActive(arg0_85.agoraSaveCdBtn, true)

	arg0_85.saveCdTimer = Timer.New(function()
		local var0_86 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg1_85 - var0_86 <= 0 then
			arg0_85:RemoveSaveCdTimer()
			arg0_85:FlushSaveBtn()
		else
			arg0_85.agoraSaveCdTxt.text = pg.TimeMgr.GetInstance():DescCDTimeForMinute(arg1_85 - var0_86)
		end
	end, 1, -1)

	arg0_85.saveCdTimer:Start()
	arg0_85.saveCdTimer.func()
end

function var0_0.RemoveSaveCdTimer(arg0_87)
	if arg0_87.saveCdTimer then
		arg0_87.saveCdTimer:Stop()

		arg0_87.saveCdTimer = nil
	end
end

function var0_0.OnDestroy(arg0_88)
	ClearLScrollrect(arg0_88.scrollRect)
	ClearLScrollrect(arg0_88.scrollRect4Theme)

	if arg0_88.dftAniEvent then
		arg0_88.dftAniEvent:SetEndEvent(nil)
	end

	arg0_88:RemoveSaveCdTimer()

	if arg0_88.sortPage then
		arg0_88.sortPage:Destroy()

		arg0_88.sortPage = nil
	end

	if arg0_88.descPage then
		arg0_88.descPage:Destroy()

		arg0_88.descPage = nil
	end

	if arg0_88.shapeSelectPanel then
		arg0_88.shapeSelectPanel:Destroy()

		arg0_88.shapeSelectPanel = nil
	end

	for iter0_88, iter1_88 in pairs(arg0_88.cards or {}) do
		iter1_88:Dispose()
	end

	arg0_88.cards = nil

	for iter2_88, iter3_88 in pairs(arg0_88.themeCards or {}) do
		iter3_88:Dispose()
	end

	arg0_88.themeCards = nil
end

return var0_0
