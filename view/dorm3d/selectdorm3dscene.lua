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
	arg0_2.floorData = _.keys(pg.dorm3d_rooms.get_id_list_by_in_map)

	arg0_2:SetMapSwitch()
end

function var0_0.didEnter(arg0_9)
	arg0_9:SetFloor(arg0_9.floorData[arg0_9.selectedFloorId])
	arg0_9:UpdateStamina()
	arg0_9:CheckGuide("DORM3D_GUIDE_02")
	arg0_9:FlushInsBtn()

	if not ApartmentProxy.CheckDeviceRAMEnough() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("drom3d_memory_limit_tip"))
	end
end

function var0_0.FlushInsBtn(arg0_10)
	arg0_10.insBtn:Flush()
end

function var0_0.UpdateStamina(arg0_11)
	setText(arg0_11.rtStamina:Find("Text"), string.format("%d/%d", getProxy(ApartmentProxy):getStamina()))
	setActive(arg0_11.rtStamina:Find("vfx_ui_stamina01"), getProxy(ApartmentProxy):getStamina() > 0)
end

function var0_0.SetFloor(arg0_12, arg1_12)
	local var0_12

	eachChild(arg0_12.rtMap, function(arg0_13)
		setActive(arg0_13, arg0_13.name == arg1_12)

		if arg0_13.name == arg1_12 then
			var0_12 = arg0_13
		end
	end)
	assert(var0_12)

	arg0_12.roomDic = {}

	for iter0_12, iter1_12 in ipairs(pg.dorm3d_rooms.get_id_list_by_in_map[arg1_12]) do
		arg0_12.roomDic[iter1_12] = var0_12:Find(pg.dorm3d_rooms[iter1_12].assets_prefix)

		arg0_12:InitIconTrigger(iter1_12)
		arg0_12:UpdateIconState(iter1_12)
	end

	arg0_12:ReplaceSpecialRoomIcon()
end

function var0_0.FlushFloor(arg0_14)
	arg0_14:SetFloor(arg0_14.floorData[arg0_14.selectedFloorId])
end

function var0_0.InitIconTrigger(arg0_15, arg1_15)
	local var0_15 = arg0_15.roomDic[arg1_15]
	local var1_15 = pg.dorm3d_rooms[arg1_15].assets_prefix

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(var1_15)), "", var0_15:Find("icon"))
	onButton(arg0_15, var0_15, function()
		if BLOCK_DORM3D_ROOMS and table.contains(BLOCK_DORM3D_ROOMS, arg1_15) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_system_switch"))

			return
		end

		if arg1_15 ~= 1 and (not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02")) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

			return
		end

		local var0_16 = getProxy(ApartmentProxy):getRoom(arg1_15)
		local var1_16 = pg.dorm3d_rooms[arg1_15].type

		if var1_16 == 1 then
			if arg1_15 ~= 4 and not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_06") then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip2"))

				return
			end

			if not var0_16 then
				arg0_15:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_15)
			else
				arg0_15:TryDownloadResource({
					click = true,
					roomId = arg1_15
				}, function()
					local var0_17 = ApartmentProxy.GetRoomInviteList(arg1_15)

					if arg0_15:CheckGuide("DORM3D_GUIDE_06") then
						var0_17 = {}
					end

					arg0_15:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_15, var0_17, function()
						arg0_15:FlushFloor()
					end)
				end)
			end
		elseif var1_16 == 2 then
			if not var0_16 then
				arg0_15:ShowIconTipWindow(arg1_15, var0_15)
			else
				arg0_15:TryDownloadResource({
					click = true,
					roomId = arg1_15
				}, function()
					arg0_15:emit(SelectDorm3DMediator.ON_DORM, {
						roomId = var0_16.id,
						groupIds = var0_16:getInviteList()
					})
				end)
			end
		else
			assert(false)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateIconState(arg0_20, arg1_20)
	local var0_20 = arg0_20.roomDic[arg1_20]
	local var1_20 = getProxy(ApartmentProxy):getRoom(arg1_20)
	local var2_20 = var1_20 and var1_20:getState() or "lock"

	setActive(var0_20:Find("icon/mask"), var2_20 ~= "complete")
	eachChild(var0_20:Find("front"), function(arg0_21)
		setActive(arg0_21, arg0_21.name == var2_20)
	end)
	switch(var2_20, {
		loading = function()
			local var0_22 = DormGroupConst.DormDownloadLock

			setSlider(var0_20:Find("front/loading/progress"), 0, var0_22.totalSize, var0_22.curSize)
		end,
		complete = function()
			local var0_23 = var0_20:Find("front/complete")
			local var1_23 = var1_20:isPersonalRoom()

			setActive(var0_23, var1_23)

			if var1_23 then
				local var2_23 = getProxy(ApartmentProxy):getApartment(var1_20:getPersonalGroupId())
				local var3_23 = var2_23:getIconTip(var1_20:GetConfigID())

				eachChild(var0_23:Find("tip"), function(arg0_24)
					setActive(arg0_24, arg0_24.name == var3_23)
				end)
				setText(var0_23:Find("favor/Text"), var2_23.level)
			end
		end
	})

	local var3_20 = getProxy(PlayerProxy):getRawData().id

	if var0_20:Find("tip") then
		setActive(var0_20:Find("tip"), PlayerPrefs.GetInt(var3_20 .. "_dorm3dRoomInviteSuccess_" .. arg1_20, 1) == 0)
	end
end

function var0_0.UpdateShowIcon(arg0_25, arg1_25, arg2_25)
	removeOnButton(arg2_25)
	setActive(arg2_25:Find("icon/mask"), false)
	eachChild(arg2_25:Find("front"), function(arg0_26)
		setActive(arg0_26, false)
	end)
end

function var0_0.ReplaceSpecialRoomIcon(arg0_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in pairs(getProxy(ApartmentProxy):getRawData()) do
		for iter2_27, iter3_27 in ipairs(iter1_27:getSpecialTalking()) do
			local var1_27 = pg.dorm3d_dialogue_group[iter3_27].trigger_config[1]

			if arg0_27.roomDic[var1_27] then
				var0_27[var1_27] = var0_27[var1_27] or {}

				table.insert(var0_27[var1_27], iter3_27)
			end
		end
	end

	for iter4_27, iter5_27 in pairs(var0_27) do
		setActive(arg0_27.roomDic[iter4_27], false)

		local var2_27 = cloneTplTo(arg0_27.roomDic[iter4_27], arg0_27.roomDic[iter4_27].parent, arg0_27.roomDic[iter4_27].name .. "_special")

		arg0_27:UpdateShowIcon(iter4_27, var2_27)
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(pg.dorm3d_rooms[iter4_27].assets_prefix)), "", var2_27:Find("icon"))
		setActive(var2_27:Find("front/complete"), true)
		setActive(var2_27:Find("front/complete/favor"), false)
		eachChild(var2_27:Find("front/complete/tip"), function(arg0_28)
			setActive(arg0_28, arg0_28.name == "main")
		end)
		table.sort(iter5_27)

		local var3_27 = iter5_27[1]
		local var4_27 = pg.dorm3d_dialogue_group[var3_27]

		onButton(arg0_27, var2_27, function()
			arg0_27:TryDownloadResource({
				click = true,
				roomId = var4_27.room_id
			}, function()
				arg0_27:emit(SelectDorm3DMediator.ON_DORM, {
					roomId = var4_27.room_id,
					groupIds = {
						var4_27.char_id
					},
					specialId = var3_27
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.DownloadUpdate(arg0_31, arg1_31, arg2_31)
	switch(arg2_31, {
		start = function()
			if arg0_31.roomDic[arg1_31] then
				arg0_31:UpdateIconState(arg1_31)
			end
		end,
		loading = function()
			if arg0_31.roomDic[arg1_31] then
				local var0_33 = DormGroupConst.DormDownloadLock

				setSlider(arg0_31.roomDic[arg1_31]:Find("front/loading/progress"), 0, var0_33.totalSize, var0_33.curSize)
			end
		end,
		finish = function()
			for iter0_34, iter1_34 in pairs(arg0_31.roomDic) do
				arg0_31:UpdateIconState(iter0_34)
			end

			arg0_31:CheckGuide("DORM3D_GUIDE_02")
		end,
		delete = function()
			if arg0_31.roomDic[arg1_31] then
				arg0_31:UpdateIconState(arg1_31)
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_36, arg1_36)
	local var0_36 = arg1_36.roomId

	if isActive(arg0_36.rtIconTip) then
		arg0_36:HideIconTipWindow()
	end

	eachChild(arg0_36.roomDic[var0_36]:Find("icon/mask"), function(arg0_37)
		setActive(arg0_37, true)
	end)
	quickPlayAnimation(arg0_36.roomDic[var0_36], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_36:UpdateIconState(var0_36)
		arg0_36:TryDownloadResource(arg1_36)
		arg0_36:CheckGuide("DORM3D_GUIDE_02")
		arg0_36:SetMapSwitch()
	end))
end

function var0_0.ShowIconTipWindow(arg0_39, arg1_39, arg2_39)
	setLocalPosition(arg0_39.rtIconTip:Find("window"), arg0_39.rtIconTip:InverseTransformPoint(arg2_39.position))
	removeAllChildren(arg0_39.rtIconTip:Find("window/icon"))

	arg2_39 = cloneTplTo(arg2_39, arg0_39.rtIconTip:Find("window/icon"))

	arg0_39:UpdateShowIcon(arg1_39, arg2_39)
	setAnchoredPosition(arg2_39, Vector2.zero)

	local var0_39 = ApartmentRoom.New({
		id = arg1_39
	})
	local var1_39, var2_39 = var0_39:getDownloadNeedSize()

	setText(arg0_39.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_39:getPersonalGroupId()), var0_39:needDownload() and var2_39 or "0B"))
	onButton(arg0_39, arg0_39.rtIconTip:Find("window/btn_confirm"), function()
		arg0_39:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_39)
	end, SFX_CONFIRM)
	setActive(arg0_39.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_41)
	setActive(arg0_41.rtIconTip, false)
end

function var0_0.TryDownloadResource(arg0_42, arg1_42, arg2_42)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_42 = getProxy(ApartmentProxy):getRoom(arg1_42.roomId)
	local var1_42 = var0_42:getDownloadNameList()

	if #var1_42 > 0 then
		local var2_42 = {
			isShowBox = true,
			fileList = var1_42,
			finishFunc = function(arg0_43)
				if arg0_43 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_42.configId
		}

		DormGroupConst.DormDownload(var2_42)
	else
		existCall(arg2_42)
	end
end

function var0_0.InitResBar(arg0_44)
	arg0_44.goldMax = arg0_44.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_44.goldValue = arg0_44.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_44.oilMax = arg0_44.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_44.oilValue = arg0_44.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_44.gemValue = arg0_44.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_44, arg0_44.rtRes:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_44, arg0_44.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_44, arg0_44.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_44:UpdateRes()
end

function var0_0.UpdateRes(arg0_48)
	local var0_48 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_48, arg0_48.goldMax, arg0_48.goldValue, arg0_48.oilMax, arg0_48.oilValue, arg0_48.gemValue)
end

function var0_0.UpdateWeekTask(arg0_49)
	local var0_49 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_49 = getProxy(TaskProxy):getTaskVO(var0_49)
	local var2_49 = var1_49:isReceive()
	local var3_49 = var2_49 and 3 or var1_49:getProgress()
	local var4_49 = arg0_49.rtWeekTask:Find("content")

	for iter0_49 = 1, 3 do
		triggerToggle(var4_49:Find("tpl_" .. iter0_49), iter0_49 <= var3_49)
	end

	local var5_49 = Drop.Create(var1_49:getConfig("award_display")[1])

	updateDorm3dIcon(var4_49:Find("Dorm3dIconTpl"), var5_49)
	onButton(arg0_49, var4_49:Find("Dorm3dIconTpl"), function()
		if not var2_49 and var1_49:isFinish() then
			arg0_49:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_49)
		else
			arg0_49:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_49
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_49:Find("Dorm3dIconTpl/get"), not var2_49 and var1_49:isFinish())
	setGray(var4_49:Find("Dorm3dIconTpl"), var2_49)
	onButton(arg0_49, arg0_49._tf:Find("Main/task_done"), function()
		setActive(arg0_49.rtWeekTask, true)
		setActive(arg0_49._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_49, arg0_49.rtWeekTask:Find("title"), function()
		if var2_49 then
			setActive(arg0_49.rtWeekTask, false)
			setActive(arg0_49._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_53, arg1_53)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_53) then
		return
	end

	return switch(arg1_53, {
		DORM3D_GUIDE_02 = function()
			local var0_54 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_54 and not var0_54:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_53
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_53)))
				pg.NewGuideMgr.GetInstance():Play(arg1_53, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_53)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_53
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_53)))
			pg.NewGuideMgr.GetInstance():Play(arg1_53, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_53)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.SetMapSwitch(arg0_59)
	local var0_59 = getProxy(PlayerProxy):getRawData().id

	arg0_59.selectedFloorId = PlayerPrefs.GetInt("DORM_SELECTED_FLOOR_ID" .. var0_59, 1)

	if pg.NewGuideMgr.GetInstance():GetCurrentGuideName() == "DORM3D_GUIDE_01" then
		arg0_59.selectedFloorId = 1
	else
		local var1_59 = pg.dorm3d_set.drom3d_new_room_remind.key_value_int

		if PlayerPrefs.GetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_59 .. var1_59, 0) == 0 then
			arg0_59.selectedFloorId = table.indexof(arg0_59.floorData, pg.dorm3d_rooms[var1_59].in_map)

			PlayerPrefs.SetInt("DORM_SELECTED_NEW_ROOM_FLOOR" .. var0_59 .. var1_59, 1)
		end
	end

	local var2_59 = arg0_59._tf:Find("interludeAni")
	local var3_59 = var2_59:GetComponent(typeof(Animation))
	local var4_59 = var2_59:GetComponent(typeof(DftAniEvent))

	onButton(arg0_59, arg0_59.rtMain:Find("btn_switch/left"), function()
		var4_59:SetTriggerEvent(function()
			arg0_59:ChangeMap(arg0_59.selectedFloorId - 1)
		end)
		var3_59:Play("anim_InterludeAni")
	end)
	onButton(arg0_59, arg0_59.rtMain:Find("btn_switch/right"), function()
		var4_59:SetTriggerEvent(function()
			arg0_59:ChangeMap(arg0_59.selectedFloorId + 1)
		end)
		var3_59:Play("anim_InterludeAni")
	end)
	setActive(arg0_59.rtMain:Find("btn_switch/switchPanel"), false)

	local var5_59 = arg0_59.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(Animation))

	arg0_59.rtMain:Find("btn_switch/switchPanel"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_59.rtMain:Find("btn_switch/switchPanel"), false)
	end)
	onButton(arg0_59, arg0_59.rtMain:Find("btn_switch/switch"), function()
		setActive(arg0_59.rtMain:Find("btn_switch/switchPanel"), true)
	end)
	onButton(arg0_59, arg0_59.rtMain:Find("btn_switch/switchPanel"), function()
		var5_59:Play("anim_switchPanel_exit")
	end)

	local var6_59 = UIItemList.New(arg0_59.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"), arg0_59.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content/floor"))

	var6_59:make(function(arg0_67, arg1_67, arg2_67)
		if arg0_67 == UIItemList.EventUpdate then
			local var0_67 = arg0_59.floorData[arg1_67 + 1]
			local var1_67 = Clone(pg.dorm3d_rooms.get_id_list_by_in_map[var0_67])

			for iter0_67 = #var1_67, 1, -1 do
				if pg.dorm3d_rooms[var1_67[iter0_67]].is_common == 1 then
					table.remove(var1_67, iter0_67)
				end
			end

			setActive(arg2_67:Find("select"), arg1_67 + 1 == arg0_59.selectedFloorId)
			setText(arg2_67:Find("name"), i18n("dorm3d_room_" .. var0_67))
			table.sort(var1_67, CompareFuncs({
				function(arg0_68)
					local var0_68 = getProxy(ApartmentProxy):getRoom(arg0_68)

					return (var0_68 and var0_68:getState() or "lock") == "complete" and 0 or 1
				end,
				function(arg0_69)
					return pg.dorm3d_rooms[arg0_69].type == 2 and 0 or 1
				end
			}))

			local var2_67 = UIItemList.New(arg2_67:Find("rooms"), arg2_67:Find("rooms/room"))

			var2_67:make(function(arg0_70, arg1_70, arg2_70)
				if arg0_70 == UIItemList.EventUpdate then
					local var0_70 = var1_67[arg1_70 + 1]
					local var1_70 = pg.dorm3d_rooms[var0_70]
					local var2_70 = getProxy(ApartmentProxy):getRoom(var0_70)
					local var3_70 = var2_70 and var2_70:getState() or "lock"

					setActive(arg2_70:Find("lock"), var3_70 ~= "complete")
					setActive(arg2_70:Find("normal"), var3_70 == "complete")

					if var3_70 == "complete" then
						local var4_70 = string.format("dorm3dselect/room_icon_%s", string.lower(var1_70.assets_prefix))

						GetImageSpriteFromAtlasAsync(var4_70, "", arg2_70:Find("normal/mask/icon"), false)
					end

					setText(arg2_70:Find("roomId"), var0_70)
				end
			end)
			var2_67:align(#var1_67)
			onButton(arg0_59, arg2_67, function()
				var4_59:SetTriggerEvent(function()
					arg0_59:ChangeMap(arg1_67 + 1)
				end)
				var3_59:Play("anim_InterludeAni")
				var5_59:Play("anim_switchPanel_exit")
			end, SFX_PANEL)
		end
	end)
	var6_59:align(#arg0_59.floorData)
	arg0_59:ChangeMap(arg0_59.selectedFloorId)
end

function var0_0.ChangeMap(arg0_73, arg1_73)
	arg0_73.selectedFloorId = arg1_73

	local var0_73 = getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt("DORM_SELECTED_FLOOR_ID" .. var0_73, arg0_73.selectedFloorId)
	arg0_73:SetFloor(arg0_73.floorData[arg0_73.selectedFloorId])
	setActive(arg0_73.rtMain:Find("btn_switch/left"), arg0_73.selectedFloorId > 1)
	setActive(arg0_73.rtMain:Find("btn_switch/right"), arg0_73.selectedFloorId < #arg0_73.floorData)
	setText(arg0_73.rtMain:Find("btn_switch/switch/currentName"), i18n("dorm3d_room_" .. arg0_73.floorData[arg0_73.selectedFloorId]))

	for iter0_73 = 0, #arg0_73.floorData - 1 do
		setActive(arg0_73.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter0_73):Find("select"), iter0_73 + 1 == arg1_73)
	end

	arg0_73.floorTipFlag = {}
	arg0_73.floorRoomTipFlag = {}

	for iter1_73, iter2_73 in ipairs(arg0_73.floorData) do
		local var1_73 = false
		local var2_73 = {}
		local var3_73 = pg.dorm3d_rooms.get_id_list_by_in_map[iter2_73]

		for iter3_73, iter4_73 in ipairs(var3_73) do
			if pg.dorm3d_rooms[iter4_73].is_common == 0 then
				var2_73[iter4_73] = false

				local var4_73 = getProxy(ApartmentProxy):getRoom(iter4_73)
				local var5_73 = var4_73 and var4_73:getState() or "lock"

				if var5_73 == "complete" and var4_73:isPersonalRoom() and getProxy(ApartmentProxy):getApartment(var4_73:getPersonalGroupId()):getIconTip(var4_73:GetConfigID()) then
					var1_73 = true
					var2_73[iter4_73] = true
				end

				if var5_73 == "complete" and not var4_73:isPersonalRoom() then
					var2_73[iter4_73] = PlayerPrefs.GetInt(var0_73 .. "_dorm3dRoomInviteSuccess_" .. iter4_73, 1) == 0
				end
			end
		end

		table.insert(arg0_73.floorTipFlag, var1_73)
		table.insert(arg0_73.floorRoomTipFlag, var2_73)
	end

	if arg0_73.selectedFloorId > 1 then
		setActive(arg0_73.rtMain:Find("btn_switch/left/tip"), arg0_73.floorTipFlag[arg0_73.selectedFloorId - 1])
	end

	if arg0_73.selectedFloorId < #arg0_73.floorData then
		setActive(arg0_73.rtMain:Find("btn_switch/right/tip"), arg0_73.floorTipFlag[arg0_73.selectedFloorId + 1])
	end

	setActive(arg0_73.rtMain:Find("btn_switch/switch/tip"), table.contains(arg0_73.floorTipFlag, true))

	for iter5_73 = 0, arg0_73.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content").childCount - 1 do
		local var6_73 = arg0_73.rtMain:Find("btn_switch/switchPanel/switchScrollView/Viewport/Content"):GetChild(iter5_73)

		for iter6_73 = 0, var6_73:Find("rooms").childCount - 1 do
			local var7_73 = var6_73:Find("rooms"):GetChild(iter6_73)
			local var8_73 = var7_73:Find("roomId"):GetComponent(typeof(Text)).text

			setActive(var7_73:Find("normal/tip"), arg0_73.floorRoomTipFlag[iter5_73 + 1][tonumber(var8_73)])
		end
	end
end

function var0_0.onBackPressed(arg0_74)
	if isActive(arg0_74.rtIconTip) then
		arg0_74:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_74)
	end
end

function var0_0.willExit(arg0_75)
	if isActive(arg0_75.rtIconTip) then
		arg0_75:HideIconTipWindow()
	end

	if arg0_75.clearSceneCache then
		-- block empty
	end
end

return var0_0
