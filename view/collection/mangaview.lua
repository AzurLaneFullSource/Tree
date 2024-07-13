local var0_0 = class("MangaView", import("..base.BaseSubView"))

var0_0.MangaGroupName = "MANGA"

function var0_0.getUIName(arg0_1)
	return "MangaUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
	arg0_2:updateBtnList()
	arg0_2:Show()
	arg0_2:updatePanel()
	arg0_2:tryShowTipMsgBox()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.resLoader:Clear()
	arg0_3:stopUpdateEmpty()
	arg0_3:stopUpdateDownloadBtnPanel()
end

function var0_0.onBackPressed(arg0_4)
	return true
end

function var0_0.initData(arg0_5)
	arg0_5.appreciateProxy = getProxy(AppreciateProxy)
	arg0_5.resLoader = AutoLoader.New()
	arg0_5.isShowNotRead = false
	arg0_5.isShowLike = false
	arg0_5.isUpOrder = false
	arg0_5.group = GroupHelper.GetGroupMgrByName(var0_0.MangaGroupName)
	arg0_5.mangaIDListForShow = arg0_5:getMangaIDListForShow()
end

function var0_0.initUI(arg0_6)
	setLocalPosition(arg0_6._tf, Vector2.zero)

	arg0_6._tf.anchorMin = Vector2.zero
	arg0_6._tf.anchorMax = Vector2.one
	arg0_6._tf.offsetMax = Vector2.zero
	arg0_6._tf.offsetMin = Vector2.zero

	local var0_6 = arg0_6:findTF("BtnList")

	arg0_6.likeFilteBtn = arg0_6:findTF("LikeFilterBtn", var0_6)
	arg0_6.readFilteBtn = arg0_6:findTF("ReadFilteBtn", var0_6)
	arg0_6.orderBtn = arg0_6:findTF("OrderBtn", var0_6)
	arg0_6.repairBtn = arg0_6:findTF("RepairBtn", var0_6)
	arg0_6.scrollView = arg0_6:findTF("ScrollView")
	arg0_6.emptyPanel = arg0_6:findTF("EmptyPanel")
	arg0_6.downloadBtnPanel = arg0_6:findTF("UpdatePanel")
	arg0_6.mangaContainer = arg0_6:findTF("ScrollView/Content")
	arg0_6.lScrollRectSC = arg0_6:findTF("ScrollView/Content"):GetComponent("LScrollRect")
	arg0_6.mangaTpl = arg0_6:findTF("MangaTpl")

	arg0_6.lScrollRectSC:BeginLayout()
	arg0_6.lScrollRectSC:EndLayout()
	arg0_6:initUIText()
end

function var0_0.initUIText(arg0_7)
	local var0_7 = arg0_7:findTF("ShowingAll/Text", arg0_7.readFilteBtn)
	local var1_7 = arg0_7:findTF("ShowingNotRead/Text", arg0_7.readFilteBtn)
	local var2_7 = arg0_7:findTF("Content/Bottom/BottomNotRead/Tag/Text", arg0_7.mangaTpl)
	local var3_7 = arg0_7:findTF("Text", arg0_7.emptyPanel)

	setText(var0_7, i18n("cartoon_notall"))
	setText(var1_7, i18n("cartoon_notall"))
	setText(var2_7, i18n("cartoon_notall"))
	setText(var3_7, i18n("cartoon_haveno"))
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.likeFilteBtn, function()
		arg0_8.isShowLike = not arg0_8.isShowLike
		arg0_8.mangaIDListForShow = arg0_8:getMangaIDListForShow()

		arg0_8:updateBtnList()
		arg0_8:updatePanel()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.readFilteBtn, function()
		arg0_8.isShowNotRead = not arg0_8.isShowNotRead
		arg0_8.mangaIDListForShow = arg0_8:getMangaIDListForShow()

		arg0_8:updateBtnList()
		arg0_8:updatePanel()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.orderBtn, function()
		arg0_8.isUpOrder = not arg0_8.isUpOrder
		arg0_8.mangaIDListForShow = arg0_8:getMangaIDListForShow()

		arg0_8:updateBtnList()
		arg0_8:updatePanel()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.repairBtn, function()
		local var0_12 = {
			text = i18n("msgbox_repair"),
			onCallback = function()
				if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-manga.csv") then
					arg0_8.group:StartVerifyForLua()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
				end
			end
		}

		if IsUnityEditor then
			PlayerPrefs.SetInt("mangaVersion", 0)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				var0_12
			}
		})
	end, SFX_PANEL)
end

function var0_0.updateMangaTpl(arg0_14, arg1_14, arg2_14)
	local var0_14 = tf(arg2_14)
	local var1_14 = arg0_14.mangaIDListForShow[arg1_14]

	assert(var1_14, "null mangaID")

	local var2_14 = arg0_14:findTF("Update", var0_14)

	setActive(var2_14, false)

	local var3_14 = arg0_14:findTF("Content/Mask/Pic", var0_14)
	local var4_14 = arg0_14:findTF("Content/Bottom/BottomNew", var0_14)
	local var5_14 = arg0_14:findTF("Content/Bottom/BottomNotRead", var0_14)
	local var6_14 = arg0_14:findTF("Content/Bottom/BottomNormal", var0_14)
	local var7_14 = arg0_14:findTF("Content/Bottom/BottomTip", var0_14)
	local var8_14 = arg0_14:findTF("TopSpecial", var0_14)
	local var9_14 = arg0_14:findTF("NumText", var4_14)
	local var10_14 = arg0_14:findTF("NumText", var5_14)
	local var11_14 = arg0_14:findTF("NumText", var6_14)
	local var12_14 = MangaConst.isMangaEverReadByID(var1_14)
	local var13_14 = MangaConst.isMangaNewByID(var1_14)

	setActive(var7_14, false)
	setActive(var4_14, not var12_14)
	setActive(var5_14, false)
	setActive(var6_14, var12_14)
	setActive(var8_14, not var12_14)
	setText(var9_14, "#" .. pg.cartoon[var1_14].cartoon_id)
	setText(var10_14, "#" .. pg.cartoon[var1_14].cartoon_id)
	setText(var11_14, "#" .. pg.cartoon[var1_14].cartoon_id)
	removeOnButton(var0_14)
	onButton(arg0_14, var0_14, function()
		arg0_14:openMangaViewLayer(arg1_14)
	end, SFX_PANEL)

	local var14_14 = pg.cartoon[var1_14].resource
	local var15_14 = MangaConst.MANGA_PATH_PREFIX .. var14_14
	local var16_14 = GetComponent(var3_14, "Image").sprite

	if not IsNil(var16_14) then
		if var16_14.name ~= var14_14 then
			arg0_14.resLoader:LoadSprite(var15_14, var14_14, var3_14, false)
		end
	else
		arg0_14.resLoader:LoadSprite(var15_14, var14_14, var3_14, false)
	end
end

function var0_0.initEmpty(arg0_16, arg1_16)
	local var0_16 = tf(arg1_16)
	local var1_16 = arg0_16:findTF("TopSpecial", var0_16)

	setActive(var1_16, false)

	local var2_16 = arg0_16:findTF("Content/Bottom/BottomNew", var0_16)
	local var3_16 = arg0_16:findTF("Content/Bottom/BottomNotRead", var0_16)
	local var4_16 = arg0_16:findTF("Content/Bottom/BottomNormal", var0_16)
	local var5_16 = arg0_16:findTF("Content/Bottom/BottomTip", var0_16)

	setActive(var2_16, false)
	setActive(var3_16, false)
	setActive(var4_16, false)
	setActive(var5_16, true)

	local var6_16 = arg0_16:findTF("Update", var0_16)
	local var7_16 = arg0_16:findTF("Btn", var6_16)
	local var8_16 = arg0_16:findTF("Progress", var6_16)
	local var9_16 = arg0_16:findTF("Slider", var8_16)

	setActive(var6_16, true)
	setActive(var7_16, true)
	setActive(var8_16, false)

	local var10_16
	local var11_16

	for iter0_16, iter1_16 in ipairs(pg.cartoon.all) do
		local var12_16 = pg.cartoon[iter1_16].resource
		local var13_16 = MangaConst.MANGA_PATH_PREFIX .. var12_16

		if checkABExist(var13_16) then
			var10_16 = var12_16
			var11_16 = var13_16

			break
		end
	end

	local var14_16 = arg0_16:findTF("Content/Mask/Pic", var0_16)

	arg0_16.resLoader:LoadSprite(var11_16, var10_16, var14_16, false)
	setText(arg0_16:findTF("Text", var5_16), "")
	onButton(arg0_16, var7_16, function()
		local var0_17 = arg0_16.group.state

		if var0_17 == DownloadState.None or var0_17 == DownloadState.CheckFailure then
			arg0_16.group:CheckD()
		elseif var0_17 == DownloadState.CheckToUpdate or var0_17 == DownloadState.UpdateFailure then
			local var1_17 = GroupHelper.GetGroupSize(var0_0.MangaGroupName)
			local var2_17 = HashUtil.BytesToString(var1_17)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2_17)),
				onYes = function()
					arg0_16.group:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0_16:startUpdateEmpty(arg1_16)
end

function var0_0.updateEmpty(arg0_19, arg1_19)
	local var0_19 = tf(arg1_19)
	local var1_19 = arg0_19:findTF("Update", var0_19)
	local var2_19 = arg0_19:findTF("Btn", var1_19)
	local var3_19 = arg0_19:findTF("Text", var2_19)
	local var4_19 = arg0_19:findTF("Progress", var1_19)
	local var5_19 = arg0_19:findTF("Slider", var4_19)
	local var6_19 = arg0_19.group.state

	if var6_19 == DownloadState.None then
		setText(var3_19, "None")
		setActive(var2_19, true)
		setActive(var4_19, false)
	elseif var6_19 == DownloadState.Checking then
		setText(var3_19, i18n("word_manga_checking"))
		setActive(var2_19, true)
		setActive(var4_19, false)
	elseif var6_19 == DownloadState.CheckToUpdate then
		setText(var3_19, i18n("word_manga_checktoupdate"))
		setActive(var2_19, true)
		setActive(var4_19, false)
	elseif var6_19 == DownloadState.CheckOver then
		setText(var3_19, "Latest Ver")
		setActive(var2_19, true)
		setActive(var4_19, false)
	elseif var6_19 == DownloadState.CheckFailure then
		setText(var3_19, i18n("word_manga_checkfailure"))
		setActive(var2_19, true)
		setActive(var4_19, false)
	elseif var6_19 == DownloadState.Updating then
		setText(var3_19, i18n("word_manga_updating", arg0_19.group.downloadCount, arg0_19.group.downloadTotal))
		setActive(var2_19, false)
		setActive(var4_19, true)
		setSlider(var5_19, 0, arg0_19.group.downloadTotal, arg0_19.group.downloadCount)
	elseif var6_19 == DownloadState.UpdateSuccess then
		setText(var3_19, i18n("word_manga_updatesuccess"))
		setActive(var2_19, true)
		setActive(var4_19, false)

		arg0_19.mangaIDListForShow = arg0_19:getMangaIDListForShow()

		arg0_19:updatePanel()
	elseif var6_19 == DownloadState.UpdateFailure then
		setText(var3_19, i18n("word_manga_updatefailure"))
		setActive(var2_19, true)
		setActive(var4_19, false)
	end
end

function var0_0.startUpdateEmpty(arg0_20, arg1_20)
	if arg0_20.timer then
		arg0_20.timer:Stop()
	end

	arg0_20.timer = Timer.New(function()
		arg0_20:updateEmpty(arg1_20)
	end, 0.5, -1)

	arg0_20.timer:Start()
	arg0_20:updateEmpty(arg1_20)
end

function var0_0.stopUpdateEmpty(arg0_22, arg1_22)
	if arg0_22.timer then
		arg0_22.timer:Stop()
	end
end

function var0_0.updateMangaList(arg0_23)
	arg0_23.resLoader:Clear()

	function arg0_23.lScrollRectSC.onReturnItem(arg0_24, arg1_24)
		arg0_24 = arg0_24 + 1

		if arg0_23.mangaIDListForShow[arg0_24] == false then
			arg0_23:stopUpdateEmpty(arg1_24)
		end
	end

	function arg0_23.lScrollRectSC.onUpdateItem(arg0_25, arg1_25)
		arg0_25 = arg0_25 + 1

		if arg0_23.mangaIDListForShow[arg0_25] == false then
			arg0_23:initEmpty(arg1_25)
			arg0_23:updateEmpty(arg1_25)
		else
			arg0_23:updateMangaTpl(arg0_25, arg1_25)
		end
	end

	arg0_23.lScrollRectSC:SetTotalCount(#arg0_23.mangaIDListForShow)
end

function var0_0.initDownloadBtnPanel(arg0_26)
	local var0_26 = arg0_26:findTF("Btn", arg0_26.downloadBtnPanel)
	local var1_26 = arg0_26:findTF("Text", var0_26)
	local var2_26 = arg0_26:findTF("Progress", arg0_26.downloadBtnPanel)
	local var3_26 = arg0_26:findTF("Slider", var2_26)

	setActive(var0_26, true)
	setActive(var2_26, false)
	onButton(arg0_26, var0_26, function()
		local var0_27 = arg0_26.group.state

		if var0_27 == DownloadState.None or var0_27 == DownloadState.CheckFailure then
			arg0_26.group:CheckD()
		elseif var0_27 == DownloadState.CheckToUpdate or var0_27 == DownloadState.UpdateFailure then
			local var1_27 = GroupHelper.GetGroupSize(var0_0.MangaGroupName)
			local var2_27 = HashUtil.BytesToString(var1_27)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2_27)),
				onYes = function()
					arg0_26.group:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0_26:startUpdateDownloadBtnPanel()
end

function var0_0.updateDownloadBtnPanel(arg0_29)
	local var0_29 = arg0_29:findTF("Btn", arg0_29.downloadBtnPanel)
	local var1_29 = arg0_29:findTF("Text", var0_29)
	local var2_29 = arg0_29:findTF("Progress", arg0_29.downloadBtnPanel)
	local var3_29 = arg0_29:findTF("Slider", var2_29)
	local var4_29 = arg0_29.group.state

	if var4_29 == DownloadState.None then
		setText(var1_29, "None")
		setActive(var0_29, true)
		setActive(var2_29, false)
	elseif var4_29 == DownloadState.Checking then
		setText(var1_29, i18n("word_manga_checking"))
		setActive(var0_29, true)
		setActive(var2_29, false)
	elseif var4_29 == DownloadState.CheckToUpdate then
		setText(var1_29, i18n("word_manga_checktoupdate"))
		setActive(var0_29, true)
		setActive(var2_29, false)
	elseif var4_29 == DownloadState.CheckOver then
		setText(var1_29, "Latest Ver")
		setActive(var0_29, true)
		setActive(var2_29, false)
	elseif var4_29 == DownloadState.CheckFailure then
		setText(var1_29, i18n("word_manga_checkfailure"))
		setActive(var0_29, true)
		setActive(var2_29, false)
	elseif var4_29 == DownloadState.Updating then
		setText(var1_29, i18n("word_manga_updating", arg0_29.group.downloadCount, arg0_29.group.downloadTotal))
		setActive(var0_29, false)
		setActive(var2_29, true)
		setSlider(var3_29, 0, arg0_29.group.downloadTotal, arg0_29.group.downloadCount)
	elseif var4_29 == DownloadState.UpdateSuccess then
		setText(var1_29, i18n("word_manga_updatesuccess"))
		setActive(var0_29, true)
		setActive(var2_29, false)

		arg0_29.mangaIDListForShow = arg0_29:getMangaIDListForShow()

		arg0_29:updatePanel()
	elseif var4_29 == DownloadState.UpdateFailure then
		setText(var1_29, i18n("word_manga_updatefailure"))
		setActive(var0_29, true)
		setActive(var2_29, false)
	end
end

function var0_0.startUpdateDownloadBtnPanel(arg0_30)
	if arg0_30.timer then
		arg0_30.timer:Stop()
	end

	arg0_30.timer = Timer.New(function()
		arg0_30:updateDownloadBtnPanel()
	end, 0.5, -1)

	arg0_30.timer:Start()
	arg0_30:updateDownloadBtnPanel()
end

function var0_0.stopUpdateDownloadBtnPanel(arg0_32)
	if arg0_32.timer then
		arg0_32.timer:Stop()
	end
end

function var0_0.updatePanel(arg0_33)
	local var0_33 = #arg0_33.mangaIDListForShow <= 0
	local var1_33 = #arg0_33.mangaIDListForShow == 1 and arg0_33.mangaIDListForShow[1] == false

	setActive(arg0_33.emptyPanel, var0_33)
	setActive(arg0_33.downloadBtnPanel, var1_33)
	setActive(arg0_33.scrollView, not var0_33 and not var1_33)
	arg0_33:stopUpdateEmpty()
	arg0_33:stopUpdateDownloadBtnPanel()

	if not var0_33 and not var1_33 then
		arg0_33:updateMangaList()
	elseif var1_33 then
		arg0_33:initDownloadBtnPanel()
	end
end

function var0_0.updateBtnList(arg0_34)
	local var0_34 = arg0_34:findTF("On", arg0_34.likeFilteBtn)

	setActive(var0_34, arg0_34.isShowLike)

	local var1_34 = arg0_34:findTF("ShowingAll", arg0_34.readFilteBtn)
	local var2_34 = arg0_34:findTF("ShowingNotRead", arg0_34.readFilteBtn)

	setActive(var1_34, not arg0_34.isShowNotRead)
	setActive(var2_34, arg0_34.isShowNotRead)

	local var3_34 = arg0_34:findTF("Up", arg0_34.orderBtn)
	local var4_34 = arg0_34:findTF("Down", arg0_34.orderBtn)

	setActive(var3_34, arg0_34.isUpOrder)
	setActive(var4_34, not arg0_34.isUpOrder)
end

function var0_0.tryShowTipMsgBox(arg0_35)
	if arg0_35.appreciateProxy:isMangaHaveNewRes() then
		local function var0_35()
			PlayerPrefs.SetInt("mangaVersion", MangaConst.Version)
			arg0_35:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_cartoon_new_tip", MangaConst.NewCount),
			onYes = var0_35,
			onCancel = var0_35,
			onClose = var0_35
		})
	end
end

function var0_0.openMangaViewLayer(arg0_37, arg1_37)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = MangaFullScreenMediator,
		viewComponent = MangaFullScreenLayer,
		data = {
			mangaIndex = arg1_37,
			mangaIDLIst = arg0_37.mangaIDListForShow,
			mangaContext = arg0_37,
			isShowingNotRead = isActive(arg0_37:findTF("ShowingNotRead", arg0_37.readFilteBtn))
		},
		onRemoved = function()
			return
		end
	}))
end

function var0_0.updateLineAfterRead(arg0_39, arg1_39)
	local var0_39 = table.indexof(arg0_39.mangaIDListForShow, arg1_39) - 1
	local var1_39 = arg0_39:findTF(tostring(var0_39), arg0_39.mangaContainer)

	if var1_39 then
		local var2_39 = arg0_39:findTF("Content/Bottom/BottomNew", var1_39)
		local var3_39 = arg0_39:findTF("Content/Bottom/BottomNotRead", var1_39)
		local var4_39 = arg0_39:findTF("Content/Bottom/BottomNormal", var1_39)
		local var5_39 = arg0_39:findTF("TopSpecial", var1_39)
		local var6_39 = MangaConst.isMangaEverReadByID(arg1_39)
		local var7_39 = MangaConst.isMangaNewByID(arg1_39)

		setActive(var2_39, var7_39 and not var6_39)
		setActive(var3_39, not var7_39 and not var6_39)
		setActive(var4_39, var6_39)
		setActive(var5_39, not var6_39)
	end
end

function var0_0.updateToMangaID(arg0_40, arg1_40)
	local var0_40 = table.indexof(arg0_40.mangaIDListForShow, arg1_40) - 1
	local var1_40 = arg0_40.lScrollRectSC:HeadIndexToValue(var0_40)

	arg0_40.lScrollRectSC:SetTotalCount(#arg0_40.mangaIDListForShow, defaultValue(var1_40, -1))
end

function var0_0.getMangaIDListForShow(arg0_41, arg1_41)
	local var0_41 = {}

	for iter0_41, iter1_41 in ipairs(pg.cartoon.all) do
		if arg0_41:isMangaExist(iter1_41) then
			local var1_41 = MangaConst.isMangaEverReadByID(iter1_41)
			local var2_41 = MangaConst.isMangaLikeByID(iter1_41)

			if arg0_41.isShowNotRead and arg0_41.isShowLike then
				if not var1_41 and var2_41 then
					table.insert(var0_41, iter1_41)
				end
			elseif arg0_41.isShowNotRead and not arg0_41.isShowLike then
				if not var1_41 then
					table.insert(var0_41, iter1_41)
				end
			elseif not arg0_41.isShowNotRead and arg0_41.isShowLike then
				if var2_41 then
					table.insert(var0_41, iter1_41)
				end
			else
				table.insert(var0_41, iter1_41)
			end
		end
	end

	local function var3_41(arg0_42, arg1_42)
		local var0_42 = pg.cartoon[arg0_42]
		local var1_42 = pg.cartoon[arg1_42]
		local var2_42 = var0_42.cartoon_id
		local var3_42 = var1_42.cartoon_id

		if var3_42 < var2_42 then
			return not arg0_41.isUpOrder
		elseif var2_42 == var3_42 then
			return arg0_42 < arg1_42
		elseif var2_42 < var3_42 then
			return arg0_41.isUpOrder
		end
	end

	table.sort(var0_41, var3_41)

	if arg0_41:isNeedShowDownBtn() then
		table.insert(var0_41, 1, false)
	end

	return var0_41
end

function var0_0.isMangaExist(arg0_43, arg1_43)
	local var0_43 = MangaConst.MANGA_PATH_PREFIX .. arg1_43
	local var1_43 = arg0_43.group:CheckF(var0_43)

	return var1_43 == DownloadState.None or var1_43 == DownloadState.UpdateSuccess
end

function var0_0.isNeedShowDownBtn(arg0_44)
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0_0.MangaGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0_0.MangaGroupName) then
		return false
	end

	return true
end

return var0_0
