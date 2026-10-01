local var0_0 = class("Dorm3dInsMainLayer", import("...base.BaseUI"))

var0_0.OPEN_INS = "Dorm3dInsMainLayer.OPEN_INS"
var0_0.OPEN_CHAT = "Dorm3dInsMainLayer.OPEN_CHAT"
var0_0.OPEN_PHONE = "Dorm3dInsMainLayer.OPEN_PHONE"
var0_0.DOWNLOAD_ROOM = "Dorm3dInsMainLayer.DOWNLOAD_ROOM"
var0_0.DELETE_ROOM = "Dorm3dInsMainLayer.DELETE_ROOM"
var0_0.FLUSH_LEFT = "Dorm3dInsMainLayer.FLUSH_LEFT"

local var1_0 = 1
local var2_0 = 2
local var3_0 = "PAGE_INS"
local var4_0 = "PAGE_CHAT"
local var5_0 = "PAGE_PHONE"
local var6_0 = "PAGE_MAIN"
local var7_0 = 2
local var8_0 = 1

function var0_0.getUIName(arg0_1)
	return "Dorm3dInsMainUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {}

	local function var1_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	for iter0_2, iter1_2 in ipairs(getProxy(Dorm3dInsProxy):GetRoomList() or {}) do
		var1_2(iter1_2:GetIcon())
		var1_2(iter1_2:GetCard())
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_4)
	arg0_4.bg = arg0_4._tf:Find("bg")
	arg0_4.mainTf = arg0_4._tf:Find("main")
	arg0_4.mainPages = {
		[var8_0] = Dorm3dInsPublicPage.New(arg0_4._tf:Find("main/public_page"), arg0_4.event),
		[var7_0] = Dorm3dInsCharPage.New(arg0_4._tf:Find("main/char_page"), arg0_4.event)
	}
	arg0_4.roomListContainer = arg0_4._tf:Find("left/scroll/mask/list")
	arg0_4.roomItemList = UIItemList.New(arg0_4.roomListContainer, arg0_4.roomListContainer:Find("tpl"))

	arg0_4.roomItemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateRoomList(arg1_5, arg2_5)
		end
	end)

	arg0_4.expandPanel = arg0_4._tf:Find("expand_panel")
	arg0_4.expandListContainer = arg0_4._tf:Find("expand_panel/scroll/mask/list")
	arg0_4.expandItemList = UIItemList.New(arg0_4.expandListContainer, arg0_4.expandListContainer:Find("tpl"))

	arg0_4.expandItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			arg0_4:UpdateRoomList(arg1_6, arg2_6)
		end
	end)

	arg0_4.selectPanel = arg0_4._tf:Find("select_panel")
	arg0_4.selectListContainer = arg0_4._tf:Find("select_panel/list")
	arg0_4.selectItemList = UIItemList.New(arg0_4.selectListContainer, arg0_4.selectListContainer:Find("tpl"))

	arg0_4.selectItemList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventInit then
			arg0_4:InitSelectItem(arg1_7, arg2_7)
		end
	end)

	arg0_4.selectOpen = false
	arg0_4.downloadTf = arg0_4._tf:Find("main/download")
	arg0_4.download = arg0_4.downloadTf:Find("btns/download")
	arg0_4.downloading = arg0_4.downloadTf:Find("btns/downloading")
	arg0_4.delete = arg0_4.downloadTf:Find("btns/delete")
	arg0_4.downloadProgress = arg0_4.downloadTf:Find("progress")
	arg0_4.slider = arg0_4.downloadProgress:Find("slider")

	arg0_4:BlurPanel(arg0_4._tf)
	arg0_4:InitData()
end

function var0_0.InitData(arg0_8)
	arg0_8.roomDataDic = {}
	arg0_8.roomDataList = Clone(getProxy(Dorm3dInsProxy):GetRoomList())

	for iter0_8, iter1_8 in ipairs(arg0_8.roomDataList) do
		arg0_8.roomDataDic[iter1_8.id] = iter1_8
	end

	arg0_8.selectOptions = {}

	arg0_8:BuildSelectOptions()
	arg0_8:FilterRoomList(var1_0)
	arg0_8:SortRoomList()
end

function var0_0.BuildSelectOptions(arg0_9)
	table.insert(arg0_9.selectOptions, {
		mode = var1_0,
		label = i18n("dorm3d_privatechat_screen_all")
	})

	for iter0_9, iter1_9 in pairs(pg.dorm3d_rooms.get_id_list_by_in_map) do
		table.insert(arg0_9.selectOptions, {
			mode = var2_0,
			arg = iter0_9,
			label = i18n("dorm3d_privatechat_screen_" .. iter0_9)
		})
	end
end

function var0_0.FilterRoomList(arg0_10, arg1_10, arg2_10)
	arg0_10.roomIdList = _.map(_.select(arg0_10.roomDataList, function(arg0_11)
		return switch(arg1_10, {
			[var1_0] = function()
				return true
			end,
			[var2_0] = function()
				return arg0_11:GetInMap() == arg2_10
			end
		})
	end), function(arg0_14)
		return arg0_14.id
	end)
end

function var0_0.SortRoomList(arg0_15)
	table.sort(arg0_15.roomIdList, function(arg0_16, arg1_16)
		local var0_16 = arg0_15.roomDataDic[arg0_16]:IsCare() and 1 or 0
		local var1_16 = arg0_15.roomDataDic[arg1_16]:IsCare() and 1 or 0

		if var0_16 ~= var1_16 then
			return var1_16 < var0_16
		end

		local var2_16 = arg0_15.roomDataDic[arg0_16]:GetType()
		local var3_16 = arg0_15.roomDataDic[arg1_16]:GetType()

		if var2_16 ~= var3_16 then
			return var3_16 < var2_16
		end

		return arg0_16 < arg1_16
	end)
end

function var0_0.ClosePrePage(arg0_17)
	switch(arg0_17.curPage, {
		[var3_0] = function()
			arg0_17:emit(Dorm3dInsMainMediator.CLOSE_JUUS)
		end,
		[var4_0] = function()
			arg0_17:emit(Dorm3dInsMainMediator.CLOSE_CHAT)
		end,
		[var5_0] = function()
			arg0_17:emit(Dorm3dInsMainMediator.CLOSE_PHONE)
		end,
		[var6_0] = function()
			setActive(arg0_17.mainTf, false)
		end
	})

	arg0_17.curPage = nil
end

function var0_0.didEnter(arg0_22)
	onButton(arg0_22, arg0_22.bg, function()
		if arg0_22.curPage then
			arg0_22:ClosePrePage()
		end

		arg0_22:closeView()
	end, SFX_PANEL)
	onButton(arg0_22, arg0_22._tf:Find("left/btn_select"), function()
		arg0_22:OpenOrCloseSelectPanel()
	end)
	onButton(arg0_22, arg0_22.selectPanel:Find("back"), function()
		arg0_22:OpenOrCloseSelectPanel()
	end)
	onButton(arg0_22, arg0_22._tf:Find("left/btn_expand"), function()
		setActive(arg0_22.expandPanel, true)
		arg0_22.expandPanel:SetAsLastSibling()
	end)
	onButton(arg0_22, arg0_22.expandPanel:Find("btn_close"), function()
		setActive(arg0_22.expandPanel, false)
	end)
	onButton(arg0_22, arg0_22.downloadTf, function()
		arg0_22:OnClickDownload(arg0_22.selectedId)
	end)

	local function var0_22(arg0_29)
		if not arg0_22.roomDataDic[arg0_22.selectedId]:IsDownloaded() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_room_unlock"))
		else
			existCall(arg0_29)
		end
	end

	arg0_22:bind(var0_0.OPEN_INS, function(arg0_30)
		var0_22(function()
			arg0_22:ClosePrePage()

			arg0_22.curPage = var3_0

			arg0_22:emit(Dorm3dInsMainMediator.OPEN_JUUS, arg0_22.roomDataDic[arg0_22.selectedId].groupId)
		end)
	end)
	arg0_22:bind(var0_0.OPEN_CHAT, function(arg0_32)
		var0_22(function()
			arg0_22:ClosePrePage()

			arg0_22.curPage = var4_0

			arg0_22:emit(Dorm3dInsMainMediator.OPEN_CHAT, arg0_22.roomDataDic[arg0_22.selectedId].groupId)
		end)
	end)
	arg0_22:bind(var0_0.OPEN_PHONE, function(arg0_34)
		var0_22(function()
			if DORM_LOCK_INS_PHONE then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_telephone"))

				return
			end

			arg0_22:ClosePrePage()

			arg0_22.curPage = var5_0

			arg0_22:emit(Dorm3dInsMainMediator.OPEN_PHONE, arg0_22.roomDataDic[arg0_22.selectedId].groupId)
		end)
	end)
	arg0_22:bind(var0_0.FLUSH_LEFT, function(arg0_36)
		arg0_22:SortRoomList()
		arg0_22.roomItemList:align(#arg0_22.roomIdList)
	end)

	arg0_22.selectedId = arg0_22.roomIdList[1]

	arg0_22.selectItemList:align(#arg0_22.selectOptions)

	arg0_22.curPage = var6_0

	arg0_22:Flush()

	if arg0_22.contextData.isPhone then
		-- block empty
	end
end

function var0_0.UpdateRoomList(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.roomDataDic[arg0_37.roomIdList[arg1_37 + 1]]

	setActive(arg2_37:Find("selected"), var0_37.id == arg0_37.selectedId)
	setActive(arg2_37:Find("like"), var0_37:IsCare())
	GetImageSpriteFromAtlasAsync(var0_37:GetIcon(), "", arg2_37:Find("mask/icon"), true)
	setActive(arg2_37:Find("tip"), var0_37:ShouldTip())
	onButton(arg0_37, arg2_37, function()
		arg0_37.selectedId = var0_37.id

		if arg0_37.curPage ~= var6_0 then
			arg0_37:OpenMain()
		end

		arg0_37:Flush()
	end)
end

function var0_0.OpenMain(arg0_39)
	arg0_39:ClosePrePage()
	setActive(arg0_39.mainTf, true)
	arg0_39:Flush()

	arg0_39.curPage = var6_0
end

function var0_0.Flush(arg0_40)
	local function var0_40(arg0_41)
		return #arg0_40.mainPages - arg0_41 + 1
	end

	local var1_40 = arg0_40.roomDataDic[arg0_40.selectedId]:GetType()
	local var2_40 = var0_40(var1_40)

	arg0_40.mainPages[var2_40]:Hide()
	arg0_40.mainPages[var1_40]:Show()
	arg0_40.mainPages[var1_40]:Flush(arg0_40.roomDataDic[arg0_40.selectedId])
	arg0_40.roomItemList:align(#arg0_40.roomIdList)
	arg0_40.expandItemList:align(#arg0_40.roomIdList)
	arg0_40:FlushDownload()
end

function var0_0.FlushLeft(arg0_42)
	arg0_42.roomItemList:align(#arg0_42.roomIdList)
end

function var0_0.InitSelectItem(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.selectOptions[arg1_43 + 1]

	setText(arg2_43:Find("label"), var0_43.label)
	onButton(arg0_43, arg2_43, function()
		arg0_43:FilterRoomList(var0_43.mode, var0_43.arg)
		arg0_43:SortRoomList()
		arg0_43.roomItemList:align(#arg0_43.roomIdList)
		arg0_43.expandItemList:align(#arg0_43.roomIdList)
	end)
end

function var0_0.OpenOrCloseSelectPanel(arg0_45)
	arg0_45.selectOpen = not arg0_45.selectOpen

	setActive(arg0_45.selectPanel, arg0_45.selectOpen)

	if arg0_45.selectOpen then
		arg0_45.selectPanel:SetAsLastSibling()
	end
end

local var9_0 = 1
local var10_0 = 2
local var11_0 = 3

function var0_0.CheckCurrentDownloadState(arg0_46, arg1_46)
	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg1_46 then
		return var11_0
	end

	return arg0_46.roomDataDic[arg1_46]:IsDownloaded() and var10_0 or var9_0
end

function var0_0.FlushDownload(arg0_47, arg1_47)
	arg1_47 = arg1_47 or arg0_47:CheckCurrentDownloadState(arg0_47.selectedId)

	setActive(arg0_47.download, arg1_47 == var9_0)
	setActive(arg0_47.delete, arg1_47 == var10_0)
	setActive(arg0_47.downloading, arg1_47 == var11_0)
	arg0_47:FlushDownloadSlider(arg1_47)
end

function var0_0.FlushDownloadSlider(arg0_48, arg1_48)
	setActive(arg0_48.downloadProgress, arg1_48 == var11_0)

	if arg1_48 == var11_0 then
		local var0_48 = DormGroupConst.DormDownloadLock

		setSlider(arg0_48.slider, 0, var0_48.totalSize, var0_48.curSize)
	end
end

function var0_0.DownloadUpdate(arg0_49, arg1_49, arg2_49)
	if arg1_49 ~= arg0_49.selectedId then
		return
	end

	switch(arg2_49, {
		start = function()
			arg0_49:FlushDownload(var11_0)
		end,
		loading = function()
			arg0_49:FlushDownloadSlider(var11_0)
		end,
		finish = function()
			arg0_49:FlushDownload(var10_0)
		end,
		delete = function()
			arg0_49:FlushDownload(var9_0)
		end
	})
end

function var0_0.OnClickDownload(arg0_54, arg1_54)
	if not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02") then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

		return
	end

	local var0_54 = arg0_54:CheckCurrentDownloadState(arg1_54)

	switch(var0_54, {
		[var10_0] = function()
			arg0_54:DeleteRoom(arg1_54)
		end,
		[var9_0] = function()
			if not getProxy(ApartmentProxy):getRoom(arg1_54) then
				if arg0_54.roomDataDic[arg1_54]:GetType() == 1 then
					arg0_54:emit(Dorm3dInsMainMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_54)
				elseif arg0_54.roomDataDic[arg1_54]:GetType() == 2 then
					arg0_54:emit(Dorm3dInsMainMediator.ON_UNLOCK_DORM_ROOM, arg1_54)
				end
			else
				arg0_54:TryDownloadResource({
					roomId = arg1_54
				})
			end
		end,
		[var11_0] = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))
		end
	})
end

function var0_0.TryDownloadResource(arg0_58, arg1_58, arg2_58)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_58 = getProxy(ApartmentProxy):getRoom(arg1_58.roomId)
	local var1_58 = var0_58:getDownloadNameList()

	if #var1_58 > 0 then
		local var2_58 = {
			isShowBox = true,
			fileList = var1_58,
			finishFunc = function(arg0_59)
				if arg0_59 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_58.configId
		}

		DormGroupConst.DormDownload(var2_58)
	else
		existCall(arg2_58)
	end
end

function var0_0.DeleteRoom(arg0_60, arg1_60)
	arg0_60:TryDownloadResource({
		roomId = arg1_60
	}, function()
		local var0_61 = getProxy(ApartmentProxy):getRoom(arg1_60)
		local var1_61 = var0_61:getConfig("room")

		if var0_61:isPersonalRoom() then
			var1_61 = ShipGroup.getDefaultShipNameByGroupID(var0_61:getPersonalGroupId())
		end

		local var2_61

		if var0_61:isPersonalRoom() then
			var2_61 = DormGroupConst.GetDelRoomSize(string.lower(var0_61:getConfig("resource_name")), {
				"room",
				"apartment"
			})
		else
			var2_61 = DormGroupConst.GetDelRoomSize(string.lower(var0_61:getConfig("resource_name")), {
				"room"
			})
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dorm3d_role_assets_delete", var1_61, var2_61),
			onYes = function()
				if IsUnityEditor then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

					return
				end

				if var0_61:isPersonalRoom() then
					DormGroupConst.DelRoom(string.lower(var0_61:getConfig("resource_name")), {
						"room",
						"apartment"
					})
				else
					DormGroupConst.DelRoom(string.lower(var0_61:getConfig("resource_name")), {
						"room"
					})
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_delete_finish"))
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDownload(var0_61.id, 3))
				arg0_60:emit(Dorm3dInsMainMediator.NotifyDormDelete, arg1_60)
			end
		})
	end)
end

return var0_0
