local var0 = class("MangaView", import("..base.BaseSubView"))

var0.MangaGroupName = "MANGA"

function var0.getUIName(arg0)
	return "MangaUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
	arg0:updateBtnList()
	arg0:Show()
	arg0:updatePanel()
	arg0:tryShowTipMsgBox()
end

function var0.OnDestroy(arg0)
	arg0.resLoader:Clear()
	arg0:stopUpdateEmpty()
	arg0:stopUpdateDownloadBtnPanel()
end

function var0.onBackPressed(arg0)
	return true
end

function var0.initData(arg0)
	arg0.appreciateProxy = getProxy(AppreciateProxy)
	arg0.resLoader = AutoLoader.New()
	arg0.isShowNotRead = false
	arg0.isShowLike = false
	arg0.isUpOrder = false
	arg0.group = GroupHelper.GetGroupMgrByName(var0.MangaGroupName)
	arg0.mangaIDListForShow = arg0:getMangaIDListForShow()
end

function var0.initUI(arg0)
	setLocalPosition(arg0._tf, Vector2.zero)

	arg0._tf.anchorMin = Vector2.zero
	arg0._tf.anchorMax = Vector2.one
	arg0._tf.offsetMax = Vector2.zero
	arg0._tf.offsetMin = Vector2.zero

	local var0 = arg0:findTF("BtnList")

	arg0.likeFilteBtn = arg0:findTF("LikeFilterBtn", var0)
	arg0.readFilteBtn = arg0:findTF("ReadFilteBtn", var0)
	arg0.orderBtn = arg0:findTF("OrderBtn", var0)
	arg0.repairBtn = arg0:findTF("RepairBtn", var0)
	arg0.scrollView = arg0:findTF("ScrollView")
	arg0.emptyPanel = arg0:findTF("EmptyPanel")
	arg0.downloadBtnPanel = arg0:findTF("UpdatePanel")
	arg0.mangaContainer = arg0:findTF("ScrollView/Content")
	arg0.lScrollRectSC = arg0:findTF("ScrollView/Content"):GetComponent("LScrollRect")
	arg0.mangaTpl = arg0:findTF("MangaTpl")

	arg0.lScrollRectSC:BeginLayout()
	arg0.lScrollRectSC:EndLayout()
	arg0:initUIText()
end

function var0.initUIText(arg0)
	local var0 = arg0:findTF("ShowingAll/Text", arg0.readFilteBtn)
	local var1 = arg0:findTF("ShowingNotRead/Text", arg0.readFilteBtn)
	local var2 = arg0:findTF("Content/Bottom/BottomNotRead/Tag/Text", arg0.mangaTpl)
	local var3 = arg0:findTF("Text", arg0.emptyPanel)

	setText(var0, i18n("cartoon_notall"))
	setText(var1, i18n("cartoon_notall"))
	setText(var2, i18n("cartoon_notall"))
	setText(var3, i18n("cartoon_haveno"))
end

function var0.addListener(arg0)
	onButton(arg0, arg0.likeFilteBtn, function()
		arg0.isShowLike = not arg0.isShowLike
		arg0.mangaIDListForShow = arg0:getMangaIDListForShow()

		arg0:updateBtnList()
		arg0:updatePanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.readFilteBtn, function()
		arg0.isShowNotRead = not arg0.isShowNotRead
		arg0.mangaIDListForShow = arg0:getMangaIDListForShow()

		arg0:updateBtnList()
		arg0:updatePanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.orderBtn, function()
		arg0.isUpOrder = not arg0.isUpOrder
		arg0.mangaIDListForShow = arg0:getMangaIDListForShow()

		arg0:updateBtnList()
		arg0:updatePanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.repairBtn, function()
		local var0 = {
			text = i18n("msgbox_repair"),
			onCallback = function()
				if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-manga.csv") then
					arg0.group:StartVerifyForLua()
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
				var0
			}
		})
	end, SFX_PANEL)
end

function var0.updateMangaTpl(arg0, arg1, arg2)
	local var0 = tf(arg2)
	local var1 = arg0.mangaIDListForShow[arg1]

	assert(var1, "null mangaID")

	local var2 = arg0:findTF("Update", var0)

	setActive(var2, false)

	local var3 = arg0:findTF("Content/Mask/Pic", var0)
	local var4 = arg0:findTF("Content/Bottom/BottomNew", var0)
	local var5 = arg0:findTF("Content/Bottom/BottomNotRead", var0)
	local var6 = arg0:findTF("Content/Bottom/BottomNormal", var0)
	local var7 = arg0:findTF("Content/Bottom/BottomTip", var0)
	local var8 = arg0:findTF("TopSpecial", var0)
	local var9 = arg0:findTF("NumText", var4)
	local var10 = arg0:findTF("NumText", var5)
	local var11 = arg0:findTF("NumText", var6)
	local var12 = MangaConst.isMangaEverReadByID(var1)
	local var13 = MangaConst.isMangaNewByID(var1)

	setActive(var7, false)
	setActive(var4, not var12)
	setActive(var5, false)
	setActive(var6, var12)
	setActive(var8, not var12)
	setText(var9, "#" .. pg.cartoon[var1].cartoon_id)
	setText(var10, "#" .. pg.cartoon[var1].cartoon_id)
	setText(var11, "#" .. pg.cartoon[var1].cartoon_id)
	removeOnButton(var0)
	onButton(arg0, var0, function()
		arg0:openMangaViewLayer(arg1)
	end, SFX_PANEL)

	local var14 = pg.cartoon[var1].resource
	local var15 = MangaConst.MANGA_PATH_PREFIX .. var14
	local var16 = GetComponent(var3, "Image").sprite

	if not IsNil(var16) then
		if var16.name ~= var14 then
			arg0.resLoader:LoadSprite(var15, var14, var3, false)
		end
	else
		arg0.resLoader:LoadSprite(var15, var14, var3, false)
	end
end

function var0.initEmpty(arg0, arg1)
	local var0 = tf(arg1)
	local var1 = arg0:findTF("TopSpecial", var0)

	setActive(var1, false)

	local var2 = arg0:findTF("Content/Bottom/BottomNew", var0)
	local var3 = arg0:findTF("Content/Bottom/BottomNotRead", var0)
	local var4 = arg0:findTF("Content/Bottom/BottomNormal", var0)
	local var5 = arg0:findTF("Content/Bottom/BottomTip", var0)

	setActive(var2, false)
	setActive(var3, false)
	setActive(var4, false)
	setActive(var5, true)

	local var6 = arg0:findTF("Update", var0)
	local var7 = arg0:findTF("Btn", var6)
	local var8 = arg0:findTF("Progress", var6)
	local var9 = arg0:findTF("Slider", var8)

	setActive(var6, true)
	setActive(var7, true)
	setActive(var8, false)

	local var10
	local var11

	for iter0, iter1 in ipairs(pg.cartoon.all) do
		local var12 = pg.cartoon[iter1].resource
		local var13 = MangaConst.MANGA_PATH_PREFIX .. var12

		if checkABExist(var13) then
			var10 = var12
			var11 = var13

			break
		end
	end

	local var14 = arg0:findTF("Content/Mask/Pic", var0)

	arg0.resLoader:LoadSprite(var11, var10, var14, false)
	setText(arg0:findTF("Text", var5), "")
	onButton(arg0, var7, function()
		local var0 = arg0.group.state

		if var0 == DownloadState.None or var0 == DownloadState.CheckFailure then
			arg0.group:CheckD()
		elseif var0 == DownloadState.CheckToUpdate or var0 == DownloadState.UpdateFailure then
			local var1 = GroupHelper.GetGroupSize(var0.MangaGroupName)
			local var2 = HashUtil.BytesToString(var1)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2)),
				onYes = function()
					arg0.group:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0:startUpdateEmpty(arg1)
end

function var0.updateEmpty(arg0, arg1)
	local var0 = tf(arg1)
	local var1 = arg0:findTF("Update", var0)
	local var2 = arg0:findTF("Btn", var1)
	local var3 = arg0:findTF("Text", var2)
	local var4 = arg0:findTF("Progress", var1)
	local var5 = arg0:findTF("Slider", var4)
	local var6 = arg0.group.state

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
		setText(var3, i18n("word_manga_updating", arg0.group.downloadCount, arg0.group.downloadTotal))
		setActive(var2, false)
		setActive(var4, true)
		setSlider(var5, 0, arg0.group.downloadTotal, arg0.group.downloadCount)
	elseif var6 == DownloadState.UpdateSuccess then
		setText(var3, i18n("word_manga_updatesuccess"))
		setActive(var2, true)
		setActive(var4, false)

		arg0.mangaIDListForShow = arg0:getMangaIDListForShow()

		arg0:updatePanel()
	elseif var6 == DownloadState.UpdateFailure then
		setText(var3, i18n("word_manga_updatefailure"))
		setActive(var2, true)
		setActive(var4, false)
	end
end

function var0.startUpdateEmpty(arg0, arg1)
	if arg0.timer then
		arg0.timer:Stop()
	end

	arg0.timer = Timer.New(function()
		arg0:updateEmpty(arg1)
	end, 0.5, -1)

	arg0.timer:Start()
	arg0:updateEmpty(arg1)
end

function var0.stopUpdateEmpty(arg0, arg1)
	if arg0.timer then
		arg0.timer:Stop()
	end
end

function var0.updateMangaList(arg0)
	arg0.resLoader:Clear()

	function arg0.lScrollRectSC.onReturnItem(arg0, arg1)
		arg0 = arg0 + 1

		if arg0.mangaIDListForShow[arg0] == false then
			arg0:stopUpdateEmpty(arg1)
		end
	end

	function arg0.lScrollRectSC.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		if arg0.mangaIDListForShow[arg0] == false then
			arg0:initEmpty(arg1)
			arg0:updateEmpty(arg1)
		else
			arg0:updateMangaTpl(arg0, arg1)
		end
	end

	arg0.lScrollRectSC:SetTotalCount(#arg0.mangaIDListForShow)
end

function var0.initDownloadBtnPanel(arg0)
	local var0 = arg0:findTF("Btn", arg0.downloadBtnPanel)
	local var1 = arg0:findTF("Text", var0)
	local var2 = arg0:findTF("Progress", arg0.downloadBtnPanel)
	local var3 = arg0:findTF("Slider", var2)

	setActive(var0, true)
	setActive(var2, false)
	onButton(arg0, var0, function()
		local var0 = arg0.group.state

		if var0 == DownloadState.None or var0 == DownloadState.CheckFailure then
			arg0.group:CheckD()
		elseif var0 == DownloadState.CheckToUpdate or var0 == DownloadState.UpdateFailure then
			local var1 = GroupHelper.GetGroupSize(var0.MangaGroupName)
			local var2 = HashUtil.BytesToString(var1)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_NORMAL,
				content = string.format(i18n("group_download_tip", var2)),
				onYes = function()
					arg0.group:UpdateD()
				end
			})
		end
	end, SFX_PANEL)
	arg0:startUpdateDownloadBtnPanel()
end

function var0.updateDownloadBtnPanel(arg0)
	local var0 = arg0:findTF("Btn", arg0.downloadBtnPanel)
	local var1 = arg0:findTF("Text", var0)
	local var2 = arg0:findTF("Progress", arg0.downloadBtnPanel)
	local var3 = arg0:findTF("Slider", var2)
	local var4 = arg0.group.state

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
		setText(var1, i18n("word_manga_updating", arg0.group.downloadCount, arg0.group.downloadTotal))
		setActive(var0, false)
		setActive(var2, true)
		setSlider(var3, 0, arg0.group.downloadTotal, arg0.group.downloadCount)
	elseif var4 == DownloadState.UpdateSuccess then
		setText(var1, i18n("word_manga_updatesuccess"))
		setActive(var0, true)
		setActive(var2, false)

		arg0.mangaIDListForShow = arg0:getMangaIDListForShow()

		arg0:updatePanel()
	elseif var4 == DownloadState.UpdateFailure then
		setText(var1, i18n("word_manga_updatefailure"))
		setActive(var0, true)
		setActive(var2, false)
	end
end

function var0.startUpdateDownloadBtnPanel(arg0)
	if arg0.timer then
		arg0.timer:Stop()
	end

	arg0.timer = Timer.New(function()
		arg0:updateDownloadBtnPanel()
	end, 0.5, -1)

	arg0.timer:Start()
	arg0:updateDownloadBtnPanel()
end

function var0.stopUpdateDownloadBtnPanel(arg0)
	if arg0.timer then
		arg0.timer:Stop()
	end
end

function var0.updatePanel(arg0)
	local var0 = #arg0.mangaIDListForShow <= 0
	local var1 = #arg0.mangaIDListForShow == 1 and arg0.mangaIDListForShow[1] == false

	setActive(arg0.emptyPanel, var0)
	setActive(arg0.downloadBtnPanel, var1)
	setActive(arg0.scrollView, not var0 and not var1)
	arg0:stopUpdateEmpty()
	arg0:stopUpdateDownloadBtnPanel()

	if not var0 and not var1 then
		arg0:updateMangaList()
	elseif var1 then
		arg0:initDownloadBtnPanel()
	end
end

function var0.updateBtnList(arg0)
	local var0 = arg0:findTF("On", arg0.likeFilteBtn)

	setActive(var0, arg0.isShowLike)

	local var1 = arg0:findTF("ShowingAll", arg0.readFilteBtn)
	local var2 = arg0:findTF("ShowingNotRead", arg0.readFilteBtn)

	setActive(var1, not arg0.isShowNotRead)
	setActive(var2, arg0.isShowNotRead)

	local var3 = arg0:findTF("Up", arg0.orderBtn)
	local var4 = arg0:findTF("Down", arg0.orderBtn)

	setActive(var3, arg0.isUpOrder)
	setActive(var4, not arg0.isUpOrder)
end

function var0.tryShowTipMsgBox(arg0)
	if arg0.appreciateProxy:isMangaHaveNewRes() then
		local function var0()
			PlayerPrefs.SetInt("mangaVersion", MangaConst.Version)
			arg0:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_cartoon_new_tip", MangaConst.NewCount),
			onYes = var0,
			onCancel = var0,
			onClose = var0
		})
	end
end

function var0.openMangaViewLayer(arg0, arg1)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = MangaFullScreenMediator,
		viewComponent = MangaFullScreenLayer,
		data = {
			mangaIndex = arg1,
			mangaIDLIst = arg0.mangaIDListForShow,
			mangaContext = arg0,
			isShowingNotRead = isActive(arg0:findTF("ShowingNotRead", arg0.readFilteBtn))
		},
		onRemoved = function()
			return
		end
	}))
end

function var0.updateLineAfterRead(arg0, arg1)
	local var0 = table.indexof(arg0.mangaIDListForShow, arg1) - 1
	local var1 = arg0:findTF(tostring(var0), arg0.mangaContainer)

	if var1 then
		local var2 = arg0:findTF("Content/Bottom/BottomNew", var1)
		local var3 = arg0:findTF("Content/Bottom/BottomNotRead", var1)
		local var4 = arg0:findTF("Content/Bottom/BottomNormal", var1)
		local var5 = arg0:findTF("TopSpecial", var1)
		local var6 = MangaConst.isMangaEverReadByID(arg1)
		local var7 = MangaConst.isMangaNewByID(arg1)

		setActive(var2, var7 and not var6)
		setActive(var3, not var7 and not var6)
		setActive(var4, var6)
		setActive(var5, not var6)
	end
end

function var0.updateToMangaID(arg0, arg1)
	local var0 = table.indexof(arg0.mangaIDListForShow, arg1) - 1
	local var1 = arg0.lScrollRectSC:HeadIndexToValue(var0)

	arg0.lScrollRectSC:SetTotalCount(#arg0.mangaIDListForShow, defaultValue(var1, -1))
end

function var0.getMangaIDListForShow(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.cartoon.all) do
		if arg0:isMangaExist(iter1) then
			local var1 = MangaConst.isMangaEverReadByID(iter1)
			local var2 = MangaConst.isMangaLikeByID(iter1)

			if arg0.isShowNotRead and arg0.isShowLike then
				if not var1 and var2 then
					table.insert(var0, iter1)
				end
			elseif arg0.isShowNotRead and not arg0.isShowLike then
				if not var1 then
					table.insert(var0, iter1)
				end
			elseif not arg0.isShowNotRead and arg0.isShowLike then
				if var2 then
					table.insert(var0, iter1)
				end
			else
				table.insert(var0, iter1)
			end
		end
	end

	local function var3(arg0, arg1)
		local var0 = pg.cartoon[arg0]
		local var1 = pg.cartoon[arg1]
		local var2 = var0.cartoon_id
		local var3 = var1.cartoon_id

		if var3 < var2 then
			return not arg0.isUpOrder
		elseif var2 == var3 then
			return arg0 < arg1
		elseif var2 < var3 then
			return arg0.isUpOrder
		end
	end

	table.sort(var0, var3)

	if arg0:isNeedShowDownBtn() then
		table.insert(var0, 1, false)
	end

	return var0
end

function var0.isMangaExist(arg0, arg1)
	local var0 = MangaConst.MANGA_PATH_PREFIX .. arg1
	local var1 = arg0.group:CheckF(var0)

	return var1 == DownloadState.None or var1 == DownloadState.UpdateSuccess
end

function var0.isNeedShowDownBtn(arg0)
	if Application.isEditor then
		return false
	end

	if GroupHelper.IsGroupVerLastest(var0.MangaGroupName) then
		return false
	end

	if not GroupHelper.IsGroupWaitToUpdate(var0.MangaGroupName) then
		return false
	end

	return true
end

return var0
