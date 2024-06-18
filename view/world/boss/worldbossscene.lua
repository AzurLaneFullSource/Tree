local var0_0 = class("WorldBossScene", import("...base.BaseUI"))

var0_0.PAGE_ENTRANCE = 0
var0_0.PAGE_CHALLENGE = 1
var0_0.PAGE_CURRENT = 2
var0_0.PAGE_ARCHIVES_CHALLENGE = 3
var0_0.PAGE_ARCHIVES = 4
var0_0.PAGE_ARCHIVES_LIST = 5
var0_0.ON_SWITCH = "WorldBossScene:ON_SWITCH"
var0_0.ON_QUIT_ARCHIVES_LIST = "WorldBossScene:ON_QUIT_ARCHIVES_LIST"
var0_0.Listeners = {
	onBossUpdated = "OnBossUpdated"
}

function var0_0.getUIName(arg0_1)
	return "WorldBossUI"
end

function var0_0.SetBossProxy(arg0_2, arg1_2, arg2_2)
	assert(not arg0_2.bossProxy)

	arg0_2.bossProxy = arg1_2
	arg0_2.metaCharacterProxy = arg2_2
	arg0_2.boss = arg0_2.bossProxy:GetBoss()
	arg0_2.entrancePage = WorldBossEntrancePage.New(arg0_2.pagesTF, arg0_2.event, arg0_2.contextData)

	arg0_2.entrancePage:Setup(arg0_2.bossProxy)

	arg0_2.challengeCurrentBossPage = CurrentWorldBossChallengePage.New(arg0_2.pagesTF, arg0_2.event, arg0_2.contextData)

	arg0_2.challengeCurrentBossPage:Setup(arg0_2.bossProxy)

	arg0_2.currentEmptyPage = CurrentWorldBossEmptyPage.New(arg0_2.pagesTF, arg0_2.event)

	arg0_2.currentEmptyPage:Setup(arg0_2.bossProxy)

	arg0_2.currentBossDetailPage = CurrentWorldBossDetailPage.New(arg0_2.pagesTF, arg0_2.event)

	arg0_2.currentBossDetailPage:Setup(arg0_2.bossProxy)

	arg0_2.challengeArchivesBossPage = ArchivesWorldBossChallengePage.New(arg0_2.pagesTF, arg0_2.event, arg0_2.contextData)

	arg0_2.challengeArchivesBossPage:Setup(arg0_2.bossProxy)

	arg0_2.archivesListPage = ArchivesWorldBossListPage.New(arg0_2.pagesTF, arg0_2.event)

	arg0_2.archivesListPage:Setup(arg0_2.bossProxy)

	arg0_2.archivesEmptyPage = ArchivesWorldBossEmptyPage.New(arg0_2.pagesTF, arg0_2.event)

	arg0_2.archivesEmptyPage:Setup(arg0_2.bossProxy)

	arg0_2.archivesDetailPage = ArchivesWorldBossDetailPage.New(arg0_2.pagesTF, arg0_2.event)

	arg0_2.archivesDetailPage:Setup(arg0_2.bossProxy)

	arg0_2.formationPreviewPage = WorldBossFormationPreViewPage.New(arg0_2.pagesTF, arg0_2.event)

	arg0_2.bossProxy:AddListener(WorldBossProxy.EventBossUpdated, arg0_2.onBossUpdated)
end

function var0_0.AddListeners(arg0_3)
	arg0_3:bind(var0_0.ON_SWITCH, function(arg0_4, arg1_4)
		arg0_3:SwitchPage(arg1_4)
	end)
	arg0_3:bind(var0_0.ON_QUIT_ARCHIVES_LIST, function()
		arg0_3:OnBack()
	end)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6.bossProxy:RemoveListener(WorldBossProxy.EventBossUpdated, arg0_6.onBossUpdated)
end

function var0_0.OnBossUpdated(arg0_7)
	arg0_7.boss = arg0_7.bossProxy:GetBoss()

	if arg0_7.page == arg0_7.currentBossDetailPage or arg0_7.page == arg0_7.archivesDetailPage or arg0_7.page == arg0_7.currentEmptyPage or arg0_7.page == arg0_7.archivesEmptyPage then
		arg0_7:SwitchPage(var0_0.PAGE_ENTRANCE)
	end
end

function var0_0.OnShowFormationPreview(arg0_8, arg1_8)
	arg0_8.formationPreviewPage:ExecuteAction("Show", arg1_8)
end

function var0_0.OnRemoveLayers(arg0_9)
	if arg0_9.currentBossDetailPage and arg0_9.currentBossDetailPage:GetLoaded() and arg0_9.currentBossDetailPage:isShowing() then
		arg0_9.currentBossDetailPage:TryPlayGuide()
	end
end

function var0_0.OnAutoBattleResult(arg0_10, arg1_10)
	if arg0_10.archivesDetailPage and arg0_10.archivesDetailPage:isShowing() then
		arg0_10.archivesDetailPage:OnAutoBattleResult(arg1_10)
	end
end

function var0_0.OnAutoBattleStart(arg0_11, arg1_11)
	if arg0_11.archivesDetailPage and arg0_11.archivesDetailPage:isShowing() then
		arg0_11.archivesDetailPage:OnAutoBattleStart(arg1_11)
	end
end

function var0_0.OnSwitchArchives(arg0_12)
	if arg0_12.archivesListPage and arg0_12.archivesListPage:GetLoaded() and arg0_12.archivesListPage:isShowing() then
		arg0_12.archivesListPage:OnSwitchArchives()
	end
end

function var0_0.OnGetMetaAwards(arg0_13)
	if arg0_13.archivesListPage and arg0_13.archivesListPage:GetLoaded() and arg0_13.archivesListPage:isShowing() then
		arg0_13.archivesListPage:OnGetMetaAwards()
	end
end

function var0_0.getAwardDone(arg0_14)
	if arg0_14.page == arg0_14.challengeCurrentBossPage then
		arg0_14.challengeCurrentBossPage:ExecuteAction("CloseGetPage")
	end

	if (arg0_14.page == arg0_14.currentEmptyPage or arg0_14.page == arg0_14.currentBossDetailPage) and arg0_14.page:GetLoaded() then
		arg0_14.page.metaWorldbossBtn:Update()
	end
end

function var0_0.init(arg0_15)
	for iter0_15, iter1_15 in pairs(var0_0.Listeners) do
		arg0_15[iter0_15] = function(...)
			var0_0[iter1_15](arg0_15, ...)
		end
	end

	arg0_15.backBtn = arg0_15:findTF("back_btn")
	arg0_15.pagesTF = arg0_15:findTF("pages")

	arg0_15:AddListeners()
end

function var0_0.didEnter(arg0_17)
	arg0_17.pageStack = {}

	onButton(arg0_17, arg0_17.backBtn, function()
		arg0_17:OnBack()
	end, SOUND_BACK)
	arg0_17:emit(WorldBossMediator.ON_FETCH_BOSS)
end

function var0_0.OnBack(arg0_19)
	if #arg0_19.pageStack <= 1 then
		arg0_19:emit(var0_0.ON_BACK)

		return
	end

	table.remove(arg0_19.pageStack, #arg0_19.pageStack)

	local var0_19 = arg0_19.pageStack[#arg0_19.pageStack]

	arg0_19:_SwitchPage(var0_19)
end

function var0_0.SwitchPage(arg0_20, arg1_20)
	arg0_20:_SwitchPage(arg1_20)

	if #arg0_20.pageStack > 1 and arg0_20.pageStack[#arg0_20.pageStack - 1] == arg1_20 then
		table.remove(arg0_20.pageStack, #arg0_20.pageStack)
	else
		table.insert(arg0_20.pageStack, arg1_20)
	end
end

function var0_0.GetTargetPageType(arg0_21, arg1_21, arg2_21)
	if arg1_21 == var0_0.PAGE_CHALLENGE then
		return arg0_21.challengeCurrentBossPage
	elseif arg1_21 == var0_0.PAGE_ARCHIVES_CHALLENGE then
		return arg0_21.challengeArchivesBossPage
	elseif arg1_21 == var0_0.PAGE_ENTRANCE then
		return arg0_21.entrancePage
	elseif arg1_21 == var0_0.PAGE_CURRENT then
		if arg0_21.boss and arg2_21 then
			return arg0_21.currentBossDetailPage
		else
			return arg0_21.currentEmptyPage
		end
	elseif arg1_21 == var0_0.PAGE_ARCHIVES then
		if arg0_21.boss and not arg2_21 then
			return arg0_21.archivesDetailPage
		else
			return arg0_21.archivesEmptyPage
		end
	elseif arg1_21 == var0_0.PAGE_ARCHIVES_LIST then
		return arg0_21.archivesListPage
	end
end

function var0_0._SwitchPage(arg0_22, arg1_22)
	if arg0_22.page then
		arg0_22.page:ExecuteAction("Hide")
	end

	local var0_22 = false

	if arg0_22.boss then
		var0_22 = WorldBossConst._IsCurrBoss(arg0_22.boss)
	end

	if arg1_22 == var0_0.PAGE_ENTRANCE and arg0_22.boss then
		arg1_22 = var0_22 and var0_0.PAGE_CURRENT or var0_0.PAGE_ARCHIVES
	end

	if LOCK_WORLDBOSS_ARCHIVES and (arg1_22 == var0_0.PAGE_ENTRANCE or arg1_22 > var0_0.PAGE_CURRENT) then
		arg1_22 = var0_0.PAGE_CURRENT
	end

	arg0_22.page = arg0_22:GetTargetPageType(arg1_22, var0_22)

	arg0_22.page:ExecuteAction("Update")

	arg0_22.pageType = arg1_22

	setActive(arg0_22.backBtn, arg0_22.pageType ~= var0_0.PAGE_ENTRANCE and arg0_22.pageType ~= var0_0.PAGE_ARCHIVES_LIST)
	arg0_22:LoadEffect(arg1_22)
end

function var0_0.LoadEffect(arg0_23, arg1_23)
	local var0_23 = arg1_23 == var0_0.PAGE_CURRENT and arg0_23.boss or arg1_23 == var0_0.PAGE_CHALLENGE and arg0_23.bossProxy:ExistCacheBoss()

	if var0_23 and not arg0_23.fireEffect then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetUI("gondouBoss_huoxing", true, function(arg0_24)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0_23.fireEffect = arg0_24

			setParent(arg0_23.fireEffect, arg0_23._tf)
			setActive(arg0_23.fireEffect, true)
		end)
	elseif arg0_23.fireEffect then
		setActive(arg0_23.fireEffect, var0_23)
	end
end

function var0_0.willExit(arg0_25)
	if arg0_25.fireEffect then
		PoolMgr.GetInstance():ReturnUI("gondouBoss_huoxing", arg0_25.fireEffect)
	end

	if arg0_25.bossProxy then
		arg0_25:RemoveListeners()
	end

	if arg0_25.challengeCurrentBossPage then
		arg0_25.challengeCurrentBossPage:Destroy()

		arg0_25.challengeCurrentBossPage = nil
	end

	if arg0_25.currentEmptyPage then
		arg0_25.currentEmptyPage:Destroy()

		arg0_25.currentEmptyPage = nil
	end

	if arg0_25.currentBossDetailPage then
		arg0_25.currentBossDetailPage:Destroy()

		arg0_25.currentBossDetailPage = nil
	end

	if arg0_25.formationPreviewPage then
		arg0_25.formationPreviewPage:Destroy()

		arg0_25.formationPreviewPage = nil
	end

	if arg0_25.archivesListPage then
		arg0_25.archivesListPage:Destroy()

		arg0_25.archivesListPage = nil
	end

	if arg0_25.archivesDetailPage then
		arg0_25.archivesDetailPage:Destroy()

		arg0_25.archivesDetailPage = nil
	end

	if arg0_25.entrancePage then
		arg0_25.entrancePage:Destroy()

		arg0_25.entrancePage = nil
	end

	if arg0_25.archivesEmptyPage then
		arg0_25.archivesEmptyPage:Destroy()

		arg0_25.archivesEmptyPage = nil
	end

	if arg0_25.challengeArchivesBossPage then
		arg0_25.challengeArchivesBossPage:Destroy()

		arg0_25.challengeArchivesBossPage = nil
	end
end

return var0_0
