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

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.mainTf = arg0_2._tf:Find("main")
	arg0_2.mainPages = {
		[var8_0] = Dorm3dInsPublicPage.New(arg0_2._tf:Find("main/public_page"), arg0_2.event),
		[var7_0] = Dorm3dInsCharPage.New(arg0_2._tf:Find("main/char_page"), arg0_2.event)
	}
	arg0_2.roomListContainer = arg0_2:findTF("left/scroll/mask/list")
	arg0_2.roomItemList = UIItemList.New(arg0_2.roomListContainer, arg0_2.roomListContainer:Find("tpl"))

	arg0_2.roomItemList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventUpdate then
			arg0_2:UpdateRoomList(arg1_3, arg2_3)
		end
	end)

	arg0_2.expandPanel = arg0_2:findTF("expand_panel")
	arg0_2.expandListContainer = arg0_2:findTF("expand_panel/scroll/mask/list")
	arg0_2.expandItemList = UIItemList.New(arg0_2.expandListContainer, arg0_2.expandListContainer:Find("tpl"))

	arg0_2.expandItemList:make(function(arg0_4, arg1_4, arg2_4)
		if arg0_4 == UIItemList.EventUpdate then
			arg0_2:UpdateRoomList(arg1_4, arg2_4)
		end
	end)

	arg0_2.selectPanel = arg0_2:findTF("select_panel")
	arg0_2.selectListContainer = arg0_2:findTF("select_panel/list")
	arg0_2.selectItemList = UIItemList.New(arg0_2.selectListContainer, arg0_2.selectListContainer:Find("tpl"))

	arg0_2.selectItemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventInit then
			arg0_2:InitSelectItem(arg1_5, arg2_5)
		end
	end)

	arg0_2.selectOpen = false
	arg0_2.downloadTf = arg0_2:findTF("main/download")
	arg0_2.download = arg0_2.downloadTf:Find("btns/download")
	arg0_2.downloading = arg0_2.downloadTf:Find("btns/downloading")
	arg0_2.delete = arg0_2.downloadTf:Find("btns/delete")
	arg0_2.downloadProgress = arg0_2.downloadTf:Find("progress")
	arg0_2.slider = arg0_2.downloadProgress:Find("slider")

	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		groupName = "Instagram",
		weight = LayerWeightConst.SECOND_LAYER
	})
	arg0_2:InitData()
end

function var0_0.InitData(arg0_6)
	arg0_6.roomDataDic = {}
	arg0_6.roomDataList = getProxy(Dorm3dInsProxy):GetRoomList()

	for iter0_6, iter1_6 in ipairs(arg0_6.roomDataList) do
		arg0_6.roomDataDic[iter1_6.id] = iter1_6
	end

	arg0_6.selectOptions = {}

	arg0_6:BuildSelectOptions()
	arg0_6:FilterRoomList(var1_0)
	arg0_6:SortRoomList()
end

function var0_0.BuildSelectOptions(arg0_7)
	table.insert(arg0_7.selectOptions, {
		mode = var1_0,
		label = i18n("dorm3d_privatechat_screen_all")
	})

	for iter0_7, iter1_7 in pairs(pg.dorm3d_rooms.get_id_list_by_in_map) do
		table.insert(arg0_7.selectOptions, {
			mode = var2_0,
			arg = iter0_7,
			label = i18n("dorm3d_privatechat_screen_" .. iter0_7)
		})
	end
end

function var0_0.FilterRoomList(arg0_8, arg1_8, arg2_8)
	arg0_8.roomIdList = _.map(_.select(arg0_8.roomDataList, function(arg0_9)
		return switch(arg1_8, {
			[var1_0] = function()
				return true
			end,
			[var2_0] = function()
				return arg0_9:GetInMap() == arg2_8
			end
		})
	end), function(arg0_12)
		return arg0_12.id
	end)
end

function var0_0.SortRoomList(arg0_13)
	table.sort(arg0_13.roomIdList, function(arg0_14, arg1_14)
		local var0_14 = arg0_13.roomDataDic[arg0_14]:IsCare() and 1 or 0
		local var1_14 = arg0_13.roomDataDic[arg1_14]:IsCare() and 1 or 0

		return var0_14 == var1_14 and arg0_14 < arg1_14 or var1_14 < var0_14
	end)
end

function var0_0.ClosePrePage(arg0_15)
	switch(arg0_15.curPage, {
		[var3_0] = function()
			arg0_15:emit(Dorm3dInsMainMediator.CLOSE_JUUS)
		end,
		[var4_0] = function()
			arg0_15:emit(Dorm3dInsMainMediator.CLOSE_CHAT)
		end,
		[var5_0] = function()
			arg0_15:emit(Dorm3dInsMainMediator.CLOSE_PHONE)
		end,
		[var6_0] = function()
			setActive(arg0_15.mainTf, false)
		end
	})

	arg0_15.curPage = nil
end

function var0_0.didEnter(arg0_20)
	onButton(arg0_20, arg0_20.bg, function()
		if arg0_20.curPage then
			arg0_20:ClosePrePage()
		end

		arg0_20:closeView()
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20._tf:Find("left/btn_select"), function()
		arg0_20:OpenOrCloseSelectPanel()
	end)
	setActive(arg0_20._tf:Find("left/btn_select"), false)
	onButton(arg0_20, arg0_20.selectPanel:Find("back"), function()
		arg0_20:OpenOrCloseSelectPanel()
	end)
	onButton(arg0_20, arg0_20._tf:Find("left/btn_expand"), function()
		setActive(arg0_20.expandPanel, true)
		arg0_20.expandPanel:SetAsLastSibling()
	end)
	onButton(arg0_20, arg0_20.expandPanel:Find("btn_close"), function()
		setActive(arg0_20.expandPanel, false)
	end)
	onButton(arg0_20, arg0_20.downloadTf, function()
		arg0_20:OnClickDownload(arg0_20.selectedId)
	end)

	local function var0_20(arg0_27)
		if not arg0_20.roomDataDic[arg0_20.selectedId]:IsDownloaded() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_room_unlock"))
		else
			existCall(arg0_27)
		end
	end

	arg0_20:bind(var0_0.OPEN_INS, function(arg0_28)
		var0_20(function()
			arg0_20:ClosePrePage()

			arg0_20.curPage = var3_0

			arg0_20:emit(Dorm3dInsMainMediator.OPEN_JUUS, arg0_20.roomDataDic[arg0_20.selectedId].groupId)
		end)
	end)
	arg0_20:bind(var0_0.OPEN_CHAT, function(arg0_30)
		var0_20(function()
			arg0_20:ClosePrePage()

			arg0_20.curPage = var4_0

			arg0_20:emit(Dorm3dInsMainMediator.OPEN_CHAT, arg0_20.roomDataDic[arg0_20.selectedId].groupId)
		end)
	end)
	arg0_20:bind(var0_0.OPEN_PHONE, function(arg0_32)
		var0_20(function()
			if DORM_LOCK_INS_PHONE then
				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_privatechat_telephone"))

				return
			end

			arg0_20:ClosePrePage()

			arg0_20.curPage = var5_0

			arg0_20:emit(Dorm3dInsMainMediator.OPEN_PHONE, arg0_20.roomDataDic[arg0_20.selectedId].groupId)
		end)
	end)
	arg0_20:bind(var0_0.FLUSH_LEFT, function(arg0_34)
		arg0_20:SortRoomList()
		arg0_20.roomItemList:align(#arg0_20.roomIdList)
	end)

	arg0_20.selectedId = arg0_20.roomIdList[1]

	arg0_20.selectItemList:align(#arg0_20.selectOptions)

	arg0_20.curPage = var6_0

	arg0_20:Flush()

	if arg0_20.contextData.isPhone then
		-- block empty
	end
end

function var0_0.UpdateRoomList(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35.roomDataDic[arg0_35.roomIdList[arg1_35 + 1]]

	setActive(arg2_35:Find("selected"), var0_35.id == arg0_35.selectedId)
	setActive(arg2_35:Find("like"), var0_35:IsCare())
	GetImageSpriteFromAtlasAsync(var0_35:GetIcon(), "", arg2_35:Find("mask/icon"), true)
	setActive(arg2_35:Find("tip"), var0_35:ShouldTip())
	onButton(arg0_35, arg2_35, function()
		arg0_35.selectedId = var0_35.id

		if arg0_35.curPage ~= var6_0 then
			arg0_35:OpenMain()
		end

		arg0_35:Flush()
	end)
end

function var0_0.OpenMain(arg0_37)
	arg0_37:ClosePrePage()
	setActive(arg0_37.mainTf, true)
	arg0_37:Flush()

	arg0_37.curPage = var6_0
end

function var0_0.Flush(arg0_38)
	local function var0_38(arg0_39)
		return #arg0_38.mainPages - arg0_39 + 1
	end

	local var1_38 = arg0_38.roomDataDic[arg0_38.selectedId]:GetType()
	local var2_38 = var0_38(var1_38)

	arg0_38.mainPages[var2_38]:Hide()
	arg0_38.mainPages[var1_38]:Show()
	arg0_38.mainPages[var1_38]:Flush(arg0_38.roomDataDic[arg0_38.selectedId])
	arg0_38.roomItemList:align(#arg0_38.roomIdList)
	arg0_38.expandItemList:align(#arg0_38.roomIdList)
	arg0_38:FlushDownload()
end

function var0_0.InitSelectItem(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg0_40.selectOptions[arg1_40 + 1]

	setText(arg2_40:Find("label"), var0_40.label)
	onButton(arg0_40, arg2_40, function()
		arg0_40:FilterRoomList(var0_40.mode, var0_40.arg)
		arg0_40:SortRoomList()
		arg0_40.roomItemList:align(#arg0_40.roomIdList)
		arg0_40.expandItemList:align(#arg0_40.roomIdList)
	end)
end

function var0_0.OpenOrCloseSelectPanel(arg0_42)
	arg0_42.selectOpen = not arg0_42.selectOpen

	setActive(arg0_42.selectPanel, arg0_42.selectOpen)

	if arg0_42.selectOpen then
		arg0_42.selectPanel:SetAsLastSibling()
	end
end

local var9_0 = 1
local var10_0 = 2
local var11_0 = 3

function var0_0.CheckCurrentDownloadState(arg0_43, arg1_43)
	if DormGroupConst.DormDownloadLock and DormGroupConst.DormDownloadLock.roomId == arg1_43 then
		return var11_0
	end

	return arg0_43.roomDataDic[arg1_43]:IsDownloaded() and var10_0 or var9_0
end

function var0_0.FlushDownload(arg0_44, arg1_44)
	arg1_44 = arg1_44 or arg0_44:CheckCurrentDownloadState(arg0_44.selectedId)

	setActive(arg0_44.download, arg1_44 == var9_0)
	setActive(arg0_44.delete, arg1_44 == var10_0)
	setActive(arg0_44.downloading, arg1_44 == var11_0)
	arg0_44:FlushDownloadSlider(arg1_44)
end

function var0_0.FlushDownloadSlider(arg0_45, arg1_45)
	setActive(arg0_45.downloadProgress, arg1_45 == var11_0)

	if arg1_45 == var11_0 then
		local var0_45 = DormGroupConst.DormDownloadLock

		setSlider(arg0_45.slider, 0, var0_45.totalSize, var0_45.curSize)
	end
end

function var0_0.DownloadUpdate(arg0_46, arg1_46, arg2_46)
	if arg1_46 ~= arg0_46.selectedId then
		return
	end

	switch(arg2_46, {
		start = function()
			arg0_46:FlushDownload(var11_0)
		end,
		loading = function()
			arg0_46:FlushDownloadSlider(var11_0)
		end,
		finish = function()
			arg0_46:FlushDownload(var10_0)
		end,
		delete = function()
			arg0_46:FlushDownload(var9_0)
		end
	})
end

function var0_0.OnClickDownload(arg0_51, arg1_51)
	if not getProxy(ApartmentProxy):getRoom(1) or not pg.NewStoryMgr.GetInstance():IsPlayed("DORM3D_GUIDE_02") then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_tip"))

		return
	end

	local var0_51 = arg0_51:CheckCurrentDownloadState(arg1_51)

	switch(var0_51, {
		[var10_0] = function()
			arg0_51:DeleteRoom(arg1_51)
		end,
		[var9_0] = function()
			if not getProxy(ApartmentProxy):getRoom(arg1_51) then
				if arg0_51.roomDataDic[arg1_51]:GetType() == 1 then
					arg0_51:emit(Dorm3dInsMainMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_51)
				elseif arg0_51.roomDataDic[arg1_51]:GetType() == 2 then
					arg0_51:emit(Dorm3dInsMainMediator.ON_UNLOCK_DORM_ROOM, arg1_51)
				end
			else
				arg0_51:TryDownloadResource({
					roomId = arg1_51
				})
			end
		end,
		[var11_0] = function()
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))
		end
	})
end

function var0_0.TryDownloadResource(arg0_55, arg1_55, arg2_55)
	if DormGroupConst.IsDownloading() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_now_is_downloading"))

		return
	end

	local var0_55 = getProxy(ApartmentProxy):getRoom(arg1_55.roomId)
	local var1_55 = var0_55:getDownloadNameList()

	if #var1_55 > 0 then
		local var2_55 = {
			isShowBox = true,
			fileList = var1_55,
			finishFunc = function(arg0_56)
				if arg0_56 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_resource_download_complete"))
				end
			end,
			roomId = var0_55.configId
		}

		DormGroupConst.DormDownload(var2_55)
	else
		existCall(arg2_55)
	end
end

function var0_0.DeleteRoom(arg0_57, arg1_57)
	arg0_57:TryDownloadResource({
		roomId = arg1_57
	}, function()
		local var0_58 = getProxy(ApartmentProxy):getRoom(arg1_57)
		local var1_58 = var0_58:getConfig("room")

		if var0_58:isPersonalRoom() then
			var1_58 = ShipGroup.getDefaultShipNameByGroupID(var0_58:getPersonalGroupId())
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("dorm3d_role_assets_delete", var1_58),
			onYes = function()
				if IsUnityEditor then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

					return
				end

				if var0_58:isPersonalRoom() then
					DormGroupConst.DelRoom(string.lower(var0_58:getConfig("resource_name")), {
						"room",
						"apartment"
					})
				else
					DormGroupConst.DelRoom(string.lower(var0_58:getConfig("resource_name")), {
						"room"
					})
				end

				pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_delete_finish"))
				pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDownload(var0_58.id, 3))
				arg0_57:emit(Dorm3dInsMainMediator.NotifyDormDelete, arg1_57)
			end
		})
	end)
end

return var0_0
