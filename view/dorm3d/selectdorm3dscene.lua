local var0_0 = class("SelectDorm3DScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SelectDorm3DUI"
end

function var0_0.forceGC(arg0_2)
	return true
end

var0_0.optionsPath = {
	"Main/option"
}

function var0_0.init(arg0_3)
	arg0_3.rtMap = arg0_3._tf:Find("Map")
	arg0_3.rtIconTip = arg0_3.rtMap:Find("tip")

	setActive(arg0_3.rtIconTip, false)
	onButton(arg0_3, arg0_3.rtIconTip:Find("bg"), function()
		arg0_3:HideIconTipWindow()
	end, SFX_CANCEL)
	setText(arg0_3.rtIconTip:Find("window/btn_cancel/Text"), i18n("text_cancel"))
	onButton(arg0_3, arg0_3.rtIconTip:Find("window/btn_cancel"), function()
		arg0_3:HideIconTipWindow()
	end, SFX_CANCEL)
	setText(arg0_3.rtIconTip:Find("window/btn_confirm/Text"), i18n("text_confirm"))

	arg0_3.rtMain = arg0_3._tf:Find("Main")

	setText(arg0_3.rtMain:Find("title/Text"), i18n("dorm3d_role_choose"))
	onButton(arg0_3, arg0_3.rtMain:Find("btn_back"), function()
		arg0_3.clearSceneCache = true

		arg0_3:closeView()
	end, SFX_CANCEL)

	arg0_3.insBtn = Dorm3dInsBtn.New(arg0_3.rtMain:Find("btn_ins"))

	onButton(arg0_3, arg0_3.insBtn.root, function()
		arg0_3:emit(SelectDorm3DMediator.OPEN_INS_LAYER, arg0_3.insBtn.IsNewPhoneCall())
	end)

	arg0_3.rtStamina = arg0_3.rtMain:Find("stamina")
	arg0_3.rtRes = arg0_3.rtMain:Find("res")

	arg0_3:InitResBar()

	arg0_3.rtWeekTask = arg0_3.rtMain:Find("task")

	arg0_3:UpdateWeekTask()

	arg0_3.rtLayer = arg0_3._tf:Find("Layer")
	arg0_3.rtMgrPanel = arg0_3.rtLayer:Find("mgr_panel")

	onButton(arg0_3, arg0_3.rtMgrPanel:Find("bg"), function()
		arg0_3:HideMgrPanel()
	end, SFX_CANCEL)
	setText(arg0_3.rtMgrPanel:Find("window/title/Text"), i18n("dorm3d_role_manage"))

	arg0_3.rtMgrChar = arg0_3.rtMgrPanel:Find("window/character")

	setText(arg0_3.rtMgrChar:Find("title"), i18n("dorm3d_role_manage_role"))

	local var0_3 = arg0_3.rtMgrChar:Find("container")

	arg0_3.charRoomCardItemList = UIItemList.New(var0_3, var0_3:Find("tpl"))

	arg0_3.charRoomCardItemList:make(function(arg0_9, arg1_9, arg2_9)
		arg1_9 = arg1_9 + 1

		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_3.filterCharRoomIds[arg1_9]

			setActive(arg2_9:Find("base"), var0_9)
			setActive(arg2_9:Find("empty"), not var0_9)

			if not var0_9 then
				arg2_9.name = "null"

				setText(arg2_9:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_9.name = tostring(var0_9)
				arg0_3.cardDic[var0_9] = arg2_9:Find("base")

				arg0_3:InitCardTrigger(var0_9)
				arg0_3:UpdateCardState(var0_9)

				return
			end
		end
	end)

	arg0_3.rtMgrPublic = arg0_3.rtMgrPanel:Find("window/public")

	setText(arg0_3.rtMgrPublic:Find("title"), i18n("dorm3d_role_manage_public_area"))

	local var1_3 = arg0_3.rtMgrPublic:Find("container")

	arg0_3.publicRoomCardItemList = UIItemList.New(var1_3, var1_3:Find("tpl"))

	arg0_3.publicRoomCardItemList:make(function(arg0_10, arg1_10, arg2_10)
		arg1_10 = arg1_10 + 1

		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_3.filterPublicRoomIds[arg1_10]

			arg0_3.cardDic[var0_10] = arg2_10

			arg0_3:InitCardTrigger(var0_10)
			arg0_3:UpdateCardState(var0_10)
		end
	end)
end

function var0_0.didEnter(arg0_11)
	arg0_11.contextData.floorName = arg0_11.contextData.floorName or "floor_1"

	arg0_11:SetFloor(arg0_11.contextData.floorName)
	arg0_11:UpdateStamina()
	arg0_11:CheckGuide("DORM3D_GUIDE_02")
	arg0_11:FlushInsBtn()
	DormProxy.CheckDeviceRAMEnough()
end

function var0_0.FlushInsBtn(arg0_12)
	arg0_12.insBtn:Flush()
end

function var0_0.UpdateStamina(arg0_13)
	setText(arg0_13.rtStamina:Find("Text"), string.format("%d/%d", getProxy(ApartmentProxy):getStamina()))
	setActive(arg0_13.rtStamina:Find("vfx_ui_stamina01"), getProxy(ApartmentProxy):getStamina() > 0)
end

function var0_0.SetFloor(arg0_14, arg1_14)
	local var0_14

	eachChild(arg0_14.rtMap, function(arg0_15)
		setActive(arg0_15, arg0_15.name == arg1_14)

		if arg0_15.name == arg1_14 then
			var0_14 = arg0_15
		end
	end)
	assert(var0_14)

	arg0_14.roomDic = {}

	for iter0_14, iter1_14 in ipairs(pg.dorm3d_rooms.get_id_list_by_in_map[arg1_14]) do
		arg0_14.roomDic[iter1_14] = var0_14:Find(pg.dorm3d_rooms[iter1_14].assets_prefix)

		arg0_14:InitIconTrigger(iter1_14)
		arg0_14:UpdateIconState(iter1_14)
	end

	arg0_14:ReplaceSpecialRoomIcon()
end

function var0_0.InitIconTrigger(arg0_16, arg1_16)
	local var0_16 = arg0_16.roomDic[arg1_16]
	local var1_16 = pg.dorm3d_rooms[arg1_16].assets_prefix

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(var1_16)), "", var0_16:Find("icon"))
	onButton(arg0_16, var0_16, function()
		if BLOCK_DORM3D_ROOMS and table.contains(BLOCK_DORM3D_ROOMS, arg1_16) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_system_switch"))

			return
		end

		if arg1_16 ~= 1 and (not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

			return
		end

		local var0_17 = getProxy(ApartmentProxy):getRoom(arg1_16)
		local var1_17 = pg.dorm3d_rooms[arg1_16].type

		if var1_17 == 1 then
			if not var0_17 then
				arg0_16:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_16)
			else
				arg0_16:TryDownloadResource({
					click = true,
					roomId = arg1_16
				}, function()
					local var0_18 = underscore.map(string.split(PlayerPrefs.GetString(string.format("room%d_invite_list", arg1_16), ""), "|"), function(arg0_19)
						return tonumber(arg0_19)
					end)

					if arg0_16:CheckGuide("DORM3D_GUIDE_06") then
						var0_18 = {}
					end

					arg0_16:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_16, var0_18)
				end)
			end
		elseif var1_17 == 2 then
			if not var0_17 then
				arg0_16:ShowIconTipWindow(arg1_16, var0_16)
			else
				arg0_16:TryDownloadResource({
					click = true,
					roomId = arg1_16
				}, function()
					arg0_16:emit(SelectDorm3DMediator.ON_DORM, {
						roomId = var0_17.id,
						groupIds = var0_17:getInviteList()
					})
				end)
			end
		else
			assert(false)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateIconState(arg0_21, arg1_21)
	local var0_21 = arg0_21.roomDic[arg1_21]
	local var1_21 = getProxy(ApartmentProxy):getRoom(arg1_21)
	local var2_21 = var1_21 and var1_21:getState() or "lock"

	setActive(var0_21:Find("icon/mask"), var2_21 ~= "complete")
	eachChild(var0_21:Find("front"), function(arg0_22)
		setActive(arg0_22, arg0_22.name == var2_21)
	end)
	switch(var2_21, {
		loading = function()
			local var0_23 = DormGroupConst.DormDownloadLock

			setSlider(var0_21:Find("front/loading/progress"), 0, var0_23.totalSize, var0_23.curSize)
		end,
		complete = function()
			local var0_24 = var0_21:Find("front/complete")
			local var1_24 = var1_21:isPersonalRoom()

			setActive(var0_24, var1_24)

			if var1_24 then
				local var2_24 = getProxy(ApartmentProxy):getApartment(var1_21:getPersonalGroupId())
				local var3_24 = var2_24:getIconTip(var1_21:GetConfigID())

				eachChild(var0_24:Find("tip"), function(arg0_25)
					setActive(arg0_25, arg0_25.name == var3_24)
				end)
				setText(var0_24:Find("favor/Text"), var2_24.level)
			end
		end
	})
end

function var0_0.UpdateShowIcon(arg0_26, arg1_26, arg2_26)
	removeOnButton(arg2_26)
	setActive(arg2_26:Find("icon/mask"), false)
	eachChild(arg2_26:Find("front"), function(arg0_27)
		setActive(arg0_27, false)
	end)
end

function var0_0.ReplaceSpecialRoomIcon(arg0_28)
	local var0_28 = {}

	for iter0_28, iter1_28 in pairs(getProxy(ApartmentProxy):getRawData()) do
		for iter2_28, iter3_28 in ipairs(iter1_28:getSpecialTalking()) do
			local var1_28 = pg.dorm3d_dialogue_group[iter3_28].trigger_config[1]

			var0_28[var1_28] = var0_28[var1_28] or {}

			table.insert(var0_28[var1_28], iter3_28)
		end
	end

	for iter4_28, iter5_28 in pairs(var0_28) do
		setActive(arg0_28.roomDic[iter4_28], false)

		local var2_28 = cloneTplTo(arg0_28.roomDic[iter4_28], arg0_28.roomDic[iter4_28].parent, arg0_28.roomDic[iter4_28].name .. "_special")

		arg0_28:UpdateShowIcon(iter4_28, var2_28)
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(pg.dorm3d_rooms[iter4_28].assets_prefix)), "", var2_28:Find("icon"))
		setActive(var2_28:Find("front/complete"), true)
		setActive(var2_28:Find("front/complete/favor"), false)
		eachChild(var2_28:Find("front/complete/tip"), function(arg0_29)
			setActive(arg0_29, arg0_29.name == "main")
		end)
		table.sort(iter5_28)

		local var3_28 = iter5_28[1]
		local var4_28 = pg.dorm3d_dialogue_group[var3_28]

		onButton(arg0_28, var2_28, function()
			arg0_28:TryDownloadResource({
				click = true,
				roomId = var4_28.room_id
			}, function()
				arg0_28:emit(SelectDorm3DMediator.ON_DORM, {
					roomId = var4_28.room_id,
					groupIds = {
						var4_28.char_id
					},
					specialId = var3_28
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.InitCardTrigger(arg0_32, arg1_32)
	local var0_32 = getProxy(ApartmentProxy):getRoom(arg1_32)

	assert(var0_32)

	local var1_32 = arg0_32.cardDic[arg1_32]

	if var0_32:isPersonalRoom() then
		local var2_32 = var0_32:getPersonalGroupId()
		local var3_32 = Apartment.New({
			ship_group = var2_32
		}):GetSkinModelID(var0_32:getConfig("tag"))

		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var3_32), "", var1_32:Find("Image"))
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", var2_32), "", var1_32:Find("name"))
	else
		local var4_32 = var0_32:getConfig("assets_prefix")

		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_%s", string.lower(var4_32)), "", var1_32:Find("Image"))
	end

	onButton(arg0_32, var1_32, function()
		arg0_32:TryDownloadResource({
			click = true,
			roomId = arg1_32
		}, function()
			local var0_34 = var0_32:getConfig("room")

			if var0_32:isPersonalRoom() then
				var0_34 = ShipGroup.getDefaultShipNameByGroupID(var0_32:getPersonalGroupId())
			end

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("dorm3d_role_assets_delete", var0_34),
				onYes = function()
					if IsUnityEditor then
						pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

						return
					end

					if var0_32:isPersonalRoom() then
						DormGroupConst.DelRoom(string.lower(var0_32:getConfig("resource_name")), {
							"room",
							"apartment"
						})
					else
						DormGroupConst.DelRoom(string.lower(var0_32:getConfig("resource_name")), {
							"room"
						})
					end

					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_delete_finish"))
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDownload(var0_32.id, 3))
					arg0_32:DownloadUpdate(arg1_32, "delete")
				end
			})
		end)
	end, SFX_PANEL)
end

function var0_0.UpdateCardState(arg0_36, arg1_36)
	local var0_36 = getProxy(ApartmentProxy):getRoom(arg1_36)
	local var1_36 = arg0_36.cardDic[arg1_36]
	local var2_36 = var0_36:getState()

	if var0_36:isPersonalRoom() then
		setActive(var1_36:Find("lock"), var2_36 ~= "complete")
		setActive(var1_36:Find("unlock"), var2_36 == "complete")

		local var3_36 = getProxy(ApartmentProxy):getApartment(var0_36:getPersonalGroupId())

		setText(var1_36:Find("favor_level/Text"), var3_36 and var3_36.level or "?")
	end

	local var4_36 = var1_36:Find("operation")

	eachChild(var4_36, function(arg0_37)
		setActive(arg0_37, arg0_37.name == var2_36)
	end)

	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg1_36 then
		arg0_36:UpdateCardProgess()
	end

	setActive(var1_36:Find("mask"), var2_36 ~= "complete")
end

function var0_0.UpdateCardProgess(arg0_38)
	local var0_38 = DormGroupConst.DormDownloadLock
	local var1_38 = arg0_38.cardDic[var0_38.roomId]

	setSlider(var1_38:Find("operation/loading"), 0, var0_38.totalSize, var0_38.curSize)
end

function var0_0.DownloadUpdate(arg0_39, arg1_39, arg2_39)
	switch(arg2_39, {
		start = function()
			if arg0_39.roomDic[arg1_39] then
				arg0_39:UpdateIconState(arg1_39)
			end

			if arg0_39.cardDic and arg0_39.cardDic[arg1_39] then
				arg0_39:UpdateCardState(arg1_39)
			end
		end,
		loading = function()
			if arg0_39.roomDic[arg1_39] then
				local var0_41 = DormGroupConst.DormDownloadLock

				setSlider(arg0_39.roomDic[arg1_39]:Find("front/loading/progress"), 0, var0_41.totalSize, var0_41.curSize)
			end

			if arg0_39.cardDic and arg0_39.cardDic[arg1_39] then
				arg0_39:UpdateCardProgess()
			end
		end,
		finish = function()
			for iter0_42, iter1_42 in pairs(arg0_39.roomDic) do
				arg0_39:UpdateIconState(iter0_42)
			end

			if arg0_39.cardDic then
				for iter2_42, iter3_42 in pairs(arg0_39.cardDic) do
					arg0_39:UpdateCardState(iter2_42)
				end
			else
				arg0_39:CheckGuide("DORM3D_GUIDE_02")
			end
		end,
		delete = function()
			if arg0_39.roomDic[arg1_39] then
				arg0_39:UpdateIconState(arg1_39)
			end

			if arg0_39.cardDic and arg0_39.cardDic[arg1_39] then
				arg0_39:UpdateCardState(arg1_39)
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_44, arg1_44)
	local var0_44 = arg1_44.roomId

	if isActive(arg0_44.rtIconTip) then
		arg0_44:HideIconTipWindow()
	end

	eachChild(arg0_44.roomDic[var0_44]:Find("icon/mask"), function(arg0_45)
		setActive(arg0_45, true)
	end)
	quickPlayAnimation(arg0_44.roomDic[var0_44], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_44:UpdateIconState(var0_44)
		arg0_44:TryDownloadResource(arg1_44)
		arg0_44:CheckGuide("DORM3D_GUIDE_02")
	end))
end

function var0_0.ShowIconTipWindow(arg0_47, arg1_47, arg2_47)
	setLocalPosition(arg0_47.rtIconTip:Find("window"), arg0_47.rtIconTip:InverseTransformPoint(arg2_47.position))
	removeAllChildren(arg0_47.rtIconTip:Find("window/icon"))

	arg2_47 = cloneTplTo(arg2_47, arg0_47.rtIconTip:Find("window/icon"))

	arg0_47:UpdateShowIcon(arg1_47, arg2_47)
	setAnchoredPosition(arg2_47, Vector2.zero)

	local var0_47 = ApartmentRoom.New({
		id = arg1_47
	})
	local var1_47, var2_47 = var0_47:getDownloadNeedSize()

	setText(arg0_47.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_47:getPersonalGroupId()), var0_47:needDownload() and var2_47 or "0B"))
	onButton(arg0_47, arg0_47.rtIconTip:Find("window/btn_confirm"), function()
		arg0_47:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_47)
	end, SFX_CONFIRM)
	setActive(arg0_47.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_49)
	setActive(arg0_49.rtIconTip, false)
end

function var0_0.ShowMgrPanel(arg0_50)
	arg0_50.cardDic = {}
	arg0_50.filterCharRoomIds = {}
	arg0_50.filterPublicRoomIds = {}

	for iter0_50, iter1_50 in ipairs(underscore.filter(pg.dorm3d_rooms.all, function(arg0_51)
		return tobool(getProxy(ApartmentProxy):getRoom(arg0_51))
	end)) do
		local var0_50 = pg.dorm3d_rooms[iter1_50].type

		if var0_50 == 1 then
			table.insert(arg0_50.filterPublicRoomIds, iter1_50)
		elseif var0_50 == 2 then
			table.insert(arg0_50.filterCharRoomIds, iter1_50)
		else
			assert(false)
		end
	end

	arg0_50.charRoomCardItemList:align(#arg0_50.filterCharRoomIds)
	arg0_50.publicRoomCardItemList:align(#arg0_50.filterPublicRoomIds)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_50.rtMgrPanel, {
		force = true,
		pbList = {
			arg0_50.rtMgrPanel:Find("window")
		}
	})
	setActive(arg0_50.rtMgrPanel, true)
end

function var0_0.HideMgrPanel(arg0_52)
	arg0_52.cardDic = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_52.rtMgrPanel, arg0_52.rtLayer)
	setActive(arg0_52.rtMgrPanel, false)
	arg0_52:CheckGuide("DORM3D_GUIDE_02")
end

function var0_0.TryDownloadResource(arg0_53, arg1_53, arg2_53)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_53 = getProxy(ApartmentProxy):getRoom(arg1_53.roomId)
	local var1_53 = var0_53:getDownloadNameList()

	if #var1_53 > 0 then
		local var2_53 = {
			isShowBox = true,
			fileList = var1_53,
			finishFunc = function(arg0_54)
				if arg0_54 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_53.configId
		}

		DormGroupConst.DormDownload(var2_53)
	else
		existCall(arg2_53)
	end
end

function var0_0.InitResBar(arg0_55)
	arg0_55.goldMax = arg0_55.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_55.goldValue = arg0_55.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_55.oilMax = arg0_55.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_55.oilValue = arg0_55.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_55.gemValue = arg0_55.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_55, arg0_55.rtRes:Find("gold"), function()
		warning("debug test")
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_55:UpdateRes()
end

function var0_0.UpdateRes(arg0_59)
	local var0_59 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_59, arg0_59.goldMax, arg0_59.goldValue, arg0_59.oilMax, arg0_59.oilValue, arg0_59.gemValue)
end

function var0_0.UpdateWeekTask(arg0_60)
	local var0_60 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_60 = getProxy(TaskProxy):getTaskVO(var0_60)
	local var2_60 = var1_60:isReceive()
	local var3_60 = var2_60 and 3 or var1_60:getProgress()
	local var4_60 = arg0_60.rtWeekTask:Find("content")

	for iter0_60 = 1, 3 do
		triggerToggle(var4_60:Find("tpl_" .. iter0_60), iter0_60 <= var3_60)
	end

	local var5_60 = Drop.Create(var1_60:getConfig("award_display")[1])

	updateDorm3dIcon(var4_60:Find("Dorm3dIconTpl"), var5_60)
	onButton(arg0_60, var4_60:Find("Dorm3dIconTpl"), function()
		if not var2_60 and var1_60:isFinish() then
			arg0_60:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_60)
		else
			arg0_60:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_60
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_60:Find("Dorm3dIconTpl/get"), not var2_60 and var1_60:isFinish())
	setGray(var4_60:Find("Dorm3dIconTpl"), var2_60)
	onButton(arg0_60, arg0_60._tf:Find("Main/task_done"), function()
		setActive(arg0_60.rtWeekTask, true)
		setActive(arg0_60._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_60, arg0_60.rtWeekTask:Find("title"), function()
		if var2_60 then
			setActive(arg0_60.rtWeekTask, false)
			setActive(arg0_60._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_64, arg1_64)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_64) then
		return
	end

	return switch(arg1_64, {
		DORM3D_GUIDE_02 = function()
			local var0_65 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_65 and not var0_65:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_64
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_64)))
				pg.NewGuideMgr.GetInstance():Play(arg1_64, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_64)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_64
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_64)))
			pg.NewGuideMgr.GetInstance():Play(arg1_64, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_64)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.onBackPressed(arg0_70)
	if isActive(arg0_70.rtMgrPanel) then
		arg0_70:HideMgrPanel()
	elseif isActive(arg0_70.rtIconTip) then
		arg0_70:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_70)
	end
end

function var0_0.willExit(arg0_71)
	if isActive(arg0_71.rtMgrPanel) then
		arg0_71:HideMgrPanel()
	end

	if isActive(arg0_71.rtIconTip) then
		arg0_71:HideIconTipWindow()
	end

	if arg0_71.clearSceneCache then
		BLHX.Rendering.EngineCore.TryDispose(true)

		local var0_71 = typeof("BLHX.Rendering.Executor")
		local var1_71 = ReflectionHelp.RefGetProperty(var0_71, "Instance", nil)

		ReflectionHelp.RefCallMethod(var0_71, "TryHandleWaitLinkList", var1_71)
	end
end

return var0_0
