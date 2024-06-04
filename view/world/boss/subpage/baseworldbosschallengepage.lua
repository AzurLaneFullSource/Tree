local var0 = class("BaseWorldBossChallengePage", import("view.base.BaseSubView"))

var0.Listeners = {
	onRankListUpdated = "OnRankListUpdated",
	onCacheBossUpdated = "OnCacheBossUpdated"
}

local var1 = {
	[970701] = {
		411,
		777
	},
	[970702] = {
		411,
		574
	},
	[970201] = {
		296,
		610,
		0.95,
		0.95
	},
	[970703] = {
		1424,
		1267.9,
		1.7,
		1.7
	},
	[970401] = {
		480,
		635
	},
	[970402] = {
		480,
		635
	},
	[970403] = {
		510,
		611.2,
		0.95,
		0.95
	}
}

function var0.Setup(arg0, arg1)
	for iter0, iter1 in pairs(var0.Listeners) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.proxy = arg1
end

function var0.OnLoaded(arg0)
	arg0.rankPage = WorldBossRankPage.New(arg0._tf.parent.parent, arg0.event)

	arg0:AddListeners(arg0.proxy)
end

function var0.OnInit(arg0)
	arg0:UpdateEmptyCard()

	arg0.scrollRect = WorldBossItemList.New(arg0:findTF("list_panel/mask/bg/container"), arg0:findTF("list_panel/mask/tpl"))

	arg0.scrollRect:Make(function(arg0, arg1)
		arg0:OnInitCard(arg0, arg1)
	end, function(arg0, arg1)
		arg0:OnPreviewCard(arg0, arg1)
	end, function(arg0, arg1)
		arg0:OnSelectCard(arg0, arg1)
	end)

	arg0.hpSlider = arg0:findTF("main/hp/slider"):GetComponent(typeof(Slider))
	arg0.levelTxt = arg0:findTF("main/hp/level/Text"):GetComponent(typeof(Text))
	arg0.hpTxt = arg0:findTF("main/hp/Text"):GetComponent(typeof(Text))
	arg0.expiredTimeTxt = arg0:findTF("main/time/Text"):GetComponent(typeof(Text))
	arg0.mainPanel = arg0:findTF("main")
	arg0.painting = arg0:findTF("paint")

	setActive(arg0.painting, false)
	setActive(arg0.mainPanel, false)

	arg0.rankBtn = arg0.mainPanel:Find("rank_btn")
	arg0.startBtn = arg0.mainPanel:Find("start_btn")
	arg0.refreshBtn = arg0:findTF("list_panel/frame/filter/refresh_btn")
	arg0.refreshBtnGray = arg0:findTF("list_panel/frame/filter/refresh_btn_gray")
	arg0.cdTime = 0

	onButton(arg0, arg0.refreshBtn, function()
		if arg0.cdTime <= pg.TimeMgr.GetInstance():GetServerTime() then
			arg0.worldBossId = nil

			arg0:emit(WorldBossMediator.UPDATE_CACHE_BOSS_HP, function()
				arg0:OnCacheBossUpdated()
			end)
			assert(pg.gameset.world_boss_resfresh, "gameset >>>>>>>>>>world_boss_resfresh")

			local var0 = pg.gameset.world_boss_resfresh.key_value

			arg0.cdTime = pg.TimeMgr.GetInstance():GetServerTime() + var0

			arg0:RotateRefreshBtn(var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_not_refresh_frequently"))
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.refreshBtnGray, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_not_refresh_frequently"))
	end, SFX_PANEL)

	arg0.filterToggle = arg0:findTF("list_panel/frame/filter/toggles")
	arg0.filterFlags = {
		WorldBoss.BOSS_TYPE_WORLD,
		WorldBoss.BOSS_TYPE_FRIEND,
		WorldBoss.BOSS_TYPE_GUILD
	}

	onToggle(arg0, arg0:findTF("list_panel/frame/filter/toggles/friend"), function(arg0)
		arg0.filterFlags[2] = arg0 and WorldBoss.BOSS_TYPE_FRIEND or -1

		arg0:CheckToggle()
		arg0:UpdateNonProcessList()
	end, SFX_PANEL)
	GetComponent(arg0:findTF("list_panel/frame/filter/toggles/friend/unsel"), typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("list_panel/frame/filter/toggles/friend/sel"), typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("list_panel/frame/filter/toggles/guild/sel"), typeof(Image)):SetNativeSize()
	GetComponent(arg0:findTF("list_panel/frame/filter/toggles/guild/unsel"), typeof(Image)):SetNativeSize()
	onToggle(arg0, arg0:findTF("list_panel/frame/filter/toggles/guild"), function(arg0)
		arg0.filterFlags[3] = arg0 and WorldBoss.BOSS_TYPE_GUILD or -1

		arg0:CheckToggle()
		arg0:UpdateNonProcessList()
	end, SFX_PANEL)
end

function var0.UpdateEmptyCard(arg0)
	local var0 = arg0:findTF("list_panel/mask/tpl")
	local var1 = WorldBossConst.GetCurrBossGroup()
	local var2 = var0:Find("empty"):GetComponent(typeof(Image))

	var2.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var1, "item_04")

	var2:SetNativeSize()
end

function var0.CheckToggle(arg0)
	if _.all(arg0.filterFlags, function(arg0)
		return arg0 == -1
	end) then
		triggerToggle(arg0:findTF("list_panel/frame/filter/toggles/friend"), true)
		triggerToggle(arg0:findTF("list_panel/frame/filter/toggles/guild"), true)
	end
end

function var0.GetResSuffix(arg0)
	return ""
end

function var0.UpdatePainting(arg0, arg1)
	if arg0.groupId ~= arg1 then
		arg0.groupId = arg1

		local var0 = arg0:findTF("main/label"):GetComponent(typeof(Image))

		var0.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg1, "title" .. arg0:GetResSuffix())

		var0:SetNativeSize()
		setMetaPaintingPrefabAsync(arg0.painting, arg0.groupId, "lihuisha")

		local var1 = WorldBossConst.MetaId2BossId(arg0.groupId)
		local var2 = pg.world_joint_boss_template[var1].p_offset_other or var1[arg0.groupId]

		if var2 then
			setAnchoredPosition(arg0.painting, {
				x = var2[1],
				y = var2[2]
			})

			local var3 = var2[3] or 1
			local var4 = var2[4] or 1

			arg0.painting.localScale = Vector3(var3, var4, 1)
		end
	end
end

function var0.RotateRefreshBtn(arg0, arg1)
	LeanTween.rotate(rtf(arg0.refreshBtn), -360, 0.5):setOnComplete(System.Action(function()
		arg0.refreshBtn.localEulerAngles = Vector3(0, 0, 0)

		setActive(arg0.refreshBtnGray, false)
		setActive(arg0.refreshBtnGray, true)
	end))

	if arg0.refreshtimer then
		arg0.refreshtimer:Stop()

		arg0.refreshtimer = nil
	end

	arg0.refreshtimer = Timer.New(function()
		setActive(arg0.refreshBtnGray, true)
		setActive(arg0.refreshBtnGray, false)
	end, arg1, 1)

	arg0.refreshtimer:Start()
end

function var0.AddListeners(arg0, arg1)
	arg1:AddListener(WorldBossProxy.EventRankListUpdated, arg0.onRankListUpdated)
	arg1:AddListener(WorldBossProxy.EventCacheBossListUpdated, arg0.onCacheBossUpdated)
end

function var0.RemoveListeners(arg0, arg1)
	arg1:RemoveListener(WorldBossProxy.EventRankListUpdated, arg0.onRankListUpdated)
	arg1:RemoveListener(WorldBossProxy.EventCacheBossListUpdated, arg0.onCacheBossUpdated)
end

function var0.OnCacheBossUpdated(arg0)
	arg0:UpdateNonProcessList()
end

function var0.OnRankListUpdated(arg0, arg1, arg2, arg3)
	if arg0.boss and arg0.boss.id == arg3 and arg0.rankPage:GetLoaded() and arg0.rankPage:isActive() then
		arg0.rankPage:ExecuteAction("Update", arg0.proxy, arg0.boss.id)
	end
end

function var0.Update(arg0)
	arg0:emit(WorldBossMediator.UPDATE_CACHE_BOSS_HP, function()
		arg0:UpdateNonProcessList()
		arg0:Show()
	end)
end

function var0.UpdateNonProcessList(arg0)
	local var0 = arg0.proxy:GetCacheBossList()

	local function var1(arg0)
		local var0 = _.select(arg0.filterFlags, function(arg0)
			return arg0 >= 0
		end)

		return _.any(var0, function(arg0)
			return arg0:GetType() == arg0
		end)
	end

	arg0.displays = {}

	for iter0, iter1 in ipairs(var0) do
		if not iter1:isDeath() and not iter1:IsExpired() and var1(iter1) and not iter1:IsFullPeople() and arg0:OnFilterBoss(iter1) then
			table.insert(arg0.displays, iter1)
		end
	end

	table.sort(arg0.displays, function(arg0, arg1)
		return arg0:GetJoinTime() > arg1:GetJoinTime()
	end)

	local var2 = 1

	for iter2, iter3 in ipairs(arg0.displays) do
		if iter3.id == arg0.contextData.worldBossId or iter3.id == arg0.worldBossId then
			var2 = iter2

			break
		end
	end

	arg0.contextData.worldBossId = nil
	WorldBossScene.inOtherBossBattle = nil

	arg0.scrollRect:Align(#arg0.displays, var2)
	setActive(arg0.filterToggle, true)
	setActive(arg0.refreshBtn, true)
end

function var0.OnFilterBoss(arg0, arg1)
	return true
end

function var0.OnInitCard(arg0, arg1, arg2)
	local var0 = arg0.displays[arg2 + 1]
	local var1 = false
	local var2 = arg1:Find("tags")

	removeOnButton(arg1)
	setText(arg1:Find("tags/friend/Text"), "")
	setText(arg1:Find("tags/guild/Text"), "")

	if var0 then
		var1 = var0:isDeath()

		local var3 = var0:GetType()

		setActive(arg1:Find("tags/friend"), var3 == WorldBoss.BOSS_TYPE_FRIEND)
		setActive(arg1:Find("tags/guild"), var3 == WorldBoss.BOSS_TYPE_GUILD)
		setActive(arg1:Find("tags/world"), var3 == WorldBoss.BOSS_TYPE_WORLD)

		var2.anchoredPosition = Vector3(0, 14, 0)

		setText(arg1:Find("tags/friend/Text"), var0:GetRoleName())
		setText(arg1:Find("tags/guild/Text"), var0:GetRoleName())
		onButton(arg0, arg1, function()
			arg0.scrollRect:SliceTo(arg1)
		end, SFX_PANEL)
		arg0:UpdateCardStyle(arg1, var0.config.meta_id)
	end

	setActive(arg1:Find("complete"), var0 and var1)
	setActive(arg1:Find("raiding"), var0 and not var1)
	setActive(arg1:Find("empty"), not var0)
	setActive(var2, var0)
	setActive(arg1:Find("tags/friend/Text"), false)
	setActive(arg1:Find("tags/guild/Text"), false)
end

function var0.UpdateCardStyle(arg0, arg1, arg2)
	arg1:Find("raiding"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg2, "item_03")

	local var0 = arg1:Find("empty"):GetComponent(typeof(Image))

	var0.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg2, "item_04")

	var0:SetNativeSize()

	arg1:Find("selected/challenging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg2, "item_01" .. arg0:GetResSuffix())
end

function var0.OnPreviewCard(arg0, arg1, arg2)
	if arg0.prevSelected and arg0.prevSelected.boss then
		arg0.prevSelected.childTF:Find("tags").anchoredPosition = Vector3(0, 14, 0)

		setActive(arg0.prevSelected.childTF:Find("tags/friend/Text"), false)
		setActive(arg0.prevSelected.childTF:Find("tags/guild/Text"), false)
		setActive(arg0.prevSelected.childTF:Find("selected"), false)
	end

	local var0 = arg0.displays[arg2 + 1]

	if var0 then
		local var1 = var0:isDeath()

		setActive(arg1:Find("selected/challenging"), not var1)
		setActive(arg1:Find("selected/finished"), var1)

		arg1:Find("tags").anchoredPosition = Vector3(-17, 41.69, 0)

		setActive(arg1:Find("tags/friend/Text"), true)
		setActive(arg1:Find("tags/guild/Text"), true)
		arg0:UpdateMainView(var0)
	end

	setActive(arg1:Find("selected"), var0)

	arg0.prevSelected = {
		childTF = arg1,
		boss = var0
	}
end

function var0.OnSelectCard(arg0, arg1, arg2)
	local var0 = arg0.displays[arg2 + 1]

	arg0.boss = var0
	arg0.worldBossId = nil

	if arg0.boss then
		arg0.worldBossId = var0.id

		arg0:UpdateMainView(var0)
	else
		setActive(arg0.mainPanel, false)
		setActive(arg0.painting, false)
	end
end

function var0.UpdateMainView(arg0, arg1, arg2)
	setActive(arg0.mainPanel, true)
	setActive(arg0.painting, true)

	local var0 = arg0.proxy
	local var1 = arg1:isDeath()
	local var2 = arg1:GetLeftTime()

	onButton(arg0, arg0.rankBtn, function()
		arg0.rankPage:ExecuteAction("Update", arg0.proxy, arg1.id)
	end, SFX_PANEL)

	local var3 = arg1:GetMaxHp()

	arg0.hpSlider.value = 1
	arg0.levelTxt.text = arg1:GetLevel()
	arg0.hpTxt.text = "HP:" .. var3

	onButton(arg0, arg0.startBtn, function()
		arg0:emit(WorldBossMediator.ON_BATTLE, arg1.id, true)
	end, SFX_PANEL)
	setActive(arg0.startBtn, not var1 and var2 > 0)
	arg0:removeBattleTimer()

	if not var1 and not arg2 then
		arg0:addBattleTimer(arg1)
	end

	arg0:UpdatePainting(arg1.config.meta_id)
end

function var0.addBattleTimer(arg0, arg1)
	local var0 = arg1:GetExpiredTime()

	if var0 - pg.TimeMgr.GetInstance():GetServerTime() >= 0 then
		arg0.timer = Timer.New(function()
			if arg0.exited then
				arg0:removeBattleTimer()

				return
			end

			local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0 <= 0 then
				arg0.expiredTimeTxt.text = i18n("world_word_expired")

				arg0:removeBattleTimer()
				arg0:UpdateMainView(arg1, true)
			else
				arg0.expiredTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
			end
		end, 1, -1)

		arg0.timer:Start()
		arg0.timer.func()
	else
		arg0.expiredTimeTxt.text = i18n("world_word_expired")

		arg0:UpdateMainView(arg1, true)
	end
end

function var0.removeBattleTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	retMetaPaintingPrefab(arg0.painting, arg0.groupId)
	arg0:RemoveListeners(arg0.proxy)
	arg0:removeBattleTimer()
	arg0.scrollRect:Dispose()
	arg0.rankPage:Destroy()

	if arg0.refreshtimer then
		arg0.refreshtimer:Stop()

		arg0.refreshtimer = nil
	end

	arg0.exited = true
end

return var0
