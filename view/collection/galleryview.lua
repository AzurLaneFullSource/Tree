local var0 = class("GalleryView", import("..base.BaseSubView"))

var0.GalleryPicGroupName = "GALLERY_PIC"

function var0.getUIName(arg0)
	return "GalleryUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initCardListPanel()
	arg0:initPicPanel()
	arg0:Show()
	arg0:recoveryFromRunData()
	arg0:tryShowTipMsgBox()
end

function var0.OnDestroy(arg0)
	arg0.resLoader:Clear()

	if arg0.appreciateUnlockMsgBox and arg0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0.appreciateUnlockMsgBox:hideCustomMsgBox()
	end

	if isActive(arg0.picPanel) then
		arg0:closePicPanel(true)
	end

	arg0:stopUpdateEmptyCard()
	arg0:stopUpdateDownBtnPanel()
end

function var0.onBackPressed(arg0)
	if arg0.appreciateUnlockMsgBox and arg0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0.appreciateUnlockMsgBox:hideCustomMsgBox()

		return false
	elseif isActive(arg0.picPanel) then
		arg0:closePicPanel()

		return false
	else
		return true
	end
end

function var0.initData(arg0)
	arg0.appreciateProxy = getProxy(AppreciateProxy)

	arg0.appreciateProxy:checkPicFileState()

	arg0.resLoader = AutoLoader.New()
	arg0.manager = BundleWizard.Inst:GetGroupMgr("GALLERY_PIC")
	arg0.picForShowConfigList = {}
	arg0.cardTFList = {}
	arg0.curPicLikeValue = GalleryConst.Filte_Normal_Value
	arg0.curPicSelectDateValue = GalleryConst.Data_All_Value
	arg0.curPicSortValue = GalleryConst.Sort_Order_Up
	arg0.curMiddleDataIndex = 1
	arg0.curFilteLoadingBGValue = GalleryConst.Loading_BG_NO_Filte
	arg0.downloadCheckIDList = {}
	arg0.downloadCheckTimer = nil
	arg0.picLikeToggleTag = false
end

function var0.findUI(arg0)
	setLocalPosition(arg0._tf, Vector2.zero)

	arg0._tf.anchorMin = Vector2.zero
	arg0._tf.anchorMax = Vector2.one
	arg0._tf.offsetMax = Vector2.zero
	arg0._tf.offsetMin = Vector2.zero
	arg0.topPanel = arg0:findTF("TopPanel")
	arg0.scrollBar = arg0:findTF("Scrollbar")
	arg0.timeFilterToggle = arg0:findTF("List/TimeFilterBtn", arg0.topPanel)
	arg0.timeTextSelected = arg0:findTF("TextSelected", arg0.timeFilterToggle)
	arg0.timeItemContainer = arg0:findTF("Panel", arg0.timeFilterToggle)
	arg0.timeItemTpl = arg0:findTF("Item", arg0.timeItemContainer)

	setActive(arg0.timeFilterToggle, #GalleryConst.DateIndex >= 2)

	arg0.setFilteToggle = arg0:findTF("List/SetFilterBtn", arg0.topPanel)

	setActive(arg0.setFilteToggle, false)

	arg0.setOpenToggle = arg0:findTF("SetToggle")

	setActive(arg0.setOpenToggle, false)

	arg0.likeFilterToggle = arg0:findTF("List/LikeFilterBtn", arg0.topPanel)
	arg0.likeNumText = arg0:findTF("TextNum", arg0.likeFilterToggle)

	setActive(arg0.likeFilterToggle, true)
	setActive(arg0.likeNumText, false)

	arg0.orderToggle = arg0:findTF("List/OrderBtn", arg0.topPanel)
	arg0.resRepaireBtn = arg0:findTF("List/RepaireBtn", arg0.topPanel)
	arg0.progressText = arg0:findTF("TextProgress", arg0.topPanel)
	arg0.scrollPanel = arg0:findTF("Scroll")
	arg0.lScrollPageSC = GetComponent(arg0.scrollPanel, "LScrollPage")
	arg0.picPanel = arg0:findTF("PicPanel")
	arg0.picPanelBG = arg0:findTF("PanelBG", arg0.picPanel)
	arg0.picTopContainer = arg0:findTF("Container", arg0.picPanel)
	arg0.picContainer = arg0:findTF("Container/Picture", arg0.picPanel)
	arg0.picBGImg = arg0:findTF("Container/Picture/PicBG", arg0.picPanel)
	arg0.picImg = arg0:findTF("Container/Picture/Pic", arg0.picPanel)
	arg0.picLikeToggle = arg0:findTF("LikeBtn", arg0.picContainer)
	arg0.picName = arg0:findTF("PicName", arg0.picContainer)
	arg0.picPreBtn = arg0:findTF("PreBtn", arg0.picPanel)
	arg0.picNextBtn = arg0:findTF("NextBtn", arg0.picPanel)

	setActive(arg0.picLikeToggle, true)

	arg0.emptyPanel = arg0:findTF("EmptyPanel")
	arg0.updatePanel = arg0:findTF("UpdatePanel")
end

function var0.addListener(arg0)
	onToggle(arg0, arg0.orderToggle, function(arg0)
		arg0.curMiddleDataIndex = 1

		if arg0 == true then
			arg0.curPicSortValue = GalleryConst.Sort_Order_Down
		else
			arg0.curPicSortValue = GalleryConst.Sort_Order_Up
		end

		arg0:saveRunData()
		arg0:filtePic()
		arg0:updateCardListPanel()
	end, SFX_PANEL)
	onToggle(arg0, arg0.likeFilterToggle, function(arg0)
		arg0.curMiddleDataIndex = 1

		if arg0 == true then
			arg0.curPicLikeValue = GalleryConst.Filte_Like_Value
		else
			arg0.curPicLikeValue = GalleryConst.Filte_Normal_Value
		end

		arg0:saveRunData()
		arg0:filtePic()
		arg0:updateCardListPanel()
	end)
	onButton(arg0, arg0.resRepaireBtn, function()
		local var0 = {
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
				var0
			}
		})
	end, SFX_PANEL)
end

function var0.initTimeSelectPanel(arg0)
	arg0.timeSelectUIItemList = UIItemList.New(arg0.timeItemContainer, arg0.timeItemTpl)

	arg0.timeSelectUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = GalleryConst.DateIndex[arg1 + 1]
			local var1 = GalleryConst.DateIndexName[arg1 + 1]
			local var2 = arg0:findTF("Text", arg2)

			setText(var2, var1)
			onButton(arg0, arg2, function()
				if var0 ~= arg0.curPicSelectDateValue then
					arg0.curPicSelectDateValue = var0
					arg0.curMiddleDataIndex = 1

					arg0:saveRunData()
					setText(arg0.timeTextSelected, var1)
					arg0:filtePic()
					arg0:updateCardListPanel()
				end

				triggerToggle(arg0.timeFilterToggle, false)
			end, SFX_PANEL)
		end
	end)
	arg0.timeSelectUIItemList:align(#GalleryConst.DateIndex)
end

function var0.initCardListPanel(arg0)
	function arg0.lScrollPageSC.itemInitedCallback(arg0, arg1)
		local var0 = arg0 + 1

		arg0.cardTFList[var0] = arg1

		local var1 = arg0 + 1

		if arg0:getPicConfigForShowByIndex(var1) == false then
			arg0:initEmptyCard(arg1)
		else
			arg0:cardUpdate(arg0, arg1)
		end
	end

	function arg0.lScrollPageSC.itemClickCallback(arg0, arg1)
		local var0 = arg0 + 1
		local var1 = arg0:getPicConfigForShowByIndex(var0)

		if var1 then
			local var2 = var1.id
			local var3
			local var4
			local var5 = arg0:isPicExist(var2)

			if arg0:getPicStateByID(var2) == GalleryConst.CardStates.Unlocked and var5 then
				arg0:updatePicImg(var0)
				arg0:openPicPanel()
			end
		end
	end

	function arg0.lScrollPageSC.itemPitchCallback(arg0, arg1)
		arg0:setMovingTag(false)

		local var0 = arg0 + 1

		if arg0.curMiddleDataIndex ~= var0 then
			arg0.curMiddleDataIndex = var0

			arg0:saveRunData()

			if isActive(arg0.picPanel) then
				arg0:switchPicImg(arg0.curMiddleDataIndex)
			end
		end
	end

	function arg0.lScrollPageSC.itemRecycleCallback(arg0, arg1)
		local var0 = arg0 + 1

		arg0.cardTFList[var0] = nil

		local var1 = arg0 + 1

		if arg0:getPicConfigForShowByIndex(var1) == false then
			arg0:stopUpdateEmptyCard(arg1)
		end
	end

	function arg0.lScrollPageSC.itemMoveCallback(arg0)
		if #arg0.picForShowConfigList == 1 then
			setText(arg0.progressText, "1/1")
		else
			setText(arg0.progressText, math.clamp(math.round(arg0 * (#arg0.picForShowConfigList - 1)) + 1, 1, #arg0.picForShowConfigList) .. "/" .. #arg0.picForShowConfigList)
		end
	end
end

function var0.updateCardListPanel(arg0)
	arg0.cardTFList = {}

	arg0.resLoader:Clear()

	local var0 = #arg0.picForShowConfigList <= 0
	local var1 = #arg0.picForShowConfigList == 1 and arg0.picForShowConfigList[1] == false

	setActive(arg0.emptyPanel, var0)
	setActive(arg0.updatePanel, var1)
	setActive(arg0.scrollPanel, not var0 and not var1)
	arg0:stopUpdateDownBtnPanel()

	if not var0 and not var1 then
		setActive(arg0.scrollBar, true)
		setActive(arg0.progressText, true)

		arg0.lScrollPageSC.DataCount = #arg0.picForShowConfigList

		arg0.lScrollPageSC:Init(arg0.curMiddleDataIndex - 1)
	elseif var1 then
		setActive(arg0.scrollBar, false)
		setActive(arg0.progressText, false)
		arg0:initDownBtnPanel()
	end
end

function var0.initDownBtnPanel(arg0)
	local var0 = arg0:findTF("Btn", arg0.updatePanel)
	local var1 = arg0:findTF("Text", var0)
	local var2 = arg0:findTF("Progress", arg0.updatePanel)
	local var3 = arg0:findTF("Slider", var2)

	setActive(var0, true)
	setActive(var2, false)
	onButton(arg0, var0, function()
		warning("click download btn,state:", tostring(arg0.manager.state))

		local var0 = arg0.manager.state

		if var0 == DownloadState.None or var0 == DownloadState.CheckFailure then
			arg0.manager:CheckD()
		elseif var0 == DownloadState.CheckToUpdate or var0 == DownloadState.UpdateFailure then
			local var1 = GroupHelper.GetGroupSize(var0.GalleryPicGroupName)
			local var2 = HashUtil.BytesToString(var1)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2)),
				onYes = function()
					arg0.manager:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0:startUpdateDownBtnPanel()
end

function var0.updateDownBtnPanel(arg0)
	local var0 = arg0:findTF("Btn", arg0.updatePanel)
	local var1 = arg0:findTF("Text", var0)
	local var2 = arg0:findTF("Progress", arg0.updatePanel)
	local var3 = arg0:findTF("Slider", var2)
	local var4 = arg0.manager.state

	if var4 == DownloadState.None then
		setText(var1, "None")
		setActive(var0, true)
		setActive(var2, false)
	elseif var4 == DownloadState.Checking then
		setText(var1, i18n("word_manga_checking"))
		setActive(var0, true)
		setActive(var2, false)
	elseif var4 == DownloadState.CheckToUpdate then
		setText(var1, i18n("word_manga_checktoupdate"))
		setActive(var0, true)
		setActive(var2, false)
	elseif var4 == DownloadState.CheckOver then
		setText(var1, "Latest Ver")
		setActive(var0, true)
		setActive(var2, false)
	elseif var4 == DownloadState.CheckFailure then
		setText(var1, i18n("word_manga_checkfailure"))
		setActive(var0, true)
		setActive(var2, false)
	elseif var4 == DownloadState.Updating then
		setText(var1, i18n("word_manga_updating", arg0.manager.downloadCount, arg0.manager.downloadTotal))
		setActive(var0, false)
		setActive(var2, true)
		setSlider(var3, 0, arg0.manager.downloadTotal, arg0.manager.downloadCount)
	elseif var4 == DownloadState.UpdateSuccess then
		setText(var1, i18n("word_manga_updatesuccess"))
		setActive(var0, true)
		setActive(var2, false)
		arg0:filtePic()
		arg0:updateCardListPanel()
	elseif var4 == DownloadState.UpdateFailure then
		setText(var1, i18n("word_manga_updatefailure"))
		setActive(var0, true)
		setActive(var2, false)
	end
end

function var0.startUpdateDownBtnPanel(arg0)
	if arg0.downloadCheckTimer then
		arg0.downloadCheckTimer:Stop()
	end

	arg0.downloadCheckTimer = Timer.New(function()
		arg0:updateDownBtnPanel()
	end, 0.5, -1)

	arg0.downloadCheckTimer:Start()
	arg0:updateDownBtnPanel()
end

function var0.stopUpdateDownBtnPanel(arg0)
	if arg0.downloadCheckTimer then
		arg0.downloadCheckTimer:Stop()
	end
end

function var0.initPicPanel(arg0)
	onButton(arg0, arg0.picPanelBG, function()
		arg0:closePicPanel()
	end, SFX_CANCEL)
	addSlip(SLIP_TYPE_HRZ, arg0.picImg, function()
		triggerButton(arg0.picPreBtn)
	end, function()
		triggerButton(arg0.picNextBtn)
	end, function()
		local var0 = arg0.curMiddleDataIndex
		local var1 = arg0:getPicConfigForShowByIndex(var0).id

		arg0:emit(GalleryConst.OPEN_FULL_SCREEN_PIC_VIEW, var1)
	end)
	onButton(arg0, arg0.picPreBtn, function()
		if arg0.isMoving == true then
			return
		end

		local var0 = arg0.curMiddleDataIndex
		local var1

		while var0 > 1 do
			var0 = var0 - 1

			local var2 = arg0:getPicConfigForShowByIndex(var0).id
			local var3 = arg0:isPicExist(var2)
			local var4 = arg0:getPicStateByID(var2)

			if var3 and var4 == GalleryConst.CardStates.Unlocked then
				var1 = var0

				break
			end
		end

		if var1 and var1 > 0 then
			arg0:setMovingTag(true)
			arg0.lScrollPageSC:MoveToItemID(var1 - 1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.picNextBtn, function()
		if arg0.isMoving == true then
			return
		end

		local var0 = arg0.curMiddleDataIndex
		local var1

		while var0 < #arg0.picForShowConfigList do
			var0 = var0 + 1

			local var2 = arg0:getPicConfigForShowByIndex(var0).id
			local var3 = arg0:isPicExist(var2)
			local var4 = arg0:getPicStateByID(var2)

			if var3 and var4 == GalleryConst.CardStates.Unlocked then
				var1 = var0

				break
			end
		end

		if var1 and var1 <= #arg0.picForShowConfigList then
			arg0:setMovingTag(true)
			arg0.lScrollPageSC:MoveToItemID(var1 - 1)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.picLikeToggle, function(arg0)
		if arg0.picLikeToggleTag == true then
			arg0.picLikeToggleTag = false

			return
		end

		local var0 = arg0:getPicConfigForShowByIndex(arg0.curMiddleDataIndex).id
		local var1 = arg0 == true and 0 or 1

		if var1 == 0 then
			if arg0.appreciateProxy:isLikedByPicID(var0) then
				return
			else
				pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, {
					isAdd = 0,
					picID = var0
				})
			end
		elseif var1 == 1 then
			if arg0.appreciateProxy:isLikedByPicID(var0) then
				pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, {
					isAdd = 1,
					picID = var0
				})
			else
				return
			end
		end
	end, SFX_PANEL)
end

function var0.updatePicImg(arg0, arg1)
	local var0 = arg1 or arg0.curMiddleDataIndex
	local var1 = arg0:getPicConfigForShowByIndex(var0)
	local var2 = var1.id
	local var3 = var1.name
	local var4 = var1.illustration
	local var5 = GalleryConst.PIC_PATH_PREFIX .. var4

	setImageSprite(arg0.picImg, LoadSprite(var5, var4))
	setText(arg0.picName, var3)

	local var6 = arg0.appreciateProxy:isLikedByPicID(var2)

	arg0.picLikeToggleTag = true

	triggerToggle(arg0.picLikeToggle, var6)
end

function var0.switchPicImg(arg0, arg1)
	local var0 = arg1 or arg0.curMiddleDataIndex
	local var1 = arg0:getPicConfigForShowByIndex(var0)
	local var2 = var1.id
	local var3 = var1.name
	local var4 = var1.illustration
	local var5 = GalleryConst.PIC_PATH_PREFIX .. var4

	setImageSprite(arg0.picBGImg, LoadSprite(var5, var4))

	local var6 = arg0.appreciateProxy:isLikedByPicID(var2)

	arg0.picLikeToggleTag = true

	triggerToggle(arg0.picLikeToggle, var6)
	LeanTween.value(go(arg0.picImg), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0)
		setImageAlpha(arg0.picImg, arg0)
	end)):setOnComplete(System.Action(function()
		setImageFromImage(arg0.picImg, arg0.picBGImg)
		setImageAlpha(arg0.picImg, 1)
	end))
end

function var0.openPicPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.picPanel, false, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})

	arg0.picPanel.offsetMax = arg0._tf.parent.offsetMax
	arg0.picPanel.offsetMin = arg0._tf.parent.offsetMin

	setActive(arg0.picPanel, true)
	LeanTween.value(go(arg0.picTopContainer), 0, 1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setLocalScale(arg0.picTopContainer, {
			x = arg0,
			y = arg0
		})
	end)):setOnComplete(System.Action(function()
		setLocalScale(arg0.picTopContainer, {
			x = 1,
			y = 1
		})
	end))
end

function var0.closePicPanel(arg0, arg1)
	if arg1 == true then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.picPanel, arg0._tf)
		setActive(arg0.picPanel, false)

		return
	end

	if isActive(arg0.picPanel) then
		LeanTween.value(go(arg0.picTopContainer), 1, 0, 0.3):setOnUpdate(System.Action_float(function(arg0)
			setLocalScale(arg0.picTopContainer, {
				x = arg0,
				y = arg0
			})
		end)):setOnComplete(System.Action(function()
			setLocalScale(arg0.picTopContainer, {
				x = 0,
				y = 0
			})
			pg.UIMgr.GetInstance():UnblurPanel(arg0.picPanel, arg0._tf)
			setActive(arg0.picPanel, false)
		end))
	end
end

function var0.setMovingTag(arg0, arg1)
	arg0.isMoving = arg1
end

function var0.saveRunData(arg0)
	arg0.appreciateProxy:updateGalleryRunData(arg0.curPicSelectDateValue, arg0.curPicSortValue, arg0.curMiddleDataIndex, arg0.curPicLikeValue, arg0.curFilteLoadingBGValue)
end

function var0.recoveryFromRunData(arg0)
	local var0 = arg0.appreciateProxy:getGalleryRunData()

	arg0.curPicSelectDateValue = var0.dateValue
	arg0.curPicSortValue = var0.sortValue
	arg0.curMiddleDataIndex = var0.middleIndex
	arg0.curPicLikeValue = var0.likeValue
	arg0.curFilteLoadingBGValue = var0.bgFilteValue

	setText(arg0.progressText, arg0.curMiddleDataIndex .. "/" .. #arg0.picForShowConfigList)

	local var1 = table.indexof(GalleryConst.DateIndex, arg0.curPicSelectDateValue, 1)
	local var2 = GalleryConst.DateIndexName[var1]

	setText(arg0.timeTextSelected, var2)

	local var3 = arg0.curMiddleDataIndex - 1

	triggerToggle(arg0.likeFilterToggle, arg0.curPicLikeValue == GalleryConst.Filte_Like_Value)
	triggerToggle(arg0.orderToggle, arg0.curPicSortValue == GalleryConst.Sort_Order_Down)
	arg0.lScrollPageSC:MoveToItemID(var3)
end

function var0.tryShowTipMsgBox(arg0)
	if arg0.appreciateProxy:isGalleryHaveNewRes() then
		local function var0()
			PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
			arg0:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_pic_new_tip", GalleryConst.NewCount),
			onYes = var0,
			onCancel = var0,
			onClose = var0
		})
	end
end

function var0.cardUpdate(arg0, arg1, arg2)
	local var0 = arg0:findTF("CardImg", arg2)
	local var1 = arg0:findTF("CardNum/Text", arg2)
	local var2 = arg0:findTF("SelectBtn", arg2)
	local var3 = arg0:findTF("BlackMask", arg2)
	local var4 = arg0:findTF("Update", var3)
	local var5 = arg0:findTF("DownloadBtn", var3)
	local var6 = arg0:findTF("LockImg", var3)
	local var7 = arg0:findTF("TextUnlockTip", var3)
	local var8 = arg0:findTF("UnLockBtn", var3)

	setActive(var4, false)

	local var9 = arg1 + 1
	local var10 = arg0:getPicConfigForShowByIndex(var9)
	local var11 = var10.illustration .. "_t"
	local var12 = GalleryConst.CARD_PATH_PREFIX .. var11

	arg0.resLoader:LoadSprite(var12, var11, var0, false)
	setText(var1, "#" .. var9)

	local var13 = var10.id
	local var14
	local var15
	local var16 = arg0:isPicExist(var13)
	local var17 = arg0:getPicStateByID(var13)

	if var17 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var16 then
			setActive(var2, true)
			setActive(var3, false)
		else
			setActive(var2, false)
			setActive(var3, true)
			setActive(var5, true)
			setActive(var6, false)
			setActive(var7, false)
			setActive(var8, false)
		end
	elseif var17 == GalleryConst.CardStates.Unlocked then
		if var16 then
			local var18 = GalleryConst.GetBGFuncTag()

			setActive(var2, var18)
			setActive(var3, false)
		end
	elseif var17 == GalleryConst.CardStates.Unlockable then
		setActive(var2, false)
		setActive(var3, true)
		setActive(var5, false)
		setActive(var6, true)
		setActive(var7, false)
		setActive(var8, true)
		onButton(arg0, var8, function()
			if not arg0.appreciateUnlockMsgBox then
				arg0.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0._tf, arg0.event, arg0.contextData)
			end

			arg0.appreciateUnlockMsgBox:Reset()
			arg0.appreciateUnlockMsgBox:Load()
			arg0.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = arg0.appreciateProxy:getPicUnlockMaterialByID(var13),
				onYes = function()
					pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_UNLOCK, {
						picID = var13,
						unlockCBFunc = function()
							arg0:cardUpdate(arg1, arg2)
							arg0.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif var17 == GalleryConst.CardStates.DisUnlockable then
		setActive(var2, false)
		setActive(var3, true)
		setActive(var5, false)
		setActive(var6, true)
		setActive(var7, true)
		setActive(var8, false)
		setText(var7, var10.illustrate)
	end
end

function var0.initEmptyCard(arg0, arg1)
	local var0 = arg0:findTF("CardImg", arg1)
	local var1 = arg0:findTF("CardNum", arg1)
	local var2 = arg0:findTF("SelectBtn", arg1)

	setActive(var0, true)
	setActive(var1, false)
	setActive(var2, false)

	local var3
	local var4

	for iter0, iter1 in ipairs(pg.gallery_config.all) do
		local var5 = pg.gallery_config[iter1].illustration .. "_t"
		local var6 = GalleryConst.CARD_PATH_PREFIX .. var5

		if checkABExist(var6) then
			var3 = var6
			var4 = var5

			break
		end
	end

	arg0.resLoader:LoadSprite(var3, var4, var0, false)

	local var7 = arg0:findTF("BlackMask", arg1)
	local var8 = arg0:findTF("LockImg", var7)
	local var9 = arg0:findTF("TextUnlockTip", var7)
	local var10 = arg0:findTF("UnLockBtn", var7)

	setActive(var7, true)
	setActive(var8, false)
	setActive(var9, false)
	setActive(var10, false)

	local var11 = arg0:findTF("Update", var7)
	local var12 = arg0:findTF("Btn", var11)
	local var13 = arg0:findTF("Progress", var11)
	local var14 = arg0:findTF("Slider", var13)

	setActive(var11, true)
	setActive(var12, true)
	setActive(var13, false)
	onButton(arg0, var12, function()
		warning("click download btn,state:", tostring(arg0.manager.state))

		local var0 = arg0.manager.state

		if var0 == DownloadState.None or var0 == DownloadState.CheckFailure then
			arg0.manager:CheckD()
		elseif var0 == DownloadState.CheckToUpdate or var0 == DownloadState.UpdateFailure then
			local var1 = GroupHelper.GetGroupSize(var0.GalleryPicGroupName)
			local var2 = HashUtil.BytesToString(var1)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2)),
				onYes = function()
					arg0.manager:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0:startUpdateEmptyCard(arg1)
end

function var0.updateEmptyCard(arg0, arg1)
	local var0 = arg0:findTF("BlackMask", arg1)
	local var1 = arg0:findTF("Update", var0)
	local var2 = arg0:findTF("Btn", var1)
	local var3 = arg0:findTF("Text", var2)
	local var4 = arg0:findTF("Progress", var1)
	local var5 = arg0:findTF("Slider", var4)
	local var6 = arg0.manager.state

	if var6 == DownloadState.None then
		setText(var3, "None")
		setActive(var2, true)
		setActive(var4, false)
	elseif var6 == DownloadState.Checking then
		setText(var3, i18n("word_manga_checking"))
		setActive(var2, true)
		setActive(var4, false)
	elseif var6 == DownloadState.CheckToUpdate then
		setText(var3, i18n("word_manga_checktoupdate"))
		setActive(var2, true)
		setActive(var4, false)
	elseif var6 == DownloadState.CheckOver then
		setText(var3, "Latest Ver")
		setActive(var2, true)
		setActive(var4, false)
	elseif var6 == DownloadState.CheckFailure then
		setText(var3, i18n("word_manga_checkfailure"))
		setActive(var2, true)
		setActive(var4, false)
	elseif var6 == DownloadState.Updating then
		setText(var3, i18n("word_manga_updating", arg0.manager.downloadCount, arg0.manager.downloadTotal))
		setActive(var2, false)
		setActive(var4, true)
		setSlider(var5, 0, arg0.manager.downloadTotal, arg0.manager.downloadCount)
	elseif var6 == DownloadState.UpdateSuccess then
		setText(var3, i18n("word_manga_updatesuccess"))
		setActive(var2, true)
		setActive(var4, false)
		arg0:filtePic()
		arg0:updateCardListPanel()
	elseif var6 == DownloadState.UpdateFailure then
		setText(var3, i18n("word_manga_updatefailure"))
		setActive(var2, true)
		setActive(var4, false)
	end
end

function var0.startUpdateEmptyCard(arg0, arg1)
	if arg0.downloadCheckTimer then
		arg0.downloadCheckTimer:Stop()
	end

	arg0.downloadCheckTimer = Timer.New(function()
		arg0:updateEmptyCard(arg1)
	end, 0.5, -1)

	arg0.downloadCheckTimer:Start()
	arg0:updateEmptyCard(arg1)
end

function var0.stopUpdateEmptyCard(arg0, arg1)
	if arg0.downloadCheckTimer then
		arg0.downloadCheckTimer:Stop()
	end
end

function var0.getPicConfigForShowByIndex(arg0, arg1)
	local var0 = arg0.picForShowConfigList[arg1]

	if var0 then
		return var0
	elseif var0 == false then
		return false
	else
		assert(false, "不存在的Index:" .. tostring(arg1))
	end
end

function var0.sortPicConfigListForShow(arg0)
	local function var0(arg0, arg1)
		if arg0.curPicSortValue == GalleryConst.Sort_Order_Up then
			if arg0.id < arg1.id then
				return true
			else
				return false
			end
		elseif arg0.curPicSortValue == GalleryConst.Sort_Order_Down then
			if arg0.id < arg1.id then
				return false
			else
				return true
			end
		end
	end

	table.sort(arg0.picForShowConfigList, var0)
end

function var0.isPicExist(arg0, arg1)
	local var0 = pg.gallery_config[arg1].illustration
	local var1 = GalleryConst.PIC_PATH_PREFIX .. var0
	local var2 = arg0.manager:CheckF(var1)
	local var3 = var2 == DownloadState.None or var2 == DownloadState.UpdateSuccess
	local var4 = var1 .. "_t"
	local var5 = arg0.manager:CheckF(var4)
	local var6 = var5 == DownloadState.None or var5 == DownloadState.UpdateSuccess

	return var3 and var6
end

function var0.getPicStateByID(arg0, arg1)
	if not arg0.appreciateProxy:isPicNeedUnlockByID(arg1) then
		return GalleryConst.CardStates.Unlocked
	elseif arg0.appreciateProxy:isPicUnlockedByID(arg1) then
		return GalleryConst.CardStates.Unlocked
	elseif arg0.appreciateProxy:isPicUnlockableByID(arg1) then
		return GalleryConst.CardStates.Unlockable
	else
		return GalleryConst.CardStates.DisUnlockable
	end
end

function var0.filtePicForShow(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.gallery_config.all) do
		if arg0:isPicExist(iter1) then
			local var1 = arg0.appreciateProxy:getSinglePicConfigByID(iter1)

			if arg0.appreciateProxy:isPicNeedUnlockByID(iter1) then
				if not arg0.appreciateProxy:isPicUnlockedByID(iter1) then
					local var2, var3 = arg0.appreciateProxy:isPicUnlockableByID(iter1)

					if var2 then
						var0[#var0 + 1] = var1
					elseif var3 then
						var0[#var0 + 1] = var1
					end
				else
					var0[#var0 + 1] = var1
				end
			else
				var0[#var0 + 1] = var1
			end
		end
	end

	return var0
end

function var0.filtePicForShowByDate(arg0)
	local var0 = arg0.curPicSelectDateValue

	if var0 == GalleryConst.Data_All_Value then
		return arg0:filtePicForShow()
	end

	local var1 = {}

	for iter0, iter1 in ipairs(pg.gallery_config.all) do
		if arg0:isPicExist(iter1) then
			local var2 = arg0.appreciateProxy:getSinglePicConfigByID(iter1)

			if arg0.appreciateProxy:isPicNeedUnlockByID(iter1) then
				if not arg0.appreciateProxy:isPicUnlockedByID(iter1) then
					local var3, var4 = arg0.appreciateProxy:isPicUnlockableByID(iter1)

					if var3 then
						if var0 == var2.year then
							var1[#var1 + 1] = var2
						end
					elseif var4 and var0 == var2.year then
						var1[#var1 + 1] = var2
					end
				elseif var0 == var2.year then
					var1[#var1 + 1] = var2
				end
			elseif var0 == var2.year then
				var1[#var1 + 1] = var2
			end
		end
	end

	return var1
end

function var0.filtePicForShowByLike(arg0)
	if arg0.curPicLikeValue == GalleryConst.Filte_Normal_Value then
		return arg0.picForShowConfigList
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.picForShowConfigList) do
		local var1 = iter1.id

		if arg0.appreciateProxy:isLikedByPicID(var1) then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var0.filtePicForShowByLoadingBG(arg0)
	if arg0.curFilteLoadingBGValue == GalleryConst.Loading_BG_NO_Filte then
		return arg0.picForShowConfigList
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.picForShowConfigList) do
		local var1 = iter1.id

		if GalleryConst.IsInBGIDList(var1) then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var0.filtePic(arg0)
	arg0.picForShowConfigList = arg0:filtePicForShow()
	arg0.picForShowConfigList = arg0:filtePicForShowByLike(arg0.curPicLikeValue)

	arg0:sortPicConfigListForShow()

	if arg0:isNeedShowDownBtn() then
		table.insert(arg0.picForShowConfigList, 1, false)
	end
end

function var0.isNeedShowDownBtn(arg0)
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0.GalleryPicGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0.GalleryPicGroupName) then
		return false
	end

	return true
end

return var0
