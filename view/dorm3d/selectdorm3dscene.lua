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
	onButton(arg0_3, arg0_3.rtMain:Find("btn_mgr"), function()
		arg0_3:ShowMgrPanel()
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
	DormProxy.CheckDeviceRAMEnough()
end

function var0_0.UpdateStamina(arg0_12)
	setText(arg0_12.rtStamina:Find("Text"), string.format("%d/%d", getProxy(ApartmentProxy):getStamina()))
end

function var0_0.SetFloor(arg0_13, arg1_13)
	local var0_13

	eachChild(arg0_13.rtMap, function(arg0_14)
		setActive(arg0_14, arg0_14.name == arg1_13)

		if arg0_14.name == arg1_13 then
			var0_13 = arg0_14
		end
	end)
	assert(var0_13)

	arg0_13.roomDic = {}

	for iter0_13, iter1_13 in ipairs(pg.dorm3d_rooms.get_id_list_by_in_map[arg1_13]) do
		arg0_13.roomDic[iter1_13] = var0_13:Find(pg.dorm3d_rooms[iter1_13].assets_prefix)

		arg0_13:InitIconTrigger(iter1_13)
		arg0_13:UpdateIconState(iter1_13)
	end

	arg0_13:ReplaceSpecialRoomIcon()
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

		local var0_16 = getProxy(ApartmentProxy):getRoom(arg1_15)
		local var1_16 = pg.dorm3d_rooms[arg1_15].type

		if var1_16 == 1 then
			if not var0_16 then
				arg0_15:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_15)
			else
				arg0_15:TryDownloadResource({
					click = true,
					roomId = arg1_15
				}, function()
					local var0_17 = underscore.map(string.split(PlayerPrefs.GetString(string.format("room%d_invite_list", arg1_15), ""), "|"), function(arg0_18)
						return tonumber(arg0_18)
					end)

					if arg0_15:CheckGuide("DORM3D_GUIDE_06") then
						var0_17 = {}
					end

					arg0_15:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_15, var0_17)
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

			var0_27[var1_27] = var0_27[var1_27] or {}

			table.insert(var0_27[var1_27], iter3_27)
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

function var0_0.InitCardTrigger(arg0_31, arg1_31)
	local var0_31 = getProxy(ApartmentProxy):getRoom(arg1_31)

	assert(var0_31)

	local var1_31 = arg0_31.cardDic[arg1_31]
	local var2_31 = var0_31:getConfig("assets_prefix")

	if var0_31:isPersonalRoom() then
		local var3_31 = var0_31:getPersonalGroupId()

		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var3_31), "", var1_31:Find("Image"))
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", var3_31), "", var1_31:Find("name"))
		onButton(arg0_31, var1_31, function()
			arg0_31:TryDownloadResource({
				click = true,
				roomId = arg1_31
			}, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("dorm3d_role_assets_delete", ShipGroup.getDefaultShipNameByGroupID(var3_31)),
					onYes = function()
						if IsUnityEditor then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

							return
						end

						local var0_34 = var0_31:getConfig("resource_name")

						DormGroupConst.DelDir("dorm3d/character/" .. string.lower(var0_34))
						pg.TipsMgr.GetInstance():ShowTips("delete finish !")
					end
				})
			end)
		end, SFX_PANEL)
	else
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_%s", string.lower(var2_31)), "", var1_31:Find("Image"))
		removeOnButton(var1_31)
	end
end

function var0_0.UpdateCardState(arg0_35, arg1_35)
	local var0_35 = getProxy(ApartmentProxy):getRoom(arg1_35)
	local var1_35 = arg0_35.cardDic[arg1_35]
	local var2_35 = var0_35:getState()

	if var0_35:isPersonalRoom() then
		setActive(var1_35:Find("lock"), var2_35 ~= "complete")
		setActive(var1_35:Find("unlock"), var2_35 == "complete")

		local var3_35 = getProxy(ApartmentProxy):getApartment(var0_35:getPersonalGroupId())

		setText(var1_35:Find("favor_level/Text"), var3_35 and var3_35.level or "?")
	end

	local var4_35 = var1_35:Find("operation")

	eachChild(var4_35, function(arg0_36)
		setActive(arg0_36, arg0_36.name == var2_35)
	end)
	setImageAlpha(var4_35:Find("complete"), var0_35:isPersonalRoom() and 1 or 0)

	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg1_35 then
		arg0_35:UpdateCardProgess()
	end

	setActive(var1_35:Find("mask"), var2_35 ~= "complete")
end

function var0_0.UpdateCardProgess(arg0_37)
	local var0_37 = DormGroupConst.DormDownloadLock
	local var1_37 = arg0_37.cardDic[var0_37.roomId]

	setSlider(var1_37:Find("operation/loading"), 0, var0_37.totalSize, var0_37.curSize)
end

function var0_0.UpdateSelectableCard(arg0_38, arg1_38, arg2_38, arg3_38)
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", arg2_38), "", arg1_38:Find("Image"))
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", arg2_38), "", arg1_38:Find("name"))

	local var0_38 = getProxy(ApartmentProxy):getApartment(arg2_38)
	local var1_38 = not var0_38 or var0_38:needDownload()

	setActive(arg1_38:Find("lock"), var1_38)
	setActive(arg1_38:Find("mask"), var1_38)
	setActive(arg1_38:Find("unlock"), not var1_38)
	setActive(arg1_38:Find("favor_level"), var0_38)

	if var0_38 then
		setText(arg1_38:Find("favor_level/Text"), var0_38.level)
	end

	onToggle(arg0_38, arg1_38, function(arg0_39)
		arg3_38(arg0_39)

		if arg0_39 then
			if not var0_38 then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need unlock apartment{%d}", arg2_38))
				triggerToggle(arg1_38, false)
			elseif var0_38:needDownload() then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need download resource{%d}", arg2_38))
				triggerToggle(arg1_38, false)
			end
		end
	end, SFX_UI_CLICK)
end

function var0_0.DownloadUpdate(arg0_40, arg1_40, arg2_40)
	switch(arg2_40, {
		start = function()
			if arg0_40.roomDic[arg1_40] then
				arg0_40:UpdateIconState(arg1_40)
			end

			if arg0_40.cardDic and arg0_40.cardDic[arg1_40] then
				arg0_40:UpdateCardState(arg1_40)
			end
		end,
		loading = function()
			if arg0_40.roomDic[arg1_40] then
				local var0_42 = DormGroupConst.DormDownloadLock

				setSlider(arg0_40.roomDic[arg1_40]:Find("front/loading/progress"), 0, var0_42.totalSize, var0_42.curSize)
			end

			if arg0_40.cardDic and arg0_40.cardDic[arg1_40] then
				arg0_40:UpdateCardProgess()
			end
		end,
		finish = function()
			for iter0_43, iter1_43 in pairs(arg0_40.roomDic) do
				if iter0_43 == arg1_40 or pg.dorm3d_rooms[iter0_43].type == 1 then
					arg0_40:UpdateIconState(iter0_43)
				end
			end

			if arg0_40.cardDic then
				for iter2_43, iter3_43 in pairs(arg0_40.cardDic) do
					if iter2_43 == arg1_40 or pg.dorm3d_rooms[iter2_43].type == 1 then
						arg0_40:UpdateCardState(iter2_43)
					end
				end
			else
				arg0_40:CheckGuide("DORM3D_GUIDE_02")
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
end

function var0_0.TryDownloadResource(arg0_53, arg1_53, arg2_53)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips("now is downloading")

		return
	end

	local var0_53 = getProxy(ApartmentProxy):getRoom(arg1_53.roomId)
	local var1_53, var2_53 = var0_53:getDownloadNameList()

	if #var1_53 > 0 or #var2_53 > 0 then
		local var3_53 = {
			isShowBox = true,
			fileList = table.mergeArray(var1_53, var2_53),
			finishFunc = function(arg0_54)
				if arg0_54 then
					pg.TipsMgr.GetInstance():ShowTips("dorm resource download complete !")
				end

				if arg0_53.exited then
					return
				end

				if arg0_53.roomDic[var0_53.configId] then
					arg0_53:UpdateIconState(var0_53.configId)
				end
			end,
			roomId = var0_53.configId
		}

		DormGroupConst.DormDownload(var3_53)
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
