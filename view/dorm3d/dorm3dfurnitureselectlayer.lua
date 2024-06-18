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

	local var0_2 = arg0_2._tf:Find("Right/Panel/Furnitures")

	arg0_2.furnitureScroll = var0_2:Find("Scroll"):GetComponent("LScrollRect")
	arg0_2.furnitureEmpty = var0_2:Find("Empty")
	arg0_2.lableTrans = arg0_2._tf:Find("Main/Label")

	setActive(arg0_2.lableTrans, false)

	arg0_2.blockActive = false

	local var1_2 = arg0_2.furnitureScroll.prefabItem.transform

	setText(var1_2:Find("Unfit/Icon/Text"), i18n("dorm3d_furniture_unfit"))
	setText(var1_2:Find("Lack/Icon/Text"), i18n("ryza_tip_control_buff_not_obtain"))
end

function var0_0.SetSceneRoot(arg0_3, arg1_3)
	arg0_3.scene = arg1_3
end

function var0_0.SetApartment(arg0_4, arg1_4)
	arg0_4.apartment = arg1_4:clone()
end

function var0_0.didEnter(arg0_5)
	local var0_5 = arg0_5.apartment:GetNormalZones()

	arg0_5.zoneIndex = 1

	local var1_5 = arg0_5.scene:GetAttachedFurnitureName()

	if var1_5 then
		table.Ipairs(var0_5, function(arg0_6, arg1_6)
			if arg1_6:GetWatchCameraName() == var1_5 then
				arg0_5.zoneIndex = arg0_6
			end
		end)
	end

	onButton(arg0_5, arg0_5._tf:Find("Right/Panel/Zone/Switch"), function()
		setActive(arg0_5.zoneList, true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.zoneList:Find("Mask"), function()
		setActive(arg0_5.zoneList, false)
	end)
	onButton(arg0_5, arg0_5._tf:Find("Top/Back"), function()
		arg0_5:onBackPressed()
	end)
	onButton(arg0_5, arg0_5._tf:Find("Right/Save"), function()
		arg0_5:ShowReplaceWindow()
	end, SFX_PANEL)

	local var2_5 = arg0_5._tf:Find("Right").rect.width

	local function var3_5(arg0_11)
		setCanvasGroupAlpha(arg0_5._tf:Find("Right"), 1)
		shiftPanel(arg0_5._tf:Find("Right"), arg0_11 and var2_5 or 0, nil, 0.5, nil, nil, nil, nil, function()
			return
		end)
		setActive(arg0_5._tf:Find("Right/Popup"), arg0_11)
		setActive(arg0_5._tf:Find("Right/Collapse"), not arg0_11)
	end

	setActive(arg0_5._tf:Find("Right/Popup"), false)
	onButton(arg0_5, arg0_5._tf:Find("Right/Popup"), function()
		var3_5(false)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Right/Collapse"), function()
		var3_5(true)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5._tf:Find("Right/Auto"), function()
		arg0_5:AutoReplaceFurniture()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.lableTrans, function()
		arg0_5:CleanSlot()
	end)

	arg0_5.furnitureItems = {}

	function arg0_5.furnitureScroll.onUpdateItem(arg0_17, arg1_17)
		arg0_17 = arg0_17 + 1
		arg0_5.furnitureItems[arg0_17] = arg1_17

		arg0_5:UpdateFurnitureItem(arg0_17)
	end

	arg0_5.replaceFurnitures = {}

	arg0_5.scene:EnterFurnitureWatchMode()
	arg0_5:UpdateZone()
	arg0_5:UpdateView()
end

function var0_0.UpdateZone(arg0_18)
	local var0_18 = arg0_18.apartment
	local var1_18 = var0_18:GetNormalZones()[arg0_18.zoneIndex]
	local var2_18 = {
		var1_18,
		unpack(var0_18:GetGlobalZones())
	}
	local var3_18 = _.reduce(var2_18, {}, function(arg0_19, arg1_19)
		table.insertto(arg0_19, arg1_19:GetSlots())

		return arg0_19
	end)

	arg0_18.activeFurnitureTypes = {}

	local var4_18 = 99

	_.each(var3_18, function(arg0_20)
		arg0_18.activeFurnitureTypes[arg0_20:GetType()] = true
		var4_18 = math.min(var4_18, arg0_20:GetType())
	end)

	arg0_18.activeFurnitureTypes = _.keys(arg0_18.activeFurnitureTypes)

	var1_18:SortTypes(arg0_18.activeFurnitureTypes)

	arg0_18.furnitureType = arg0_18.activeFurnitureTypes[1]

	setText(arg0_18._tf:Find("Right/Panel/Zone/Name"), var1_18:GetName())
	arg0_18:UpdateDisplayFurnitures()
end

function var0_0.UpdateDisplayFurnitures(arg0_21)
	local var0_21 = arg0_21.apartment
	local var1_21 = arg0_21.furnitureType

	arg0_21.selectMode = var0_0.SELECT_MODE.NONE
	arg0_21.selectFurnitureId = nil
	arg0_21.selectSlotId = nil

	local var2_21 = var0_21:GetFurnitures()
	local var3_21 = {}
	local var4_21 = {}

	_.each(var2_21, function(arg0_22)
		local var0_22 = arg0_22:GetConfigID()

		if var3_21[var0_22] then
			table.insert(var4_21[var3_21[var0_22]].instances, arg0_22)

			return
		end

		if arg0_22:GetType() ~= var1_21 then
			return
		end

		table.insert(var4_21, {
			useable = 0,
			id = var0_22,
			instances = {
				arg0_22
			}
		})

		var3_21[var0_22] = #var4_21
	end)

	arg0_21.displayFurnitures = var4_21

	_.each(arg0_21.displayFurnitures, function(arg0_23)
		arg0_23.useable = _.reduce(arg0_23.instances, 0, function(arg0_24, arg1_24)
			return arg0_24 + (arg1_24:GetSlotID() == 0 and 1 or 0)
		end)
	end)
	arg0_21:FilterFurnitures()
end

function var0_0.FilterFurnitures(arg0_25)
	local var0_25 = {
		function(arg0_26)
			return arg0_26.useable > 0 and 0 or 1
		end,
		function(arg0_27)
			return -arg0_27.instances[1]:GetRarity()
		end,
		function(arg0_28)
			return -arg0_28.id
		end
	}

	if arg0_25.selectMode == var0_0.SELECT_MODE.SLOT then
		local var1_25 = Dorm3dFurnitureSlot.New({
			configId = arg0_25.selectSlotId
		})

		_.each(arg0_25.displayFurnitures, function(arg0_29)
			local var0_29 = arg0_29.instances[1]

			arg0_29.fit = var1_25:CanUseFurniture(var0_29)
		end)
	end

	table.sort(arg0_25.displayFurnitures, CompareFuncs(var0_25))
end

function var0_0.UpdateView(arg0_30)
	local var0_30 = arg0_30.apartment
	local var1_30 = var0_30:GetNormalZones()

	UIItemList.StaticAlign(arg0_30.zoneList:Find("List"), arg0_30.zoneList:Find("List"):GetChild(0), #var1_30, function(arg0_31, arg1_31, arg2_31)
		if arg0_31 ~= UIItemList.EventUpdate then
			return
		end

		arg1_31 = arg1_31 + 1

		local var0_31 = var1_30[arg1_31]

		setText(arg2_31:Find("Name"), var0_31:GetName())
		onButton(arg0_30, arg2_31, function()
			arg0_30.zoneIndex = arg1_31

			arg0_30:UpdateZone()
			arg0_30:UpdateView()
			setActive(arg0_30.zoneList, false)
		end, SFX_PANEL)
		setActive(arg2_31:Find("Line"), arg1_31 < #var1_30)

		local var1_31 = arg2_31:Find("Name"):GetComponent(typeof(Text)).color
		local var2_31 = arg0_30.zoneIndex == arg1_31 and Color.NewHex("39bfff") or Color.white

		var2_31.a = var1_31.a

		setTextColor(arg2_31:Find("Name"), var2_31)
	end)
	UIItemList.StaticAlign(arg0_30._tf:Find("Right/Panel/Types"), arg0_30._tf:Find("Right/Panel/Types"):GetChild(0), #arg0_30.activeFurnitureTypes, function(arg0_33, arg1_33, arg2_33)
		if arg0_33 ~= UIItemList.EventUpdate then
			return
		end

		arg1_33 = arg1_33 + 1

		local var0_33 = arg0_30.activeFurnitureTypes[arg1_33]

		setText(arg2_33:Find("Name"), i18n(Dorm3dFurniture.TYPE2NAME[var0_33]))
		setActive(arg2_33:Find("Selected"), arg0_30.furnitureType == var0_33)
		onButton(arg0_30, arg2_33, function()
			if arg0_30.furnitureType == var0_33 then
				return
			end

			arg0_30.furnitureType = var0_33

			arg0_30:UpdateDisplayFurnitures()
			arg0_30:UpdateView()
			setActive(arg0_30.zoneList, false)
		end, SFX_PANEL)
	end)
	arg0_30.furnitureScroll:SetTotalCount(#arg0_30.displayFurnitures)
	setActive(arg0_30.furnitureEmpty, #arg0_30.displayFurnitures == 0)

	local var2_30 = {}
	local var3_30 = var1_30[arg0_30.zoneIndex]
	local var4_30 = arg0_30.furnitureType
	local var5_30 = {
		var3_30,
		unpack(var0_30:GetGlobalZones())
	}
	local var6_30 = _.reduce(var5_30, {}, function(arg0_35, arg1_35)
		table.insertto(arg0_35, arg1_35:GetSlots())

		return arg0_35
	end)
	local var7_30 = _.select(var6_30, function(arg0_36)
		return arg0_36:GetType() == var4_30
	end)

	_.each(var7_30, function(arg0_37)
		local var0_37 = arg0_37:GetConfigID()

		if arg0_30.selectMode == var0_0.SELECT_MODE.NONE then
			var2_30[var0_37] = 0
		elseif arg0_30.selectMode == var0_0.SELECT_MODE.FURNITURE then
			local var1_37 = arg0_37:CanUseFurniture(Dorm3dFurniture.New({
				configId = arg0_30.selectFurnitureId
			}))

			var2_30[var0_37] = var1_37 and 1 or 2
		elseif arg0_30.selectMode == var0_0.SELECT_MODE.SLOT then
			var2_30[var0_37] = arg0_30.selectSlotId == var0_37 and 1 or 0
		end
	end)

	local var8_30 = false

	if arg0_30.selectMode == var0_0.SELECT_MODE.SLOT then
		local var9_30 = Dorm3dFurnitureSlot.New({
			configId = arg0_30.selectSlotId
		})

		if var9_30:GetType() == Dorm3dFurniture.TYPE.DECORATION then
			local var10_30 = arg0_30.apartment:GetFurnitures()

			if _.detect(var10_30, function(arg0_38)
				return arg0_38:GetSlotID() == var9_30:GetConfigID()
			end) then
				local var11_30 = arg0_30.scene:GetSlotByID(var9_30:GetConfigID())
				local var12_30 = arg0_30.scene:GetScreenPosition(var11_30) or Vector2.New(-10000, -10000)

				setAnchoredPosition(arg0_30.lableTrans, var12_30)

				var8_30 = true
			end
		end
	end

	setActive(arg0_30.lableTrans, var8_30)

	if arg0_30.activeZoneId ~= var3_30:GetConfigID() then
		arg0_30.blockActive = true

		arg0_30.scene:SwitchZone(var3_30, function()
			arg0_30.blockActive = false
		end)

		arg0_30.activeZoneId = var3_30:GetConfigID()
	end

	arg0_30.scene:DisplayFurnitureSlots(_.map(var7_30, function(arg0_40)
		return arg0_40:GetConfigID()
	end))
	arg0_30.scene:UpdateDisplaySlots(var2_30)
	arg0_30.scene:RefreshSlots(arg0_30.apartment)
end

function var0_0.UpdateFurnitureItem(arg0_41, arg1_41)
	local var0_41 = arg0_41.furnitureItems[arg1_41]
	local var1_41 = arg0_41.displayFurnitures[arg1_41]

	if not var0_41 then
		return
	end

	local var2_41 = tf(var0_41)

	updateDrop(var2_41:Find("Item/Icon"), {
		type = DROP_TYPE_DORM3D_FURNITURE,
		id = var1_41.id
	})
	setText(var2_41:Find("Item/Name"), var1_41.instances[1]:GetName())

	local var3_41 = i18n("dorm3d_furniture_count", var1_41.useable .. "/" .. #var1_41.instances)

	if var1_41.useable < #var1_41.instances then
		var3_41 = i18n("dorm3d_furniture_used") .. var3_41
	end

	setText(var2_41:Find("Item/Count"), var3_41)
	setActive(var2_41:Find("Selected"), arg0_41.selectFurnitureId == var1_41.id)

	local var4_41 = arg0_41.selectMode == var0_0.SELECT_MODE.SLOT and not var1_41.fit

	setActive(var2_41:Find("Unfit"), var4_41)

	local var5_41 = not var4_41 and var1_41.useable == 0

	setActive(var2_41:Find("Lack"), var5_41)
	setCanvasGroupAlpha(var2_41:Find("Item"), (var4_41 or var5_41) and 0.3 or 1)
	onButton(arg0_41, var2_41:Find("Item/Tip"), function()
		arg0_41:emit(Dorm3dFurnitureSelectMediator.SHOW_FURNITURE_ACESSES, {
			showGOBtn = true,
			title = i18n("courtyard_label_detail"),
			drop = {
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var1_41.id,
				count = #var1_41.instances
			},
			list = var1_41.instances[1]:GetAcesses()
		})
	end, SFX_PANEL)
	onButton(arg0_41, var2_41, function()
		local var0_43 = var1_41.instances[1]:GetType()

		local function var1_43()
			local var0_44 = _.detect(arg0_41.apartment:GetGlobalZones()[1]:GetSlots(), function(arg0_45)
				return arg0_45:GetType() == var0_43
			end)

			if not var0_44 then
				return
			end

			arg0_41.apartment:ReplaceFurniture(var0_44:GetConfigID(), var1_41.id)
			table.insert(arg0_41.replaceFurnitures, {
				slotId = var0_44:GetConfigID(),
				furnitureId = var1_41.id
			})
			arg0_41:UpdateDisplayFurnitures()
		end

		if arg0_41.selectMode == var0_0.SELECT_MODE.NONE then
			if var1_41.useable > 0 then
				if var0_43 == Dorm3dFurniture.TYPE.FLOOR or var0_43 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1_43()
				else
					arg0_41.selectMode = var0_0.SELECT_MODE.FURNITURE
					arg0_41.selectFurnitureId = var1_41.id
				end

				arg0_41:UpdateView()
			end

			return
		end

		if arg0_41.selectMode == var0_0.SELECT_MODE.SLOT then
			if var1_41.fit and var1_41.useable > 0 then
				arg0_41.apartment:ReplaceFurniture(arg0_41.selectSlotId, var1_41.id)
				table.insert(arg0_41.replaceFurnitures, {
					slotId = arg0_41.selectSlotId,
					furnitureId = var1_41.id
				})
				arg0_41:UpdateDisplayFurnitures()
				arg0_41:UpdateView()
			end

			return
		end

		if arg0_41.selectMode == var0_0.SELECT_MODE.FURNITURE then
			if arg0_41.selectFurnitureId == var1_41.id then
				arg0_41.selectMode = var0_0.SELECT_MODE.NONE
				arg0_41.selectFurnitureId = nil

				arg0_41:UpdateView()
			elseif var1_41.useable > 0 then
				if var0_43 == Dorm3dFurniture.TYPE.FLOOR or var0_43 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1_43()
				else
					arg0_41.selectFurnitureId = var1_41.id

					arg0_41:UpdateView()
				end
			end

			return
		end
	end, SFX_PANEL)
end

function var0_0.OnClickFurnitureSlot(arg0_46, arg1_46)
	if arg0_46.selectMode == var0_0.SELECT_MODE.FURNITURE then
		local var0_46 = _.detect(arg0_46.displayFurnitures, function(arg0_47)
			return arg0_47.id == arg0_46.selectFurnitureId
		end)
		local var1_46 = Dorm3dFurnitureSlot.New({
			configId = arg1_46
		})

		if var0_46 and var0_46.useable > 0 and var1_46:CanUseFurniture(var0_46.instances[1]) then
			arg0_46.apartment:ReplaceFurniture(arg1_46, var0_46.id)
			table.insert(arg0_46.replaceFurnitures, {
				slotId = arg1_46,
				furnitureId = var0_46.id
			})
			arg0_46:UpdateDisplayFurnitures()
		else
			return
		end
	elseif arg0_46.selectMode == var0_0.SELECT_MODE.NONE then
		arg0_46.selectMode = var0_0.SELECT_MODE.SLOT
		arg0_46.selectSlotId = arg1_46

		arg0_46:FilterFurnitures()
	elseif arg0_46.selectMode == var0_0.SELECT_MODE.SLOT then
		if arg0_46.selectSlotId == arg1_46 then
			arg0_46.selectMode = var0_0.SELECT_MODE.NONE
			arg0_46.selectSlotId = nil
		else
			arg0_46.selectSlotId = arg1_46
		end

		arg0_46:FilterFurnitures()
	end

	arg0_46:UpdateView()
end

function var0_0.CleanSlot(arg0_48)
	if arg0_48.selectMode ~= var0_0.SELECT_MODE.SLOT then
		return
	end

	local var0_48 = arg0_48.selectSlotId

	arg0_48.apartment:ReplaceFurniture(var0_48, 0)
	table.insert(arg0_48.replaceFurnitures, {
		furnitureId = 0,
		slotId = var0_48
	})
	arg0_48:UpdateDisplayFurnitures()
	arg0_48:UpdateView()
end

function var0_0.OnReplaceFurnitureDone(arg0_49)
	arg0_49.replaceFurnitures = {}

	existCall(arg0_49.replaceFurnitureCallback)

	arg0_49.replaceFurnitureCallback = nil
end

function var0_0.OnReplaceFurnitureError(arg0_50)
	arg0_50.replaceFurnitureCallback = nil
end

function var0_0.AutoReplaceFurniture(arg0_51)
	local var0_51 = arg0_51.apartment:GetNormalZones()[arg0_51.zoneIndex]:GetSlots()

	_.each(var0_51, function(arg0_52)
		if arg0_52:GetType() == Dorm3dFurniture.TYPE.FLOOR or arg0_52:GetType() == Dorm3dFurniture.TYPE.WALLPAPER then
			return
		end

		local var0_52 = arg0_51.apartment:GetFurnitures()
		local var1_52 = _.detect(var0_52, function(arg0_53)
			return arg0_53:GetSlotID() == arg0_52:GetConfigID()
		end)

		if var1_52 and var1_52:GetConfigID() ~= arg0_52:GetDefaultFurniture() then
			return
		end

		local var2_52 = table.shallowCopy(var0_52)
		local var3_52 = {
			function(arg0_54)
				return arg0_54:GetSlotID() == 0 and arg0_52:CanUseFurniture(arg0_54) and 0 or 1
			end,
			function(arg0_55)
				return -arg0_55:GetRarity()
			end,
			function(arg0_56)
				return -arg0_56:GetConfigID()
			end
		}

		table.sort(var2_52, CompareFuncs(var3_52))

		local var4_52 = var2_52[1]

		if not var4_52 or var4_52:GetSlotID() ~= 0 or not arg0_52:CanUseFurniture(var4_52) then
			return
		end

		arg0_51.apartment:ReplaceFurniture(arg0_52:GetConfigID(), var4_52:GetConfigID())
		table.insert(arg0_51.replaceFurnitures, {
			slotId = arg0_52:GetConfigID(),
			furnitureId = var4_52:GetConfigID()
		})
	end)
	arg0_51:UpdateView()
end

function var0_0.ShowReplaceWindow(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57.replaceFurnitures

	if #var0_57 == 0 then
		return existCall(arg1_57)
	end

	arg0_57:emit(Dorm3dFurnitureSelectMediator.SHOW_CONFIRM_WINDOW, {
		title = i18n("title_info"),
		content = i18n("dorm3d_replace_furniture_confirm"),
		onYes = function()
			arg0_57:emit(GAME.APARTMENT_REPLACE_FURNITURE, {
				shipGroupId = arg0_57.apartment:GetConfigID(),
				furnitures = var0_57
			})

			arg0_57.replaceFurnitureCallback = arg1_57
		end,
		onNo = arg2_57
	})
end

function var0_0.onBackPressed(arg0_59)
	if arg0_59.blockActive then
		return
	end

	seriesAsync({
		function(arg0_60)
			arg0_59:ShowReplaceWindow(arg0_60, arg0_60)
		end,
		function(arg0_61)
			var0_0.super.onBackPressed(arg0_59)
		end
	})
end

function var0_0.willExit(arg0_62)
	arg0_62.scene:ExitFurnitureWatchMode()
end

return var0_0
