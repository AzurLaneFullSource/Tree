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
	arg0_2.energyCostSilderTF = arg0_2.energyTF:Find("energy_bar_cost")
	arg0_2.giftBtn = arg0_2.energyTFInfo:Find("gift")
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
	arg0_4:AddListener(GAME.ISLAND_GIVE_GIFT_DONE, arg0_4.OnUseItem)
end

function var0_0.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(GAME.ISLAND_FOLLOWER_OP_DONE, arg0_5.OnFollowerOp)
	arg0_5:RemoveListener(GAME.ISLAND_GIVE_GIFT_DONE, arg0_5.OnUseItem)
end

function var0_0.OnUseItem(arg0_6)
	arg0_6:ClosePage(IslandShipStatusBox)
	arg0_6:FlushInfo()
end

function var0_0.OnFollowerOp(arg0_7, arg1_7)
	for iter0_7, iter1_7 in pairs(arg0_7.cards) do
		if iter1_7.id == arg1_7 then
			iter1_7:UpdateFollowMask()
		end
	end
end

function var0_0.OnInit(arg0_8)
	onButton(arg0_8, arg0_8.backBtn, function()
		arg0_8:Hide()
		existCall(arg0_8.cancelFunc)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.addStutasBtn, function()
		if isActive(arg0_8.addStutasInfoPanel) then
			setActive(arg0_8.addStutasInfoPanel, false)
		else
			setActive(arg0_8.addStutasInfoPanel, true)
			arg0_8.buffInfoUIList:align(#arg0_8.buffInfos)
			setActive(arg0_8.buffInfoEmptyTF, #arg0_8.buffInfos == 0)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.sureBtn, function()
		local var0_11 = getProxy(IslandProxy):GetIsland():GetFollowerAgency()
		local var1_11 = {}

		for iter0_11, iter1_11 in ipairs(arg0_8.selectedIds) do
			if var0_11:Following(iter1_11) then
				table.insert(var1_11, iter1_11)
			end
		end

		if #var1_11 > 0 then
			arg0_8:ShowMsgBox({
				type = IslandMsgBox.TYPE_COMMON,
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					local var0_12 = {}

					for iter0_12, iter1_12 in ipairs(var1_11) do
						table.insert(var0_12, function(arg0_13)
							arg0_8:emit(IslandMediator.DEL_FOLLOWER, iter1_12, arg0_13)
						end)
					end

					seriesAsync(var0_12, function()
						arg0_8:Hide()
						existCall(arg0_8.confirmFunc, arg0_8.selectedIds)
					end)
				end
			})

			return
		end

		arg0_8:Hide()
		existCall(arg0_8.confirmFunc, arg0_8.selectedIds)
	end, SFX_PANEL)
	onToggle(arg0_8, arg0_8.indexBtn, function(arg0_15)
		if arg0_15 then
			arg0_8:emit(IslandMediator.OPEN_SHIP_INDEX, {
				OnFilter = function(arg0_16)
					arg0_8:OnFilter(arg0_16)
				end,
				defaultIndex = arg0_8.sortData,
				needWorkSpeed = arg0_8.needWorkSpeed
			})
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.orderBtn, function()
		arg0_8.selectAsc = not arg0_8.selectAsc

		arg0_8:UpdateSortBtn()
		arg0_8:FlushShips()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.benefitTipBtn, function()
		arg0_8:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_manage_help_tip")
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8._tf:Find("top/title/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.island_help_commission.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.giftBtn, function()
		if not arg0_8.showId or arg0_8.showId == IslandCharacterAgency.NPC_CONFIG_ID then
			return
		end

		arg0_8:OpenPage(IslandShipStatusBox, arg0_8.showId)
	end, SFX_PANEL)
	arg0_8.subAttrUIList:make(function(arg0_21, arg1_21, arg2_21)
		if arg0_21 == UIItemList.EventInit then
			local var0_21 = IslandShipAttr.ATTRS[arg1_21 + 1]

			arg2_21.name = var0_21

			setText(arg2_21:Find("Text"), IslandShipAttr.ToChinese(var0_21))
		elseif arg0_21 == UIItemList.EventUpdate then
			setFillAmount(arg2_21:Find("slider/bar"), arg0_8:GetShipsAttrProgress(IslandShipAttr.ATTRS[arg1_21 + 1]))
		end
	end)

	function arg0_8.shipRectCom.onInitItem(arg0_22)
		arg0_8:OnInitShip(arg0_22)
	end

	function arg0_8.shipRectCom.onUpdateItem(arg0_23, arg1_23)
		arg0_8:OnUpdateShip(arg0_23, arg1_23)
	end

	arg0_8.cards = {}
	arg0_8.selectAsc = true
	arg0_8.sortData = {
		sortIndex = IslandShipIndexLayer.SortLevel,
		campIndex = ShipIndexConst.CampAll,
		rarityIndex = ShipIndexConst.RarityAll,
		extraIndex = IslandShipIndexLayer.ExtraALL
	}

	arg0_8:UpdateSortBtn()

	arg0_8.timeMgr = pg.TimeMgr.GetInstance()
end

function var0_0.OnFilter(arg0_24, arg1_24)
	arg0_24.sortData = arg1_24

	arg0_24:UpdateSortBtn()
	arg0_24:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_25)
	arg0_25.orderIco.localScale = arg0_25.selectAsc and Vector3(1, 1, 1) or Vector3(1, -1, 1)

	local var0_25, var1_25 = IslandShipIndexLayer.getSortFuncAndName(arg0_25.sortData.sortIndex, arg0_25.selectAsc)

	arg0_25.orderTxt.text = i18n(var1_25)
end

function var0_0.UpdateAttrs(arg0_26, arg1_26)
	local var0_26 = IslandShipAttr.ATTRS

	arg0_26.attrUIList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = arg1_27 + 1

			arg0_26:UpdateAttr(arg2_27, var0_26, var0_27, arg1_26)
		end
	end)
	arg0_26.attrUIList:align(#var0_26)
end

function var0_0.UpdateAttr(arg0_28, arg1_28, arg2_28, arg3_28, arg4_28)
	local var0_28 = arg2_28[arg3_28]
	local var1_28 = arg4_28:GetAttr(var0_28)

	setText(arg1_28:Find("name"), IslandShipAttr.ToChinese(var0_28))

	local var2_28 = IslandProductTimeHelper.GetAttributeAddPercentByAttribute(arg4_28.id, arg3_28)
	local var3_28
	local var4_28 = var2_28 > 0 and "#00B91E" or var2_28 < 0 and "#FF6767" or "#393A3C"

	setTextColor(arg1_28:Find("value"), Color.NewHex(var4_28))

	local var5_28 = var2_28 ~= 0 and math.floor(var1_28 * (1 + 0.01 * var2_28)) or var1_28

	setText(arg1_28:Find("value"), var5_28)

	if var2_28 ~= 0 then
		local var6_28 = arg4_28:GetDisplayStatus()
		local var7_28 = _.select(var6_28, function(arg0_29)
			return arg0_29:GetBuffType() == IslandBuffType.SHIP_ATTR
		end)

		onButton(arg0_28, arg1_28, function()
			arg0_28:ShowMsgBox({
				hideNo = true,
				type = IslandMsgBox.TYPE_SHIP_OWN_STATUS,
				title = i18n("island_word_ship_buff_desc"),
				statusList = var7_28
			})
		end, SFX_PANEL)
	else
		removeOnButton(arg1_28)
	end

	local var8_28 = arg4_28:GetAttrGradeByValue(var5_28)
	local var9_28 = IslandShipAttr.Grade2Img(var8_28)

	arg1_28:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var9_28[1])
	arg1_28:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var9_28[2])

	setActive(arg1_28:Find("vx_tpl"), arg0_28.attrType == arg3_28)
end

function var0_0.OnShow(arg0_31, arg1_31)
	arg0_31:BlurPanel()

	arg0_31.showType = arg1_31.showType or IslandSelectShipCard.SHOW_TYPE.PLACE
	arg0_31.selectNum = arg1_31.selectNum or 1
	arg0_31.selectedIds = arg1_31.selectedIds or {}
	arg0_31.attrType = arg1_31.attrType
	arg0_31.confirmFunc = arg1_31.confirmFunc
	arg0_31.cancelFunc = arg1_31.cancelFunc
	arg0_31.placeId = arg1_31.placeId
	arg0_31.restId = arg1_31.restId
	arg0_31.showBenefits = arg1_31.showBenefits
	arg0_31.needWorkSpeed = arg1_31.needWorkSpeed or false
	arg0_31.autoCollectionSelectShip = arg1_31.autoCollectionSelectShip

	local var0_31 = arg1_31.emptyInfoTitle or ""

	setText(arg0_31.infoEmptyTitleTF, var0_31)

	arg0_31.energyCost = arg1_31.energyCost or 0
	arg0_31.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	if arg0_31.needWorkSpeed then
		arg0_31.sortData.sortIndex = IslandShipIndexLayer.SortWorkSpeed
	else
		arg0_31.sortData.sortIndex = IslandShipIndexLayer.SortLevel
	end

	arg0_31:UpdateSortBtn()

	local var1_31 = #arg0_31.selectedIds == 0 and arg0_31.selectNum == 1

	arg0_31:FlushShips(var1_31)
end

function var0_0.CheckHasSelected(arg0_32, arg1_32)
	if not arg0_32.autoCollectionSelectShip then
		return false
	end

	local var0_32 = false

	for iter0_32, iter1_32 in pairs(arg0_32.autoCollectionSelectShip) do
		if arg1_32 == iter1_32 then
			var0_32 = true
		end
	end

	return var0_32
end

function var0_0.OnInitShip(arg0_33, arg1_33)
	local var0_33 = IslandSelectShipCard.New(arg1_33)

	arg0_33.cards[arg1_33] = var0_33
end

function var0_0.OnUpdateShip(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.cards[arg2_34]

	if not var0_34 then
		arg0_34:OnInitItem(arg2_34)

		var0_34 = arg0_34.cards[arg2_34]
	end

	local var1_34 = arg0_34.showShips[arg1_34 + 1]
	local var2_34 = arg0_34.characterAgency:GetShipById(var1_34)

	onButton(arg0_34, var0_34.go, function()
		if arg0_34:CheckHasSelected(var1_34) then
			return
		end

		if getProxy(IslandProxy):GetIsland():GetFollowerAgency():Following(var1_34) then
			arg0_34:ShowMsgBox({
				content = i18n("island_cancel_follow_tip"),
				onYes = function()
					arg0_34:emit(IslandMediator.DEL_FOLLOWER, var1_34)
				end
			})

			return
		end

		if not var2_34:IsDelegable() then
			return
		end

		if arg0_34.showId == var0_34.id then
			arg0_34.showId = nil
		else
			arg0_34.showId = var0_34.id
		end

		if table.contains(arg0_34.selectedIds, var0_34.id) then
			table.removebyvalue(arg0_34.selectedIds, var0_34.id)
		elseif arg0_34.selectNum == 1 then
			arg0_34.selectedIds = {
				var0_34.id
			}
		else
			if #arg0_34.selectedIds >= arg0_34.selectNum then
				return
			end

			table.insert(arg0_34.selectedIds, var0_34.id)
		end

		for iter0_35, iter1_35 in pairs(arg0_34.cards) do
			iter1_35:UpdateSelected(arg0_34.selectedIds)
		end

		arg0_34:FlushInfo()
	end, SFX_PANEL)

	if arg0_34.showType == IslandSelectShipCard.SHOW_TYPE.PLACE then
		var0_34:Update(arg0_34.showType, var1_34, arg0_34.attrType, arg0_34.placeId, arg0_34.selectedIds, arg0_34.autoCollectionSelectShip)
	elseif arg0_34.showType == IslandSelectShipCard.SHOW_TYPE.RESTAURANT then
		var0_34:Update(arg0_34.showType, var1_34, arg0_34.attrType, arg0_34.restId, arg0_34.selectedIds, arg0_34.autoCollectionSelectShip)
	end
end

function var0_0.FlushShips(arg0_37, arg1_37)
	arg0_37.showShips = arg0_37:GetShips()

	if #arg0_37.showShips ~= 0 and arg1_37 then
		local var0_37 = arg0_37:GetFristSelectableShipId()

		if var0_37 then
			arg0_37.showId = var0_37

			table.insert(arg0_37.selectedIds, var0_37)
		end
	end

	arg0_37.showId = arg0_37.selectedIds[1]

	setActive(arg0_37.shipContent, #arg0_37.showShips ~= 0)
	setActive(arg0_37.shipEmpty, #arg0_37.showShips == 0)
	arg0_37.shipRectCom:SetTotalCount(#arg0_37.showShips)
	arg0_37:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.showShips) do
		if arg0_38.characterAgency:GetShipById(iter1_38):GetState() == IslandShip.STATE_NORMAL and not arg0_38:CheckHasSelected(iter1_38) then
			return iter1_38
		end
	end

	return nilGetShipsAttrProgress
end

function var0_0.UpdateTimer(arg0_39, arg1_39)
	local var0_39 = arg1_39 - arg0_39.timeMgr:GetServerTime()

	setText(arg0_39.energyTimeTextTf, arg0_39.timeMgr:DescCDTime(var0_39))
end

function var0_0.StopTimer(arg0_40)
	if arg0_40.energyTimer ~= nil then
		arg0_40.energyTimer:Stop()

		arg0_40.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_41)
	arg0_41.selectedTextCom.text = #arg0_41.selectedIds .. "/" .. arg0_41.selectNum

	arg0_41:FlushBenefits()
	setActive(arg0_41.sureBtn, arg0_41.showId)
	setActive(arg0_41.infoPanel, arg0_41.showId)
	setActive(arg0_41.infoEmptyTF, not arg0_41.showId)
	arg0_41:FlushAddPercent()
	arg0_41:FlushEnergyPercent()

	if not arg0_41.showId then
		return
	end

	setActive(arg0_41.giftBtn, arg0_41.showId ~= IslandCharacterAgency.NPC_CONFIG_ID)

	local var0_41 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_41.showId)

	setText(arg0_41.nameTF, var0_41:GetName())
	setText(arg0_41.levelTF, string.format("-Lv.%d", var0_41:GetLevel()))
	arg0_41:UpdateAttrs(var0_41)

	local var1_41 = IslandShip.StaticGetPrefab(var0_41.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_41, "", arg0_41.shipIconTF)

	local var2_41 = var0_41:GetCurrentEnergy()
	local var3_41 = var0_41:GetMaxEnergy()

	setText(arg0_41.energyTF:Find("text"), var2_41 .. "/" .. var3_41)
	setSlider(arg0_41.energyTF:Find("energy_bar"), 0, 1, var2_41 / var3_41)

	if var2_41 ~= var3_41 then
		setActive(arg0_41.recoveryTimeTips, true)
		setActive(arg0_41.energyTimeTextTf, true)

		local var4_41 = var0_41:GetEnergyMaxTime()

		arg0_41:StopTimer()
		arg0_41:UpdateTimer(var4_41)

		arg0_41.energyTimer = Timer.New(function()
			arg0_41:UpdateTimer(var4_41)
		end, 1, -1)

		arg0_41.energyTimer:Start()
	else
		arg0_41:StopTimer()
		setActive(arg0_41.recoveryTimeTips, false)
		setActive(arg0_41.energyTimeTextTf, false)
	end

	local var5_41 = var0_41:GetSkill()
	local var6_41 = var5_41:IsUnlock()

	setActive(arg0_41.skill, var6_41)
	setActive(arg0_41.skillEmp, not var6_41)
	setText(arg0_41.skillEmpDes, i18n("island_need_star", var0_41:GetSkillUnlockLevel()))

	local var7_41 = arg0_41.showType == IslandSelectShipCard.SHOW_TYPE.PLACE and arg0_41.placeId or arg0_41.restId
	local var8_41 = var6_41 and IslandSelectShipCard.GetSkillEffective(var0_41, arg0_41.showType, var7_41)

	setActive(arg0_41.skillInuse, var8_41)
	setActive(arg0_41.skillUnuse, not var8_41)

	arg0_41.skillName.text = string.format("%s - %s", var5_41:GetName(), "[Lv." .. var5_41:GetLevel() .. "]")
	arg0_41.skillDes.text = var5_41:GetEffectDesc()

	arg0_41:FlushAddPercent()
	arg0_41:FlushEnergyPercent()
	arg0_41:FlushEnergyCostAnim(var0_41)
end

function var0_0.FlushEnergyCostAnim(arg0_43, arg1_43)
	arg0_43:StopCostTimer()

	local var0_43 = arg0_43.energyCost ~= 0 and arg0_43.showType == IslandSelectShipCard.SHOW_TYPE.PLACE

	setActive(arg0_43.energyCostSilderTF, var0_43)

	if not var0_43 then
		return
	end

	if arg1_43.id == IslandCharacterAgency.NPC_CONFIG_ID then
		local var1_43 = arg1_43:GetCurrentEnergy()
		local var2_43 = arg1_43:GetMaxEnergy()

		setActive(arg0_43.energyCostSilderTF, false)
		setSlider(arg0_43.energyTF:Find("energy_bar"), 0, 1, var1_43 / var2_43)
		setText(arg0_43.energyTF:Find("text"), string.format("%d-<color=#fadfb6>%d</color>/%d", var1_43, 0, var2_43))

		return
	end

	local var3_43 = math.floor(arg0_43.energyCost * (1 - IslandProductCostHelper.GetReducePercentInPlace(arg1_43.id, arg0_43.placeId)))
	local var4_43 = math.max(var3_43, 1)

	arg0_43.energyCostTimer = Timer.New(function()
		local var0_44 = arg1_43:GetCurrentEnergy()
		local var1_44 = arg1_43:GetMaxEnergy()

		setSlider(arg0_43.energyTF:Find("energy_bar"), 0, 1, (var0_44 - var4_43) / var1_44)
		setSlider(arg0_43.energyCostSilderTF, 0, 1, var0_44 / var1_44)
		setText(arg0_43.energyTF:Find("text"), string.format("%d-<color=#fadfb6>%d</color>/%d", var0_44, var4_43, var1_44))
	end, 1, -1)

	arg0_43.energyCostTimer:Start()
	arg0_43.energyCostTimer.func()
end

function var0_0.FlushEnergyPercent(arg0_45)
	if not arg0_45.showId or not arg0_45.autoCollectionSelectShip then
		setActive(arg0_45.energyStutasTF, false)

		return
	end

	setActive(arg0_45.energyStutasTF, true)

	local var0_45 = IslandAutoCollectHelper.GetAttributeReducePercent(arg0_45.showId)
	local var1_45 = string.format("<color=#39bfff> -%d%%</color>", var0_45)
	local var2_45 = i18n("island_chara_gather_skill_effect") .. var1_45

	setText(arg0_45.energyStutasTFNum, var2_45)
end

function var0_0.FlushAddPercent(arg0_46)
	if not arg0_46.showId or not arg0_46.needWorkSpeed then
		setActive(arg0_46.addStutasTF, false)
		setActive(arg0_46.addStutasInfoPanel, false)

		return
	end

	local var0_46, var1_46, var2_46, var3_46 = IslandProductTimeHelper.GetAllAddPercent(arg0_46.showId, arg0_46.placeId, arg0_46.attrType)
	local var4_46 = var0_46 + var1_46 + var2_46 + var3_46

	setActive(arg0_46.addStutasTF, true)
	setText(arg0_46.addStutasNum, i18n("island_production_speed_tip1", var4_46))

	arg0_46.buffInfos = {}

	local var5_46 = IslandProductTimeHelper.GetAttributeAddPercent(arg0_46.showId, arg0_46.attrType)

	if var0_46 > 0 then
		local var6_46 = IslandShipAttr.GetAtrrName(arg0_46.attrType)

		table.insert(arg0_46.buffInfos, {
			name = i18n("island_production_speed_addition1", IslandShipAttr.ToChinese(var6_46)),
			effect = "+" .. var0_46 .. "%"
		})
	end

	if var1_46 > 0 then
		table.insert(arg0_46.buffInfos, {
			name = i18n("island_production_speed_addition2"),
			effect = "+" .. var1_46 .. "%"
		})
	end

	if var2_46 > 0 then
		local var7_46 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_46.showId):GetSkill():GetName()

		table.insert(arg0_46.buffInfos, {
			name = var7_46,
			effect = "+" .. var2_46 .. "%"
		})
	end

	if var3_46 > 0 then
		table.insert(arg0_46.buffInfos, {
			name = i18n("island_production_speed_addition3"),
			effect = "+" .. var3_46 .. "%"
		})
	end

	arg0_46.buffInfoUIList:align(#arg0_46.buffInfos)
	setActive(arg0_46.buffInfoEmptyTF, #arg0_46.buffInfos == 0)
end

function var0_0.FlushBenefits(arg0_47)
	setActive(arg0_47.benefitsTF, arg0_47.showBenefits)

	if arg0_47.showBenefits then
		setFillAmount(arg0_47.mainAttrBar, arg0_47:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_47.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_48, arg1_48)
	local var0_48 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_48 = var0_48 * arg0_48.selectNum
	local var2_48 = 0

	for iter0_48, iter1_48 in ipairs(arg0_48.selectedIds) do
		var2_48 = var2_48 + (var0_48 - arg0_48.characterAgency:GetShipById(iter1_48):GetAttrGrade(arg1_48) + 1)
	end

	return var2_48 / var1_48
end

function var0_0.ToVShip(arg0_49, arg1_49)
	if not arg0_49.vship then
		arg0_49.vship = {}

		function arg0_49.vship.getNation()
			return arg0_49.vship.config.nationality
		end

		function arg0_49.vship.getShipType()
			return arg0_49.vship.config.type
		end

		function arg0_49.vship.getTeamType()
			return ShipType.GetTeamFromShipType(arg0_49.vship.config.type)
		end

		function arg0_49.vship.getRarity()
			return arg0_49.vship.config.rarity
		end
	end

	arg0_49.vship.config = arg1_49

	return arg0_49.vship
end

local function var1_0(arg0_54, arg1_54)
	if not arg1_54 or arg1_54 == "" then
		return true
	end

	local var0_54 = string.lower(string.gsub(arg1_54, "%.", "%%."))
	local var1_54 = IslandShip.StaticGetName(arg0_54)

	return string.find(string.lower(var1_54), var0_54)
end

local function var2_0(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg1_55
	local var1_55 = ShipGroup.getDefaultShipConfig(var0_55)
	local var2_55 = arg0_55:ToVShip(var1_55)
	local var3_55 = arg0_55.characterAgency:GetShipById(arg1_55)

	if ShipIndexConst.filterByCamp(var2_55, arg2_55.campIndex) and ShipIndexConst.filterByRarity(var2_55, arg2_55.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_55, arg2_55.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_56)
	local var0_56 = {}
	local var1_56 = {}
	local var2_56 = arg0_56.characterAgency:GetShipsContainNpc()

	for iter0_56, iter1_56 in ipairs(var2_56) do
		if var1_0(iter1_56.id, arg0_56.searchKey) and var2_0(arg0_56, iter1_56.id, arg0_56.sortData) then
			if arg0_56.needWorkSpeed then
				local var3_56 = setmetatable({
					GetWorkSpeed = function()
						local var0_57, var1_57, var2_57, var3_57 = IslandProductTimeHelper.GetAllAddPercent(iter1_56.id, arg0_56.placeId, arg0_56.attrType)

						return var0_57 + var1_57 + var2_57 + var3_57
					end
				}, {
					__index = iter1_56
				})

				table.insert(var1_56, var3_56)
			elseif arg0_56.autoCollectionSelectShip then
				if iter1_56.id ~= 1 then
					table.insert(var1_56, iter1_56)
				end
			else
				table.insert(var1_56, iter1_56)
			end
		end
	end

	local var4_56 = IslandShipIndexLayer.getSortFuncAndName(arg0_56.sortData.sortIndex, arg0_56.selectAsc)

	table.sort(var1_56, CompareFuncs(var4_56))

	for iter2_56, iter3_56 in ipairs(var1_56) do
		table.insert(var0_56, iter3_56.id)
	end

	return var0_56
end

function var0_0.StopCostTimer(arg0_58)
	if arg0_58.energyCostTimer ~= nil then
		arg0_58.energyCostTimer:Stop()

		arg0_58.energyCostTimer = nil
	end
end

function var0_0.OnDestroy(arg0_59)
	ClearLScrollrect(arg0_59.shipRectCom)
	arg0_59:StopTimer()
	arg0_59:StopCostTimer()
	arg0_59:OnHide()
end

function var0_0.OnHide(arg0_60)
	if isActive(arg0_60.addStutasInfoPanel) then
		setActive(arg0_60.addStutasInfoPanel, false)
	end

	arg0_60:UnBlurPanel()
end

function var0_0.OnDisable(arg0_61)
	arg0_61:OnHide()
end

return var0_0
