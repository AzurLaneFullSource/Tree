local var0_0 = class("SelectDorm3DScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SelectDorm3DUI"
end

var0_0.optionsPath = {
	"Main/option"
}

function var0_0.init(arg0_2)
	arg0_2.rtMap = arg0_2._tf:Find("Map")
	arg0_2.rtIconTip = arg0_2.rtMap:Find("tip")

	setActive(arg0_2.rtIconTip, false)
	onButton(arg0_2, arg0_2.rtIconTip:Find("bg"), function()
		arg0_2:HideIconTipWindow()
	end, SFX_CANCEL)
	setText(arg0_2.rtIconTip:Find("window/btn_cancel/Text"), i18n("text_cancel"))
	onButton(arg0_2, arg0_2.rtIconTip:Find("window/btn_cancel"), function()
		arg0_2:HideIconTipWindow()
	end, SFX_CANCEL)
	setText(arg0_2.rtIconTip:Find("window/btn_confirm/Text"), i18n("text_confirm"))

	arg0_2.rtMain = arg0_2._tf:Find("Main")

	setText(arg0_2.rtMain:Find("title/Text"), i18n("dorm3d_role_choose"))
	onButton(arg0_2, arg0_2.rtMain:Find("btn_back"), function()
		arg0_2.clearSceneCache = true

		arg0_2:closeView()
	end, SFX_CANCEL)

	arg0_2.insBtn = Dorm3dInsBtn.New(arg0_2.rtMain:Find("btn_ins"))

	onButton(arg0_2, arg0_2.insBtn.root, function()
		arg0_2:emit(SelectDorm3DMediator.OPEN_INS_LAYER, arg0_2.insBtn.IsNewPhoneCall())
	end)
	setActive(arg0_2.rtMain:Find("btn_ins"), not DORM_LOCK_INS)

	local var0_2 = getProxy(PlayerProxy):getRawData().id

	if not pg.TimeMgr.GetInstance():IsSameWeek(pg.TimeMgr.GetInstance():GetServerTime(), PlayerPrefs.GetInt(var0_2 .. "_dorm3dGiftWeekRefreshTimeStamp", 0)) then
		ApartmentProxy.RefreshGiftDailyTip()
	end

	setActive(arg0_2.rtMain:Find("btn_shop/tip"), Dorm3dShopUI.ShouldShowAllTip())
	onButton(arg0_2, arg0_2.rtMain:Find("btn_shop"), function()
		arg0_2:emit(SelectDorm3DMediator.OPEN_SHOP_LAYER, function()
			setActive(arg0_2.rtMain:Find("btn_shop/tip"), Dorm3dShopUI.ShouldShowAllTip())
		end)
	end)

	arg0_2.rtStamina = arg0_2.rtMain:Find("stamina")
	arg0_2.rtRes = arg0_2.rtMain:Find("res")

	arg0_2:InitResBar()

	arg0_2.rtWeekTask = arg0_2.rtMain:Find("task")

	arg0_2:UpdateWeekTask()

	arg0_2.rtLayer = arg0_2._tf:Find("Layer")
	arg0_2.rtMgrPanel = arg0_2.rtLayer:Find("mgr_panel")

	onButton(arg0_2, arg0_2.rtMgrPanel:Find("bg"), function()
		arg0_2:HideMgrPanel()
	end, SFX_CANCEL)
	setText(arg0_2.rtMgrPanel:Find("window/title/Text"), i18n("dorm3d_role_manage"))

	arg0_2.rtMgrChar = arg0_2.rtMgrPanel:Find("window/character")

	setText(arg0_2.rtMgrChar:Find("title"), i18n("dorm3d_role_manage_role"))

	local var1_2 = arg0_2.rtMgrChar:Find("container")

	arg0_2.charRoomCardItemList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	arg0_2.charRoomCardItemList:make(function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_2.filterCharRoomIds[arg1_10]

			setActive(arg2_10:Find("base"), var0_10)
			setActive(arg2_10:Find("empty"), not var0_10)

			if not var0_10 then
				arg2_10.name = "null"

				setText(arg2_10:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_10.name = tostring(var0_10)
				arg0_2.cardDic[var0_10] = arg2_10:Find("base")

				arg0_2:InitCardTrigger(var0_10)
				arg0_2:UpdateCardState(var0_10)

				return
			end
		end
	end)

	arg0_2.rtMgrPublic = arg0_2.rtMgrPanel:Find("window/public")

	setText(arg0_2.rtMgrPublic:Find("title"), i18n("dorm3d_role_manage_public_area"))

	local var2_2 = arg0_2.rtMgrPublic:Find("container")

	arg0_2.publicRoomCardItemList = UIItemList.New(var2_2, var2_2:Find("tpl"))

	arg0_2.publicRoomCardItemList:make(function(arg0_11, arg1_11, arg2_11)
		arg1_11 = arg1_11 + 1

		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg0_2.filterPublicRoomIds[arg1_11]

			arg0_2.cardDic[var0_11] = arg2_11

			arg0_2:InitCardTrigger(var0_11)
			arg0_2:UpdateCardState(var0_11)
		end
	end)
end

function var0_0.didEnter(arg0_12)
	arg0_12.contextData.floorName = arg0_12.contextData.floorName or "floor_1"

	arg0_12:SetFloor(arg0_12.contextData.floorName)
	arg0_12:UpdateStamina()
	arg0_12:CheckGuide("DORM3D_GUIDE_02")
	arg0_12:FlushInsBtn()

	if not ApartmentProxy.CheckDeviceRAMEnough() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("drom3d_memory_limit_tip"))
	end
end

function var0_0.FlushInsBtn(arg0_13)
	arg0_13.insBtn:Flush()
end

function var0_0.UpdateStamina(arg0_14)
	setText(arg0_14.rtStamina:Find("Text"), string.format("%d/%d", getProxy(ApartmentProxy):getStamina()))
	setActive(arg0_14.rtStamina:Find("vfx_ui_stamina01"), getProxy(ApartmentProxy):getStamina() > 0)
end

function var0_0.SetFloor(arg0_15, arg1_15)
	local var0_15

	eachChild(arg0_15.rtMap, function(arg0_16)
		setActive(arg0_16, arg0_16.name == arg1_15)

		if arg0_16.name == arg1_15 then
			var0_15 = arg0_16
		end
	end)
	assert(var0_15)

	arg0_15.roomDic = {}

	for iter0_15, iter1_15 in ipairs(pg.dorm3d_rooms.get_id_list_by_in_map[arg1_15]) do
		arg0_15.roomDic[iter1_15] = var0_15:Find(pg.dorm3d_rooms[iter1_15].assets_prefix)

		arg0_15:InitIconTrigger(iter1_15)
		arg0_15:UpdateIconState(iter1_15)
	end

	arg0_15:ReplaceSpecialRoomIcon()
end

function var0_0.FlushFloor(arg0_17)
	arg0_17:SetFloor(arg0_17.contextData.floorName)
end

function var0_0.InitIconTrigger(arg0_18, arg1_18)
	local var0_18 = arg0_18.roomDic[arg1_18]
	local var1_18 = pg.dorm3d_rooms[arg1_18].assets_prefix

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(var1_18)), "", var0_18:Find("icon"))
	onButton(arg0_18, var0_18, function()
		if BLOCK_DORM3D_ROOMS and table.contains(BLOCK_DORM3D_ROOMS, arg1_18) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_system_switch"))

			return
		end

		if arg1_18 ~= 1 and (not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

			return
		end

		local var0_19 = getProxy(ApartmentProxy):getRoom(arg1_18)
		local var1_19 = pg.dorm3d_rooms[arg1_18].type

		if var1_19 == 1 then
			if not var0_19 then
				arg0_18:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_18)
			else
				arg0_18:TryDownloadResource({
					click = true,
					roomId = arg1_18
				}, function()
					local var0_20 = underscore.map(string.split(PlayerPrefs.GetString(string.format("room%d_invite_list", arg1_18), ""), "|"), function(arg0_21)
						return tonumber(arg0_21)
					end)

					if arg0_18:CheckGuide("DORM3D_GUIDE_06") then
						var0_20 = {}
					end

					arg0_18:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_18, var0_20, function()
						arg0_18:FlushFloor()
					end)
				end)
			end
		elseif var1_19 == 2 then
			if not var0_19 then
				arg0_18:ShowIconTipWindow(arg1_18, var0_18)
			else
				arg0_18:TryDownloadResource({
					click = true,
					roomId = arg1_18
				}, function()
					arg0_18:emit(SelectDorm3DMediator.ON_DORM, {
						roomId = var0_19.id,
						groupIds = var0_19:getInviteList()
					})
				end)
			end
		else
			assert(false)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateIconState(arg0_24, arg1_24)
	local var0_24 = arg0_24.roomDic[arg1_24]
	local var1_24 = getProxy(ApartmentProxy):getRoom(arg1_24)
	local var2_24 = var1_24 and var1_24:getState() or "lock"

	setActive(var0_24:Find("icon/mask"), var2_24 ~= "complete")
	eachChild(var0_24:Find("front"), function(arg0_25)
		setActive(arg0_25, arg0_25.name == var2_24)
	end)
	switch(var2_24, {
		loading = function()
			local var0_26 = DormGroupConst.DormDownloadLock

			setSlider(var0_24:Find("front/loading/progress"), 0, var0_26.totalSize, var0_26.curSize)
		end,
		complete = function()
			local var0_27 = var0_24:Find("front/complete")
			local var1_27 = var1_24:isPersonalRoom()

			setActive(var0_27, var1_27)

			if var1_27 then
				local var2_27 = getProxy(ApartmentProxy):getApartment(var1_24:getPersonalGroupId())
				local var3_27 = var2_27:getIconTip(var1_24:GetConfigID())

				eachChild(var0_27:Find("tip"), function(arg0_28)
					setActive(arg0_28, arg0_28.name == var3_27)
				end)
				setText(var0_27:Find("favor/Text"), var2_27.level)
			end
		end
	})

	local var3_24 = getProxy(PlayerProxy):getRawData().id

	if var0_24:Find("tip") then
		setActive(var0_24:Find("tip"), PlayerPrefs.GetInt(var3_24 .. "_dorm3dRoomInviteSuccess_" .. arg1_24, 1) == 0)
	end
end

function var0_0.UpdateShowIcon(arg0_29, arg1_29, arg2_29)
	removeOnButton(arg2_29)
	setActive(arg2_29:Find("icon/mask"), false)
	eachChild(arg2_29:Find("front"), function(arg0_30)
		setActive(arg0_30, false)
	end)
end

function var0_0.ReplaceSpecialRoomIcon(arg0_31)
	local var0_31 = {}

	for iter0_31, iter1_31 in pairs(getProxy(ApartmentProxy):getRawData()) do
		for iter2_31, iter3_31 in ipairs(iter1_31:getSpecialTalking()) do
			local var1_31 = pg.dorm3d_dialogue_group[iter3_31].trigger_config[1]

			var0_31[var1_31] = var0_31[var1_31] or {}

			table.insert(var0_31[var1_31], iter3_31)
		end
	end

	for iter4_31, iter5_31 in pairs(var0_31) do
		setActive(arg0_31.roomDic[iter4_31], false)

		local var2_31 = cloneTplTo(arg0_31.roomDic[iter4_31], arg0_31.roomDic[iter4_31].parent, arg0_31.roomDic[iter4_31].name .. "_special")

		arg0_31:UpdateShowIcon(iter4_31, var2_31)
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(pg.dorm3d_rooms[iter4_31].assets_prefix)), "", var2_31:Find("icon"))
		setActive(var2_31:Find("front/complete"), true)
		setActive(var2_31:Find("front/complete/favor"), false)
		eachChild(var2_31:Find("front/complete/tip"), function(arg0_32)
			setActive(arg0_32, arg0_32.name == "main")
		end)
		table.sort(iter5_31)

		local var3_31 = iter5_31[1]
		local var4_31 = pg.dorm3d_dialogue_group[var3_31]

		onButton(arg0_31, var2_31, function()
			arg0_31:TryDownloadResource({
				click = true,
				roomId = var4_31.room_id
			}, function()
				arg0_31:emit(SelectDorm3DMediator.ON_DORM, {
					roomId = var4_31.room_id,
					groupIds = {
						var4_31.char_id
					},
					specialId = var3_31
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.InitCardTrigger(arg0_35, arg1_35)
	local var0_35 = getProxy(ApartmentProxy):getRoom(arg1_35)

	assert(var0_35)

	local var1_35 = arg0_35.cardDic[arg1_35]

	if var0_35:isPersonalRoom() then
		local var2_35 = var0_35:getPersonalGroupId()
		local var3_35 = Apartment.New({
			ship_group = var2_35
		}):GetSkinModelID(var0_35:getConfig("tag"))

		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var3_35), "", var1_35:Find("Image"))
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", var2_35), "", var1_35:Find("name"))
	else
		local var4_35 = var0_35:getConfig("assets_prefix")

		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_%s", string.lower(var4_35)), "", var1_35:Find("Image"))
	end

	onButton(arg0_35, var1_35, function()
		arg0_35:TryDownloadResource({
			click = true,
			roomId = arg1_35
		}, function()
			local var0_37 = var0_35:getConfig("room")

			if var0_35:isPersonalRoom() then
				var0_37 = ShipGroup.getDefaultShipNameByGroupID(var0_35:getPersonalGroupId())
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("dorm3d_role_assets_delete", var0_37),
				onYes = function()
					if IsUnityEditor then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

						return
					end

					if var0_35:isPersonalRoom() then
						DormGroupConst.DelRoom(string.lower(var0_35:getConfig("resource_name")), {
							"room",
							"apartment"
						})
					else
						DormGroupConst.DelRoom(string.lower(var0_35:getConfig("resource_name")), {
							"room"
						})
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_delete_finish"))
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDownload(var0_35.id, 3))
					arg0_35:DownloadUpdate(arg1_35, "delete")
				end
			})
		end)
	end, SFX_PANEL)
end

function var0_0.UpdateCardState(arg0_39, arg1_39)
	local var0_39 = getProxy(ApartmentProxy):getRoom(arg1_39)
	local var1_39 = arg0_39.cardDic[arg1_39]
	local var2_39 = var0_39:getState()

	if var0_39:isPersonalRoom() then
		setActive(var1_39:Find("lock"), var2_39 ~= "complete")
		setActive(var1_39:Find("unlock"), var2_39 == "complete")

		local var3_39 = getProxy(ApartmentProxy):getApartment(var0_39:getPersonalGroupId())

		setText(var1_39:Find("favor_level/Text"), var3_39 and var3_39.level or "?")
	end

	local var4_39 = var1_39:Find("operation")

	eachChild(var4_39, function(arg0_40)
		setActive(arg0_40, arg0_40.name == var2_39)
	end)

	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg1_39 then
		arg0_39:UpdateCardProgess()
	end

	setActive(var1_39:Find("mask"), var2_39 ~= "complete")
end

function var0_0.UpdateCardProgess(arg0_41)
	local var0_41 = DormGroupConst.DormDownloadLock
	local var1_41 = arg0_41.cardDic[var0_41.roomId]

	setSlider(var1_41:Find("operation/loading"), 0, var0_41.totalSize, var0_41.curSize)
end

function var0_0.DownloadUpdate(arg0_42, arg1_42, arg2_42)
	switch(arg2_42, {
		start = function()
			if arg0_42.roomDic[arg1_42] then
				arg0_42:UpdateIconState(arg1_42)
			end

			if arg0_42.cardDic and arg0_42.cardDic[arg1_42] then
				arg0_42:UpdateCardState(arg1_42)
			end
		end,
		loading = function()
			if arg0_42.roomDic[arg1_42] then
				local var0_44 = DormGroupConst.DormDownloadLock

				setSlider(arg0_42.roomDic[arg1_42]:Find("front/loading/progress"), 0, var0_44.totalSize, var0_44.curSize)
			end

			if arg0_42.cardDic and arg0_42.cardDic[arg1_42] then
				arg0_42:UpdateCardProgess()
			end
		end,
		finish = function()
			for iter0_45, iter1_45 in pairs(arg0_42.roomDic) do
				arg0_42:UpdateIconState(iter0_45)
			end

			if arg0_42.cardDic then
				for iter2_45, iter3_45 in pairs(arg0_42.cardDic) do
					arg0_42:UpdateCardState(iter2_45)
				end
			else
				arg0_42:CheckGuide("DORM3D_GUIDE_02")
			end
		end,
		delete = function()
			if arg0_42.roomDic[arg1_42] then
				arg0_42:UpdateIconState(arg1_42)
			end

			if arg0_42.cardDic and arg0_42.cardDic[arg1_42] then
				arg0_42:UpdateCardState(arg1_42)
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_47, arg1_47)
	local var0_47 = arg1_47.roomId

	if isActive(arg0_47.rtIconTip) then
		arg0_47:HideIconTipWindow()
	end

	eachChild(arg0_47.roomDic[var0_47]:Find("icon/mask"), function(arg0_48)
		setActive(arg0_48, true)
	end)
	quickPlayAnimation(arg0_47.roomDic[var0_47], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_47:UpdateIconState(var0_47)
		arg0_47:TryDownloadResource(arg1_47)
		arg0_47:CheckGuide("DORM3D_GUIDE_02")
	end))
end

function var0_0.ShowIconTipWindow(arg0_50, arg1_50, arg2_50)
	setLocalPosition(arg0_50.rtIconTip:Find("window"), arg0_50.rtIconTip:InverseTransformPoint(arg2_50.position))
	removeAllChildren(arg0_50.rtIconTip:Find("window/icon"))

	arg2_50 = cloneTplTo(arg2_50, arg0_50.rtIconTip:Find("window/icon"))

	arg0_50:UpdateShowIcon(arg1_50, arg2_50)
	setAnchoredPosition(arg2_50, Vector2.zero)

	local var0_50 = ApartmentRoom.New({
		id = arg1_50
	})
	local var1_50, var2_50 = var0_50:getDownloadNeedSize()

	setText(arg0_50.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_50:getPersonalGroupId()), var0_50:needDownload() and var2_50 or "0B"))
	onButton(arg0_50, arg0_50.rtIconTip:Find("window/btn_confirm"), function()
		arg0_50:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_50)
	end, SFX_CONFIRM)
	setActive(arg0_50.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_52)
	setActive(arg0_52.rtIconTip, false)
end

function var0_0.ShowMgrPanel(arg0_53)
	arg0_53.cardDic = {}
	arg0_53.filterCharRoomIds = {}
	arg0_53.filterPublicRoomIds = {}

	for iter0_53, iter1_53 in ipairs(underscore.filter(pg.dorm3d_rooms.all, function(arg0_54)
		return tobool(getProxy(ApartmentProxy):getRoom(arg0_54))
	end)) do
		local var0_53 = pg.dorm3d_rooms[iter1_53].type

		if var0_53 == 1 then
			table.insert(arg0_53.filterPublicRoomIds, iter1_53)
		elseif var0_53 == 2 then
			table.insert(arg0_53.filterCharRoomIds, iter1_53)
		else
			assert(false)
		end
	end

	arg0_53.charRoomCardItemList:align(#arg0_53.filterCharRoomIds)
	arg0_53.publicRoomCardItemList:align(#arg0_53.filterPublicRoomIds)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_53.rtMgrPanel, {
		force = true,
		pbList = {
			arg0_53.rtMgrPanel:Find("window")
		}
	})
	setActive(arg0_53.rtMgrPanel, true)
end

function var0_0.HideMgrPanel(arg0_55)
	arg0_55.cardDic = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_55.rtMgrPanel, arg0_55.rtLayer)
	setActive(arg0_55.rtMgrPanel, false)
	arg0_55:CheckGuide("DORM3D_GUIDE_02")
end

function var0_0.TryDownloadResource(arg0_56, arg1_56, arg2_56)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_56 = getProxy(ApartmentProxy):getRoom(arg1_56.roomId)
	local var1_56 = var0_56:getDownloadNameList()

	if #var1_56 > 0 then
		local var2_56 = {
			isShowBox = true,
			fileList = var1_56,
			finishFunc = function(arg0_57)
				if arg0_57 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_56.configId
		}

		DormGroupConst.DormDownload(var2_56)
	else
		existCall(arg2_56)
	end
end

function var0_0.InitResBar(arg0_58)
	arg0_58.goldMax = arg0_58.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_58.goldValue = arg0_58.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_58.oilMax = arg0_58.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_58.oilValue = arg0_58.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_58.gemValue = arg0_58.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_58, arg0_58.rtRes:Find("gold"), function()
		warning("debug test")
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_58, arg0_58.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_58, arg0_58.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_58:UpdateRes()
end

function var0_0.UpdateRes(arg0_62)
	local var0_62 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_62, arg0_62.goldMax, arg0_62.goldValue, arg0_62.oilMax, arg0_62.oilValue, arg0_62.gemValue)
end

function var0_0.UpdateWeekTask(arg0_63)
	local var0_63 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_63 = getProxy(TaskProxy):getTaskVO(var0_63)
	local var2_63 = var1_63:isReceive()
	local var3_63 = var2_63 and 3 or var1_63:getProgress()
	local var4_63 = arg0_63.rtWeekTask:Find("content")

	for iter0_63 = 1, 3 do
		triggerToggle(var4_63:Find("tpl_" .. iter0_63), iter0_63 <= var3_63)
	end

	local var5_63 = Drop.Create(var1_63:getConfig("award_display")[1])

	updateDorm3dIcon(var4_63:Find("Dorm3dIconTpl"), var5_63)
	onButton(arg0_63, var4_63:Find("Dorm3dIconTpl"), function()
		if not var2_63 and var1_63:isFinish() then
			arg0_63:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_63)
		else
			arg0_63:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_63
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_63:Find("Dorm3dIconTpl/get"), not var2_63 and var1_63:isFinish())
	setGray(var4_63:Find("Dorm3dIconTpl"), var2_63)
	onButton(arg0_63, arg0_63._tf:Find("Main/task_done"), function()
		setActive(arg0_63.rtWeekTask, true)
		setActive(arg0_63._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_63, arg0_63.rtWeekTask:Find("title"), function()
		if var2_63 then
			setActive(arg0_63.rtWeekTask, false)
			setActive(arg0_63._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_67, arg1_67)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_67) then
		return
	end

	return switch(arg1_67, {
		DORM3D_GUIDE_02 = function()
			local var0_68 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_68 and not var0_68:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_67
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_67)))
				pg.NewGuideMgr.GetInstance():Play(arg1_67, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_67)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_67
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_67)))
			pg.NewGuideMgr.GetInstance():Play(arg1_67, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_67)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.onBackPressed(arg0_73)
	if isActive(arg0_73.rtMgrPanel) then
		arg0_73:HideMgrPanel()
	elseif isActive(arg0_73.rtIconTip) then
		arg0_73:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_73)
	end
end

function var0_0.willExit(arg0_74)
	if isActive(arg0_74.rtMgrPanel) then
		arg0_74:HideMgrPanel()
	end

	if isActive(arg0_74.rtIconTip) then
		arg0_74:HideIconTipWindow()
	end

	if arg0_74.clearSceneCache then
		BLHX.Rendering.EngineCore.TryDispose(true)

		local var0_74 = typeof("BLHX.Rendering.Executor")
		local var1_74 = ReflectionHelp.RefGetProperty(var0_74, "Instance", nil)

		ReflectionHelp.RefCallMethod(var0_74, "TryHandleWaitLinkList", var1_74)
	end
end

return var0_0
