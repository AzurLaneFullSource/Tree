local var0_0 = class("Dorm3dInviteLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dInviteWindow"
end

function var0_0.init(arg0_2)
	arg0_2.rtInvitePanel = arg0_2._tf:Find("invite_panel")

	setText(arg0_2.rtInvitePanel:Find("window/Text"), i18n("dorm3d_invite_beach_tip"))
	setText(arg0_2.rtInvitePanel:Find("window/btn_confirm/Text"), i18n("text_confirm"))
	onButton(arg0_2, arg0_2.rtInvitePanel:Find("bg"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.rtInvitePanel:Find("window/btn_close"), function()
		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.rtSelectPanel = arg0_2._tf:Find("select_panel")

	setText(arg0_2.rtSelectPanel:Find("window/character/title"), i18n("dorm3d_select_tip"))
	onButton(arg0_2, arg0_2.rtSelectPanel:Find("bg"), function()
		arg0_2:HideSelectPanel()
		arg0_2:ShowInvitePanel()
	end, SFX_CANCEL)
	setText(arg0_2.rtSelectPanel:Find("window/title/Text"), i18n("dorm3d_data_choose"))
	setText(arg0_2.rtSelectPanel:Find("window/bottom/container/btn_confirm/Text"), i18n("text_confirm"))
end

function var0_0.ShowInvitePanel(arg0_6)
	GetImageSpriteFromAtlasAsync("dorm3dselect/room_invite_" .. arg0_6.room:getConfig("assets_prefix"), "", arg0_6.rtInvitePanel:Find("window/Image"))
	setText(arg0_6.rtInvitePanel:Find("window/Text"), i18n("dorm3d_data_go", arg0_6.room:getRoomName()))

	local var0_6, var1_6 = arg0_6.room:getInteractRange()
	local var2_6 = arg0_6.rtInvitePanel:Find("window/container")

	UIItemList.StaticAlign(var2_6, var2_6:GetChild(0), var1_6, function(arg0_7, arg1_7, arg2_7)
		arg1_7 = arg1_7 + 1

		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg0_6.selectIds[arg1_7]

			setActive(arg2_7:Find("empty"), not var0_7)
			setActive(arg2_7:Find("ship"), var0_7)

			if var0_7 then
				local var1_7 = pg.dorm3d_resource.get_id_list_by_ship_group[var0_7][1]

				GetImageSpriteFromAtlasAsync(pg.dorm3d_resource[var1_7].head_Icon, "", arg2_7:Find("ship"), true)
			end

			onButton(arg0_6, arg2_7, function()
				arg0_6:HideInvitePanel()
				arg0_6:ShowSelectPanel()
			end, SFX_PANEL)

			if arg1_7 == var1_6 or not var0_7 then
				local var2_7 = getProxy(PlayerProxy):getRawData().id

				setActive(arg2_7:Find("tip"), PlayerPrefs.GetInt(var2_7 .. "_dorm3dRoomInviteSuccess_" .. arg0_6.room.id, 1) == 0)
			end
		end
	end)
	onButton(arg0_6, arg0_6.rtInvitePanel:Find("window/btn_confirm"), function()
		if #arg0_6.selectIds < var0_6 or #arg0_6.selectIds > var1_6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		local var0_9 = {}

		if #arg0_6.selectIds >= 3 and not ApartmentProxy.CheckDeviceRAMEnough() then
			table.insert(var0_9, function(arg0_10)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("drom3d_beach_memory_limit_tip"),
					onYes = arg0_10
				})
			end)
		end

		table.insert(var0_9, function(arg0_11)
			getProxy(ApartmentProxy):SetRoomInviteList(arg0_6.room.id, arg0_6.selectIds)
			arg0_11()
		end)
		seriesAsync(var0_9, function()
			arg0_6:emit(Dorm3dInviteMediator.ON_DORM, {
				roomId = arg0_6.room.id,
				groupIds = underscore.rest(arg0_6.selectIds, 1)
			})
		end)
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6.rtInvitePanel, {
		force = true,
		weight = LayerWeightConst.SECOND_LAYER
	})
	setActive(arg0_6.rtInvitePanel, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_sidebar")
end

function var0_0.HideInvitePanel(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13.rtInvitePanel, arg0_13._tf)
	setActive(arg0_13.rtInvitePanel, false)
end

function var0_0.ShowSelectPanel(arg0_14)
	local var0_14 = arg0_14.room:getInviteList()
	local var1_14, var2_14 = arg0_14.room:getInteractRange()
	local var3_14 = {}
	local var4_14 = {}

	for iter0_14, iter1_14 in ipairs(var0_14) do
		if not arg0_14.room.unlockCharacter[iter1_14] then
			var4_14[iter1_14] = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(iter1_14) then
			var4_14[iter1_14] = "room"
		elseif Apartment.New({
			ship_group = iter1_14
		}):needDownload() then
			var4_14[iter1_14] = "download"
		else
			var4_14[iter1_14] = nil
		end
	end

	local var5_14 = getProxy(PlayerProxy):getRawData().id
	local var6_14 = arg0_14.rtSelectPanel:Find("window/character/container")

	UIItemList.StaticAlign(var6_14, var6_14:GetChild(0), #var0_14, function(arg0_15, arg1_15, arg2_15)
		arg1_15 = arg1_15 + 1

		if arg0_15 == UIItemList.EventUpdate then
			local var0_15 = var0_14[arg1_15]

			setActive(arg2_15:Find("base"), var0_15)
			setActive(arg2_15:Find("empty"), not var0_15)

			if not var0_15 then
				arg2_15.name = "null"

				setText(arg2_15:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_15.name = tostring(var0_15)

				arg0_14:UpdateSelectableCard(arg2_15:Find("base"), var0_15, function(arg0_16)
					table.removebyvalue(var3_14, var0_15, true)

					if arg0_16 then
						table.insert(var3_14, var0_15)
					end

					setText(arg0_14.rtSelectPanel:Find("window/bottom/title/Text"), i18n("dorm3d_select_tip") .. #var3_14 .. "/" .. var2_14)
				end)
				triggerToggle(arg2_15:Find("base"), table.contains(arg0_14.selectIds, var0_15))
				setActive(arg2_15:Find("base/mask"), var4_14[var0_15])
				onButton(arg0_14, arg2_15:Find("base/mask"), function()
					if var4_14[var0_15] == "lock" then
						arg0_14:HideSelectPanel()
						arg0_14:emit(Dorm3dInviteMediator.OPEN_ROOM_UNLOCK_WINDOW, arg0_14.room:GetConfigID(), var0_15)
					elseif var4_14[var0_15] == "room" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
					elseif var4_14[var0_15] == "download" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_beach_tip"))
					end
				end, SFX_PANEL)
				eachChild(arg2_15:Find("base/operation"), function(arg0_18)
					setActive(arg0_18, arg0_18.name == var4_14[var0_15])
				end)
			end

			setActive(arg2_15:Find("tip"), PlayerPrefs.GetInt(var5_14 .. "_dorm3dRoomInviteSuccess_" .. arg0_14.room.id .. "_" .. var0_15, 1) == 0)
			PlayerPrefs.SetInt(var5_14 .. "_dorm3dRoomInviteSuccess_" .. arg0_14.room.id .. "_" .. var0_15, 1)
		end
	end)
	PlayerPrefs.SetInt(var5_14 .. "_dorm3dRoomInviteSuccess_" .. arg0_14.room.id, 1)
	onButton(arg0_14, arg0_14.rtSelectPanel:Find("window/bottom/container/btn_confirm"), function()
		if #var3_14 > var2_14 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		arg0_14.selectIds = var3_14

		arg0_14:HideSelectPanel()
		arg0_14:ShowInvitePanel()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_14.rtSelectPanel, {
		force = true,
		weight = LayerWeightConst.SECOND_LAYER,
		pbList = {
			arg0_14.rtSelectPanel:Find("window")
		}
	})
	setActive(arg0_14.rtSelectPanel, true)
end

function var0_0.UpdateSelectableCard(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = Apartment.New({
		ship_group = arg2_20
	}):GetSkinModelID(arg0_20.room:getConfig("tag"))

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var0_20), "", arg1_20:Find("Image"))
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", arg2_20), "", arg1_20:Find("name"))

	local var1_20 = getProxy(ApartmentProxy):getApartment(arg2_20)
	local var2_20 = not var1_20 or var1_20:needDownload()

	setActive(arg1_20:Find("lock"), var2_20)
	setActive(arg1_20:Find("mask"), var2_20)
	setActive(arg1_20:Find("unlock"), not var2_20)
	setActive(arg1_20:Find("favor_level"), var1_20)

	if var1_20 then
		setText(arg1_20:Find("favor_level/Text"), var1_20.level)
	end

	onToggle(arg0_20, arg1_20, function(arg0_21)
		arg3_20(arg0_21)

		if arg0_21 then
			if not var1_20 then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need unlock apartment{%d}", arg2_20))
				triggerToggle(arg1_20, false)
			elseif var1_20:needDownload() then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need download resource{%d}", arg2_20))
				triggerToggle(arg1_20, false)
			end
		end
	end, SFX_UI_CLICK)
end

function var0_0.HideSelectPanel(arg0_22)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_22.rtSelectPanel, arg0_22._tf)
	setActive(arg0_22.rtSelectPanel, false)
end

function var0_0.UpdateRoom(arg0_23, arg1_23)
	arg0_23.room = arg1_23
end

function var0_0.didEnter(arg0_24)
	arg0_24.selectIds = underscore.filter(arg0_24.contextData.groupIds or {}, function(arg0_25)
		return arg0_24.room.unlockCharacter[arg0_25] and tobool(getProxy(ApartmentProxy):getApartment(arg0_25)) and not Apartment.New({
			ship_group = arg0_25
		}):needDownload()
	end)
	arg0_24.contextData.groupIds = nil

	arg0_24:ShowInvitePanel()
end

function var0_0.onBackPressed(arg0_26)
	if isActive(arg0_26.rtSelectPanel) then
		arg0_26:HideSelectPanel()
		arg0_26:ShowInvitePanel()
	else
		arg0_26:closeView()
	end
end

function var0_0.willExit(arg0_27)
	if isActive(arg0_27.rtSelectPanel) then
		arg0_27:HideSelectPanel()
	else
		arg0_27:HideInvitePanel()
	end
end

return var0_0
