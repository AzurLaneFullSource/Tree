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
	arg0_2.addStutasTF = arg0_2._tf:Find("addStutas")
	arg0_2.addStutasNum = arg0_2._tf:Find("addStutas/num")
	arg0_2.addStutasBtn = arg0_2._tf:Find("addStutas/num/tipbtn")
	arg0_2.addStutasInfoPanel = arg0_2._tf:Find("addinfo_panel")
	arg0_2.buffInfoUIList = UIItemList.New(arg0_2.addStutasInfoPanel:Find("effects"), arg0_2.addStutasInfoPanel:Find("effects/tpl"))

	setText(arg0_2.addStutasInfoPanel:Find("Text"), i18n("island_production_speed_tip2"))

	arg0_2.buffInfoEmptyTF = arg0_2.addStutasInfoPanel:Find("empty")

	setText(arg0_2.buffInfoEmptyTF:Find("Text"), i18n("island_manage_no_addition"))
	arg0_2.buffInfoUIList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.buffInfos[arg1_3 + 1]

			setText(arg2_3:Find("bg/name"), var0_3.name)
			setText(arg2_3:Find("bg/effect"), var0_3.effect)
		end
	end)
	setText(arg0_2.shipEmpty:Find("Text"), i18n("island_production_selected_tip2"))
	setText(arg0_2.recoveryTimeTips, i18n("island_ship_energy_recoverytips"))
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4.backBtn, function()
		arg0_4:Hide()
		existCall(arg0_4.cancelFunc)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.addStutasBtn, function()
		if isActive(arg0_4.addStutasInfoPanel) then
			setActive(arg0_4.addStutasInfoPanel, false)
		else
			setActive(arg0_4.addStutasInfoPanel, true)
			arg0_4.buffInfoUIList:align(#arg0_4.buffInfos)
			setActive(arg0_4.buffInfoEmptyTF, #arg0_4.buffInfos == 0)
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.sureBtn, function()
		local var0_7 = getProxy(IslandProxy):GetIsland():GetFollowerAgency()
		local var1_7 = {}

		for iter0_7, iter1_7 in ipairs(arg0_4.selectedIds) do
			if var0_7:Following(iter1_7) then
				table.insert(var1_7, iter1_7)
			end
		end

		if #var1_7 > 0 then
			arg0_4:ShowMsgBox({
				type = IslandMsgBox.TYPE_COMMON,
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					for iter0_8, iter1_8 in ipairs(var1_7) do
						arg0_4:emit(IslandMediator.DEL_FOLLOWER, iter1_8)
					end

					arg0_4:Hide()
					existCall(arg0_4.confirmFunc, arg0_4.selectedIds)
				end,
				onNo = function()
					return
				end
			})

			return
		end

		arg0_4:Hide()
		existCall(arg0_4.confirmFunc, arg0_4.selectedIds)
	end, SFX_PANEL)
	onToggle(arg0_4, arg0_4.indexBtn, function(arg0_10)
		if arg0_10 then
			arg0_4:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_11)
					arg0_4:OnFilter(arg0_11)
				end,
				defaultIndex = arg0_4.sortData,
				needWorkSpeed = arg0_4.needWorkSpeed
			})
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.orderBtn, function()
		arg0_4.selectAsc = not arg0_4.selectAsc

		arg0_4:UpdateSortBtn()
		arg0_4:FlushShips()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.benefitTipBtn, function()
		arg0_4:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_manage_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
	arg0_4.subAttrUIList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventInit then
			local var0_15 = IslandShipAttr.ATTRS[arg1_15 + 1]

			arg2_15.name = var0_15

			setText(arg2_15:Find("Text"), IslandShipAttr.ToChinese(var0_15))
		elseif arg0_15 == UIItemList.EventUpdate then
			setFillAmount(arg2_15:Find("slider/bar"), arg0_4:GetShipsAttrProgress(IslandShipAttr.ATTRS[arg1_15 + 1]))
		end
	end)

	function arg0_4.shipRectCom.onInitItem(arg0_16)
		arg0_4:OnInitShip(arg0_16)
	end

	function arg0_4.shipRectCom.onUpdateItem(arg0_17, arg1_17)
		arg0_4:OnUpdateShip(arg0_17, arg1_17)
	end

	arg0_4.cards = {}
	arg0_4.selectAsc = true
	arg0_4.sortData = {
		sortIndex = IslandShipIndexLayer.SortLevel,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_4:UpdateSortBtn()

	arg0_4.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFilter(arg0_18, arg1_18)
	arg0_18.sortData = arg1_18

	arg0_18:UpdateSortBtn()
	arg0_18:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_19)
	arg0_19.orderIco.localScale = arg0_19.selectAsc and Vector3(1, 1, 1) or Vector3(1, -1, 1)

	local var0_19, var1_19 = IslandShipIndexLayer.getSortFuncAndName(arg0_19.sortData.sortIndex, arg0_19.selectAsc)

	arg0_19.orderTxt.text = i18n(var1_19)
end

function var0_0.UpdateAttrs(arg0_20, arg1_20)
	local var0_20 = IslandShipAttr.ATTRS

	arg0_20.attrUIList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventUpdate then
			local var0_21 = arg1_21 + 1

			arg0_20:UpdateAttr(arg2_21, var0_20, var0_21, arg1_20)
		end
	end)
	arg0_20.attrUIList:align(#var0_20)
end

function var0_0.UpdateAttr(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	local var0_22 = arg2_22[arg3_22]
	local var1_22 = arg4_22:GetAttr(var0_22)

	setText(arg1_22:Find("name"), IslandShipAttr.ToChinese(var0_22))
	setText(arg1_22:Find("value"), var1_22)

	local var2_22 = arg4_22:GetAttrGrade(var0_22)
	local var3_22 = IslandShipAttr.Grade2Img(var2_22)

	arg1_22:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_22[1])
	arg1_22:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_22[2])

	setActive(arg1_22:Find("vx_tpl"), arg0_22.attrType == arg3_22)
end

function var0_0.OnShow(arg0_23, arg1_23)
	arg0_23:BlurPanel()

	arg0_23.selectNum = arg1_23.selectNum or 1
	arg0_23.selectedIds = arg1_23.selectedIds or {}
	arg0_23.attrType = arg1_23.attrType
	arg0_23.confirmFunc = arg1_23.confirmFunc
	arg0_23.cancelFunc = arg1_23.cancelFunc
	arg0_23.placeId = arg1_23.placeId
	arg0_23.showBenefits = arg1_23.showBenefits
	arg0_23.needWorkSpeed = arg1_23.needWorkSpeed or false

	local var0_23 = arg1_23.emptyInfoTitle or ""

	setText(arg0_23.infoEmptyTitleTF, var0_23)

	arg0_23.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	if arg0_23.needWorkSpeed then
		arg0_23.sortData.sortIndex = IslandShipIndexLayer.SortWorkSpeed
	else
		arg0_23.sortData.sortIndex = IslandShipIndexLayer.SortLevel
	end

	arg0_23:UpdateSortBtn()

	local var1_23 = #arg0_23.selectedIds == 0 and arg0_23.selectNum == 1

	arg0_23:FlushShips(var1_23)
end

function var0_0.OnInitShip(arg0_24, arg1_24)
	local var0_24 = IslandSelectShipCard.New(arg1_24)

	arg0_24.cards[arg1_24] = var0_24
end

function var0_0.OnUpdateShip(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.cards[arg2_25]

	if not var0_25 then
		arg0_25:OnInitItem(arg2_25)

		var0_25 = arg0_25.cards[arg2_25]
	end

	local var1_25 = arg0_25.showShips[arg1_25 + 1]
	local var2_25 = arg0_25.characterAgency:GetShipById(var1_25)

	onButton(arg0_25, var0_25.go, function()
		if var2_25:GetState() ~= IslandShip.STATE_NORMAL then
			return
		end

		if arg0_25.showId == var0_25.id then
			arg0_25.showId = nil
		else
			arg0_25.showId = var0_25.id
		end

		if table.contains(arg0_25.selectedIds, var0_25.id) then
			table.removebyvalue(arg0_25.selectedIds, var0_25.id)
		elseif arg0_25.selectNum == 1 then
			arg0_25.selectedIds = {
				var0_25.id
			}
		else
			if #arg0_25.selectedIds >= arg0_25.selectNum then
				return
			end

			table.insert(arg0_25.selectedIds, var0_25.id)
		end

		for iter0_26, iter1_26 in pairs(arg0_25.cards) do
			iter1_26:UpdateSelected(arg0_25.selectedIds)
		end

		arg0_25:FlushInfo()
	end, SFX_PANEL)
	var0_25:Update(var1_25, arg0_25.attrType, arg0_25.placeId, arg0_25.selectedIds)
end

function var0_0.FlushShips(arg0_27, arg1_27)
	arg0_27.showShips = arg0_27:GetShips()

	if #arg0_27.showShips ~= 0 and arg1_27 then
		local var0_27 = arg0_27:GetFristSelectableShipId()

		if var0_27 then
			arg0_27.showId = var0_27

			table.insert(arg0_27.selectedIds, var0_27)
		end
	end

	arg0_27.showId = arg0_27.selectedIds[1]

	setActive(arg0_27.shipContent, #arg0_27.showShips ~= 0)
	setActive(arg0_27.shipEmpty, #arg0_27.showShips == 0)
	arg0_27.shipRectCom:SetTotalCount(#arg0_27.showShips)
	arg0_27:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_28)
	for iter0_28, iter1_28 in ipairs(arg0_28.showShips) do
		if arg0_28.characterAgency:GetShipById(iter1_28):GetState() == IslandShip.STATE_NORMAL then
			return iter1_28
		end
	end

	return nilGetShipsAttrProgress
end

function var0_0.UpdateTimer(arg0_29, arg1_29)
	local var0_29 = arg1_29 - arg0_29.timeMgr:GetServerTime()

	setText(arg0_29.energyTimeTextTf, arg0_29.timeMgr:DescCDTime(var0_29))
end

function var0_0.StopTimer(arg0_30)
	if arg0_30.energyTimer ~= nil then
		arg0_30.energyTimer:Stop()

		arg0_30.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_31)
	arg0_31.selectedTextCom.text = #arg0_31.selectedIds .. "/" .. arg0_31.selectNum

	arg0_31:FlushBenefits()
	setActive(arg0_31.sureBtn, arg0_31.showId)
	setActive(arg0_31.infoPanel, arg0_31.showId)
	setActive(arg0_31.infoEmptyTF, not arg0_31.showId)
	arg0_31:FlushAddPercent()

	if not arg0_31.showId then
		return
	end

	local var0_31 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_31.showId)

	setText(arg0_31.nameTF, var0_31:GetName())
	setText(arg0_31.levelTF, string.format("-Lv.%d", var0_31:GetLevel()))
	arg0_31:UpdateAttrs(var0_31)

	local var1_31 = IslandShip.StaticGetPrefab(var0_31.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_31, "", arg0_31.shipIconTF)

	local var2_31 = var0_31:GetCurrentEnergy()
	local var3_31 = var0_31:GetMaxEnergy()

	setText(arg0_31.energyTF:Find("text"), var2_31 .. "/" .. var3_31)
	setSlider(arg0_31.energyTF:Find("energy_bar"), 0, 1, var2_31 / var3_31)

	if var2_31 ~= var3_31 then
		setActive(arg0_31.recoveryTimeTips, true)
		setActive(arg0_31.energyTimeTextTf, true)

		local var4_31 = var0_31:GetEnergyMaxTime()

		arg0_31:StopTimer()
		arg0_31:UpdateTimer(var4_31)

		arg0_31.energyTimer = Timer.New(function()
			arg0_31:UpdateTimer(var4_31)
		end, 1, -1)

		arg0_31.energyTimer:Start()
	else
		arg0_31:StopTimer()
		setActive(arg0_31.recoveryTimeTips, false)
		setActive(arg0_31.energyTimeTextTf, false)
	end

	local var5_31 = var0_31:GetSkill()
	local var6_31 = var5_31:IsUnlock()

	setActive(arg0_31.skill, var6_31)
	setActive(arg0_31.skillEmp, not var6_31)
	setText(arg0_31.skillEmpDes, i18n("island_need_star", var0_31:GetSkillUnlockLevel()))

	local var7_31 = var5_31:IsEffectiveInPlace(arg0_31.placeId)

	setActive(arg0_31.skillInuse, var7_31)
	setActive(arg0_31.skillUnuse, not var7_31)

	arg0_31.skillName.text = string.format("%s - %s", var5_31:GetName(), "[Lv." .. var5_31:GetLevel() .. "]")
	arg0_31.skillDes.text = var5_31:GetEffectDesc()

	arg0_31:FlushAddPercent()
end

function var0_0.FlushAddPercent(arg0_33)
	if not arg0_33.showId or not arg0_33.needWorkSpeed then
		setActive(arg0_33.addStutasTF, false)
		setActive(arg0_33.addStutasInfoPanel, false)

		return
	end

	local var0_33, var1_33, var2_33 = IslandProductTimeHelper.GetAllAddPercent(arg0_33.showId, arg0_33.placeId, arg0_33.attrType)
	local var3_33 = var0_33 + var1_33 + var2_33

	setActive(arg0_33.addStutasTF, true)
	setText(arg0_33.addStutasNum, i18n("island_production_speed_tip1", var3_33))

	arg0_33.buffInfos = {}

	local var4_33 = IslandProductTimeHelper.GetAttributeAddPercent(arg0_33.showId, arg0_33.attrType)

	if var0_33 > 0 then
		local var5_33 = IslandShipAttr.GetAtrrName(arg0_33.attrType)

		table.insert(arg0_33.buffInfos, {
			name = i18n("island_production_speed_addition1", IslandShipAttr.ToChinese(var5_33)),
			effect = "+" .. var0_33 .. "%"
		})
	end

	if var1_33 > 0 then
		table.insert(arg0_33.buffInfos, {
			name = i18n("island_production_speed_addition2"),
			effect = "+" .. var1_33 .. "%"
		})
	end

	if var2_33 > 0 then
		local var6_33 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_33.showId):GetSkill():GetName()

		table.insert(arg0_33.buffInfos, {
			name = var6_33,
			effect = "+" .. var2_33 .. "%"
		})
	end

	arg0_33.buffInfoUIList:align(#arg0_33.buffInfos)
	setActive(arg0_33.buffInfoEmptyTF, #arg0_33.buffInfos == 0)
end

function var0_0.FlushBenefits(arg0_34)
	setActive(arg0_34.benefitsTF, arg0_34.showBenefits)

	if arg0_34.showBenefits then
		setFillAmount(arg0_34.mainAttrBar, arg0_34:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_34.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_35, arg1_35)
	local var0_35 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_35 = var0_35 * arg0_35.selectNum
	local var2_35 = 0

	for iter0_35, iter1_35 in ipairs(arg0_35.selectedIds) do
		var2_35 = var2_35 + (var0_35 - arg0_35.characterAgency:GetShipById(iter1_35):GetAttrGrade(arg1_35) + 1)
	end

	return var2_35 / var1_35
end

function var0_0.ToVShip(arg0_36, arg1_36)
	if not arg0_36.vship then
		arg0_36.vship = {}

		function arg0_36.vship.getNation()
			return arg0_36.vship.config.nationality
		end

		function arg0_36.vship.getShipType()
			return arg0_36.vship.config.type
		end

		function arg0_36.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_36.vship.config.type)
		end

		function arg0_36.vship.getRarity()
			return arg0_36.vship.config.rarity
		end
	end

	arg0_36.vship.config = arg1_36

	return arg0_36.vship
end

local function var1_0(arg0_41, arg1_41)
	if not arg1_41 or arg1_41 == "" then
		return true
	end

	local var0_41 = string.lower(string.gsub(arg1_41, "%.", "%%."))
	local var1_41 = IslandShip.StaticGetName(arg0_41)

	return string.find(string.lower(var1_41), var0_41)
end

local function var2_0(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg1_42
	local var1_42 = ShipGroup.getDefaultShipConfig(var0_42)
	local var2_42 = arg0_42:ToVShip(var1_42)
	local var3_42 = arg0_42.characterAgency:GetShipById(arg1_42)

	if ShipIndexConst.filterByCamp(var2_42, arg2_42.campIndex) and ShipIndexConst.filterByRarity(var2_42, arg2_42.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_42, arg2_42.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_43)
	local var0_43 = {}
	local var1_43 = {}
	local var2_43 = arg0_43.characterAgency:GetShipsContainNpc()

	for iter0_43, iter1_43 in ipairs(var2_43) do
		if var1_0(iter1_43.id, arg0_43.searchKey) and var2_0(arg0_43, iter1_43.id, arg0_43.sortData) then
			if arg0_43.needWorkSpeed then
				local var3_43 = setmetatable({
					GetWorkSpeed = function()
						local var0_44, var1_44, var2_44 = IslandProductTimeHelper.GetAllAddPercent(iter1_43.id, arg0_43.placeId, arg0_43.attrType)

						return var0_44 + var1_44 + var2_44
					end
				}, {
					__index = iter1_43
				})

				table.insert(var1_43, var3_43)
			else
				table.insert(var1_43, iter1_43)
			end
		end
	end

	local var4_43 = IslandShipIndexLayer.getSortFuncAndName(arg0_43.sortData.sortIndex, arg0_43.selectAsc)

	table.sort(var1_43, CompareFuncs(var4_43))

	for iter2_43, iter3_43 in ipairs(var1_43) do
		table.insert(var0_43, iter3_43.id)
	end

	return var0_43
end

function var0_0.OnDestroy(arg0_45)
	ClearLScrollrect(arg0_45.shipRectCom)
	arg0_45:StopTimer()
	arg0_45:OnHide()
end

function var0_0.OnHide(arg0_46)
	if isActive(arg0_46.addStutasInfoPanel) then
		setActive(arg0_46.addStutasInfoPanel, false)
	end

	arg0_46:UnBlurPanel()
end

function var0_0.OnDisable(arg0_47)
	arg0_47:OnHide()
end

return var0_0
