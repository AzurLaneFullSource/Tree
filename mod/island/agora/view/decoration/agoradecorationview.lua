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
end

function var0_0.OnShow(arg0_3)
	IslandGuideChecker.CheckGuide("ISLAND_GUIDE_27")
end

function var0_0.PlayExitAnim(arg0_4, arg1_4)
	if arg0_4.isAniming then
		return
	end

	arg0_4.isAniming = true

	arg0_4.dftAniEvent:SetEndEvent(function()
		arg0_4.isAniming = false

		var0_0.super.Hide(arg0_4)
		arg1_4()
	end)
	arg0_4.anim:Play("anim_IslandAgoraDecorationUI_Out")
end

function var0_0.OnSelectedItem(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg0_6.selectedId

	arg0_6.selectedId = arg1_6

	for iter0_6, iter1_6 in pairs(arg0_6.cards) do
		iter1_6:UpdateSelected(arg0_6.selectedId)
	end

	if not arg2_6 then
		arg0_6:TriggerTag(arg1_6)

		return
	end

	if arg0_6.selectedId > 0 and not arg0_6.isHideState then
		triggerButton(arg0_6.hideBtn)
		arg0_6:FoldBtnsAndTop()
	elseif arg3_6 then
		local var1_6 = _.detect(arg0_6.displays, function(arg0_7)
			return arg0_7:Contains(arg3_6)
		end)

		if var1_6 and var1_6:GetAvailableCnt() > 0 then
			return
		end

		if arg1_6 < 0 then
			triggerButton(arg0_6.showBtn)
		end
	elseif arg1_6 < 0 then
		triggerButton(arg0_6.showBtn)
	end
end

function var0_0.TriggerTag(arg0_8, arg1_8)
	if arg1_8 <= 0 then
		return
	end

	local var0_8 = arg0_8:GetView().agora:GetPlaceableItem(arg1_8)

	if not var0_8 then
		return
	end

	local var1_8 = table.indexof(AgoraFurnitureType.PLACEMENT_TYPE, var0_8:GetType())

	if var1_8 > 0 then
		triggerToggle(arg0_8.toggles[var1_8], true)
	end
end

function var0_0.OnCreateSameItem(arg0_9, arg1_9)
	local var0_9 = _.detect(arg0_9.displays, function(arg0_10)
		return arg0_10:Contains(arg1_9)
	end)

	if var0_9 and var0_9:GetAvailableCnt() > 0 then
		local var1_9 = var0_9:GetAvailableItem()

		arg0_9:Op("PlaceItemRandonPosition", var1_9.id)
	end
end

function var0_0.RegisterEvent(arg0_11)
	function arg0_11.scrollRect.onInitItem(arg0_12)
		arg0_11:OnInitItem(arg0_12)
	end

	function arg0_11.scrollRect.onUpdateItem(arg0_13, arg1_13)
		arg0_11:OnUpdateItem(arg0_13, arg1_13)
	end

	function arg0_11.scrollRect4Theme.onInitItem(arg0_14)
		arg0_11:OnInitItem4Theme(arg0_14)
	end

	function arg0_11.scrollRect4Theme.onUpdateItem(arg0_15, arg1_15)
		arg0_11:OnUpdateItem4Theme(arg0_15, arg1_15)
	end

	onButton(arg0_11, arg0_11.agoraSaveBtn, function()
		if arg0_11:TrySave() then
			arg0_11:Op("Save")
		end
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.agoraClearBtn, function()
		arg0_11:ShowMsgbox({
			content = i18n("island_agora_clear_tip"),
			onYes = function()
				arg0_11:Op("ClearAll")
			end
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.agoraRevertBtn, function()
		arg0_11:ShowMsgbox({
			content = i18n("island_agora_revert_tip"),
			onYes = function()
				arg0_11:Op("Revert")
			end
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.capacityBtn, function()
		local var0_21 = arg0_11:GetView()
		local var1_21 = var0_21.agora:GetPlacedInfoList()
		local var2_21 = var0_21.agora:GetMaxCapacity()

		arg0_11:ShowMsgbox({
			type = IslandMsgBox.TYPE_AGORA_PLACED_LIST,
			list = var1_21,
			totalCnt = var2_21
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.agoraShopBtn, function()
		if arg0_11:GetView():GetController():CheckChange() then
			arg0_11:Save()
		else
			arg0_11:PlayExitAnim(function()
				arg0_11:Op("ExitEditMode")
				arg0_11:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE, IslandShopPage, {
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
	onButton(arg0_11, arg0_11.backBtn, function()
		if arg0_11:GetView():GetController():CheckChange() then
			arg0_11:Save()
		else
			arg0_11:PlayExitAnim(function()
				arg0_11:Op("ExitEditMode")
			end)
		end
	end, SFX_PANEL)
	onInputChanged(arg0_11, arg0_11.searchInput, function()
		local var0_26 = getInputText(arg0_11.searchInput)

		setActive(arg0_11.searchClearBtn, var0_26 ~= "")
		arg0_11:OnSearch(var0_26)
	end)
	onButton(arg0_11, arg0_11.searchClearBtn, function()
		setInputText(arg0_11.searchInput, "")

		arg0_11.indexData.searchKey = ""
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.sortBtn, function()
		arg0_11.sortPage:ExecuteAction("Show", arg0_11.indexData, function(arg0_29)
			arg0_11:OnSort(arg0_29)
		end)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.orderBtn, function()
		local var0_30 = 1 - arg0_11.indexData.order

		arg0_11:OnOrder(var0_30)
	end, SFX_PANEL)

	arg0_11.isHideState = false
	arg0_11.isHideBtnAndTop = false

	onButton(arg0_11, arg0_11.hideBtn, function()
		arg0_11.isHideState = true

		arg0_11.panelAnim:Play("fold")
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.showBtn, function()
		arg0_11.isHideState = false

		arg0_11.panelAnim:Play("unfold")

		if arg0_11.isHideBtnAndTop then
			arg0_11:UnFoldBtnsAndTop()
		end
	end, SFX_PANEL)
end

function var0_0.TrySave(arg0_33)
	local var0_33 = arg0_33:GetView():GetController():CanEnterEditMode()

	if not var0_33 then
		arg0_33:ShowMsgbox({
			type = IslandMsgBox.TYPE_AOGRA_SAVE_CD,
			duetime = arg0_33:GetView():GetController().editCdTime,
			onNo = function()
				arg0_33:Op("RevertAndExit")
			end
		})
	end

	return var0_33
end

function var0_0.Save(arg0_35)
	if arg0_35:TrySave() then
		arg0_35:ShowMsgbox({
			content = i18n("island_agora_save_or_exit_tip"),
			noText = i18n("island_agora_exit_and_unsave"),
			yesText = i18n("island_agora_exit_and_save"),
			onYes = function()
				arg0_35:Op("SaveAndExit")
			end,
			onNo = function()
				arg0_35:Op("RevertAndExit")
			end
		})
	end
end

function var0_0.FoldBtnsAndTop(arg0_38)
	setActive(arg0_38.agoraSaveBtn, false)
	setActive(arg0_38.agoraClearBtn, false)
	setActive(arg0_38.agoraRevertBtn, false)
	setActive(arg0_38.topPanel, false)

	arg0_38.isHideBtnAndTop = true
end

function var0_0.UnFoldBtnsAndTop(arg0_39)
	setActive(arg0_39.agoraSaveBtn, true)
	setActive(arg0_39.agoraClearBtn, true)
	setActive(arg0_39.agoraRevertBtn, true)
	setActive(arg0_39.topPanel, true)

	arg0_39.isHideBtnAndTop = false
end

function var0_0.InitTags(arg0_40)
	arg0_40.toggles = {}

	arg0_40.tagUIItemList:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			local var0_41 = AgoraFurnitureType.PLACEMENT_TYPE[arg1_41 + 1]

			onToggle(arg0_40, arg2_41, function(arg0_42)
				if arg0_42 then
					arg0_40.selectedTagIndex = arg1_41 + 1

					arg0_40:Op("NotifiyAgora", ISLAND_AGORA_EVT.TAG_CHANGE, var0_41)
					arg0_40:OnFliter(var0_41)
				end
			end, SFX_PANEL)
			setText(arg2_41:Find("sel/Text"), AgoraFurnitureType.Type2CN(var0_41))
			table.insert(arg0_40.toggles, arg2_41)
		end
	end)
	arg0_40.tagUIItemList:align(#AgoraFurnitureType.PLACEMENT_TYPE)
	onToggle(arg0_40, arg0_40.themeBtn, function(arg0_43)
		if arg0_43 then
			arg0_40.selectedTagIndex = nil

			arg0_40:FlushThemeList()
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem4Theme(arg0_44, arg1_44)
	local var0_44 = AgoraDecorationThemeCard.New(arg1_44)

	onButton(arg0_44, var0_44.mainTr, function()
		local var0_45 = isa(var0_44.theme, AgoraSystemTheme)
		local var1_45 = var0_45 and IslandMsgBox.TYPE_SYSTEM_THEME or IslandMsgBox.TYPE_THEME

		arg0_44:ShowMsgbox({
			type = var1_45,
			theme = var0_44.theme,
			onYes = function()
				arg0_44:Op("ApplyTheme", var0_44.theme.id, var0_45)
			end,
			onDel = function()
				arg0_44:Op("DeleteTheme", var0_44.theme.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_44, var0_44.addTr, function()
		local var0_48 = arg0_44:GetView().agora:GetUseableThemeId()

		if not var0_48 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_pos_place"))

			return
		end

		seriesAsync({
			function(arg0_49)
				arg0_44:PrepareToTakeScreenshot()
				arg0_44:ShootScreen(var0_48, arg0_49)
			end,
			function()
				arg0_44:RevertTakeScreenshot()
				arg0_44:ShowMsgbox({
					type = IslandMsgBox.TYPE_SAVE_THEME,
					id = var0_48,
					onYes = function(arg0_51)
						arg0_44:Op("SaveTheme", var0_48, arg0_51)
					end
				})
			end
		})
	end, SFX_PANEL)

	arg0_44.themeCards[arg1_44] = var0_44
end

function var0_0.PrepareToTakeScreenshot(arg0_52)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_SHOOTSCREEN_NAME)
	arg0_52:GetView():ShowOrHideContainer(false)
end

function var0_0.ShootScreen(arg0_53, arg1_53, arg2_53)
	local var0_53 = IslandCameraMgr.instance._mainCamera
	local var1_53 = 426
	local var2_53 = 320

	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(var0_53, function(arg0_54)
		local var0_54

		if arg0_54.width < var1_53 or arg0_54.height < var2_53 then
			var0_54 = arg0_54
		else
			local var1_54 = arg0_54.width * 0.5 - var1_53 * 0.5
			local var2_54 = arg0_54.height * 0.5 - var2_53 * 0.5
			local var3_54 = arg0_54:GetPixels(var1_54, var2_54, var1_53, var2_53)

			var0_54 = UnityEngine.Texture2D.New(var1_53, var2_53)

			var0_54:SetPixels(var3_54)
			var0_54:Apply()
		end

		local var4_54 = Tex2DExtension.EncodeToJPG(var0_54)
		local var5_54 = AgoraCalc.BuildScreenShootSavePath(arg1_53)

		if PathMgr.FileExists(var5_54) then
			System.IO.File.Delete(var5_54)
		end

		System.IO.File.WriteAllBytes(var5_54, var4_54)
		arg2_53()
	end)
end

function var0_0.RevertTakeScreenshot(arg0_55)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_NAME)
	arg0_55:GetView():ShowOrHideContainer(true)
end

function var0_0.OnUpdateItem4Theme(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56.themeCards[arg2_56]

	if not var0_56 then
		arg0_56:OnInitItem4Theme(arg2_56)

		var0_56 = arg0_56.themeCards[arg2_56]
	end

	local var1_56 = arg0_56.displayThemes[arg1_56 + 1]

	var0_56:Update(var1_56)
end

function var0_0.GetDisplayThemes(arg0_57)
	local var0_57 = arg0_57:GetView()
	local var1_57 = var0_57.agora:GetThemes()
	local var2_57 = {}

	for iter0_57, iter1_57 in ipairs(var1_57) do
		table.insert(var2_57, iter1_57)
	end

	if var0_57.agora:GetMaxCustomThemeCnt() > #var1_57 then
		table.insert(var2_57, 1, {
			id = -1
		})
	end

	return var2_57
end

function var0_0.OnInitItem(arg0_58, arg1_58)
	local var0_58 = AgoraDecorationCard.New(arg1_58)
	local var1_58 = false

	local function var2_58()
		if var1_58 then
			arg0_58.descPage:ExecuteAction("Hide")

			var1_58 = false
		end
	end

	var0_58.onClickEvent:RemoveAllListeners()
	var0_58.onClickEvent:AddListener(function()
		if var1_58 then
			var2_58()

			return
		end

		local var0_60 = var0_58.valueObject:GetAvailableItem()

		if var0_60 then
			arg0_58:Op("ClearNew", var0_60.id)
		end

		if var0_58.valueObject:IsOptionalShapeType() then
			arg0_58.shapeSelectPanel:Show(var0_58, function(arg0_61)
				arg0_58:GetView():EnterPaveTileMode(var0_60, arg0_61)
			end)
		elseif var0_58.valueObject:IsBuilding() then
			if var0_60 then
				arg0_58:Op("ReplaceBuilding", var0_60.id)
			end
		elseif var0_58.valueObject:IsFoundation() then
			if var0_60 then
				arg0_58:Op("ReplaceFoundation", var0_60.id)
			end
		else
			if var0_58.valueObject:IsUsing() then
				local var1_60 = var0_58.valueObject:GetFirstItem()

				arg0_58:Op("TrySelectItemById", var1_60.id)

				return
			end

			if var0_60 then
				arg0_58:Op("PlaceItemRandonPosition", var0_60.id)
			end
		end
	end)
	var0_58.longPressTriggerEvent:RemoveAllListeners()
	var0_58.longPressTriggerEvent:AddListener(function()
		var1_58 = true

		arg0_58.descPage:ExecuteAction("Show", var0_58.valueObject, var0_58._go.transform.position)
	end)
	var0_58.onReleasedEvent:RemoveAllListeners()
	var0_58.onReleasedEvent:AddListener(var2_58)

	arg0_58.cards[arg1_58] = var0_58
end

function var0_0.OnUpdateItem(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg0_63.cards[arg2_63]

	if not var0_63 then
		arg0_63:OnInitItem(arg2_63)

		var0_63 = arg0_63.cards[arg2_63]
	end

	local var1_63 = arg0_63.displays[arg1_63 + 1]

	var0_63:Update(var1_63, arg0_63.selectedId)
end

function var0_0.OnFliter(arg0_64, arg1_64)
	arg0_64.indexData.tag = arg1_64

	arg0_64.shapeSelectPanel:Hide()
	arg0_64:FlushList()
end

function var0_0.OnSort(arg0_65, arg1_65)
	arg0_65.indexData.sortKey = arg1_65

	arg0_65:UpdateOrderTxt()
	arg0_65:FlushList()
end

function var0_0.OnSearch(arg0_66, arg1_66)
	arg0_66.indexData.searchKey = arg1_66

	arg0_66:FlushList()
end

function var0_0.OnOrder(arg0_67, arg1_67)
	arg0_67.indexData.order = arg1_67
	arg0_67.orderBtn.localScale = Vector3(1, arg1_67 == 1 and 1 or -1, 1)

	arg0_67:FlushList()
end

function var0_0.UpdateOrderTxt(arg0_68)
	arg0_68.orderTxt.text = AgoraFurnitureType.Sort2CN(arg0_68.indexData.sortKey)
end

function var0_0.GetDisplays(arg0_69)
	local var0_69 = arg0_69:GetView()
	local var1_69 = var0_69.agora:GetPlaceableList()
	local var2_69 = {}

	for iter0_69, iter1_69 in pairs(var1_69) do
		if not var2_69[iter1_69.configId] then
			var2_69[iter1_69.configId] = AgoraDecorationVO.New(iter1_69.configId, var0_69)
		end

		var2_69[iter1_69.configId]:AddItem(iter1_69)
	end

	local var3_69 = {}

	for iter2_69, iter3_69 in pairs(var2_69) do
		if iter3_69:IsType(arg0_69.indexData.tag) and iter3_69:IsMatchSearch(arg0_69.indexData.searchKey) then
			table.insert(var3_69, iter3_69)
		end
	end

	local var4_69

	if arg0_69.indexData.sortKey == AgoraFurnitureType.SORT_DEFAULT then
		var4_69 = {
			function(arg0_70)
				return arg0_70:IsUsing() and 0 or 1
			end,
			function(arg0_71)
				return arg0_71:IsNew() and 0 or 1
			end,
			function(arg0_72)
				return -1 * arg0_72:GetRarity()
			end,
			function(arg0_73)
				return -1 * arg0_73.id
			end
		}
	else
		var4_69 = {
			function(arg0_74)
				return arg0_74:IsUsing() and 0 or 1
			end,
			function(arg0_75)
				return arg0_75:IsNew() and 0 or 1
			end,
			function(arg0_76)
				return -1 * arg0_76:GetSortValue(arg0_69.indexData.sortKey, arg0_69.indexData.order)
			end,
			function(arg0_77)
				return -1 * arg0_77.id
			end
		}
	end

	table.sort(var3_69, CompareFuncs(var4_69))

	return var3_69
end

function var0_0.Flush(arg0_78)
	local var0_78 = arg0_78.selectedTagIndex or 1

	triggerToggle(arg0_78.toggles[var0_78], true)
	arg0_78:FlushCapacity()
	arg0_78:FlushSaveBtn()
	arg0_78.anim:Play("anim_IslandAgoraDecorationUI_In")
end

function var0_0.FlushCard(arg0_79, arg1_79)
	for iter0_79, iter1_79 in pairs(arg0_79.cards or {}) do
		if iter1_79.valueObject:Contains(arg1_79) then
			iter1_79:Update(iter1_79.valueObject, arg0_79.selectedId)

			break
		end
	end
end

function var0_0.FlushList(arg0_80)
	if not isActive(arg0_80.scrollRect) then
		return
	end

	arg0_80.displays = arg0_80:GetDisplays()

	arg0_80.scrollRect:SetTotalCount(#arg0_80.displays)
	setActive(arg0_80.emptyTr, #arg0_80.displays == 0)
end

function var0_0.FlushThemeList(arg0_81)
	if not isActive(arg0_81.scrollRect4Theme) then
		return
	end

	arg0_81.displayThemes = arg0_81:GetDisplayThemes()

	arg0_81.scrollRect4Theme:SetTotalCount(#arg0_81.displayThemes)
	setActive(arg0_81.emptyTr, false)
end

function var0_0.FlushCapacity(arg0_82)
	local var0_82 = arg0_82:GetView().agora:GetCapacity()
	local var1_82 = arg0_82:GetView().agora:GetMaxCapacity()

	arg0_82.capacityTxt.text = i18n("island_agora_capacity") .. ":<color=#a0ff9d>" .. var0_82 .. "</color>/" .. var1_82
end

function var0_0.FlushSaveBtn(arg0_83)
	local var0_83 = arg0_83:GetView():GetController()

	arg0_83:AddSaveCdTimer(var0_83.editCdTime)
end

function var0_0.AddSaveCdTimer(arg0_84, arg1_84)
	arg0_84:RemoveSaveCdTimer()

	if arg1_84 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_84.agoraSaveCdTxt.text = ""

		setActive(arg0_84.agoraSaveBtn, true)
		setActive(arg0_84.agoraSaveCdBtn, false)

		return
	end

	setActive(arg0_84.agoraSaveBtn, false)
	setActive(arg0_84.agoraSaveCdBtn, true)

	arg0_84.saveCdTimer = Timer.New(function()
		local var0_85 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg1_84 - var0_85 <= 0 then
			arg0_84:RemoveSaveCdTimer()
			arg0_84:FlushSaveBtn()
		else
			arg0_84.agoraSaveCdTxt.text = pg.TimeMgr.GetInstance():DescCDTimeForMinute(arg1_84 - var0_85)
		end
	end, 1, -1)

	arg0_84.saveCdTimer:Start()
	arg0_84.saveCdTimer.func()
end

function var0_0.RemoveSaveCdTimer(arg0_86)
	if arg0_86.saveCdTimer then
		arg0_86.saveCdTimer:Stop()

		arg0_86.saveCdTimer = nil
	end
end

function var0_0.OnDestroy(arg0_87)
	if arg0_87.dftAniEvent then
		arg0_87.dftAniEvent:SetEndEvent(nil)
	end

	arg0_87:RemoveSaveCdTimer()

	if arg0_87.sortPage then
		arg0_87.sortPage:Destroy()

		arg0_87.sortPage = nil
	end

	if arg0_87.descPage then
		arg0_87.descPage:Destroy()

		arg0_87.descPage = nil
	end

	if arg0_87.shapeSelectPanel then
		arg0_87.shapeSelectPanel:Destroy()

		arg0_87.shapeSelectPanel = nil
	end

	for iter0_87, iter1_87 in pairs(arg0_87.cards or {}) do
		iter1_87:Dispose()
	end

	arg0_87.cards = nil

	for iter2_87, iter3_87 in pairs(arg0_87.themeCards or {}) do
		iter3_87:Dispose()
	end

	arg0_87.themeCards = nil
end

return var0_0
