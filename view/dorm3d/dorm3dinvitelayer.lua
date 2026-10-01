local var0_0 = class("Dorm3dInviteLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dInviteWindow"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = arg1_2 or arg0_2.contextData or {}

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local var3_2 = var1_2.roomId and pg.dorm3d_rooms[var1_2.roomId]
	local var4_2 = {}

	local function var5_2(arg0_4)
		if arg0_4 and not table.contains(var4_2, arg0_4) then
			table.insert(var4_2, arg0_4)
		end
	end

	if var3_2 then
		if noEmptyStr(var3_2.assets_prefix) then
			var2_2("dorm3dselect/room_invite_" .. var3_2.assets_prefix)
		end

		for iter0_2, iter1_2 in ipairs(var3_2.character or {}) do
			var5_2(iter1_2)
		end

		for iter2_2, iter3_2 in ipairs(var3_2.character_pay or {}) do
			var5_2(iter3_2)
		end
	end

	for iter4_2, iter5_2 in ipairs(var1_2.groupIds or {}) do
		var5_2(iter5_2)
	end

	for iter6_2, iter7_2 in ipairs(var4_2) do
		local var6_2 = pg.dorm3d_resource.get_id_list_by_ship_group[iter7_2]
		local var7_2 = var6_2 and var6_2[1]
		local var8_2 = var7_2 and pg.dorm3d_resource[var7_2]

		var2_2(var8_2 and var8_2.head_Icon)

		if var3_2 then
			local var9_2 = Apartment.New({
				ship_group = iter7_2
			}):GetSkinModelID(var3_2.tag)

			if var9_2 then
				var2_2(string.format("dorm3dselect/room_card_apartment_%d", var9_2))
			end

			var2_2(string.format("dorm3dselect/room_card_apartment_name_%d", iter7_2))
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_5)
	arg0_5.rtInvitePanel = arg0_5._tf:Find("invite_panel")

	setText(arg0_5.rtInvitePanel:Find("window/Text"), i18n("dorm3d_invite_beach_tip"))
	setText(arg0_5.rtInvitePanel:Find("window/btn_confirm/Text"), i18n("text_confirm"))
	onButton(arg0_5, arg0_5.rtInvitePanel:Find("bg"), function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.rtInvitePanel:Find("window/btn_close"), function()
		arg0_5:closeView()
	end, SFX_CANCEL)

	arg0_5.rtSelectPanel = arg0_5._tf:Find("select_panel")

	setText(arg0_5.rtSelectPanel:Find("window/character/title"), i18n("dorm3d_select_tip"))
	onButton(arg0_5, arg0_5.rtSelectPanel:Find("bg"), function()
		arg0_5:HideSelectPanel()
		arg0_5:ShowInvitePanel()
	end, SFX_CANCEL)
	setText(arg0_5.rtSelectPanel:Find("window/title/Text"), i18n("dorm3d_data_choose"))
	setText(arg0_5.rtSelectPanel:Find("window/bottom/container/btn_confirm/Text"), i18n("text_confirm"))

	arg0_5.selectCountTip = i18n("dorm3d_select_tip")
end

function var0_0.ShowInvitePanel(arg0_9)
	GetImageSpriteFromAtlasAsync("dorm3dselect/room_invite_" .. arg0_9.room:getConfig("assets_prefix"), "", arg0_9.rtInvitePanel:Find("window/Image"))
	setText(arg0_9.rtInvitePanel:Find("window/Text"), i18n("dorm3d_data_go", arg0_9.room:getRoomName()))

	local var0_9, var1_9 = arg0_9.room:getInteractRange()
	local var2_9 = arg0_9.rtInvitePanel:Find("window/container")

	UIItemList.StaticAlign(var2_9, var2_9:GetChild(0), var1_9, function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.selectIds[arg1_10]

			setActive(arg2_10:Find("empty"), not var0_10)
			setActive(arg2_10:Find("ship"), var0_10)

			if var0_10 then
				local var1_10 = pg.dorm3d_resource.get_id_list_by_ship_group[var0_10][1]

				GetImageSpriteFromAtlasAsync(pg.dorm3d_resource[var1_10].head_Icon, "", arg2_10:Find("ship"), true)
			end

			onButton(arg0_9, arg2_10, function()
				arg0_9:HideInvitePanel()
				arg0_9:ShowSelectPanel()
			end, SFX_PANEL)

			if arg1_10 == var1_9 or not var0_10 then
				local var2_10 = getProxy(PlayerProxy):getRawData().id

				setActive(arg2_10:Find("tip"), PlayerPrefs.GetInt(var2_10 .. "_dorm3dRoomInviteSuccess_" .. arg0_9.room.id, 1) == 0)
			end
		end
	end)
	onButton(arg0_9, arg0_9.rtInvitePanel:Find("window/btn_confirm"), function()
		if #arg0_9.selectIds < var0_9 or #arg0_9.selectIds > var1_9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		local var0_12 = {}

		if #arg0_9.selectIds >= 3 and not ApartmentProxy.CheckDeviceRAMEnough() then
			table.insert(var0_12, function(arg0_13)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("drom3d_beach_memory_limit_tip"),
					onYes = arg0_13
				})
			end)
		end

		table.insert(var0_12, function(arg0_14)
			getProxy(ApartmentProxy):SetRoomInviteList(arg0_9.room.id, arg0_9.selectIds)
			arg0_14()
		end)
		seriesAsync(var0_12, function()
			arg0_9:emit(Dorm3dInviteMediator.ON_DORM, {
				roomId = arg0_9.room.id,
				groupIds = underscore.to_array(arg0_9.selectIds)
			})
		end)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_9.rtInvitePanel, {
		force = true
	})
	setActive(arg0_9.rtInvitePanel, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_sidebar")
end

function var0_0.HideInvitePanel(arg0_16)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_16.rtInvitePanel, arg0_16._tf)
	setActive(arg0_16.rtInvitePanel, false)
end

function var0_0.ShowSelectPanel(arg0_17)
	local var0_17 = arg0_17.room:getInviteList()
	local var1_17, var2_17 = arg0_17.room:getInteractRange()
	local var3_17 = {}
	local var4_17 = {}

	for iter0_17, iter1_17 in ipairs(var0_17) do
		if not arg0_17.room.unlockCharacter[iter1_17] then
			var4_17[iter1_17] = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(iter1_17) then
			var4_17[iter1_17] = "room"
		elseif Apartment.New({
			ship_group = iter1_17
		}):needDownload() then
			var4_17[iter1_17] = "download"
		else
			var4_17[iter1_17] = nil
		end
	end

	local var5_17 = getProxy(PlayerProxy):getRawData().id
	local var6_17 = arg0_17.rtSelectPanel:Find("window/character/container")

	UIItemList.StaticAlign(var6_17, var6_17:GetChild(0), #var0_17, function(arg0_18, arg1_18, arg2_18)
		arg1_18 = arg1_18 + 1

		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = var0_17[arg1_18]

			setActive(arg2_18:Find("base"), var0_18)
			setActive(arg2_18:Find("empty"), not var0_18)

			if not var0_18 then
				arg2_18.name = "null"

				setText(arg2_18:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_18.name = tostring(var0_18)

				arg0_17:UpdateSelectableCard(arg2_18:Find("base"), var0_18, function(arg0_19)
					table.removebyvalue(var3_17, var0_18, true)

					if arg0_19 then
						table.insert(var3_17, var0_18)
					end

					setText(arg0_17.rtSelectPanel:Find("window/bottom/title/Text"), arg0_17.selectCountTip .. #var3_17 .. "/" .. var2_17)
				end)
				triggerToggle(arg2_18:Find("base"), table.contains(arg0_17.selectIds, var0_18))
				setActive(arg2_18:Find("base/mask"), var4_17[var0_18])
				onButton(arg0_17, arg2_18:Find("base/mask"), function()
					if var4_17[var0_18] == "lock" then
						arg0_17:HideSelectPanel()
						arg0_17:emit(Dorm3dInviteMediator.OPEN_ROOM_UNLOCK_WINDOW, arg0_17.room:GetConfigID(), var0_18)
					elseif var4_17[var0_18] == "room" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
					elseif var4_17[var0_18] == "download" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_beach_tip"))
					end
				end, SFX_PANEL)
				eachChild(arg2_18:Find("base/operation"), function(arg0_21)
					setActive(arg0_21, arg0_21.name == var4_17[var0_18])
				end)
			end

			setActive(arg2_18:Find("tip"), PlayerPrefs.GetInt(var5_17 .. "_dorm3dRoomInviteSuccess_" .. arg0_17.room.id .. "_" .. var0_18, 1) == 0)
			PlayerPrefs.SetInt(var5_17 .. "_dorm3dRoomInviteSuccess_" .. arg0_17.room.id .. "_" .. var0_18, 1)
		end
	end)
	PlayerPrefs.SetInt(var5_17 .. "_dorm3dRoomInviteSuccess_" .. arg0_17.room.id, 1)
	onButton(arg0_17, arg0_17.rtSelectPanel:Find("window/bottom/container/btn_confirm"), function()
		if #var3_17 > var2_17 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		arg0_17.selectIds = var3_17

		arg0_17:HideSelectPanel()
		arg0_17:ShowInvitePanel()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_17.rtSelectPanel, {
		force = true,
		pbList = {
			arg0_17.rtSelectPanel:Find("window")
		}
	})
	setActive(arg0_17.rtSelectPanel, true)
end

function var0_0.UpdateSelectableCard(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = Apartment.New({
		ship_group = arg2_23
	}):GetSkinModelID(arg0_23.room:getConfig("tag"))

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var0_23), "", arg1_23:Find("Image"))
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", arg2_23), "", arg1_23:Find("name"))

	local var1_23 = getProxy(ApartmentProxy):getApartment(arg2_23)
	local var2_23 = not var1_23 or var1_23:needDownload()

	setActive(arg1_23:Find("lock"), var2_23)
	setActive(arg1_23:Find("mask"), var2_23)
	setActive(arg1_23:Find("unlock"), not var2_23)
	setActive(arg1_23:Find("favor_level"), var1_23)

	if var1_23 then
		setText(arg1_23:Find("favor_level/Text"), var1_23.level)
	end

	onToggle(arg0_23, arg1_23, function(arg0_24)
		arg3_23(arg0_24)

		if arg0_24 then
			if not var1_23 then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need unlock apartment{%d}", arg2_23))
				triggerToggle(arg1_23, false)
			elseif var1_23:needDownload() then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need download resource{%d}", arg2_23))
				triggerToggle(arg1_23, false)
			end
		end
	end, SFX_UI_CLICK)
end

function var0_0.HideSelectPanel(arg0_25)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25.rtSelectPanel, arg0_25._tf)
	setActive(arg0_25.rtSelectPanel, false)
end

function var0_0.UpdateRoom(arg0_26, arg1_26)
	arg0_26.room = arg1_26
end

function var0_0.didEnter(arg0_27)
	arg0_27.selectIds = underscore.filter(arg0_27.contextData.groupIds or {}, function(arg0_28)
		return arg0_27.room.unlockCharacter[arg0_28] and tobool(getProxy(ApartmentProxy):getApartment(arg0_28)) and not Apartment.New({
			ship_group = arg0_28
		}):needDownload()
	end)
	arg0_27.contextData.groupIds = nil

	arg0_27:ShowInvitePanel()
end

function var0_0.onBackPressed(arg0_29)
	if isActive(arg0_29.rtSelectPanel) then
		arg0_29:HideSelectPanel()
		arg0_29:ShowInvitePanel()
	else
		arg0_29:closeView()
	end
end

function var0_0.willExit(arg0_30)
	if isActive(arg0_30.rtSelectPanel) then
		arg0_30:HideSelectPanel()
	else
		arg0_30:HideInvitePanel()
	end
end

return var0_0
