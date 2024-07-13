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
	arg0_6.topPanel = arg0_6:findTF("TopPanel")
	arg0_6.scrollBar = arg0_6:findTF("Scrollbar")
	arg0_6.timeFilterToggle = arg0_6:findTF("List/TimeFilterBtn", arg0_6.topPanel)
	arg0_6.timeTextSelected = arg0_6:findTF("TextSelected", arg0_6.timeFilterToggle)
	arg0_6.timeItemContainer = arg0_6:findTF("Panel", arg0_6.timeFilterToggle)
	arg0_6.timeItemTpl = arg0_6:findTF("Item", arg0_6.timeItemContainer)

	setActive(arg0_6.timeFilterToggle, #GalleryConst.DateIndex >= 2)

	arg0_6.setFilteToggle = arg0_6:findTF("List/SetFilterBtn", arg0_6.topPanel)

	setActive(arg0_6.setFilteToggle, false)

	arg0_6.setOpenToggle = arg0_6:findTF("SetToggle")

	setActive(arg0_6.setOpenToggle, false)

	arg0_6.likeFilterToggle = arg0_6:findTF("List/LikeFilterBtn", arg0_6.topPanel)
	arg0_6.likeNumText = arg0_6:findTF("TextNum", arg0_6.likeFilterToggle)

	setActive(arg0_6.likeFilterToggle, true)
	setActive(arg0_6.likeNumText, false)

	arg0_6.orderToggle = arg0_6:findTF("List/OrderBtn", arg0_6.topPanel)
	arg0_6.resRepaireBtn = arg0_6:findTF("List/RepaireBtn", arg0_6.topPanel)
	arg0_6.progressText = arg0_6:findTF("TextProgress", arg0_6.topPanel)
	arg0_6.scrollPanel = arg0_6:findTF("Scroll")
	arg0_6.lScrollPageSC = GetComponent(arg0_6.scrollPanel, "LScrollPage")
	arg0_6.picPanel = arg0_6:findTF("PicPanel")
	arg0_6.picPanelBG = arg0_6:findTF("PanelBG", arg0_6.picPanel)
	arg0_6.picTopContainer = arg0_6:findTF("Container", arg0_6.picPanel)
	arg0_6.picContainer = arg0_6:findTF("Container/Picture", arg0_6.picPanel)
	arg0_6.picBGImg = arg0_6:findTF("Container/Picture/PicBG", arg0_6.picPanel)
	arg0_6.picImg = arg0_6:findTF("Container/Picture/Pic", arg0_6.picPanel)
	arg0_6.picLikeToggle = arg0_6:findTF("LikeBtn", arg0_6.picContainer)
	arg0_6.picName = arg0_6:findTF("PicName", arg0_6.picContainer)
	arg0_6.picPreBtn = arg0_6:findTF("PreBtn", arg0_6.picPanel)
	arg0_6.picNextBtn = arg0_6:findTF("NextBtn", arg0_6.picPanel)

	setActive(arg0_6.picLikeToggle, true)

	arg0_6.emptyPanel = arg0_6:findTF("EmptyPanel")
	arg0_6.updatePanel = arg0_6:findTF("UpdatePanel")
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
			local var2_13 = arg0_12:findTF("Text", arg2_13)

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
	local var0_22 = arg0_22:findTF("Btn", arg0_22.updatePanel)
	local var1_22 = arg0_22:findTF("Text", var0_22)
	local var2_22 = arg0_22:findTF("Progress", arg0_22.updatePanel)
	local var3_22 = arg0_22:findTF("Slider", var2_22)

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
	local var0_25 = arg0_25:findTF("Btn", arg0_25.updatePanel)
	local var1_25 = arg0_25:findTF("Text", var0_25)
	local var2_25 = arg0_25:findTF("Progress", arg0_25.updatePanel)
	local var3_25 = arg0_25:findTF("Slider", var2_25)
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
end

function var0_0.updatePicImg(arg0_37, arg1_37)
	local var0_37 = arg1_37 or arg0_37.curMiddleDataIndex
	local var1_37 = arg0_37:getPicConfigForShowByIndex(var0_37)
	local var2_37 = var1_37.id
	local var3_37 = var1_37.name
	local var4_37 = var1_37.illustration
	local var5_37 = GalleryConst.PIC_PATH_PREFIX .. var4_37

	setImageSprite(arg0_37.picImg, LoadSprite(var5_37, var4_37))
	setText(arg0_37.picName, var3_37)

	local var6_37 = arg0_37.appreciateProxy:isLikedByPicID(var2_37)

	arg0_37.picLikeToggleTag = true

	triggerToggle(arg0_37.picLikeToggle, var6_37)
end

function var0_0.switchPicImg(arg0_38, arg1_38)
	local var0_38 = arg1_38 or arg0_38.curMiddleDataIndex
	local var1_38 = arg0_38:getPicConfigForShowByIndex(var0_38)
	local var2_38 = var1_38.id
	local var3_38 = var1_38.name
	local var4_38 = var1_38.illustration
	local var5_38 = GalleryConst.PIC_PATH_PREFIX .. var4_38

	setImageSprite(arg0_38.picBGImg, LoadSprite(var5_38, var4_38))

	local var6_38 = arg0_38.appreciateProxy:isLikedByPicID(var2_38)

	arg0_38.picLikeToggleTag = true

	triggerToggle(arg0_38.picLikeToggle, var6_38)
	LeanTween.value(go(arg0_38.picImg), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_39)
		setImageAlpha(arg0_38.picImg, arg0_39)
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0_38.picImg, arg0_38.picBGImg)
		setImageAlpha(arg0_38.picImg, 1)
	end))
end

function var0_0.openPicPanel(arg0_41)
	pg.UIMgr.GetInstance():BlurPanel(arg0_41.picPanel, false, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})

	arg0_41.picPanel.offsetMax = arg0_41._tf.parent.offsetMax
	arg0_41.picPanel.offsetMin = arg0_41._tf.parent.offsetMin

	setActive(arg0_41.picPanel, true)
	LeanTween.value(go(arg0_41.picTopContainer), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0_42)
		setLocalScale(arg0_41.picTopContainer, {
			x = arg0_42,
			y = arg0_42
		})
	end)):setOnComplete(System.Action(function()
		setLocalScale(arg0_41.picTopContainer, {
			x = 1,
			y = 1
		})
	end))
end

function var0_0.closePicPanel(arg0_44, arg1_44)
	if arg1_44 == true then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_44.picPanel, arg0_44._tf)
		setActive(arg0_44.picPanel, false)

		return
	end

	if isActive(arg0_44.picPanel) then
		LeanTween.value(go(arg0_44.picTopContainer), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_45)
			setLocalScale(arg0_44.picTopContainer, {
				x = arg0_45,
				y = arg0_45
			})
		end)):setOnComplete(System.Action(function()
			setLocalScale(arg0_44.picTopContainer, {
				x = 0,
				y = 0
			})
			pg.UIMgr.GetInstance():UnblurPanel(arg0_44.picPanel, arg0_44._tf)
			setActive(arg0_44.picPanel, false)
		end))
	end
end

function var0_0.setMovingTag(arg0_47, arg1_47)
	arg0_47.isMoving = arg1_47
end

function var0_0.saveRunData(arg0_48)
	arg0_48.appreciateProxy:updateGalleryRunData(arg0_48.curPicSelectDateValue, arg0_48.curPicSortValue, arg0_48.curMiddleDataIndex, arg0_48.curPicLikeValue, arg0_48.curFilteLoadingBGValue)
end

function var0_0.recoveryFromRunData(arg0_49)
	local var0_49 = arg0_49.appreciateProxy:getGalleryRunData()

	arg0_49.curPicSelectDateValue = var0_49.dateValue
	arg0_49.curPicSortValue = var0_49.sortValue
	arg0_49.curMiddleDataIndex = var0_49.middleIndex
	arg0_49.curPicLikeValue = var0_49.likeValue
	arg0_49.curFilteLoadingBGValue = var0_49.bgFilteValue

	setText(arg0_49.progressText, arg0_49.curMiddleDataIndex .. "/" .. #arg0_49.picForShowConfigList)

	local var1_49 = table.indexof(GalleryConst.DateIndex, arg0_49.curPicSelectDateValue, 1)
	local var2_49 = GalleryConst.DateIndexName[var1_49]

	setText(arg0_49.timeTextSelected, var2_49)

	local var3_49 = arg0_49.curMiddleDataIndex - 1

	triggerToggle(arg0_49.likeFilterToggle, arg0_49.curPicLikeValue == GalleryConst.Filte_Like_Value)
	triggerToggle(arg0_49.orderToggle, arg0_49.curPicSortValue == GalleryConst.Sort_Order_Down)
	arg0_49.lScrollPageSC:MoveToItemID(var3_49)
end

function var0_0.tryShowTipMsgBox(arg0_50)
	if arg0_50.appreciateProxy:isGalleryHaveNewRes() then
		local function var0_50()
			PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
			arg0_50:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_pic_new_tip", GalleryConst.NewCount),
			onYes = var0_50,
			onCancel = var0_50,
			onClose = var0_50
		})
	end
end

function var0_0.cardUpdate(arg0_52, arg1_52, arg2_52)
	local var0_52 = arg0_52:findTF("CardImg", arg2_52)
	local var1_52 = arg0_52:findTF("CardNum/Text", arg2_52)
	local var2_52 = arg0_52:findTF("SelectBtn", arg2_52)
	local var3_52 = arg0_52:findTF("BlackMask", arg2_52)
	local var4_52 = arg0_52:findTF("Update", var3_52)
	local var5_52 = arg0_52:findTF("DownloadBtn", var3_52)
	local var6_52 = arg0_52:findTF("LockImg", var3_52)
	local var7_52 = arg0_52:findTF("TextUnlockTip", var3_52)
	local var8_52 = arg0_52:findTF("UnLockBtn", var3_52)

	setActive(var4_52, false)

	local var9_52 = arg1_52 + 1
	local var10_52 = arg0_52:getPicConfigForShowByIndex(var9_52)
	local var11_52 = var10_52.illustration .. "_t"
	local var12_52 = GalleryConst.CARD_PATH_PREFIX .. var11_52

	arg0_52.resLoader:LoadSprite(var12_52, var11_52, var0_52, false)
	setText(var1_52, "#" .. var9_52)

	local var13_52 = var10_52.id
	local var14_52
	local var15_52
	local var16_52 = arg0_52:isPicExist(var13_52)
	local var17_52 = arg0_52:getPicStateByID(var13_52)

	if var17_52 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var16_52 then
			setActive(var2_52, true)
			setActive(var3_52, false)
		else
			setActive(var2_52, false)
			setActive(var3_52, true)
			setActive(var5_52, true)
			setActive(var6_52, false)
			setActive(var7_52, false)
			setActive(var8_52, false)
		end
	elseif var17_52 == GalleryConst.CardStates.Unlocked then
		if var16_52 then
			local var18_52 = GalleryConst.GetBGFuncTag()

			setActive(var2_52, var18_52)
			setActive(var3_52, false)
		end
	elseif var17_52 == GalleryConst.CardStates.Unlockable then
		setActive(var2_52, false)
		setActive(var3_52, true)
		setActive(var5_52, false)
		setActive(var6_52, true)
		setActive(var7_52, false)
		setActive(var8_52, true)
		onButton(arg0_52, var8_52, function()
			if not arg0_52.appreciateUnlockMsgBox then
				arg0_52.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0_52._tf, arg0_52.event, arg0_52.contextData)
			end

			arg0_52.appreciateUnlockMsgBox:Reset()
			arg0_52.appreciateUnlockMsgBox:Load()
			arg0_52.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = arg0_52.appreciateProxy:getPicUnlockMaterialByID(var13_52),
				onYes = function()
					pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_UNLOCK, {
						picID = var13_52,
						unlockCBFunc = function()
							arg0_52:cardUpdate(arg1_52, arg2_52)
							arg0_52.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif var17_52 == GalleryConst.CardStates.DisUnlockable then
		setActive(var2_52, false)
		setActive(var3_52, true)
		setActive(var5_52, false)
		setActive(var6_52, true)
		setActive(var7_52, true)
		setActive(var8_52, false)
		setText(var7_52, var10_52.illustrate)
	end
end

function var0_0.initEmptyCard(arg0_56, arg1_56)
	local var0_56 = arg0_56:findTF("CardImg", arg1_56)
	local var1_56 = arg0_56:findTF("CardNum", arg1_56)
	local var2_56 = arg0_56:findTF("SelectBtn", arg1_56)

	setActive(var0_56, true)
	setActive(var1_56, false)
	setActive(var2_56, false)

	local var3_56
	local var4_56

	for iter0_56, iter1_56 in ipairs(pg.gallery_config.all) do
		local var5_56 = pg.gallery_config[iter1_56].illustration .. "_t"
		local var6_56 = GalleryConst.CARD_PATH_PREFIX .. var5_56

		if checkABExist(var6_56) then
			var3_56 = var6_56
			var4_56 = var5_56

			break
		end
	end

	arg0_56.resLoader:LoadSprite(var3_56, var4_56, var0_56, false)

	local var7_56 = arg0_56:findTF("BlackMask", arg1_56)
	local var8_56 = arg0_56:findTF("LockImg", var7_56)
	local var9_56 = arg0_56:findTF("TextUnlockTip", var7_56)
	local var10_56 = arg0_56:findTF("UnLockBtn", var7_56)

	setActive(var7_56, true)
	setActive(var8_56, false)
	setActive(var9_56, false)
	setActive(var10_56, false)

	local var11_56 = arg0_56:findTF("Update", var7_56)
	local var12_56 = arg0_56:findTF("Btn", var11_56)
	local var13_56 = arg0_56:findTF("Progress", var11_56)
	local var14_56 = arg0_56:findTF("Slider", var13_56)

	setActive(var11_56, true)
	setActive(var12_56, true)
	setActive(var13_56, false)
	onButton(arg0_56, var12_56, function()
		warning("click download btn,state:", tostring(arg0_56.manager.state))

		local var0_57 = arg0_56.manager.state

		if var0_57 == DownloadState.None or var0_57 == DownloadState.CheckFailure then
			arg0_56.manager:CheckD()
		elseif var0_57 == DownloadState.CheckToUpdate or var0_57 == DownloadState.UpdateFailure then
			local var1_57 = GroupHelper.GetGroupSize(var0_0.GalleryPicGroupName)
			local var2_57 = HashUtil.BytesToString(var1_57)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2_57)),
				onYes = function()
					arg0_56.manager:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0_56:startUpdateEmptyCard(arg1_56)
end

function var0_0.updateEmptyCard(arg0_59, arg1_59)
	local var0_59 = arg0_59:findTF("BlackMask", arg1_59)
	local var1_59 = arg0_59:findTF("Update", var0_59)
	local var2_59 = arg0_59:findTF("Btn", var1_59)
	local var3_59 = arg0_59:findTF("Text", var2_59)
	local var4_59 = arg0_59:findTF("Progress", var1_59)
	local var5_59 = arg0_59:findTF("Slider", var4_59)
	local var6_59 = arg0_59.manager.state

	if var6_59 == DownloadState.None then
		setText(var3_59, "None")
		setActive(var2_59, true)
		setActive(var4_59, false)
	elseif var6_59 == DownloadState.Checking then
		setText(var3_59, i18n("word_manga_checking"))
		setActive(var2_59, true)
		setActive(var4_59, false)
	elseif var6_59 == DownloadState.CheckToUpdate then
		setText(var3_59, i18n("word_manga_checktoupdate"))
		setActive(var2_59, true)
		setActive(var4_59, false)
	elseif var6_59 == DownloadState.CheckOver then
		setText(var3_59, "Latest Ver")
		setActive(var2_59, true)
		setActive(var4_59, false)
	elseif var6_59 == DownloadState.CheckFailure then
		setText(var3_59, i18n("word_manga_checkfailure"))
		setActive(var2_59, true)
		setActive(var4_59, false)
	elseif var6_59 == DownloadState.Updating then
		setText(var3_59, i18n("word_manga_updating", arg0_59.manager.downloadCount, arg0_59.manager.downloadTotal))
		setActive(var2_59, false)
		setActive(var4_59, true)
		setSlider(var5_59, 0, arg0_59.manager.downloadTotal, arg0_59.manager.downloadCount)
	elseif var6_59 == DownloadState.UpdateSuccess then
		setText(var3_59, i18n("word_manga_updatesuccess"))
		setActive(var2_59, true)
		setActive(var4_59, false)
		arg0_59:filtePic()
		arg0_59:updateCardListPanel()
	elseif var6_59 == DownloadState.UpdateFailure then
		setText(var3_59, i18n("word_manga_updatefailure"))
		setActive(var2_59, true)
		setActive(var4_59, false)
	end
end

function var0_0.startUpdateEmptyCard(arg0_60, arg1_60)
	if arg0_60.downloadCheckTimer then
		arg0_60.downloadCheckTimer:Stop()
	end

	arg0_60.downloadCheckTimer = Timer.New(function()
		arg0_60:updateEmptyCard(arg1_60)
	end, 0.5, -1)

	arg0_60.downloadCheckTimer:Start()
	arg0_60:updateEmptyCard(arg1_60)
end

function var0_0.stopUpdateEmptyCard(arg0_62, arg1_62)
	if arg0_62.downloadCheckTimer then
		arg0_62.downloadCheckTimer:Stop()
	end
end

function var0_0.getPicConfigForShowByIndex(arg0_63, arg1_63)
	local var0_63 = arg0_63.picForShowConfigList[arg1_63]

	if var0_63 then
		return var0_63
	elseif var0_63 == false then
		return false
	else
		assert(false, "不存在的Index:" .. tostring(arg1_63))
	end
end

function var0_0.sortPicConfigListForShow(arg0_64)
	local function var0_64(arg0_65, arg1_65)
		if arg0_64.curPicSortValue == GalleryConst.Sort_Order_Up then
			if arg0_65.id < arg1_65.id then
				return true
			else
				return false
			end
		elseif arg0_64.curPicSortValue == GalleryConst.Sort_Order_Down then
			if arg0_65.id < arg1_65.id then
				return false
			else
				return true
			end
		end
	end

	table.sort(arg0_64.picForShowConfigList, var0_64)
end

function var0_0.isPicExist(arg0_66, arg1_66)
	local var0_66 = pg.gallery_config[arg1_66].illustration
	local var1_66 = GalleryConst.PIC_PATH_PREFIX .. var0_66
	local var2_66 = arg0_66.manager:CheckF(var1_66)
	local var3_66 = var2_66 == DownloadState.None or var2_66 == DownloadState.UpdateSuccess
	local var4_66 = var1_66 .. "_t"
	local var5_66 = arg0_66.manager:CheckF(var4_66)
	local var6_66 = var5_66 == DownloadState.None or var5_66 == DownloadState.UpdateSuccess

	return var3_66 and var6_66
end

function var0_0.getPicStateByID(arg0_67, arg1_67)
	if not arg0_67.appreciateProxy:isPicNeedUnlockByID(arg1_67) then
		return GalleryConst.CardStates.Unlocked
	elseif arg0_67.appreciateProxy:isPicUnlockedByID(arg1_67) then
		return GalleryConst.CardStates.Unlocked
	elseif arg0_67.appreciateProxy:isPicUnlockableByID(arg1_67) then
		return GalleryConst.CardStates.Unlockable
	else
		return GalleryConst.CardStates.DisUnlockable
	end
end

function var0_0.filtePicForShow(arg0_68)
	local var0_68 = {}

	for iter0_68, iter1_68 in ipairs(pg.gallery_config.all) do
		if arg0_68:isPicExist(iter1_68) then
			local var1_68 = arg0_68.appreciateProxy:getSinglePicConfigByID(iter1_68)

			if arg0_68.appreciateProxy:isPicNeedUnlockByID(iter1_68) then
				if not arg0_68.appreciateProxy:isPicUnlockedByID(iter1_68) then
					local var2_68, var3_68 = arg0_68.appreciateProxy:isPicUnlockableByID(iter1_68)

					if var2_68 then
						var0_68[#var0_68 + 1] = var1_68
					elseif var3_68 then
						var0_68[#var0_68 + 1] = var1_68
					end
				else
					var0_68[#var0_68 + 1] = var1_68
				end
			else
				var0_68[#var0_68 + 1] = var1_68
			end
		end
	end

	return var0_68
end

function var0_0.filtePicForShowByDate(arg0_69)
	local var0_69 = arg0_69.curPicSelectDateValue

	if var0_69 == GalleryConst.Data_All_Value then
		return arg0_69:filtePicForShow()
	end

	local var1_69 = {}

	for iter0_69, iter1_69 in ipairs(pg.gallery_config.all) do
		if arg0_69:isPicExist(iter1_69) then
			local var2_69 = arg0_69.appreciateProxy:getSinglePicConfigByID(iter1_69)

			if arg0_69.appreciateProxy:isPicNeedUnlockByID(iter1_69) then
				if not arg0_69.appreciateProxy:isPicUnlockedByID(iter1_69) then
					local var3_69, var4_69 = arg0_69.appreciateProxy:isPicUnlockableByID(iter1_69)

					if var3_69 then
						if var0_69 == var2_69.year then
							var1_69[#var1_69 + 1] = var2_69
						end
					elseif var4_69 and var0_69 == var2_69.year then
						var1_69[#var1_69 + 1] = var2_69
					end
				elseif var0_69 == var2_69.year then
					var1_69[#var1_69 + 1] = var2_69
				end
			elseif var0_69 == var2_69.year then
				var1_69[#var1_69 + 1] = var2_69
			end
		end
	end

	return var1_69
end

function var0_0.filtePicForShowByLike(arg0_70)
	if arg0_70.curPicLikeValue == GalleryConst.Filte_Normal_Value then
		return arg0_70.picForShowConfigList
	end

	local var0_70 = {}

	for iter0_70, iter1_70 in ipairs(arg0_70.picForShowConfigList) do
		local var1_70 = iter1_70.id

		if arg0_70.appreciateProxy:isLikedByPicID(var1_70) then
			var0_70[#var0_70 + 1] = iter1_70
		end
	end

	return var0_70
end

function var0_0.filtePicForShowByLoadingBG(arg0_71)
	if arg0_71.curFilteLoadingBGValue == GalleryConst.Loading_BG_NO_Filte then
		return arg0_71.picForShowConfigList
	end

	local var0_71 = {}

	for iter0_71, iter1_71 in ipairs(arg0_71.picForShowConfigList) do
		local var1_71 = iter1_71.id

		if GalleryConst.IsInBGIDList(var1_71) then
			var0_71[#var0_71 + 1] = iter1_71
		end
	end

	return var0_71
end

function var0_0.filtePic(arg0_72)
	arg0_72.picForShowConfigList = arg0_72:filtePicForShow()
	arg0_72.picForShowConfigList = arg0_72:filtePicForShowByLike(arg0_72.curPicLikeValue)

	arg0_72:sortPicConfigListForShow()

	if arg0_72:isNeedShowDownBtn() then
		table.insert(arg0_72.picForShowConfigList, 1, false)
	end
end

function var0_0.isNeedShowDownBtn(arg0_73)
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
