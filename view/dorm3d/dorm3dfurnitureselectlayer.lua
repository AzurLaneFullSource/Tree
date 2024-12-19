local var0_0 = class("Dorm3dFurnitureSelectLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dFurnitureSelectUI"
end

var0_0.SELECT_MODE = {
	SLOT = 1,
	FURNITURE = 2,
	NONE = 0
}

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
end

function var0_0.UpdateDataZone(arg0_21)
	local var0_21 = arg0_21.normalZones[arg0_21.zoneIndex]
	local var1_21 = {
		var0_21,
		unpack(arg0_21.globalZones)
	}
	local var2_21 = _.reduce(var1_21, {}, function(arg0_22, arg1_22)
		table.insertto(arg0_22, arg1_22:GetSlots())

		return arg0_22
	end)
	local var3_21 = {}
	local var4_21 = 99

	_.each(var2_21, function(arg0_23)
		var3_21[arg0_23:GetType()] = true
		var4_21 = math.min(var4_21, arg0_23:GetType())
	end)

	arg0_21.activeFurnitureTypes = _.keys(var3_21)

	var0_21:SortTypes(arg0_21.activeFurnitureTypes)

	arg0_21.furnitureType = arg0_21.activeFurnitureTypes[1]

	arg0_21:UpdateDataDisplayFurnitures()
end

function var0_0.UpdateDataDisplayFurnitures(arg0_24)
	local var0_24 = arg0_24.room
	local var1_24 = arg0_24.furnitureType

	arg0_24.selectMode = var0_0.SELECT_MODE.NONE
	arg0_24.selectFurnitureId = nil
	arg0_24.selectSlotId = nil

	local var2_24 = arg0_24.normalZones[arg0_24.zoneIndex]
	local var3_24 = {
		var2_24,
		unpack(arg0_24.globalZones)
	}
	local var4_24 = _.reduce(var3_24, {}, function(arg0_25, arg1_25)
		table.insertto(arg0_25, arg1_25:GetSlots())

		return arg0_25
	end)
	local var5_24 = var0_24:GetFurnitureIDList()
	local var6_24 = var0_24:GetFurnitures()
	local var7_24 = {}
	local var8_24 = {}

	_.each(var5_24, function(arg0_26)
		local var0_26 = Dorm3dFurniture.New({
			configId = arg0_26
		})

		if var0_26:GetType() ~= var1_24 then
			return
		end

		if not _.any(var4_24, function(arg0_27)
			return arg0_27:CanUseFurniture(var0_26)
		end) then
			return
		end

		table.insert(var8_24, {
			useable = 0,
			count = 0,
			id = arg0_26,
			template = var0_26
		})

		var7_24[arg0_26] = #var8_24
	end)
	_.each(var6_24, function(arg0_28)
		if arg0_28:GetType() ~= var1_24 then
			return
		end

		if not _.any(var4_24, function(arg0_29)
			return arg0_29:CanUseFurniture(arg0_28)
		end) then
			return
		end

		local var0_28 = arg0_28:GetConfigID()
		local var1_28 = var8_24[var7_24[var0_28]]

		var1_28.count = var1_28.count + 1

		if arg0_28:GetSlotID() == 0 then
			var1_28.useable = var1_28.useable + 1
		end
	end)

	var8_24 = _.filter(var8_24, function(arg0_30)
		return arg0_30.count > 0 or arg0_30.template:InShopTime()
	end)
	arg0_24.displayFurnitures = var8_24

	arg0_24:FilterDataFurnitures()
end

function var0_0.FilterDataFurnitures(arg0_31)
	local var0_31 = {
		function(arg0_32)
			return arg0_32.useable > 0 and 0 or 1
		end,
		function(arg0_33)
			return -arg0_33.template:GetRarity()
		end,
		function(arg0_34)
			return -arg0_34.id
		end
	}

	if arg0_31.selectMode == var0_0.SELECT_MODE.SLOT then
		local var1_31 = Dorm3dFurnitureSlot.New({
			configId = arg0_31.selectSlotId
		})

		_.each(arg0_31.displayFurnitures, function(arg0_35)
			local var0_35 = arg0_35.template

			arg0_35.fit = var1_31:CanUseFurniture(var0_35)
		end)
		table.insert(var0_31, function(arg0_36)
			return arg0_36.fit and 0 or 1
		end)
	end

	table.sort(arg0_31.displayFurnitures, CompareFuncs(var0_31))
end

function var0_0.InitViewZoneList(arg0_37)
	local var0_37 = arg0_37.normalZones

	UIItemList.StaticAlign(arg0_37.zoneList:Find("List"), arg0_37.zoneList:Find("List"):GetChild(0), #var0_37, function(arg0_38, arg1_38, arg2_38)
		if arg0_38 ~= UIItemList.EventUpdate then
			return
		end

		arg1_38 = arg1_38 + 1

		local var0_38 = var0_37[arg1_38]

		arg2_38.name = var0_38:GetWatchCameraName()

		setText(arg2_38:Find("Name"), var0_38:GetName())
		onButton(arg0_37, arg2_38, function()
			arg0_37.zoneIndex = arg1_38

			arg0_37:UpdateDataZone()
			arg0_37.scene:SwitchFurnitureZone(var0_38)
			arg0_37:InitViewTypeList()
			arg0_37:UpdateView()
			quickPlayAnimation(arg0_37._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_37.zoneList, false)
		end, SFX_PANEL)
		setActive(arg2_38:Find("Line"), arg1_38 < #var0_37)
		setActive(arg2_38:Find("New"), false)
	end)
end

function var0_0.InitViewTypeList(arg0_40)
	UIItemList.StaticAlign(arg0_40._tf:Find("Right/Panel/Container/Types"), arg0_40._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_40.activeFurnitureTypes, function(arg0_41, arg1_41, arg2_41)
		if arg0_41 ~= UIItemList.EventUpdate then
			return
		end

		arg1_41 = arg1_41 + 1

		local var0_41 = arg0_40.activeFurnitureTypes[arg1_41]

		setText(arg2_41:Find("Name"), i18n(Dorm3dFurniture.TYPE2NAME[var0_41]))
		onButton(arg0_40, arg2_41, function()
			if arg0_40.furnitureType == var0_41 then
				return
			end

			arg0_40.furnitureType = var0_41

			arg0_40:UpdateDataDisplayFurnitures()
			arg0_40:UpdateView()
			quickPlayAnimation(arg0_40._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_40.zoneList, false)
		end, SFX_PANEL)
	end)
end

function var0_0.UpdateView(arg0_43)
	local var0_43 = arg0_43.normalZones
	local var1_43 = var0_43[arg0_43.zoneIndex]

	setText(arg0_43._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Name"), var1_43:GetName())
	UIItemList.StaticAlign(arg0_43.zoneList:Find("List"), arg0_43.zoneList:Find("List"):GetChild(0), #var0_43, function(arg0_44, arg1_44, arg2_44)
		if arg0_44 ~= UIItemList.EventUpdate then
			return
		end

		arg1_44 = arg1_44 + 1

		local var0_44 = arg2_44:Find("Name"):GetComponent(typeof(Text)).color
		local var1_44 = arg0_43.zoneIndex == arg1_44 and Color.NewHex("39bfff") or Color.white

		var1_44.a = var0_44.a

		setTextColor(arg2_44:Find("Name"), var1_44)
		setActive(arg2_44:Find("New"), false)
	end)
	;(function()
		local var0_45 = arg0_43.room:GetFurnitures()
		local var1_45 = false

		table.Ipairs(arg0_43.normalZones, function(arg0_46, arg1_46)
			local var0_46 = false

			if arg1_46 ~= var1_43 then
				var0_46 = _.any(arg1_46:GetSlots(), function(arg0_47)
					return _.any(var0_45, function(arg0_48)
						if not arg0_47:CanUseFurniture(arg0_48) then
							return
						end

						return Dorm3dFurniture.GetViewedFlag(arg0_48:GetConfigID()) == 0
					end)
				end)
			end

			setActive(arg0_43.zoneList:Find("List"):GetChild(arg0_46 - 1):Find("New"), var0_46)

			var1_45 = var1_45 or var0_46
		end)
		setActive(arg0_43._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Switch/New"), var1_45)
	end)()
	setActive(arg0_43._tf:Find("Right/Panel/Container/Types"), #arg0_43.activeFurnitureTypes > 1)
	UIItemList.StaticAlign(arg0_43._tf:Find("Right/Panel/Container/Types"), arg0_43._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_43.activeFurnitureTypes, function(arg0_49, arg1_49, arg2_49)
		if arg0_49 ~= UIItemList.EventUpdate then
			return
		end

		arg1_49 = arg1_49 + 1

		local var0_49 = arg0_43.activeFurnitureTypes[arg1_49]

		setActive(arg2_49:Find("Selected"), arg0_43.furnitureType == var0_49)
	end)

	arg0_43.furnitureItems = {}

	arg0_43.furnitureScroll:SetTotalCount(#arg0_43.displayFurnitures)
	setActive(arg0_43.furnitureEmpty, #arg0_43.displayFurnitures == 0)

	if arg0_43.timerRefreshShop then
		arg0_43.timerRefreshShop:Stop()
	end

	arg0_43.timerRefreshShop = Timer.New(function()
		table.Foreach(arg0_43.furnitureItems, function(arg0_51, arg1_51)
			arg0_43:UpdateViewFurnitureItem(arg0_51)
		end)
	end, 1, -1)

	arg0_43.timerRefreshShop:Start()

	local var2_43 = {}
	local var3_43 = arg0_43.furnitureType
	local var4_43 = {
		var1_43,
		unpack(arg0_43.globalZones)
	}
	local var5_43 = _.reduce(var4_43, {}, function(arg0_52, arg1_52)
		table.insertto(arg0_52, arg1_52:GetSlots())

		return arg0_52
	end)
	local var6_43 = _.select(var5_43, function(arg0_53)
		return arg0_53:GetType() == var3_43
	end)

	_.each(var6_43, function(arg0_54)
		local var0_54 = arg0_54:GetConfigID()

		if arg0_43.selectMode == var0_0.SELECT_MODE.NONE then
			var2_43[var0_54] = 0
		elseif arg0_43.selectMode == var0_0.SELECT_MODE.FURNITURE then
			local var1_54 = arg0_54:CanUseFurniture(Dorm3dFurniture.New({
				configId = arg0_43.selectFurnitureId
			}))

			var2_43[var0_54] = var1_54 and 1 or 2
		elseif arg0_43.selectMode == var0_0.SELECT_MODE.SLOT then
			var2_43[var0_54] = arg0_43.selectSlotId == var0_54 and 1 or 0
		end
	end)

	local var7_43 = false

	if arg0_43.selectMode == var0_0.SELECT_MODE.SLOT then
		local var8_43 = Dorm3dFurnitureSlot.New({
			configId = arg0_43.selectSlotId
		})

		if var8_43:GetType() == Dorm3dFurniture.TYPE.DECORATION then
			local var9_43 = arg0_43.room:GetFurnitures()

			if _.detect(var9_43, function(arg0_55)
				return arg0_55:GetSlotID() == var8_43:GetConfigID()
			end) then
				local var10_43 = arg0_43.scene:GetSlotByID(var8_43:GetConfigID())
				local var11_43 = arg0_43.scene:GetScreenPosition(var10_43.position)
				local var12_43 = arg0_43.scene:GetLocalPosition(var11_43, arg0_43.lableTrans.parent)

				setLocalPosition(arg0_43.lableTrans, var12_43)

				var7_43 = true
			end
		end
	end

	setActive(arg0_43.lableTrans, var7_43)
	arg0_43.scene:DisplayFurnitureSlots(_.map(var6_43, function(arg0_56)
		return arg0_56:GetConfigID()
	end))
	arg0_43.scene:UpdateDisplaySlots(var2_43)
	arg0_43.scene:RefreshSlots(arg0_43.room)
end

function var0_0.UpdateViewFurnitureItem(arg0_57, arg1_57)
	local var0_57 = arg0_57.furnitureItems[arg1_57]
	local var1_57 = arg0_57.displayFurnitures[arg1_57]

	if not var0_57 then
		return
	end

	local var2_57 = tf(var0_57)

	var2_57.name = var1_57.id

	updateDorm3dIcon(var2_57:Find("Item/Dorm3dIconTpl"), Drop.New({
		type = DROP_TYPE_DORM3D_FURNITURE,
		id = var1_57.id,
		count = var1_57.count
	}))
	setText(var2_57:Find("Item/Name"), var1_57.template:GetName())

	local var3_57 = i18n("dorm3d_furniture_count", var1_57.useable .. "/" .. var1_57.count)

	if var1_57.useable < var1_57.count then
		var3_57 = i18n("dorm3d_furniture_used") .. var3_57
	elseif var1_57.count == 0 then
		var3_57 = i18n("dorm3d_furniture_lack") .. var3_57
	end

	setText(var2_57:Find("Item/Count"), var3_57)
	setActive(var2_57:Find("Selected"), arg0_57.selectFurnitureId == var1_57.id)

	local var4_57 = arg0_57.selectMode == var0_0.SELECT_MODE.SLOT and not var1_57.fit

	setActive(var2_57:Find("Unfit"), var4_57)
	setCanvasGroupAlpha(var2_57:Find("Item"), var4_57 and 0.4 or 1)

	local var5_57 = var1_57.template:IsValuable()
	local var6_57 = var1_57.template:IsSpecial()
	local var7_57 = 0

	if var6_57 then
		var7_57 = 2
	elseif var5_57 then
		var7_57 = 1
	end

	setActive(var2_57:Find("Item/BG/Pro"), var7_57 == 1)
	setActive(var2_57:Find("Item/LabelPro"), var7_57 == 1)
	setActive(var2_57:Find("Item/BG/SP"), var7_57 == 2)
	setActive(var2_57:Find("Item/LabelSP"), var7_57 == 2)
	setActive(var2_57:Find("Item/Action"), false)

	local var8_57 = var1_57.template:GetEndTime()
	local var9_57 = var8_57 > 0 and var8_57 > pg.TimeMgr.GetInstance():GetServerTime()

	setActive(var2_57:Find("TimeLimit"), var9_57)

	if var9_57 then
		setText(var2_57:Find("TimeLimit/Text"), skinCommdityTimeStamp(var8_57))
	end

	onButton(arg0_57, var2_57:Find("Item/Tip"), function()
		arg0_57:emit(Dorm3dFurnitureSelectMediator.SHOW_FURNITURE_ACESSES, {
			showGOBtn = true,
			title = i18n("courtyard_label_detail"),
			drop = {
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var1_57.id,
				count = var1_57.count
			},
			list = var1_57.template:GetAcesses()
		})
	end, SFX_PANEL)
	setActive(var2_57:Find("Item/New"), var1_57.count > 0 and Dorm3dFurniture.GetViewedFlag(var1_57.id) == 0)
	onButton(arg0_57, var2_57, function()
		if var1_57.count > 0 then
			Dorm3dFurniture.SetViewedFlag(var1_57.id)
			setActive(var2_57:Find("Item/New"), false)
		end

		local var0_59 = var1_57.template:GetType()

		local function var1_59()
			local var0_60 = _.detect(arg0_57.globalZones[1]:GetSlots(), function(arg0_61)
				return arg0_61:GetType() == var0_59
			end)

			if not var0_60 then
				return
			end

			arg0_57.room:ReplaceFurniture(var0_60:GetConfigID(), var1_57.id)
			table.insert(arg0_57.replaceFurnitures, {
				slotId = var0_60:GetConfigID(),
				furnitureId = var1_57.id
			})
			arg0_57:UpdateDataDisplayFurnitures()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
		end

		if arg0_57.selectMode == var0_0.SELECT_MODE.NONE then
			if var1_57.useable > 0 then
				if var0_59 == Dorm3dFurniture.TYPE.FLOOR or var0_59 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1_59()
				else
					arg0_57.selectMode = var0_0.SELECT_MODE.FURNITURE
					arg0_57.selectFurnitureId = var1_57.id
				end

				arg0_57:UpdateView()
			end

			return
		end

		if arg0_57.selectMode == var0_0.SELECT_MODE.SLOT then
			if var1_57.fit and var1_57.useable > 0 then
				arg0_57.room:ReplaceFurniture(arg0_57.selectSlotId, var1_57.id)
				table.insert(arg0_57.replaceFurnitures, {
					slotId = arg0_57.selectSlotId,
					furnitureId = var1_57.id
				})
				arg0_57:UpdateDataDisplayFurnitures()
				arg0_57:UpdateView()
				pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
			end

			return
		end

		if arg0_57.selectMode == var0_0.SELECT_MODE.FURNITURE then
			if arg0_57.selectFurnitureId == var1_57.id then
				arg0_57.selectMode = var0_0.SELECT_MODE.NONE
				arg0_57.selectFurnitureId = nil

				arg0_57:UpdateView()
			elseif var1_57.useable > 0 then
				if var0_59 == Dorm3dFurniture.TYPE.FLOOR or var0_59 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1_59()
				else
					arg0_57.selectFurnitureId = var1_57.id

					arg0_57:UpdateView()
				end
			end

			return
		end
	end)

	local var10_57 = var1_57.count == 0 and var1_57.template:GetShopID() or 0

	setActive(var2_57:Find("GO"), var10_57 ~= 0)

	if var10_57 ~= 0 then
		local var11_57 = CommonCommodity.New({
			id = var10_57
		}, Goods.TYPE_SHOPSTREET)
		local var12_57, var13_57, var14_57 = var11_57:GetPrice()
		local var15_57 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var11_57:GetResType(),
			count = var12_57
		})
		local var16_57 = pg.shop_template[var10_57]

		onButton(arg0_57, var2_57:Find("GO"), function()
			local var0_62 = var1_57.template:GetEndTime()

			arg0_57:emit(Dorm3dFurnitureSelectMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var11_57:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var13_57,
					cost = "x" .. var15_57.count,
					old = var14_57,
					name = var1_57.template:GetName()
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var1_57.template,
				endTime = var0_62,
				onYes = function()
					if not var1_57.template:InShopTime() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_purchase_outtime"))

						return
					end

					arg0_57:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var10_57
					})
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.OnClickFurnitureSlot(arg0_64, arg1_64)
	if arg0_64.selectMode == var0_0.SELECT_MODE.FURNITURE then
		local var0_64 = _.detect(arg0_64.displayFurnitures, function(arg0_65)
			return arg0_65.id == arg0_64.selectFurnitureId
		end)
		local var1_64 = Dorm3dFurnitureSlot.New({
			configId = arg1_64
		})

		if var0_64 and var0_64.useable > 0 and var1_64:CanUseFurniture(var0_64.template) then
			arg0_64.room:ReplaceFurniture(arg1_64, var0_64.id)
			table.insert(arg0_64.replaceFurnitures, {
				slotId = arg1_64,
				furnitureId = var0_64.id
			})
			arg0_64:UpdateDataDisplayFurnitures()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
		else
			return
		end
	elseif arg0_64.selectMode == var0_0.SELECT_MODE.NONE then
		arg0_64.selectMode = var0_0.SELECT_MODE.SLOT
		arg0_64.selectSlotId = arg1_64

		arg0_64:FilterDataFurnitures()
	elseif arg0_64.selectMode == var0_0.SELECT_MODE.SLOT then
		if arg0_64.selectSlotId == arg1_64 then
			arg0_64.selectMode = var0_0.SELECT_MODE.NONE
			arg0_64.selectSlotId = nil
		else
			arg0_64.selectSlotId = arg1_64
		end

		arg0_64:FilterDataFurnitures()
	end

	arg0_64:UpdateView()
end

function var0_0.CleanSlot(arg0_66)
	if arg0_66.selectMode ~= var0_0.SELECT_MODE.SLOT then
		return
	end

	local var0_66 = arg0_66.selectSlotId

	arg0_66.room:ReplaceFurniture(var0_66, 0)
	table.insert(arg0_66.replaceFurnitures, {
		furnitureId = 0,
		slotId = var0_66
	})
	arg0_66:UpdateDataDisplayFurnitures()
	arg0_66:UpdateView()
end

function var0_0.OnReplaceFurnitureDone(arg0_67)
	arg0_67.replaceFurnitures = {}

	existCall(arg0_67.replaceFurnitureCallback)

	arg0_67.replaceFurnitureCallback = nil
end

function var0_0.OnReplaceFurnitureError(arg0_68)
	arg0_68.replaceFurnitureCallback = nil
end

function var0_0.AutoReplaceFurniture(arg0_69)
	local var0_69 = arg0_69.normalZones[arg0_69.zoneIndex]:GetSlots()

	_.each(var0_69, function(arg0_70)
		if arg0_70:GetType() == Dorm3dFurniture.TYPE.FLOOR or arg0_70:GetType() == Dorm3dFurniture.TYPE.WALLPAPER then
			return
		end

		local var0_70 = arg0_69.room:GetFurnitures()
		local var1_70 = _.detect(var0_70, function(arg0_71)
			return arg0_71:GetSlotID() == arg0_70:GetConfigID()
		end)

		if var1_70 and var1_70:GetConfigID() ~= arg0_70:GetDefaultFurniture() then
			return
		end

		local var2_70 = table.shallowCopy(var0_70)
		local var3_70 = {
			function(arg0_72)
				return arg0_72:GetSlotID() == 0 and arg0_70:CanUseFurniture(arg0_72) and 0 or 1
			end,
			function(arg0_73)
				return -arg0_73:GetRarity()
			end,
			function(arg0_74)
				return -arg0_74:GetConfigID()
			end
		}

		table.sort(var2_70, CompareFuncs(var3_70))

		local var4_70 = var2_70[1]

		if not var4_70 or var4_70:GetSlotID() ~= 0 or not arg0_70:CanUseFurniture(var4_70) then
			return
		end

		arg0_69.room:ReplaceFurniture(arg0_70:GetConfigID(), var4_70:GetConfigID())
		table.insert(arg0_69.replaceFurnitures, {
			slotId = arg0_70:GetConfigID(),
			furnitureId = var4_70:GetConfigID()
		})
	end)
	arg0_69:UpdateDataDisplayFurnitures()
	arg0_69:UpdateView()
end

function var0_0.ShowReplaceWindow(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg0_75.replaceFurnitures

	if #var0_75 == 0 then
		return existCall(arg1_75)
	end

	arg0_75:emit(Dorm3dFurnitureSelectMediator.SHOW_CONFIRM_WINDOW, {
		title = i18n("title_info"),
		content = i18n("dorm3d_furniture_sure_save"),
		onYes = function()
			arg0_75:emit(GAME.APARTMENT_REPLACE_FURNITURE, {
				roomId = arg0_75.room:GetConfigID(),
				furnitures = var0_75
			})

			arg0_75.replaceFurnitureCallback = arg1_75
		end,
		onNo = arg2_75
	})
end

function var0_0.onBackPressed(arg0_77)
	seriesAsync({
		function(arg0_78)
			arg0_77:ShowReplaceWindow(arg0_78, arg0_78)
		end,
		function(arg0_79)
			var0_0.super.onBackPressed(arg0_77)
		end
	})
end

function var0_0.willExit(arg0_80)
	arg0_80.furnitureScroll.enabled = false

	if arg0_80.timerRefreshShop then
		arg0_80.timerRefreshShop:Stop()
	end

	arg0_80.scene:ExitFurnitureWatchMode()
end

return var0_0
