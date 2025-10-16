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

	var3_25[Dorm3dFurniture.TYPE.SPECIAL] = nil
	arg0_25.activeFurnitureTypes = _.keys(var3_25)

	if _.any(arg0_25:GetDisplayFurnitures(nil), function(arg0_28)
		return arg0_28.template:IsSpecial()
	end) then
		table.insert(arg0_25.activeFurnitureTypes, Dorm3dFurniture.TYPE.SPECIAL)
	end

	var0_25:SortTypes(arg0_25.activeFurnitureTypes)

	arg0_25.furnitureType = arg0_25.activeFurnitureTypes[1]

	arg0_25:ResetSelectSetting()
	arg0_25:UpdateDataDisplayFurnitures()
	arg0_25:FilterDataFurnitures()
end

function var0_0.ResetSelectSetting(arg0_29)
	arg0_29.selectFurnitureId = nil
	arg0_29.selectSlotId = nil
end

function var0_0.GetDisplayFurnitures(arg0_30, arg1_30)
	local var0_30 = arg0_30.room
	local var1_30 = arg0_30.normalZones[arg0_30.zoneIndex]
	local var2_30 = {
		var1_30,
		unpack(arg0_30.globalZones)
	}
	local var3_30 = _.reduce(var2_30, {}, function(arg0_31, arg1_31)
		table.insertto(arg0_31, arg1_31:GetSlots())

		return arg0_31
	end)
	local var4_30 = var0_30:GetFurnitureIDList()
	local var5_30 = var0_30:GetFurnitures()
	local var6_30 = {}
	local var7_30 = {}

	_.each(var4_30, function(arg0_32)
		local var0_32 = Dorm3dFurniture.New({
			configId = arg0_32
		})

		if arg1_30 and var0_32:GetType() ~= arg1_30 then
			return
		end

		if not _.any(var3_30, function(arg0_33)
			return arg0_33:CanUseFurniture(var0_32)
		end) then
			if arg1_30 then
				warning("家具没有可用槽位，检查类型是否一致 FURNITUREID = " .. arg0_32)
			end

			return
		end

		table.insert(var7_30, {
			useable = 0,
			count = 0,
			id = arg0_32,
			template = var0_32
		})

		var6_30[arg0_32] = #var7_30
	end)
	_.each(var5_30, function(arg0_34)
		if arg1_30 and arg0_34:GetType() ~= arg1_30 then
			return
		end

		if not _.any(var3_30, function(arg0_35)
			return arg0_35:CanUseFurniture(arg0_34)
		end) then
			return
		end

		local var0_34 = arg0_34:GetConfigID()
		local var1_34 = var7_30[var6_30[var0_34]]

		var1_34.count = var1_34.count + 1

		if arg0_34:GetSlotID() == 0 then
			var1_34.useable = var1_34.useable + 1
		end

		var1_34.viewedFlag = Dorm3dFurniture.GetViewedFlag(var0_34) ~= 0
	end)

	var7_30 = _.filter(var7_30, function(arg0_36)
		return arg0_36.count > 0 or arg0_36.template:InShopTime()
	end)

	return var7_30
end

function var0_0.UpdateDataDisplayFurnitures(arg0_37)
	if arg0_37.furnitureType == Dorm3dFurniture.TYPE.SPECIAL then
		arg0_37.displayFurnitures = _.filter(arg0_37:GetDisplayFurnitures(nil), function(arg0_38)
			return arg0_38.template:IsSpecial()
		end)
	else
		arg0_37.displayFurnitures = arg0_37:GetDisplayFurnitures(arg0_37.furnitureType)
	end
end

function var0_0.FilterDataFurnitures(arg0_39)
	local var0_39 = {
		function(arg0_40)
			return arg0_40.useable > 0 and 0 or 1
		end,
		function(arg0_41)
			return -arg0_41.template:GetRarity()
		end,
		function(arg0_42)
			return -arg0_42.template:GetTargetSlotID()
		end,
		function(arg0_43)
			return -arg0_43.id
		end
	}

	table.sort(arg0_39.displayFurnitures, CompareFuncs(var0_39))
end

function var0_0.InitViewZoneList(arg0_44)
	local var0_44 = arg0_44.normalZones

	UIItemList.StaticAlign(arg0_44.zoneList:Find("List"), arg0_44.zoneList:Find("List"):GetChild(0), #var0_44, function(arg0_45, arg1_45, arg2_45)
		if arg0_45 ~= UIItemList.EventUpdate then
			return
		end

		arg1_45 = arg1_45 + 1

		local var0_45 = var0_44[arg1_45]

		arg2_45.name = var0_45:GetWatchCameraName()

		setText(arg2_45:Find("Name"), var0_45:GetName())
		onButton(arg0_44, arg2_45, function()
			arg0_44.zoneIndex = arg1_45

			arg0_44:UpdateDataZone()
			arg0_44.scene:SwitchFurnitureZone(var0_45)
			arg0_44:InitViewTypeList()
			arg0_44:UpdateView()
			quickPlayAnimation(arg0_44._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_44.zoneList, false)
		end, SFX_PANEL)
		setActive(arg2_45:Find("Line"), arg1_45 < #var0_44)
		setActive(arg2_45:Find("New"), false)
	end)
end

function var0_0.InitViewTypeList(arg0_47)
	UIItemList.StaticAlign(arg0_47._tf:Find("Right/Panel/Container/Types"), arg0_47._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_47.activeFurnitureTypes, function(arg0_48, arg1_48, arg2_48)
		if arg0_48 ~= UIItemList.EventUpdate then
			return
		end

		arg1_48 = arg1_48 + 1

		local var0_48 = arg0_47.activeFurnitureTypes[arg1_48]

		setText(arg2_48:Find("Name"), i18n(Dorm3dFurniture.TYPE2NAME[var0_48]))
		onButton(arg0_47, arg2_48, function()
			if arg0_47.furnitureType == var0_48 then
				return
			end

			arg0_47.furnitureType = var0_48

			arg0_47:ResetSelectSetting()
			arg0_47:UpdateDataDisplayFurnitures()
			arg0_47:FilterDataFurnitures()
			arg0_47:UpdateView()
			quickPlayAnimation(arg0_47._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_47.zoneList, false)
		end, SFX_PANEL)
	end)
end

function var0_0.UpdateView(arg0_50)
	local var0_50 = arg0_50.normalZones
	local var1_50 = var0_50[arg0_50.zoneIndex]

	setText(arg0_50._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Name"), var1_50:GetName())
	UIItemList.StaticAlign(arg0_50.zoneList:Find("List"), arg0_50.zoneList:Find("List"):GetChild(0), #var0_50, function(arg0_51, arg1_51, arg2_51)
		if arg0_51 ~= UIItemList.EventUpdate then
			return
		end

		arg1_51 = arg1_51 + 1

		local var0_51 = arg2_51:Find("Name"):GetComponent(typeof(Text)).color
		local var1_51 = arg0_50.zoneIndex == arg1_51 and Color.NewHex("39bfff") or Color.white

		var1_51.a = var0_51.a

		setTextColor(arg2_51:Find("Name"), var1_51)
		setActive(arg2_51:Find("New"), false)
	end)

	local var2_50 = arg0_50.room:GetFurnitures()

	;(function()
		local var0_52 = false

		table.Ipairs(arg0_50.normalZones, function(arg0_53, arg1_53)
			local var0_53 = false

			if arg1_53 ~= var1_50 then
				var0_53 = _.any(arg1_53:GetSlots(), function(arg0_54)
					return _.any(var2_50, function(arg0_55)
						if not arg0_54:CanUseFurniture(arg0_55) then
							return
						end

						return Dorm3dFurniture.GetViewedFlag(arg0_55:GetConfigID()) == 0
					end)
				end)
			end

			setActive(arg0_50.zoneList:Find("List"):GetChild(arg0_53 - 1):Find("New"), var0_53)

			var0_52 = var0_52 or var0_53
		end)
		setActive(arg0_50._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Switch/New"), var0_52)
	end)()
	setActive(arg0_50._tf:Find("Right/Panel/Container/Types"), #arg0_50.activeFurnitureTypes > 1)
	UIItemList.StaticAlign(arg0_50._tf:Find("Right/Panel/Container/Types"), arg0_50._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_50.activeFurnitureTypes, function(arg0_56, arg1_56, arg2_56)
		if arg0_56 ~= UIItemList.EventUpdate then
			return
		end

		arg1_56 = arg1_56 + 1

		local var0_56 = arg0_50.activeFurnitureTypes[arg1_56]

		setActive(arg2_56:Find("Selected"), arg0_50.furnitureType == var0_56)

		local var1_56 = _.any(var1_50:GetSlots(), function(arg0_57)
			return _.any(var2_50, function(arg0_58)
				if arg0_58:GetType() ~= var0_56 then
					return
				end

				if not arg0_57:CanUseFurniture(arg0_58) then
					return
				end

				return Dorm3dFurniture.GetViewedFlag(arg0_58:GetConfigID()) == 0
			end)
		end)

		setActive(arg2_56:Find("New"), var1_56)
	end)

	arg0_50.furnitureItems = {}

	arg0_50.furnitureScroll:SetTotalCount(#arg0_50.displayFurnitures)
	setActive(arg0_50.furnitureEmpty, #arg0_50.displayFurnitures == 0)

	if arg0_50.timerRefreshShop then
		arg0_50.timerRefreshShop:Stop()
	end

	arg0_50.timerRefreshShop = Timer.New(function()
		table.Foreach(arg0_50.furnitureItems, function(arg0_60, arg1_60)
			arg0_50:UpdateViewFurnitureItem(arg0_60)
		end)
	end, 1, -1)

	arg0_50.timerRefreshShop:Start()

	local var3_50 = {}
	local var4_50 = arg0_50.furnitureType
	local var5_50 = {
		var1_50,
		unpack(arg0_50.globalZones)
	}
	local var6_50 = _.reduce(var5_50, {}, function(arg0_61, arg1_61)
		table.insertto(arg0_61, arg1_61:GetSlots())

		return arg0_61
	end)
	local var7_50 = _.select(var6_50, function(arg0_62)
		return arg0_62:GetType() == var4_50
	end)

	_.each(var7_50, function(arg0_63)
		local var0_63 = arg0_63:GetConfigID()

		var3_50[var0_63] = 0
	end)

	local var8_50 = false

	if arg0_50.selectSlotId then
		local var9_50 = Dorm3dFurnitureSlot.New({
			configId = arg0_50.selectSlotId
		})

		if var9_50:GetType() == Dorm3dFurniture.TYPE.DECORATION or var9_50:GetType() == Dorm3dFurniture.TYPE.SPECIAL then
			local var10_50 = arg0_50.room:GetFurnitures()

			if _.detect(var10_50, function(arg0_64)
				return arg0_64:GetSlotID() == var9_50:GetConfigID()
			end) then
				arg0_50:CleanSlot()
			end
		end
	end

	if not var8_50 then
		arg0_50.labelSettings = nil
	end

	setActive(arg0_50.lableTrans, var8_50)
	arg0_50.scene:DisplayFurnitureSlots(_.map(var7_50, function(arg0_65)
		return arg0_65:GetConfigID()
	end))
	arg0_50.scene:UpdateDisplaySlots(var3_50)
	arg0_50.scene:RefreshSlots(arg0_50.room)
end

function var0_0.UpdateViewFurnitureItem(arg0_66, arg1_66)
	local var0_66 = arg0_66.furnitureItems[arg1_66]
	local var1_66 = arg0_66.displayFurnitures[arg1_66]

	if not var0_66 then
		return
	end

	local var2_66 = tf(var0_66)

	var2_66.name = var1_66.id

	updateCustomDrop(var2_66:Find("Item/Dorm3dIconTpl"), Drop.New({
		type = DROP_TYPE_DORM3D_FURNITURE,
		id = var1_66.id,
		count = var1_66.count
	}))
	setText(var2_66:Find("Item/Name"), var1_66.template:GetName())

	local var3_66 = i18n("dorm3d_furniture_count", var1_66.useable .. "/" .. var1_66.count)

	if var1_66.useable < var1_66.count then
		var3_66 = i18n("dorm3d_furniture_used") .. var3_66
	elseif var1_66.count == 0 then
		var3_66 = i18n("dorm3d_furniture_lack") .. var3_66
	end

	setText(var2_66:Find("Item/Count"), var3_66)
	setActive(var2_66:Find("Selected"), arg0_66.selectFurnitureId == var1_66.id)
	setCanvasGroupAlpha(var2_66:Find("Item"), 1)

	local var4_66 = var1_66.template:IsValuable()
	local var5_66 = var1_66.template:IsSpecial()
	local var6_66 = 0

	if var5_66 then
		var6_66 = 2
	elseif var4_66 then
		var6_66 = 1
	end

	setActive(var2_66:Find("Item/BG/Pro"), var6_66 == 1)
	setActive(var2_66:Find("Item/LabelPro"), var6_66 == 1)
	setActive(var2_66:Find("Item/BG/SP"), var6_66 == 2)
	setActive(var2_66:Find("Item/LabelSP"), var6_66 == 2)
	setActive(var2_66:Find("Item/Action"), false)

	local var7_66 = var1_66.template:GetEndTime()
	local var8_66 = var1_66.count == 0 and var7_66 > 0 and var7_66 > pg.TimeMgr.GetInstance():GetServerTime()

	setActive(var2_66:Find("TimeLimit"), var8_66)

	if var8_66 then
		setText(var2_66:Find("TimeLimit/Text"), skinCommdityTimeStamp(var7_66))
	end

	onButton(arg0_66, var2_66:Find("Item/Tip"), function()
		arg0_66:emit(Dorm3dFurnitureSelectMediator.SHOW_FURNITURE_ACESSES, {
			showGOBtn = true,
			title = i18n("courtyard_label_detail"),
			drop = {
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var1_66.id,
				count = var1_66.count
			},
			list = var1_66.template:GetAcesses()
		})
	end, SFX_PANEL)

	local var9_66 = var1_66.count > 0 and not var1_66.viewedFlag

	setActive(var2_66:Find("Item/New"), var9_66)

	if var9_66 then
		Dorm3dFurniture.SetViewedFlag(var1_66.id)
	end

	onButton(arg0_66, var2_66, function()
		if var1_66.count > 0 then
			setActive(var2_66:Find("Item/New"), false)

			var1_66.viewedFlag = true
		end

		local var0_68 = var1_66.template:GetTargetSlotID()

		arg0_66.selectSlotId = nil

		if var1_66.useable > 0 then
			arg0_66.room:ReplaceFurniture(var0_68, var1_66.id)
			table.insert(arg0_66.replaceFurnitures, {
				slotId = var0_68,
				furnitureId = var1_66.id
			})
			arg0_66:UpdateDataDisplayFurnitures()
			arg0_66:UpdateView()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
		elseif var1_66.useable < var1_66.count then
			arg0_66.selectSlotId = var0_68

			arg0_66:UpdateView()
		end
	end)

	local var10_66 = var1_66.count == 0 and var1_66.template:GetShopID() or 0

	setActive(var2_66:Find("GO"), var10_66 ~= 0)

	if var10_66 ~= 0 then
		local var11_66 = CommonCommodity.New({
			id = var10_66
		}, Goods.TYPE_SHOPSTREET)
		local var12_66, var13_66, var14_66 = var11_66:GetPrice()
		local var15_66 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var11_66:GetResType(),
			count = var12_66
		})
		local var16_66 = pg.shop_template[var10_66]

		onButton(arg0_66, var2_66:Find("GO"), function()
			local var0_69 = var1_66.template:GetEndTime()

			arg0_66:emit(Dorm3dFurnitureSelectMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var11_66:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var13_66,
					cost = var15_66.count,
					old = var14_66,
					name = var1_66.template:GetName()
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var1_66.template,
				endTime = var0_69,
				onYes = function()
					if not var1_66.template:InShopTime() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_purchase_outtime"))

						return
					end

					arg0_66:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var10_66
					})
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.CleanSlot(arg0_71)
	if not arg0_71.selectSlotId then
		return
	end

	local var0_71 = arg0_71.selectSlotId

	arg0_71.room:ReplaceFurniture(var0_71, 0)
	table.insert(arg0_71.replaceFurnitures, {
		furnitureId = 0,
		slotId = var0_71
	})
	arg0_71:ResetSelectSetting()
	arg0_71:UpdateDataDisplayFurnitures()
	arg0_71:UpdateView()
end

function var0_0.OnReplaceFurnitureDone(arg0_72)
	arg0_72.replaceFurnitures = {}

	existCall(arg0_72.replaceFurnitureCallback)

	arg0_72.replaceFurnitureCallback = nil
end

function var0_0.OnReplaceFurnitureError(arg0_73)
	arg0_73.replaceFurnitureCallback = nil
end

function var0_0.AutoReplaceFurniture(arg0_74)
	local var0_74 = arg0_74.normalZones[arg0_74.zoneIndex]:GetSlots()

	_.each(var0_74, function(arg0_75)
		if arg0_75:GetType() == Dorm3dFurniture.TYPE.FLOOR or arg0_75:GetType() == Dorm3dFurniture.TYPE.WALLPAPER then
			return
		end

		local var0_75 = arg0_74.room:GetFurnitures()
		local var1_75 = _.detect(var0_75, function(arg0_76)
			return arg0_76:GetSlotID() == arg0_75:GetConfigID()
		end)

		if var1_75 and var1_75:GetConfigID() ~= arg0_75:GetDefaultFurniture() then
			return
		end

		local var2_75 = table.shallowCopy(var0_75)
		local var3_75 = {
			function(arg0_77)
				return arg0_77:GetSlotID() == 0 and arg0_75:CanUseFurniture(arg0_77) and 0 or 1
			end,
			function(arg0_78)
				return -arg0_78:GetRarity()
			end,
			function(arg0_79)
				return -arg0_79:GetConfigID()
			end
		}

		table.sort(var2_75, CompareFuncs(var3_75))

		local var4_75 = var2_75[1]

		if not var4_75 or var4_75:GetSlotID() ~= 0 or not arg0_75:CanUseFurniture(var4_75) then
			return
		end

		arg0_74.room:ReplaceFurniture(arg0_75:GetConfigID(), var4_75:GetConfigID())
		table.insert(arg0_74.replaceFurnitures, {
			slotId = arg0_75:GetConfigID(),
			furnitureId = var4_75:GetConfigID()
		})
	end)
	arg0_74:ResetSelectSetting()
	arg0_74:UpdateDataDisplayFurnitures()
	arg0_74:UpdateView()
end

function var0_0.ShowReplaceWindow(arg0_80, arg1_80, arg2_80)
	local var0_80 = arg0_80.replaceFurnitures

	if #var0_80 == 0 then
		return existCall(arg1_80)
	end

	arg0_80:emit(Dorm3dFurnitureSelectMediator.SHOW_CONFIRM_WINDOW, {
		title = i18n("title_info"),
		content = i18n("dorm3d_furniture_sure_save"),
		onYes = function()
			arg0_80:emit(GAME.APARTMENT_REPLACE_FURNITURE, {
				roomId = arg0_80.room:GetConfigID(),
				furnitures = var0_80
			})

			arg0_80.replaceFurnitureCallback = arg1_80
		end,
		onNo = arg2_80
	})
end

function var0_0.onBackPressed(arg0_82)
	seriesAsync({
		function(arg0_83)
			arg0_82:ShowReplaceWindow(arg0_83, arg0_83)
		end,
		function(arg0_84)
			GetOrAddComponent(arg0_82._tf, typeof(CanvasGroup)).alpha = 0

			arg0_82.scene:ExitFurnitureWatchMode(function()
				var0_0.super.onBackPressed(arg0_82)
			end)
		end
	})
end

function var0_0.willExit(arg0_86)
	arg0_86.furnitureScroll.enabled = false

	if arg0_86.timerRefreshShop then
		arg0_86.timerRefreshShop:Stop()
	end

	UpdateBeat:RemoveListener(arg0_86.updateHandler)
end

return var0_0
