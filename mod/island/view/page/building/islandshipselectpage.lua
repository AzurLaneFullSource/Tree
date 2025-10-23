local var0_0 = class("IslandShipSelectPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipSelectUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("top/back")
	arg0_2.title = arg0_2._tf:Find("top/title/Text")

	setText(arg0_2.title, i18n("island_select_ship"))

	arg0_2.frameTF = arg0_2._tf:Find("frame")
	arg0_2.shipRectCom = arg0_2.frameTF:Find("ships"):GetComponent("LScrollRect")

	setText(arg0_2.frameTF:Find("selected/Text"), i18n("island_select_ship_label_1"))

	arg0_2.selectedTextCom = arg0_2.frameTF:Find("selected/num"):GetComponent("Text")
	arg0_2.benefitsTF = arg0_2._tf:Find("benefits")
	arg0_2.benefitTipBtn = arg0_2.benefitsTF:Find("tip/help")

	setText(arg0_2.benefitsTF:Find("tip/Text"), i18n("island_select_ship_overview"))

	arg0_2.mainAttrBar = arg0_2.benefitsTF:Find("main/slider/bar")

	setText(arg0_2.benefitsTF:Find("main/Text"), IslandShipAttr.ATTRS_CH[IslandShipAttr.MANAGE_KEY])

	arg0_2.subAttrUIList = UIItemList.New(arg0_2.benefitsTF:Find("subs"), arg0_2.benefitsTF:Find("subs/tpl"))
	arg0_2.infoEmptyTF = arg0_2._tf:Find("info/empty")

	setText(arg0_2.infoEmptyTF:Find("Image/Text"), i18n("island_select_ship"))

	arg0_2.infoEmptyTitleTF = arg0_2.infoEmptyTF:Find("name")
	arg0_2.infoPanel = arg0_2._tf:Find("info/content")
	arg0_2.nameTF = arg0_2.infoPanel:Find("name")
	arg0_2.levelTF = arg0_2.infoPanel:Find("name/level")
	arg0_2.attrUIList = UIItemList.New(arg0_2.infoPanel:Find("attrs"), arg0_2.infoPanel:Find("attrs/tpl"))
	arg0_2.skillTF = arg0_2.infoPanel:Find("skill")
	arg0_2.energyTFInfo = arg0_2.infoPanel:Find("selectShipEnergyInfo")
	arg0_2.energyTF = arg0_2.energyTFInfo:Find("energy")
	arg0_2.statusTF = arg0_2.infoPanel:Find("status")
	arg0_2.sureBtn = arg0_2._tf:Find("sure")

	setText(arg0_2.sureBtn:Find("Text"), i18n("island_shipselect_confirm"))

	arg0_2.indexBtn = arg0_2._tf:Find("frame/filter_panel/IndexIco")
	arg0_2.orderBtn = arg0_2._tf:Find("frame/filter_panel/index")
	arg0_2.orderIco = arg0_2._tf:Find("frame/filter_panel/index/content/icon/icon")
	arg0_2.orderTxt = arg0_2._tf:Find("frame/filter_panel/index/content/Text"):GetComponent(typeof(Text))
	arg0_2.shipIconTF = arg0_2.energyTFInfo:Find("icon_mask/icon")
	arg0_2.energyTimeTextTf = arg0_2.energyTFInfo:Find("time_Text")
	arg0_2.recoveryTimeTips = arg0_2.infoPanel:Find("selectShipEnergyInfo/recoveryTimeTips")
	arg0_2.skill = arg0_2.infoPanel:Find("skill")
	arg0_2.skillEmp = arg0_2.infoPanel:Find("skillEmp")
	arg0_2.skillEmpDes = arg0_2.skillEmp:Find("Text")
	arg0_2.skillInuse = arg0_2.skill:Find("skill_tab_bg/iconBright")
	arg0_2.skillUnuse = arg0_2.skill:Find("skill_tab_bg/iconDark")
	arg0_2.skillName = arg0_2.skill:Find("name"):GetComponent(typeof(Text))
	arg0_2.skillDes = arg0_2.skill:Find("desc/Text"):GetComponent(typeof(Text))
	arg0_2.shipContent = arg0_2.frameTF:Find("ships")
	arg0_2.shipEmpty = arg0_2.frameTF:Find("empShip")

	setText(arg0_2.shipEmpty:Find("Text"), i18n("island_production_selected_tip2"))
	setText(arg0_2.recoveryTimeTips, i18n("island_ship_energy_recoverytips"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:Hide()
		existCall(arg0_3.cancelFunc)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.sureBtn, function()
		local var0_5 = getProxy(IslandProxy):GetIsland():GetFollowerAgency()
		local var1_5 = {}

		for iter0_5, iter1_5 in ipairs(arg0_3.selectedIds) do
			if var0_5:Following(iter1_5) then
				table.insert(var1_5, iter1_5)
			end
		end

		if #var1_5 > 0 then
			arg0_3:ShowMsgBox({
				type = IslandMsgBox.TYPE_COMMON,
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					for iter0_6, iter1_6 in ipairs(var1_5) do
						arg0_3:emit(IslandMediator.DEL_FOLLOWER, iter1_6)
					end

					arg0_3:Hide()
					existCall(arg0_3.confirmFunc, arg0_3.selectedIds)
				end,
				onNo = function()
					return
				end
			})

			return
		end

		arg0_3:Hide()
		existCall(arg0_3.confirmFunc, arg0_3.selectedIds)
	end, SFX_PANEL)
	onToggle(arg0_3, arg0_3.indexBtn, function(arg0_8)
		if arg0_8 then
			arg0_3:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_9)
					arg0_3:OnFilter(arg0_9)
				end,
				defaultIndex = arg0_3.sortData
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.orderBtn, function()
		arg0_3.selectAsc = not arg0_3.selectAsc

		arg0_3:UpdateSortBtn()
		arg0_3:FlushShips()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.benefitTipBtn, function()
		arg0_3:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_manage_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
	arg0_3.subAttrUIList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventInit then
			local var0_13 = IslandShipAttr.ATTRS[arg1_13 + 1]

			arg2_13.name = var0_13

			setText(arg2_13:Find("Text"), IslandShipAttr.ToChinese(var0_13))
		elseif arg0_13 == UIItemList.EventUpdate then
			setFillAmount(arg2_13:Find("slider/bar"), arg0_3:GetShipsAttrProgress(IslandShipAttr.ATTRS[arg1_13 + 1]))
		end
	end)

	function arg0_3.shipRectCom.onInitItem(arg0_14)
		arg0_3:OnInitShip(arg0_14)
	end

	function arg0_3.shipRectCom.onUpdateItem(arg0_15, arg1_15)
		arg0_3:OnUpdateShip(arg0_15, arg1_15)
	end

	arg0_3.cards = {}
	arg0_3.selectAsc = true
	arg0_3.sortData = {
		sortIndex = IslandShipIndexLayer.SortLevel,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_3:UpdateSortBtn()

	arg0_3.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFilter(arg0_16, arg1_16)
	arg0_16.sortData = arg1_16

	arg0_16:UpdateSortBtn()
	arg0_16:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_17)
	arg0_17.orderIco.localScale = arg0_17.selectAsc and Vector3(1, -1, 1) or Vector3(1, 1, 1)

	local var0_17, var1_17 = IslandShipIndexLayer.getSortFuncAndName(arg0_17.sortData.sortIndex, arg0_17.selectAsc)

	arg0_17.orderTxt.text = i18n(var1_17)
end

function var0_0.UpdateAttrs(arg0_18, arg1_18)
	local var0_18 = IslandShipAttr.ATTRS

	arg0_18.attrUIList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventUpdate then
			local var0_19 = arg1_19 + 1

			arg0_18:UpdateAttr(arg2_19, var0_18, var0_19, arg1_18)
		end
	end)
	arg0_18.attrUIList:align(#var0_18)
end

function var0_0.UpdateAttr(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20 = arg2_20[arg3_20]
	local var1_20 = arg4_20:GetAttr(var0_20)

	setText(arg1_20:Find("name"), IslandShipAttr.ToChinese(var0_20))
	setText(arg1_20:Find("value"), var1_20)

	local var2_20 = arg4_20:GetAttrGrade(var0_20)
	local var3_20 = IslandShipAttr.Grade2Img(var2_20)

	arg1_20:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_20[1])
	arg1_20:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_20[2])
end

function var0_0.OnShow(arg0_21, arg1_21)
	arg0_21:BlurPanel()

	arg0_21.selectNum = arg1_21.selectNum or 1
	arg0_21.selectedIds = arg1_21.selectedIds or {}
	arg0_21.attrType = arg1_21.attrType
	arg0_21.confirmFunc = arg1_21.confirmFunc
	arg0_21.cancelFunc = arg1_21.cancelFunc
	arg0_21.placeId = arg1_21.placeId
	arg0_21.showBenefits = arg1_21.showBenefits

	local var0_21 = arg1_21.emptyInfoTitle or ""

	setText(arg0_21.infoEmptyTitleTF, var0_21)

	arg0_21.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	local var1_21 = #arg0_21.selectedIds == 0 and arg0_21.selectNum == 1

	arg0_21:FlushShips(var1_21)
end

function var0_0.OnInitShip(arg0_22, arg1_22)
	local var0_22 = IslandSelectShipCard.New(arg1_22)

	arg0_22.cards[arg1_22] = var0_22
end

function var0_0.OnUpdateShip(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg0_23.cards[arg2_23]

	if not var0_23 then
		arg0_23:OnInitItem(arg2_23)

		var0_23 = arg0_23.cards[arg2_23]
	end

	local var1_23 = arg0_23.showShips[arg1_23 + 1]
	local var2_23 = arg0_23.characterAgency:GetShipById(var1_23)

	onButton(arg0_23, var0_23.go, function()
		if var2_23:GetState() ~= IslandShip.STATE_NORMAL then
			return
		end

		if arg0_23.showId == var0_23.id then
			arg0_23.showId = nil
		else
			arg0_23.showId = var0_23.id
		end

		if table.contains(arg0_23.selectedIds, var0_23.id) then
			table.removebyvalue(arg0_23.selectedIds, var0_23.id)
		elseif arg0_23.selectNum == 1 then
			arg0_23.selectedIds = {
				var0_23.id
			}
		else
			if #arg0_23.selectedIds >= arg0_23.selectNum then
				return
			end

			table.insert(arg0_23.selectedIds, var0_23.id)
		end

		for iter0_24, iter1_24 in pairs(arg0_23.cards) do
			iter1_24:UpdateSelected(arg0_23.selectedIds)
		end

		arg0_23:FlushInfo()
	end, SFX_PANEL)
	var0_23:Update(var1_23, arg0_23.attrType, arg0_23.placeId, arg0_23.selectedIds)
end

function var0_0.FlushShips(arg0_25, arg1_25)
	arg0_25.showShips = arg0_25:GetShips()

	if #arg0_25.showShips ~= 0 and arg1_25 then
		local var0_25 = arg0_25:GetFristSelectableShipId()

		if var0_25 then
			arg0_25.showId = var0_25

			table.insert(arg0_25.selectedIds, var0_25)
		end
	end

	arg0_25.showId = arg0_25.selectedIds[1]

	setActive(arg0_25.shipContent, #arg0_25.showShips ~= 0)
	setActive(arg0_25.shipEmpty, #arg0_25.showShips == 0)
	arg0_25.shipRectCom:SetTotalCount(#arg0_25.showShips)
	arg0_25:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.showShips) do
		if arg0_26.characterAgency:GetShipById(iter1_26):GetState() == IslandShip.STATE_NORMAL then
			return iter1_26
		end
	end

	return nil
end

function var0_0.UpdateTimer(arg0_27, arg1_27)
	local var0_27 = arg1_27 - arg0_27.timeMgr:GetServerTime()

	setText(arg0_27.energyTimeTextTf, arg0_27.timeMgr:DescCDTime(var0_27))
end

function var0_0.StopTimer(arg0_28)
	if arg0_28.energyTimer ~= nil then
		arg0_28.energyTimer:Stop()

		arg0_28.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_29)
	arg0_29.selectedTextCom.text = #arg0_29.selectedIds .. "/" .. arg0_29.selectNum

	arg0_29:FlushBenefits()
	setActive(arg0_29.sureBtn, arg0_29.showId)
	setActive(arg0_29.infoPanel, arg0_29.showId)
	setActive(arg0_29.infoEmptyTF, not arg0_29.showId)

	if not arg0_29.showId then
		return
	end

	local var0_29 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_29.showId)

	setText(arg0_29.nameTF, var0_29:GetName())
	setText(arg0_29.levelTF, string.format("-Lv.%d", var0_29:GetLevel()))
	arg0_29:UpdateAttrs(var0_29)

	local var1_29 = IslandShip.StaticGetPrefab(var0_29.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_29, "", arg0_29.shipIconTF)

	local var2_29 = var0_29:GetCurrentEnergy()
	local var3_29 = var0_29:GetMaxEnergy()

	setText(arg0_29.energyTF:Find("text"), var2_29 .. "/" .. var3_29)
	setSlider(arg0_29.energyTF:Find("energy_bar"), 0, 1, var2_29 / var3_29)

	if var2_29 ~= var3_29 then
		setActive(arg0_29.recoveryTimeTips, true)
		setActive(arg0_29.energyTimeTextTf, true)

		local var4_29 = var0_29:GetEnergyMaxTime()

		arg0_29:StopTimer()
		arg0_29:UpdateTimer(var4_29)

		arg0_29.energyTimer = Timer.New(function()
			arg0_29:UpdateTimer(var4_29)
		end, 1, -1)

		arg0_29.energyTimer:Start()
	else
		arg0_29:StopTimer()
		setActive(arg0_29.recoveryTimeTips, false)
		setActive(arg0_29.energyTimeTextTf, false)
	end

	local var5_29 = var0_29:GetSkill()
	local var6_29 = var5_29:IsUnlock()

	setActive(arg0_29.skill, var6_29)
	setActive(arg0_29.skillEmp, not var6_29)
	setText(arg0_29.skillEmpDes, i18n("island_need_star", var0_29:GetSkillUnlockLevel()))

	local var7_29 = var5_29:IsEffectiveInPlace(arg0_29.placeId)

	setActive(arg0_29.skillInuse, var7_29)
	setActive(arg0_29.skillUnuse, not var7_29)

	arg0_29.skillName.text = string.format("%s - %s", var5_29:GetName(), "[Lv." .. var5_29:GetLevel() .. "]")
	arg0_29.skillDes.text = var5_29:GetEffectDesc()
end

function var0_0.FlushBenefits(arg0_31)
	setActive(arg0_31.benefitsTF, arg0_31.showBenefits)

	if arg0_31.showBenefits then
		setFillAmount(arg0_31.mainAttrBar, arg0_31:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_31.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_32, arg1_32)
	local var0_32 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_32 = var0_32 * arg0_32.selectNum
	local var2_32 = 0

	for iter0_32, iter1_32 in ipairs(arg0_32.selectedIds) do
		var2_32 = var2_32 + (var0_32 - arg0_32.characterAgency:GetShipById(iter1_32):GetAttrGrade(arg1_32) + 1)
	end

	return var2_32 / var1_32
end

function var0_0.ToVShip(arg0_33, arg1_33)
	if not arg0_33.vship then
		arg0_33.vship = {}

		function arg0_33.vship.getNation()
			return arg0_33.vship.config.nationality
		end

		function arg0_33.vship.getShipType()
			return arg0_33.vship.config.type
		end

		function arg0_33.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_33.vship.config.type)
		end

		function arg0_33.vship.getRarity()
			return arg0_33.vship.config.rarity
		end
	end

	arg0_33.vship.config = arg1_33

	return arg0_33.vship
end

local function var1_0(arg0_38, arg1_38)
	if not arg1_38 or arg1_38 == "" then
		return true
	end

	local var0_38 = string.lower(string.gsub(arg1_38, "%.", "%%."))
	local var1_38 = IslandShip.StaticGetName(arg0_38)

	return string.find(string.lower(var1_38), var0_38)
end

local function var2_0(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg1_39
	local var1_39 = ShipGroup.getDefaultShipConfig(var0_39)
	local var2_39 = arg0_39:ToVShip(var1_39)
	local var3_39 = arg0_39.characterAgency:GetShipById(arg1_39)

	if ShipIndexConst.filterByCamp(var2_39, arg2_39.campIndex) and ShipIndexConst.filterByRarity(var2_39, arg2_39.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_39, arg2_39.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_40)
	local var0_40 = {}
	local var1_40 = arg0_40.characterAgency:GetShipsContainNpc()

	for iter0_40, iter1_40 in ipairs(var1_40) do
		if var1_0(iter1_40.id, arg0_40.searchKey) and var2_0(arg0_40, iter1_40.id, arg0_40.sortData) then
			table.insert(var0_40, iter1_40.id)
		end
	end

	local var2_40 = IslandShipIndexLayer.getSortFuncAndName(arg0_40.sortData.sortIndex, arg0_40.selectAsc)

	table.sort(var0_40, CompareFuncs(var2_40))

	return var0_40
end

function var0_0.OnDestroy(arg0_41)
	ClearLScrollrect(arg0_41.shipRectCom)
	arg0_41:StopTimer()
	arg0_41:OnHide()
end

function var0_0.OnHide(arg0_42)
	arg0_42:UnBlurPanel()
end

function var0_0.OnDisable(arg0_43)
	arg0_43:OnHide()
end

return var0_0
