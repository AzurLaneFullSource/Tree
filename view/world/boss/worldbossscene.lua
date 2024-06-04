local var0 = class("WorldBossScene", import("...base.BaseUI"))

var0.PAGE_ENTRANCE = 0
var0.PAGE_CHALLENGE = 1
var0.PAGE_CURRENT = 2
var0.PAGE_ARCHIVES_CHALLENGE = 3
var0.PAGE_ARCHIVES = 4
var0.PAGE_ARCHIVES_LIST = 5
var0.ON_SWITCH = "WorldBossScene:ON_SWITCH"
var0.ON_QUIT_ARCHIVES_LIST = "WorldBossScene:ON_QUIT_ARCHIVES_LIST"
var0.Listeners = {
	onBossUpdated = "OnBossUpdated"
}

function var0.getUIName(arg0)
	return "WorldBossUI"
end

function var0.SetBossProxy(arg0, arg1, arg2)
	assert(not arg0.bossProxy)

	arg0.bossProxy = arg1
	arg0.metaCharacterProxy = arg2
	arg0.boss = arg0.bossProxy:GetBoss()
	arg0.entrancePage = WorldBossEntrancePage.New(arg0.pagesTF, arg0.event, arg0.contextData)

	arg0.entrancePage:Setup(arg0.bossProxy)

	arg0.challengeCurrentBossPage = CurrentWorldBossChallengePage.New(arg0.pagesTF, arg0.event, arg0.contextData)

	arg0.challengeCurrentBossPage:Setup(arg0.bossProxy)

	arg0.currentEmptyPage = CurrentWorldBossEmptyPage.New(arg0.pagesTF, arg0.event)

	arg0.currentEmptyPage:Setup(arg0.bossProxy)

	arg0.currentBossDetailPage = CurrentWorldBossDetailPage.New(arg0.pagesTF, arg0.event)

	arg0.currentBossDetailPage:Setup(arg0.bossProxy)

	arg0.challengeArchivesBossPage = ArchivesWorldBossChallengePage.New(arg0.pagesTF, arg0.event, arg0.contextData)

	arg0.challengeArchivesBossPage:Setup(arg0.bossProxy)

	arg0.archivesListPage = ArchivesWorldBossListPage.New(arg0.pagesTF, arg0.event)

	arg0.archivesListPage:Setup(arg0.bossProxy)

	arg0.archivesEmptyPage = ArchivesWorldBossEmptyPage.New(arg0.pagesTF, arg0.event)

	arg0.archivesEmptyPage:Setup(arg0.bossProxy)

	arg0.archivesDetailPage = ArchivesWorldBossDetailPage.New(arg0.pagesTF, arg0.event)

	arg0.archivesDetailPage:Setup(arg0.bossProxy)

	arg0.formationPreviewPage = WorldBossFormationPreViewPage.New(arg0.pagesTF, arg0.event)

	arg0.bossProxy:AddListener(WorldBossProxy.EventBossUpdated, arg0.onBossUpdated)
end

function var0.AddListeners(arg0)
	arg0:bind(var0.ON_SWITCH, function(arg0, arg1)
		arg0:SwitchPage(arg1)
	end)
	arg0:bind(var0.ON_QUIT_ARCHIVES_LIST, function()
		arg0:OnBack()
	end)
end

function var0.RemoveListeners(arg0)
	arg0.bossProxy:RemoveListener(WorldBossProxy.EventBossUpdated, arg0.onBossUpdated)
end

function var0.OnBossUpdated(arg0)
	arg0.boss = arg0.bossProxy:GetBoss()

	if arg0.page == arg0.currentBossDetailPage or arg0.page == arg0.archivesDetailPage or arg0.page == arg0.currentEmptyPage or arg0.page == arg0.archivesEmptyPage then
		arg0:SwitchPage(var0.PAGE_ENTRANCE)
	end
end

function var0.OnShowFormationPreview(arg0, arg1)
	arg0.formationPreviewPage:ExecuteAction("Show", arg1)
end

function var0.OnRemoveLayers(arg0)
	if arg0.currentBossDetailPage and arg0.currentBossDetailPage:GetLoaded() and arg0.currentBossDetailPage:isShowing() then
		arg0.currentBossDetailPage:TryPlayGuide()
	end
end

function var0.OnAutoBattleResult(arg0, arg1)
	if arg0.archivesDetailPage and arg0.archivesDetailPage:isShowing() then
		arg0.archivesDetailPage:OnAutoBattleResult(arg1)
	end
end

function var0.OnAutoBattleStart(arg0, arg1)
	if arg0.archivesDetailPage and arg0.archivesDetailPage:isShowing() then
		arg0.archivesDetailPage:OnAutoBattleStart(arg1)
	end
end

function var0.OnSwitchArchives(arg0)
	if arg0.archivesListPage and arg0.archivesListPage:GetLoaded() and arg0.archivesListPage:isShowing() then
		arg0.archivesListPage:OnSwitchArchives()
	end
end

function var0.OnGetMetaAwards(arg0)
	if arg0.archivesListPage and arg0.archivesListPage:GetLoaded() and arg0.archivesListPage:isShowing() then
		arg0.archivesListPage:OnGetMetaAwards()
	end
end

function var0.getAwardDone(arg0)
	if arg0.page == arg0.challengeCurrentBossPage then
		arg0.challengeCurrentBossPage:ExecuteAction("CloseGetPage")
	end

	if (arg0.page == arg0.currentEmptyPage or arg0.page == arg0.currentBossDetailPage) and arg0.page:GetLoaded() then
		arg0.page.metaWorldbossBtn:Update()
	end
end

function var0.init(arg0)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.backBtn = arg0:findTF("back_btn")
	arg0.pagesTF = arg0:findTF("pages")

	arg0:AddListeners()
end

function var0.didEnter(arg0)
	arg0.pageStack = {}

	onButton(arg0, arg0.backBtn, function()
		arg0:OnBack()
	end, SOUND_BACK)
	arg0:emit(WorldBossMediator.ON_FETCH_BOSS)
end

function var0.OnBack(arg0)
	if #arg0.pageStack <= 1 then
		arg0:emit(var0.ON_BACK)

		return
	end

	table.remove(arg0.pageStack, #arg0.pageStack)

	local var0 = arg0.pageStack[#arg0.pageStack]

	arg0:_SwitchPage(var0)
end

function var0.SwitchPage(arg0, arg1)
	arg0:_SwitchPage(arg1)

	if #arg0.pageStack > 1 and arg0.pageStack[#arg0.pageStack - 1] == arg1 then
		table.remove(arg0.pageStack, #arg0.pageStack)
	else
		table.insert(arg0.pageStack, arg1)
	end
end

function var0.GetTargetPageType(arg0, arg1, arg2)
	if arg1 == var0.PAGE_CHALLENGE then
		return arg0.challengeCurrentBossPage
	elseif arg1 == var0.PAGE_ARCHIVES_CHALLENGE then
		return arg0.challengeArchivesBossPage
	elseif arg1 == var0.PAGE_ENTRANCE then
		return arg0.entrancePage
	elseif arg1 == var0.PAGE_CURRENT then
		if arg0.boss and arg2 then
			return arg0.currentBossDetailPage
		else
			return arg0.currentEmptyPage
		end
	elseif arg1 == var0.PAGE_ARCHIVES then
		if arg0.boss and not arg2 then
			return arg0.archivesDetailPage
		else
			return arg0.archivesEmptyPage
		end
	elseif arg1 == var0.PAGE_ARCHIVES_LIST then
		return arg0.archivesListPage
	end
end

function var0._SwitchPage(arg0, arg1)
	if arg0.page then
		arg0.page:ExecuteAction("Hide")
	end

	local var0 = false

	if arg0.boss then
		var0 = WorldBossConst._IsCurrBoss(arg0.boss)
	end

	if arg1 == var0.PAGE_ENTRANCE and arg0.boss then
		arg1 = var0 and var0.PAGE_CURRENT or var0.PAGE_ARCHIVES
	end

	if LOCK_WORLDBOSS_ARCHIVES and (arg1 == var0.PAGE_ENTRANCE or arg1 > var0.PAGE_CURRENT) then
		arg1 = var0.PAGE_CURRENT
	end

	arg0.page = arg0:GetTargetPageType(arg1, var0)

	arg0.page:ExecuteAction("Update")

	arg0.pageType = arg1

	setActive(arg0.backBtn, arg0.pageType ~= var0.PAGE_ENTRANCE and arg0.pageType ~= var0.PAGE_ARCHIVES_LIST)
	arg0:LoadEffect(arg1)
end

function var0.LoadEffect(arg0, arg1)
	local var0 = arg1 == var0.PAGE_CURRENT and arg0.boss or arg1 == var0.PAGE_CHALLENGE and arg0.bossProxy:ExistCacheBoss()

	if var0 and not arg0.fireEffect then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetUI("gondouBoss_huoxing", true, function(arg0)
			pg.UIMgr.GetInstance():LoadingOff()

			arg0.fireEffect = arg0

			setParent(arg0.fireEffect, arg0._tf)
			setActive(arg0.fireEffect, true)
		end)
	elseif arg0.fireEffect then
		setActive(arg0.fireEffect, var0)
	end
end

function var0.willExit(arg0)
	if arg0.fireEffect then
		PoolMgr.GetInstance():ReturnUI("gondouBoss_huoxing", arg0.fireEffect)
	end

	if arg0.bossProxy then
		arg0:RemoveListeners()
	end

	if arg0.challengeCurrentBossPage then
		arg0.challengeCurrentBossPage:Destroy()

		arg0.challengeCurrentBossPage = nil
	end

	if arg0.currentEmptyPage then
		arg0.currentEmptyPage:Destroy()

		arg0.currentEmptyPage = nil
	end

	if arg0.currentBossDetailPage then
		arg0.currentBossDetailPage:Destroy()

		arg0.currentBossDetailPage = nil
	end

	if arg0.formationPreviewPage then
		arg0.formationPreviewPage:Destroy()

		arg0.formationPreviewPage = nil
	end

	if arg0.archivesListPage then
		arg0.archivesListPage:Destroy()

		arg0.archivesListPage = nil
	end

	if arg0.archivesDetailPage then
		arg0.archivesDetailPage:Destroy()

		arg0.archivesDetailPage = nil
	end

	if arg0.entrancePage then
		arg0.entrancePage:Destroy()

		arg0.entrancePage = nil
	end

	if arg0.archivesEmptyPage then
		arg0.archivesEmptyPage:Destroy()

		arg0.archivesEmptyPage = nil
	end

	if arg0.challengeArchivesBossPage then
		arg0.challengeArchivesBossPage:Destroy()

		arg0.challengeArchivesBossPage = nil
	end
end

return var0
