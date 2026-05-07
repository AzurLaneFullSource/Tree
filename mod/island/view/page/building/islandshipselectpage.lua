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

function var0_0.AddListeners(arg0_4)
	arg0_4:AddListener(GAME.ISLAND_FOLLOWER_OP_DONE, arg0_4.OnFollowerOp)
end

function var0_0.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(GAME.ISLAND_FOLLOWER_OP_DONE, arg0_5.OnFollowerOp)
end

function var0_0.OnFollowerOp(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg0_6.cards) do
		if iter1_6.id == arg1_6 then
			iter1_6:UpdateFollowMask()
		end
	end
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7.backBtn, function()
		arg0_7:Hide()
		existCall(arg0_7.cancelFunc)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.addStutasBtn, function()
		if isActive(arg0_7.addStutasInfoPanel) then
			setActive(arg0_7.addStutasInfoPanel, false)
		else
			setActive(arg0_7.addStutasInfoPanel, true)
			arg0_7.buffInfoUIList:align(#arg0_7.buffInfos)
			setActive(arg0_7.buffInfoEmptyTF, #arg0_7.buffInfos == 0)
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.sureBtn, function()
		local var0_10 = getProxy(IslandProxy):GetIsland():GetFollowerAgency()
		local var1_10 = {}

		for iter0_10, iter1_10 in ipairs(arg0_7.selectedIds) do
			if var0_10:Following(iter1_10) then
				table.insert(var1_10, iter1_10)
			end
		end

		if #var1_10 > 0 then
			arg0_7:ShowMsgBox({
				type = IslandMsgBox.TYPE_COMMON,
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					local var0_11 = {}

					for iter0_11, iter1_11 in ipairs(var1_10) do
						table.insert(var0_11, function(arg0_12)
							arg0_7:emit(IslandMediator.DEL_FOLLOWER, iter1_11, arg0_12)
						end)
					end

					seriesAsync(var0_11, function()
						arg0_7:Hide()
						existCall(arg0_7.confirmFunc, arg0_7.selectedIds)
					end)
				end
			})

			return
		end

		arg0_7:Hide()
		existCall(arg0_7.confirmFunc, arg0_7.selectedIds)
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.indexBtn, function(arg0_14)
		if arg0_14 then
			arg0_7:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_15)
					arg0_7:OnFilter(arg0_15)
				end,
				defaultIndex = arg0_7.sortData,
				needWorkSpeed = arg0_7.needWorkSpeed
			})
		end
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.orderBtn, function()
		arg0_7.selectAsc = not arg0_7.selectAsc

		arg0_7:UpdateSortBtn()
		arg0_7:FlushShips()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.benefitTipBtn, function()
		arg0_7:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_manage_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
	arg0_7.subAttrUIList:make(function(arg0_19, arg1_19, arg2_19)
		if arg0_19 == UIItemList.EventInit then
			local var0_19 = IslandShipAttr.ATTRS[arg1_19 + 1]

			arg2_19.name = var0_19

			setText(arg2_19:Find("Text"), IslandShipAttr.ToChinese(var0_19))
		elseif arg0_19 == UIItemList.EventUpdate then
			setFillAmount(arg2_19:Find("slider/bar"), arg0_7:GetShipsAttrProgress(IslandShipAttr.ATTRS[arg1_19 + 1]))
		end
	end)

	function arg0_7.shipRectCom.onInitItem(arg0_20)
		arg0_7:OnInitShip(arg0_20)
	end

	function arg0_7.shipRectCom.onUpdateItem(arg0_21, arg1_21)
		arg0_7:OnUpdateShip(arg0_21, arg1_21)
	end

	arg0_7.cards = {}
	arg0_7.selectAsc = true
	arg0_7.sortData = {
		sortIndex = IslandShipIndexLayer.SortLevel,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_7:UpdateSortBtn()

	arg0_7.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFilter(arg0_22, arg1_22)
	arg0_22.sortData = arg1_22

	arg0_22:UpdateSortBtn()
	arg0_22:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_23)
	arg0_23.orderIco.localScale = arg0_23.selectAsc and Vector3(1, 1, 1) or Vector3(1, -1, 1)

	local var0_23, var1_23 = IslandShipIndexLayer.getSortFuncAndName(arg0_23.sortData.sortIndex, arg0_23.selectAsc)

	arg0_23.orderTxt.text = i18n(var1_23)
end

function var0_0.UpdateAttrs(arg0_24, arg1_24)
	local var0_24 = IslandShipAttr.ATTRS

	arg0_24.attrUIList:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = arg1_25 + 1

			arg0_24:UpdateAttr(arg2_25, var0_24, var0_25, arg1_24)
		end
	end)
	arg0_24.attrUIList:align(#var0_24)
end

function var0_0.UpdateAttr(arg0_26, arg1_26, arg2_26, arg3_26, arg4_26)
	local var0_26 = arg2_26[arg3_26]
	local var1_26 = arg4_26:GetAttr(var0_26)

	setText(arg1_26:Find("name"), IslandShipAttr.ToChinese(var0_26))

	local var2_26 = IslandProductTimeHelper.GetAttributeAddPercentByAttribute(arg4_26.id, arg3_26)
	local var3_26
	local var4_26 = var2_26 > 0 and "#00B91E" or var2_26 < 0 and "#FF6767" or "#393A3C"

	setTextColor(arg1_26:Find("value"), Color.NewHex(var4_26))

	local var5_26 = var2_26 ~= 0 and math.floor(var1_26 * (1 + 0.01 * var2_26)) or var1_26

	setText(arg1_26:Find("value"), var5_26)

	if var2_26 ~= 0 then
		local var6_26 = arg4_26:GetDisplayStatus()
		local var7_26 = _.select(var6_26, function(arg0_27)
			return arg0_27:GetBuffType() == IslandBuffType.SHIP_ATTR
		end)

		onButton(arg0_26, arg1_26, function()
			arg0_26:ShowMsgBox({
				hideNo = true,
				type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
				title = i18n("island_word_ship_buff_desc"),
				statusList = var7_26
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg1_26)
	end

	local var8_26 = arg4_26:GetAttrGradeByValue(var5_26)
	local var9_26 = IslandShipAttr.Grade2Img(var8_26)

	arg1_26:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var9_26[1])
	arg1_26:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var9_26[2])

	setActive(arg1_26:Find("vx_tpl"), arg0_26.attrType == arg3_26)
end

function var0_0.OnShow(arg0_29, arg1_29)
	arg0_29:BlurPanel()

	arg0_29.selectNum = arg1_29.selectNum or 1
	arg0_29.selectedIds = arg1_29.selectedIds or {}
	arg0_29.attrType = arg1_29.attrType
	arg0_29.confirmFunc = arg1_29.confirmFunc
	arg0_29.cancelFunc = arg1_29.cancelFunc
	arg0_29.placeId = arg1_29.placeId
	arg0_29.showBenefits = arg1_29.showBenefits
	arg0_29.needWorkSpeed = arg1_29.needWorkSpeed or false
	arg0_29.autoCollectionSelectShip = arg1_29.autoCollectionSelectShip

	local var0_29 = arg1_29.emptyInfoTitle or ""

	setText(arg0_29.infoEmptyTitleTF, var0_29)

	arg0_29.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	if arg0_29.needWorkSpeed then
		arg0_29.sortData.sortIndex = IslandShipIndexLayer.SortWorkSpeed
	else
		arg0_29.sortData.sortIndex = IslandShipIndexLayer.SortLevel
	end

	arg0_29:UpdateSortBtn()

	local var1_29 = #arg0_29.selectedIds == 0 and arg0_29.selectNum == 1

	arg0_29:FlushShips(var1_29)
end

function var0_0.CheckHasSelected(arg0_30, arg1_30)
	if not arg0_30.autoCollectionSelectShip then
		return false
	end

	local var0_30 = false

	for iter0_30, iter1_30 in pairs(arg0_30.autoCollectionSelectShip) do
		if arg1_30 == iter1_30 then
			var0_30 = true
		end
	end

	return var0_30
end

function var0_0.OnInitShip(arg0_31, arg1_31)
	local var0_31 = IslandSelectShipCard.New(arg1_31)

	arg0_31.cards[arg1_31] = var0_31
end

function var0_0.OnUpdateShip(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg0_32.cards[arg2_32]

	if not var0_32 then
		arg0_32:OnInitItem(arg2_32)

		var0_32 = arg0_32.cards[arg2_32]
	end

	local var1_32 = arg0_32.showShips[arg1_32 + 1]
	local var2_32 = arg0_32.characterAgency:GetShipById(var1_32)

	onButton(arg0_32, var0_32.go, function()
		if arg0_32:CheckHasSelected(var1_32) then
			return
		end

		if getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(var1_32) then
			arg0_32:ShowMsgBox({
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					arg0_32:emit(IslandMediator.DEL_FOLLOWER, var1_32)
				end
			})

			return
		end

		if not var2_32:IsDelegable() then
			return
		end

		if arg0_32.showId == var0_32.id then
			arg0_32.showId = nil
		else
			arg0_32.showId = var0_32.id
		end

		if table.contains(arg0_32.selectedIds, var0_32.id) then
			table.removebyvalue(arg0_32.selectedIds, var0_32.id)
		elseif arg0_32.selectNum == 1 then
			arg0_32.selectedIds = {
				var0_32.id
			}
		else
			if #arg0_32.selectedIds >= arg0_32.selectNum then
				return
			end

			table.insert(arg0_32.selectedIds, var0_32.id)
		end

		for iter0_33, iter1_33 in pairs(arg0_32.cards) do
			iter1_33:UpdateSelected(arg0_32.selectedIds)
		end

		arg0_32:FlushInfo()
	end, SFX_PANEL)
	var0_32:Update(var1_32, arg0_32.attrType, arg0_32.placeId, arg0_32.selectedIds, arg0_32.autoCollectionSelectShip)
end

function var0_0.FlushShips(arg0_35, arg1_35)
	arg0_35.showShips = arg0_35:GetShips()

	if #arg0_35.showShips ~= 0 and arg1_35 then
		local var0_35 = arg0_35:GetFristSelectableShipId()

		if var0_35 then
			arg0_35.showId = var0_35

			table.insert(arg0_35.selectedIds, var0_35)
		end
	end

	arg0_35.showId = arg0_35.selectedIds[1]

	setActive(arg0_35.shipContent, #arg0_35.showShips ~= 0)
	setActive(arg0_35.shipEmpty, #arg0_35.showShips == 0)
	arg0_35.shipRectCom:SetTotalCount(#arg0_35.showShips)
	arg0_35:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_36)
	for iter0_36, iter1_36 in ipairs(arg0_36.showShips) do
		if arg0_36.characterAgency:GetShipById(iter1_36):GetState() == IslandShip.STATE_NORMAL and not arg0_36:CheckHasSelected(iter1_36) then
			return iter1_36
		end
	end

	return nilGetShipsAttrProgress
end

function var0_0.UpdateTimer(arg0_37, arg1_37)
	local var0_37 = arg1_37 - arg0_37.timeMgr:GetServerTime()

	setText(arg0_37.energyTimeTextTf, arg0_37.timeMgr:DescCDTime(var0_37))
end

function var0_0.StopTimer(arg0_38)
	if arg0_38.energyTimer ~= nil then
		arg0_38.energyTimer:Stop()

		arg0_38.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_39)
	arg0_39.selectedTextCom.text = #arg0_39.selectedIds .. "/" .. arg0_39.selectNum

	arg0_39:FlushBenefits()
	setActive(arg0_39.sureBtn, arg0_39.showId)
	setActive(arg0_39.infoPanel, arg0_39.showId)
	setActive(arg0_39.infoEmptyTF, not arg0_39.showId)
	arg0_39:FlushAddPercent()
	arg0_39:FlushEnergyPercent()

	if not arg0_39.showId then
		return
	end

	local var0_39 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_39.showId)

	setText(arg0_39.nameTF, var0_39:GetName())
	setText(arg0_39.levelTF, string.format("-Lv.%d", var0_39:GetLevel()))
	arg0_39:UpdateAttrs(var0_39)

	local var1_39 = IslandShip.StaticGetPrefab(var0_39.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_39, "", arg0_39.shipIconTF)

	local var2_39 = var0_39:GetCurrentEnergy()
	local var3_39 = var0_39:GetMaxEnergy()

	setText(arg0_39.energyTF:Find("text"), var2_39 .. "/" .. var3_39)
	setSlider(arg0_39.energyTF:Find("energy_bar"), 0, 1, var2_39 / var3_39)

	if var2_39 ~= var3_39 then
		setActive(arg0_39.recoveryTimeTips, true)
		setActive(arg0_39.energyTimeTextTf, true)

		local var4_39 = var0_39:GetEnergyMaxTime()

		arg0_39:StopTimer()
		arg0_39:UpdateTimer(var4_39)

		arg0_39.energyTimer = Timer.New(function()
			arg0_39:UpdateTimer(var4_39)
		end, 1, -1)

		arg0_39.energyTimer:Start()
	else
		arg0_39:StopTimer()
		setActive(arg0_39.recoveryTimeTips, false)
		setActive(arg0_39.energyTimeTextTf, false)
	end

	local var5_39 = var0_39:GetSkill()
	local var6_39 = var5_39:IsUnlock()

	setActive(arg0_39.skill, var6_39)
	setActive(arg0_39.skillEmp, not var6_39)
	setText(arg0_39.skillEmpDes, i18n("island_need_star", var0_39:GetSkillUnlockLevel()))

	local var7_39 = var5_39:IsEffectiveInPlace(arg0_39.placeId)

	setActive(arg0_39.skillInuse, var7_39)
	setActive(arg0_39.skillUnuse, not var7_39)

	arg0_39.skillName.text = string.format("%s - %s", var5_39:GetName(), "[Lv." .. var5_39:GetLevel() .. "]")
	arg0_39.skillDes.text = var5_39:GetEffectDesc()

	arg0_39:FlushAddPercent()
	arg0_39:FlushEnergyPercent()
end

function var0_0.FlushEnergyPercent(arg0_41)
	if not arg0_41.showId or not arg0_41.autoCollectionSelectShip then
		setActive(arg0_41.energyStutasTF, false)

		return
	end

	setActive(arg0_41.energyStutasTF, true)

	local var0_41 = IslandAutoCollectHelper.GetAttributeReducePercent(arg0_41.showId)
	local var1_41 = string.format("<color=#39bfff> -%d%%</color>", var0_41)
	local var2_41 = i18n("island_chara_gather_skill_effect") .. var1_41

	setText(arg0_41.energyStutasTFNum, var2_41)
end

function var0_0.FlushAddPercent(arg0_42)
	if not arg0_42.showId or not arg0_42.needWorkSpeed then
		setActive(arg0_42.addStutasTF, false)
		setActive(arg0_42.addStutasInfoPanel, false)

		return
	end

	local var0_42, var1_42, var2_42, var3_42 = IslandProductTimeHelper.GetAllAddPercent(arg0_42.showId, arg0_42.placeId, arg0_42.attrType)
	local var4_42 = var0_42 + var1_42 + var2_42 + var3_42

	setActive(arg0_42.addStutasTF, true)
	setText(arg0_42.addStutasNum, i18n("island_production_speed_tip1", var4_42))

	arg0_42.buffInfos = {}

	local var5_42 = IslandProductTimeHelper.GetAttributeAddPercent(arg0_42.showId, arg0_42.attrType)

	if var0_42 > 0 then
		local var6_42 = IslandShipAttr.GetAtrrName(arg0_42.attrType)

		table.insert(arg0_42.buffInfos, {
			name = i18n("island_production_speed_addition1", IslandShipAttr.ToChinese(var6_42)),
			effect = "+" .. var0_42 .. "%"
		})
	end

	if var1_42 > 0 then
		table.insert(arg0_42.buffInfos, {
			name = i18n("island_production_speed_addition2"),
			effect = "+" .. var1_42 .. "%"
		})
	end

	if var2_42 > 0 then
		local var7_42 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_42.showId):GetSkill():GetName()

		table.insert(arg0_42.buffInfos, {
			name = var7_42,
			effect = "+" .. var2_42 .. "%"
		})
	end

	if var3_42 > 0 then
		table.insert(arg0_42.buffInfos, {
			name = i18n("island_production_speed_addition3"),
			effect = "+" .. var3_42 .. "%"
		})
	end

	arg0_42.buffInfoUIList:align(#arg0_42.buffInfos)
	setActive(arg0_42.buffInfoEmptyTF, #arg0_42.buffInfos == 0)
end

function var0_0.FlushBenefits(arg0_43)
	setActive(arg0_43.benefitsTF, arg0_43.showBenefits)

	if arg0_43.showBenefits then
		setFillAmount(arg0_43.mainAttrBar, arg0_43:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_43.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_44, arg1_44)
	local var0_44 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_44 = var0_44 * arg0_44.selectNum
	local var2_44 = 0

	for iter0_44, iter1_44 in ipairs(arg0_44.selectedIds) do
		var2_44 = var2_44 + (var0_44 - arg0_44.characterAgency:GetShipById(iter1_44):GetAttrGrade(arg1_44) + 1)
	end

	return var2_44 / var1_44
end

function var0_0.ToVShip(arg0_45, arg1_45)
	if not arg0_45.vship then
		arg0_45.vship = {}

		function arg0_45.vship.getNation()
			return arg0_45.vship.config.nationality
		end

		function arg0_45.vship.getShipType()
			return arg0_45.vship.config.type
		end

		function arg0_45.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_45.vship.config.type)
		end

		function arg0_45.vship.getRarity()
			return arg0_45.vship.config.rarity
		end
	end

	arg0_45.vship.config = arg1_45

	return arg0_45.vship
end

local function var1_0(arg0_50, arg1_50)
	if not arg1_50 or arg1_50 == "" then
		return true
	end

	local var0_50 = string.lower(string.gsub(arg1_50, "%.", "%%."))
	local var1_50 = IslandShip.StaticGetName(arg0_50)

	return string.find(string.lower(var1_50), var0_50)
end

local function var2_0(arg0_51, arg1_51, arg2_51)
	local var0_51 = arg1_51
	local var1_51 = ShipGroup.getDefaultShipConfig(var0_51)
	local var2_51 = arg0_51:ToVShip(var1_51)
	local var3_51 = arg0_51.characterAgency:GetShipById(arg1_51)

	if ShipIndexConst.filterByCamp(var2_51, arg2_51.campIndex) and ShipIndexConst.filterByRarity(var2_51, arg2_51.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_51, arg2_51.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_52)
	local var0_52 = {}
	local var1_52 = {}
	local var2_52 = arg0_52.characterAgency:GetShipsContainNpc()

	for iter0_52, iter1_52 in ipairs(var2_52) do
		if var1_0(iter1_52.id, arg0_52.searchKey) and var2_0(arg0_52, iter1_52.id, arg0_52.sortData) then
			if arg0_52.needWorkSpeed then
				local var3_52 = setmetatable({
					GetWorkSpeed = function()
						local var0_53, var1_53, var2_53, var3_53 = IslandProductTimeHelper.GetAllAddPercent(iter1_52.id, arg0_52.placeId, arg0_52.attrType)

						return var0_53 + var1_53 + var2_53 + var3_53
					end
				}, {
					__index = iter1_52
				})

				table.insert(var1_52, var3_52)
			elseif arg0_52.autoCollectionSelectShip then
				if iter1_52.id ~= 1 then
					table.insert(var1_52, iter1_52)
				end
			else
				table.insert(var1_52, iter1_52)
			end
		end
	end

	local var4_52 = IslandShipIndexLayer.getSortFuncAndName(arg0_52.sortData.sortIndex, arg0_52.selectAsc)

	table.sort(var1_52, CompareFuncs(var4_52))

	for iter2_52, iter3_52 in ipairs(var1_52) do
		table.insert(var0_52, iter3_52.id)
	end

	return var0_52
end

function var0_0.OnDestroy(arg0_54)
	ClearLScrollrect(arg0_54.shipRectCom)
	arg0_54:StopTimer()
	arg0_54:OnHide()
end

function var0_0.OnHide(arg0_55)
	if isActive(arg0_55.addStutasInfoPanel) then
		setActive(arg0_55.addStutasInfoPanel, false)
	end

	arg0_55:UnBlurPanel()
end

function var0_0.OnDisable(arg0_56)
	arg0_56:OnHide()
end

return var0_0
