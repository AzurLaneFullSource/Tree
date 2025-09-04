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

	arg0_2:SetMapSwitch()
end

function var0_0.didEnter(arg0_11)
	arg0_11:SetFloor(arg0_11.floorData[arg0_11.selectedFloorId])
	arg0_11:UpdateStamina()
	arg0_11:CheckGuide("DORM3D_GUIDE_02")
	arg0_11:FlushInsBtn()

	if not ApartmentProxy.CheckDeviceRAMEnough() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("drom3d_memory_limit_tip"))
	end
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

function var0_0.FlushFloor(arg0_16)
	arg0_16:SetFloor(arg0_16.floorData[arg0_16.selectedFloorId])
end

function var0_0.InitIconTrigger(arg0_17, arg1_17)
	local var0_17 = arg0_17.roomDic[arg1_17]
	local var1_17 = pg.dorm3d_rooms[arg1_17].assets_prefix

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(var1_17)), "", var0_17:Find("icon"))
	onButton(arg0_17, var0_17, function()
		if BLOCK_DORM3D_ROOMS and table.contains(BLOCK_DORM3D_ROOMS, arg1_17) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_system_switch"))

			return
		end

		if arg1_17 ~= 1 and (not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

			return
		end

		local var0_18 = getProxy(ApartmentProxy):getRoom(arg1_17)
		local var1_18 = pg.dorm3d_rooms[arg1_17].type

		if var1_18 == 1 then
			if arg1_17 ~= 4 and not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_06") then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip2"))

				return
			end

			if not var0_18 then
				arg0_17:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_17)
			else
				arg0_17:TryDownloadResource({
					click = true,
					roomId = arg1_17
				}, function()
					local var0_19 = ApartmentProxy.GetRoomInviteList(arg1_17)

					if arg0_17:CheckGuide("DORM3D_GUIDE_06") then
						var0_19 = {}
					end

					arg0_17:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_17, var0_19, function()
						arg0_17:FlushFloor()
					end)
				end)
			end
		elseif var1_18 == 2 then
			if not var0_18 then
				arg0_17:ShowIconTipWindow(arg1_17, var0_17)
			else
				arg0_17:TryDownloadResource({
					click = true,
					roomId = arg1_17
				}, function()
					arg0_17:emit(SelectDorm3DMediator.ON_DORM, {
						roomId = var0_18.id,
						groupIds = var0_18:getInviteList()
					})
				end)
			end
		else
			assert(false)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateIconState(arg0_22, arg1_22)
	local var0_22 = arg0_22.roomDic[arg1_22]
	local var1_22 = getProxy(ApartmentProxy):getRoom(arg1_22)
	local var2_22 = var1_22 and var1_22:getState() or "lock"

	setActive(var0_22:Find("icon/mask"), var2_22 ~= "complete")
	eachChild(var0_22:Find("front"), function(arg0_23)
		setActive(arg0_23, arg0_23.name == var2_22)
	end)
	switch(var2_22, {
		loading = function()
			local var0_24 = DormGroupConst.DormDownloadLock

			setSlider(var0_22:Find("front/loading/progress"), 0, var0_24.totalSize, var0_24.curSize)
		end,
		complete = function()
			local var0_25 = var0_22:Find("front/complete")
			local var1_25 = var1_22:isPersonalRoom()

			setActive(var0_25, var1_25)

			if var1_25 then
				local var2_25 = getProxy(ApartmentProxy):getApartment(var1_22:getPersonalGroupId())
				local var3_25 = var2_25:getIconTip(var1_22:GetConfigID())

				eachChild(var0_25:Find("tip"), function(arg0_26)
					setActive(arg0_26, arg0_26.name == var3_25)
				end)
				setText(var0_25:Find("favor/Text"), var2_25.level)
			end
		end
	})

	local var3_22 = getProxy(PlayerProxy):getRawData().id

	if var0_22:Find("tip") then
		setActive(var0_22:Find("tip"), PlayerPrefs.GetInt(var3_22 .. "_dorm3dRoomInviteSuccess_" .. arg1_22, 1) == 0)
	end
end

function var0_0.UpdateShowIcon(arg0_27, arg1_27, arg2_27)
	removeOnButton(arg2_27)
	setActive(arg2_27:Find("icon/mask"), false)
	eachChild(arg2_27:Find("front"), function(arg0_28)
		setActive(arg0_28, false)
	end)
end

function var0_0.ReplaceSpecialRoomIcon(arg0_29)
	local var0_29 = {}

	for iter0_29, iter1_29 in pairs(getProxy(ApartmentProxy):getRawData()) do
		for iter2_29, iter3_29 in ipairs(iter1_29:getSpecialTalking()) do
			local var1_29 = pg.dorm3d_dialogue_group[iter3_29].trigger_config[1]

			if arg0_29.roomDic[var1_29] then
				var0_29[var1_29] = var0_29[var1_29] or {}

				table.insert(var0_29[var1_29], iter3_29)
			end
		end
	end

	for iter4_29, iter5_29 in pairs(var0_29) do
		setActive(arg0_29.roomDic[iter4_29], false)

		local var2_29 = cloneTplTo(arg0_29.roomDic[iter4_29], arg0_29.roomDic[iter4_29].parent, arg0_29.roomDic[iter4_29].name .. "_special")

		arg0_29:UpdateShowIcon(iter4_29, var2_29)
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(pg.dorm3d_rooms[iter4_29].assets_prefix)), "", var2_29:Find("icon"))
		setActive(var2_29:Find("front/complete"), true)
		setActive(var2_29:Find("front/complete/favor"), false)
		eachChild(var2_29:Find("front/complete/tip"), function(arg0_30)
			setActive(arg0_30, arg0_30.name == "main")
		end)
		table.sort(iter5_29)

		local var3_29 = iter5_29[1]
		local var4_29 = pg.dorm3d_dialogue_group[var3_29]

		onButton(arg0_29, var2_29, function()
			arg0_29:TryDownloadResource({
				click = true,
				roomId = var4_29.room_id
			}, function()
				arg0_29:emit(SelectDorm3DMediator.ON_DORM, {
					roomId = var4_29.room_id,
					groupIds = {
						var4_29.char_id
					},
					specialId = var3_29
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadUpdate(arg0_33, arg1_33, arg2_33)
	switch(arg2_33, {
		start = function()
			if arg0_33.roomDic[arg1_33] then
				arg0_33:UpdateIconState(arg1_33)
			end
		end,
		loading = function()
			if arg0_33.roomDic[arg1_33] then
				local var0_35 = DormGroupConst.DormDownloadLock

				setSlider(arg0_33.roomDic[arg1_33]:Find("front/loading/progress"), 0, var0_35.totalSize, var0_35.curSize)
			end
		end,
		finish = function()
			for iter0_36, iter1_36 in pairs(arg0_33.roomDic) do
				arg0_33:UpdateIconState(iter0_36)
			end

			arg0_33:CheckGuide("DORM3D_GUIDE_02")
		end,
		delete = function()
			if arg0_33.roomDic[arg1_33] then
				arg0_33:UpdateIconState(arg1_33)
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_38, arg1_38)
	local var0_38 = arg1_38.roomId

	if isActive(arg0_38.rtIconTip) then
		arg0_38:HideIconTipWindow()
	end

	eachChild(arg0_38.roomDic[var0_38]:Find("icon/mask"), function(arg0_39)
		setActive(arg0_39, true)
	end)
	quickPlayAnimation(arg0_38.roomDic[var0_38], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_38:UpdateIconState(var0_38)
		arg0_38:TryDownloadResource(arg1_38)
		arg0_38:CheckGuide("DORM3D_GUIDE_02")
		arg0_38:SetMapSwitch()
	end))
end

function var0_0.ShowIconTipWindow(arg0_41, arg1_41, arg2_41)
	setLocalPosition(arg0_41.rtIconTip:Find("window"), arg0_41.rtIconTip:InverseTransformPoint(arg2_41.position))
	removeAllChildren(arg0_41.rtIconTip:Find("window/icon"))

	arg2_41 = cloneTplTo(arg2_41, arg0_41.rtIconTip:Find("window/icon"))

	arg0_41:UpdateShowIcon(arg1_41, arg2_41)
	setAnchoredPosition(arg2_41, Vector2.zero)

	local var0_41 = ApartmentRoom.New({
		id = arg1_41
	})
	local var1_41, var2_41 = var0_41:getDownloadNeedSize()

	setText(arg0_41.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_41:getPersonalGroupId()), var0_41:needDownload() and var2_41 or "0B"))
	onButton(arg0_41, arg0_41.rtIconTip:Find("window/btn_confirm"), function()
		arg0_41:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_41)
	end, SFX_CONFIRM)
	setActive(arg0_41.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_43)
	setActive(arg0_43.rtIconTip, false)
end

function var0_0.TryDownloadResource(arg0_44, arg1_44, arg2_44)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_44 = getProxy(ApartmentProxy):getRoom(arg1_44.roomId)
	local var1_44 = var0_44:getDownloadNameList()

	if #var1_44 > 0 then
		local var2_44 = {
			isShowBox = true,
			fileList = var1_44,
			finishFunc = function(arg0_45)
				if arg0_45 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_44.configId
		}

		DormGroupConst.DormDownload(var2_44)
	else
		existCall(arg2_44)
	end
end

function var0_0.InitResBar(arg0_46)
	arg0_46.goldMax = arg0_46.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_46.goldValue = arg0_46.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_46.oilMax = arg0_46.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_46.oilValue = arg0_46.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_46.gemValue = arg0_46.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_46, arg0_46.rtRes:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_46, arg0_46.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_46, arg0_46.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_46:UpdateRes()
end

function var0_0.UpdateRes(arg0_50)
	local var0_50 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_50, arg0_50.goldMax, arg0_50.goldValue, arg0_50.oilMax, arg0_50.oilValue, arg0_50.gemValue)
end

function var0_0.UpdateWeekTask(arg0_51)
	local var0_51 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_51 = getProxy(TaskProxy):getTaskVO(var0_51)
	local var2_51 = var1_51:isReceive()
	local var3_51 = var2_51 and 3 or var1_51:getProgress()
	local var4_51 = arg0_51.rtWeekTask:Find("content")

	for iter0_51 = 1, 3 do
		triggerToggle(var4_51:Find("tpl_" .. iter0_51), iter0_51 <= var3_51)
	end

	local var5_51 = Drop.Create(var1_51:getConfig("award_display")[1])

	updateCustomDrop(var4_51:Find("Dorm3dIconTpl"), var5_51)
	onButton(arg0_51, var4_51:Find("Dorm3dIconTpl"), function()
		if not var2_51 and var1_51:isFinish() then
			arg0_51:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_51)
		else
			arg0_51:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_51
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_51:Find("Dorm3dIconTpl/get"), not var2_51 and var1_51:isFinish())
	setGray(var4_51:Find("Dorm3dIconTpl"), var2_51)
	onButton(arg0_51, arg0_51._tf:Find("Main/task_done"), function()
		setActive(arg0_51.rtWeekTask, true)
		setActive(arg0_51._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_51, arg0_51.rtWeekTask:Find("title"), function()
		if var2_51 then
			setActive(arg0_51.rtWeekTask, false)
			setActive(arg0_51._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_55, arg1_55)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_55) then
		return
	end

	return switch(arg1_55, {
		DORM3D_GUIDE_02 = function()
			local var0_56 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_56 and not var0_56:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_55
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_55)))
				pg.NewGuideMgr.GetInstance():Play(arg1_55, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_55)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_55
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_55)))
			pg.NewGuideMgr.GetInstance():Play(arg1_55, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_55)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.SetMapSwitch(arg0_61)
	local var0_61 = getProxy(PlayerProxy):getRawData().id

	arg0_61.selectedFloorId = PlayerPrefs.GetInt("DORM_SELECTED_FLOOR_ID" .. var0_61, 1)

	if pg.NewGuideMgr.GetInstance():GetCurrentGuideName() == "DORM3D_GUIDE_01" then
		arg0_61.selectedFloorId = 1
	elseif not DORM_LOCK_SELECT_NEW then
		local var1_61 = pg.dorm3d_set.drom3d_new_room_remind.key_value_int

		if PlayerPrefs.GetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_61 .. var1_61, 0) == 0 then
			arg0_61.selectedFloorId = table.indexof(arg0_61.floorData, pg.dorm3d_rooms[var1_61].in_map)

			PlayerPrefs.SetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_61 .. var1_61, 1)
		end
	end

	local var2_61 = arg0_61._tf:Find("interludeAni")
	local var3_61 = var2_61:GetComponent(typeof(Animation))
	local var4_61 = var2_61:GetComponent(typeof(DftAniEvent))

	onButton(arg0_61, arg0_61.rtMain:Find("btn_switch/left"), function()
		var4_61:SetTriggerEvent(function()
			arg0_61:ChangeMap(arg0_61.selectedFloorId - 1)
		end)
		var3_61:Play("anim_InterludeAni")
	end)
	onButton(arg0_61, arg0_61.rtMain:Find("btn_switch/right"), function()
		var4_61:SetTriggerEvent(function()
			arg0_61:ChangeMap(arg0_61.selectedFloorId + 1)
		end)
		var3_61:Play("anim_InterludeAni")
	end)
	setActive(arg0_61.rtMain:Find("btn_switch/switchPanel"), false)

	local var5_61 = arg0_61.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(Animation))

	arg0_61.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_61.rtMain:Find("btn_switch/switchPanel"), false)
	end)
	onButton(arg0_61, arg0_61.rtMain:Find("btn_switch/switch"), function()
		setActive(arg0_61.rtMain:Find("btn_switch/switchPanel"), true)
	end)
	onButton(arg0_61, arg0_61.rtMain:Find("btn_switch/switchPanel"), function()
		var5_61:Play("anim_switchPanel_exit")
	end)

	local var6_61 = UIItemList.New(arg0_61.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"), arg0_61.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content/floor"))

	var6_61:make(function(arg0_69, arg1_69, arg2_69)
		if arg0_69 == UIItemList.EventUpdate then
			local var0_69 = arg0_61.floorData[arg1_69 + 1]
			local var1_69 = Clone(pg.dorm3d_rooms.get_id_list_by_in_map[var0_69])

			for iter0_69 = #var1_69, 1, -1 do
				if pg.dorm3d_rooms[var1_69[iter0_69]].is_common == 1 then
					table.remove(var1_69, iter0_69)
				end
			end

			setActive(arg2_69:Find("select"), arg1_69 + 1 == arg0_61.selectedFloorId)
			setText(arg2_69:Find("name"), i18n("dorm3d_room_" .. var0_69))
			table.sort(var1_69, CompareFuncs({
				function(arg0_70)
					local var0_70 = getProxy(ApartmentProxy):getRoom(arg0_70)

					return (var0_70 and var0_70:getState() or "lock") == "complete" and 0 or 1
				end,
				function(arg0_71)
					return pg.dorm3d_rooms[arg0_71].type == 2 and 0 or 1
				end
			}))

			local var2_69 = UIItemList.New(arg2_69:Find("rooms"), arg2_69:Find("rooms/room"))

			var2_69:make(function(arg0_72, arg1_72, arg2_72)
				if arg0_72 == UIItemList.EventUpdate then
					local var0_72 = var1_69[arg1_72 + 1]
					local var1_72 = pg.dorm3d_rooms[var0_72]
					local var2_72 = getProxy(ApartmentProxy):getRoom(var0_72)
					local var3_72 = var2_72 and var2_72:getState() or "lock"

					setActive(arg2_72:Find("lock"), var3_72 ~= "complete")
					setActive(arg2_72:Find("normal"), var3_72 == "complete")

					if var3_72 == "complete" then
						local var4_72 = string.format("dorm3dselect/room_icon_%s", string.lower(var1_72.assets_prefix))

						GetImageSpriteFromAtlasAsync(var4_72, "", arg2_72:Find("normal/mask/icon"), false)
					end

					setText(arg2_72:Find("roomId"), var0_72)
				end
			end)
			var2_69:align(#var1_69)
			onButton(arg0_61, arg2_69, function()
				var4_61:SetTriggerEvent(function()
					arg0_61:ChangeMap(arg1_69 + 1)
				end)
				var3_61:Play("anim_InterludeAni")
				var5_61:Play("anim_switchPanel_exit")
			end, SFX_PANEL)
		end
	end)
	var6_61:align(#arg0_61.floorData)
	arg0_61:ChangeMap(arg0_61.selectedFloorId)
end

function var0_0.ChangeMap(arg0_75, arg1_75)
	arg0_75.selectedFloorId = arg1_75

	local var0_75 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DORM_SELECTED_FLOOR_ID" .. var0_75, arg0_75.selectedFloorId)
	arg0_75:SetFloor(arg0_75.floorData[arg0_75.selectedFloorId])
	setActive(arg0_75.rtMain:Find("btn_switch/left"), arg0_75.selectedFloorId > 1)
	setActive(arg0_75.rtMain:Find("btn_switch/right"), arg0_75.selectedFloorId < #arg0_75.floorData)
	setText(arg0_75.rtMain:Find("btn_switch/switch/currentName"), i18n("dorm3d_room_" .. arg0_75.floorData[arg0_75.selectedFloorId]))

	for iter0_75 = 0, #arg0_75.floorData - 1 do
		setActive(arg0_75.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter0_75):Find("select"), iter0_75 + 1 == arg1_75)
	end

	arg0_75.floorTipFlag = {}
	arg0_75.floorRoomTipFlag = {}

	for iter1_75, iter2_75 in ipairs(arg0_75.floorData) do
		local var1_75 = false
		local var2_75 = {}
		local var3_75 = pg.dorm3d_rooms.get_id_list_by_in_map[iter2_75]

		for iter3_75, iter4_75 in ipairs(var3_75) do
			if pg.dorm3d_rooms[iter4_75].is_common == 0 then
				var2_75[iter4_75] = false

				local var4_75 = getProxy(ApartmentProxy):getRoom(iter4_75)
				local var5_75 = var4_75 and var4_75:getState() or "lock"

				if var5_75 == "complete" and var4_75:isPersonalRoom() and getProxy(ApartmentProxy):getApartment(var4_75:getPersonalGroupId()):getIconTip(var4_75:GetConfigID()) then
					var1_75 = true
					var2_75[iter4_75] = true
				end

				if var5_75 == "complete" and not var4_75:isPersonalRoom() then
					var2_75[iter4_75] = PlayerPrefs.GetInt(var0_75 .. "_dorm3dRoomInviteSuccess_" .. iter4_75, 1) == 0
				end
			end
		end

		table.insert(arg0_75.floorTipFlag, var1_75)
		table.insert(arg0_75.floorRoomTipFlag, var2_75)
	end

	if arg0_75.selectedFloorId > 1 then
		setActive(arg0_75.rtMain:Find("btn_switch/left/tip"), arg0_75.floorTipFlag[arg0_75.selectedFloorId - 1])
	end

	if arg0_75.selectedFloorId < #arg0_75.floorData then
		setActive(arg0_75.rtMain:Find("btn_switch/right/tip"), arg0_75.floorTipFlag[arg0_75.selectedFloorId + 1])
	end

	setActive(arg0_75.rtMain:Find("btn_switch/switch/tip"), table.contains(arg0_75.floorTipFlag, true))

	for iter5_75 = 0, arg0_75.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content").childCount - 1 do
		local var6_75 = arg0_75.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter5_75)

		for iter6_75 = 0, var6_75:Find("rooms").childCount - 1 do
			local var7_75 = var6_75:Find("rooms"):GetChild(iter6_75)
			local var8_75 = var7_75:Find("roomId"):GetComponent(typeof(Text)).text

			setActive(var7_75:Find("normal/tip"), arg0_75.floorRoomTipFlag[iter5_75 + 1][tonumber(var8_75)])
		end
	end
end

function var0_0.onBackPressed(arg0_76)
	if isActive(arg0_76.rtIconTip) then
		arg0_76:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_76)
	end
end

function var0_0.willExit(arg0_77)
	if isActive(arg0_77.rtIconTip) then
		arg0_77:HideIconTipWindow()
	end

	if arg0_77.clearSceneCache then
		-- block empty
	end
end

return var0_0
