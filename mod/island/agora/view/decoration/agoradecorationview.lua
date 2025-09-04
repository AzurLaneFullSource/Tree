local var0_0 = class("AgoraDecorationView", import("Mod.Island.Core.View.IslandBaseSubView"))

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

function var0_0.PlayExitAnim(arg0_3, arg1_3)
	if arg0_3.isAniming then
		return
	end

	arg0_3.isAniming = true

	arg0_3.dftAniEvent:SetEndEvent(function()
		arg0_3.isAniming = false

		arg1_3()
		var0_0.super.Hide(arg0_3)
	end)
	arg0_3.anim:Play("anim_IslandAgoraDecorationUI_Out")
end

function var0_0.OnSelectedItem(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg0_5.selectedId

	arg0_5.selectedId = arg1_5

	for iter0_5, iter1_5 in pairs(arg0_5.cards) do
		iter1_5:UpdateSelected(arg0_5.selectedId)
	end

	if not arg2_5 then
		arg0_5:TriggerTag(arg1_5)

		return
	end

	if arg0_5.selectedId > 0 and not arg0_5.isHideState then
		triggerButton(arg0_5.hideBtn)
		arg0_5:FoldBtnsAndTop()
	elseif arg3_5 then
		local var1_5 = _.detect(arg0_5.displays, function(arg0_6)
			return arg0_6:Contains(arg3_5)
		end)

		if var1_5 and var1_5:GetAvailableCnt() > 0 then
			return
		end

		if arg1_5 < 0 then
			triggerButton(arg0_5.showBtn)
		end
	elseif arg1_5 < 0 then
		triggerButton(arg0_5.showBtn)
	end
end

function var0_0.TriggerTag(arg0_7, arg1_7)
	if arg1_7 <= 0 then
		return
	end

	local var0_7 = arg0_7:GetView().agora:GetPlaceableItem(arg1_7)

	if not var0_7 then
		return
	end

	local var1_7 = table.indexof(AgoraFurnitureType.PLACEMENT_TYPE, var0_7:GetType())

	if var1_7 > 0 then
		triggerToggle(arg0_7.toggles[var1_7], true)
	end
end

function var0_0.OnCreateSameItem(arg0_8, arg1_8)
	local var0_8 = _.detect(arg0_8.displays, function(arg0_9)
		return arg0_9:Contains(arg1_8)
	end)

	if var0_8 and var0_8:GetAvailableCnt() > 0 then
		local var1_8 = var0_8:GetAvailableItem()

		arg0_8:Op("PlaceItemRandonPosition", var1_8.id)
	end
end

function var0_0.RegisterEvent(arg0_10)
	function arg0_10.scrollRect.onInitItem(arg0_11)
		arg0_10:OnInitItem(arg0_11)
	end

	function arg0_10.scrollRect.onUpdateItem(arg0_12, arg1_12)
		arg0_10:OnUpdateItem(arg0_12, arg1_12)
	end

	function arg0_10.scrollRect4Theme.onInitItem(arg0_13)
		arg0_10:OnInitItem4Theme(arg0_13)
	end

	function arg0_10.scrollRect4Theme.onUpdateItem(arg0_14, arg1_14)
		arg0_10:OnUpdateItem4Theme(arg0_14, arg1_14)
	end

	onButton(arg0_10, arg0_10.agoraSaveBtn, function()
		if arg0_10:TrySave() then
			arg0_10:Op("Save")
		end
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.agoraClearBtn, function()
		arg0_10:ShowMsgbox({
			content = i18n("island_agora_clear_tip"),
			onYes = function()
				arg0_10:Op("ClearAll")
			end
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.agoraRevertBtn, function()
		arg0_10:ShowMsgbox({
			content = i18n("island_agora_revert_tip"),
			onYes = function()
				arg0_10:Op("Revert")
			end
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.capacityBtn, function()
		local var0_20 = arg0_10:GetView()
		local var1_20 = var0_20.agora:GetPlacedInfoList()
		local var2_20 = var0_20.agora:GetMaxCapacity()

		arg0_10:ShowMsgbox({
			type = IslandMsgBox.TYPE_AGORA_PLACED_LIST,
			list = var1_20,
			totalCnt = var2_20
		})
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.agoraShopBtn, function()
		if arg0_10:GetView():GetController():CheckChange() then
			arg0_10:Save()
		else
			arg0_10:PlayExitAnim(function()
				arg0_10:Op("ExitEditMode")
				arg0_10:NotifiyIsland(ISLAND_EX_EVT.OPEN_PAGE, IslandShopPage, {
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
	onButton(arg0_10, arg0_10.backBtn, function()
		if arg0_10:GetView():GetController():CheckChange() then
			arg0_10:Save()
		else
			arg0_10:PlayExitAnim(function()
				arg0_10:Op("ExitEditMode")
			end)
		end
	end, SFX_PANEL)
	onInputChanged(arg0_10, arg0_10.searchInput, function()
		local var0_25 = getInputText(arg0_10.searchInput)

		setActive(arg0_10.searchClearBtn, var0_25 ~= "")
		arg0_10:OnSearch(var0_25)
	end)
	onButton(arg0_10, arg0_10.searchClearBtn, function()
		setInputText(arg0_10.searchInput, "")

		arg0_10.indexData.searchKey = ""
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.sortBtn, function()
		arg0_10.sortPage:ExecuteAction("Show", arg0_10.indexData, function(arg0_28)
			arg0_10:OnSort(arg0_28)
		end)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.orderBtn, function()
		local var0_29 = 1 - arg0_10.indexData.order

		arg0_10:OnOrder(var0_29)
	end, SFX_PANEL)

	arg0_10.isHideState = false
	arg0_10.isHideBtnAndTop = false

	onButton(arg0_10, arg0_10.hideBtn, function()
		arg0_10.isHideState = true

		arg0_10.panelAnim:Play("fold")
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.showBtn, function()
		arg0_10.isHideState = false

		arg0_10.panelAnim:Play("unfold")

		if arg0_10.isHideBtnAndTop then
			arg0_10:UnFoldBtnsAndTop()
		end
	end, SFX_PANEL)
end

function var0_0.TrySave(arg0_32)
	local var0_32 = arg0_32:GetView():GetController():CanEnterEditMode()

	if not var0_32 then
		arg0_32:ShowMsgbox({
			type = IslandMsgBox.TYPE_AOGRA_SAVE_CD,
			duetime = arg0_32:GetView():GetController().editCdTime,
			onNo = function()
				arg0_32:Op("RevertAndExit")
			end
		})
	end

	return var0_32
end

function var0_0.Save(arg0_34)
	if arg0_34:TrySave() then
		arg0_34:ShowMsgbox({
			content = i18n("island_agora_save_or_exit_tip"),
			noText = i18n("island_agora_exit_and_unsave"),
			yesText = i18n("island_agora_exit_and_save"),
			onYes = function()
				arg0_34:Op("SaveAndExit")
			end,
			onNo = function()
				arg0_34:Op("RevertAndExit")
			end
		})
	end
end

function var0_0.FoldBtnsAndTop(arg0_37)
	setActive(arg0_37.agoraSaveBtn, false)
	setActive(arg0_37.agoraClearBtn, false)
	setActive(arg0_37.agoraRevertBtn, false)
	setActive(arg0_37.topPanel, false)

	arg0_37.isHideBtnAndTop = true
end

function var0_0.UnFoldBtnsAndTop(arg0_38)
	setActive(arg0_38.agoraSaveBtn, true)
	setActive(arg0_38.agoraClearBtn, true)
	setActive(arg0_38.agoraRevertBtn, true)
	setActive(arg0_38.topPanel, true)

	arg0_38.isHideBtnAndTop = false
end

function var0_0.InitTags(arg0_39)
	arg0_39.toggles = {}

	arg0_39.tagUIItemList:make(function(arg0_40, arg1_40, arg2_40)
		if arg0_40 == UIItemList.EventUpdate then
			local var0_40 = AgoraFurnitureType.PLACEMENT_TYPE[arg1_40 + 1]

			onToggle(arg0_39, arg2_40, function(arg0_41)
				if arg0_41 then
					arg0_39.selectedTagIndex = arg1_40 + 1

					arg0_39:GetView():OnTagChange(var0_40)
					arg0_39:OnFliter(var0_40)
				end
			end, SFX_PANEL)
			setText(arg2_40:Find("sel/Text"), AgoraFurnitureType.Type2CN(var0_40))
			table.insert(arg0_39.toggles, arg2_40)
		end
	end)
	arg0_39.tagUIItemList:align(#AgoraFurnitureType.PLACEMENT_TYPE)
	onToggle(arg0_39, arg0_39.themeBtn, function(arg0_42)
		if arg0_42 then
			arg0_39.selectedTagIndex = nil

			arg0_39:FlushThemeList()
		end
	end, SFX_PANEL)
end

function var0_0.OnInitItem4Theme(arg0_43, arg1_43)
	local var0_43 = AgoraDecorationThemeCard.New(arg1_43)

	onButton(arg0_43, var0_43.mainTr, function()
		local var0_44 = isa(var0_43.theme, AgoraSystemTheme)
		local var1_44 = var0_44 and IslandMsgBox.TYPE_SYSTEM_THEME or IslandMsgBox.TYPE_THEME

		arg0_43:ShowMsgbox({
			type = var1_44,
			theme = var0_43.theme,
			onYes = function()
				arg0_43:Op("ApplyTheme", var0_43.theme.id, var0_44)
			end,
			onDel = function()
				arg0_43:Op("DeleteTheme", var0_43.theme.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_43, var0_43.addTr, function()
		local var0_47 = arg0_43:GetView().agora:GetUseableThemeId()

		if not var0_47 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_no_pos_place"))

			return
		end

		seriesAsync({
			function(arg0_48)
				arg0_43:PrepareToTakeScreenshot()
				arg0_43:ShootScreen(var0_47, arg0_48)
			end,
			function()
				arg0_43:RevertTakeScreenshot()
				arg0_43:ShowMsgbox({
					type = IslandMsgBox.TYPE_SAVE_THEME,
					id = var0_47,
					onYes = function(arg0_50)
						arg0_43:Op("SaveTheme", var0_47, arg0_50)
					end
				})
			end
		})
	end, SFX_PANEL)

	arg0_43.themeCards[arg1_43] = var0_43
end

function var0_0.PrepareToTakeScreenshot(arg0_51)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_SHOOTSCREEN_NAME)
	arg0_51:GetView():ShowOrHideContainer(false)
end

function var0_0.ShootScreen(arg0_52, arg1_52, arg2_52)
	local var0_52 = IslandCameraMgr.instance._mainCamera
	local var1_52 = 426
	local var2_52 = 320

	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(var0_52, function(arg0_53)
		local var0_53

		if arg0_53.width < var1_52 or arg0_53.height < var2_52 then
			var0_53 = arg0_53
		else
			local var1_53 = arg0_53.width * 0.5 - var1_52 * 0.5
			local var2_53 = arg0_53.height * 0.5 - var2_52 * 0.5
			local var3_53 = arg0_53:GetPixels(var1_53, var2_53, var1_52, var2_52)

			var0_53 = UnityEngine.Texture2D.New(var1_52, var2_52)

			var0_53:SetPixels(var3_53)
			var0_53:Apply()
		end

		local var4_53 = Tex2DExtension.EncodeToJPG(var0_53)
		local var5_53 = AgoraCalc.BuildScreenShootSavePath(arg1_52)

		if PathMgr.FileExists(var5_53) then
			System.IO.File.Delete(var5_53)
		end

		System.IO.File.WriteAllBytes(var5_53, var4_53)
		arg2_52()
	end)
end

function var0_0.RevertTakeScreenshot(arg0_54)
	IslandCameraMgr.instance:ActiveVirtualCamera(IslandConst.AGORA_CAMERA_NAME)
	arg0_54:GetView():ShowOrHideContainer(true)
end

function var0_0.OnUpdateItem4Theme(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg0_55.themeCards[arg2_55]

	if not var0_55 then
		arg0_55:OnInitItem4Theme(arg2_55)

		var0_55 = arg0_55.themeCards[arg2_55]
	end

	local var1_55 = arg0_55.displayThemes[arg1_55 + 1]

	var0_55:Update(var1_55)
end

function var0_0.GetDisplayThemes(arg0_56)
	local var0_56 = arg0_56:GetView()
	local var1_56 = var0_56.agora:GetThemes()
	local var2_56 = {}

	for iter0_56, iter1_56 in ipairs(var1_56) do
		table.insert(var2_56, iter1_56)
	end

	if var0_56.agora:GetMaxCustomThemeCnt() > #var1_56 then
		table.insert(var2_56, 1, {
			id = -1
		})
	end

	local var3_56 = var0_56.agora:GetSystemThemes()

	for iter2_56, iter3_56 in ipairs(var3_56) do
		if iter3_56:Owned(var0_56.agora:GetPlaceableList()) then
			table.insert(var2_56, iter3_56)
		end
	end

	return var2_56
end

function var0_0.OnInitItem(arg0_57, arg1_57)
	local var0_57 = AgoraDecorationCard.New(arg1_57)
	local var1_57 = false

	local function var2_57()
		if var1_57 then
			arg0_57.descPage:ExecuteAction("Hide")

			var1_57 = false
		end
	end

	var0_57.onClickEvent:RemoveAllListeners()
	var0_57.onClickEvent:AddListener(function()
		if var1_57 then
			var2_57()

			return
		end

		local var0_59 = var0_57.valueObject:GetAvailableItem()

		if var0_57.valueObject:IsOptionalShapeType() then
			arg0_57.shapeSelectPanel:Show(var0_57, function(arg0_60)
				arg0_57:GetView():EnterPaveTileMode(var0_59, arg0_60)
			end)
		elseif var0_57.valueObject:IsBuilding() then
			if var0_59 then
				arg0_57:Op("ReplaceBuilding", var0_59.id)
			end
		elseif var0_57.valueObject:IsFoundation() then
			if var0_59 then
				arg0_57:Op("ReplaceFoundation", var0_59.id)
			end
		else
			if var0_57.valueObject:IsUsing() then
				local var1_59 = var0_57.valueObject:GetFirstItem()

				arg0_57:Op("TrySelectItemById", var1_59.id)

				return
			end

			if var0_59 then
				arg0_57:Op("PlaceItemRandonPosition", var0_59.id)
			end
		end
	end)
	var0_57.longPressTriggerEvent:RemoveAllListeners()
	var0_57.longPressTriggerEvent:AddListener(function()
		var1_57 = true

		arg0_57.descPage:ExecuteAction("Show", var0_57.valueObject, var0_57._go.transform.position)
	end)
	var0_57.onReleasedEvent:RemoveAllListeners()
	var0_57.onReleasedEvent:AddListener(var2_57)

	arg0_57.cards[arg1_57] = var0_57
end

function var0_0.OnUpdateItem(arg0_62, arg1_62, arg2_62)
	local var0_62 = arg0_62.cards[arg2_62]

	if not var0_62 then
		arg0_62:OnInitItem(arg2_62)

		var0_62 = arg0_62.cards[arg2_62]
	end

	local var1_62 = arg0_62.displays[arg1_62 + 1]

	var0_62:Update(var1_62, arg0_62.selectedId)
end

function var0_0.OnFliter(arg0_63, arg1_63)
	arg0_63.indexData.tag = arg1_63

	arg0_63.shapeSelectPanel:Hide()
	arg0_63:FlushList()
end

function var0_0.OnSort(arg0_64, arg1_64)
	arg0_64.indexData.sortKey = arg1_64

	arg0_64:UpdateOrderTxt()
	arg0_64:FlushList()
end

function var0_0.OnSearch(arg0_65, arg1_65)
	arg0_65.indexData.searchKey = arg1_65

	arg0_65:FlushList()
end

function var0_0.OnOrder(arg0_66, arg1_66)
	arg0_66.indexData.order = arg1_66
	arg0_66.orderBtn.localScale = Vector3(1, arg1_66 == 1 and 1 or -1, 1)

	arg0_66:FlushList()
end

function var0_0.UpdateOrderTxt(arg0_67)
	arg0_67.orderTxt.text = AgoraFurnitureType.Sort2CN(arg0_67.indexData.sortKey)
end

function var0_0.GetDisplays(arg0_68)
	local var0_68 = arg0_68:GetView()
	local var1_68 = var0_68.agora:GetPlaceableList()
	local var2_68 = {}

	for iter0_68, iter1_68 in pairs(var1_68) do
		if not var2_68[iter1_68.configId] then
			var2_68[iter1_68.configId] = AgoraDecorationVO.New(iter1_68.configId, var0_68)
		end

		var2_68[iter1_68.configId]:AddItem(iter1_68)
	end

	local var3_68 = {}

	for iter2_68, iter3_68 in pairs(var2_68) do
		if iter3_68:IsType(arg0_68.indexData.tag) and iter3_68:IsMatchSearch(arg0_68.indexData.searchKey) then
			table.insert(var3_68, iter3_68)
		end
	end

	local var4_68

	if arg0_68.indexData.sortKey == AgoraFurnitureType.SORT_DEFAULT then
		var4_68 = {
			function(arg0_69)
				return arg0_69:IsUsing() and 0 or 1
			end,
			function(arg0_70)
				return arg0_70.id
			end
		}
	else
		var4_68 = {
			function(arg0_71)
				return arg0_71:IsUsing() and 0 or 1
			end,
			function(arg0_72)
				return arg0_72:GetSortValue(arg0_68.indexData.sortKey, arg0_68.indexData.order)
			end
		}
	end

	table.sort(var3_68, CompareFuncs(var4_68))

	return var3_68
end

function var0_0.Flush(arg0_73)
	local var0_73 = arg0_73.selectedTagIndex or 1

	triggerToggle(arg0_73.toggles[var0_73], true)
	arg0_73:FlushCapacity()
	arg0_73:FlushSaveBtn()
end

function var0_0.FlushList(arg0_74)
	if not isActive(arg0_74.scrollRect) then
		return
	end

	arg0_74.displays = arg0_74:GetDisplays()

	arg0_74.scrollRect:SetTotalCount(#arg0_74.displays)
	setActive(arg0_74.emptyTr, #arg0_74.displays == 0)
end

function var0_0.FlushThemeList(arg0_75)
	if not isActive(arg0_75.scrollRect4Theme) then
		return
	end

	arg0_75.displayThemes = arg0_75:GetDisplayThemes()

	arg0_75.scrollRect4Theme:SetTotalCount(#arg0_75.displayThemes)
	setActive(arg0_75.emptyTr, false)
end

function var0_0.FlushCapacity(arg0_76)
	local var0_76 = arg0_76:GetView().agora:GetCapacity()
	local var1_76 = arg0_76:GetView().agora:GetMaxCapacity()

	arg0_76.capacityTxt.text = i18n("island_agora_label_capacity") .. ":<color=#a0ff9d>" .. var0_76 .. "</color>/" .. var1_76
end

function var0_0.FlushSaveBtn(arg0_77)
	local var0_77 = arg0_77:GetView():GetController()

	arg0_77:AddSaveCdTimer(var0_77.editCdTime)
end

function var0_0.AddSaveCdTimer(arg0_78, arg1_78)
	arg0_78:RemoveSaveCdTimer()

	if arg1_78 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_78.agoraSaveCdTxt.text = ""

		setActive(arg0_78.agoraSaveBtn, true)
		setActive(arg0_78.agoraSaveCdBtn, false)

		return
	end

	setActive(arg0_78.agoraSaveBtn, false)
	setActive(arg0_78.agoraSaveCdBtn, true)

	arg0_78.saveCdTimer = Timer.New(function()
		local var0_79 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg1_78 - var0_79 <= 0 then
			arg0_78:RemoveSaveCdTimer()
			arg0_78:FlushSaveBtn()
		else
			arg0_78.agoraSaveCdTxt.text = pg.TimeMgr.GetInstance():DescCDTimeForMinute(arg1_78 - var0_79)
		end
	end, 1, -1)

	arg0_78.saveCdTimer:Start()
	arg0_78.saveCdTimer.func()
end

function var0_0.RemoveSaveCdTimer(arg0_80)
	if arg0_80.saveCdTimer then
		arg0_80.saveCdTimer:Stop()

		arg0_80.saveCdTimer = nil
	end
end

function var0_0.OnDestroy(arg0_81)
	if arg0_81.dftAniEvent then
		arg0_81.dftAniEvent:SetEndEvent(nil)
	end

	arg0_81:RemoveSaveCdTimer()

	if arg0_81.sortPage then
		arg0_81.sortPage:Destroy()

		arg0_81.sortPage = nil
	end

	if arg0_81.descPage then
		arg0_81.descPage:Destroy()

		arg0_81.descPage = nil
	end

	if arg0_81.shapeSelectPanel then
		arg0_81.shapeSelectPanel:Destroy()

		arg0_81.shapeSelectPanel = nil
	end

	for iter0_81, iter1_81 in pairs(arg0_81.cards or {}) do
		iter1_81:Dispose()
	end

	arg0_81.cards = nil

	for iter2_81, iter3_81 in pairs(arg0_81.themeCards or {}) do
		iter3_81:Dispose()
	end

	arg0_81.themeCards = nil
end

return var0_0
