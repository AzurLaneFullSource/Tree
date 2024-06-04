local var0 = class("Dorm3dFurnitureSelectLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "Dorm3dFurnitureSelectUI"
end

var0.SELECT_MODE = {
	SLOT = 1,
	FURNITURE = 2,
	NONE = 0
}

function var0.init(arg0)
	arg0.zoneList = arg0._tf:Find("ZoneList")

	setActive(arg0.zoneList, false)

	local var0 = arg0._tf:Find("Right/Panel/Furnitures")

	arg0.furnitureScroll = var0:Find("Scroll"):GetComponent("LScrollRect")
	arg0.furnitureEmpty = var0:Find("Empty")
	arg0.lableTrans = arg0._tf:Find("Main/Label")

	setActive(arg0.lableTrans, false)

	arg0.blockActive = false

	local var1 = arg0.furnitureScroll.prefabItem.transform

	setText(var1:Find("Unfit/Icon/Text"), i18n("dorm3d_furniture_unfit"))
	setText(var1:Find("Lack/Icon/Text"), i18n("ryza_tip_control_buff_not_obtain"))
end

function var0.SetSceneRoot(arg0, arg1)
	arg0.scene = arg1
end

function var0.SetApartment(arg0, arg1)
	arg0.apartment = arg1:clone()
end

function var0.didEnter(arg0)
	local var0 = arg0.apartment:GetNormalZones()

	arg0.zoneIndex = 1

	local var1 = arg0.scene:GetAttachedFurnitureName()

	if var1 then
		table.Ipairs(var0, function(arg0, arg1)
			if arg1:GetWatchCameraName() == var1 then
				arg0.zoneIndex = arg0
			end
		end)
	end

	onButton(arg0, arg0._tf:Find("Right/Panel/Zone/Switch"), function()
		setActive(arg0.zoneList, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.zoneList:Find("Mask"), function()
		setActive(arg0.zoneList, false)
	end)
	onButton(arg0, arg0._tf:Find("Top/Back"), function()
		arg0:onBackPressed()
	end)
	onButton(arg0, arg0._tf:Find("Right/Save"), function()
		arg0:ShowReplaceWindow()
	end, SFX_PANEL)

	local var2 = arg0._tf:Find("Right").rect.width

	local function var3(arg0)
		setCanvasGroupAlpha(arg0._tf:Find("Right"), 1)
		shiftPanel(arg0._tf:Find("Right"), arg0 and var2 or 0, nil, 0.5, nil, nil, nil, nil, function()
			return
		end)
		setActive(arg0._tf:Find("Right/Popup"), arg0)
		setActive(arg0._tf:Find("Right/Collapse"), not arg0)
	end

	setActive(arg0._tf:Find("Right/Popup"), false)
	onButton(arg0, arg0._tf:Find("Right/Popup"), function()
		var3(false)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Right/Collapse"), function()
		var3(true)
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Right/Auto"), function()
		arg0:AutoReplaceFurniture()
	end, SFX_PANEL)
	onButton(arg0, arg0.lableTrans, function()
		arg0:CleanSlot()
	end)

	arg0.furnitureItems = {}

	function arg0.furnitureScroll.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1
		arg0.furnitureItems[arg0] = arg1

		arg0:UpdateFurnitureItem(arg0)
	end

	arg0.replaceFurnitures = {}

	arg0.scene:EnterFurnitureWatchMode()
	arg0:UpdateZone()
	arg0:UpdateView()
end

function var0.UpdateZone(arg0)
	local var0 = arg0.apartment
	local var1 = var0:GetNormalZones()[arg0.zoneIndex]
	local var2 = {
		var1,
		unpack(var0:GetGlobalZones())
	}
	local var3 = _.reduce(var2, {}, function(arg0, arg1)
		table.insertto(arg0, arg1:GetSlots())

		return arg0
	end)

	arg0.activeFurnitureTypes = {}

	local var4 = 99

	_.each(var3, function(arg0)
		arg0.activeFurnitureTypes[arg0:GetType()] = true
		var4 = math.min(var4, arg0:GetType())
	end)

	arg0.activeFurnitureTypes = _.keys(arg0.activeFurnitureTypes)

	var1:SortTypes(arg0.activeFurnitureTypes)

	arg0.furnitureType = arg0.activeFurnitureTypes[1]

	setText(arg0._tf:Find("Right/Panel/Zone/Name"), var1:GetName())
	arg0:UpdateDisplayFurnitures()
end

function var0.UpdateDisplayFurnitures(arg0)
	local var0 = arg0.apartment
	local var1 = arg0.furnitureType

	arg0.selectMode = var0.SELECT_MODE.NONE
	arg0.selectFurnitureId = nil
	arg0.selectSlotId = nil

	local var2 = var0:GetFurnitures()
	local var3 = {}
	local var4 = {}

	_.each(var2, function(arg0)
		local var0 = arg0:GetConfigID()

		if var3[var0] then
			table.insert(var4[var3[var0]].instances, arg0)

			return
		end

		if arg0:GetType() ~= var1 then
			return
		end

		table.insert(var4, {
			useable = 0,
			id = var0,
			instances = {
				arg0
			}
		})

		var3[var0] = #var4
	end)

	arg0.displayFurnitures = var4

	_.each(arg0.displayFurnitures, function(arg0)
		arg0.useable = _.reduce(arg0.instances, 0, function(arg0, arg1)
			return arg0 + (arg1:GetSlotID() == 0 and 1 or 0)
		end)
	end)
	arg0:FilterFurnitures()
end

function var0.FilterFurnitures(arg0)
	local var0 = {
		function(arg0)
			return arg0.useable > 0 and 0 or 1
		end,
		function(arg0)
			return -arg0.instances[1]:GetRarity()
		end,
		function(arg0)
			return -arg0.id
		end
	}

	if arg0.selectMode == var0.SELECT_MODE.SLOT then
		local var1 = Dorm3dFurnitureSlot.New({
			configId = arg0.selectSlotId
		})

		_.each(arg0.displayFurnitures, function(arg0)
			local var0 = arg0.instances[1]

			arg0.fit = var1:CanUseFurniture(var0)
		end)
	end

	table.sort(arg0.displayFurnitures, CompareFuncs(var0))
end

function var0.UpdateView(arg0)
	local var0 = arg0.apartment
	local var1 = var0:GetNormalZones()

	UIItemList.StaticAlign(arg0.zoneList:Find("List"), arg0.zoneList:Find("List"):GetChild(0), #var1, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = var1[arg1]

		setText(arg2:Find("Name"), var0:GetName())
		onButton(arg0, arg2, function()
			arg0.zoneIndex = arg1

			arg0:UpdateZone()
			arg0:UpdateView()
			setActive(arg0.zoneList, false)
		end, SFX_PANEL)
		setActive(arg2:Find("Line"), arg1 < #var1)

		local var1 = arg2:Find("Name"):GetComponent(typeof(Text)).color
		local var2 = arg0.zoneIndex == arg1 and Color.NewHex("39bfff") or Color.white

		var2.a = var1.a

		setTextColor(arg2:Find("Name"), var2)
	end)
	UIItemList.StaticAlign(arg0._tf:Find("Right/Panel/Types"), arg0._tf:Find("Right/Panel/Types"):GetChild(0), #arg0.activeFurnitureTypes, function(arg0, arg1, arg2)
		if arg0 ~= UIItemList.EventUpdate then
			return
		end

		arg1 = arg1 + 1

		local var0 = arg0.activeFurnitureTypes[arg1]

		setText(arg2:Find("Name"), i18n(Dorm3dFurniture.TYPE2NAME[var0]))
		setActive(arg2:Find("Selected"), arg0.furnitureType == var0)
		onButton(arg0, arg2, function()
			if arg0.furnitureType == var0 then
				return
			end

			arg0.furnitureType = var0

			arg0:UpdateDisplayFurnitures()
			arg0:UpdateView()
			setActive(arg0.zoneList, false)
		end, SFX_PANEL)
	end)
	arg0.furnitureScroll:SetTotalCount(#arg0.displayFurnitures)
	setActive(arg0.furnitureEmpty, #arg0.displayFurnitures == 0)

	local var2 = {}
	local var3 = var1[arg0.zoneIndex]
	local var4 = arg0.furnitureType
	local var5 = {
		var3,
		unpack(var0:GetGlobalZones())
	}
	local var6 = _.reduce(var5, {}, function(arg0, arg1)
		table.insertto(arg0, arg1:GetSlots())

		return arg0
	end)
	local var7 = _.select(var6, function(arg0)
		return arg0:GetType() == var4
	end)

	_.each(var7, function(arg0)
		local var0 = arg0:GetConfigID()

		if arg0.selectMode == var0.SELECT_MODE.NONE then
			var2[var0] = 0
		elseif arg0.selectMode == var0.SELECT_MODE.FURNITURE then
			local var1 = arg0:CanUseFurniture(Dorm3dFurniture.New({
				configId = arg0.selectFurnitureId
			}))

			var2[var0] = var1 and 1 or 2
		elseif arg0.selectMode == var0.SELECT_MODE.SLOT then
			var2[var0] = arg0.selectSlotId == var0 and 1 or 0
		end
	end)

	local var8 = false

	if arg0.selectMode == var0.SELECT_MODE.SLOT then
		local var9 = Dorm3dFurnitureSlot.New({
			configId = arg0.selectSlotId
		})

		if var9:GetType() == Dorm3dFurniture.TYPE.DECORATION then
			local var10 = arg0.apartment:GetFurnitures()

			if _.detect(var10, function(arg0)
				return arg0:GetSlotID() == var9:GetConfigID()
			end) then
				local var11 = arg0.scene:GetSlotByID(var9:GetConfigID())
				local var12 = arg0.scene:GetScreenPosition(var11) or Vector2.New(-10000, -10000)

				setAnchoredPosition(arg0.lableTrans, var12)

				var8 = true
			end
		end
	end

	setActive(arg0.lableTrans, var8)

	if arg0.activeZoneId ~= var3:GetConfigID() then
		arg0.blockActive = true

		arg0.scene:SwitchZone(var3, function()
			arg0.blockActive = false
		end)

		arg0.activeZoneId = var3:GetConfigID()
	end

	arg0.scene:DisplayFurnitureSlots(_.map(var7, function(arg0)
		return arg0:GetConfigID()
	end))
	arg0.scene:UpdateDisplaySlots(var2)
	arg0.scene:RefreshSlots(arg0.apartment)
end

function var0.UpdateFurnitureItem(arg0, arg1)
	local var0 = arg0.furnitureItems[arg1]
	local var1 = arg0.displayFurnitures[arg1]

	if not var0 then
		return
	end

	local var2 = tf(var0)

	updateDrop(var2:Find("Item/Icon"), {
		type = DROP_TYPE_DORM3D_FURNITURE,
		id = var1.id
	})
	setText(var2:Find("Item/Name"), var1.instances[1]:GetName())

	local var3 = i18n("dorm3d_furniture_count", var1.useable .. "/" .. #var1.instances)

	if var1.useable < #var1.instances then
		var3 = i18n("dorm3d_furniture_used") .. var3
	end

	setText(var2:Find("Item/Count"), var3)
	setActive(var2:Find("Selected"), arg0.selectFurnitureId == var1.id)

	local var4 = arg0.selectMode == var0.SELECT_MODE.SLOT and not var1.fit

	setActive(var2:Find("Unfit"), var4)

	local var5 = not var4 and var1.useable == 0

	setActive(var2:Find("Lack"), var5)
	setCanvasGroupAlpha(var2:Find("Item"), (var4 or var5) and 0.3 or 1)
	onButton(arg0, var2:Find("Item/Tip"), function()
		arg0:emit(Dorm3dFurnitureSelectMediator.SHOW_FURNITURE_ACESSES, {
			showGOBtn = true,
			title = i18n("courtyard_label_detail"),
			drop = {
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var1.id,
				count = #var1.instances
			},
			list = var1.instances[1]:GetAcesses()
		})
	end, SFX_PANEL)
	onButton(arg0, var2, function()
		local var0 = var1.instances[1]:GetType()
		local var1 = function()
			local var0 = _.detect(arg0.apartment:GetGlobalZones()[1]:GetSlots(), function(arg0)
				return arg0:GetType() == var0
			end)

			if not var0 then
				return
			end

			arg0.apartment:ReplaceFurniture(var0:GetConfigID(), var1.id)
			table.insert(arg0.replaceFurnitures, {
				slotId = var0:GetConfigID(),
				furnitureId = var1.id
			})
			arg0:UpdateDisplayFurnitures()
		end

		if arg0.selectMode == var0.SELECT_MODE.NONE then
			if var1.useable > 0 then
				if var0 == Dorm3dFurniture.TYPE.FLOOR or var0 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1()
				else
					arg0.selectMode = var0.SELECT_MODE.FURNITURE
					arg0.selectFurnitureId = var1.id
				end

				arg0:UpdateView()
			end

			return
		end

		if arg0.selectMode == var0.SELECT_MODE.SLOT then
			if var1.fit and var1.useable > 0 then
				arg0.apartment:ReplaceFurniture(arg0.selectSlotId, var1.id)
				table.insert(arg0.replaceFurnitures, {
					slotId = arg0.selectSlotId,
					furnitureId = var1.id
				})
				arg0:UpdateDisplayFurnitures()
				arg0:UpdateView()
			end

			return
		end

		if arg0.selectMode == var0.SELECT_MODE.FURNITURE then
			if arg0.selectFurnitureId == var1.id then
				arg0.selectMode = var0.SELECT_MODE.NONE
				arg0.selectFurnitureId = nil

				arg0:UpdateView()
			elseif var1.useable > 0 then
				if var0 == Dorm3dFurniture.TYPE.FLOOR or var0 == Dorm3dFurniture.TYPE.WALLPAPER then
					var1()
				else
					arg0.selectFurnitureId = var1.id

					arg0:UpdateView()
				end
			end

			return
		end
	end, SFX_PANEL)
end

function var0.OnClickFurnitureSlot(arg0, arg1)
	if arg0.selectMode == var0.SELECT_MODE.FURNITURE then
		local var0 = _.detect(arg0.displayFurnitures, function(arg0)
			return arg0.id == arg0.selectFurnitureId
		end)
		local var1 = Dorm3dFurnitureSlot.New({
			configId = arg1
		})

		if var0 and var0.useable > 0 and var1:CanUseFurniture(var0.instances[1]) then
			arg0.apartment:ReplaceFurniture(arg1, var0.id)
			table.insert(arg0.replaceFurnitures, {
				slotId = arg1,
				furnitureId = var0.id
			})
			arg0:UpdateDisplayFurnitures()
		else
			return
		end
	elseif arg0.selectMode == var0.SELECT_MODE.NONE then
		arg0.selectMode = var0.SELECT_MODE.SLOT
		arg0.selectSlotId = arg1

		arg0:FilterFurnitures()
	elseif arg0.selectMode == var0.SELECT_MODE.SLOT then
		if arg0.selectSlotId == arg1 then
			arg0.selectMode = var0.SELECT_MODE.NONE
			arg0.selectSlotId = nil
		else
			arg0.selectSlotId = arg1
		end

		arg0:FilterFurnitures()
	end

	arg0:UpdateView()
end

function var0.CleanSlot(arg0)
	if arg0.selectMode ~= var0.SELECT_MODE.SLOT then
		return
	end

	local var0 = arg0.selectSlotId

	arg0.apartment:ReplaceFurniture(var0, 0)
	table.insert(arg0.replaceFurnitures, {
		furnitureId = 0,
		slotId = var0
	})
	arg0:UpdateDisplayFurnitures()
	arg0:UpdateView()
end

function var0.OnReplaceFurnitureDone(arg0)
	arg0.replaceFurnitures = {}

	existCall(arg0.replaceFurnitureCallback)

	arg0.replaceFurnitureCallback = nil
end

function var0.OnReplaceFurnitureError(arg0)
	arg0.replaceFurnitureCallback = nil
end

function var0.AutoReplaceFurniture(arg0)
	local var0 = arg0.apartment:GetNormalZones()[arg0.zoneIndex]:GetSlots()

	_.each(var0, function(arg0)
		if arg0:GetType() == Dorm3dFurniture.TYPE.FLOOR or arg0:GetType() == Dorm3dFurniture.TYPE.WALLPAPER then
			return
		end

		local var0 = arg0.apartment:GetFurnitures()
		local var1 = _.detect(var0, function(arg0)
			return arg0:GetSlotID() == arg0:GetConfigID()
		end)

		if var1 and var1:GetConfigID() ~= arg0:GetDefaultFurniture() then
			return
		end

		local var2 = table.shallowCopy(var0)
		local var3 = {
			function(arg0)
				return arg0:GetSlotID() == 0 and arg0:CanUseFurniture(arg0) and 0 or 1
			end,
			function(arg0)
				return -arg0:GetRarity()
			end,
			function(arg0)
				return -arg0:GetConfigID()
			end
		}

		table.sort(var2, CompareFuncs(var3))

		local var4 = var2[1]

		if not var4 or var4:GetSlotID() ~= 0 or not arg0:CanUseFurniture(var4) then
			return
		end

		arg0.apartment:ReplaceFurniture(arg0:GetConfigID(), var4:GetConfigID())
		table.insert(arg0.replaceFurnitures, {
			slotId = arg0:GetConfigID(),
			furnitureId = var4:GetConfigID()
		})
	end)
	arg0:UpdateView()
end

function var0.ShowReplaceWindow(arg0, arg1, arg2)
	local var0 = arg0.replaceFurnitures

	if #var0 == 0 then
		return existCall(arg1)
	end

	arg0:emit(Dorm3dFurnitureSelectMediator.SHOW_CONFIRM_WINDOW, {
		title = i18n("title_info"),
		content = i18n("dorm3d_replace_furniture_confirm"),
		onYes = function()
			arg0:emit(GAME.APARTMENT_REPLACE_FURNITURE, {
				shipGroupId = arg0.apartment:GetConfigID(),
				furnitures = var0
			})

			arg0.replaceFurnitureCallback = arg1
		end,
		onNo = arg2
	})
end

function var0.onBackPressed(arg0)
	if arg0.blockActive then
		return
	end

	seriesAsync({
		function(arg0)
			arg0:ShowReplaceWindow(arg0, arg0)
		end,
		function(arg0)
			var0.super.onBackPressed(arg0)
		end
	})
end

function var0.willExit(arg0)
	arg0.scene:ExitFurnitureWatchMode()
end

return var0
