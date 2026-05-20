local var0_0 = class("GalleryView", import("..base.BaseSubView"))

var0_0.GalleryPicGroupName = "GALLERY_PIC"

function var0_0.getUIName(arg0_1)
	return "GalleryUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initCardListPanel()
	arg0_2:initPicPanel()
	arg0_2:Show()
	arg0_2:recoveryFromRunData()
	arg0_2:tryShowTipMsgBox()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.resLoader:Clear()

	if arg0_3.appreciateUnlockMsgBox and arg0_3.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0_3.appreciateUnlockMsgBox:hideCustomMsgBox()
	end

	if isActive(arg0_3.picPanel) then
		arg0_3:closePicPanel(true)
	end

	arg0_3:stopUpdateEmptyCard()
	arg0_3:stopUpdateDownBtnPanel()
end

function var0_0.onBackPressed(arg0_4)
	if arg0_4.appreciateUnlockMsgBox and arg0_4.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.appreciateUnlockMsgBox:hideCustomMsgBox()

		return false
	elseif isActive(arg0_4.picPanel) then
		arg0_4:closePicPanel()

		return false
	else
		return true
	end
end

function var0_0.initData(arg0_5)
	arg0_5.appreciateProxy = getProxy(AppreciateProxy)

	arg0_5.appreciateProxy:checkPicFileState()

	arg0_5.resLoader = AutoLoader.New()
	arg0_5.manager = BundleWizard.Inst:GetGroupMgr("GALLERY_PIC")
	arg0_5.picForShowConfigList = {}
	arg0_5.cardTFList = {}
	arg0_5.curPicLikeValue = GalleryConst.Filte_Normal_Value
	arg0_5.curPicSelectDateValue = GalleryConst.Data_All_Value
	arg0_5.curPicSortValue = GalleryConst.Sort_Order_Up
	arg0_5.curMiddleDataIndex = 1
	arg0_5.curFilteLoadingBGValue = GalleryConst.Loading_BG_NO_Filte
	arg0_5.downloadCheckIDList = {}
	arg0_5.downloadCheckTimer = nil
	arg0_5.picLikeToggleTag = false
end

function var0_0.findUI(arg0_6)
	setLocalPosition(arg0_6._tf, Vector2.zero)

	arg0_6._tf.anchorMin = Vector2.zero
	arg0_6._tf.anchorMax = Vector2.one
	arg0_6._tf.offsetMax = Vector2.zero
	arg0_6._tf.offsetMin = Vector2.zero
	arg0_6.topPanel = arg0_6._tf:Find("TopPanel")
	arg0_6.scrollBar = arg0_6._tf:Find("Scrollbar")
	arg0_6.timeFilterToggle = arg0_6.topPanel:Find("List/TimeFilterBtn")
	arg0_6.timeTextSelected = arg0_6.timeFilterToggle:Find("TextSelected")
	arg0_6.timeItemContainer = arg0_6.timeFilterToggle:Find("Panel")
	arg0_6.timeItemTpl = arg0_6.timeItemContainer:Find("Item")

	setActive(arg0_6.timeFilterToggle, #GalleryConst.DateIndex >= 2)

	arg0_6.setFilteToggle = arg0_6.topPanel:Find("List/SetFilterBtn")

	setActive(arg0_6.setFilteToggle, false)

	arg0_6.setOpenToggle = arg0_6._tf:Find("SetToggle")

	setActive(arg0_6.setOpenToggle, false)

	arg0_6.likeFilterToggle = arg0_6.topPanel:Find("List/LikeFilterBtn")
	arg0_6.likeNumText = arg0_6.likeFilterToggle:Find("TextNum")

	setActive(arg0_6.likeFilterToggle, true)
	setActive(arg0_6.likeNumText, false)

	arg0_6.orderToggle = arg0_6.topPanel:Find("List/OrderBtn")
	arg0_6.resRepaireBtn = arg0_6.topPanel:Find("List/RepaireBtn")
	arg0_6.progressText = arg0_6.topPanel:Find("TextProgress")
	arg0_6.scrollPanel = arg0_6._tf:Find("Scroll")
	arg0_6.lScrollPageSC = GetComponent(arg0_6.scrollPanel, "LScrollPage")
	arg0_6.scrollListContainer = arg0_6.scrollPanel:Find("Content")
	arg0_6.picPanel = arg0_6._tf:Find("PicPanel")
	arg0_6.picPanelBG = arg0_6.picPanel:Find("PanelBG")
	arg0_6.picTopContainer = arg0_6.picPanel:Find("Container")
	arg0_6.picContainer = arg0_6.picPanel:Find("Container/Picture")
	arg0_6.picBGImg = arg0_6.picPanel:Find("Container/Picture/PicBG")
	arg0_6.picImg = arg0_6.picPanel:Find("Container/Picture/Pic")
	arg0_6.picLikeToggle = arg0_6.picContainer:Find("LikeBtn")
	arg0_6.picName = arg0_6.picContainer:Find("PicName")
	arg0_6.picPreBtn = arg0_6.picPanel:Find("PreBtn")
	arg0_6.picNextBtn = arg0_6.picPanel:Find("NextBtn")

	setActive(arg0_6.picLikeToggle, true)

	arg0_6.picAddLoadingBtn = arg0_6.picContainer:Find("LoadingBtn/Off")
	arg0_6.picRemoveLoadingBtn = arg0_6.picContainer:Find("LoadingBtn/On")
	arg0_6.emptyPanel = arg0_6._tf:Find("EmptyPanel")
	arg0_6.updatePanel = arg0_6._tf:Find("UpdatePanel")
end

function var0_0.addListener(arg0_7)
	onToggle(arg0_7, arg0_7.orderToggle, function(arg0_8)
		arg0_7.curMiddleDataIndex = 1

		if arg0_8 == true then
			arg0_7.curPicSortValue = GalleryConst.Sort_Order_Down
		else
			arg0_7.curPicSortValue = GalleryConst.Sort_Order_Up
		end

		arg0_7:saveRunData()
		arg0_7:filtePic()
		arg0_7:updateCardListPanel()
	end, SFX_PANEL)
	onToggle(arg0_7, arg0_7.likeFilterToggle, function(arg0_9)
		arg0_7.curMiddleDataIndex = 1

		if arg0_9 == true then
			arg0_7.curPicLikeValue = GalleryConst.Filte_Like_Value
		else
			arg0_7.curPicLikeValue = GalleryConst.Filte_Normal_Value
		end

		arg0_7:saveRunData()
		arg0_7:filtePic()
		arg0_7:updateCardListPanel()
	end)
	onButton(arg0_7, arg0_7.resRepaireBtn, function()
		local var0_10 = {
			text = i18n("msgbox_repair"),
			onCallback = function()
				if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-pic.csv") then
					BundleWizard.Inst:GetGroupMgr("GALLERY_PIC"):StartVerifyForLua()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
				end
			end
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				var0_10
			}
		})
	end, SFX_PANEL)
end

function var0_0.initTimeSelectPanel(arg0_12)
	arg0_12.timeSelectUIItemList = UIItemList.New(arg0_12.timeItemContainer, arg0_12.timeItemTpl)

	arg0_12.timeSelectUIItemList:make(function(arg0_13, arg1_13, arg2_13)
		if arg0_13 == UIItemList.EventUpdate then
			local var0_13 = GalleryConst.DateIndex[arg1_13 + 1]
			local var1_13 = GalleryConst.DateIndexName[arg1_13 + 1]
			local var2_13 = arg2_13:Find("Text")

			setText(var2_13, var1_13)
			onButton(arg0_12, arg2_13, function()
				if var0_13 ~= arg0_12.curPicSelectDateValue then
					arg0_12.curPicSelectDateValue = var0_13
					arg0_12.curMiddleDataIndex = 1

					arg0_12:saveRunData()
					setText(arg0_12.timeTextSelected, var1_13)
					arg0_12:filtePic()
					arg0_12:updateCardListPanel()
				end

				triggerToggle(arg0_12.timeFilterToggle, false)
			end, SFX_PANEL)
		end
	end)
	arg0_12.timeSelectUIItemList:align(#GalleryConst.DateIndex)
end

function var0_0.initCardListPanel(arg0_15)
	function arg0_15.lScrollPageSC.itemInitedCallback(arg0_16, arg1_16)
		local var0_16 = arg0_16 + 1

		arg0_15.cardTFList[var0_16] = arg1_16

		local var1_16 = arg0_16 + 1

		if arg0_15:getPicConfigForShowByIndex(var1_16) == false then
			arg0_15:initEmptyCard(arg1_16)
		else
			arg0_15:cardUpdate(arg0_16, arg1_16)
		end
	end

	function arg0_15.lScrollPageSC.itemClickCallback(arg0_17, arg1_17)
		local var0_17 = arg0_17 + 1
		local var1_17 = arg0_15:getPicConfigForShowByIndex(var0_17)

		if var1_17 then
			local var2_17 = var1_17.id
			local var3_17
			local var4_17
			local var5_17 = arg0_15:isPicExist(var2_17)

			if arg0_15:getPicStateByID(var2_17) == GalleryConst.CardStates.Unlocked and var5_17 then
				arg0_15:updatePicImg(var0_17)
				arg0_15:openPicPanel()
			end
		end
	end

	function arg0_15.lScrollPageSC.itemPitchCallback(arg0_18, arg1_18)
		arg0_15:setMovingTag(false)

		local var0_18 = arg0_18 + 1

		if arg0_15.curMiddleDataIndex ~= var0_18 then
			arg0_15.curMiddleDataIndex = var0_18

			arg0_15:saveRunData()

			if isActive(arg0_15.picPanel) then
				arg0_15:switchPicImg(arg0_15.curMiddleDataIndex)
			end
		end
	end

	function arg0_15.lScrollPageSC.itemRecycleCallback(arg0_19, arg1_19)
		local var0_19 = arg0_19 + 1

		arg0_15.cardTFList[var0_19] = nil

		local var1_19 = arg0_19 + 1

		if arg0_15:getPicConfigForShowByIndex(var1_19) == false then
			arg0_15:stopUpdateEmptyCard(arg1_19)
		end
	end

	function arg0_15.lScrollPageSC.itemMoveCallback(arg0_20)
		if #arg0_15.picForShowConfigList == 1 then
			setText(arg0_15.progressText, "1/1")
		else
			setText(arg0_15.progressText, math.clamp(math.round(arg0_20 * (#arg0_15.picForShowConfigList - 1)) + 1, 1, #arg0_15.picForShowConfigList) .. "/" .. #arg0_15.picForShowConfigList)
		end
	end
end

function var0_0.updateCardListPanel(arg0_21)
	arg0_21.cardTFList = {}

	arg0_21.resLoader:Clear()

	local var0_21 = #arg0_21.picForShowConfigList <= 0
	local var1_21 = #arg0_21.picForShowConfigList == 1 and arg0_21.picForShowConfigList[1] == false

	setActive(arg0_21.emptyPanel, var0_21)
	setActive(arg0_21.updatePanel, var1_21)
	setActive(arg0_21.scrollPanel, not var0_21 and not var1_21)
	arg0_21:stopUpdateDownBtnPanel()

	if not var0_21 and not var1_21 then
		setActive(arg0_21.scrollBar, true)
		setActive(arg0_21.progressText, true)

		arg0_21.lScrollPageSC.DataCount = #arg0_21.picForShowConfigList

		arg0_21.lScrollPageSC:Init(arg0_21.curMiddleDataIndex - 1)
	elseif var1_21 then
		setActive(arg0_21.scrollBar, false)
		setActive(arg0_21.progressText, false)
		arg0_21:initDownBtnPanel()
	end
end

function var0_0.initDownBtnPanel(arg0_22)
	local var0_22 = arg0_22.updatePanel:Find("Btn")
	local var1_22 = var0_22:Find("Text")
	local var2_22 = arg0_22.updatePanel:Find("Progress")
	local var3_22 = var2_22:Find("Slider")

	setActive(var0_22, true)
	setActive(var2_22, false)
	onButton(arg0_22, var0_22, function()
		warning("click download btn,state:", tostring(arg0_22.manager.state))

		local var0_23 = arg0_22.manager.state

		if var0_23 == DownloadState.None or var0_23 == DownloadState.CheckFailure then
			arg0_22.manager:CheckD()
		elseif var0_23 == DownloadState.CheckToUpdate or var0_23 == DownloadState.UpdateFailure then
			local var1_23 = GroupHelper.GetGroupSize(var0_0.GalleryPicGroupName)
			local var2_23 = HashUtil.BytesToString(var1_23)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2_23)),
				onYes = function()
					arg0_22.manager:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0_22:startUpdateDownBtnPanel()
end

function var0_0.updateDownBtnPanel(arg0_25)
	local var0_25 = arg0_25.updatePanel:Find("Btn")
	local var1_25 = var0_25:Find("Text")
	local var2_25 = arg0_25.updatePanel:Find("Progress")
	local var3_25 = var2_25:Find("Slider")
	local var4_25 = arg0_25.manager.state

	if var4_25 == DownloadState.None then
		setText(var1_25, "None")
		setActive(var0_25, true)
		setActive(var2_25, false)
	elseif var4_25 == DownloadState.Checking then
		setText(var1_25, i18n("word_manga_checking"))
		setActive(var0_25, true)
		setActive(var2_25, false)
	elseif var4_25 == DownloadState.CheckToUpdate then
		setText(var1_25, i18n("word_manga_checktoupdate"))
		setActive(var0_25, true)
		setActive(var2_25, false)
	elseif var4_25 == DownloadState.CheckOver then
		setText(var1_25, "Latest Ver")
		setActive(var0_25, true)
		setActive(var2_25, false)
	elseif var4_25 == DownloadState.CheckFailure then
		setText(var1_25, i18n("word_manga_checkfailure"))
		setActive(var0_25, true)
		setActive(var2_25, false)
	elseif var4_25 == DownloadState.Updating then
		setText(var1_25, i18n("word_manga_updating", arg0_25.manager.downloadCount, arg0_25.manager.downloadTotal))
		setActive(var0_25, false)
		setActive(var2_25, true)
		setSlider(var3_25, 0, arg0_25.manager.downloadTotal, arg0_25.manager.downloadCount)
	elseif var4_25 == DownloadState.UpdateSuccess then
		setText(var1_25, i18n("word_manga_updatesuccess"))
		setActive(var0_25, true)
		setActive(var2_25, false)
		arg0_25:filtePic()
		arg0_25:updateCardListPanel()
	elseif var4_25 == DownloadState.UpdateFailure then
		setText(var1_25, i18n("word_manga_updatefailure"))
		setActive(var0_25, true)
		setActive(var2_25, false)
	end
end

function var0_0.startUpdateDownBtnPanel(arg0_26)
	if arg0_26.downloadCheckTimer then
		arg0_26.downloadCheckTimer:Stop()
	end

	arg0_26.downloadCheckTimer = Timer.New(function()
		arg0_26:updateDownBtnPanel()
	end, 0.5, -1)

	arg0_26.downloadCheckTimer:Start()
	arg0_26:updateDownBtnPanel()
end

function var0_0.stopUpdateDownBtnPanel(arg0_28)
	if arg0_28.downloadCheckTimer then
		arg0_28.downloadCheckTimer:Stop()
	end
end

function var0_0.initPicPanel(arg0_29)
	onButton(arg0_29, arg0_29.picPanelBG, function()
		arg0_29:closePicPanel()
	end, SFX_CANCEL)
	addSlip(SLIP_TYPE_HRZ, arg0_29.picImg, function()
		triggerButton(arg0_29.picPreBtn)
	end, function()
		triggerButton(arg0_29.picNextBtn)
	end, function()
		local var0_33 = arg0_29.curMiddleDataIndex
		local var1_33 = arg0_29:getPicConfigForShowByIndex(var0_33).id

		arg0_29:emit(GalleryConst.OPEN_FULL_SCREEN_PIC_VIEW, var1_33)
	end)
	onButton(arg0_29, arg0_29.picPreBtn, function()
		if arg0_29.isMoving == true then
			return
		end

		local var0_34 = arg0_29.curMiddleDataIndex
		local var1_34

		while var0_34 > 1 do
			var0_34 = var0_34 - 1

			local var2_34 = arg0_29:getPicConfigForShowByIndex(var0_34).id
			local var3_34 = arg0_29:isPicExist(var2_34)
			local var4_34 = arg0_29:getPicStateByID(var2_34)

			if var3_34 and var4_34 == GalleryConst.CardStates.Unlocked then
				var1_34 = var0_34

				break
			end
		end

		if var1_34 and var1_34 > 0 then
			arg0_29:setMovingTag(true)
			arg0_29.lScrollPageSC:MoveToItemID(var1_34 - 1)
		end
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.picNextBtn, function()
		if arg0_29.isMoving == true then
			return
		end

		local var0_35 = arg0_29.curMiddleDataIndex
		local var1_35

		while var0_35 < #arg0_29.picForShowConfigList do
			var0_35 = var0_35 + 1

			local var2_35 = arg0_29:getPicConfigForShowByIndex(var0_35).id
			local var3_35 = arg0_29:isPicExist(var2_35)
			local var4_35 = arg0_29:getPicStateByID(var2_35)

			if var3_35 and var4_35 == GalleryConst.CardStates.Unlocked then
				var1_35 = var0_35

				break
			end
		end

		if var1_35 and var1_35 <= #arg0_29.picForShowConfigList then
			arg0_29:setMovingTag(true)
			arg0_29.lScrollPageSC:MoveToItemID(var1_35 - 1)
		end
	end, SFX_PANEL)
	onToggle(arg0_29, arg0_29.picLikeToggle, function(arg0_36)
		if arg0_29.picLikeToggleTag == true then
			arg0_29.picLikeToggleTag = false

			return
		end

		local var0_36 = arg0_29:getPicConfigForShowByIndex(arg0_29.curMiddleDataIndex).id
		local var1_36 = arg0_36 == true and 0 or 1

		if var1_36 == 0 then
			if arg0_29.appreciateProxy:isLikedByPicID(var0_36) then
				return
			else
				pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, {
					isAdd = 0,
					picID = var0_36
				})
			end
		elseif var1_36 == 1 then
			if arg0_29.appreciateProxy:isLikedByPicID(var0_36) then
				pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, {
					isAdd = 1,
					picID = var0_36
				})
			else
				return
			end
		end
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.picAddLoadingBtn, function()
		local var0_37 = arg0_29:getPicConfigForShowByIndex(arg0_29.curMiddleDataIndex).id

		arg0_29:addLoadingPic(var0_37)
	end, SFX_PANEL)
	onButton(arg0_29, arg0_29.picRemoveLoadingBtn, function()
		local var0_38 = arg0_29:getPicConfigForShowByIndex(arg0_29.curMiddleDataIndex).id

		arg0_29:removeLoadingPic(var0_38)
	end, SFX_PANEL)
end

function var0_0.updateLoadingBtn(arg0_39, arg1_39)
	local var0_39 = arg0_39:isPicUsed(arg1_39)

	setActive(arg0_39.picAddLoadingBtn, not var0_39)
	setActive(arg0_39.picRemoveLoadingBtn, var0_39)
end

function var0_0.updatePicImg(arg0_40, arg1_40)
	local var0_40 = arg1_40 or arg0_40.curMiddleDataIndex
	local var1_40 = arg0_40:getPicConfigForShowByIndex(var0_40)
	local var2_40 = var1_40.id
	local var3_40 = var1_40.name
	local var4_40 = var1_40.illustration
	local var5_40 = GalleryConst.PIC_PATH_PREFIX .. var4_40

	setImageSprite(arg0_40.picImg, LoadSprite(var5_40, var4_40))
	setText(arg0_40.picName, var3_40)
	arg0_40:updateLoadingBtn(var2_40)

	local var6_40 = arg0_40.appreciateProxy:isLikedByPicID(var2_40)

	arg0_40.picLikeToggleTag = true

	triggerToggle(arg0_40.picLikeToggle, var6_40)
end

function var0_0.switchPicImg(arg0_41, arg1_41)
	local var0_41 = arg1_41 or arg0_41.curMiddleDataIndex
	local var1_41 = arg0_41:getPicConfigForShowByIndex(var0_41)
	local var2_41 = var1_41.id
	local var3_41 = var1_41.name
	local var4_41 = var1_41.illustration
	local var5_41 = GalleryConst.PIC_PATH_PREFIX .. var4_41

	setImageSprite(arg0_41.picBGImg, LoadSprite(var5_41, var4_41))

	local var6_41 = arg0_41.appreciateProxy:isLikedByPicID(var2_41)

	arg0_41.picLikeToggleTag = true

	triggerToggle(arg0_41.picLikeToggle, var6_41)
	arg0_41:updateLoadingBtn(var2_41)
	LeanTween.value(go(arg0_41.picImg), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_42)
		setImageAlpha(arg0_41.picImg, arg0_42)
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0_41.picImg, arg0_41.picBGImg)
		setImageAlpha(arg0_41.picImg, 1)
	end))
end

function var0_0.openPicPanel(arg0_44)
	arg0_44:BlurPanel(arg0_44.picPanel)

	arg0_44.picPanel.offsetMax = arg0_44._tf.parent.offsetMax
	arg0_44.picPanel.offsetMin = arg0_44._tf.parent.offsetMin

	setActive(arg0_44.picPanel, true)
	LeanTween.value(go(arg0_44.picTopContainer), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_45)
		setLocalScale(arg0_44.picTopContainer, {
			x = arg0_45,
			y = arg0_45
		})
	end)):setOnComplete(System.Action(function()
		setLocalScale(arg0_44.picTopContainer, {
			x = 1,
			y = 1
		})
	end))
end

function var0_0.closePicPanel(arg0_47, arg1_47)
	if arg1_47 == true then
		arg0_47:UnOverlayPanel(arg0_47.picPanel, arg0_47._tf)
		setActive(arg0_47.picPanel, false)

		return
	end

	if isActive(arg0_47.picPanel) then
		LeanTween.value(go(arg0_47.picTopContainer), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_48)
			setLocalScale(arg0_47.picTopContainer, {
				x = arg0_48,
				y = arg0_48
			})
		end)):setOnComplete(System.Action(function()
			setLocalScale(arg0_47.picTopContainer, {
				x = 0,
				y = 0
			})
			arg0_47:UnOverlayPanel(arg0_47.picPanel, arg0_47._tf)
			setActive(arg0_47.picPanel, false)
		end))
	end
end

function var0_0.setMovingTag(arg0_50, arg1_50)
	arg0_50.isMoving = arg1_50
end

function var0_0.saveRunData(arg0_51)
	arg0_51.appreciateProxy:updateGalleryRunData(arg0_51.curPicSelectDateValue, arg0_51.curPicSortValue, arg0_51.curMiddleDataIndex, arg0_51.curPicLikeValue, arg0_51.curFilteLoadingBGValue)
end

function var0_0.recoveryFromRunData(arg0_52)
	local var0_52 = arg0_52.appreciateProxy:getGalleryRunData()

	arg0_52.curPicSelectDateValue = var0_52.dateValue
	arg0_52.curPicSortValue = var0_52.sortValue
	arg0_52.curMiddleDataIndex = var0_52.middleIndex
	arg0_52.curPicLikeValue = var0_52.likeValue
	arg0_52.curFilteLoadingBGValue = var0_52.bgFilteValue

	setText(arg0_52.progressText, arg0_52.curMiddleDataIndex .. "/" .. #arg0_52.picForShowConfigList)

	local var1_52 = table.indexof(GalleryConst.DateIndex, arg0_52.curPicSelectDateValue, 1)
	local var2_52 = GalleryConst.DateIndexName[var1_52]

	setText(arg0_52.timeTextSelected, var2_52)

	local var3_52 = arg0_52.curMiddleDataIndex - 1

	triggerToggle(arg0_52.likeFilterToggle, arg0_52.curPicLikeValue == GalleryConst.Filte_Like_Value)
	triggerToggle(arg0_52.orderToggle, arg0_52.curPicSortValue == GalleryConst.Sort_Order_Down)
	arg0_52.lScrollPageSC:MoveToItemID(var3_52)
end

function var0_0.tryShowTipMsgBox(arg0_53)
	if arg0_53.appreciateProxy:isGalleryHaveNewRes() then
		local function var0_53()
			PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
			arg0_53:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_pic_new_tip", GalleryConst.NewCount),
			onYes = var0_53,
			onCancel = var0_53,
			onClose = var0_53
		})
	end
end

function var0_0.cardUpdate(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg2_55:Find("CardImg")
	local var1_55 = arg2_55:Find("CardNum/Text")
	local var2_55 = arg2_55:Find("SelectBtn")

	setActive(var2_55, false)

	local var3_55 = arg2_55:Find("UsedTag")
	local var4_55 = arg2_55:Find("BlackMask")
	local var5_55 = var4_55:Find("Update")
	local var6_55 = var4_55:Find("DownloadBtn")
	local var7_55 = var4_55:Find("LockImg")
	local var8_55 = var4_55:Find("TextUnlockTip")
	local var9_55 = var4_55:Find("UnLockBtn")

	setActive(var5_55, false)

	local var10_55 = arg1_55 + 1
	local var11_55 = arg0_55:getPicConfigForShowByIndex(var10_55)
	local var12_55 = var11_55.illustration .. "_t"
	local var13_55 = GalleryConst.CARD_PATH_PREFIX .. var12_55

	arg0_55.resLoader:LoadSprite(var13_55, var12_55, var0_55, false)
	setText(var1_55, "#" .. var10_55)

	local var14_55 = var11_55.id
	local var15_55
	local var16_55
	local var17_55 = arg0_55:isPicExist(var14_55)
	local var18_55 = arg0_55:getPicStateByID(var14_55)

	if var18_55 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var17_55 then
			setActive(var4_55, false)
		else
			setActive(var4_55, true)
			setActive(var6_55, true)
			setActive(var7_55, false)
			setActive(var8_55, false)
			setActive(var9_55, false)
		end
	elseif var18_55 == GalleryConst.CardStates.Unlocked then
		if var17_55 then
			local var19_55 = getProxy(LoadingPicProxy):getDiyModeOpenFlag()
			local var20_55 = table.contains(getProxy(LoadingPicProxy):getGalleryPicIDList(), var14_55)

			setActive(var3_55, var19_55 and var20_55)
			setActive(var4_55, false)
		end
	elseif var18_55 == GalleryConst.CardStates.Unlockable then
		setActive(var2_55, false)
		setActive(var4_55, true)
		setActive(var6_55, false)
		setActive(var7_55, true)
		setActive(var8_55, false)
		setActive(var9_55, true)
		onButton(arg0_55, var9_55, function()
			if not arg0_55.appreciateUnlockMsgBox then
				arg0_55.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0_55._tf, arg0_55.event, arg0_55.contextData)
			end

			arg0_55.appreciateUnlockMsgBox:Reset()
			arg0_55.appreciateUnlockMsgBox:Load()
			arg0_55.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = arg0_55.appreciateProxy:getPicUnlockMaterialByID(var14_55),
				onYes = function()
					pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_UNLOCK, {
						picID = var14_55,
						unlockCBFunc = function()
							arg0_55:cardUpdate(arg1_55, arg2_55)
							arg0_55.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif var18_55 == GalleryConst.CardStates.DisUnlockable then
		setActive(var2_55, false)
		setActive(var4_55, true)
		setActive(var6_55, false)
		setActive(var7_55, true)
		setActive(var8_55, true)
		setActive(var9_55, false)
		setText(var8_55, var11_55.illustrate)
	end
end

function var0_0.updateCurCardLoadingBtn(arg0_59, arg1_59)
	local var0_59 = arg1_59 and tostring(arg1_59 - 1) or tostring(arg0_59.curMiddleDataIndex - 1)
	local var1_59 = arg0_59.scrollListContainer:Find(var0_59):Find("UsedTag")
	local var2_59 = arg0_59:getPicConfigForShowByIndex(arg1_59 or arg0_59.curMiddleDataIndex).id

	setActive(var1_59, arg0_59:isPicUsed(var2_59))
end

function var0_0.initEmptyCard(arg0_60, arg1_60)
	local var0_60 = arg1_60:Find("CardImg")
	local var1_60 = arg1_60:Find("CardNum")
	local var2_60 = arg1_60:Find("SelectBtn")
	local var3_60 = arg1_60:Find("UsedTag")

	setActive(var0_60, true)
	setActive(var1_60, false)
	setActive(var2_60, false)
	setActive(var3_60, false)

	local var4_60
	local var5_60

	for iter0_60, iter1_60 in ipairs(pg.gallery_config.all) do
		local var6_60 = pg.gallery_config[iter1_60].illustration .. "_t"
		local var7_60 = GalleryConst.CARD_PATH_PREFIX .. var6_60

		if checkABExist(var7_60) then
			var4_60 = var7_60
			var5_60 = var6_60

			break
		end
	end

	arg0_60.resLoader:LoadSprite(var4_60, var5_60, var0_60, false)

	local var8_60 = arg1_60:Find("BlackMask")
	local var9_60 = var8_60:Find("LockImg")
	local var10_60 = var8_60:Find("TextUnlockTip")
	local var11_60 = var8_60:Find("UnLockBtn")

	setActive(var8_60, true)
	setActive(var9_60, false)
	setActive(var10_60, false)
	setActive(var11_60, false)

	local var12_60 = var8_60:Find("Update")
	local var13_60 = var12_60:Find("Btn")
	local var14_60 = var12_60:Find("Progress")
	local var15_60 = var14_60:Find("Slider")

	setActive(var12_60, true)
	setActive(var13_60, true)
	setActive(var14_60, false)
	onButton(arg0_60, var13_60, function()
		warning("click download btn,state:", tostring(arg0_60.manager.state))

		local var0_61 = arg0_60.manager.state

		if var0_61 == DownloadState.None or var0_61 == DownloadState.CheckFailure then
			arg0_60.manager:CheckD()
		elseif var0_61 == DownloadState.CheckToUpdate or var0_61 == DownloadState.UpdateFailure then
			local var1_61 = GroupHelper.GetGroupSize(var0_0.GalleryPicGroupName)
			local var2_61 = HashUtil.BytesToString(var1_61)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2_61)),
				onYes = function()
					arg0_60.manager:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0_60:startUpdateEmptyCard(arg1_60)
end

function var0_0.updateEmptyCard(arg0_63, arg1_63)
	local var0_63 = arg1_63:Find("BlackMask"):Find("Update")
	local var1_63 = var0_63:Find("Btn")
	local var2_63 = var1_63:Find("Text")
	local var3_63 = var0_63:Find("Progress")
	local var4_63 = var3_63:Find("Slider")
	local var5_63 = arg0_63.manager.state

	if var5_63 == DownloadState.None then
		setText(var2_63, "None")
		setActive(var1_63, true)
		setActive(var3_63, false)
	elseif var5_63 == DownloadState.Checking then
		setText(var2_63, i18n("word_manga_checking"))
		setActive(var1_63, true)
		setActive(var3_63, false)
	elseif var5_63 == DownloadState.CheckToUpdate then
		setText(var2_63, i18n("word_manga_checktoupdate"))
		setActive(var1_63, true)
		setActive(var3_63, false)
	elseif var5_63 == DownloadState.CheckOver then
		setText(var2_63, "Latest Ver")
		setActive(var1_63, true)
		setActive(var3_63, false)
	elseif var5_63 == DownloadState.CheckFailure then
		setText(var2_63, i18n("word_manga_checkfailure"))
		setActive(var1_63, true)
		setActive(var3_63, false)
	elseif var5_63 == DownloadState.Updating then
		setText(var2_63, i18n("word_manga_updating", arg0_63.manager.downloadCount, arg0_63.manager.downloadTotal))
		setActive(var1_63, false)
		setActive(var3_63, true)
		setSlider(var4_63, 0, arg0_63.manager.downloadTotal, arg0_63.manager.downloadCount)
	elseif var5_63 == DownloadState.UpdateSuccess then
		setText(var2_63, i18n("word_manga_updatesuccess"))
		setActive(var1_63, true)
		setActive(var3_63, false)
		arg0_63:filtePic()
		arg0_63:updateCardListPanel()
	elseif var5_63 == DownloadState.UpdateFailure then
		setText(var2_63, i18n("word_manga_updatefailure"))
		setActive(var1_63, true)
		setActive(var3_63, false)
	end
end

function var0_0.startUpdateEmptyCard(arg0_64, arg1_64)
	if arg0_64.downloadCheckTimer then
		arg0_64.downloadCheckTimer:Stop()
	end

	arg0_64.downloadCheckTimer = Timer.New(function()
		arg0_64:updateEmptyCard(arg1_64)
	end, 0.5, -1)

	arg0_64.downloadCheckTimer:Start()
	arg0_64:updateEmptyCard(arg1_64)
end

function var0_0.stopUpdateEmptyCard(arg0_66, arg1_66)
	if arg0_66.downloadCheckTimer then
		arg0_66.downloadCheckTimer:Stop()
	end
end

function var0_0.getPicConfigForShowByIndex(arg0_67, arg1_67)
	local var0_67 = arg0_67.picForShowConfigList[arg1_67]

	if var0_67 then
		return var0_67
	elseif var0_67 == false then
		return false
	else
		assert(false, "不存在的Index:" .. tostring(arg1_67))
	end
end

function var0_0.sortPicConfigListForShow(arg0_68)
	local function var0_68(arg0_69, arg1_69)
		if arg0_68.curPicSortValue == GalleryConst.Sort_Order_Up then
			if arg0_69.id < arg1_69.id then
				return true
			else
				return false
			end
		elseif arg0_68.curPicSortValue == GalleryConst.Sort_Order_Down then
			if arg0_69.id < arg1_69.id then
				return false
			else
				return true
			end
		end
	end

	table.sort(arg0_68.picForShowConfigList, var0_68)
end

function var0_0.isPicExist(arg0_70, arg1_70)
	local var0_70 = pg.gallery_config[arg1_70].illustration
	local var1_70 = GalleryConst.PIC_PATH_PREFIX .. var0_70
	local var2_70 = arg0_70.manager:CheckF(var1_70)
	local var3_70 = var2_70 == DownloadState.None or var2_70 == DownloadState.UpdateSuccess
	local var4_70 = var1_70 .. "_t"
	local var5_70 = arg0_70.manager:CheckF(var4_70)
	local var6_70 = var5_70 == DownloadState.None or var5_70 == DownloadState.UpdateSuccess

	return var3_70 and var6_70
end

function var0_0.getPicStateByID(arg0_71, arg1_71)
	if not arg0_71.appreciateProxy:isPicNeedUnlockByID(arg1_71) then
		return GalleryConst.CardStates.Unlocked
	elseif arg0_71.appreciateProxy:isPicUnlockedByID(arg1_71) then
		return GalleryConst.CardStates.Unlocked
	elseif arg0_71.appreciateProxy:isPicUnlockableByID(arg1_71) then
		return GalleryConst.CardStates.Unlockable
	else
		return GalleryConst.CardStates.DisUnlockable
	end
end

function var0_0.filtePicForShow(arg0_72)
	local var0_72 = {}

	for iter0_72, iter1_72 in ipairs(pg.gallery_config.all) do
		if arg0_72:isPicExist(iter1_72) then
			local var1_72 = arg0_72.appreciateProxy:getSinglePicConfigByID(iter1_72)

			if arg0_72.appreciateProxy:isPicNeedUnlockByID(iter1_72) then
				if not arg0_72.appreciateProxy:isPicUnlockedByID(iter1_72) then
					local var2_72, var3_72 = arg0_72.appreciateProxy:isPicUnlockableByID(iter1_72)

					if var2_72 then
						var0_72[#var0_72 + 1] = var1_72
					elseif var3_72 then
						var0_72[#var0_72 + 1] = var1_72
					end
				else
					var0_72[#var0_72 + 1] = var1_72
				end
			else
				var0_72[#var0_72 + 1] = var1_72
			end
		end
	end

	return var0_72
end

function var0_0.filtePicForShowByDate(arg0_73)
	local var0_73 = arg0_73.curPicSelectDateValue

	if var0_73 == GalleryConst.Data_All_Value then
		return arg0_73:filtePicForShow()
	end

	local var1_73 = {}

	for iter0_73, iter1_73 in ipairs(pg.gallery_config.all) do
		if arg0_73:isPicExist(iter1_73) then
			local var2_73 = arg0_73.appreciateProxy:getSinglePicConfigByID(iter1_73)

			if arg0_73.appreciateProxy:isPicNeedUnlockByID(iter1_73) then
				if not arg0_73.appreciateProxy:isPicUnlockedByID(iter1_73) then
					local var3_73, var4_73 = arg0_73.appreciateProxy:isPicUnlockableByID(iter1_73)

					if var3_73 then
						if var0_73 == var2_73.year then
							var1_73[#var1_73 + 1] = var2_73
						end
					elseif var4_73 and var0_73 == var2_73.year then
						var1_73[#var1_73 + 1] = var2_73
					end
				elseif var0_73 == var2_73.year then
					var1_73[#var1_73 + 1] = var2_73
				end
			elseif var0_73 == var2_73.year then
				var1_73[#var1_73 + 1] = var2_73
			end
		end
	end

	return var1_73
end

function var0_0.filtePicForShowByLike(arg0_74)
	if arg0_74.curPicLikeValue == GalleryConst.Filte_Normal_Value then
		return arg0_74.picForShowConfigList
	end

	local var0_74 = {}

	for iter0_74, iter1_74 in ipairs(arg0_74.picForShowConfigList) do
		local var1_74 = iter1_74.id

		if arg0_74.appreciateProxy:isLikedByPicID(var1_74) then
			var0_74[#var0_74 + 1] = iter1_74
		end
	end

	return var0_74
end

function var0_0.filtePicForShowByLoadingBG(arg0_75)
	if arg0_75.curFilteLoadingBGValue == GalleryConst.Loading_BG_NO_Filte then
		return arg0_75.picForShowConfigList
	end

	local var0_75 = {}

	for iter0_75, iter1_75 in ipairs(arg0_75.picForShowConfigList) do
		local var1_75 = iter1_75.id

		if GalleryConst.IsInBGIDList(var1_75) then
			var0_75[#var0_75 + 1] = iter1_75
		end
	end

	return var0_75
end

function var0_0.filtePic(arg0_76)
	arg0_76.picForShowConfigList = arg0_76:filtePicForShow()
	arg0_76.picForShowConfigList = arg0_76:filtePicForShowByLike(arg0_76.curPicLikeValue)

	arg0_76:sortPicConfigListForShow()

	if arg0_76:isNeedShowDownBtn() then
		table.insert(arg0_76.picForShowConfigList, 1, false)
	end
end

function var0_0.isNeedShowDownBtn(arg0_77)
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

function var0_0.isPicUsed(arg0_78, arg1_78)
	return table.contains(getProxy(LoadingPicProxy):getGalleryPicIDList(true), arg1_78)
end

function var0_0.removeLoadingPic(arg0_79, arg1_79)
	local var0_79 = {}
	local var1_79 = getProxy(LoadingPicProxy):getGalleryPicIDList()

	for iter0_79, iter1_79 in ipairs(var1_79) do
		if iter1_79 == arg1_79 then
			table.remove(var1_79, iter0_79)

			break
		end
	end

	var0_79.galleryPicIDList = var1_79

	function var0_79.callback()
		arg0_79:updateLoadingBtn(arg1_79)
		arg0_79:updateCurCardLoadingBtn()
	end

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_79)
end

function var0_0.addLoadingPic(arg0_81, arg1_81)
	if arg0_81:isPicUsed(arg1_81) then
		warning("already used.", arg1_81)

		return
	end

	local var0_81 = {}
	local var1_81 = getProxy(LoadingPicProxy):getGalleryPicIDList()

	table.insert(var1_81, arg1_81)

	var0_81.galleryPicIDList = var1_81

	function var0_81.callback()
		arg0_81:updateLoadingBtn(arg1_81)
		arg0_81:updateCurCardLoadingBtn()
	end

	pg.m02:sendNotification(GAME.UPDATE_LOADING_PIC, var0_81)
end

return var0_0
