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
	onButton(arg0_2, arg0_2.rtMain:Find("btn_mgr"), function()
		arg0_2:ShowMgrPanel()
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

	local var0_2 = arg0_2.rtMgrChar:Find("container")

	arg0_2.charRoomCardItemList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	arg0_2.charRoomCardItemList:make(function(arg0_8, arg1_8, arg2_8)
		arg1_8 = arg1_8 + 1

		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = arg0_2.filterCharRoomIds[arg1_8]

			setActive(arg2_8:Find("base"), var0_8)
			setActive(arg2_8:Find("empty"), not var0_8)

			if not var0_8 then
				arg2_8.name = "null"

				setText(arg2_8:Find("empty/Text"), i18n("dorm3d_waiting"))
			else
				arg2_8.name = tostring(var0_8)
				arg0_2.cardDic[var0_8] = arg2_8:Find("base")

				arg0_2:InitCardTrigger(var0_8)
				arg0_2:UpdateCardState(var0_8)

				return
			end
		end
	end)

	arg0_2.rtMgrPublic = arg0_2.rtMgrPanel:Find("window/public")

	setText(arg0_2.rtMgrPublic:Find("title"), i18n("dorm3d_role_manage_public_area"))

	local var1_2 = arg0_2.rtMgrPublic:Find("container")

	arg0_2.publicRoomCardItemList = UIItemList.New(var1_2, var1_2:Find("tpl"))

	arg0_2.publicRoomCardItemList:make(function(arg0_9, arg1_9, arg2_9)
		arg1_9 = arg1_9 + 1

		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg0_2.filterPublicRoomIds[arg1_9]

			arg0_2.cardDic[var0_9] = arg2_9

			arg0_2:InitCardTrigger(var0_9)
			arg0_2:UpdateCardState(var0_9)
		end
	end)
end

function var0_0.didEnter(arg0_10)
	arg0_10.contextData.floorName = arg0_10.contextData.floorName or "floor_1"

	arg0_10:SetFloor(arg0_10.contextData.floorName)
	arg0_10:UpdateStamina()
	arg0_10:CheckGuide("DORM3D_GUIDE_02")
end

function var0_0.UpdateStamina(arg0_11)
	setText(arg0_11.rtStamina:Find("Text"), string.format("%d/%d", getProxy(ApartmentProxy):getStamina()))
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

function var0_0.InitIconTrigger(arg0_14, arg1_14)
	local var0_14 = arg0_14.roomDic[arg1_14]
	local var1_14 = pg.dorm3d_rooms[arg1_14].assets_prefix

	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(var1_14)), "", var0_14:Find("icon"))
	onButton(arg0_14, var0_14, function()
		if BLOCK_DORM3D_ROOMS and table.contains(BLOCK_DORM3D_ROOMS, arg1_14) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_system_switch"))

			return
		end

		local var0_15 = getProxy(ApartmentProxy):getRoom(arg1_14)
		local var1_15 = pg.dorm3d_rooms[arg1_14].type

		if var1_15 == 1 then
			if not var0_15 then
				arg0_14:emit(SelectDorm3DMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_14)
			else
				arg0_14:TryDownloadResource({
					click = true,
					roomId = arg1_14
				}, function()
					local var0_16 = underscore.map(string.split(PlayerPrefs.GetString(string.format("room%d_invite_list", arg1_14), ""), "|"), function(arg0_17)
						return tonumber(arg0_17)
					end)

					if arg0_14:CheckGuide("DORM3D_GUIDE_06") then
						var0_16 = {}
					end

					arg0_14:emit(SelectDorm3DMediator.OPEN_INVITE_LAYER, arg1_14, var0_16)
				end)
			end
		elseif var1_15 == 2 then
			if not var0_15 then
				arg0_14:ShowIconTipWindow(arg1_14, var0_14)
			else
				arg0_14:TryDownloadResource({
					click = true,
					roomId = arg1_14
				}, function()
					arg0_14:emit(SelectDorm3DMediator.ON_DORM, {
						roomId = var0_15.id,
						groupIds = var0_15:getInviteList()
					})
				end)
			end
		else
			assert(false)
		end
	end, SFX_PANEL)
end

function var0_0.UpdateIconState(arg0_19, arg1_19)
	local var0_19 = arg0_19.roomDic[arg1_19]
	local var1_19 = getProxy(ApartmentProxy):getRoom(arg1_19)
	local var2_19 = var1_19 and var1_19:getState() or "lock"

	setActive(var0_19:Find("icon/mask"), var2_19 ~= "complete")
	eachChild(var0_19:Find("front"), function(arg0_20)
		setActive(arg0_20, arg0_20.name == var2_19)
	end)
	switch(var2_19, {
		loading = function()
			local var0_21 = DormGroupConst.DormDownloadLock

			setSlider(var0_19:Find("front/loading/progress"), 0, var0_21.totalSize, var0_21.curSize)
		end,
		complete = function()
			local var0_22 = var0_19:Find("front/complete")
			local var1_22 = var1_19:isPersonalRoom()

			setActive(var0_22, var1_22)

			if var1_22 then
				local var2_22 = getProxy(ApartmentProxy):getApartment(var1_19:getPersonalGroupId())
				local var3_22 = var2_22:getIconTip(var1_19:GetConfigID())

				eachChild(var0_22:Find("tip"), function(arg0_23)
					setActive(arg0_23, arg0_23.name == var3_22)
				end)
				setText(var0_22:Find("favor/Text"), var2_22.level)
			end
		end
	})
end

function var0_0.UpdateShowIcon(arg0_24, arg1_24, arg2_24)
	removeOnButton(arg2_24)
	setActive(arg2_24:Find("icon/mask"), false)
	eachChild(arg2_24:Find("front"), function(arg0_25)
		setActive(arg0_25, false)
	end)
end

function var0_0.ReplaceSpecialRoomIcon(arg0_26)
	local var0_26 = {}

	for iter0_26, iter1_26 in pairs(getProxy(ApartmentProxy):getRawData()) do
		for iter2_26, iter3_26 in ipairs(iter1_26:getSpecialTalking()) do
			local var1_26 = pg.dorm3d_dialogue_group[iter3_26].trigger_config[1]

			var0_26[var1_26] = var0_26[var1_26] or {}

			table.insert(var0_26[var1_26], iter3_26)
		end
	end

	for iter4_26, iter5_26 in pairs(var0_26) do
		setActive(arg0_26.roomDic[iter4_26], false)

		local var2_26 = cloneTplTo(arg0_26.roomDic[iter4_26], arg0_26.roomDic[iter4_26].parent, arg0_26.roomDic[iter4_26].name .. "_special")

		arg0_26:UpdateShowIcon(iter4_26, var2_26)
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_icon_%s", string.lower(pg.dorm3d_rooms[iter4_26].assets_prefix)), "", var2_26:Find("icon"))
		setActive(var2_26:Find("front/complete"), true)
		setActive(var2_26:Find("front/complete/favor"), false)
		eachChild(var2_26:Find("front/complete/tip"), function(arg0_27)
			setActive(arg0_27, arg0_27.name == "main")
		end)
		table.sort(iter5_26)

		local var3_26 = iter5_26[1]
		local var4_26 = pg.dorm3d_dialogue_group[var3_26]

		onButton(arg0_26, var2_26, function()
			arg0_26:TryDownloadResource({
				click = true,
				roomId = var4_26.room_id
			}, function()
				arg0_26:emit(SelectDorm3DMediator.ON_DORM, {
					roomId = var4_26.room_id,
					groupIds = {
						var4_26.char_id
					},
					specialId = var3_26
				})
			end)
		end, SFX_PANEL)
	end
end

function var0_0.InitCardTrigger(arg0_30, arg1_30)
	local var0_30 = getProxy(ApartmentProxy):getRoom(arg1_30)

	assert(var0_30)

	local var1_30 = arg0_30.cardDic[arg1_30]
	local var2_30 = var0_30:getConfig("assets_prefix")

	if var0_30:isPersonalRoom() then
		local var3_30 = var0_30:getPersonalGroupId()

		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", var3_30), "", var1_30:Find("Image"))
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", var3_30), "", var1_30:Find("name"))
		onButton(arg0_30, var1_30, function()
			arg0_30:TryDownloadResource({
				click = true,
				roomId = arg1_30
			}, function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("dorm3d_role_assets_delete", ShipGroup.getDefaultShipNameByGroupID(var3_30)),
					onYes = function()
						if IsUnityEditor then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

							return
						end

						local var0_33 = var0_30:getConfig("resource_name")

						DormGroupConst.DelDir("dorm3d/character/" .. string.lower(var0_33))
						pg.TipsMgr.GetInstance():ShowTips("delete finish !")
					end
				})
			end)
		end, SFX_PANEL)
	else
		GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_%s", string.lower(var2_30)), "", var1_30:Find("Image"))
		removeOnButton(var1_30)
	end
end

function var0_0.UpdateCardState(arg0_34, arg1_34)
	local var0_34 = getProxy(ApartmentProxy):getRoom(arg1_34)
	local var1_34 = arg0_34.cardDic[arg1_34]
	local var2_34 = var0_34:getState()

	if var0_34:isPersonalRoom() then
		setActive(var1_34:Find("lock"), var2_34 ~= "complete")
		setActive(var1_34:Find("unlock"), var2_34 == "complete")

		local var3_34 = getProxy(ApartmentProxy):getApartment(var0_34:getPersonalGroupId())

		setText(var1_34:Find("favor_level/Text"), var3_34 and var3_34.level or "?")
	end

	local var4_34 = var1_34:Find("operation")

	eachChild(var4_34, function(arg0_35)
		setActive(arg0_35, arg0_35.name == var2_34)
	end)
	setImageAlpha(var4_34:Find("complete"), var0_34:isPersonalRoom() and 1 or 0)

	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg1_34 then
		arg0_34:UpdateCardProgess()
	end

	setActive(var1_34:Find("mask"), var2_34 ~= "complete")
end

function var0_0.UpdateCardProgess(arg0_36)
	local var0_36 = DormGroupConst.DormDownloadLock
	local var1_36 = arg0_36.cardDic[var0_36.roomId]

	setSlider(var1_36:Find("operation/loading"), 0, var0_36.totalSize, var0_36.curSize)
end

function var0_0.UpdateSelectableCard(arg0_37, arg1_37, arg2_37, arg3_37)
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_%d", arg2_37), "", arg1_37:Find("Image"))
	GetImageSpriteFromAtlasAsync(string.format("dorm3dselect/room_card_apartment_name_%d", arg2_37), "", arg1_37:Find("name"))

	local var0_37 = getProxy(ApartmentProxy):getApartment(arg2_37)
	local var1_37 = not var0_37 or var0_37:needDownload()

	setActive(arg1_37:Find("lock"), var1_37)
	setActive(arg1_37:Find("mask"), var1_37)
	setActive(arg1_37:Find("unlock"), not var1_37)
	setActive(arg1_37:Find("favor_level"), var0_37)

	if var0_37 then
		setText(arg1_37:Find("favor_level/Text"), var0_37.level)
	end

	onToggle(arg0_37, arg1_37, function(arg0_38)
		arg3_37(arg0_38)

		if arg0_38 then
			if not var0_37 then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need unlock apartment{%d}", arg2_37))
				triggerToggle(arg1_37, false)
			elseif var0_37:needDownload() then
				pg.TipsMgr.GetInstance():ShowTips(string.format("need download resource{%d}", arg2_37))
				triggerToggle(arg1_37, false)
			end
		end
	end, SFX_UI_CLICK)
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
				if iter0_42 == arg1_39 or pg.dorm3d_rooms[iter0_42].type == 1 then
					arg0_39:UpdateIconState(iter0_42)
				end
			end

			if arg0_39.cardDic then
				for iter2_42, iter3_42 in pairs(arg0_39.cardDic) do
					if iter2_42 == arg1_39 or pg.dorm3d_rooms[iter2_42].type == 1 then
						arg0_39:UpdateCardState(iter2_42)
					end
				end
			else
				arg0_39:CheckGuide("DORM3D_GUIDE_02")
			end
		end
	})
end

function var0_0.AfterRoomUnlock(arg0_43, arg1_43)
	local var0_43 = arg1_43.roomId

	if isActive(arg0_43.rtIconTip) then
		arg0_43:HideIconTipWindow()
	end

	eachChild(arg0_43.roomDic[var0_43]:Find("icon/mask"), function(arg0_44)
		setActive(arg0_44, true)
	end)
	quickPlayAnimation(arg0_43.roomDic[var0_43], "anim_Dorm3d_selectDorm_icon_unlock")
	pg.UIMgr.GetInstance():LoadingOn(false)
	LeanTween.delayedCall(1.23333333333333, System.Action(function()
		pg.UIMgr.GetInstance():LoadingOff(false)
		arg0_43:UpdateIconState(var0_43)
		arg0_43:TryDownloadResource(arg1_43)
		arg0_43:CheckGuide("DORM3D_GUIDE_02")
	end))
end

function var0_0.ShowIconTipWindow(arg0_46, arg1_46, arg2_46)
	setLocalPosition(arg0_46.rtIconTip:Find("window"), arg0_46.rtIconTip:InverseTransformPoint(arg2_46.position))
	removeAllChildren(arg0_46.rtIconTip:Find("window/icon"))

	arg2_46 = cloneTplTo(arg2_46, arg0_46.rtIconTip:Find("window/icon"))

	arg0_46:UpdateShowIcon(arg1_46, arg2_46)
	setAnchoredPosition(arg2_46, Vector2.zero)

	local var0_46 = ApartmentRoom.New({
		id = arg1_46
	})
	local var1_46, var2_46 = var0_46:getDownloadNeedSize()

	setText(arg0_46.rtIconTip:Find("window/Text"), i18n("dorm3d_role_assets_download", ShipGroup.getDefaultShipNameByGroupID(var0_46:getPersonalGroupId()), var0_46:needDownload() and var2_46 or "0B"))
	onButton(arg0_46, arg0_46.rtIconTip:Find("window/btn_confirm"), function()
		arg0_46:emit(SelectDorm3DMediator.ON_UNLOCK_DORM_ROOM, arg1_46)
	end, SFX_CONFIRM)
	setActive(arg0_46.rtIconTip, true)
end

function var0_0.HideIconTipWindow(arg0_48)
	setActive(arg0_48.rtIconTip, false)
end

function var0_0.ShowMgrPanel(arg0_49)
	arg0_49.cardDic = {}
	arg0_49.filterCharRoomIds = {}
	arg0_49.filterPublicRoomIds = {}

	for iter0_49, iter1_49 in ipairs(underscore.filter(pg.dorm3d_rooms.all, function(arg0_50)
		return tobool(getProxy(ApartmentProxy):getRoom(arg0_50))
	end)) do
		local var0_49 = pg.dorm3d_rooms[iter1_49].type

		if var0_49 == 1 then
			table.insert(arg0_49.filterPublicRoomIds, iter1_49)
		elseif var0_49 == 2 then
			table.insert(arg0_49.filterCharRoomIds, iter1_49)
		else
			assert(false)
		end
	end

	arg0_49.charRoomCardItemList:align(#arg0_49.filterCharRoomIds)
	arg0_49.publicRoomCardItemList:align(#arg0_49.filterPublicRoomIds)
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_49.rtMgrPanel, {
		force = true,
		pbList = {
			arg0_49.rtMgrPanel:Find("window")
		}
	})
	setActive(arg0_49.rtMgrPanel, true)
end

function var0_0.HideMgrPanel(arg0_51)
	arg0_51.cardDic = nil

	pg.UIMgr.GetInstance():UnblurPanel(arg0_51.rtMgrPanel, arg0_51.rtLayer)
	setActive(arg0_51.rtMgrPanel, false)
end

function var0_0.TryDownloadResource(arg0_52, arg1_52, arg2_52)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips("now is downloading")

		return
	end

	local var0_52 = getProxy(ApartmentProxy):getRoom(arg1_52.roomId)
	local var1_52, var2_52 = var0_52:getDownloadNameList()

	if #var1_52 > 0 or #var2_52 > 0 then
		local var3_52 = {
			isShowBox = true,
			fileList = table.mergeArray(var1_52, var2_52),
			finishFunc = function(arg0_53)
				if arg0_53 then
					pg.TipsMgr.GetInstance():ShowTips("dorm resource download complete !")
				end

				if arg0_52.roomDic[var0_52.configId] then
					arg0_52:UpdateIconState(var0_52.configId)
				end
			end,
			roomId = var0_52.configId
		}

		DormGroupConst.DormDownload(var3_52)
	else
		existCall(arg2_52)
	end
end

function var0_0.InitResBar(arg0_54)
	arg0_54.goldMax = arg0_54.rtRes:Find("gold/max"):GetComponent(typeof(Text))
	arg0_54.goldValue = arg0_54.rtRes:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_54.oilMax = arg0_54.rtRes:Find("oil/max"):GetComponent(typeof(Text))
	arg0_54.oilValue = arg0_54.rtRes:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_54.gemValue = arg0_54.rtRes:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_54, arg0_54.rtRes:Find("gold"), function()
		warning("debug test")
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54.rtRes:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_54, arg0_54.rtRes:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_54:UpdateRes()
end

function var0_0.UpdateRes(arg0_58)
	local var0_58 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_58, arg0_58.goldMax, arg0_58.goldValue, arg0_58.oilMax, arg0_58.oilValue, arg0_58.gemValue)
end

function var0_0.UpdateWeekTask(arg0_59)
	local var0_59 = getDorm3dGameset("drom3d_weekly_task")[1]
	local var1_59 = getProxy(TaskProxy):getTaskVO(var0_59)
	local var2_59 = var1_59:isReceive()
	local var3_59 = var2_59 and 3 or var1_59:getProgress()
	local var4_59 = arg0_59.rtWeekTask:Find("content")

	for iter0_59 = 1, 3 do
		triggerToggle(var4_59:Find("tpl_" .. iter0_59), iter0_59 <= var3_59)
	end

	local var5_59 = Drop.Create(var1_59:getConfig("award_display")[1])

	updateDorm3dIcon(var4_59:Find("Dorm3dIconTpl"), var5_59)
	onButton(arg0_59, var4_59:Find("Dorm3dIconTpl"), function()
		if not var2_59 and var1_59:isFinish() then
			arg0_59:emit(SelectDorm3DMediator.ON_SUBMIT_TASK, var0_59)
		else
			arg0_59:emit(BaseUI.ON_NEW_DROP, {
				drop = var5_59
			})
		end
	end, SFX_CONFIRM)
	setActive(var4_59:Find("Dorm3dIconTpl/get"), not var2_59 and var1_59:isFinish())
	setGray(var4_59:Find("Dorm3dIconTpl"), var2_59)
	onButton(arg0_59, arg0_59._tf:Find("Main/task_done"), function()
		setActive(arg0_59.rtWeekTask, true)
		setActive(arg0_59._tf:Find("Main/task_done"), false)
	end)
	onButton(arg0_59, arg0_59.rtWeekTask:Find("title"), function()
		if var2_59 then
			setActive(arg0_59.rtWeekTask, false)
			setActive(arg0_59._tf:Find("Main/task_done"), true)
		end
	end)
end

function var0_0.CheckGuide(arg0_63, arg1_63)
	if pg.NewStoryMgr.GetInstance():IsPlayed(arg1_63) then
		return
	end

	return switch(arg1_63, {
		DORM3D_GUIDE_02 = function()
			local var0_64 = getProxy(ApartmentProxy):getApartment(20220)

			if var0_64 and not var0_64:needDownload() then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = arg1_63
				})
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_63)))
				pg.NewGuideMgr.GetInstance():Play(arg1_63, nil, function()
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_63)))
				end)

				return true
			end
		end,
		DORM3D_GUIDE_06 = function()
			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = arg1_63
			})
			pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(1, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_63)))
			pg.NewGuideMgr.GetInstance():Play(arg1_63, nil, function()
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGuide(2, pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_63)))
			end)

			return true
		end
	}, function()
		return false
	end)
end

function var0_0.onBackPressed(arg0_69)
	if isActive(arg0_69.rtMgrPanel) then
		arg0_69:HideMgrPanel()
	elseif isActive(arg0_69.rtIconTip) then
		arg0_69:HideIconTipWindow()
	else
		var0_0.super.onBackPressed(arg0_69)
	end
end

function var0_0.willExit(arg0_70)
	if isActive(arg0_70.rtMgrPanel) then
		arg0_70:HideMgrPanel()
	end

	if isActive(arg0_70.rtIconTip) then
		arg0_70:HideIconTipWindow()
	end

	if arg0_70.clearSceneCache then
		BLHX.Rendering.EngineCore.TryDispose(true)

		local var0_70 = typeof("BLHX.Rendering.Executor")
		local var1_70 = ReflectionHelp.RefGetProperty(var0_70, "Instance", nil)

		ReflectionHelp.RefCallMethod(var0_70, "TryHandleWaitLinkList", var1_70)
	end
end

return var0_0
