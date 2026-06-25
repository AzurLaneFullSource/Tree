local var0_0 = class("SelectDorm3DScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SelectDorm3DUI"
end

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
	onButton(arg0_2, arg0_2.rtMain:Find("option/setting"), function()
		arg0_2:emit(SelectDorm3DMediator.OPEN_SETTING_LAYER)
	end)
	onButton(arg0_2, arg0_2.rtMain:Find("option/home"), function()
		arg0_2:emit(BaseUI.ON_HOME)
	end)

	arg0_2.rtStamina = arg0_2.rtMain:Find("stamina")
	arg0_2.rtRes = arg0_2.rtMain:Find("res")

	arg0_2:InitResBar()

	arg0_2.rtWeekTask = arg0_2.rtMain:Find("task")

	arg0_2:UpdateWeekTask()

	arg0_2.rtLayer = arg0_2._tf:Find("Layer")
	arg0_2.floorData = _.keys(pg.dorm3d_rooms.get_id_list_by_in_map)

	table.sort(arg0_2.floorData, function(arg0_11, arg1_11)
		return (tonumber(string.match(arg0_11, "%d+")) or 0) < (tonumber(string.match(arg1_11, "%d+")) or 0)
	end)
	arg0_2:SetMapSwitch()
end

function var0_0.didEnter(arg0_12)
	arg0_12:SetFloor(arg0_12.floorData[arg0_12.selectedFloorId])
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
	arg0_17:SetFloor(arg0_17.floorData[arg0_17.selectedFloorId])
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

		if arg1_18 ~= 1 and (not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02")) and not DORM_LOCK_GUIDE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

			return
		end

		local var0_19 = getProxy(ApartmentProxy):getRoom(arg1_18)
		local var1_19 = pg.dorm3d_rooms[arg1_18].type

		if var1_19 == 1 then
			if arg1_18 ~= 4 and not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_06") and not DORM_LOCK_GUIDE then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip2"))

				return
			end

			if not var0_19 then
				arg0_18:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_18)
			else
				arg0_18:TryDownloadResource({
					click = true,
					roomId = arg1_18
				}, function()
					local var0_20 = ApartmentProxy.GetRoomInviteList(arg1_18)

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

function var0_0.UpdateIconState(arg0_23, arg1_23)
	local var0_23 = arg0_23.roomDic[arg1_23]
	local var1_23 = getProxy(ApartmentProxy):getRoom(arg1_23)
	local var2_23 = var1_23 and var1_23:getState() or "lock"

	setActive(var0_23:Find("icon/mask"), var2_23 ~= "complete")
	eachChild(var0_23:Find("front"), function(arg0_24)
		setActive(arg0_24, arg0_24.name == var2_23)
	end)
	switch(var2_23, {
		loading = function()
			local var0_25 = DormGroupConst.DormDownloadLock

			setSlider(var0_23:Find("front/loading/progress"), 0, var0_25.totalSize, var0_25.curSize)
		end,
		complete = function()
			local var0_26 = var0_23:Find("front/complete")
			local var1_26 = var1_23:isPersonalRoom()

			setActive(var0_26, var1_26)

			if var1_26 then
				local var2_26 = getProxy(ApartmentProxy):getApartment(var1_23:getPersonalGroupId())
				local var3_26 = var2_26:getIconTip(var1_23:GetConfigID())

				eachChild(var0_26:Find("tip"), function(arg0_27)
					setActive(arg0_27, arg0_27.name == var3_26)
				end)
				setText(var0_26:Find("favor/Text"), var2_26.level)
			end
		end
	})

	local var3_23 = getProxy(PlayerProxy):getRawData().id

	if arg1_23 == 4 then
		setActive(var0_23:Find("inivite_tip"), PlayerPrefs.GetInt(var3_23 .. "_dorm3dRoomInviteSuccess_" .. arg1_23, 1) == 0)
	end

	local function var4_23()
		if not var1_23 or not var1_23:isPersonalRoom() then
			return false
		end

		return getProxy(ApartmentProxy):HasShipGroupGiftExpireSoon(var1_23:getConfig("character")[1])
	end

	setActive(var0_23:Find("tip"), var4_23())
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

			if arg0_31.roomDic[var1_31] then
				var0_31[var1_31] = var0_31[var1_31] or {}

				table.insert(var0_31[var1_31], iter3_31)
			end
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

		if DORM_LOCK_GUIDE and var3_31 == 10010 then
			return
		end

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

function var0_0.DownloadUpdate(arg0_35, arg1_35, arg2_35)
	switch(arg2_35, {
		start = function()
			if arg0_35.roomDic[arg1_35] then
				arg0_35:UpdateIconState(arg1_35)
			end
		end,
		loading = function()
			if arg0_35.roomDic[arg1_35] then
				local var0_37 = DormGroupConst.DormDownloadLock

				setSlider(arg0_35.roomDic[arg1_35]:Find("front/loading/progress"), 0, var0_37.totalSize, var0_37.curSize)
			end
		end,
		finish = function()
			for iter0_38, iter1_38 in pairs(arg0_35.roomDic) do
				arg0_35:UpdateIconState(iter0_38)
			end

			arg0_35:CheckGuide("DORM3D_GUIDE_02")
		end,
		delete = function()
			if arg0_35.roomDic[arg1_35] then
				arg0_35:UpdateIconState(arg1_35)
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_40, arg1_40)
	local var0_40 = arg1_40.roomId

	if isActive(arg0_40.rtIconTip) then
		arg0_40:HideIconTipWindow()
	end

	eachChild(arg0_40.roomDic[var0_40]:Find("icon/mask"), function(arg0_41)
		setActive(arg0_41, true)
	end)
	quickPlayAnimation(arg0_40.roomDic[var0_40], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_40:UpdateIconState(var0_40)
		arg0_40:TryDownloadResource(arg1_40)
		arg0_40:CheckGuide("DORM3D_GUIDE_02")
		arg0_40:SetMapSwitch()
	end))
end

function var0_0.ShowIconTipWindow(arg0_43, arg1_43, arg2_43)
	setLocalPosition(arg0_43.rtIconTip:Find("window"), arg0_43.rtIconTip:InverseTransformPoint(arg2_43.position))
	removeAllChildren(arg0_43.rtIconTip:Find("window/icon"))

	arg2_43 = cloneTplTo(arg2_43, arg0_43.rtIconTip:Find("window/icon"))

	arg0_43:UpdateShowIcon(arg1_43, arg2_43)
	setAnchoredPosition(arg2_43, Vector2.zero)

	local var0_43 = ApartmentRoom.New({
		id = arg1_43
	})
	local var1_43, var2_43 = var0_43:getDownloadNeedSize()

	setText(arg0_43.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_43:getPersonalGroupId()), var0_43:needDownload() and var2_43 or "0B"))
	onButton(arg0_43, arg0_43.rtIconTip:Find("window/btn_confirm"), function()
		arg0_43:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_43)
	end, SFX_CONFIRM)
	setActive(arg0_43.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_45)
	setActive(arg0_45.rtIconTip, false)
end

function var0_0.TryDownloadResource(arg0_46, arg1_46, arg2_46)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_46 = getProxy(ApartmentProxy):getRoom(arg1_46.roomId)
	local var1_46 = var0_46:getDownloadNameList()

	if #var1_46 > 0 then
		local var2_46 = {
			isShowBox = true,
			fileList = var1_46,
			finishFunc = function(arg0_47)
				if arg0_47 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_46.configId
		}

		DormGroupConst.DormDownload(var2_46)
	else
		existCall(arg2_46)
	end
end

function var0_0.InitResBar(arg0_48)
	arg0_48.goldMax = arg0_48.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_48.goldValue = arg0_48.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_48.oilMax = arg0_48.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_48.oilValue = arg0_48.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_48.gemValue = arg0_48.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_48, arg0_48.rtRes:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_48, arg0_48.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_48, arg0_48.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_48:UpdateRes()
end

function var0_0.UpdateRes(arg0_52)
	local var0_52 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_52, arg0_52.goldMax, arg0_52.goldValue, arg0_52.oilMax, arg0_52.oilValue, arg0_52.gemValue)
end

function var0_0.UpdateWeekTask(arg0_53)
	local var0_53 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_53 = getProxy(TaskProxy):getTaskVO(var0_53)
	local var2_53 = var1_53:isReceive()
	local var3_53 = var2_53 and 3 or var1_53:getProgress()
	local var4_53 = arg0_53.rtWeekTask:Find("content")

	for iter0_53 = 1, 3 do
		triggerToggle(var4_53:Find("tpl_" .. iter0_53), iter0_53 <= var3_53)
	end

	local var5_53 = Drop.Create(var1_53:getConfig("award_display")[1])

	updateCustomDrop(var4_53:Find("Dorm3dIconTpl"), var5_53)
	onButton(arg0_53, var4_53:Find("Dorm3dIconTpl"), function()
		if not var2_53 and var1_53:isFinish() then
			arg0_53:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_53)
		else
			arg0_53:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_53
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_53:Find("Dorm3dIconTpl/get"), not var2_53 and var1_53:isFinish())
	setGray(var4_53:Find("Dorm3dIconTpl"), var2_53)
	onButton(arg0_53, arg0_53._tf:Find("Main/task_done"), function()
		setActive(arg0_53.rtWeekTask, true)
		setActive(arg0_53._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_53, arg0_53.rtWeekTask:Find("title"), function()
		if var2_53 then
			setActive(arg0_53.rtWeekTask, false)
			setActive(arg0_53._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_57, arg1_57)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_57) then
		return
	end

	if DORM_LOCK_GUIDE then
		return false
	end

	return switch(arg1_57, {
		DORM3D_GUIDE_02 = function()
			local var0_58 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_58 and not var0_58:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_57
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_57)))
				pg.NewGuideMgr.GetInstance():Play(arg1_57, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_57)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_57
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_57)))
			pg.NewGuideMgr.GetInstance():Play(arg1_57, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_57)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.SetMapSwitch(arg0_63)
	local var0_63 = getProxy(PlayerProxy):getRawData().id

	arg0_63.selectedFloorId = PlayerPrefs.GetInt("DORM_SELECTED_FLOOR_ID" .. var0_63, 1)

	if pg.NewGuideMgr.GetInstance():GetCurrentGuideName() == "DORM3D_GUIDE_01" then
		arg0_63.selectedFloorId = 1
	elseif not DORM_LOCK_SELECT_NEW then
		local var1_63 = pg.dorm3d_set.drom3d_new_room_remind.key_value_int

		if PlayerPrefs.GetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_63 .. var1_63, 0) == 0 then
			arg0_63.selectedFloorId = table.indexof(arg0_63.floorData, pg.dorm3d_rooms[var1_63].in_map)

			PlayerPrefs.SetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_63 .. var1_63, 1)
		end
	end

	local var2_63 = arg0_63._tf:Find("interludeAni")
	local var3_63 = var2_63:GetComponent(typeof(Animation))
	local var4_63 = var2_63:GetComponent(typeof(DftAniEvent))

	onButton(arg0_63, arg0_63.rtMain:Find("btn_switch/left"), function()
		var4_63:SetTriggerEvent(function()
			arg0_63:ChangeMap(arg0_63.selectedFloorId - 1)
		end)
		var3_63:Play("anim_InterludeAni")
	end)
	onButton(arg0_63, arg0_63.rtMain:Find("btn_switch/right"), function()
		var4_63:SetTriggerEvent(function()
			arg0_63:ChangeMap(arg0_63.selectedFloorId + 1)
		end)
		var3_63:Play("anim_InterludeAni")
	end)
	setActive(arg0_63.rtMain:Find("btn_switch/switchPanel"), false)

	local var5_63 = arg0_63.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(Animation))

	arg0_63.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_63.rtMain:Find("btn_switch/switchPanel"), false)
	end)
	onButton(arg0_63, arg0_63.rtMain:Find("btn_switch/switch"), function()
		setActive(arg0_63.rtMain:Find("btn_switch/switchPanel"), true)
	end)
	onButton(arg0_63, arg0_63.rtMain:Find("btn_switch/switchPanel"), function()
		var5_63:Play("anim_switchPanel_exit")
	end)

	local var6_63 = UIItemList.New(arg0_63.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"), arg0_63.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content/floor"))

	var6_63:make(function(arg0_71, arg1_71, arg2_71)
		if arg0_71 == UIItemList.EventUpdate then
			local var0_71 = arg0_63.floorData[arg1_71 + 1]
			local var1_71 = Clone(pg.dorm3d_rooms.get_id_list_by_in_map[var0_71])

			for iter0_71 = #var1_71, 1, -1 do
				if pg.dorm3d_rooms[var1_71[iter0_71]].is_common == 1 then
					table.remove(var1_71, iter0_71)
				end
			end

			setActive(arg2_71:Find("select"), arg1_71 + 1 == arg0_63.selectedFloorId)
			setText(arg2_71:Find("name"), i18n("dorm3d_room_" .. var0_71))
			table.sort(var1_71, CompareFuncs({
				function(arg0_72)
					local var0_72 = getProxy(ApartmentProxy):getRoom(arg0_72)

					return (var0_72 and var0_72:getState() or "lock") == "complete" and 0 or 1
				end,
				function(arg0_73)
					return pg.dorm3d_rooms[arg0_73].type == 2 and 0 or 1
				end
			}))

			local var2_71 = UIItemList.New(arg2_71:Find("rooms"), arg2_71:Find("rooms/room"))

			var2_71:make(function(arg0_74, arg1_74, arg2_74)
				if arg0_74 == UIItemList.EventUpdate then
					local var0_74 = var1_71[arg1_74 + 1]
					local var1_74 = pg.dorm3d_rooms[var0_74]
					local var2_74 = getProxy(ApartmentProxy):getRoom(var0_74)
					local var3_74 = var2_74 and var2_74:getState() or "lock"

					setActive(arg2_74:Find("lock"), var3_74 ~= "complete")

					local var4_74 = string.format("dorm3dselect/room_icon_%s", string.lower(var1_74.assets_prefix))

					GetImageSpriteFromAtlasAsync(var4_74, "", arg2_74:Find("normal/mask/icon"), false)
					setText(arg2_74:Find("roomId"), var0_74)
				end
			end)
			var2_71:align(#var1_71)
			onButton(arg0_63, arg2_71, function()
				var4_63:SetTriggerEvent(function()
					arg0_63:ChangeMap(arg1_71 + 1)
				end)
				var3_63:Play("anim_InterludeAni")
				var5_63:Play("anim_switchPanel_exit")
			end, SFX_PANEL)
		end
	end)
	var6_63:align(#arg0_63.floorData)
	arg0_63:ChangeMap(arg0_63.selectedFloorId)
end

function var0_0.ChangeMap(arg0_77, arg1_77)
	arg0_77.selectedFloorId = arg1_77

	local var0_77 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DORM_SELECTED_FLOOR_ID" .. var0_77, arg0_77.selectedFloorId)
	arg0_77:SetFloor(arg0_77.floorData[arg0_77.selectedFloorId])
	setActive(arg0_77.rtMain:Find("btn_switch/left"), arg0_77.selectedFloorId > 1)
	setActive(arg0_77.rtMain:Find("btn_switch/right"), arg0_77.selectedFloorId < #arg0_77.floorData)
	setText(arg0_77.rtMain:Find("btn_switch/switch/currentName"), i18n("dorm3d_room_" .. arg0_77.floorData[arg0_77.selectedFloorId]))

	for iter0_77 = 0, #arg0_77.floorData - 1 do
		setActive(arg0_77.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter0_77):Find("select"), iter0_77 + 1 == arg1_77)
	end

	arg0_77.floorTipFlag = {}
	arg0_77.floorRoomTipFlag = {}

	for iter1_77, iter2_77 in ipairs(arg0_77.floorData) do
		local var1_77 = false
		local var2_77 = {}
		local var3_77 = pg.dorm3d_rooms.get_id_list_by_in_map[iter2_77]

		for iter3_77, iter4_77 in ipairs(var3_77) do
			if pg.dorm3d_rooms[iter4_77].is_common == 0 then
				var2_77[iter4_77] = false

				local var4_77 = getProxy(ApartmentProxy):getRoom(iter4_77)
				local var5_77 = var4_77 and var4_77:getState() or "lock"

				if var5_77 == "complete" and var4_77:isPersonalRoom() and getProxy(ApartmentProxy):getApartment(var4_77:getPersonalGroupId()):getIconTip(var4_77:GetConfigID()) then
					var1_77 = true
					var2_77[iter4_77] = true
				end

				if var5_77 == "complete" and not var4_77:isPersonalRoom() then
					var2_77[iter4_77] = PlayerPrefs.GetInt(var0_77 .. "_dorm3dRoomInviteSuccess_" .. iter4_77, 1) == 0
				end
			end
		end

		table.insert(arg0_77.floorTipFlag, var1_77)
		table.insert(arg0_77.floorRoomTipFlag, var2_77)
	end

	if arg0_77.selectedFloorId > 1 then
		setActive(arg0_77.rtMain:Find("btn_switch/left/tip"), arg0_77.floorTipFlag[arg0_77.selectedFloorId - 1])
	end

	if arg0_77.selectedFloorId < #arg0_77.floorData then
		setActive(arg0_77.rtMain:Find("btn_switch/right/tip"), arg0_77.floorTipFlag[arg0_77.selectedFloorId + 1])
	end

	setActive(arg0_77.rtMain:Find("btn_switch/switch/tip"), table.contains(arg0_77.floorTipFlag, true))

	for iter5_77 = 0, arg0_77.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content").childCount - 1 do
		local var6_77 = arg0_77.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter5_77)

		for iter6_77 = 0, var6_77:Find("rooms").childCount - 1 do
			local var7_77 = var6_77:Find("rooms"):GetChild(iter6_77)
			local var8_77 = var7_77:Find("roomId"):GetComponent(typeof(Text)).text

			setActive(var7_77:Find("normal/tip"), arg0_77.floorRoomTipFlag[iter5_77 + 1][tonumber(var8_77)])
		end
	end
end

function var0_0.onBackPressed(arg0_78)
	if isActive(arg0_78.rtIconTip) then
		arg0_78:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_78)
	end
end

function var0_0.willExit(arg0_79)
	if isActive(arg0_79.rtIconTip) then
		arg0_79:HideIconTipWindow()
	end

	if arg0_79.clearSceneCache then
		-- block empty
	end
end

return var0_0
