local var0_0 = class("GalleryView", import("..base.BaseSubView"))

var0_0.GalleryPicGroupName = "GALLERY_PIC"

function var0_0.getUIName(arg0_1)
	return "GalleryUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()

	arg0_2.galleryScrollView = GalleryScrollView.New(arg0_2.scrollPanel, arg0_2)
	arg0_2.galleryGridView = GalleryGridView.New(arg0_2.gridPanel, arg0_2)

	arg0_2:Show()
	arg0_2:refreshPicInfoList()
	arg0_2:tryShowTipMsgBox()
end

function var0_0.OnDestroy(arg0_3)
	if arg0_3.galleryScrollView then
		arg0_3.galleryScrollView:dispose()

		arg0_3.galleryScrollView = nil
	end

	if arg0_3.galleryGridView then
		arg0_3.galleryGridView:dispose()

		arg0_3.galleryGridView = nil
	end
end

function var0_0.onBackPressed(arg0_4)
	return true
end

function var0_0.initData(arg0_5)
	arg0_5.appreciateProxy = getProxy(AppreciateProxy)

	arg0_5.appreciateProxy:checkPicFileState()

	arg0_5.picInfoListForShow = {}
	arg0_5.isDownloading = false
	arg0_5.downloadCount = 0
	arg0_5.downloadTotal = 0
	arg0_5.downloadFailed = false
	arg0_5.hasMissingGalleryPic = false
	arg0_5.hasExistingGalleryPic = false
	arg0_5.curViewMode = "scroll"
	arg0_5.curPicLikeValue = GalleryConst.Filte_Normal_Value
	arg0_5.curPicSetValue = GalleryConst.Filte_Set_Normal_Value
	arg0_5.curPicSortValue = GalleryConst.Sort_Order_Up
end

function var0_0.findUI(arg0_6)
	setLocalPosition(arg0_6._tf, Vector2.zero)

	arg0_6._tf.anchorMin = Vector2.zero
	arg0_6._tf.anchorMax = Vector2.one
	arg0_6._tf.offsetMax = Vector2.zero
	arg0_6._tf.offsetMin = Vector2.zero
	arg0_6.topPanel = arg0_6._tf:Find("TopPanel")
	arg0_6.setFilterToggle = arg0_6.topPanel:Find("List/SetFilterBtn")

	setText(arg0_6.setFilterToggle:Find("TextLikeOff"), i18n("loading_pic_btn"))
	setText(arg0_6.setFilterToggle:Find("TextLikeOn"), i18n("loading_pic_btn"))
	setActive(arg0_6.setFilterToggle, true)

	local var0_6 = arg0_6.topPanel:Find("List/TimeFilterBtn")

	setActive(var0_6, false)

	arg0_6.likeFilterToggle = arg0_6.topPanel:Find("List/LikeFilterBtn")

	setActive(arg0_6.likeFilterToggle, true)

	arg0_6.likeNumText = arg0_6.likeFilterToggle:Find("TextNum")

	setActive(arg0_6.likeNumText, false)

	arg0_6.orderToggle = arg0_6.topPanel:Find("List/OrderBtn")
	arg0_6.resRepaireBtn = arg0_6.topPanel:Find("List/RepaireBtn")
	arg0_6.switchToGridBtn = arg0_6.topPanel:Find("SwitchToGridBtn")
	arg0_6.switchToScrollBtn = arg0_6.topPanel:Find("SwitchToScrollBtn")
	arg0_6.scrollPanel = arg0_6._tf:Find("Scroll")
	arg0_6.gridPanel = arg0_6._tf:Find("Grid")
	arg0_6.emptyPanel = arg0_6._tf:Find("EmptyPanel")
	arg0_6.updatePanel = arg0_6._tf:Find("UpdatePanel")
end

function var0_0.addListener(arg0_7)
	onToggle(arg0_7, arg0_7.orderToggle, function(arg0_8)
		if arg0_8 == true then
			arg0_7.curPicSortValue = GalleryConst.Sort_Order_Down
		else
			arg0_7.curPicSortValue = GalleryConst.Sort_Order_Up
		end

		arg0_7:refreshPicInfoList(true)
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.likeFilterToggle, function(arg0_9)
		if arg0_9 == true then
			arg0_7.curPicLikeValue = GalleryConst.Filte_Like_Value
		else
			arg0_7.curPicLikeValue = GalleryConst.Filte_Normal_Value
		end

		arg0_7:refreshPicInfoList(true)
	end)
	onToggle(arg0_7, arg0_7.setFilterToggle, function(arg0_10)
		if arg0_10 == true then
			arg0_7.curPicSetValue = GalleryConst.Filte_Set_Value
		else
			arg0_7.curPicSetValue = GalleryConst.Filte_Set_Normal_Value
		end

		arg0_7:refreshPicInfoList(true)
	end)
	onButton(arg0_7, arg0_7.resRepaireBtn, function()
		local var0_11 = {
			text = i18n("msgbox_repair"),
			onCallback = function()
				if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-pic.csv") then
					BundleWizard.Inst:GetGroupMgr(var0_0.GalleryPicGroupName):StartVerifyForLua()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
				end
			end
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				var0_11
			}
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.switchToGridBtn, function()
		arg0_7:switchViewMode("grid")
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.switchToScrollBtn, function()
		arg0_7:switchViewMode("scroll")
	end, SFX_PANEL)
end

function var0_0.refreshPicInfoList(arg0_15)
	arg0_15:filterPicInfoList()
	arg0_15:updateViewDisplay()
end

function var0_0.switchViewMode(arg0_16, arg1_16)
	if arg0_16.curViewMode == arg1_16 then
		return
	end

	arg0_16.curViewMode = arg1_16

	arg0_16:resetActiveViewState()
	arg0_16:updateViewDisplay()
end

function var0_0.resetActiveViewState(arg0_17)
	if arg0_17.curViewMode == "scroll" and arg0_17.galleryScrollView then
		arg0_17.galleryScrollView:resetMiddleDataIndex()
	end
end

function var0_0.updateViewDisplay(arg0_18)
	local var0_18 = #arg0_18.picInfoListForShow <= 0
	local var1_18 = var0_18 and not arg0_18.hasExistingGalleryPic and arg0_18.hasMissingGalleryPic and arg0_18:isNeedShowDownBtn()
	local var2_18 = arg0_18.curViewMode == "scroll"
	local var3_18 = arg0_18.curViewMode == "grid"

	setActive(arg0_18.emptyPanel, var0_18 and not var1_18)
	setActive(arg0_18.updatePanel, var1_18)
	setActive(arg0_18.scrollPanel, not var0_18 and not var1_18 and var2_18)
	setActive(arg0_18.gridPanel, not var0_18 and not var1_18 and var3_18)
	setActive(arg0_18.switchToGridBtn, var2_18)
	setActive(arg0_18.switchToScrollBtn, var3_18)

	if var1_18 then
		arg0_18:initDownBtnPanel()
	elseif not var0_18 then
		if var3_18 then
			arg0_18.galleryGridView:refresh(arg0_18.picInfoListForShow)
		else
			arg0_18.galleryScrollView:refresh(arg0_18.picInfoListForShow)
		end
	end
end

function var0_0.initDownBtnPanel(arg0_19)
	local var0_19 = arg0_19.updatePanel:Find("Btn")
	local var1_19 = var0_19:Find("Text")
	local var2_19 = arg0_19.updatePanel:Find("Progress")

	setActive(var0_19, not arg0_19.isDownloading)
	setActive(var2_19, arg0_19.isDownloading)

	if arg0_19.downloadFailed then
		setText(var1_19, i18n("word_manga_updatefailure"))
	elseif arg0_19.isDownloading then
		local var3_19, var4_19 = arg0_19:getGalleryDownloadProgress()

		setText(var1_19, i18n("word_manga_updating", var3_19, var4_19))
	else
		setText(var1_19, i18n("word_manga_checktoupdate"))
	end

	onButton(arg0_19, var0_19, function()
		arg0_19:showDownloadMsgBox()
	end, SFX_PANEL)
end

function var0_0.isGalleryDownloading(arg0_21)
	return arg0_21.isDownloading
end

function var0_0.isGalleryDownloadFailed(arg0_22)
	return arg0_22.downloadFailed
end

function var0_0.getGalleryDownloadProgress(arg0_23)
	return arg0_23.downloadCount, arg0_23.downloadTotal
end

function var0_0.refreshDownloadStateViews(arg0_24)
	if arg0_24.galleryScrollView then
		arg0_24.galleryScrollView:updateEmptyCardDownloadStateList()
	end

	if arg0_24.galleryGridView then
		arg0_24.galleryGridView:updateEmptyCardDownloadStateList()
	end

	if arg0_24.updatePanel and isActive(arg0_24.updatePanel) then
		arg0_24:initDownBtnPanel()
	end
end

function var0_0.showDownloadMsgBox(arg0_25)
	local var0_25 = GroupHelper.GetGroupSize(var0_0.GalleryPicGroupName)
	local var1_25 = HashUtil.BytesToString(var0_25)

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_NORMAL,
		content = string.format(i18n("group_download_tip", var1_25)),
		onYes = function()
			arg0_25:startDownloadGroup()
		end
	})
end

function var0_0.startDownloadGroup(arg0_27)
	if arg0_27.isDownloading or arg0_27.exited then
		return
	end

	arg0_27.isDownloading = true
	arg0_27.downloadFailed = false
	arg0_27.downloadCount = 0
	arg0_27.downloadTotal = 0

	arg0_27:refreshDownloadStateViews()

	local var0_27 = {
		var0_0.GalleryPicGroupName
	}
	local var1_27 = table.concat(var0_27, "_")

	local function var2_27(arg0_28, arg1_28, arg2_28)
		arg0_27:onDownloadProgress(arg0_28, arg1_28, arg2_28)
	end

	local function var3_27(arg0_29, arg1_29)
		arg0_27:onDownloadFinish(arg0_29, arg1_29)
	end

	local var4_27 = BundleWizardUpdater.Inst:GetFileList(var0_27)
	local var5_27 = BundleWizardUpdater.Inst:CreateListInfo(var1_27, var4_27, nil, var3_27, var2_27)

	BundleWizardUpdater.Inst:StartUpdate(var5_27)
end

function var0_0.onDownloadProgress(arg0_30, arg1_30, arg2_30, arg3_30)
	if arg0_30.exited then
		return
	end

	arg0_30.downloadCount = (arg1_30 or 0) + (arg2_30 or 0)
	arg0_30.downloadTotal = arg3_30 or 0

	arg0_30:refreshDownloadStateViews()
end

function var0_0.onDownloadFinish(arg0_31, arg1_31, arg2_31)
	arg0_31.isDownloading = false
	arg0_31.downloadFailed = not arg1_31

	if arg0_31.exited then
		return
	end

	if arg1_31 then
		arg0_31.downloadCount = arg0_31.downloadTotal

		arg0_31.appreciateProxy:checkPicFileState()
		arg0_31:refreshDownloadStateViews()
		arg0_31:refreshPicInfoList()
	else
		arg0_31:refreshDownloadStateViews()
		arg0_31:showDownloadRetryMsgBox(arg2_31)
	end
end

function var0_0.showDownloadRetryMsgBox(arg0_32, arg1_32)
	if arg1_32 then
		warning("gallery download failed:", tostring(arg1_32))
	end

	local function var0_32()
		if not arg0_32.exited then
			arg0_32.downloadFailed = false
			arg0_32.downloadCount = 0
			arg0_32.downloadTotal = 0

			arg0_32:refreshDownloadStateViews()
		end
	end

	local function var1_32()
		if not arg0_32.exited then
			arg0_32:startDownloadGroup()
		end
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_NORMAL,
		content = i18n("file_down_mgr_error", "", tostring(arg1_32 or "")),
		onYes = var1_32,
		onNo = var0_32,
		onClose = var0_32
	})
end

function var0_0.tryShowTipMsgBox(arg0_35)
	if arg0_35.appreciateProxy:isGalleryHaveNewRes() then
		local function var0_35()
			PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
			arg0_35:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_pic_new_tip", GalleryConst.NewCount),
			onYes = var0_35,
			onCancel = var0_35,
			onClose = var0_35
		})
	end
end

function var0_0.getPicInfoForShowByIndex(arg0_37, arg1_37)
	local var0_37 = arg0_37.picInfoListForShow[arg1_37]

	if var0_37 then
		return var0_37
	elseif var0_37 == false then
		return false
	else
		assert(false, "不存在的Index:" .. tostring(arg1_37))
	end
end

function var0_0.sortPicInfoListForShow(arg0_38)
	local function var0_38(arg0_39, arg1_39)
		if arg0_38.curPicSortValue == GalleryConst.Sort_Order_Up then
			return arg0_39.id < arg1_39.id
		elseif arg0_38.curPicSortValue == GalleryConst.Sort_Order_Down then
			return arg0_39.id >= arg1_39.id
		end
	end

	table.sort(arg0_38.picInfoListForShow, var0_38)
end

function var0_0.filterPicInfoForShow(arg0_40)
	local var0_40 = {}

	arg0_40.hasMissingGalleryPic = false

	for iter0_40, iter1_40 in ipairs(pg.gallery_config.all) do
		if arg0_40.appreciateProxy:getPicExistStateByID(iter1_40) then
			var0_40[#var0_40 + 1] = AppreciatePicConst.createPicInfo(AppreciatePicConst.TYPE_GALLERY, iter1_40)
		else
			arg0_40.hasMissingGalleryPic = true
		end
	end

	arg0_40.hasExistingGalleryPic = #var0_40 > 0

	return var0_40
end

function var0_0.filterPicInfoForShowByLike(arg0_41)
	if arg0_41.curPicLikeValue == GalleryConst.Filte_Normal_Value then
		return arg0_41.picInfoListForShow
	end

	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(arg0_41.picInfoListForShow) do
		if GalleryConst.isGalleryLikeByID(iter1_41.id) then
			var0_41[#var0_41 + 1] = iter1_41
		end
	end

	return var0_41
end

function var0_0.filterPicInfoForShowBySet(arg0_42)
	if arg0_42.curPicSetValue == GalleryConst.Filte_Set_Normal_Value then
		return arg0_42.picInfoListForShow
	end

	local var0_42 = {}
	local var1_42 = getProxy(LoadingPicProxy):getDiyModeOpenFlag()

	for iter0_42, iter1_42 in ipairs(arg0_42.picInfoListForShow) do
		local var2_42

		if var1_42 then
			var2_42 = AppreciatePicConst.isUsedPicInfo(iter1_42)
		else
			var2_42 = iter1_42.id > 1000
		end

		if var2_42 then
			var0_42[#var0_42 + 1] = iter1_42
		end
	end

	return var0_42
end

function var0_0.filterPicInfoList(arg0_43)
	arg0_43.picInfoListForShow = arg0_43:filterPicInfoForShow()
	arg0_43.picInfoListForShow = arg0_43:filterPicInfoForShowByLike(arg0_43.curPicLikeValue)
	arg0_43.picInfoListForShow = arg0_43:filterPicInfoForShowBySet(arg0_43.curPicSetValue)

	arg0_43:sortPicInfoListForShow()

	if #arg0_43.picInfoListForShow > 0 and arg0_43.hasMissingGalleryPic and arg0_43:isNeedShowDownBtn() then
		table.insert(arg0_43.picInfoListForShow, 1, false)
	end
end

function var0_0.isNeedShowDownBtn(arg0_44)
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0_0.GalleryPicGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0_0.GalleryPicGroupName) then
		return false
	end

	return true
end

return var0_0
