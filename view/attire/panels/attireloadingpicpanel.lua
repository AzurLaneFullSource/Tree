local var0_0 = class("AttireLoadingPicPanel", import("...base.BaseSubView"))

var0_0.FilterMode = {
	Default = 2,
	All = 0,
	Selected = 1,
	Manga = 4,
	Gallery = 3
}

function var0_0.getUIName(arg0_1)
	return "attireloadingpicui"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initUIText()
	arg0_2:autoSelectPanel()
	arg0_2:enterEditMode(false)
end

function var0_0.Update(arg0_3)
	return
end

function var0_0.OnDestroy(arg0_4)
	arg0_4.resLoader:Clear()
end

function var0_0.initData(arg0_5)
	arg0_5.resLoader = AutoLoader.New()
	arg0_5.loadingPicProxy = getProxy(LoadingPicProxy)
	arg0_5.picInfoList = arg0_5:initPicInfoList()
	arg0_5.curFilterMode = var0_0.FilterMode.All
	arg0_5.curPicInfoListForShow = arg0_5:getCurPicInfoListForShow()
	arg0_5.curUsedPicInfoList = arg0_5:getUsedPicInfoList()
	arg0_5.isEditMode = false
	arg0_5.curEditPicInfoList = {}
	arg0_5.isEditChanged = false
	arg0_5.returnCount = 0
end

function var0_0.findUI(arg0_6)
	arg0_6.lScrollRectSC = arg0_6.listTF:GetComponent("LScrollRect")

	arg0_6.lScrollRectSC:BeginLayout()
	arg0_6.lScrollRectSC:EndLayout()
end

function var0_0.addListener(arg0_7)
	onButton(arg0_7, arg0_7.openShowBtn, function()
		local var0_8 = true

		local function var1_8()
			arg0_7:switchPanel(true, true)
		end

		local var2_8 = {
			diyModeOpenFlag = var0_8,
			callback = var1_8
		}

		pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var2_8)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.closeShowBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("loading_quit_tip"),
			onYes = function()
				local var0_11 = false

				local function var1_11()
					arg0_7:switchPanel(false)
				end

				local var2_11 = {
					diyModeOpenFlag = var0_11,
					callback = var1_11
				}

				pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var2_11)
			end
		})

		local var0_10 = {
			diyModeOpenFlag = diyModeOpenFlag,
			callback = closeFunc
		}

		pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_10)
	end, SFX_PANEL)

	function arg0_7.lScrollRectSC.onReturnItem(arg0_13, arg1_13)
		arg0_7:checkReturnCount()
	end

	function arg0_7.lScrollRectSC.onInitItem(arg0_14)
		return
	end

	function arg0_7.lScrollRectSC.onUpdateItem(arg0_15, arg1_15)
		arg0_15 = arg0_15 + 1

		local var0_15 = arg0_7:getCurPicInfoForShowByIndex(arg0_15)

		arg0_7:updatePicTpl(arg1_15, var0_15)
		onButton(arg0_7, arg1_15, function()
			if arg0_7.isEditMode then
				if arg0_7:isPicInfoSelected(var0_15) then
					arg0_7:removePicInfoFromEditList(var0_15)
				else
					arg0_7:addPicInfoToEditList(var0_15)
				end

				arg0_7:updatePicTpl(arg1_15, var0_15)
				arg0_7:updateCountText()
			else
				arg0_7:openPicViewLayer(var0_15)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_7, arg0_7.openFilterBtn, function()
		arg0_7:showFilterPanel(true)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.closeFilterBtn, function()
		arg0_7:showFilterPanel(false)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.filterSelectedBtn, function()
		arg0_7.curFilterMode = var0_0.FilterMode.Selected
		arg0_7.curPicInfoListForShow = arg0_7:getCurPicInfoListForShow()

		arg0_7:updateAllPicTplList()
		arg0_7:showFilterPanel(false)
		arg0_7:updateFilterBtn()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.filterDefaultBtn, function()
		arg0_7.curFilterMode = var0_0.FilterMode.Default
		arg0_7.curPicInfoListForShow = arg0_7:getCurPicInfoListForShow()

		arg0_7:updateAllPicTplList()
		arg0_7:showFilterPanel(false)
		arg0_7:updateFilterBtn()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.filterGalleryBtn, function()
		arg0_7.curFilterMode = var0_0.FilterMode.Gallery
		arg0_7.curPicInfoListForShow = arg0_7:getCurPicInfoListForShow()

		arg0_7:updateAllPicTplList()
		arg0_7:showFilterPanel(false)
		arg0_7:updateFilterBtn()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.filterMangaBtn, function()
		arg0_7.curFilterMode = var0_0.FilterMode.Manga
		arg0_7.curPicInfoListForShow = arg0_7:getCurPicInfoListForShow()

		arg0_7:updateAllPicTplList()
		arg0_7:showFilterPanel(false)
		arg0_7:updateFilterBtn()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.filterAllBtn, function()
		arg0_7.curFilterMode = var0_0.FilterMode.All
		arg0_7.curPicInfoListForShow = arg0_7:getCurPicInfoListForShow()

		arg0_7:updateAllPicTplList()
		arg0_7:showFilterPanel(false)
		arg0_7:updateFilterBtn()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.editBtn, function()
		if not arg0_7.isEditMode then
			arg0_7:enterEditMode(true)
		else
			local function var0_24()
				arg0_7:enterEditMode(false)
			end

			if arg0_7.isEditChanged then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("loading_pic_tip"),
					onYes = function()
						var0_24()
					end
				})
			else
				var0_24()
			end
		end
	end)
	onButton(arg0_7, arg0_7.resetBtn, function()
		arg0_7.curEditPicInfoList = arg0_7:getDefaultPicInfoList()
		arg0_7.isEditChanged = true

		arg0_7:updateCurPicTplList()
		arg0_7:updateCountText()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.clearBtn, function()
		arg0_7.curEditPicInfoList = {}
		arg0_7.isEditChanged = true

		arg0_7:updateCurPicTplList()
		arg0_7:updateCountText()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.confirmBtn, function()
		if #arg0_7.curEditPicInfoList == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loading_pic_min"))

			return
		end

		local var0_29 = true
		local var1_29 = {}
		local var2_29 = {}

		for iter0_29, iter1_29 in ipairs(arg0_7.curEditPicInfoList) do
			if iter1_29.type == AppreciatePicConst.TYPE_GALLERY then
				table.insert(var1_29, iter1_29.id)
			elseif iter1_29.type == AppreciatePicConst.TYPE_MANGA then
				table.insert(var2_29, iter1_29.id)
			end
		end

		local function var3_29()
			arg0_7.isEditChanged = false
			arg0_7.curPicInfoListForShow = arg0_7:getCurPicInfoListForShow()

			arg0_7:enterEditMode(false)
			arg0_7:updateAllPicTplList()
		end

		local var4_29 = {
			diyModeOpenFlag = var0_29,
			galleryPicIDList = var1_29,
			mangaPicIDList = var2_29,
			callback = var3_29
		}

		pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var4_29)
	end, SFX_PANEL)
	arg0_7.filterListTF:GetComponent(typeof(DftAniEvent)):SetCommonEvent(function(arg0_31)
		if arg0_31.stringParameter == "OnFilterMenuPanelClose" then
			setActive(arg0_7.filterPanelTF, false)
		end
	end)
end

function var0_0.initUIText(arg0_32)
	setText(arg0_32.emptyTitieText, i18n("loading_title"))
	setText(arg0_32.emptyTipText, i18n("loading_picture_lack"))
	setText(arg0_32.openShowBtnText, i18n("loading_start_set"))
	setText(arg0_32.closeShowBtnText, i18n("loading_start_set"))
	setText(arg0_32.showTitieText, i18n("loading_title"))
	setText(arg0_32.countTipText, i18n("loading_pic_chosen"))
	setText(arg0_32.emptyViewTipText, i18n("loading_chosen_blank"))
end

function var0_0.autoSelectPanel(arg0_33)
	if arg0_33.loadingPicProxy:getDiyModeOpenFlag() then
		arg0_33:switchPanel(true)
	else
		arg0_33:switchPanel(false)
	end
end

function var0_0.switchPanel(arg0_34, arg1_34, arg2_34)
	if not arg1_34 then
		setActive(arg0_34.emptyPanelTF, true)
		setActive(arg0_34.showPanelTF, false)
		quickPlayAnimation(arg0_34._tf, "anim_AttireLoadingPicUI_not_select")
	elseif arg1_34 and arg2_34 then
		setActive(arg0_34.emptyPanelTF, true)
		setActive(arg0_34.showPanelTF, true)
		quickPlayAnimation(arg0_34._tf, "anim_AttireLoadingPicUI_open")
	elseif arg1_34 then
		setActive(arg0_34.emptyPanelTF, false)
		setActive(arg0_34.showPanelTF, true)
		quickPlayAnimation(arg0_34._tf, "anim_AttireLoadingPicUI_select")
	end

	if arg1_34 then
		arg0_34:updateCountText()
		arg0_34:updateAllPicTplList()
		arg0_34:updateFilterBtn()
	end
end

function var0_0.updateCountText(arg0_35)
	local var0_35

	if arg0_35.isEditMode then
		var0_35 = arg0_35.curEditPicInfoList
	else
		var0_35 = arg0_35.curUsedPicInfoList
	end

	local var1_35 = #var0_35

	setText(arg0_35.countNumText, string.format("%d/%d", var1_35, AppreciatePicConst.MAX_COUNT))
end

function var0_0.updateAllPicTplList(arg0_36)
	arg0_36.resLoader:Clear()
	setActive(arg0_36.emptyViewTF, #arg0_36.curPicInfoListForShow == 0)
	setActive(arg0_36.scrollViewTF, #arg0_36.curPicInfoListForShow > 0)

	if #arg0_36.curPicInfoListForShow > 0 then
		arg0_36.lScrollRectSC:SetTotalCount(#arg0_36.curPicInfoListForShow)
	end
end

function var0_0.enterEditMode(arg0_37, arg1_37)
	arg0_37.isEditMode = arg1_37

	if arg1_37 then
		arg0_37.curEditPicInfoList = Clone(arg0_37.curUsedPicInfoList)
	else
		arg0_37.curEditPicInfoList = {}
		arg0_37.curUsedPicInfoList = arg0_37:getUsedPicInfoList()
	end

	arg0_37.isEditChanged = false

	setActive(arg0_37.clearBtn, arg1_37)
	setActive(arg0_37.confirmBtn, arg1_37)
	setActive(arg0_37.resetBtn, arg1_37)
	arg0_37:updateCurPicTplList()
	arg0_37:updateCountText()
end

function var0_0.updatePicTpl(arg0_38, arg1_38, arg2_38)
	arg0_38:updatePicTplForImg(arg1_38, arg2_38)
	arg0_38:updatePicTplForTag(arg1_38, arg2_38)
	arg0_38:updatePicTplForSelect(arg1_38, arg2_38)
end

function var0_0.updatePicTplForImg(arg0_39, arg1_39, arg2_39)
	local var0_39 = findTF(arg1_39, "Pic/Gallery")
	local var1_39 = findTF(arg1_39, "Pic/Manga/Image")

	setActive(var0_39, arg2_39.type == AppreciatePicConst.TYPE_GALLERY)
	setActive(var1_39, arg2_39.type == AppreciatePicConst.TYPE_MANGA)

	if arg2_39.type == AppreciatePicConst.TYPE_GALLERY then
		arg0_39:setImage(var0_39, arg2_39)
		setActive(findTF(arg1_39, "Pic/Gallery"), true)
		setActive(findTF(arg1_39, "Pic/Manga"), false)
	elseif arg2_39.type == AppreciatePicConst.TYPE_MANGA then
		arg0_39:setImage(var1_39, arg2_39)
		setActive(findTF(arg1_39, "Pic/Gallery"), false)
		setActive(findTF(arg1_39, "Pic/Manga"), true)
	end
end

function var0_0.updatePicTplForTag(arg0_40, arg1_40, arg2_40)
	local var0_40 = findTF(arg1_40, "Tag/Used")
	local var1_40 = findTF(arg1_40, "Tag/New")

	if arg0_40.isEditMode then
		setActive(var0_40, arg0_40:isPicInfoSelected(arg2_40))
	else
		setActive(var0_40, arg0_40:isPicInfoUsed(arg2_40))
	end

	if isActive(var0_40) then
		setActive(var1_40, false)
	else
		setActive(var1_40, arg0_40:isNewPicInfo(arg2_40))
	end
end

function var0_0.updatePicTplForSelect(arg0_41, arg1_41, arg2_41)
	local var0_41 = findTF(arg1_41, "Pic/Selected")

	if arg0_41.isEditMode then
		setActive(var0_41, arg0_41:isPicInfoSelected(arg2_41))
	else
		setActive(var0_41, arg0_41:isPicInfoUsed(arg2_41))
	end
end

function var0_0.setImage(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg2_42.path
	local var1_42 = GetFileName(var0_42)
	local var2_42 = GetComponent(arg1_42, typeof(Image)).sprite

	if not IsNil(var2_42) then
		local var3_42 = var2_42.name

		if string.lower(var3_42) ~= string.lower(var1_42) then
			arg0_42.resLoader:LoadSprite(var0_42, var1_42, arg1_42, false)
		end
	else
		arg0_42.resLoader:LoadSprite(var0_42, var1_42, arg1_42, false)
	end
end

function var0_0.showFilterPanel(arg0_43, arg1_43)
	setActive(arg0_43.filterPanelTF, true)

	if arg1_43 then
		quickPlayAnimation(arg0_43.filterListTF, "anim_FilterMenuPanel_open")
	else
		quickPlayAnimation(arg0_43.filterListTF, "anim_FilterMenuPanel_close")
	end
end

function var0_0.openPicViewLayer(arg0_44, arg1_44)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = AppreciatePicViewMediator,
		viewComponent = AppreciatePicViewLayer,
		data = {
			curPicInfo = arg1_44,
			picInfoList = arg0_44.curPicInfoListForShow
		},
		onRemoved = function()
			arg0_44.curUsedPicInfoList = arg0_44:getUsedPicInfoList()

			arg0_44:updateCurPicTplList()
			arg0_44:updateCountText()
		end
	}))
end

function var0_0.updateCurPicTplList(arg0_46)
	for iter0_46 = 1, arg0_46.listTF.childCount do
		local var0_46 = arg0_46.listTF:GetChild(iter0_46 - 1)
		local var1_46 = go(var0_46).name

		if var1_46 ~= "-1" then
			local var2_46 = tonumber(var1_46) + 1
			local var3_46 = arg0_46:getCurPicInfoForShowByIndex(var2_46)

			arg0_46:updatePicTpl(var0_46, var3_46)
		end
	end
end

function var0_0.checkReturnCount(arg0_47)
	return
end

function var0_0.updateFilterBtn(arg0_48)
	local var0_48 = findTF(arg0_48.openFilterBtn, "ALL")
	local var1_48 = findTF(arg0_48.openFilterBtn, "Default")
	local var2_48 = findTF(arg0_48.openFilterBtn, "Gallery")
	local var3_48 = findTF(arg0_48.openFilterBtn, "Manga")
	local var4_48 = findTF(arg0_48.openFilterBtn, "Selected")

	setActive(var0_48, arg0_48.curFilterMode == var0_0.FilterMode.All)
	setActive(var1_48, arg0_48.curFilterMode == var0_0.FilterMode.Default)
	setActive(var2_48, arg0_48.curFilterMode == var0_0.FilterMode.Gallery)
	setActive(var3_48, arg0_48.curFilterMode == var0_0.FilterMode.Manga)
	setActive(var4_48, arg0_48.curFilterMode == var0_0.FilterMode.Selected)
end

function var0_0.initPicInfoList(arg0_49)
	local var0_49 = {}

	for iter0_49, iter1_49 in ipairs(pg.gallery_config.all) do
		local var1_49 = GalleryConst.GetGalleryPicPathByID(iter1_49)

		if checkABExist(var1_49) then
			local var2_49 = AppreciatePicConst.createPicInfo(AppreciatePicConst.TYPE_GALLERY, iter1_49)

			table.insert(var0_49, var2_49)
		end
	end

	for iter2_49, iter3_49 in ipairs(pg.cartoon.all) do
		local var3_49 = MangaConst.GetMangaPicPathByID(iter3_49)

		if checkABExist(var3_49) then
			local var4_49 = AppreciatePicConst.createPicInfo(AppreciatePicConst.TYPE_MANGA, iter3_49)

			table.insert(var0_49, var4_49)
		end
	end

	return var0_49
end

function var0_0.getUsedPicInfoList(arg0_50)
	local var0_50 = {}

	for iter0_50, iter1_50 in ipairs(arg0_50.picInfoList) do
		if arg0_50:isPicInfoUsed(iter1_50) then
			table.insert(var0_50, iter1_50)
		end
	end

	arg0_50.curUsedPicInfoList = var0_50

	return var0_50
end

function var0_0.isPicInfoUsed(arg0_51, arg1_51)
	return AppreciatePicConst.isUsedPicInfo(arg1_51)
end

function var0_0.isNewPicInfo(arg0_52, arg1_52)
	return AppreciatePicConst.isNewPicInfo(arg1_52)
end

function var0_0.isDefaultPicInfo(arg0_53, arg1_53)
	local var0_53 = arg0_53:isGalleryPic(arg1_53)
	local var1_53 = table.contains(AppreciatePicConst.getDefaultGalleryPicIDList(), arg1_53.id)

	return var0_53 and var1_53
end

function var0_0.isGalleryPic(arg0_54, arg1_54)
	return arg1_54.type == AppreciatePicConst.TYPE_GALLERY
end

function var0_0.isMangaPic(arg0_55, arg1_55)
	return arg1_55.type == AppreciatePicConst.TYPE_MANGA
end

function var0_0.getPicInfoTypeSortWeight(arg0_56, arg1_56)
	if arg0_56:isGalleryPic(arg1_56) and not arg0_56:isDefaultPicInfo(arg1_56) then
		return 3
	elseif arg0_56:isDefaultPicInfo(arg1_56) then
		return 2
	elseif arg0_56:isMangaPic(arg1_56) then
		return 1
	end

	return 0
end

function var0_0.isPicInfoSelected(arg0_57, arg1_57)
	local var0_57

	if arg0_57.isEditMode then
		var0_57 = arg0_57.curEditPicInfoList
	else
		var0_57 = arg0_57.curUsedPicInfoList
	end

	for iter0_57, iter1_57 in ipairs(var0_57) do
		if iter1_57.id == arg1_57.id and iter1_57.type == arg1_57.type then
			return true
		end
	end

	return false
end

function var0_0.sortPicInfoList(arg0_58, arg1_58)
	table.sort(arg1_58, function(arg0_59, arg1_59)
		local var0_59 = arg0_58:isNewPicInfo(arg0_59)
		local var1_59 = arg0_58:isNewPicInfo(arg1_59)

		if var0_59 ~= var1_59 then
			return var0_59
		end

		local var2_59 = arg0_58:getPicInfoTypeSortWeight(arg0_59)
		local var3_59 = arg0_58:getPicInfoTypeSortWeight(arg1_59)

		if var0_59 and var1_59 then
			if var2_59 ~= var3_59 then
				return var3_59 < var2_59
			end

			return arg0_59.id > arg1_59.id
		end

		local var4_59 = arg0_58:isPicInfoUsed(arg0_59)

		if var4_59 ~= arg0_58:isPicInfoUsed(arg1_59) then
			return var4_59
		end

		if var2_59 ~= var3_59 then
			return var3_59 < var2_59
		end

		return arg0_59.id > arg1_59.id
	end)

	return arg1_58
end

function var0_0.getCurPicInfoListForShow(arg0_60)
	local var0_60 = {}

	if arg0_60.curFilterMode == var0_0.FilterMode.All then
		var0_60 = Clone(arg0_60.picInfoList)
	elseif arg0_60.curFilterMode == var0_0.FilterMode.Selected then
		for iter0_60, iter1_60 in ipairs(arg0_60.picInfoList) do
			if arg0_60:isPicInfoSelected(iter1_60) then
				table.insert(var0_60, iter1_60)
			end
		end
	elseif arg0_60.curFilterMode == var0_0.FilterMode.Gallery then
		for iter2_60, iter3_60 in ipairs(arg0_60.picInfoList) do
			if arg0_60:isGalleryPic(iter3_60) and not arg0_60:isDefaultPicInfo(iter3_60) then
				table.insert(var0_60, iter3_60)
			end
		end
	elseif arg0_60.curFilterMode == var0_0.FilterMode.Manga then
		for iter4_60, iter5_60 in ipairs(arg0_60.picInfoList) do
			if arg0_60:isMangaPic(iter5_60) then
				table.insert(var0_60, iter5_60)
			end
		end
	elseif arg0_60.curFilterMode == var0_0.FilterMode.Default then
		var0_60 = arg0_60:getDefaultPicInfoList()
	end

	local var1_60 = arg0_60:sortPicInfoList(var0_60)

	arg0_60.curPicInfoListForShow = var1_60

	return var1_60
end

function var0_0.getDefaultPicInfoList(arg0_61)
	local var0_61 = AppreciatePicConst.getDefaultGalleryPicIDList()
	local var1_61 = {}

	for iter0_61, iter1_61 in ipairs(var0_61) do
		local var2_61 = GalleryConst.GetGalleryPicPathByID(iter1_61)

		if checkABExist(var2_61) then
			local var3_61 = AppreciatePicConst.createPicInfo(AppreciatePicConst.TYPE_GALLERY, iter1_61)

			table.insert(var1_61, var3_61)
		end
	end

	return var1_61
end

function var0_0.getCurPicInfoForShowByIndex(arg0_62, arg1_62)
	return arg0_62.curPicInfoListForShow[arg1_62]
end

function var0_0.getPicInfoIndexInShowList(arg0_63, arg1_63)
	local var0_63 = 0

	for iter0_63, iter1_63 in ipairs(arg0_63.curPicInfoListForShow) do
		if iter1_63.id == arg1_63.id and iter1_63.type == arg1_63.type then
			return iter0_63
		end
	end

	return 0
end

function var0_0.removePicInfoFromEditList(arg0_64, arg1_64)
	local var0_64 = 0

	for iter0_64, iter1_64 in ipairs(arg0_64.curEditPicInfoList) do
		if iter1_64.id == arg1_64.id and iter1_64.type == arg1_64.type then
			table.remove(arg0_64.curEditPicInfoList, iter0_64)

			break
		end
	end

	arg0_64.isEditChanged = true
end

function var0_0.addPicInfoToEditList(arg0_65, arg1_65)
	if #arg0_65.curEditPicInfoList >= AppreciatePicConst.MAX_COUNT then
		pg.TipsMgr.GetInstance():ShowTips(i18n("loading_pic_max"))

		return
	end

	table.insert(arg0_65.curEditPicInfoList, arg1_65)

	arg0_65.isEditChanged = true
end

return var0_0
