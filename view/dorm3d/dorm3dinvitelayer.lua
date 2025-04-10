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

function var0_0.HideInvitePanel(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12.rtInvitePanel, arg0_12._tf)
	setActive(arg0_12.rtInvitePanel, false)
end

function var0_0.ShowSelectPanel(arg0_13)
	local var0_13 = arg0_13.room:getInviteList()
	local var1_13, var2_13 = arg0_13.room:getInteractRange()
	local var3_13 = {}
	local var4_13 = {}

	for iter0_13, iter1_13 in ipairs(var0_13) do
		if not arg0_13.room.unlockCharacter[iter1_13] then
			var4_13[iter1_13] = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(iter1_13) then
			var4_13[iter1_13] = "room"
		elseif Apartment.New({
			ship_group = iter1_13
		}):needDownload() then
			var4_13[iter1_13] = "download"
		else
			var4_13[iter1_13] = nil
		end
	end

	local var5_13 = getProxy(PlayerProxy):getRawData().id
	local var6_13 = arg0_13.rtSelectPanel:Find("window/character/container")

	UIItemList.StaticAlign(var6_13, var6_13:GetChild(0), #var0_13, function(arg0_14, arg1_14, arg2_14)
		arg1_14 = arg1_14 + 1

		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = var0_13[arg1_14]

			setActive(arg2_14:Find("base"), var0_14)
			setActive(arg2_14:Find("empty"), not var0_14)

			if not var0_14 then
				arg2_14.name = "null"

				setText(arg2_14:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_14.name = tostring(var0_14)

				arg0_13:UpdateSelectableCard(arg2_14:Find("base"), var0_14, function(arg0_15)
					table.removebyvalue(var3_13, var0_14, true)

					if arg0_15 then
						table.insert(var3_13, var0_14)
					end

					setText(arg0_13.rtSelectPanel:Find("window/bottom/title/Text"), i18n("dorm3d_select_tip") .. #var3_13 .. "/" .. var2_13)
				end)
				triggerToggle(arg2_14:Find("base"), table.contains(arg0_13.selectIds, var0_14))
				setActive(arg2_14:Find("base/mask"), var4_13[var0_14])
				onButton(arg0_13, arg2_14:Find("base/mask"), function()
					if var4_13[var0_14] == "lock" then
						arg0_13:HideSelectPanel()
						arg0_13:emit(Dorm3dInviteMediator.OPEN_ROOM_UNLOCK_WINDOW, arg0_13.room:GetConfigID(), var0_14)
					elseif var4_13[var0_14] == "room" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
					elseif var4_13[var0_14] == "download" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_beach_tip"))
					end
				end, SFX_PANEL)
				eachChild(arg2_14:Find("base/operation"), function(arg0_17)
					setActive(arg0_17, arg0_17.name == var4_13[var0_14])
				end)
			end

			setActive(arg2_14:Find("tip"), PlayerPrefs.GetInt(var5_13 .. "_dorm3dRoomInviteSuccess_" .. arg0_13.room.id .. "_" .. var0_14, 1) == 0)
			PlayerPrefs.SetInt(var5_13 .. "_dorm3dRoomInviteSuccess_" .. arg0_13.room.id .. "_" .. var0_14, 1)
		end
	end)
	PlayerPrefs.SetInt(var5_13 .. "_dorm3dRoomInviteSuccess_" .. arg0_13.room.id, 1)
	onButton(arg0_13, arg0_13.rtSelectPanel:Find("window/bottom/container/btn_confirm"), function()
		if #var3_13 > var2_13 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		arg0_13.selectIds = var3_13

		arg0_13:HideSelectPanel()
		arg0_13:ShowInvitePanel()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_13.rtSelectPanel, {
		force = true,
		weight = LayerWeightConst.SECOND_LAYER,
		pbList = {
			arg0_13.rtSelectPanel:Find("window")
		}
	})
	setActive(arg0_13.rtSelectPanel, true)
end

function var0_0.UpdateSelectableCard(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19 = Apartment.New({
		ship_group = arg2_19
	}):GetSkinModelID(arg0_19.room:getConfig("tag"))

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var0_19), "", arg1_19:Find("Image"))
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", arg2_19), "", arg1_19:Find("name"))

	local var1_19 = getProxy(ApartmentProxy):getApartment(arg2_19)
	local var2_19 = not var1_19 or var1_19:needDownload()

	setActive(arg1_19:Find("lock"), var2_19)
	setActive(arg1_19:Find("mask"), var2_19)
	setActive(arg1_19:Find("unlock"), not var2_19)
	setActive(arg1_19:Find("favor_level"), var1_19)

	if var1_19 then
		setText(arg1_19:Find("favor_level/Text"), var1_19.level)
	end

	onToggle(arg0_19, arg1_19, function(arg0_20)
		arg3_19(arg0_20)

		if arg0_20 then
			if not var1_19 then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need unlock apartment{%d}", arg2_19))
				triggerToggle(arg1_19, false)
			elseif var1_19:needDownload() then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need download resource{%d}", arg2_19))
				triggerToggle(arg1_19, false)
			end
		end
	end, SFX_UI_CLICK)
end

function var0_0.HideSelectPanel(arg0_21)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_21.rtSelectPanel, arg0_21._tf)
	setActive(arg0_21.rtSelectPanel, false)
end

function var0_0.UpdateRoom(arg0_22, arg1_22)
	arg0_22.room = arg1_22
end

function var0_0.didEnter(arg0_23)
	arg0_23.selectIds = underscore.filter(arg0_23.contextData.groupIds or {}, function(arg0_24)
		return arg0_23.room.unlockCharacter[arg0_24] and tobool(getProxy(ApartmentProxy):getApartment(arg0_24)) and not Apartment.New({
			ship_group = arg0_24
		}):needDownload()
	end)
	arg0_23.contextData.groupIds = nil

	arg0_23:ShowInvitePanel()
end

function var0_0.onBackPressed(arg0_25)
	if isActive(arg0_25.rtSelectPanel) then
		arg0_25:HideSelectPanel()
		arg0_25:ShowInvitePanel()
	else
		arg0_25:closeView()
	end
end

function var0_0.willExit(arg0_26)
	if isActive(arg0_26.rtSelectPanel) then
		arg0_26:HideSelectPanel()
	else
		arg0_26:HideInvitePanel()
	end
end

return var0_0
