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
		end
	end)
	onButton(arg0_6, arg0_6.rtInvitePanel:Find("window/btn_confirm"), function()
		if #arg0_6.selectIds < var0_6 or #arg0_6.selectIds > var1_6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		arg0_6:emit(Dorm3dInviteMediator.ON_DORM, {
			roomId = arg0_6.room.id,
			groupIds = underscore.rest(arg0_6.selectIds, 1)
		})
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_6.rtInvitePanel, {
		force = true,
		weight = LayerWeightConst.SECOND_LAYER
	})
	setActive(arg0_6.rtInvitePanel, true)
	pg.CriMgr.GetInstance():PlaySE_V3("ui-dorm_sidebar")
end

function var0_0.HideInvitePanel(arg0_10)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_10.rtInvitePanel, arg0_10._tf)
	setActive(arg0_10.rtInvitePanel, false)
end

function var0_0.ShowSelectPanel(arg0_11)
	local var0_11 = arg0_11.room:getInviteList()
	local var1_11, var2_11 = arg0_11.room:getInteractRange()
	local var3_11 = {}
	local var4_11 = {}

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if not arg0_11.room.unlockCharacter[iter1_11] then
			var4_11[iter1_11] = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(iter1_11) then
			var4_11[iter1_11] = "room"
		elseif Apartment.New({
			ship_group = iter1_11
		}):needDownload() then
			var4_11[iter1_11] = "download"
		else
			var4_11[iter1_11] = nil
		end
	end

	local var5_11 = arg0_11.rtSelectPanel:Find("window/character/container")

	UIItemList.StaticAlign(var5_11, var5_11:GetChild(0), #var0_11, function(arg0_12, arg1_12, arg2_12)
		arg1_12 = arg1_12 + 1

		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var0_11[arg1_12]

			setActive(arg2_12:Find("base"), var0_12)
			setActive(arg2_12:Find("empty"), not var0_12)

			if not var0_12 then
				arg2_12.name = "null"

				setText(arg2_12:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_12.name = tostring(var0_12)

				arg0_11:UpdateSelectableCard(arg2_12:Find("base"), var0_12, function(arg0_13)
					table.removebyvalue(var3_11, var0_12, true)

					if arg0_13 then
						table.insert(var3_11, var0_12)
					end

					setText(arg0_11.rtSelectPanel:Find("window/bottom/title/Text"), i18n("dorm3d_select_tip") .. #var3_11 .. "/" .. var2_11)
				end)
				triggerToggle(arg2_12:Find("base"), table.contains(arg0_11.selectIds, var0_12))
				setActive(arg2_12:Find("base/mask"), var4_11[var0_12])
				onButton(arg0_11, arg2_12:Find("base/mask"), function()
					if var4_11[var0_12] == "lock" then
						arg0_11:HideSelectPanel()
						arg0_11:emit(Dorm3dInviteMediator.OPEN_ROOM_UNLOCK_WINDOW, arg0_11.room:GetConfigID(), var0_12)
					elseif var4_11[var0_12] == "room" then
						pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
					elseif var4_11[var0_12] == "download" then
						pg.TipsMgr.GetInstance():ShowTips("please exit and download character resource in build scene ~")
					end
				end, SFX_PANEL)
				eachChild(arg2_12:Find("base/operation"), function(arg0_15)
					setActive(arg0_15, arg0_15.name == var4_11[var0_12])
				end)
			end
		end
	end)
	onButton(arg0_11, arg0_11.rtSelectPanel:Find("window/bottom/container/btn_confirm"), function()
		if #var3_11 > var2_11 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_data_Invite_lack"))

			return
		end

		arg0_11.selectIds = var3_11

		arg0_11:HideSelectPanel()
		arg0_11:ShowInvitePanel()
	end, SFX_CONFIRM)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_11.rtSelectPanel, {
		force = true,
		weight = LayerWeightConst.SECOND_LAYER,
		pbList = {
			arg0_11.rtSelectPanel:Find("window")
		}
	})
	setActive(arg0_11.rtSelectPanel, true)
end

function var0_0.UpdateSelectableCard(arg0_17, arg1_17, arg2_17, arg3_17)
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d_%d", arg2_17, arg0_17.contextData.roomId), "", arg1_17:Find("Image"))
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", arg2_17), "", arg1_17:Find("name"))

	local var0_17 = getProxy(ApartmentProxy):getApartment(arg2_17)
	local var1_17 = not var0_17 or var0_17:needDownload()

	setActive(arg1_17:Find("lock"), var1_17)
	setActive(arg1_17:Find("mask"), var1_17)
	setActive(arg1_17:Find("unlock"), not var1_17)
	setActive(arg1_17:Find("favor_level"), var0_17)

	if var0_17 then
		setText(arg1_17:Find("favor_level/Text"), var0_17.level)
	end

	onToggle(arg0_17, arg1_17, function(arg0_18)
		arg3_17(arg0_18)

		if arg0_18 then
			if not var0_17 then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need unlock apartment{%d}", arg2_17))
				triggerToggle(arg1_17, false)
			elseif var0_17:needDownload() then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need download resource{%d}", arg2_17))
				triggerToggle(arg1_17, false)
			end
		end
	end, SFX_UI_CLICK)
end

function var0_0.HideSelectPanel(arg0_19)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_19.rtSelectPanel, arg0_19._tf)
	setActive(arg0_19.rtSelectPanel, false)
end

function var0_0.didEnter(arg0_20)
	arg0_20.room = getProxy(ApartmentProxy):getRoom(arg0_20.contextData.roomId)
	arg0_20.selectIds = underscore.filter(arg0_20.contextData.groupIds or {}, function(arg0_21)
		return arg0_20.room.unlockCharacter[arg0_21] and tobool(getProxy(ApartmentProxy):getApartment(arg0_21)) and not Apartment.New({
			ship_group = arg0_21
		}):needDownload()
	end)
	arg0_20.contextData.groupIds = nil

	arg0_20:ShowInvitePanel()
end

function var0_0.onBackPressed(arg0_22)
	if isActive(arg0_22.rtSelectPanel) then
		arg0_22:HideSelectPanel()
		arg0_22:ShowInvitePanel()
	else
		arg0_22:closeView()
	end
end

function var0_0.willExit(arg0_23)
	if isActive(arg0_23.rtSelectPanel) then
		arg0_23:HideSelectPanel()
	else
		arg0_23:HideInvitePanel()
	end
end

return var0_0
