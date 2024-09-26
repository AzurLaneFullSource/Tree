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

function var0_0.UpdateDataZone(arg0_20)
	local var0_20 = arg0_20.normalZones[arg0_20.zoneIndex]
	local var1_20 = {
		var0_20,
		unpack(arg0_20.globalZones)
	}
	local var2_20 = _.reduce(var1_20, {}, function(arg0_21, arg1_21)
		table.insertto(arg0_21, arg1_21:GetSlots())

		return arg0_21
	end)
	local var3_20 = {}
	local var4_20 = 99

	_.each(var2_20, function(arg0_22)
		var3_20[arg0_22:GetType()] = true
		var4_20 = math.min(var4_20, arg0_22:GetType())
	end)

	arg0_20.activeFurnitureTypes = _.keys(var3_20)

	var0_20:SortTypes(arg0_20.activeFurnitureTypes)

	arg0_20.furnitureType = arg0_20.activeFurnitureTypes[1]

	arg0_20:UpdateDataDisplayFurnitures()
end

function var0_0.UpdateDataDisplayFurnitures(arg0_23)
	local var0_23 = arg0_23.room
	local var1_23 = arg0_23.furnitureType

	arg0_23.selectMode = var0_0.SELECT_MODE.NONE
	arg0_23.selectFurnitureId = nil
	arg0_23.selectSlotId = nil

	local var2_23 = arg0_23.normalZones[arg0_23.zoneIndex]
	local var3_23 = {
		var2_23,
		unpack(arg0_23.globalZones)
	}
	local var4_23 = _.reduce(var3_23, {}, function(arg0_24, arg1_24)
		table.insertto(arg0_24, arg1_24:GetSlots())

		return arg0_24
	end)
	local var5_23 = var0_23:GetFurnitureIDList()
	local var6_23 = var0_23:GetFurnitures()
	local var7_23 = {}
	local var8_23 = {}

	_.each(var5_23, function(arg0_25)
		local var0_25 = Dorm3dFurniture.New({
			configId = arg0_25
		})

		if var0_25:GetType() ~= var1_23 then
			return
		end

		if not _.any(var4_23, function(arg0_26)
			return arg0_26:CanUseFurniture(var0_25)
		end) then
			return
		end

		table.insert(var8_23, {
			useable = 0,
			count = 0,
			id = arg0_25,
			template = var0_25
		})

		var7_23[arg0_25] = #var8_23
	end)
	_.each(var6_23, function(arg0_27)
		if arg0_27:GetType() ~= var1_23 then
			return
		end

		if not _.any(var4_23, function(arg0_28)
			return arg0_28:CanUseFurniture(arg0_27)
		end) then
			return
		end

		local var0_27 = arg0_27:GetConfigID()
		local var1_27 = var8_23[var7_23[var0_27]]

		var1_27.count = var1_27.count + 1

		if arg0_27:GetSlotID() == 0 then
			var1_27.useable = var1_27.useable + 1
		end
	end)

	arg0_23.displayFurnitures = var8_23

	arg0_23:FilterDataFurnitures()
end

function var0_0.FilterDataFurnitures(arg0_29)
	local var0_29 = {
		function(arg0_30)
			return arg0_30.useable > 0 and 0 or 1
		end,
		function(arg0_31)
			return -arg0_31.template:GetRarity()
		end,
		function(arg0_32)
			return -arg0_32.id
		end
	}

	if arg0_29.selectMode == var0_0.SELECT_MODE.SLOT then
		local var1_29 = Dorm3dFurnitureSlot.New({
			configId = arg0_29.selectSlotId
		})

		_.each(arg0_29.displayFurnitures, function(arg0_33)
			local var0_33 = arg0_33.template

			arg0_33.fit = var1_29:CanUseFurniture(var0_33)
		end)
		table.insert(var0_29, function(arg0_34)
			return arg0_34.fit and 0 or 1
		end)
	end

	table.sort(arg0_29.displayFurnitures, CompareFuncs(var0_29))
end

function var0_0.InitViewZoneList(arg0_35)
	local var0_35 = arg0_35.normalZones

	UIItemList.StaticAlign(arg0_35.zoneList:Find("List"), arg0_35.zoneList:Find("List"):GetChild(0), #var0_35, function(arg0_36, arg1_36, arg2_36)
		if arg0_36 ~= UIItemList.EventUpdate then
			return
		end

		arg1_36 = arg1_36 + 1

		local var0_36 = var0_35[arg1_36]

		arg2_36.name = var0_36:GetWatchCameraName()

		setText(arg2_36:Find("Name"), var0_36:GetName())
		onButton(arg0_35, arg2_36, function()
			arg0_35.zoneIndex = arg1_36

			arg0_35:UpdateDataZone()
			arg0_35.scene:SwitchFurnitureZone(var0_36)
			arg0_35:InitViewTypeList()
			arg0_35:UpdateView()
			quickPlayAnimation(arg0_35._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_35.zoneList, false)
		end, SFX_PANEL)
		setActive(arg2_36:Find("Line"), arg1_36 < #var0_35)
		setActive(arg2_36:Find("New"), false)
	end)
end

function var0_0.InitViewTypeList(arg0_38)
	UIItemList.StaticAlign(arg0_38._tf:Find("Right/Panel/Container/Types"), arg0_38._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_38.activeFurnitureTypes, function(arg0_39, arg1_39, arg2_39)
		if arg0_39 ~= UIItemList.EventUpdate then
			return
		end

		arg1_39 = arg1_39 + 1

		local var0_39 = arg0_38.activeFurnitureTypes[arg1_39]

		setText(arg2_39:Find("Name"), i18n(Dorm3dFurniture.TYPE2NAME[var0_39]))
		onButton(arg0_38, arg2_39, function()
			if arg0_38.furnitureType == var0_39 then
				return
			end

			arg0_38.furnitureType = var0_39

			arg0_38:UpdateDataDisplayFurnitures()
			arg0_38:UpdateView()
			quickPlayAnimation(arg0_38._tf, "anim_dorm3d_furniture_change")
			setActive(arg0_38.zoneList, false)
		end, SFX_PANEL)
	end)
end

function var0_0.UpdateView(arg0_41)
	local var0_41 = arg0_41.normalZones
	local var1_41 = var0_41[arg0_41.zoneIndex]

	setText(arg0_41._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Name"), var1_41:GetName())
	UIItemList.StaticAlign(arg0_41.zoneList:Find("List"), arg0_41.zoneList:Find("List"):GetChild(0), #var0_41, function(arg0_42, arg1_42, arg2_42)
		if arg0_42 ~= UIItemList.EventUpdate then
			return
		end

		arg1_42 = arg1_42 + 1

		local var0_42 = arg2_42:Find("Name"):GetComponent(typeof(Text)).color
		local var1_42 = arg0_41.zoneIndex == arg1_42 and Color.NewHex("39bfff") or Color.white

		var1_42.a = var0_42.a

		setTextColor(arg2_42:Find("Name"), var1_42)
		setActive(arg2_42:Find("New"), false)
	end)
	;(function()
		local var0_43 = arg0_41.room:GetFurnitures()
		local var1_43 = false

		table.Ipairs(arg0_41.normalZones, function(arg0_44, arg1_44)
			local var0_44 = false

			if arg1_44 ~= var1_41 then
				var0_44 = _.any(arg1_44:GetSlots(), function(arg0_45)
					return _.any(var0_43, function(arg0_46)
						if not arg0_45:CanUseFurniture(arg0_46) then
							return
						end

						return Dorm3dFurniture.GetViewedFlag(arg0_46:GetConfigID()) == 0
					end)
				end)
			end

			setActive(arg0_41.zoneList:Find("List"):GetChild(arg0_44 - 1):Find("New"), var0_44)

			var1_43 = var1_43 or var0_44
		end)
		setActive(arg0_41._tf:Find("Right/Panel/Container/Zone/ZoneContainer/Switch/New"), var1_43)
	end)()
	setActive(arg0_41._tf:Find("Right/Panel/Container/Types"), #arg0_41.activeFurnitureTypes > 1)
	UIItemList.StaticAlign(arg0_41._tf:Find("Right/Panel/Container/Types"), arg0_41._tf:Find("Right/Panel/Container/Types"):GetChild(0), #arg0_41.activeFurnitureTypes, function(arg0_47, arg1_47, arg2_47)
		if arg0_47 ~= UIItemList.EventUpdate then
			return
		end

		arg1_47 = arg1_47 + 1

		local var0_47 = arg0_41.activeFurnitureTypes[arg1_47]

		setActive(arg2_47:Find("Selected"), arg0_41.furnitureType == var0_47)
	end)
	arg0_41.furnitureScroll:SetTotalCount(#arg0_41.displayFurnitures)
	setActive(arg0_41.furnitureEmpty, #arg0_41.displayFurnitures == 0)

	local var2_41 = {}
	local var3_41 = arg0_41.furnitureType
	local var4_41 = {
		var1_41,
		unpack(arg0_41.globalZones)
	}
	local var5_41 = _.reduce(var4_41, {}, function(arg0_48, arg1_48)
		table.insertto(arg0_48, arg1_48:GetSlots())

		return arg0_48
	end)
	local var6_41 = _.select(var5_41, function(arg0_49)
		return arg0_49:GetType() == var3_41
	end)

	_.each(var6_41, function(arg0_50)
		local var0_50 = arg0_50:GetConfigID()

		if arg0_41.selectMode == var0_0.SELECT_MODE.NONE then
			var2_41[var0_50] = 0
		elseif arg0_41.selectMode == var0_0.SELECT_MODE.FURNITURE then
			local var1_50 = arg0_50:CanUseFurniture(Dorm3dFurniture.New({
				configId = arg0_41.selectFurnitureId
			}))

			var2_41[var0_50] = var1_50 and 1 or 2
		elseif arg0_41.selectMode == var0_0.SELECT_MODE.SLOT then
			var2_41[var0_50] = arg0_41.selectSlotId == var0_50 and 1 or 0
		end
	end)

	local var7_41 = false

	if arg0_41.selectMode == var0_0.SELECT_MODE.SLOT then
		local var8_41 = Dorm3dFurnitureSlot.New({
			configId = arg0_41.selectSlotId
		})

		if var8_41:GetType() == Dorm3dFurniture.TYPE.DECORATION then
			local var9_41 = arg0_41.room:GetFurnitures()

			if _.detect(var9_41, function(arg0_51)
				return arg0_51:GetSlotID() == var8_41:GetConfigID()
			end) then
				local var10_41 = arg0_41.scene:GetSlotByID(var8_41:GetConfigID())
				local var11_41 = arg0_41.scene:GetScreenPosition(var10_41.position)
				local var12_41 = arg0_41.scene:GetLocalPosition(var11_41, arg0_41.lableTrans.parent)

				setLocalPosition(arg0_41.lableTrans, var12_41)

				var7_41 = true
			end
		end
	end

	setActive(arg0_41.lableTrans, var7_41)
	arg0_41.scene:DisplayFurnitureSlots(_.map(var6_41, function(arg0_52)
		return arg0_52:GetConfigID()
	end))
	arg0_41.scene:UpdateDisplaySlots(var2_41)
	arg0_41.scene:RefreshSlots(arg0_41.room)
end

function var0_0.UpdateViewFurnitureItem(arg0_53, arg1_53)
	local var0_53 = arg0_53.furnitureItems[arg1_53]
	local var1_53 = arg0_53.displayFurnitures[arg1_53]

	if not var0_53 then
		return
	end

	local var2_53 = tf(var0_53)

	var2_53.name = var1_53.id

	updateDorm3dIcon(var2_53:Find("Item/Dorm3dIconTpl"), Drop.New({
		type = DROP_TYPE_DORM3D_FURNITURE,
		id = var1_53.id,
		count = var1_53.count
	}))
	setText(var2_53:Find("Item/Name"), var1_53.template:GetName())

	local var3_53 = i18n("dorm3d_furniture_count", var1_53.useable .. "/" .. var1_53.count)

	if var1_53.useable < var1_53.count then
		var3_53 = i18n("dorm3d_furniture_used") .. var3_53
	end

	setText(var2_53:Find("Item/Count"), var3_53)
	setActive(var2_53:Find("Selected"), arg0_53.selectFurnitureId == var1_53.id)

	local var4_53 = arg0_53.selectMode == var0_0.SELECT_MODE.SLOT and not var1_53.fit

	setActive(var2_53:Find("Unfit"), var4_53)

	local var5_53 = not var4_53 and var1_53.count == 0

	setActive(var2_53:Find("Lack"), var5_53)
	setCanvasGroupAlpha(var2_53:Find("Item"), (var4_53 or var5_53) and 0.4 or 1)

	local var6_53 = var1_53.template:IsValuable()

	setActive(var2_53:Find("Item/BG/Normal"), not var6_53)
	setActive(var2_53:Find("Item/BG/Pro"), var6_53)
	setActive(var2_53:Find("Item/LabelPro"), var6_53)
	setActive(var2_53:Find("Item/Action"), false)
	onButton(arg0_53, var2_53:Find("Item/Tip"), function()
		arg0_53:emit(Dorm3dFurnitureSelectMediator.SHOW_FURNITURE_ACESSES, {
			showGOBtn = true,
			title = i18n("courtyard_label_detail"),
			drop = {
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var1_53.id,
				count = var1_53.count
			},
			list = var1_53.template:GetAcesses()
		})
	end, SFX_PANEL)
	setActive(var2_53:Find("Item/New"), var1_53.count > 0 and Dorm3dFurniture.GetViewedFlag(var1_53.id) == 0)
	onButton(arg0_53, var2_53, function()
		if var1_53.count > 0 then
			Dorm3dFurniture.SetViewedFlag(var1_53.id)
			setActive(var2_53:Find("Item/New"), false)
		end

		local var0_55 = var1_53.template:GetType()

		local function var1_55()
			local var0_56 = _.detect(arg0_53.globalZones[1]:GetSlots(), function(arg0_57)
				return arg0_57:GetType() == var0_55
			end)

			if not var0_56 then
				return
			end

			arg0_53.room:ReplaceFurniture(var0_56:GetConfigID(), var1_53.id)
			table.insert(arg0_53.replaceFurnitures, {
				slotId = var0_56:GetConfigID(),
				furnitureId = var1_53.id
			})
			arg0_53:UpdateDataDisplayFurnitures()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
		end

		if arg0_53.selectMode == var0_0.SELECT_MODE.NONE then
			if var1_53.useable > 0 then
				if var0_55 == Dorm3dFurniture.TYPE.FLOOR or var0_55 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1_55()
				else
					arg0_53.selectMode = var0_0.SELECT_MODE.FURNITURE
					arg0_53.selectFurnitureId = var1_53.id
				end

				arg0_53:UpdateView()
			end

			return
		end

		if arg0_53.selectMode == var0_0.SELECT_MODE.SLOT then
			if var1_53.fit and var1_53.useable > 0 then
				arg0_53.room:ReplaceFurniture(arg0_53.selectSlotId, var1_53.id)
				table.insert(arg0_53.replaceFurnitures, {
					slotId = arg0_53.selectSlotId,
					furnitureId = var1_53.id
				})
				arg0_53:UpdateDataDisplayFurnitures()
				arg0_53:UpdateView()
				pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
			end

			return
		end

		if arg0_53.selectMode == var0_0.SELECT_MODE.FURNITURE then
			if arg0_53.selectFurnitureId == var1_53.id then
				arg0_53.selectMode = var0_0.SELECT_MODE.NONE
				arg0_53.selectFurnitureId = nil

				arg0_53:UpdateView()
			elseif var1_53.useable > 0 then
				if var0_55 == Dorm3dFurniture.TYPE.FLOOR or var0_55 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1_55()
				else
					arg0_53.selectFurnitureId = var1_53.id

					arg0_53:UpdateView()
				end
			end

			return
		end
	end)

	local var7_53 = var1_53.template:GetShopID()

	setActive(var2_53:Find("GO"), var7_53)

	if var7_53 then
		local var8_53 = CommonCommodity.New({
			id = var7_53
		}, Goods.TYPE_SHOPSTREET)
		local var9_53, var10_53, var11_53 = var8_53:GetPrice()
		local var12_53 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var8_53:GetResType(),
			count = var9_53
		})
		local var13_53 = pg.shop_template[var7_53]

		onButton(arg0_53, var2_53:Find("GO"), function()
			arg0_53:emit(Dorm3dFurnitureSelectMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var8_53:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var10_53,
					cost = "x" .. var12_53.count,
					old = var11_53,
					name = var1_53.template:GetName()
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var1_53.template,
				onYes = function()
					arg0_53:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var7_53
					})
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.OnClickFurnitureSlot(arg0_60, arg1_60)
	if arg0_60.selectMode == var0_0.SELECT_MODE.FURNITURE then
		local var0_60 = _.detect(arg0_60.displayFurnitures, function(arg0_61)
			return arg0_61.id == arg0_60.selectFurnitureId
		end)
		local var1_60 = Dorm3dFurnitureSlot.New({
			configId = arg1_60
		})

		if var0_60 and var0_60.useable > 0 and var1_60:CanUseFurniture(var0_60.template) then
			arg0_60.room:ReplaceFurniture(arg1_60, var0_60.id)
			table.insert(arg0_60.replaceFurnitures, {
				slotId = arg1_60,
				furnitureId = var0_60.id
			})
			arg0_60:UpdateDataDisplayFurnitures()
			pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_furniture_placement")
		else
			return
		end
	elseif arg0_60.selectMode == var0_0.SELECT_MODE.NONE then
		arg0_60.selectMode = var0_0.SELECT_MODE.SLOT
		arg0_60.selectSlotId = arg1_60

		arg0_60:FilterDataFurnitures()
	elseif arg0_60.selectMode == var0_0.SELECT_MODE.SLOT then
		if arg0_60.selectSlotId == arg1_60 then
			arg0_60.selectMode = var0_0.SELECT_MODE.NONE
			arg0_60.selectSlotId = nil
		else
			arg0_60.selectSlotId = arg1_60
		end

		arg0_60:FilterDataFurnitures()
	end

	arg0_60:UpdateView()
end

function var0_0.CleanSlot(arg0_62)
	if arg0_62.selectMode ~= var0_0.SELECT_MODE.SLOT then
		return
	end

	local var0_62 = arg0_62.selectSlotId

	arg0_62.room:ReplaceFurniture(var0_62, 0)
	table.insert(arg0_62.replaceFurnitures, {
		furnitureId = 0,
		slotId = var0_62
	})
	arg0_62:UpdateDataDisplayFurnitures()
	arg0_62:UpdateView()
end

function var0_0.OnReplaceFurnitureDone(arg0_63)
	arg0_63.replaceFurnitures = {}

	existCall(arg0_63.replaceFurnitureCallback)

	arg0_63.replaceFurnitureCallback = nil
end

function var0_0.OnReplaceFurnitureError(arg0_64)
	arg0_64.replaceFurnitureCallback = nil
end

function var0_0.AutoReplaceFurniture(arg0_65)
	local var0_65 = arg0_65.normalZones[arg0_65.zoneIndex]:GetSlots()

	_.each(var0_65, function(arg0_66)
		if arg0_66:GetType() == Dorm3dFurniture.TYPE.FLOOR or arg0_66:GetType() == Dorm3dFurniture.TYPE.WALLPAPER then
			return
		end

		local var0_66 = arg0_65.room:GetFurnitures()
		local var1_66 = _.detect(var0_66, function(arg0_67)
			return arg0_67:GetSlotID() == arg0_66:GetConfigID()
		end)

		if var1_66 and var1_66:GetConfigID() ~= arg0_66:GetDefaultFurniture() then
			return
		end

		local var2_66 = table.shallowCopy(var0_66)
		local var3_66 = {
			function(arg0_68)
				return arg0_68:GetSlotID() == 0 and arg0_66:CanUseFurniture(arg0_68) and 0 or 1
			end,
			function(arg0_69)
				return -arg0_69:GetRarity()
			end,
			function(arg0_70)
				return -arg0_70:GetConfigID()
			end
		}

		table.sort(var2_66, CompareFuncs(var3_66))

		local var4_66 = var2_66[1]

		if not var4_66 or var4_66:GetSlotID() ~= 0 or not arg0_66:CanUseFurniture(var4_66) then
			return
		end

		arg0_65.room:ReplaceFurniture(arg0_66:GetConfigID(), var4_66:GetConfigID())
		table.insert(arg0_65.replaceFurnitures, {
			slotId = arg0_66:GetConfigID(),
			furnitureId = var4_66:GetConfigID()
		})
	end)
	arg0_65:UpdateDataDisplayFurnitures()
	arg0_65:UpdateView()
end

function var0_0.ShowReplaceWindow(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71.replaceFurnitures

	if #var0_71 == 0 then
		return existCall(arg1_71)
	end

	arg0_71:emit(Dorm3dFurnitureSelectMediator.SHOW_CONFIRM_WINDOW, {
		title = i18n("title_info"),
		content = i18n("dorm3d_furniture_sure_save"),
		onYes = function()
			arg0_71:emit(GAME.APARTMENT_REPLACE_FURNITURE, {
				roomId = arg0_71.room:GetConfigID(),
				furnitures = var0_71
			})

			arg0_71.replaceFurnitureCallback = arg1_71
		end,
		onNo = arg2_71
	})
end

function var0_0.onBackPressed(arg0_73)
	seriesAsync({
		function(arg0_74)
			arg0_73:ShowReplaceWindow(arg0_74, arg0_74)
		end,
		function(arg0_75)
			var0_0.super.onBackPressed(arg0_73)
		end
	})
end

function var0_0.willExit(arg0_76)
	arg0_76.scene:ExitFurnitureWatchMode()
end

return var0_0
