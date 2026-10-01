local var0_0 = class("CryptolaliaScene", import("view.base.BaseUI"))

var0_0.ON_UNLOCK = "CryptolaliaScene:ON_UNLOCK"
var0_0.ON_DELETE = "CryptolaliaScene:ON_DELETE"
var0_0.ON_SELECT = "CryptolaliaScene:ON_SELECT"

function var0_0.getUIName(arg0_1)
	return "CryptolaliaUI"
end

function var0_0.GetAllCryptolaliaShipRes()
	local var0_2 = {}
	local var1_2 = pg.soundstory_template.all

	for iter0_2, iter1_2 in ipairs(var1_2) do
		local var2_2 = pg.soundstory_template[iter1_2]
		local var3_2 = var2_2 and var2_2.ship_id

		if var3_2 then
			table.insert(var0_2, "CryptolaliaShip/" .. var3_2)
		end
	end

	return var0_2
end

function var0_0.GetAllCryptolaliaAuditionRes()
	local var0_3 = {}
	local var1_3 = pg.soundstory_template.all

	for iter0_3, iter1_3 in ipairs(var1_3) do
		local var2_3 = pg.soundstory_template[iter1_3]

		if var2_3 then
			local var3_3 = var2_3.audition_resource_CN
			local var4_3 = var2_3.audition_resource_JP

			if var3_3 and var3_3 ~= "" then
				table.insert(var0_3, "cue/" .. var3_3 .. ".b")
			end

			if var4_3 and var4_3 ~= "" then
				table.insert(var0_3, "cue/" .. var4_3 .. ".b")
			end
		end
	end

	return var0_3
end

function var0_0.getResource(arg0_4, arg1_4)
	local var0_4 = {
		"ui/CryptolaliaUI_atlas",
		"ui/CryptolaliaListui",
		"ui/CryptolaliaPurchaseWindowui",
		"ui/CryptolaliaResDeleteWindowui"
	}

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_4, arg1_4), var0_4, var0_0.GetAllCryptolaliaShipRes(), var0_0.GetAllCryptolaliaAuditionRes()))
end

function var0_0.SetCryptolaliaList(arg0_5, arg1_5)
	arg0_5.cryptolaliaList = arg1_5
end

function var0_0.init(arg0_6)
	arg0_6.cg = arg0_6._tf:GetComponent(typeof(CanvasGroup))
	arg0_6.backBtn = arg0_6._tf:Find("Top/blur_panel/adapt/top/back_btn")
	arg0_6.auditionBtn = arg0_6._tf:Find("Main/audition/toggle")
	arg0_6.auditionBtnOn = arg0_6._tf:Find("Main/audition/toggle/on")
	arg0_6.auditionBtnOff = arg0_6._tf:Find("Main/audition/toggle/off")
	arg0_6.cdImg = arg0_6._tf:Find("Main/cd"):GetComponent(typeof(Image))
	arg0_6.cdSignatureImg = arg0_6._tf:Find("Main/cd/signature"):GetComponent(typeof(Image))
	arg0_6.shipName = arg0_6._tf:Find("Main/cd/name"):GetComponent(typeof(Text))
	arg0_6.timeLimit = arg0_6._tf:Find("Main/cd/timelimit")
	arg0_6.timeTxt = arg0_6._tf:Find("Main/cd/timelimit/Text"):GetComponent(typeof(Text))
	arg0_6.nameTxt = arg0_6._tf:Find("Main/name"):GetComponent(typeof(Text))
	arg0_6.authorTxt = arg0_6._tf:Find("Main/author"):GetComponent(typeof(Text))
	arg0_6.descTxt = arg0_6._tf:Find("Main/desc"):GetComponent(typeof(Text))
	arg0_6.signatureImg = arg0_6._tf:Find("Main/desc/signature"):GetComponent(typeof(Image))
	arg0_6.auditionTxt = arg0_6._tf:Find("Main/audition/mask/Text"):GetComponent("ScrollText")
	arg0_6.auditionEffect = arg0_6._tf:Find("Main/audition/p2/Lines"):GetComponent(typeof(Animation))

	arg0_6.auditionEffect:Play("anim_line_reset")

	arg0_6.btnsTr = arg0_6._tf:Find("Main/btns")
	arg0_6.lockBtn = arg0_6.btnsTr:Find("lock")
	arg0_6.downloadBtn = arg0_6.btnsTr:Find("download")
	arg0_6.downloadingBtn = arg0_6.btnsTr:Find("downloading")
	arg0_6.playBtn = arg0_6.btnsTr:Find("play")
	arg0_6.playPrevBtn = arg0_6.btnsTr:Find("play/prev")
	arg0_6.playNextBtn = arg0_6.btnsTr:Find("play/next")
	arg0_6.deleteBtn = arg0_6.btnsTr:Find("delete")
	arg0_6.stateBtn = arg0_6.btnsTr:Find("state")
	arg0_6.stateBtnTxt = arg0_6.stateBtn:Find("Text"):GetComponent(typeof(Text))
	arg0_6.switchBtn = arg0_6.btnsTr:Find("switch")
	arg0_6.listBtn = arg0_6.btnsTr:Find("list")
	arg0_6.optionBtn = arg0_6._tf:Find("Top/blur_panel/adapt/top/option")
	arg0_6.purchaseWindow = CryptolaliaPurchaseWindow.New(arg0_6._tf, arg0_6.event)
	arg0_6.resDeleteWindow = CryptolaliaResDeleteWindow.New(arg0_6._tf, arg0_6.event)
	arg0_6.downloadMgr = CryptolaliaDownloadMgr.New()
	arg0_6.soundPlayer = CryptolaliaSoundPlayer.New()
	arg0_6.mainView = CryptolaliaMainView.New(arg0_6)
	arg0_6.listView = CryptolaliaListView.New(arg0_6._tf, arg0_6.event)

	local var0_6 = CryptolaliaScrollRectAnimation.New(arg0_6._tf)

	arg0_6.scrollRect = CryptolaliaScrollRect.New(arg0_6._tf:Find("Main/list/tpl"), var0_6)

	arg0_6.scrollRect:Make(function(arg0_7)
		arg0_6:OnItemUpdate(arg0_7)
	end, function(arg0_8)
		arg0_6:OnItemSelected(arg0_8:GetInitIndex())
	end)

	arg0_6.dftAniEvent = arg0_6._tf:GetComponent(typeof(DftAniEvent))

	setText(arg0_6._tf:Find("Main/cd/timelimit/label"), i18n("cryptolalia_timelimie"))
	setText(arg0_6.downloadingBtn:Find("label"), i18n("cryptolalia_label_downloading"))

	Input.multiTouchEnabled = false
end

function var0_0.didEnter(arg0_9)
	arg0_9.cards = {}
	arg0_9.downloadReqList = {}

	parallelAsync({
		function(arg0_10)
			arg0_9.dftAniEvent:SetEndEvent(arg0_10)
		end,
		function(arg0_11)
			arg0_9:InitCryptolaliaList(arg0_11)
		end
	}, function()
		arg0_9.dftAniEvent:SetEndEvent(nil)
		arg0_9.scrollRect:SetUp()
		arg0_9:ActiveDefault()
		arg0_9:RegisterEvent()
	end)
end

function var0_0.ActiveDefault(arg0_13)
	if not arg0_13.contextData.groupId then
		return
	end

	local var0_13 = -1

	for iter0_13, iter1_13 in ipairs(arg0_13.displays) do
		if iter1_13 and iter1_13:IsSameGroup(arg0_13.contextData.groupId) then
			var0_13 = iter0_13

			break
		end
	end

	if var0_13 <= 0 then
		return
	end

	for iter2_13, iter3_13 in pairs(arg0_13.cards) do
		if iter3_13:GetInitIndex() == var0_13 then
			triggerButton(iter3_13._go)

			break
		end
	end
end

function var0_0.OnItemUpdate(arg0_14, arg1_14)
	local var0_14 = arg0_14.displays[arg1_14:GetInitIndex()]

	arg1_14:Interactable(false)

	if not var0_14 then
		return
	end

	arg1_14:Interactable(true)

	local var1_14 = var0_14:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var1_14, "icon", function(arg0_15)
		arg1_14:UpdateSprite(arg0_15)
	end)

	arg0_14.cards[var0_14.id] = arg1_14
end

function var0_0.OnItemSelected(arg0_16, arg1_16)
	local var0_16 = arg0_16.displays[arg1_16]

	if not var0_16 then
		return
	end

	if not arg0_16.langType or not var0_16:ExistLang(arg0_16.langType) or arg0_16.selectedIndex ~= arg1_16 then
		arg0_16.langType = var0_16:GetDefaultLangType()
	end

	local var1_16 = var0_16:GetCpkName(arg0_16.langType)
	local var2_16 = Cryptolalia.BuildCpkPath(var1_16)
	local var3_16 = arg0_16.downloadMgr:IsDownloadState(var2_16)

	if var3_16 and arg0_16.downloadReqList[var0_16.id] == nil then
		arg0_16:OnUpdateForResDownload("ReConnection", var0_16, arg1_16)
	end

	arg0_16.mainView:Flush(var0_16, arg0_16.langType, var3_16)

	arg0_16.selectedIndex = arg1_16

	if arg0_16.auditionFlag then
		triggerButton(arg0_16.auditionBtn)
	end
end

function var0_0.Filter(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.cryptolaliaList or {}) do
		if iter1_17:InTime() or not iter1_17:IsLock() then
			table.insert(var0_17, iter1_17)
		end
	end

	table.sort(var0_17, function(arg0_18, arg1_18)
		local var0_18 = arg0_18:GetSortIndex()
		local var1_18 = arg1_18:GetSortIndex()

		if var0_18 == var1_18 then
			return arg0_18.id < arg1_18.id
		else
			return var0_18 < var1_18
		end
	end)

	return var0_17
end

function var0_0.InitCryptolaliaList(arg0_19, arg1_19)
	local var0_19 = arg0_19:Filter()

	arg0_19.displays = arg0_19:FillEmptyDisplayIfNeed(var0_19)

	arg0_19.scrollRect:Align(#arg0_19.displays, arg1_19)
end

function var0_0.FillEmptyDisplayIfNeed(arg0_20, arg1_20)
	local var0_20 = {}

	for iter0_20 = 1, math.max(5, #arg1_20) do
		local var1_20 = defaultValue(arg1_20[iter0_20], false)

		if iter0_20 % 2 == 0 then
			table.insert(var0_20, var1_20)
		else
			table.insert(var0_20, 1, var1_20)
		end
	end

	return var0_20
end

function var0_0.RegisterEvent(arg0_21)
	arg0_21:bind(var0_0.ON_UNLOCK, function(arg0_22, arg1_22)
		arg0_21:OnUnlockCryptolalia(arg1_22)
	end)
	arg0_21:bind(var0_0.ON_DELETE, function(arg0_23)
		if not arg0_21.selectedIndex then
			return
		end

		arg0_21:OnItemSelected(arg0_21.selectedIndex)
	end)
	arg0_21:bind(var0_0.ON_SELECT, function(arg0_24, arg1_24)
		local var0_24 = arg0_21.cards[arg1_24]

		if var0_24 then
			triggerButton(var0_24._go)
		end
	end)
	onButton(arg0_21, arg0_21.optionBtn, function()
		arg0_21:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.backBtn, function()
		arg0_21:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_21, arg0_21.switchBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_27 = arg0_21.displays[arg0_21.selectedIndex]

		if not var0_27 then
			return
		end

		if not var0_27:IsMultiVersion() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_coming_soom"))

			return
		end

		arg0_21.langType = 1 - arg0_21.langType

		arg0_21:OnItemSelected(arg0_21.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.listBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_28 = arg0_21.displays[arg0_21.selectedIndex]

		if var0_28 then
			local var1_28 = arg0_21:Filter()

			arg0_21.listView:ExecuteAction("Show", var1_28, arg0_21.langType, var0_28.id, arg0_21.scrollRect)
		end
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.deleteBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_29 = arg0_21.displays[arg0_21.selectedIndex]

		if var0_29 and var0_29:IsPlayableState(arg0_21.langType) then
			arg0_21.resDeleteWindow:ExecuteAction("Show", var0_29, arg0_21.langType)
		end
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.playBtn:Find("play"), function()
		if not arg0_21.selectedIndex then
			return
		end

		arg0_21:PlayVedio(arg0_21.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.playNextBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_31 = arg0_21.displays[arg0_21.selectedIndex + 1]

		if var0_31 then
			arg0_21:emit(var0_0.ON_SELECT, var0_31.id)
		end
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.playPrevBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_32 = arg0_21.displays[arg0_21.selectedIndex - 1]

		if var0_32 then
			arg0_21:emit(var0_0.ON_SELECT, var0_32.id)
		end
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.downloadBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		arg0_21:DownloadRes(arg0_21.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.lockBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_34 = arg0_21.displays[arg0_21.selectedIndex]

		if var0_34 and var0_34:IsLockState() then
			arg0_21.purchaseWindow:ExecuteAction("Show", var0_34, arg0_21.langType)
		end
	end, SFX_PANEL)

	arg0_21.auditionFlag = false

	onButton(arg0_21, arg0_21.auditionBtn, function()
		if not arg0_21.selectedIndex then
			return
		end

		local var0_35 = arg0_21.displays[arg0_21.selectedIndex]

		if not var0_35 then
			return
		end

		arg0_21.auditionFlag = not arg0_21.auditionFlag

		if arg0_21.auditionFlag then
			arg0_21:PlayAudition(var0_35)
			pg.BgmMgr.GetInstance():StopPlay()
		else
			arg0_21:ClearAuditionTimer()
			arg0_21.soundPlayer:Stop()
			arg0_21.auditionEffect:Play("anim_line_reset")
			pg.BgmMgr.GetInstance():ContinuePlay()
		end

		arg0_21:UpdateAudition(arg0_21.auditionFlag)
	end, SFX_PANEL)
	arg0_21:UpdateAudition(arg0_21.auditionFlag)
end

function var0_0.UpdateAudition(arg0_36, arg1_36)
	setActive(arg0_36.auditionBtnOn, arg1_36)
	setActive(arg0_36.auditionBtnOff, not arg1_36)
end

function var0_0.PlayAudition(arg0_37, arg1_37)
	arg0_37:ClearAuditionTimer()
	arg0_37.auditionEffect:Play("anim_line_loop")

	local var0_37 = getProxy(PlayerProxy):getRawData():GetFlagShip()
	local var1_37 = arg1_37:GetAudition(arg0_37.langType)
	local var2_37 = arg1_37:GetAuditionVoice(arg0_37.langType)

	arg0_37.soundPlayer:Load(var1_37, var2_37, 0, function(arg0_38)
		arg0_37.timer = Timer.New(function()
			if arg0_37.auditionFlag then
				triggerButton(arg0_37.auditionBtn)
			end
		end, arg0_38, 1)

		arg0_37.timer:Start()
	end)
end

function var0_0.ClearAuditionTimer(arg0_40)
	if arg0_40.timer then
		arg0_40.timer:Stop()

		arg0_40.timer = nil
	end
end

function var0_0.IsDownloading(arg0_41, arg1_41)
	if not arg1_41 then
		return false
	end

	if arg1_41:ExistLang(Cryptolalia.LANG_TYPE_CH) then
		local var0_41 = arg1_41:GetCpkName(Cryptolalia.LANG_TYPE_CH)
		local var1_41 = Cryptolalia.BuildCpkPath(var0_41)

		if arg0_41.downloadMgr:IsDownloadState(var1_41) then
			return true
		end
	end

	if arg1_41:ExistLang(Cryptolalia.LANG_TYPE_JP) then
		local var2_41 = arg1_41:GetCpkName(Cryptolalia.LANG_TYPE_JP)
		local var3_41 = Cryptolalia.BuildCpkPath(var2_41)

		if arg0_41.downloadMgr:IsDownloadState(var3_41) then
			return true
		end
	end

	return false
end

function var0_0.DownloadRes(arg0_42, arg1_42)
	for iter0_42, iter1_42 in ipairs(arg0_42.displays or {}) do
		if arg0_42:IsDownloading(iter1_42) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_download_task_already_exists", iter1_42:GetName()))

			return
		end
	end

	if IsUnityEditor then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

		return
	end

	local var0_42 = arg0_42.displays[arg1_42]

	originalPrint(var0_42:IsDownloadableState(arg0_42.langType))

	if var0_42 and var0_42:IsDownloadableState(arg0_42.langType) and not arg0_42.downloadReqList[var0_42.id] then
		originalPrint("Downloading............")
		arg0_42:OnUpdateForResDownload("Request", var0_42, arg1_42)
		arg0_42:OnItemSelected(arg0_42.selectedIndex)
	end
end

function var0_0.OnUpdateForResDownload(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg2_43:GetCpkName(arg0_43.langType)
	local var1_43 = Cryptolalia.BuildCpkPath(var0_43)
	local var2_43 = Cryptolalia.BuildSubtitlePath(var0_43)

	arg0_43.downloadMgr[arg1_43](arg0_43.downloadMgr, {
		var2_43,
		var1_43
	}, function(arg0_44, arg1_44)
		local var0_44 = arg0_43.downloadReqList[arg2_43.id]

		if not var0_44 or var0_44.index ~= arg0_43.selectedIndex then
			return
		end

		if arg1_44 == CryptolaliaDownloadMgr.PROGRESS_FINISH or arg1_44 == CryptolaliaDownloadMgr.PROGRESS_ERROR then
			arg0_43.downloadReqList[arg2_43.id] = nil
			arg0_43.cg.blocksRaycasts = false

			onNextTick(function()
				arg0_43:OnItemSelected(arg0_43.selectedIndex)

				arg0_43.cg.blocksRaycasts = true
			end)

			if arg1_44 == CryptolaliaDownloadMgr.PROGRESS_FINISH then
				pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_download_done"))
			end
		else
			setSlider(arg0_43.downloadingBtn, 0, 1, arg1_44)
		end
	end)

	arg0_43.downloadReqList[arg2_43.id] = {
		index = arg3_43
	}
end

function var0_0.PlayVedio(arg0_46, arg1_46)
	local var0_46 = arg0_46.displays[arg1_46]

	if var0_46 and var0_46:IsPlayableState(arg0_46.langType) then
		pg.BgmMgr.GetInstance():StopPlay()

		local var1_46 = var0_46:GetCpkName(arg0_46.langType)
		local var2_46 = var0_46:GetCaptionsColor()
		local var3_46 = CryptolaliaVedioPlayer.New(arg0_46._tf)

		var3_46:Play(var1_46, var2_46, function()
			pg.BgmMgr.GetInstance():ContinuePlay()
		end)

		arg0_46.player = var3_46
	end
end

function var0_0.OnUnlockCryptolalia(arg0_48, arg1_48)
	for iter0_48, iter1_48 in ipairs(arg0_48.cryptolaliaList) do
		if iter1_48.id == arg1_48 then
			iter1_48:Unlock()
		end
	end

	for iter2_48, iter3_48 in ipairs(arg0_48.displays) do
		if iter3_48 and iter3_48.id == arg1_48 then
			iter3_48:Unlock()
		end
	end

	if not arg0_48.selectedIndex then
		return
	end

	local var0_48 = arg0_48.displays[arg0_48.selectedIndex]

	if var0_48 and var0_48.id == arg1_48 then
		arg0_48:OnItemSelected(arg0_48.selectedIndex)
	end

	if arg0_48.purchaseWindow and arg0_48.purchaseWindow:GetLoaded() and arg0_48.purchaseWindow:isShowing() then
		arg0_48.purchaseWindow:Hide()
	end
end

function var0_0.onBackPressed(arg0_49)
	if arg0_49.purchaseWindow and arg0_49.purchaseWindow:GetLoaded() and arg0_49.purchaseWindow:isShowing() then
		arg0_49.purchaseWindow:Hide()

		return
	end

	if arg0_49.resDeleteWindow and arg0_49.resDeleteWindow:GetLoaded() and arg0_49.resDeleteWindow:isShowing() then
		arg0_49.resDeleteWindow:Hide()

		return
	end

	if arg0_49.listView and arg0_49.listView:GetLoaded() and arg0_49.listView:isShowing() then
		arg0_49.listView:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_49)
end

function var0_0.willExit(arg0_50)
	arg0_50:ClearAuditionTimer()

	if arg0_50.scrollRect then
		arg0_50.scrollRect:Dispose()

		arg0_50.scrollRect = nil
	end

	arg0_50.downloadReqList = nil

	if arg0_50.purchaseWindow then
		arg0_50.purchaseWindow:Destroy()

		arg0_50.purchaseWindow = nil
	end

	if arg0_50.resDeleteWindow then
		arg0_50.resDeleteWindow:Destroy()

		arg0_50.resDeleteWindow = nil
	end

	if arg0_50.mainView then
		arg0_50.mainView:Dispose()

		arg0_50.mainView = nil
	end

	if arg0_50.player then
		arg0_50.player:Dispose()

		arg0_50.player = nil
	end

	if arg0_50.downloadMgr then
		arg0_50.downloadMgr:Dispose()

		arg0_50.downloadMgr = nil
	end

	if arg0_50.listView then
		arg0_50.listView:Destroy()

		arg0_50.listView = nil
	end

	arg0_50.cards = nil

	if arg0_50.soundPlayer then
		arg0_50.soundPlayer:Dispose()

		arg0_50.soundPlayer = nil
	end

	Input.multiTouchEnabled = true
end

return var0_0
