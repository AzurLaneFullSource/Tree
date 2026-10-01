local var0_0 = class("SelectDorm3DScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SelectDorm3DUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	for iter0_2, iter1_2 in pairs(pg.dorm3d_rooms.get_id_list_by_in_map or {}) do
		for iter2_2, iter3_2 in ipairs(iter1_2) do
			local var2_2 = pg.dorm3d_rooms[iter3_2]

			if var2_2 and var2_2.assets_prefix then
				var1_2(string.format("dorm3dselect/room_icon_%s", string.lower(var2_2.assets_prefix)))
			end
		end
	end

	var1_2("weaponframes")
	var1_2("ui/dormstyledropmsgboxui")

	local var3_2 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var4_2 = var3_2 and getProxy(TaskProxy):getTaskVO(var3_2)
	local var5_2 = var4_2 and var4_2:getConfig("award_display") and var4_2:getConfig("award_display")[1]

	if var5_2 then
		local var6_2 = Drop.Create(var5_2)

		if var6_2.type == DROP_TYPE_DORM3D_GIFT then
			local var7_2 = pg.dorm3d_gift[var6_2.id]

			var1_2(var7_2 and var7_2.icon)
		else
			var1_2(var6_2:getIcon())
		end
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_4)
	arg0_4.rtMap = arg0_4._tf:Find("Map")
	arg0_4.rtIconTip = arg0_4.rtMap:Find("tip")

	setActive(arg0_4.rtIconTip, false)
	onButton(arg0_4, arg0_4.rtIconTip:Find("bg"), function()
		arg0_4:HideIconTipWindow()
	end, SFX_CANCEL)
	setText(arg0_4.rtIconTip:Find("window/btn_cancel/Text"), i18n("text_cancel"))
	onButton(arg0_4, arg0_4.rtIconTip:Find("window/btn_cancel"), function()
		arg0_4:HideIconTipWindow()
	end, SFX_CANCEL)
	setText(arg0_4.rtIconTip:Find("window/btn_confirm/Text"), i18n("text_confirm"))

	arg0_4.rtMain = arg0_4._tf:Find("Main")

	setText(arg0_4.rtMain:Find("title/Text"), i18n("dorm3d_role_choose"))
	onButton(arg0_4, arg0_4.rtMain:Find("btn_back"), function()
		arg0_4.clearSceneCache = true

		arg0_4:closeView()
	end, SFX_CANCEL)

	arg0_4.insBtn = Dorm3dInsBtn.New(arg0_4.rtMain:Find("btn_ins"))

	onButton(arg0_4, arg0_4.insBtn.root, function()
		arg0_4:emit(SelectDorm3DMediator.OPEN_INS_LAYER, arg0_4.insBtn.IsNewPhoneCall())
	end)
	setActive(arg0_4.rtMain:Find("btn_ins"), not DORM_LOCK_INS)

	local var0_4 = getProxy(PlayerProxy):getRawData().id

	if not pg.TimeMgr.GetInstance():IsSameWeek(pg.TimeMgr.GetInstance():GetServerTime(), PlayerPrefs.GetInt(var0_4 .. "_dorm3dGiftWeekRefreshTimeStamp", 0)) then
		ApartmentProxy.RefreshGiftDailyTip()
	end

	setActive(arg0_4.rtMain:Find("btn_shop/tip"), Dorm3dShopUI.ShouldShowAllTip())
	onButton(arg0_4, arg0_4.rtMain:Find("btn_shop"), function()
		arg0_4:emit(SelectDorm3DMediator.OPEN_SHOP_LAYER, function()
			setActive(arg0_4.rtMain:Find("btn_shop/tip"), Dorm3dShopUI.ShouldShowAllTip())
		end)
	end)
	onButton(arg0_4, arg0_4.rtMain:Find("option/setting"), function()
		arg0_4:emit(SelectDorm3DMediator.OPEN_SETTING_LAYER)
	end)
	onButton(arg0_4, arg0_4.rtMain:Find("option/home"), function()
		arg0_4:emit(BaseUI.ON_HOME)
	end)

	arg0_4.rtStamina = arg0_4.rtMain:Find("stamina")
	arg0_4.rtRes = arg0_4.rtMain:Find("res")

	arg0_4:InitResBar()

	arg0_4.rtWeekTask = arg0_4.rtMain:Find("task")

	arg0_4:UpdateWeekTask()

	arg0_4.rtLayer = arg0_4._tf:Find("Layer")
	arg0_4.floorData = _.keys(pg.dorm3d_rooms.get_id_list_by_in_map)

	table.sort(arg0_4.floorData, function(arg0_13, arg1_13)
		return (tonumber(string.match(arg0_13, "%d+")) or 0) < (tonumber(string.match(arg1_13, "%d+")) or 0)
	end)
	arg0_4:SetMapSwitch()
end

function var0_0.didEnter(arg0_14)
	arg0_14:SetFloor(arg0_14.floorData[arg0_14.selectedFloorId])
	arg0_14:UpdateStamina()
	arg0_14:CheckGuide("DORM3D_GUIDE_02")
	arg0_14:FlushInsBtn()

	if not ApartmentProxy.CheckDeviceRAMEnough() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("drom3d_memory_limit_tip"))
	end
end

function var0_0.FlushInsBtn(arg0_15)
	arg0_15.insBtn:Flush()
end

function var0_0.UpdateStamina(arg0_16)
	setText(arg0_16.rtStamina:Find("Text"), string.format("%d/%d", getProxy(ApartmentProxy):getStamina()))
	setActive(arg0_16.rtStamina:Find("vfx_ui_stamina01"), getProxy(ApartmentProxy):getStamina() > 0)
end

function var0_0.SetFloor(arg0_17, arg1_17)
	local var0_17

	eachChild(arg0_17.rtMap, function(arg0_18)
		setActive(arg0_18, arg0_18.name == arg1_17)

		if arg0_18.name == arg1_17 then
			var0_17 = arg0_18
		end
	end)
	assert(var0_17)

	arg0_17.roomDic = {}

	for iter0_17, iter1_17 in ipairs(pg.dorm3d_rooms.get_id_list_by_in_map[arg1_17]) do
		arg0_17.roomDic[iter1_17] = var0_17:Find(pg.dorm3d_rooms[iter1_17].assets_prefix)

		arg0_17:InitIconTrigger(iter1_17)
		arg0_17:UpdateIconState(iter1_17)
	end

	arg0_17:ReplaceSpecialRoomIcon()
end

function var0_0.FlushFloor(arg0_19)
	arg0_19:SetFloor(arg0_19.floorData[arg0_19.selectedFloorId])
end

function var0_0.InitIconTrigger(arg0_20, arg1_20)
	local var0_20 = arg0_20.roomDic[arg1_20]
	local var1_20 = pg.dorm3d_rooms[arg1_20].assets_prefix

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(var1_20)), "", var0_20:Find("icon"))
	onButton(arg0_20, var0_20, function()
		if BLOCK_DORM3D_ROOMS and table.contains(BLOCK_DORM3D_ROOMS, arg1_20) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_system_switch"))

			return
		end

		if arg1_20 ~= 1 and (not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02")) and not DORM_LOCK_GUIDE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

			return
		end

		local var0_21 = getProxy(ApartmentProxy):getRoom(arg1_20)
		local var1_21 = pg.dorm3d_rooms[arg1_20].type

		if var1_21 == 1 then
			if arg1_20 ~= 4 and not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_06") and not DORM_LOCK_GUIDE then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip2"))

				return
			end

			if not var0_21 then
				arg0_20:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_20)
			else
				arg0_20:TryDownloadResource({
					click = true,
					roomId = arg1_20
				}, function()
					local var0_22 = ApartmentProxy.GetRoomInviteList(arg1_20)

					if arg0_20:CheckGuide("DORM3D_GUIDE_06") then
						var0_22 = {}
					end

					arg0_20:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_20, var0_22, function()
						arg0_20:FlushFloor()
					end)
				end)
			end
		elseif var1_21 == 2 then
			if not var0_21 then
				arg0_20:ShowIconTipWindow(arg1_20, var0_20)
			else
				arg0_20:TryDownloadResource({
					click = true,
					roomId = arg1_20
				}, function()
					arg0_20:emit(SelectDorm3DMediator.ON_DORM, {
						roomId = var0_21.id,
						groupIds = var0_21:getInviteList()
					})
				end)
			end
		else
			assert(false)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateIconState(arg0_25, arg1_25)
	local var0_25 = arg0_25.roomDic[arg1_25]
	local var1_25 = getProxy(ApartmentProxy):getRoom(arg1_25)
	local var2_25 = var1_25 and var1_25:getState() or "lock"

	setActive(var0_25:Find("icon/mask"), var2_25 ~= "complete")
	eachChild(var0_25:Find("front"), function(arg0_26)
		setActive(arg0_26, arg0_26.name == var2_25)
	end)
	switch(var2_25, {
		loading = function()
			local var0_27 = DormGroupConst.DormDownloadLock

			setSlider(var0_25:Find("front/loading/progress"), 0, var0_27.totalSize, var0_27.curSize)
		end,
		complete = function()
			local var0_28 = var0_25:Find("front/complete")
			local var1_28 = var1_25:isPersonalRoom()

			setActive(var0_28, var1_28)

			if var1_28 then
				local var2_28 = getProxy(ApartmentProxy):getApartment(var1_25:getPersonalGroupId())
				local var3_28 = var2_28:getIconTip(var1_25:GetConfigID())

				eachChild(var0_28:Find("tip"), function(arg0_29)
					setActive(arg0_29, arg0_29.name == var3_28)
				end)
				setText(var0_28:Find("favor/Text"), var2_28.level)
			end
		end
	})

	local var3_25 = getProxy(PlayerProxy):getRawData().id

	if arg1_25 == 4 then
		setActive(var0_25:Find("inivite_tip"), PlayerPrefs.GetInt(var3_25 .. "_dorm3dRoomInviteSuccess_" .. arg1_25, 1) == 0)
	end

	local function var4_25()
		if not var1_25 or not var1_25:isPersonalRoom() then
			return false
		end

		return getProxy(ApartmentProxy):HasShipGroupGiftExpireSoon(var1_25:getConfig("character")[1])
	end

	setActive(var0_25:Find("tip"), var4_25())
end

function var0_0.UpdateShowIcon(arg0_31, arg1_31, arg2_31)
	removeOnButton(arg2_31)
	setActive(arg2_31:Find("icon/mask"), false)
	eachChild(arg2_31:Find("front"), function(arg0_32)
		setActive(arg0_32, false)
	end)
end

function var0_0.ReplaceSpecialRoomIcon(arg0_33)
	local var0_33 = {}

	for iter0_33, iter1_33 in pairs(getProxy(ApartmentProxy):getRawData()) do
		for iter2_33, iter3_33 in ipairs(iter1_33:getSpecialTalking()) do
			local var1_33 = pg.dorm3d_dialogue_group[iter3_33].trigger_config[1]

			if arg0_33.roomDic[var1_33] then
				var0_33[var1_33] = var0_33[var1_33] or {}

				table.insert(var0_33[var1_33], iter3_33)
			end
		end
	end

	for iter4_33, iter5_33 in pairs(var0_33) do
		setActive(arg0_33.roomDic[iter4_33], false)

		local var2_33 = cloneTplTo(arg0_33.roomDic[iter4_33], arg0_33.roomDic[iter4_33].parent, arg0_33.roomDic[iter4_33].name .. "_special")

		arg0_33:UpdateShowIcon(iter4_33, var2_33)
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(pg.dorm3d_rooms[iter4_33].assets_prefix)), "", var2_33:Find("icon"))
		setActive(var2_33:Find("front/complete"), true)
		setActive(var2_33:Find("front/complete/favor"), false)
		eachChild(var2_33:Find("front/complete/tip"), function(arg0_34)
			setActive(arg0_34, arg0_34.name == "main")
		end)
		table.sort(iter5_33)

		local var3_33 = iter5_33[1]
		local var4_33 = pg.dorm3d_dialogue_group[var3_33]

		if DORM_LOCK_GUIDE and var3_33 == 10010 then
			return
		end

		onButton(arg0_33, var2_33, function()
			arg0_33:TryDownloadResource({
				click = true,
				roomId = var4_33.room_id
			}, function()
				arg0_33:emit(SelectDorm3DMediator.ON_DORM, {
					roomId = var4_33.room_id,
					groupIds = {
						var4_33.char_id
					},
					specialId = var3_33
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadUpdate(arg0_37, arg1_37, arg2_37)
	switch(arg2_37, {
		start = function()
			if arg0_37.roomDic[arg1_37] then
				arg0_37:UpdateIconState(arg1_37)
			end
		end,
		loading = function()
			if arg0_37.roomDic[arg1_37] then
				local var0_39 = DormGroupConst.DormDownloadLock

				setSlider(arg0_37.roomDic[arg1_37]:Find("front/loading/progress"), 0, var0_39.totalSize, var0_39.curSize)
			end
		end,
		finish = function()
			for iter0_40, iter1_40 in pairs(arg0_37.roomDic) do
				arg0_37:UpdateIconState(iter0_40)
			end

			arg0_37:CheckGuide("DORM3D_GUIDE_02")
		end,
		delete = function()
			if arg0_37.roomDic[arg1_37] then
				arg0_37:UpdateIconState(arg1_37)
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_42, arg1_42)
	local var0_42 = arg1_42.roomId

	if isActive(arg0_42.rtIconTip) then
		arg0_42:HideIconTipWindow()
	end

	eachChild(arg0_42.roomDic[var0_42]:Find("icon/mask"), function(arg0_43)
		setActive(arg0_43, true)
	end)
	quickPlayAnimation(arg0_42.roomDic[var0_42], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_42:UpdateIconState(var0_42)
		arg0_42:TryDownloadResource(arg1_42)
		arg0_42:CheckGuide("DORM3D_GUIDE_02")
		arg0_42:SetMapSwitch()
	end))
end

function var0_0.ShowIconTipWindow(arg0_45, arg1_45, arg2_45)
	setLocalPosition(arg0_45.rtIconTip:Find("window"), arg0_45.rtIconTip:InverseTransformPoint(arg2_45.position))
	removeAllChildren(arg0_45.rtIconTip:Find("window/icon"))

	arg2_45 = cloneTplTo(arg2_45, arg0_45.rtIconTip:Find("window/icon"))

	arg0_45:UpdateShowIcon(arg1_45, arg2_45)
	setAnchoredPosition(arg2_45, Vector2.zero)

	local var0_45 = ApartmentRoom.New({
		id = arg1_45
	})
	local var1_45, var2_45 = var0_45:getDownloadNeedSize()

	setText(arg0_45.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_45:getPersonalGroupId()), var0_45:needDownload() and var2_45 or "0B"))
	onButton(arg0_45, arg0_45.rtIconTip:Find("window/btn_confirm"), function()
		arg0_45:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_45)
	end, SFX_CONFIRM)
	setActive(arg0_45.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_47)
	setActive(arg0_47.rtIconTip, false)
end

function var0_0.TryDownloadResource(arg0_48, arg1_48, arg2_48)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_48 = getProxy(ApartmentProxy):getRoom(arg1_48.roomId)
	local var1_48 = var0_48:getDownloadNameList()

	if #var1_48 > 0 then
		local var2_48 = {
			isShowBox = true,
			fileList = var1_48,
			finishFunc = function(arg0_49)
				if arg0_49 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_48.configId
		}

		DormGroupConst.DormDownload(var2_48)
	else
		existCall(arg2_48)
	end
end

function var0_0.InitResBar(arg0_50)
	arg0_50.goldMax = arg0_50.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_50.goldValue = arg0_50.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_50.oilMax = arg0_50.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_50.oilValue = arg0_50.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_50.gemValue = arg0_50.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_50, arg0_50.rtRes:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_50, arg0_50.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_50, arg0_50.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_50:UpdateRes()
end

function var0_0.UpdateRes(arg0_54)
	local var0_54 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_54, arg0_54.goldMax, arg0_54.goldValue, arg0_54.oilMax, arg0_54.oilValue, arg0_54.gemValue)
end

function var0_0.UpdateWeekTask(arg0_55)
	local var0_55 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_55 = getProxy(TaskProxy):getTaskVO(var0_55)
	local var2_55 = var1_55:isReceive()
	local var3_55 = var2_55 and 3 or var1_55:getProgress()
	local var4_55 = arg0_55.rtWeekTask:Find("content")

	for iter0_55 = 1, 3 do
		triggerToggle(var4_55:Find("tpl_" .. iter0_55), iter0_55 <= var3_55)
	end

	local var5_55 = Drop.Create(var1_55:getConfig("award_display")[1])

	updateCustomDrop(var4_55:Find("Dorm3dIconTpl"), var5_55)
	onButton(arg0_55, var4_55:Find("Dorm3dIconTpl"), function()
		if not var2_55 and var1_55:isFinish() then
			arg0_55:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_55)
		else
			arg0_55:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_55
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_55:Find("Dorm3dIconTpl/get"), not var2_55 and var1_55:isFinish())
	setGray(var4_55:Find("Dorm3dIconTpl"), var2_55)
	onButton(arg0_55, arg0_55._tf:Find("Main/task_done"), function()
		setActive(arg0_55.rtWeekTask, true)
		setActive(arg0_55._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_55, arg0_55.rtWeekTask:Find("title"), function()
		if var2_55 then
			setActive(arg0_55.rtWeekTask, false)
			setActive(arg0_55._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_59, arg1_59)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_59) then
		return
	end

	if DORM_LOCK_GUIDE then
		return false
	end

	return switch(arg1_59, {
		DORM3D_GUIDE_02 = function()
			local var0_60 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_60 and not var0_60:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_59
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_59)))
				pg.NewGuideMgr.GetInstance():Play(arg1_59, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_59)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_59
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_59)))
			pg.NewGuideMgr.GetInstance():Play(arg1_59, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_59)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.SetMapSwitch(arg0_65)
	local var0_65 = getProxy(PlayerProxy):getRawData().id

	arg0_65.selectedFloorId = PlayerPrefs.GetInt("DORM_SELECTED_FLOOR_ID" .. var0_65, 1)

	if pg.NewGuideMgr.GetInstance():GetCurrentGuideName() == "DORM3D_GUIDE_01" then
		arg0_65.selectedFloorId = 1
	elseif not DORM_LOCK_SELECT_NEW then
		local var1_65 = pg.dorm3d_set.drom3d_new_room_remind.key_value_int

		if PlayerPrefs.GetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_65 .. var1_65, 0) == 0 then
			arg0_65.selectedFloorId = table.indexof(arg0_65.floorData, pg.dorm3d_rooms[var1_65].in_map)

			PlayerPrefs.SetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_65 .. var1_65, 1)
		end
	end

	local var2_65 = arg0_65._tf:Find("interludeAni")
	local var3_65 = var2_65:GetComponent(typeof(Animation))
	local var4_65 = var2_65:GetComponent(typeof(DftAniEvent))

	onButton(arg0_65, arg0_65.rtMain:Find("btn_switch/left"), function()
		var4_65:SetTriggerEvent(function()
			arg0_65:ChangeMap(arg0_65.selectedFloorId - 1)
		end)
		var3_65:Play("anim_InterludeAni")
	end)
	onButton(arg0_65, arg0_65.rtMain:Find("btn_switch/right"), function()
		var4_65:SetTriggerEvent(function()
			arg0_65:ChangeMap(arg0_65.selectedFloorId + 1)
		end)
		var3_65:Play("anim_InterludeAni")
	end)
	setActive(arg0_65.rtMain:Find("btn_switch/switchPanel"), false)

	local var5_65 = arg0_65.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(Animation))

	arg0_65.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_65.rtMain:Find("btn_switch/switchPanel"), false)
	end)
	onButton(arg0_65, arg0_65.rtMain:Find("btn_switch/switch"), function()
		setActive(arg0_65.rtMain:Find("btn_switch/switchPanel"), true)
	end)
	onButton(arg0_65, arg0_65.rtMain:Find("btn_switch/switchPanel"), function()
		var5_65:Play("anim_switchPanel_exit")
	end)

	local var6_65 = UIItemList.New(arg0_65.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"), arg0_65.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content/floor"))

	var6_65:make(function(arg0_73, arg1_73, arg2_73)
		if arg0_73 == UIItemList.EventUpdate then
			local var0_73 = arg0_65.floorData[arg1_73 + 1]
			local var1_73 = Clone(pg.dorm3d_rooms.get_id_list_by_in_map[var0_73])

			for iter0_73 = #var1_73, 1, -1 do
				if pg.dorm3d_rooms[var1_73[iter0_73]].is_common == 1 then
					table.remove(var1_73, iter0_73)
				end
			end

			setActive(arg2_73:Find("select"), arg1_73 + 1 == arg0_65.selectedFloorId)
			setText(arg2_73:Find("name"), i18n("dorm3d_room_" .. var0_73))
			table.sort(var1_73, CompareFuncs({
				function(arg0_74)
					local var0_74 = getProxy(ApartmentProxy):getRoom(arg0_74)

					return (var0_74 and var0_74:getState() or "lock") == "complete" and 0 or 1
				end,
				function(arg0_75)
					return pg.dorm3d_rooms[arg0_75].type == 2 and 0 or 1
				end
			}))

			local var2_73 = UIItemList.New(arg2_73:Find("rooms"), arg2_73:Find("rooms/room"))

			var2_73:make(function(arg0_76, arg1_76, arg2_76)
				if arg0_76 == UIItemList.EventUpdate then
					local var0_76 = var1_73[arg1_76 + 1]
					local var1_76 = pg.dorm3d_rooms[var0_76]
					local var2_76 = getProxy(ApartmentProxy):getRoom(var0_76)
					local var3_76 = var2_76 and var2_76:getState() or "lock"

					setActive(arg2_76:Find("lock"), var3_76 ~= "complete")

					local var4_76 = string.format("dorm3dselect/room_icon_%s", string.lower(var1_76.assets_prefix))

					GetImageSpriteFromAtlasAsync(var4_76, "", arg2_76:Find("normal/mask/icon"), false)
					setText(arg2_76:Find("roomId"), var0_76)
				end
			end)
			var2_73:align(#var1_73)
			onButton(arg0_65, arg2_73, function()
				var4_65:SetTriggerEvent(function()
					arg0_65:ChangeMap(arg1_73 + 1)
				end)
				var3_65:Play("anim_InterludeAni")
				var5_65:Play("anim_switchPanel_exit")
			end, SFX_PANEL)
		end
	end)
	var6_65:align(#arg0_65.floorData)
	arg0_65:ChangeMap(arg0_65.selectedFloorId)
end

function var0_0.ChangeMap(arg0_79, arg1_79)
	arg0_79.selectedFloorId = arg1_79

	local var0_79 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DORM_SELECTED_FLOOR_ID" .. var0_79, arg0_79.selectedFloorId)
	arg0_79:SetFloor(arg0_79.floorData[arg0_79.selectedFloorId])
	setActive(arg0_79.rtMain:Find("btn_switch/left"), arg0_79.selectedFloorId > 1)
	setActive(arg0_79.rtMain:Find("btn_switch/right"), arg0_79.selectedFloorId < #arg0_79.floorData)
	setText(arg0_79.rtMain:Find("btn_switch/switch/currentName"), i18n("dorm3d_room_" .. arg0_79.floorData[arg0_79.selectedFloorId]))

	for iter0_79 = 0, #arg0_79.floorData - 1 do
		setActive(arg0_79.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter0_79):Find("select"), iter0_79 + 1 == arg1_79)
	end

	arg0_79.floorTipFlag = {}
	arg0_79.floorRoomTipFlag = {}

	for iter1_79, iter2_79 in ipairs(arg0_79.floorData) do
		local var1_79 = false
		local var2_79 = {}
		local var3_79 = pg.dorm3d_rooms.get_id_list_by_in_map[iter2_79]

		for iter3_79, iter4_79 in ipairs(var3_79) do
			if pg.dorm3d_rooms[iter4_79].is_common == 0 then
				var2_79[iter4_79] = false

				local var4_79 = getProxy(ApartmentProxy):getRoom(iter4_79)
				local var5_79 = var4_79 and var4_79:getState() or "lock"

				if var5_79 == "complete" and var4_79:isPersonalRoom() and getProxy(ApartmentProxy):getApartment(var4_79:getPersonalGroupId()):getIconTip(var4_79:GetConfigID()) then
					var1_79 = true
					var2_79[iter4_79] = true
				end

				if var5_79 == "complete" and not var4_79:isPersonalRoom() then
					var2_79[iter4_79] = PlayerPrefs.GetInt(var0_79 .. "_dorm3dRoomInviteSuccess_" .. iter4_79, 1) == 0
				end
			end
		end

		table.insert(arg0_79.floorTipFlag, var1_79)
		table.insert(arg0_79.floorRoomTipFlag, var2_79)
	end

	if arg0_79.selectedFloorId > 1 then
		setActive(arg0_79.rtMain:Find("btn_switch/left/tip"), arg0_79.floorTipFlag[arg0_79.selectedFloorId - 1])
	end

	if arg0_79.selectedFloorId < #arg0_79.floorData then
		setActive(arg0_79.rtMain:Find("btn_switch/right/tip"), arg0_79.floorTipFlag[arg0_79.selectedFloorId + 1])
	end

	setActive(arg0_79.rtMain:Find("btn_switch/switch/tip"), table.contains(arg0_79.floorTipFlag, true))

	for iter5_79 = 0, arg0_79.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content").childCount - 1 do
		local var6_79 = arg0_79.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter5_79)

		for iter6_79 = 0, var6_79:Find("rooms").childCount - 1 do
			local var7_79 = var6_79:Find("rooms"):GetChild(iter6_79)
			local var8_79 = var7_79:Find("roomId"):GetComponent(typeof(Text)).text

			setActive(var7_79:Find("normal/tip"), arg0_79.floorRoomTipFlag[iter5_79 + 1][tonumber(var8_79)])
		end
	end
end

function var0_0.onBackPressed(arg0_80)
	if isActive(arg0_80.rtIconTip) then
		arg0_80:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_80)
	end
end

function var0_0.willExit(arg0_81)
	if isActive(arg0_81.rtIconTip) then
		arg0_81:HideIconTipWindow()
	end

	if arg0_81.clearSceneCache then
		-- block empty
	end
end

return var0_0
