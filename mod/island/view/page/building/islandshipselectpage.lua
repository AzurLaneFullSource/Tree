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
	arg0_2.energyStutasTF = arg0_2._tf:Find("energyStutas")
	arg0_2.energyStutasTFNum = arg0_2._tf:Find("energyStutas/num")
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
						arg0_4:emitCore(ISLAND_EVT.WILL_DEL_FOLLOWER, iter1_8)
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

	local var2_22 = IslandProductTimeHelper.GetAttributeAddPercentByAttribute(arg4_22.id, arg3_22)
	local var3_22
	local var4_22 = var2_22 > 0 and "#00B91E" or var2_22 < 0 and "#FF6767" or "#393A3C"

	setTextColor(arg1_22:Find("value"), Color.NewHex(var4_22))

	local var5_22 = var2_22 ~= 0 and math.floor(var1_22 * (1 + 0.01 * var2_22)) or var1_22

	setText(arg1_22:Find("value"), var5_22)

	if var2_22 ~= 0 then
		local var6_22 = arg4_22:GetDisplayStatus()
		local var7_22 = _.select(var6_22, function(arg0_23)
			return arg0_23:GetBuffType() == IslandBuffType.SHIP_ATTR
		end)

		onButton(arg0_22, arg1_22, function()
			arg0_22:ShowMsgBox({
				hideNo = true,
				type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
				title = i18n("island_word_ship_buff_desc"),
				statusList = var7_22
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg1_22)
	end

	local var8_22 = arg4_22:GetAttrGradeByValue(var5_22)
	local var9_22 = IslandShipAttr.Grade2Img(var8_22)

	arg1_22:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var9_22[1])
	arg1_22:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var9_22[2])

	setActive(arg1_22:Find("vx_tpl"), arg0_22.attrType == arg3_22)
end

function var0_0.OnShow(arg0_25, arg1_25)
	arg0_25:BlurPanel()

	arg0_25.selectNum = arg1_25.selectNum or 1
	arg0_25.selectedIds = arg1_25.selectedIds or {}
	arg0_25.attrType = arg1_25.attrType
	arg0_25.confirmFunc = arg1_25.confirmFunc
	arg0_25.cancelFunc = arg1_25.cancelFunc
	arg0_25.placeId = arg1_25.placeId
	arg0_25.showBenefits = arg1_25.showBenefits
	arg0_25.needWorkSpeed = arg1_25.needWorkSpeed or false
	arg0_25.autoCollectionSelectShip = arg1_25.autoCollectionSelectShip

	local var0_25 = arg1_25.emptyInfoTitle or ""

	setText(arg0_25.infoEmptyTitleTF, var0_25)

	arg0_25.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	if arg0_25.needWorkSpeed then
		arg0_25.sortData.sortIndex = IslandShipIndexLayer.SortWorkSpeed
	else
		arg0_25.sortData.sortIndex = IslandShipIndexLayer.SortLevel
	end

	arg0_25:UpdateSortBtn()

	local var1_25 = #arg0_25.selectedIds == 0 and arg0_25.selectNum == 1

	arg0_25:FlushShips(var1_25)
end

function var0_0.CheckHasSelected(arg0_26, arg1_26)
	if not arg0_26.autoCollectionSelectShip then
		return false
	end

	local var0_26 = false

	for iter0_26, iter1_26 in pairs(arg0_26.autoCollectionSelectShip) do
		if arg1_26 == iter1_26 then
			var0_26 = true
		end
	end

	return var0_26
end

function var0_0.OnInitShip(arg0_27, arg1_27)
	local var0_27 = IslandSelectShipCard.New(arg1_27)

	arg0_27.cards[arg1_27] = var0_27
end

function var0_0.OnUpdateShip(arg0_28, arg1_28, arg2_28)
	local var0_28 = arg0_28.cards[arg2_28]

	if not var0_28 then
		arg0_28:OnInitItem(arg2_28)

		var0_28 = arg0_28.cards[arg2_28]
	end

	local var1_28 = arg0_28.showShips[arg1_28 + 1]
	local var2_28 = arg0_28.characterAgency:GetShipById(var1_28)

	onButton(arg0_28, var0_28.go, function()
		if not var2_28:IsDelegable() or arg0_28:CheckHasSelected(var1_28) then
			return
		end

		if arg0_28.showId == var0_28.id then
			arg0_28.showId = nil
		else
			arg0_28.showId = var0_28.id
		end

		if table.contains(arg0_28.selectedIds, var0_28.id) then
			table.removebyvalue(arg0_28.selectedIds, var0_28.id)
		elseif arg0_28.selectNum == 1 then
			arg0_28.selectedIds = {
				var0_28.id
			}
		else
			if #arg0_28.selectedIds >= arg0_28.selectNum then
				return
			end

			table.insert(arg0_28.selectedIds, var0_28.id)
		end

		for iter0_29, iter1_29 in pairs(arg0_28.cards) do
			iter1_29:UpdateSelected(arg0_28.selectedIds)
		end

		arg0_28:FlushInfo()
	end, SFX_PANEL)
	var0_28:Update(var1_28, arg0_28.attrType, arg0_28.placeId, arg0_28.selectedIds, arg0_28.autoCollectionSelectShip)
end

function var0_0.FlushShips(arg0_30, arg1_30)
	arg0_30.showShips = arg0_30:GetShips()

	if #arg0_30.showShips ~= 0 and arg1_30 then
		local var0_30 = arg0_30:GetFristSelectableShipId()

		if var0_30 then
			arg0_30.showId = var0_30

			table.insert(arg0_30.selectedIds, var0_30)
		end
	end

	arg0_30.showId = arg0_30.selectedIds[1]

	setActive(arg0_30.shipContent, #arg0_30.showShips ~= 0)
	setActive(arg0_30.shipEmpty, #arg0_30.showShips == 0)
	arg0_30.shipRectCom:SetTotalCount(#arg0_30.showShips)
	arg0_30:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_31)
	for iter0_31, iter1_31 in ipairs(arg0_31.showShips) do
		if arg0_31.characterAgency:GetShipById(iter1_31):GetState() == IslandShip.STATE_NORMAL and not arg0_31:CheckHasSelected(iter1_31) then
			return iter1_31
		end
	end

	return nilGetShipsAttrProgress
end

function var0_0.UpdateTimer(arg0_32, arg1_32)
	local var0_32 = arg1_32 - arg0_32.timeMgr:GetServerTime()

	setText(arg0_32.energyTimeTextTf, arg0_32.timeMgr:DescCDTime(var0_32))
end

function var0_0.StopTimer(arg0_33)
	if arg0_33.energyTimer ~= nil then
		arg0_33.energyTimer:Stop()

		arg0_33.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_34)
	arg0_34.selectedTextCom.text = #arg0_34.selectedIds .. "/" .. arg0_34.selectNum

	arg0_34:FlushBenefits()
	setActive(arg0_34.sureBtn, arg0_34.showId)
	setActive(arg0_34.infoPanel, arg0_34.showId)
	setActive(arg0_34.infoEmptyTF, not arg0_34.showId)
	arg0_34:FlushAddPercent()
	arg0_34:FlushEnergyPercent()

	if not arg0_34.showId then
		return
	end

	local var0_34 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_34.showId)

	setText(arg0_34.nameTF, var0_34:GetName())
	setText(arg0_34.levelTF, string.format("-Lv.%d", var0_34:GetLevel()))
	arg0_34:UpdateAttrs(var0_34)

	local var1_34 = IslandShip.StaticGetPrefab(var0_34.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_34, "", arg0_34.shipIconTF)

	local var2_34 = var0_34:GetCurrentEnergy()
	local var3_34 = var0_34:GetMaxEnergy()

	setText(arg0_34.energyTF:Find("text"), var2_34 .. "/" .. var3_34)
	setSlider(arg0_34.energyTF:Find("energy_bar"), 0, 1, var2_34 / var3_34)

	if var2_34 ~= var3_34 then
		setActive(arg0_34.recoveryTimeTips, true)
		setActive(arg0_34.energyTimeTextTf, true)

		local var4_34 = var0_34:GetEnergyMaxTime()

		arg0_34:StopTimer()
		arg0_34:UpdateTimer(var4_34)

		arg0_34.energyTimer = Timer.New(function()
			arg0_34:UpdateTimer(var4_34)
		end, 1, -1)

		arg0_34.energyTimer:Start()
	else
		arg0_34:StopTimer()
		setActive(arg0_34.recoveryTimeTips, false)
		setActive(arg0_34.energyTimeTextTf, false)
	end

	local var5_34 = var0_34:GetSkill()
	local var6_34 = var5_34:IsUnlock()

	setActive(arg0_34.skill, var6_34)
	setActive(arg0_34.skillEmp, not var6_34)
	setText(arg0_34.skillEmpDes, i18n("island_need_star", var0_34:GetSkillUnlockLevel()))

	local var7_34 = var5_34:IsEffectiveInPlace(arg0_34.placeId)

	setActive(arg0_34.skillInuse, var7_34)
	setActive(arg0_34.skillUnuse, not var7_34)

	arg0_34.skillName.text = string.format("%s - %s", var5_34:GetName(), "[Lv." .. var5_34:GetLevel() .. "]")
	arg0_34.skillDes.text = var5_34:GetEffectDesc()

	arg0_34:FlushAddPercent()
	arg0_34:FlushEnergyPercent()
end

function var0_0.FlushEnergyPercent(arg0_36)
	if not arg0_36.showId or not arg0_36.autoCollectionSelectShip then
		setActive(arg0_36.energyStutasTF, false)

		return
	end

	setActive(arg0_36.energyStutasTF, true)

	local var0_36 = IslandAutoCollectHelper.GetAttributeReducePercent(arg0_36.showId)
	local var1_36 = string.format("<color=#39bfff> -%d%%</color>", var0_36)
	local var2_36 = i18n("island_chara_gather_skill_effect") .. var1_36

	setText(arg0_36.energyStutasTFNum, var2_36)
end

function var0_0.FlushAddPercent(arg0_37)
	if not arg0_37.showId or not arg0_37.needWorkSpeed then
		setActive(arg0_37.addStutasTF, false)
		setActive(arg0_37.addStutasInfoPanel, false)

		return
	end

	local var0_37, var1_37, var2_37, var3_37 = IslandProductTimeHelper.GetAllAddPercent(arg0_37.showId, arg0_37.placeId, arg0_37.attrType)
	local var4_37 = var0_37 + var1_37 + var2_37 + var3_37

	setActive(arg0_37.addStutasTF, true)
	setText(arg0_37.addStutasNum, i18n("island_production_speed_tip1", var4_37))

	arg0_37.buffInfos = {}

	local var5_37 = IslandProductTimeHelper.GetAttributeAddPercent(arg0_37.showId, arg0_37.attrType)

	if var0_37 > 0 then
		local var6_37 = IslandShipAttr.GetAtrrName(arg0_37.attrType)

		table.insert(arg0_37.buffInfos, {
			name = i18n("island_production_speed_addition1", IslandShipAttr.ToChinese(var6_37)),
			effect = "+" .. var0_37 .. "%"
		})
	end

	if var1_37 > 0 then
		table.insert(arg0_37.buffInfos, {
			name = i18n("island_production_speed_addition2"),
			effect = "+" .. var1_37 .. "%"
		})
	end

	if var2_37 > 0 then
		local var7_37 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_37.showId):GetSkill():GetName()

		table.insert(arg0_37.buffInfos, {
			name = var7_37,
			effect = "+" .. var2_37 .. "%"
		})
	end

	if var3_37 > 0 then
		table.insert(arg0_37.buffInfos, {
			name = i18n("island_production_speed_addition3"),
			effect = "+" .. var3_37 .. "%"
		})
	end

	arg0_37.buffInfoUIList:align(#arg0_37.buffInfos)
	setActive(arg0_37.buffInfoEmptyTF, #arg0_37.buffInfos == 0)
end

function var0_0.FlushBenefits(arg0_38)
	setActive(arg0_38.benefitsTF, arg0_38.showBenefits)

	if arg0_38.showBenefits then
		setFillAmount(arg0_38.mainAttrBar, arg0_38:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_38.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_39, arg1_39)
	local var0_39 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_39 = var0_39 * arg0_39.selectNum
	local var2_39 = 0

	for iter0_39, iter1_39 in ipairs(arg0_39.selectedIds) do
		var2_39 = var2_39 + (var0_39 - arg0_39.characterAgency:GetShipById(iter1_39):GetAttrGrade(arg1_39) + 1)
	end

	return var2_39 / var1_39
end

function var0_0.ToVShip(arg0_40, arg1_40)
	if not arg0_40.vship then
		arg0_40.vship = {}

		function arg0_40.vship.getNation()
			return arg0_40.vship.config.nationality
		end

		function arg0_40.vship.getShipType()
			return arg0_40.vship.config.type
		end

		function arg0_40.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_40.vship.config.type)
		end

		function arg0_40.vship.getRarity()
			return arg0_40.vship.config.rarity
		end
	end

	arg0_40.vship.config = arg1_40

	return arg0_40.vship
end

local function var1_0(arg0_45, arg1_45)
	if not arg1_45 or arg1_45 == "" then
		return true
	end

	local var0_45 = string.lower(string.gsub(arg1_45, "%.", "%%."))
	local var1_45 = IslandShip.StaticGetName(arg0_45)

	return string.find(string.lower(var1_45), var0_45)
end

local function var2_0(arg0_46, arg1_46, arg2_46)
	local var0_46 = arg1_46
	local var1_46 = ShipGroup.getDefaultShipConfig(var0_46)
	local var2_46 = arg0_46:ToVShip(var1_46)
	local var3_46 = arg0_46.characterAgency:GetShipById(arg1_46)

	if ShipIndexConst.filterByCamp(var2_46, arg2_46.campIndex) and ShipIndexConst.filterByRarity(var2_46, arg2_46.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_46, arg2_46.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_47)
	local var0_47 = {}
	local var1_47 = {}
	local var2_47 = arg0_47.characterAgency:GetShipsContainNpc()

	for iter0_47, iter1_47 in ipairs(var2_47) do
		if var1_0(iter1_47.id, arg0_47.searchKey) and var2_0(arg0_47, iter1_47.id, arg0_47.sortData) then
			if arg0_47.needWorkSpeed then
				local var3_47 = setmetatable({
					GetWorkSpeed = function()
						local var0_48, var1_48, var2_48, var3_48 = IslandProductTimeHelper.GetAllAddPercent(iter1_47.id, arg0_47.placeId, arg0_47.attrType)

						return var0_48 + var1_48 + var2_48 + var3_48
					end
				}, {
					__index = iter1_47
				})

				table.insert(var1_47, var3_47)
			elseif arg0_47.autoCollectionSelectShip then
				if iter1_47.id ~= 1 then
					table.insert(var1_47, iter1_47)
				end
			else
				table.insert(var1_47, iter1_47)
			end
		end
	end

	local var4_47 = IslandShipIndexLayer.getSortFuncAndName(arg0_47.sortData.sortIndex, arg0_47.selectAsc)

	table.sort(var1_47, CompareFuncs(var4_47))

	for iter2_47, iter3_47 in ipairs(var1_47) do
		table.insert(var0_47, iter3_47.id)
	end

	return var0_47
end

function var0_0.OnDestroy(arg0_49)
	ClearLScrollrect(arg0_49.shipRectCom)
	arg0_49:StopTimer()
	arg0_49:OnHide()
end

function var0_0.OnHide(arg0_50)
	if isActive(arg0_50.addStutasInfoPanel) then
		setActive(arg0_50.addStutasInfoPanel, false)
	end

	arg0_50:UnBlurPanel()
end

function var0_0.OnDisable(arg0_51)
	arg0_51:OnHide()
end

return var0_0
