local var0_0 = class("CryptolaliaScene", import("view.base.BaseUI"))

var0_0.ON_UNLOCK = "CryptolaliaScene:ON_UNLOCK"
var0_0.ON_DELETE = "CryptolaliaScene:ON_DELETE"
var0_0.ON_SELECT = "CryptolaliaScene:ON_SELECT"

function var0_0.getUIName(arg0_1)
	return "CryptolaliaUI"
end

function var0_0.SetCryptolaliaList(arg0_2, arg1_2)
	arg0_2.cryptolaliaList = arg1_2
end

function var0_0.init(arg0_3)
	arg0_3.cg = arg0_3._tf:GetComponent(typeof(CanvasGroup))
	arg0_3.backBtn = arg0_3:findTF("Top/blur_panel/adapt/top/back_btn")
	arg0_3.auditionBtn = arg0_3:findTF("Main/audition/toggle")
	arg0_3.auditionBtnOn = arg0_3:findTF("Main/audition/toggle/on")
	arg0_3.auditionBtnOff = arg0_3:findTF("Main/audition/toggle/off")
	arg0_3.cdImg = arg0_3:findTF("Main/cd"):GetComponent(typeof(Image))
	arg0_3.cdSignatureImg = arg0_3:findTF("Main/cd/signature"):GetComponent(typeof(Image))
	arg0_3.shipName = arg0_3:findTF("Main/cd/name"):GetComponent(typeof(Text))
	arg0_3.timeLimit = arg0_3:findTF("Main/cd/timelimit")
	arg0_3.timeTxt = arg0_3:findTF("Main/cd/timelimit/Text"):GetComponent(typeof(Text))
	arg0_3.nameTxt = arg0_3:findTF("Main/name"):GetComponent(typeof(Text))
	arg0_3.authorTxt = arg0_3:findTF("Main/author"):GetComponent(typeof(Text))
	arg0_3.descTxt = arg0_3:findTF("Main/desc"):GetComponent(typeof(Text))
	arg0_3.signatureImg = arg0_3:findTF("Main/desc/signature"):GetComponent(typeof(Image))
	arg0_3.auditionTxt = arg0_3:findTF("Main/audition/mask/Text"):GetComponent("ScrollText")
	arg0_3.auditionEffect = arg0_3:findTF("Main/audition/p2/Lines"):GetComponent(typeof(Animation))

	arg0_3.auditionEffect:Play("anim_line_reset")

	arg0_3.btnsTr = arg0_3:findTF("Main/btns")
	arg0_3.lockBtn = arg0_3.btnsTr:Find("lock")
	arg0_3.downloadBtn = arg0_3.btnsTr:Find("download")
	arg0_3.downloadingBtn = arg0_3.btnsTr:Find("downloading")
	arg0_3.playBtn = arg0_3.btnsTr:Find("play")
	arg0_3.playPrevBtn = arg0_3.btnsTr:Find("play/prev")
	arg0_3.playNextBtn = arg0_3.btnsTr:Find("play/next")
	arg0_3.deleteBtn = arg0_3.btnsTr:Find("delete")
	arg0_3.stateBtn = arg0_3.btnsTr:Find("state")
	arg0_3.stateBtnTxt = arg0_3.stateBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_3.switchBtn = arg0_3.btnsTr:Find("switch")
	arg0_3.listBtn = arg0_3.btnsTr:Find("list")
	arg0_3.optionBtn = arg0_3:findTF("Top/blur_panel/adapt/top/option")
	arg0_3.purchaseWindow = CryptolaliaPurchaseWindow.New(arg0_3._tf, arg0_3.event)
	arg0_3.resDeleteWindow = CryptolaliaResDeleteWindow.New(arg0_3._tf, arg0_3.event)
	arg0_3.downloadMgr = CryptolaliaDownloadMgr.New()
	arg0_3.soundPlayer = CryptolaliaSoundPlayer.New()
	arg0_3.mainView = CryptolaliaMainView.New(arg0_3)
	arg0_3.listView = CryptolaliaListView.New(arg0_3._tf, arg0_3.event)

	local var0_3 = CryptolaliaScrollRectAnimation.New(arg0_3._tf)

	arg0_3.scrollRect = CryptolaliaScrollRect.New(arg0_3:findTF("Main/list/tpl"), var0_3)

	arg0_3.scrollRect:Make(function(arg0_4)
		arg0_3:OnItemUpdate(arg0_4)
	end, function(arg0_5)
		arg0_3:OnItemSelected(arg0_5:GetInitIndex())
	end)

	arg0_3.dftAniEvent = arg0_3._tf:GetComponent(typeof(DftAniEvent))

	setText(arg0_3:findTF("Main/cd/timelimit/label"), i18n("cryptolalia_timelimie"))
	setText(arg0_3.downloadingBtn:Find("label"), i18n("cryptolalia_label_downloading"))

	Input.multiTouchEnabled = false
end

function var0_0.didEnter(arg0_6)
	arg0_6.cards = {}
	arg0_6.downloadReqList = {}

	parallelAsync({
		function(arg0_7)
			arg0_6.dftAniEvent:SetEndEvent(arg0_7)
		end,
		function(arg0_8)
			arg0_6:InitCryptolaliaList(arg0_8)
		end
	}, function()
		arg0_6.dftAniEvent:SetEndEvent(nil)
		arg0_6.scrollRect:SetUp()
		arg0_6:ActiveDefault()
		arg0_6:RegisterEvent()
	end)
end

function var0_0.ActiveDefault(arg0_10)
	if not arg0_10.contextData.groupId then
		return
	end

	local var0_10 = -1

	for iter0_10, iter1_10 in ipairs(arg0_10.displays) do
		if iter1_10 and iter1_10:IsSameGroup(arg0_10.contextData.groupId) then
			var0_10 = iter0_10

			break
		end
	end

	if var0_10 <= 0 then
		return
	end

	for iter2_10, iter3_10 in pairs(arg0_10.cards) do
		if iter3_10:GetInitIndex() == var0_10 then
			triggerButton(iter3_10._go)

			break
		end
	end
end

function var0_0.OnItemUpdate(arg0_11, arg1_11)
	local var0_11 = arg0_11.displays[arg1_11:GetInitIndex()]

	arg1_11:Interactable(false)

	if not var0_11 then
		return
	end

	arg1_11:Interactable(true)

	local var1_11 = var0_11:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var1_11, "icon", function(arg0_12)
		arg1_11:UpdateSprite(arg0_12)
	end)

	arg0_11.cards[var0_11.id] = arg1_11
end

function var0_0.OnItemSelected(arg0_13, arg1_13)
	local var0_13 = arg0_13.displays[arg1_13]

	if not var0_13 then
		return
	end

	if not arg0_13.langType or not var0_13:ExistLang(arg0_13.langType) or arg0_13.selectedIndex ~= arg1_13 then
		arg0_13.langType = var0_13:GetDefaultLangType()
	end

	local var1_13 = var0_13:GetCpkName(arg0_13.langType)
	local var2_13 = Cryptolalia.BuildCpkPath(var1_13)
	local var3_13 = arg0_13.downloadMgr:IsDownloadState(var2_13)

	if var3_13 and arg0_13.downloadReqList[var0_13.id] == nil then
		arg0_13:OnUpdateForResDownload("ReConnection", var0_13, arg1_13)
	end

	arg0_13.mainView:Flush(var0_13, arg0_13.langType, var3_13)

	arg0_13.selectedIndex = arg1_13

	if arg0_13.auditionFlag then
		triggerButton(arg0_13.auditionBtn)
	end
end

function var0_0.Filter(arg0_14)
	local var0_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.cryptolaliaList or {}) do
		if iter1_14:InTime() or not iter1_14:IsLock() then
			table.insert(var0_14, iter1_14)
		end
	end

	table.sort(var0_14, function(arg0_15, arg1_15)
		local var0_15 = arg0_15:GetSortIndex()
		local var1_15 = arg1_15:GetSortIndex()

		if var0_15 == var1_15 then
			return arg0_15.id < arg1_15.id
		else
			return var0_15 < var1_15
		end
	end)

	return var0_14
end

function var0_0.InitCryptolaliaList(arg0_16, arg1_16)
	local var0_16 = arg0_16:Filter()

	arg0_16.displays = arg0_16:FillEmptyDisplayIfNeed(var0_16)

	arg0_16.scrollRect:Align(#arg0_16.displays, arg1_16)
end

function var0_0.FillEmptyDisplayIfNeed(arg0_17, arg1_17)
	local var0_17 = {}

	for iter0_17 = 1, math.max(5, #arg1_17) do
		local var1_17 = defaultValue(arg1_17[iter0_17], false)

		if iter0_17 % 2 == 0 then
			table.insert(var0_17, var1_17)
		else
			table.insert(var0_17, 1, var1_17)
		end
	end

	return var0_17
end

function var0_0.RegisterEvent(arg0_18)
	arg0_18:bind(var0_0.ON_UNLOCK, function(arg0_19, arg1_19)
		arg0_18:OnUnlockCryptolalia(arg1_19)
	end)
	arg0_18:bind(var0_0.ON_DELETE, function(arg0_20)
		if not arg0_18.selectedIndex then
			return
		end

		arg0_18:OnItemSelected(arg0_18.selectedIndex)
	end)
	arg0_18:bind(var0_0.ON_SELECT, function(arg0_21, arg1_21)
		local var0_21 = arg0_18.cards[arg1_21]

		if var0_21 then
			triggerButton(var0_21._go)
		end
	end)
	onButton(arg0_18, arg0_18.optionBtn, function()
		arg0_18:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.backBtn, function()
		arg0_18:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_18, arg0_18.switchBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_24 = arg0_18.displays[arg0_18.selectedIndex]

		if not var0_24 then
			return
		end

		if not var0_24:IsMultiVersion() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_coming_soom"))

			return
		end

		arg0_18.langType = 1 - arg0_18.langType

		arg0_18:OnItemSelected(arg0_18.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.listBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_25 = arg0_18.displays[arg0_18.selectedIndex]

		if var0_25 then
			local var1_25 = arg0_18:Filter()

			arg0_18.listView:ExecuteAction("Show", var1_25, arg0_18.langType, var0_25.id, arg0_18.scrollRect)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.deleteBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_26 = arg0_18.displays[arg0_18.selectedIndex]

		if var0_26 and var0_26:IsPlayableState(arg0_18.langType) then
			arg0_18.resDeleteWindow:ExecuteAction("Show", var0_26, arg0_18.langType)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.playBtn:Find("play"), function()
		if not arg0_18.selectedIndex then
			return
		end

		arg0_18:PlayVedio(arg0_18.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.playNextBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_28 = arg0_18.displays[arg0_18.selectedIndex + 1]

		if var0_28 then
			arg0_18:emit(var0_0.ON_SELECT, var0_28.id)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.playPrevBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_29 = arg0_18.displays[arg0_18.selectedIndex - 1]

		if var0_29 then
			arg0_18:emit(var0_0.ON_SELECT, var0_29.id)
		end
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.downloadBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		arg0_18:DownloadRes(arg0_18.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.lockBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_31 = arg0_18.displays[arg0_18.selectedIndex]

		if var0_31 and var0_31:IsLockState() then
			arg0_18.purchaseWindow:ExecuteAction("Show", var0_31, arg0_18.langType)
		end
	end, SFX_PANEL)

	arg0_18.auditionFlag = false

	onButton(arg0_18, arg0_18.auditionBtn, function()
		if not arg0_18.selectedIndex then
			return
		end

		local var0_32 = arg0_18.displays[arg0_18.selectedIndex]

		if not var0_32 then
			return
		end

		arg0_18.auditionFlag = not arg0_18.auditionFlag

		if arg0_18.auditionFlag then
			arg0_18:PlayAudition(var0_32)
			pg.BgmMgr.GetInstance():StopPlay()
		else
			arg0_18:ClearAuditionTimer()
			arg0_18.soundPlayer:Stop()
			arg0_18.auditionEffect:Play("anim_line_reset")
			pg.BgmMgr.GetInstance():ContinuePlay()
		end

		arg0_18:UpdateAudition(arg0_18.auditionFlag)
	end, SFX_PANEL)
	arg0_18:UpdateAudition(arg0_18.auditionFlag)
end

function var0_0.UpdateAudition(arg0_33, arg1_33)
	setActive(arg0_33.auditionBtnOn, arg1_33)
	setActive(arg0_33.auditionBtnOff, not arg1_33)
end

function var0_0.PlayAudition(arg0_34, arg1_34)
	arg0_34:ClearAuditionTimer()
	arg0_34.auditionEffect:Play("anim_line_loop")

	local var0_34 = getProxy(PlayerProxy):getRawData():GetFlagShip()
	local var1_34 = arg1_34:GetAudition(arg0_34.langType)
	local var2_34 = arg1_34:GetAuditionVoice(arg0_34.langType)

	arg0_34.soundPlayer:Load(var1_34, var2_34, 0, function(arg0_35)
		arg0_34.timer = Timer.New(function()
			if arg0_34.auditionFlag then
				triggerButton(arg0_34.auditionBtn)
			end
		end, arg0_35, 1)

		arg0_34.timer:Start()
	end)
end

function var0_0.ClearAuditionTimer(arg0_37)
	if arg0_37.timer then
		arg0_37.timer:Stop()

		arg0_37.timer = nil
	end
end

function var0_0.IsDownloading(arg0_38, arg1_38)
	if not arg1_38 then
		return false
	end

	if arg1_38:ExistLang(Cryptolalia.LANG_TYPE_CH) then
		local var0_38 = arg1_38:GetCpkName(Cryptolalia.LANG_TYPE_CH)
		local var1_38 = Cryptolalia.BuildCpkPath(var0_38)

		if arg0_38.downloadMgr:IsDownloadState(var1_38) then
			return true
		end
	end

	if arg1_38:ExistLang(Cryptolalia.LANG_TYPE_JP) then
		local var2_38 = arg1_38:GetCpkName(Cryptolalia.LANG_TYPE_JP)
		local var3_38 = Cryptolalia.BuildCpkPath(var2_38)

		if arg0_38.downloadMgr:IsDownloadState(var3_38) then
			return true
		end
	end

	return false
end

function var0_0.DownloadRes(arg0_39, arg1_39)
	for iter0_39, iter1_39 in ipairs(arg0_39.displays or {}) do
		if arg0_39:IsDownloading(iter1_39) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_download_task_already_exists", iter1_39:GetName()))

			return
		end
	end

	if IsUnityEditor then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

		return
	end

	local var0_39 = arg0_39.displays[arg1_39]

	originalPrint(var0_39:IsDownloadableState(arg0_39.langType))

	if var0_39 and var0_39:IsDownloadableState(arg0_39.langType) and not arg0_39.downloadReqList[var0_39.id] then
		originalPrint("Downloading............")
		arg0_39:OnUpdateForResDownload("Request", var0_39, arg1_39)
		arg0_39:OnItemSelected(arg0_39.selectedIndex)
	end
end

function var0_0.OnUpdateForResDownload(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40 = arg2_40:GetCpkName(arg0_40.langType)
	local var1_40 = Cryptolalia.BuildCpkPath(var0_40)
	local var2_40 = Cryptolalia.BuildSubtitlePath(var0_40)

	arg0_40.downloadMgr[arg1_40](arg0_40.downloadMgr, {
		var2_40,
		var1_40
	}, function(arg0_41, arg1_41)
		local var0_41 = arg0_40.downloadReqList[arg2_40.id]

		if not var0_41 or var0_41.index ~= arg0_40.selectedIndex then
			return
		end

		if arg1_41 == CryptolaliaDownloadMgr.PROGRESS_FINISH or arg1_41 == CryptolaliaDownloadMgr.PROGRESS_ERROR then
			arg0_40.downloadReqList[arg2_40.id] = nil
			arg0_40.cg.blocksRaycasts = false

			onNextTick(function()
				arg0_40:OnItemSelected(arg0_40.selectedIndex)

				arg0_40.cg.blocksRaycasts = true
			end)

			if arg1_41 == CryptolaliaDownloadMgr.PROGRESS_FINISH then
				pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_download_done"))
			end
		else
			setSlider(arg0_40.downloadingBtn, 0, 1, arg1_41)
		end
	end)

	arg0_40.downloadReqList[arg2_40.id] = {
		index = arg3_40
	}
end

function var0_0.PlayVedio(arg0_43, arg1_43)
	local var0_43 = arg0_43.displays[arg1_43]

	if var0_43 and var0_43:IsPlayableState(arg0_43.langType) then
		pg.BgmMgr.GetInstance():StopPlay()

		local var1_43 = var0_43:GetCpkName(arg0_43.langType)
		local var2_43 = var0_43:GetCaptionsColor()
		local var3_43 = CryptolaliaVedioPlayer.New(arg0_43._tf)

		var3_43:Play(var1_43, var2_43, function()
			pg.BgmMgr.GetInstance():ContinuePlay()
		end)

		arg0_43.player = var3_43
	end
end

function var0_0.OnUnlockCryptolalia(arg0_45, arg1_45)
	for iter0_45, iter1_45 in ipairs(arg0_45.cryptolaliaList) do
		if iter1_45.id == arg1_45 then
			iter1_45:Unlock()
		end
	end

	for iter2_45, iter3_45 in ipairs(arg0_45.displays) do
		if iter3_45 and iter3_45.id == arg1_45 then
			iter3_45:Unlock()
		end
	end

	if not arg0_45.selectedIndex then
		return
	end

	local var0_45 = arg0_45.displays[arg0_45.selectedIndex]

	if var0_45 and var0_45.id == arg1_45 then
		arg0_45:OnItemSelected(arg0_45.selectedIndex)
	end

	if arg0_45.purchaseWindow and arg0_45.purchaseWindow:GetLoaded() and arg0_45.purchaseWindow:isShowing() then
		arg0_45.purchaseWindow:Hide()
	end
end

function var0_0.onBackPressed(arg0_46)
	if arg0_46.purchaseWindow and arg0_46.purchaseWindow:GetLoaded() and arg0_46.purchaseWindow:isShowing() then
		arg0_46.purchaseWindow:Hide()

		return
	end

	if arg0_46.resDeleteWindow and arg0_46.resDeleteWindow:GetLoaded() and arg0_46.resDeleteWindow:isShowing() then
		arg0_46.resDeleteWindow:Hide()

		return
	end

	if arg0_46.listView and arg0_46.listView:GetLoaded() and arg0_46.listView:isShowing() then
		arg0_46.listView:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_46)
end

function var0_0.willExit(arg0_47)
	arg0_47:ClearAuditionTimer()

	if arg0_47.scrollRect then
		arg0_47.scrollRect:Dispose()

		arg0_47.scrollRect = nil
	end

	arg0_47.downloadReqList = nil

	if arg0_47.purchaseWindow then
		arg0_47.purchaseWindow:Destroy()

		arg0_47.purchaseWindow = nil
	end

	if arg0_47.resDeleteWindow then
		arg0_47.resDeleteWindow:Destroy()

		arg0_47.resDeleteWindow = nil
	end

	if arg0_47.mainView then
		arg0_47.mainView:Dispose()

		arg0_47.mainView = nil
	end

	if arg0_47.player then
		arg0_47.player:Dispose()

		arg0_47.player = nil
	end

	if arg0_47.downloadMgr then
		arg0_47.downloadMgr:Dispose()

		arg0_47.downloadMgr = nil
	end

	if arg0_47.listView then
		arg0_47.listView:Destroy()

		arg0_47.listView = nil
	end

	arg0_47.cards = nil

	if arg0_47.soundPlayer then
		arg0_47.soundPlayer:Dispose()

		arg0_47.soundPlayer = nil
	end

	Input.multiTouchEnabled = true
end

return var0_0
