local var0_0 = class("IslandShipSelectPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipSelectUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("top/back")
	arg0_2.title = arg0_2:findTF("top/title/Text")

	setText(arg0_2.title, i18n("island_select_ship"))

	arg0_2.frameTF = arg0_2:findTF("frame")
	arg0_2.shipRectCom = arg0_2:findTF("ships", arg0_2.frameTF):GetComponent("LScrollRect")

	setText(arg0_2.frameTF:Find("selected/Text"), i18n("island_select_ship_label_1"))

	arg0_2.selectedTextCom = arg0_2.frameTF:Find("selected/num"):GetComponent("Text")
	arg0_2.benefitsTF = arg0_2._tf:Find("benefits")
	arg0_2.benefitTipBtn = arg0_2.benefitsTF:Find("tip/help")

	setText(arg0_2.benefitsTF:Find("tip/Text"), i18n("island_select_ship_overview"))

	arg0_2.mainAttrBar = arg0_2.benefitsTF:Find("main/slider/bar")

	setText(arg0_2.benefitsTF:Find("main/Text"), IslandShipAttr.ATTRS_CH[IslandShipAttr.MANAGE_KEY])

	arg0_2.subAttrUIList = UIItemList.New(arg0_2.benefitsTF:Find("subs"), arg0_2.benefitsTF:Find("subs/tpl"))
	arg0_2.infoEmptyTF = arg0_2:findTF("info/empty")

	setText(arg0_2.infoEmptyTF:Find("Image/Text"), i18n("island_select_ship"))

	arg0_2.infoEmptyTitleTF = arg0_2.infoEmptyTF:Find("name")
	arg0_2.infoPanel = arg0_2:findTF("info/content")
	arg0_2.nameTF = arg0_2:findTF("name", arg0_2.infoPanel)
	arg0_2.levelTF = arg0_2:findTF("name/level", arg0_2.infoPanel)
	arg0_2.attrUIList = UIItemList.New(arg0_2:findTF("attrs", arg0_2.infoPanel), arg0_2:findTF("attrs/tpl", arg0_2.infoPanel))
	arg0_2.skillTF = arg0_2:findTF("skill", arg0_2.infoPanel)
	arg0_2.energyTFInfo = arg0_2:findTF("selectShipEnergyInfo", arg0_2.infoPanel)
	arg0_2.energyTF = arg0_2:findTF("energy", arg0_2.energyTFInfo)
	arg0_2.statusTF = arg0_2:findTF("status", arg0_2.infoPanel)
	arg0_2.sureBtn = arg0_2:findTF("sure")

	setText(arg0_2.sureBtn:Find("Text"), i18n("island_shipselect_confirm"))

	arg0_2.indexBtn = arg0_2._tf:Find("frame/filter_panel/IndexIco")
	arg0_2.orderBtn = arg0_2._tf:Find("frame/filter_panel/index")
	arg0_2.orderIco = arg0_2._tf:Find("frame/filter_panel/index/content/icon/icon")
	arg0_2.orderTxt = arg0_2._tf:Find("frame/filter_panel/index/content/Text"):GetComponent(typeof(Text))
	arg0_2.shipIconTF = arg0_2.energyTFInfo:Find("icon_mask/icon")
	arg0_2.energyTimeTextTf = arg0_2.energyTFInfo:Find("time_Text")
	arg0_2.recoveryTimeTips = arg0_2:findTF("selectShipEnergyInfo/recoveryTimeTips", arg0_2.infoPanel)
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
	arg0_3.subAttrUIList:make(function(arg0_12, arg1_12, arg2_12)
		if arg0_12 == UIItemList.EventInit then
			local var0_12 = IslandShipAttr.ATTRS[arg1_12 + 1]

			arg2_12.name = var0_12

			setText(arg2_12:Find("Text"), IslandShipAttr.ToChinese(var0_12))
		elseif arg0_12 == UIItemList.EventUpdate then
			setFillAmount(arg2_12:Find("slider/bar"), arg0_3:GetShipsAttrProgress(IslandShipAttr.ATTRS[arg1_12 + 1]))
		end
	end)

	function arg0_3.shipRectCom.onInitItem(arg0_13)
		arg0_3:OnInitShip(arg0_13)
	end

	function arg0_3.shipRectCom.onUpdateItem(arg0_14, arg1_14)
		arg0_3:OnUpdateShip(arg0_14, arg1_14)
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

function var0_0.OnFilter(arg0_15, arg1_15)
	arg0_15.sortData = arg1_15

	arg0_15:UpdateSortBtn()
	arg0_15:FlushShips()
end

function var0_0.UpdateSortBtn(arg0_16)
	arg0_16.orderIco.localScale = arg0_16.selectAsc and Vector3(1, -1, 1) or Vector3(1, 1, 1)

	local var0_16, var1_16 = IslandShipIndexLayer.getSortFuncAndName(arg0_16.sortData.sortIndex, arg0_16.selectAsc)

	arg0_16.orderTxt.text = i18n(var1_16)
end

function var0_0.UpdateAttrs(arg0_17, arg1_17)
	local var0_17 = IslandShipAttr.ATTRS

	arg0_17.attrUIList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg1_18 + 1

			arg0_17:UpdateAttr(arg2_18, var0_17, var0_18, arg1_17)
		end
	end)
	arg0_17.attrUIList:align(#var0_17)
end

function var0_0.UpdateAttr(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	local var0_19 = arg2_19[arg3_19]
	local var1_19 = arg4_19:GetAttr(var0_19)

	setText(arg1_19:Find("name"), IslandShipAttr.ToChinese(var0_19))
	setText(arg1_19:Find("value"), var1_19)

	local var2_19 = arg4_19:GetAttrGrade(var0_19)
	local var3_19 = IslandShipAttr.Grade2Img(var2_19)

	arg1_19:Find("grade"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_19[1])
	arg1_19:Find("grade_bg"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("ui/IslandShipUI_atlas", var3_19[2])
end

function var0_0.OnShow(arg0_20, arg1_20)
	arg0_20:BlurPanel()

	arg0_20.selectNum = arg1_20.selectNum or 1
	arg0_20.selectedIds = arg1_20.selectedIds or {}
	arg0_20.attrType = arg1_20.attrType
	arg0_20.confirmFunc = arg1_20.confirmFunc
	arg0_20.cancelFunc = arg1_20.cancelFunc
	arg0_20.placeId = arg1_20.placeId
	arg0_20.showBenefits = arg1_20.showBenefits

	local var0_20 = arg1_20.emptyInfoTitle or ""

	setText(arg0_20.infoEmptyTitleTF, var0_20)

	arg0_20.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	local var1_20 = #arg0_20.selectedIds == 0 and arg0_20.selectNum == 1

	arg0_20:FlushShips(var1_20)
end

function var0_0.OnInitShip(arg0_21, arg1_21)
	local var0_21 = IslandSelectShipCard.New(arg1_21)

	arg0_21.cards[arg1_21] = var0_21
end

function var0_0.OnUpdateShip(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cards[arg2_22]
	end

	local var1_22 = arg0_22.showShips[arg1_22 + 1]
	local var2_22 = arg0_22.characterAgency:GetShipById(var1_22)

	onButton(arg0_22, var0_22.go, function()
		if var2_22:GetState() ~= IslandShip.STATE_NORMAL then
			return
		end

		if arg0_22.showId == var0_22.id then
			arg0_22.showId = nil
		else
			arg0_22.showId = var0_22.id
		end

		if table.contains(arg0_22.selectedIds, var0_22.id) then
			table.removebyvalue(arg0_22.selectedIds, var0_22.id)
		elseif arg0_22.selectNum == 1 then
			arg0_22.selectedIds = {
				var0_22.id
			}
		else
			if #arg0_22.selectedIds >= arg0_22.selectNum then
				return
			end

			table.insert(arg0_22.selectedIds, var0_22.id)
		end

		for iter0_23, iter1_23 in pairs(arg0_22.cards) do
			iter1_23:UpdateSelected(arg0_22.selectedIds)
		end

		arg0_22:FlushInfo()
	end, SFX_PANEL)
	var0_22:Update(var1_22, arg0_22.attrType, arg0_22.placeId, arg0_22.selectedIds)
end

function var0_0.FlushShips(arg0_24, arg1_24)
	arg0_24.showShips = arg0_24:GetShips()

	if #arg0_24.showShips ~= 0 and arg1_24 then
		local var0_24 = arg0_24:GetFristSelectableShipId()

		if var0_24 then
			arg0_24.showId = var0_24

			table.insert(arg0_24.selectedIds, var0_24)
		end
	end

	arg0_24.showId = arg0_24.selectedIds[1]

	setActive(arg0_24.shipContent, #arg0_24.showShips ~= 0)
	setActive(arg0_24.shipEmpty, #arg0_24.showShips == 0)
	arg0_24.shipRectCom:SetTotalCount(#arg0_24.showShips)
	arg0_24:FlushInfo()
end

function var0_0.GetFristSelectableShipId(arg0_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.showShips) do
		if arg0_25.characterAgency:GetShipById(iter1_25):GetState() == IslandShip.STATE_NORMAL then
			return iter1_25
		end
	end

	return nil
end

function var0_0.UpdateTimer(arg0_26, arg1_26)
	local var0_26 = arg1_26 - arg0_26.timeMgr:GetServerTime()

	setText(arg0_26.energyTimeTextTf, arg0_26.timeMgr:DescCDTime(var0_26))
end

function var0_0.StopTimer(arg0_27)
	if arg0_27.energyTimer ~= nil then
		arg0_27.energyTimer:Stop()

		arg0_27.energyTimer = nil
	end
end

function var0_0.FlushInfo(arg0_28)
	arg0_28.selectedTextCom.text = #arg0_28.selectedIds .. "/" .. arg0_28.selectNum

	arg0_28:FlushBenefits()
	setActive(arg0_28.sureBtn, arg0_28.showId)
	setActive(arg0_28.infoPanel, arg0_28.showId)
	setActive(arg0_28.infoEmptyTF, not arg0_28.showId)

	if not arg0_28.showId then
		return
	end

	local var0_28 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg0_28.showId)

	setText(arg0_28.nameTF, var0_28:GetName())
	setText(arg0_28.levelTF, string.format("-Lv.%d", var0_28:GetLevel()))
	arg0_28:UpdateAttrs(var0_28)

	local var1_28 = IslandShip.StaticGetPrefab(var0_28.id)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_28, "", arg0_28.shipIconTF)

	local var2_28 = var0_28:GetCurrentEnergy()
	local var3_28 = var0_28:GetMaxEnergy()

	setText(arg0_28:findTF("text", arg0_28.energyTF), var2_28 .. "/" .. var3_28)
	setSlider(arg0_28:findTF("energy_bar", arg0_28.energyTF), 0, 1, var2_28 / var3_28)

	if var2_28 ~= var3_28 then
		setActive(arg0_28.recoveryTimeTips, true)
		setActive(arg0_28.energyTimeTextTf, true)

		local var4_28 = var0_28:GetEnergyMaxTime()

		arg0_28:StopTimer()
		arg0_28:UpdateTimer(var4_28)

		arg0_28.energyTimer = Timer.New(function()
			arg0_28:UpdateTimer(var4_28)
		end, 1, -1)

		arg0_28.energyTimer:Start()
	else
		arg0_28:StopTimer()
		setActive(arg0_28.recoveryTimeTips, false)
		setActive(arg0_28.energyTimeTextTf, false)
	end

	local var5_28 = var0_28:GetSkill()
	local var6_28 = var5_28:IsUnlock()

	setActive(arg0_28.skill, var6_28)
	setActive(arg0_28.skillEmp, not var6_28)
	setText(arg0_28.skillEmpDes, i18n("island_need_star", var0_28:GetSkillUnlockLevel()))

	local var7_28 = var5_28:IsEffectiveInPlace(arg0_28.placeId)

	setActive(arg0_28.skillInuse, var7_28)
	setActive(arg0_28.skillUnuse, not var7_28)

	arg0_28.skillName.text = string.format("%s - %s", var5_28:GetName(), "[Lv." .. var5_28:GetLevel() .. "]")
	arg0_28.skillDes.text = var5_28:GetEffectDesc()
end

function var0_0.FlushBenefits(arg0_30)
	setActive(arg0_30.benefitsTF, arg0_30.showBenefits)

	if arg0_30.showBenefits then
		setFillAmount(arg0_30.mainAttrBar, arg0_30:GetShipsAttrProgress(IslandShipAttr.ATTRS[1]))
		arg0_30.subAttrUIList:align(#IslandShipAttr.ATTRS)
	end
end

function var0_0.GetShipsAttrProgress(arg0_31, arg1_31)
	local var0_31 = pg.island_chara_att.all[#pg.island_chara_att.all]
	local var1_31 = var0_31 * arg0_31.selectNum
	local var2_31 = 0

	for iter0_31, iter1_31 in ipairs(arg0_31.selectedIds) do
		var2_31 = var2_31 + (var0_31 - arg0_31.characterAgency:GetShipById(iter1_31):GetAttrGrade(arg1_31) + 1)
	end

	return var2_31 / var1_31
end

function var0_0.ToVShip(arg0_32, arg1_32)
	if not arg0_32.vship then
		arg0_32.vship = {}

		function arg0_32.vship.getNation()
			return arg0_32.vship.config.nationality
		end

		function arg0_32.vship.getShipType()
			return arg0_32.vship.config.type
		end

		function arg0_32.vship.getTeamType()
			return TeamType.GetTeamFromShipType(arg0_32.vship.config.type)
		end

		function arg0_32.vship.getRarity()
			return arg0_32.vship.config.rarity
		end
	end

	arg0_32.vship.config = arg1_32

	return arg0_32.vship
end

local function var1_0(arg0_37, arg1_37)
	if not arg1_37 or arg1_37 == "" then
		return true
	end

	local var0_37 = string.lower(string.gsub(arg1_37, "%.", "%%."))
	local var1_37 = IslandShip.StaticGetName(arg0_37)

	return string.find(string.lower(var1_37), var0_37)
end

local function var2_0(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg1_38
	local var1_38 = ShipGroup.getDefaultShipConfig(var0_38)
	local var2_38 = arg0_38:ToVShip(var1_38)
	local var3_38 = arg0_38.characterAgency:GetShipById(arg1_38)

	if ShipIndexConst.filterByCamp(var2_38, arg2_38.campIndex) and ShipIndexConst.filterByRarity(var2_38, arg2_38.rarityIndex) and IslandShipIndexLayer.filterByExtra(var3_38, arg2_38.extraIndex) then
		return true
	end

	return false
end

function var0_0.GetShips(arg0_39)
	local var0_39 = {}
	local var1_39 = arg0_39.characterAgency:GetShipsContainNpc()

	for iter0_39, iter1_39 in ipairs(var1_39) do
		if var1_0(iter1_39.id, arg0_39.searchKey) and var2_0(arg0_39, iter1_39.id, arg0_39.sortData) then
			table.insert(var0_39, iter1_39.id)
		end
	end

	local var2_39 = IslandShipIndexLayer.getSortFuncAndName(arg0_39.sortData.sortIndex, arg0_39.selectAsc)

	table.sort(var0_39, CompareFuncs(var2_39))

	return var0_39
end

function var0_0.OnDestroy(arg0_40)
	ClearLScrollrect(arg0_40.shipRectCom)
	arg0_40:StopTimer()
end

function var0_0.OnHide(arg0_41)
	arg0_41:UnBlurPanel()
end

return var0_0
