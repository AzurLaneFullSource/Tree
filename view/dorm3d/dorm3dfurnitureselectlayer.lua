local var0_0 = class("Dorm3dFurnitureSelectLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dFurnitureSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2.zoneList = arg0_2._tf:Find("ZoneList")

	setActive(arg0_2.zoneList, false)

	local var0_2 = arg0_2._tf:Find("Right/Panel/Container/Furnitures")

	arg0_2.furnitureScroll = var0_2:Find("Scroll/Content"):GetComponent("LScrollRect")
	arg0_2.furnitureEmpty = var0_2:Find("Empty")
	arg0_2.lableTrans = arg0_2._tf:Find("Main/Label")

	setActive(arg0_2.lableTrans, false)

	local var1_2 = arg0_2.furnitureScroll.prefabItem.transform

	setText(var1_2:Find("Unfit/Icon/Text"), i18n("dorm3d_furniture_unfit"))
	setText(var1_2:Find("Lack/Icon/Text"), i18n("ryza_tip_control_buff_not_obtain"))
end

function var0_0.SetSceneRoot(arg0_3, arg1_3)
	arg0_3.scene = arg1_3
end

function var0_0.SetRoom(arg0_4, arg1_4)
	arg0_4.room = arg1_4:clone()
end

function var0_0.didEnter(arg0_5)
	arg0_5.allZones = arg0_5.room:GetFurnitureZones()
	arg0_5.globalZones = _.select(arg0_5.allZones, function(arg0_6)
		return arg0_6:IsGlobal()
	end)
	arg0_5.normalZones = _.select(arg0_5.allZones, function(arg0_7)
		return not arg0_7:IsGlobal()
	end)

	local var0_5 = arg0_5.normalZones

	arg0_5.zoneIndex = 1

	local var1_5 = arg0_5.scene:GetAttachedFurnitureName()

	if var1_5 then
		table.Ipairs(var0_5, function(arg0_8, arg1_8)
			if arg1_8:GetWatchCameraName() == var1_5 then
				arg0_5.zoneIndex = arg0_8
			end
		end)
	end

	onButton(arg0_5, arg0_5._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Switch"), function()
		setActive(arg0_5.zoneList, true)
	end, SFX_PANEL)
	setActive(arg0_5._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Switch/New"), false)
	onButton(arg0_5, arg0_5.zoneList:Find("Mask"), function()
		setActive(arg0_5.zoneList, false)
	end)
	onButton(arg0_5, arg0_5._tf:Find("Top/Back"), function()
		arg0_5:onBackPressed()
	end)
	onButton(arg0_5, arg0_5._tf:Find("Right/Save"), function()
		arg0_5:ShowReplaceWindow()
	end, SFX_PANEL)

	local function var2_5(arg0_13)
		arg0_5._tf:Find("Right/Popup"):GetComponent(typeof(Image)).raycastTarget = not arg0_13
		arg0_5._tf:Find("Right/Collapse"):GetComponent(typeof(Image)).raycastTarget = arg0_13

		if arg0_13 then
			quickPlayAnimation(arg0_5._tf, "anim_dorm3d_furniture_in")
		else
			quickPlayAnimation(arg0_5._tf, "anim_dorm3d_furniture_hide")
		end
	end

	arg0_5._tf:Find("Right/Popup"):GetComponent(typeof(Image)).raycastTarget = false
	arg0_5._tf:Find("Right/Collapse"):GetComponent(typeof(Image)).raycastTarget = true

	onButton(arg0_5, arg0_5._tf:Find("Right/Popup"), function()
		var2_5(true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Right/Collapse"), function()
		var2_5(false)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Right/Auto"), function()
		arg0_5:AutoReplaceFurniture()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.lableTrans, function()
		arg0_5:CleanSlot()
	end, "ui-dorm_furniture_removal")

	arg0_5.furnitureItems = {}

	function arg0_5.furnitureScroll.onUpdateItem(arg0_18, arg1_18)
		arg0_18 = arg0_18 + 1
		arg0_5.furnitureItems[arg0_18] = arg1_18

		arg0_5:UpdateViewFurnitureItem(arg0_18)
	end

	function arg0_5.furnitureScroll.onReturnItem(arg0_19, arg1_19)
		if arg0_5.exited then
			return
		end

		arg0_19 = arg0_19 + 1
		arg0_5.furnitureItems[arg0_19] = nil
	end

	arg0_5.replaceFurnitures = {}

	arg0_5:UpdateDataZone()
	arg0_5:InitViewZoneList()
	arg0_5:InitViewTypeList()
	arg0_5.scene:EnterFurnitureWatchMode()
	arg0_5.scene:SwitchFurnitureZone(arg0_5.normalZones[arg0_5.zoneIndex])
	onNextTick(function()
		arg0_5.furnitureScroll.enabled = true

		arg0_5:UpdateView()
	end)

	arg0_5.updateHandler = UpdateBeat:CreateListener(function()
		xpcall(function()
			arg0_5:Update()
		end, function(...)
			errorMsg(debug.traceback(...))
		end)
	end)

	UpdateBeat:AddListener(arg0_5.updateHandler)
end

function var0_0.Update(arg0_24)
	if arg0_24.labelSettings then
		local var0_24 = arg0_24.scene:GetSlotByID(arg0_24.labelSettings.slotId)
		local var1_24 = arg0_24.scene:GetScreenPosition(var0_24.position)
		local var2_24 = arg0_24.scene:GetLocalPosition(var1_24, arg0_24.lableTrans.parent)

		setLocalPosition(arg0_24.lableTrans, var2_24)
	end
end

function var0_0.UpdateDataZone(arg0_25)
	local var0_25 = arg0_25.normalZones[arg0_25.zoneIndex]
	local var1_25 = {
		var0_25,
		unpack(arg0_25.globalZones)
	}
	local var2_25 = _.reduce(var1_25, {}, function(arg0_26, arg1_26)
		table.insertto(arg0_26, arg1_26:GetSlots())

		return arg0_26
	end)
	local var3_25 = {}

	_.each(var2_25, function(arg0_27)
		var3_25[arg0_27:GetType()] = true
	end)

	arg0_25.activeFurnitureTypes = _.keys(var3_25)

	var0_25:SortTypes(arg0_25.activeFurnitureTypes)

	arg0_25.furnitureType = arg0_25.activeFurnitureTypes[1]

	arg0_25:ResetSelectSetting()
	arg0_25:UpdateDataDisplayFurnitures()
	arg0_25:FilterDataFurnitures()
end

function var0_0.ResetSelectSetting(arg0_28)
	arg0_28.selectFurnitureId = nil
	arg0_28.selectSlotId = nil
end

function var0_0.UpdateDataDisplayFurnitures(arg0_29)
	local var0_29 = arg0_29.room
	local var1_29 = arg0_29.furnitureType
	local var2_29 = arg0_29.normalZones[arg0_29.zoneIndex]
	local var3_29 = {
		var2_29,
		unpack(arg0_29.globalZones)
	}
	local var4_29 = _.reduce(var3_29, {}, function(arg0_30, arg1_30)
		table.insertto(arg0_30, arg1_30:GetSlots())

		return arg0_30
	end)
	local var5_29 = var0_29:GetFurnitureIDList()
	local var6_29 = var0_29:GetFurnitures()
	local var7_29 = {}
	local var8_29 = {}

	_.each(var5_29, function(arg0_31)
		local var0_31 = Dorm3dFurniture.New({
			configId = arg0_31
		})

		if var0_31:GetType() ~= var1_29 then
			return
		end

		if not _.any(var4_29, function(arg0_32)
			return arg0_32:CanUseFurniture(var0_31)
		end) then
			return
		end

		table.insert(var8_29, {
			useable = 0,
			count = 0,
			id = arg0_31,
			template = var0_31
		})

		var7_29[arg0_31] = #var8_29
	end)
	_.each(var6_29, function(arg0_33)
		if arg0_33:GetType() ~= var1_29 then
			return
		end

		if not _.any(var4_29, function(arg0_34)
			return arg0_34:CanUseFurniture(arg0_33)
		end) then
			return
		end

		local var0_33 = arg0_33:GetConfigID()
		local var1_33 = var8_29[var7_29[var0_33]]

		var1_33.count = var1_33.count + 1

		if arg0_33:GetSlotID() == 0 then
			var1_33.useable = var1_33.useable + 1
		end

		var1_33.viewedFlag = Dorm3dFurniture.GetViewedFlag(var0_33) ~= 0
	end)

	var8_29 = _.filter(var8_29, function(arg0_35)
		return arg0_35.count > 0 or arg0_35.template:InShopTime()
	end)
	arg0_29.displayFurnitures = var8_29
end

function var0_0.FilterDataFurnitures(arg0_36)
	local var0_36 = {
		function(arg0_37)
			return arg0_37.useable > 0 and 0 or 1
		end,
		function(arg0_38)
			return -arg0_38.template:GetRarity()
		end,
		function(arg0_39)
			return -arg0_39.template:GetTargetSlotID()
		end,
		function(arg0_40)
			return -arg0_40.id
		end
	}

	table.sort(arg0_36.displayFurnitures, CompareFuncs(var0_36))
end

function var0_0.InitViewZoneList(arg0_41)
	local var0_41 = arg0_41.normalZones

	UIItemList.StaticAlign(arg0_41.zoneList:Find("List"), arg0_41.zoneList:Find("List"):GetChild(0), #var0_41, function(arg0_42, arg1_42, arg2_42)
		if arg0_42 ~= UIItemList.EventUpdate then
			return
		end

		arg1_42 = arg1_42 + 1

		local var0_42 = var0_41[arg1_42]

		arg2_42.name = var0_42:GetWatchCameraName()

		setText(arg2_42:Find("Name"), var0_42:GetName())
		onButton(arg0_41, arg2_42, function()
			arg0_41.zoneIndex = arg1_42

			arg0_41:UpdateDataZone()
			arg0_41.scene:SwitchFurnitureZone(var0_42)
			arg0_41:InitViewTypeList()
			arg0_41:UpdateView()
			quickPlayAnimation(arg0_41._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_41.zoneList, false)
		end, SFX_PANEL)
		setActive(arg2_42:Find("Line"), arg1_42 < #var0_41)
		setActive(arg2_42:Find("New"), false)
	end)
end

function var0_0.InitViewTypeList(arg0_44)
	UIItemList.StaticAlign(arg0_44._tf:Find("Right/Panel/Container/Types"), arg0_44._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_44.activeFurnitureTypes, function(arg0_45, arg1_45, arg2_45)
		if arg0_45 ~= UIItemList.EventUpdate then
			return
		end

		arg1_45 = arg1_45 + 1

		local var0_45 = arg0_44.activeFurnitureTypes[arg1_45]

		setText(arg2_45:Find("Name"), i18n(Dorm3dFurniture.TYPE2NAME[var0_45]))
		onButton(arg0_44, arg2_45, function()
			if arg0_44.furnitureType == var0_45 then
				return
			end

			arg0_44.furnitureType = var0_45

			arg0_44:ResetSelectSetting()
			arg0_44:UpdateDataDisplayFurnitures()
			arg0_44:FilterDataFurnitures()
			arg0_44:UpdateView()
			quickPlayAnimation(arg0_44._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_44.zoneList, false)
		end, SFX_PANEL)
	end)
end

function var0_0.UpdateView(arg0_47)
	local var0_47 = arg0_47.normalZones
	local var1_47 = var0_47[arg0_47.zoneIndex]

	setText(arg0_47._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Name"), var1_47:GetName())
	UIItemList.StaticAlign(arg0_47.zoneList:Find("List"), arg0_47.zoneList:Find("List"):GetChild(0), #var0_47, function(arg0_48, arg1_48, arg2_48)
		if arg0_48 ~= UIItemList.EventUpdate then
			return
		end

		arg1_48 = arg1_48 + 1

		local var0_48 = arg2_48:Find("Name"):GetComponent(typeof(Text)).color
		local var1_48 = arg0_47.zoneIndex == arg1_48 and Color.NewHex("39bfff") or Color.white

		var1_48.a = var0_48.a

		setTextColor(arg2_48:Find("Name"), var1_48)
		setActive(arg2_48:Find("New"), false)
	end)

	local var2_47 = arg0_47.room:GetFurnitures()

	;(function()
		local var0_49 = false

		table.Ipairs(arg0_47.normalZones, function(arg0_50, arg1_50)
			local var0_50 = false

			if arg1_50 ~= var1_47 then
				var0_50 = _.any(arg1_50:GetSlots(), function(arg0_51)
					return _.any(var2_47, function(arg0_52)
						if not arg0_51:CanUseFurniture(arg0_52) then
							return
						end

						return Dorm3dFurniture.GetViewedFlag(arg0_52:GetConfigID()) == 0
					end)
				end)
			end

			setActive(arg0_47.zoneList:Find("List"):GetChild(arg0_50 - 1):Find("New"), var0_50)

			var0_49 = var0_49 or var0_50
		end)
		setActive(arg0_47._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Switch/New"), var0_49)
	end)()
	setActive(arg0_47._tf:Find("Right/Panel/Container/Types"), #arg0_47.activeFurnitureTypes > 1)
	UIItemList.StaticAlign(arg0_47._tf:Find("Right/Panel/Container/Types"), arg0_47._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_47.activeFurnitureTypes, function(arg0_53, arg1_53, arg2_53)
		if arg0_53 ~= UIItemList.EventUpdate then
			return
		end

		arg1_53 = arg1_53 + 1

		local var0_53 = arg0_47.activeFurnitureTypes[arg1_53]

		setActive(arg2_53:Find("Selected"), arg0_47.furnitureType == var0_53)

		local var1_53 = _.any(var1_47:GetSlots(), function(arg0_54)
			return _.any(var2_47, function(arg0_55)
				if arg0_55:GetType() ~= var0_53 then
					return
				end

				if not arg0_54:CanUseFurniture(arg0_55) then
					return
				end

				return Dorm3dFurniture.GetViewedFlag(arg0_55:GetConfigID()) == 0
			end)
		end)

		setActive(arg2_53:Find("New"), var1_53)
	end)

	arg0_47.furnitureItems = {}

	arg0_47.furnitureScroll:SetTotalCount(#arg0_47.displayFurnitures)
	setActive(arg0_47.furnitureEmpty, #arg0_47.displayFurnitures == 0)

	if arg0_47.timerRefreshShop then
		arg0_47.timerRefreshShop:Stop()
	end

	arg0_47.timerRefreshShop = Timer.New(function()
		table.Foreach(arg0_47.furnitureItems, function(arg0_57, arg1_57)
			arg0_47:UpdateViewFurnitureItem(arg0_57)
		end)
	end, 1, -1)

	arg0_47.timerRefreshShop:Start()

	local var3_47 = {}
	local var4_47 = arg0_47.furnitureType
	local var5_47 = {
		var1_47,
		unpack(arg0_47.globalZones)
	}
	local var6_47 = _.reduce(var5_47, {}, function(arg0_58, arg1_58)
		table.insertto(arg0_58, arg1_58:GetSlots())

		return arg0_58
	end)
	local var7_47 = _.select(var6_47, function(arg0_59)
		return arg0_59:GetType() == var4_47
	end)

	_.each(var7_47, function(arg0_60)
		local var0_60 = arg0_60:GetConfigID()

		var3_47[var0_60] = 0
	end)

	local var8_47 = false

	if arg0_47.selectSlotId then
		local var9_47 = Dorm3dFurnitureSlot.New({
			configId = arg0_47.selectSlotId
		})

		if var9_47:GetType() == Dorm3dFurniture.TYPE.DECORATION then
			local var10_47 = arg0_47.room:GetFurnitures()

			if _.detect(var10_47, function(arg0_61)
				return arg0_61:GetSlotID() == var9_47:GetConfigID()
			end) then
				var8_47 = true
				arg0_47.labelSettings = {
					slotId = var9_47:GetConfigID()
				}
			end
		end
	end

	if not var8_47 then
		arg0_47.labelSettings = nil
	end

	setActive(arg0_47.lableTrans, var8_47)
	arg0_47.scene:DisplayFurnitureSlots(_.map(var7_47, function(arg0_62)
		return arg0_62:GetConfigID()
	end))
	arg0_47.scene:UpdateDisplaySlots(var3_47)
	arg0_47.scene:RefreshSlots(arg0_47.room)
end

function var0_0.UpdateViewFurnitureItem(arg0_63, arg1_63)
	local var0_63 = arg0_63.furnitureItems[arg1_63]
	local var1_63 = arg0_63.displayFurnitures[arg1_63]

	if not var0_63 then
		return
	end

	local var2_63 = tf(var0_63)

	var2_63.name = var1_63.id

	updateDorm3dIcon(var2_63:Find("Item/Dorm3dIconTpl"), Drop.New({
		type = DROP_TYPE_DORM3D_FURNITURE,
		id = var1_63.id,
		count = var1_63.count
	}))
	setText(var2_63:Find("Item/Name"), var1_63.template:GetName())

	local var3_63 = i18n("dorm3d_furniture_count", var1_63.useable .. "/" .. var1_63.count)

	if var1_63.useable < var1_63.count then
		var3_63 = i18n("dorm3d_furniture_used") .. var3_63
	elseif var1_63.count == 0 then
		var3_63 = i18n("dorm3d_furniture_lack") .. var3_63
	end

	setText(var2_63:Find("Item/Count"), var3_63)
	setActive(var2_63:Find("Selected"), arg0_63.selectFurnitureId == var1_63.id)
	setCanvasGroupAlpha(var2_63:Find("Item"), 1)

	local var4_63 = var1_63.template:IsValuable()
	local var5_63 = var1_63.template:IsSpecial()
	local var6_63 = 0

	if var5_63 then
		var6_63 = 2
	elseif var4_63 then
		var6_63 = 1
	end

	setActive(var2_63:Find("Item/BG/Pro"), var6_63 == 1)
	setActive(var2_63:Find("Item/LabelPro"), var6_63 == 1)
	setActive(var2_63:Find("Item/BG/SP"), var6_63 == 2)
	setActive(var2_63:Find("Item/LabelSP"), var6_63 == 2)
	setActive(var2_63:Find("Item/Action"), false)

	local var7_63 = var1_63.template:GetEndTime()
	local var8_63 = var7_63 > 0 and var7_63 > pg.TimeMgr.GetInstance():GetServerTime()

	setActive(var2_63:Find("TimeLimit"), var8_63)

	if var8_63 then
		setText(var2_63:Find("TimeLimit/Text"), skinCommdityTimeStamp(var7_63))
	end

	onButton(arg0_63, var2_63:Find("Item/Tip"), function()
		arg0_63:emit(Dorm3dFurnitureSelectMediator.SHOW_FURNITURE_ACESSES, {
			showGOBtn = true,
			title = i18n("courtyard_label_detail"),
			drop = {
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var1_63.id,
				count = var1_63.count
			},
			list = var1_63.template:GetAcesses()
		})
	end, SFX_PANEL)

	local var9_63 = var1_63.count > 0 and not var1_63.viewedFlag

	setActive(var2_63:Find("Item/New"), var9_63)

	if var9_63 then
		Dorm3dFurniture.SetViewedFlag(var1_63.id)
	end

	onButton(arg0_63, var2_63, function()
		if var1_63.count > 0 then
			setActive(var2_63:Find("Item/New"), false)

			var1_63.viewedFlag = true
		end

		local var0_65 = var1_63.template:GetTargetSlotID()

		arg0_63.selectSlotId = nil

		if var1_63.useable > 0 then
			arg0_63.room:ReplaceFurniture(var0_65, var1_63.id)
			table.insert(arg0_63.replaceFurnitures, {
				slotId = var0_65,
				furnitureId = var1_63.id
			})
			arg0_63:UpdateDataDisplayFurnitures()
			arg0_63:UpdateView()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
		elseif var1_63.useable < var1_63.count then
			arg0_63.selectSlotId = var0_65

			arg0_63:UpdateView()
		end
	end)

	local var10_63 = var1_63.count == 0 and var1_63.template:GetShopID() or 0

	setActive(var2_63:Find("GO"), var10_63 ~= 0)

	if var10_63 ~= 0 then
		local var11_63 = CommonCommodity.New({
			id = var10_63
		}, Goods.TYPE_SHOPSTREET)
		local var12_63, var13_63, var14_63 = var11_63:GetPrice()
		local var15_63 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var11_63:GetResType(),
			count = var12_63
		})
		local var16_63 = pg.shop_template[var10_63]

		onButton(arg0_63, var2_63:Find("GO"), function()
			local var0_66 = var1_63.template:GetEndTime()

			arg0_63:emit(Dorm3dFurnitureSelectMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var11_63:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var13_63,
					cost = "x" .. var15_63.count,
					old = var14_63,
					name = var1_63.template:GetName()
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var1_63.template,
				endTime = var0_66,
				onYes = function()
					if not var1_63.template:InShopTime() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_purchase_outtime"))

						return
					end

					arg0_63:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var10_63
					})
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.CleanSlot(arg0_68)
	if not arg0_68.selectSlotId then
		return
	end

	local var0_68 = arg0_68.selectSlotId

	arg0_68.room:ReplaceFurniture(var0_68, 0)
	table.insert(arg0_68.replaceFurnitures, {
		furnitureId = 0,
		slotId = var0_68
	})
	arg0_68:ResetSelectSetting()
	arg0_68:UpdateDataDisplayFurnitures()
	arg0_68:UpdateView()
end

function var0_0.OnReplaceFurnitureDone(arg0_69)
	arg0_69.replaceFurnitures = {}

	existCall(arg0_69.replaceFurnitureCallback)

	arg0_69.replaceFurnitureCallback = nil
end

function var0_0.OnReplaceFurnitureError(arg0_70)
	arg0_70.replaceFurnitureCallback = nil
end

function var0_0.AutoReplaceFurniture(arg0_71)
	local var0_71 = arg0_71.normalZones[arg0_71.zoneIndex]:GetSlots()

	_.each(var0_71, function(arg0_72)
		if arg0_72:GetType() == Dorm3dFurniture.TYPE.FLOOR or arg0_72:GetType() == Dorm3dFurniture.TYPE.WALLPAPER then
			return
		end

		local var0_72 = arg0_71.room:GetFurnitures()
		local var1_72 = _.detect(var0_72, function(arg0_73)
			return arg0_73:GetSlotID() == arg0_72:GetConfigID()
		end)

		if var1_72 and var1_72:GetConfigID() ~= arg0_72:GetDefaultFurniture() then
			return
		end

		local var2_72 = table.shallowCopy(var0_72)
		local var3_72 = {
			function(arg0_74)
				return arg0_74:GetSlotID() == 0 and arg0_72:CanUseFurniture(arg0_74) and 0 or 1
			end,
			function(arg0_75)
				return -arg0_75:GetRarity()
			end,
			function(arg0_76)
				return -arg0_76:GetConfigID()
			end
		}

		table.sort(var2_72, CompareFuncs(var3_72))

		local var4_72 = var2_72[1]

		if not var4_72 or var4_72:GetSlotID() ~= 0 or not arg0_72:CanUseFurniture(var4_72) then
			return
		end

		arg0_71.room:ReplaceFurniture(arg0_72:GetConfigID(), var4_72:GetConfigID())
		table.insert(arg0_71.replaceFurnitures, {
			slotId = arg0_72:GetConfigID(),
			furnitureId = var4_72:GetConfigID()
		})
	end)
	arg0_71:ResetSelectSetting()
	arg0_71:UpdateDataDisplayFurnitures()
	arg0_71:UpdateView()
end

function var0_0.ShowReplaceWindow(arg0_77, arg1_77, arg2_77)
	local var0_77 = arg0_77.replaceFurnitures

	if #var0_77 == 0 then
		return existCall(arg1_77)
	end

	arg0_77:emit(Dorm3dFurnitureSelectMediator.SHOW_CONFIRM_WINDOW, {
		title = i18n("title_info"),
		content = i18n("dorm3d_furniture_sure_save"),
		onYes = function()
			arg0_77:emit(GAME.APARTMENT_REPLACE_FURNITURE, {
				roomId = arg0_77.room:GetConfigID(),
				furnitures = var0_77
			})

			arg0_77.replaceFurnitureCallback = arg1_77
		end,
		onNo = arg2_77
	})
end

function var0_0.onBackPressed(arg0_79)
	seriesAsync({
		function(arg0_80)
			arg0_79:ShowReplaceWindow(arg0_80, arg0_80)
		end,
		function(arg0_81)
			GetOrAddComponent(arg0_79._tf, typeof(CanvasGroup)).alpha = 0

			arg0_79.scene:ExitFurnitureWatchMode(function()
				var0_0.super.onBackPressed(arg0_79)
			end)
		end
	})
end

function var0_0.willExit(arg0_83)
	arg0_83.furnitureScroll.enabled = false

	if arg0_83.timerRefreshShop then
		arg0_83.timerRefreshShop:Stop()
	end

	UpdateBeat:RemoveListener(arg0_83.updateHandler)
end

return var0_0
