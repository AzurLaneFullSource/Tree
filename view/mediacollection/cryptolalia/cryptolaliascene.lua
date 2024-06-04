local var0 = class("CryptolaliaScene", import("view.base.BaseUI"))

var0.ON_UNLOCK = "CryptolaliaScene:ON_UNLOCK"
var0.ON_DELETE = "CryptolaliaScene:ON_DELETE"
var0.ON_SELECT = "CryptolaliaScene:ON_SELECT"

function var0.getUIName(arg0)
	return "CryptolaliaUI"
end

function var0.SetCryptolaliaList(arg0, arg1)
	arg0.cryptolaliaList = arg1
end

function var0.init(arg0)
	arg0.cg = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.backBtn = arg0:findTF("Top/blur_panel/adapt/top/back_btn")
	arg0.auditionBtn = arg0:findTF("Main/audition/toggle")
	arg0.auditionBtnOn = arg0:findTF("Main/audition/toggle/on")
	arg0.auditionBtnOff = arg0:findTF("Main/audition/toggle/off")
	arg0.cdImg = arg0:findTF("Main/cd"):GetComponent(typeof(Image))
	arg0.cdSignatureImg = arg0:findTF("Main/cd/signature"):GetComponent(typeof(Image))
	arg0.shipName = arg0:findTF("Main/cd/name"):GetComponent(typeof(Text))
	arg0.timeLimit = arg0:findTF("Main/cd/timelimit")
	arg0.timeTxt = arg0:findTF("Main/cd/timelimit/Text"):GetComponent(typeof(Text))
	arg0.nameTxt = arg0:findTF("Main/name"):GetComponent(typeof(Text))
	arg0.authorTxt = arg0:findTF("Main/name/author"):GetComponent(typeof(Text))
	arg0.descTxt = arg0:findTF("Main/desc"):GetComponent(typeof(Text))
	arg0.signatureImg = arg0:findTF("Main/desc/signature"):GetComponent(typeof(Image))
	arg0.auditionTxt = arg0:findTF("Main/audition/mask/Text"):GetComponent("ScrollText")
	arg0.auditionEffect = arg0:findTF("Main/audition/p2/Lines"):GetComponent(typeof(Animation))

	arg0.auditionEffect:Play("anim_line_reset")

	arg0.btnsTr = arg0:findTF("Main/btns")
	arg0.lockBtn = arg0.btnsTr:Find("lock")
	arg0.downloadBtn = arg0.btnsTr:Find("download")
	arg0.downloadingBtn = arg0.btnsTr:Find("downloading")
	arg0.playBtn = arg0.btnsTr:Find("play")
	arg0.playPrevBtn = arg0.btnsTr:Find("play/prev")
	arg0.playNextBtn = arg0.btnsTr:Find("play/next")
	arg0.deleteBtn = arg0.btnsTr:Find("delete")
	arg0.stateBtn = arg0.btnsTr:Find("state")
	arg0.stateBtnTxt = arg0.stateBtn:Find("Text"):GetComponent(typeof(Text))
	arg0.switchBtn = arg0.btnsTr:Find("switch")
	arg0.listBtn = arg0.btnsTr:Find("list")
	arg0.optionBtn = arg0:findTF("Top/blur_panel/adapt/top/option")
	arg0.purchaseWindow = CryptolaliaPurchaseWindow.New(arg0._tf, arg0.event)
	arg0.resDeleteWindow = CryptolaliaResDeleteWindow.New(arg0._tf, arg0.event)
	arg0.downloadMgr = CryptolaliaDownloadMgr.New()
	arg0.soundPlayer = CryptolaliaSoundPlayer.New()
	arg0.mainView = CryptolaliaMainView.New(arg0)
	arg0.listView = CryptolaliaListView.New(arg0._tf, arg0.event)

	local var0 = CryptolaliaScrollRectAnimation.New(arg0._tf)

	arg0.scrollRect = CryptolaliaScrollRect.New(arg0:findTF("Main/list/tpl"), var0)

	arg0.scrollRect:Make(function(arg0)
		arg0:OnItemUpdate(arg0)
	end, function(arg0)
		arg0:OnItemSelected(arg0:GetInitIndex())
	end)

	arg0.dftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))

	setText(arg0:findTF("Main/cd/timelimit/label"), i18n("cryptolalia_timelimie"))
	setText(arg0.downloadingBtn:Find("label"), i18n("cryptolalia_label_downloading"))

	Input.multiTouchEnabled = false
end

function var0.didEnter(arg0)
	arg0.cards = {}
	arg0.downloadReqList = {}

	parallelAsync({
		function(arg0)
			arg0.dftAniEvent:SetEndEvent(arg0)
		end,
		function(arg0)
			arg0:InitCryptolaliaList(arg0)
		end
	}, function()
		arg0.dftAniEvent:SetEndEvent(nil)
		arg0.scrollRect:SetUp()
		arg0:ActiveDefault()
		arg0:RegisterEvent()
	end)
end

function var0.ActiveDefault(arg0)
	if not arg0.contextData.groupId then
		return
	end

	local var0 = -1

	for iter0, iter1 in ipairs(arg0.displays) do
		if iter1 and iter1:IsSameGroup(arg0.contextData.groupId) then
			var0 = iter0

			break
		end
	end

	if var0 <= 0 then
		return
	end

	for iter2, iter3 in pairs(arg0.cards) do
		if iter3:GetInitIndex() == var0 then
			triggerButton(iter3._go)

			break
		end
	end
end

function var0.OnItemUpdate(arg0, arg1)
	local var0 = arg0.displays[arg1:GetInitIndex()]

	arg1:Interactable(false)

	if not var0 then
		return
	end

	arg1:Interactable(true)

	local var1 = var0:GetShipGroupId()

	LoadSpriteAtlasAsync("CryptolaliaShip/" .. var1, "icon", function(arg0)
		arg1:UpdateSprite(arg0)
	end)

	arg0.cards[var0.id] = arg1
end

function var0.OnItemSelected(arg0, arg1)
	local var0 = arg0.displays[arg1]

	if not var0 then
		return
	end

	if not arg0.langType or not var0:ExistLang(arg0.langType) then
		arg0.langType = var0:GetDefaultLangType()
	end

	local var1 = var0:GetCpkName(arg0.langType)
	local var2 = Cryptolalia.BuildCpkPath(var1)
	local var3 = arg0.downloadMgr:IsDownloadState(var2)

	if var3 and arg0.downloadReqList[var0.id] == nil then
		arg0:OnUpdateForResDownload("ReConnection", var0, arg1)
	end

	arg0.mainView:Flush(var0, arg0.langType, var3)

	arg0.selectedIndex = arg1

	if arg0.auditionFlag then
		triggerButton(arg0.auditionBtn)
	end
end

function var0.Filter(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.cryptolaliaList or {}) do
		if iter1:InTime() or not iter1:IsLock() then
			table.insert(var0, iter1)
		end
	end

	table.sort(var0, function(arg0, arg1)
		local var0 = arg0:GetSortIndex()
		local var1 = arg1:GetSortIndex()

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var0 < var1
		end
	end)

	return var0
end

function var0.InitCryptolaliaList(arg0, arg1)
	local var0 = arg0:Filter()

	arg0.displays = arg0:FillEmptyDisplayIfNeed(var0)

	arg0.scrollRect:Align(#arg0.displays, arg1)
end

function var0.FillEmptyDisplayIfNeed(arg0, arg1)
	local var0 = {}

	for iter0 = 1, math.max(5, #arg1) do
		local var1 = defaultValue(arg1[iter0], false)

		if iter0 % 2 == 0 then
			table.insert(var0, var1)
		else
			table.insert(var0, 1, var1)
		end
	end

	return var0
end

function var0.RegisterEvent(arg0)
	arg0:bind(var0.ON_UNLOCK, function(arg0, arg1)
		arg0:OnUnlockCryptolalia(arg1)
	end)
	arg0:bind(var0.ON_DELETE, function(arg0)
		if not arg0.selectedIndex then
			return
		end

		arg0:OnItemSelected(arg0.selectedIndex)
	end)
	arg0:bind(var0.ON_SELECT, function(arg0, arg1)
		local var0 = arg0.cards[arg1]

		if var0 then
			triggerButton(var0._go)
		end
	end)
	onButton(arg0, arg0.optionBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.switchBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex]

		if not var0 then
			return
		end

		if not var0:IsMultiVersion() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_coming_soom"))

			return
		end

		arg0.langType = 1 - arg0.langType

		arg0:OnItemSelected(arg0.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0, arg0.listBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex]

		if var0 then
			local var1 = arg0:Filter()

			arg0.listView:ExecuteAction("Show", var1, arg0.langType, var0.id, arg0.scrollRect)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.deleteBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex]

		if var0 and var0:IsPlayableState(arg0.langType) then
			arg0.resDeleteWindow:ExecuteAction("Show", var0, arg0.langType)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.playBtn:Find("play"), function()
		if not arg0.selectedIndex then
			return
		end

		arg0:PlayVedio(arg0.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0, arg0.playNextBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex + 1]

		if var0 then
			arg0:emit(var0.ON_SELECT, var0.id)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.playPrevBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex - 1]

		if var0 then
			arg0:emit(var0.ON_SELECT, var0.id)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.downloadBtn, function()
		if not arg0.selectedIndex then
			return
		end

		arg0:DownloadRes(arg0.selectedIndex)
	end, SFX_PANEL)
	onButton(arg0, arg0.lockBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex]

		if var0 and var0:IsLockState() then
			arg0.purchaseWindow:ExecuteAction("Show", var0, arg0.langType)
		end
	end, SFX_PANEL)

	arg0.auditionFlag = false

	onButton(arg0, arg0.auditionBtn, function()
		if not arg0.selectedIndex then
			return
		end

		local var0 = arg0.displays[arg0.selectedIndex]

		if not var0 then
			return
		end

		arg0.auditionFlag = not arg0.auditionFlag

		if arg0.auditionFlag then
			arg0:PlayAudition(var0)
		else
			arg0:ClearAuditionTimer()
			arg0.soundPlayer:Stop()
			arg0.auditionEffect:Play("anim_line_reset")
		end

		arg0:UpdateAudition(arg0.auditionFlag)
	end, SFX_PANEL)
	arg0:UpdateAudition(arg0.auditionFlag)
end

function var0.UpdateAudition(arg0, arg1)
	setActive(arg0.auditionBtnOn, arg1)
	setActive(arg0.auditionBtnOff, not arg1)
end

function var0.PlayAudition(arg0, arg1)
	arg0:ClearAuditionTimer()
	arg0.auditionEffect:Play("anim_line_loop")

	local var0 = getProxy(PlayerProxy):getRawData():GetFlagShip()
	local var1 = arg1:GetAudition(arg0.langType)
	local var2 = arg1:GetAuditionVoice(arg0.langType)

	arg0.soundPlayer:Load(var1, var2, 0, function(arg0)
		arg0.timer = Timer.New(function()
			if arg0.auditionFlag then
				triggerButton(arg0.auditionBtn)
			end
		end, arg0, 1)

		arg0.timer:Start()
	end)
end

function var0.ClearAuditionTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.IsDownloading(arg0, arg1)
	if not arg1 then
		return false
	end

	if arg1:ExistLang(Cryptolalia.LANG_TYPE_CH) then
		local var0 = arg1:GetCpkName(Cryptolalia.LANG_TYPE_CH)
		local var1 = Cryptolalia.BuildCpkPath(var0)

		if arg0.downloadMgr:IsDownloadState(var1) then
			return true
		end
	end

	if arg1:ExistLang(Cryptolalia.LANG_TYPE_JP) then
		local var2 = arg1:GetCpkName(Cryptolalia.LANG_TYPE_JP)
		local var3 = Cryptolalia.BuildCpkPath(var2)

		if arg0.downloadMgr:IsDownloadState(var3) then
			return true
		end
	end

	return false
end

function var0.DownloadRes(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.displays or {}) do
		if arg0:IsDownloading(iter1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_download_task_already_exists", iter1:GetName()))

			return
		end
	end

	if IsUnityEditor then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_open"))

		return
	end

	local var0 = arg0.displays[arg1]

	originalPrint(var0:IsDownloadableState(arg0.langType))

	if var0 and var0:IsDownloadableState(arg0.langType) and not arg0.downloadReqList[var0.id] then
		originalPrint("Downloading............")
		arg0:OnUpdateForResDownload("Request", var0, arg1)
		arg0:OnItemSelected(arg0.selectedIndex)
	end
end

function var0.OnUpdateForResDownload(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetCpkName(arg0.langType)
	local var1 = Cryptolalia.BuildCpkPath(var0)
	local var2 = Cryptolalia.BuildSubtitlePath(var0)

	arg0.downloadMgr[arg1](arg0.downloadMgr, {
		var2,
		var1
	}, function(arg0, arg1)
		local var0 = arg0.downloadReqList[arg2.id]

		if not var0 or var0.index ~= arg0.selectedIndex then
			return
		end

		if arg1 == CryptolaliaDownloadMgr.PROGRESS_FINISH or arg1 == CryptolaliaDownloadMgr.PROGRESS_ERROR then
			arg0.downloadReqList[arg2.id] = nil
			arg0.cg.blocksRaycasts = false

			onNextTick(function()
				arg0:OnItemSelected(arg0.selectedIndex)

				arg0.cg.blocksRaycasts = true
			end)

			if arg1 == CryptolaliaDownloadMgr.PROGRESS_FINISH then
				pg.TipsMgr.GetInstance():ShowTips(i18n("cryptolalia_download_done"))
			end
		else
			setSlider(arg0.downloadingBtn, 0, 1, arg1)
		end
	end)

	arg0.downloadReqList[arg2.id] = {
		index = arg3
	}
end

function var0.PlayVedio(arg0, arg1)
	local var0 = arg0.displays[arg1]

	if var0 and var0:IsPlayableState(arg0.langType) then
		pg.BgmMgr.GetInstance():StopPlay()

		local var1 = var0:GetCpkName(arg0.langType)
		local var2 = CryptolaliaVedioPlayer.New(arg0._tf)

		var2:Play(var1, function()
			pg.BgmMgr.GetInstance():ContinuePlay()
		end)

		arg0.player = var2
	end
end

function var0.OnUnlockCryptolalia(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.cryptolaliaList) do
		if iter1.id == arg1 then
			iter1:Unlock()
		end
	end

	for iter2, iter3 in ipairs(arg0.displays) do
		if iter3 and iter3.id == arg1 then
			iter3:Unlock()
		end
	end

	if not arg0.selectedIndex then
		return
	end

	local var0 = arg0.displays[arg0.selectedIndex]

	if var0 and var0.id == arg1 then
		arg0:OnItemSelected(arg0.selectedIndex)
	end

	if arg0.purchaseWindow and arg0.purchaseWindow:GetLoaded() and arg0.purchaseWindow:isShowing() then
		arg0.purchaseWindow:Hide()
	end
end

function var0.onBackPressed(arg0)
	if arg0.purchaseWindow and arg0.purchaseWindow:GetLoaded() and arg0.purchaseWindow:isShowing() then
		arg0.purchaseWindow:Hide()

		return
	end

	if arg0.resDeleteWindow and arg0.resDeleteWindow:GetLoaded() and arg0.resDeleteWindow:isShowing() then
		arg0.resDeleteWindow:Hide()

		return
	end

	if arg0.listView and arg0.listView:GetLoaded() and arg0.listView:isShowing() then
		arg0.listView:Hide()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	arg0:ClearAuditionTimer()

	if arg0.scrollRect then
		arg0.scrollRect:Dispose()

		arg0.scrollRect = nil
	end

	arg0.downloadReqList = nil

	if arg0.purchaseWindow then
		arg0.purchaseWindow:Destroy()

		arg0.purchaseWindow = nil
	end

	if arg0.resDeleteWindow then
		arg0.resDeleteWindow:Destroy()

		arg0.resDeleteWindow = nil
	end

	if arg0.mainView then
		arg0.mainView:Dispose()

		arg0.mainView = nil
	end

	if arg0.player then
		arg0.player:Dispose()

		arg0.player = nil
	end

	if arg0.downloadMgr then
		arg0.downloadMgr:Dispose()

		arg0.downloadMgr = nil
	end

	if arg0.listView then
		arg0.listView:Destroy()

		arg0.listView = nil
	end

	arg0.cards = nil

	if arg0.soundPlayer then
		arg0.soundPlayer:Dispose()

		arg0.soundPlayer = nil
	end

	Input.multiTouchEnabled = true
end

return var0
