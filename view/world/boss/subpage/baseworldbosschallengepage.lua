local var0_0 = class("BaseWorldBossChallengePage", import("view.base.BaseSubView"))

var0_0.Listeners = {
	onRankListUpdated = "OnRankListUpdated",
	onCacheBossUpdated = "OnCacheBossUpdated"
}

local var1_0 = {
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

function var0_0.Setup(arg0_1, arg1_1)
	for iter0_1, iter1_1 in pairs(var0_0.Listeners) do
		arg0_1[iter0_1] = function(...)
			var0_0[iter1_1](arg0_1, ...)
		end
	end

	arg0_1.proxy = arg1_1
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.rankPage = WorldBossRankPage.New(arg0_3._tf.parent.parent, arg0_3.event)

	arg0_3:AddListeners(arg0_3.proxy)
end

function var0_0.OnInit(arg0_4)
	arg0_4:UpdateEmptyCard()

	arg0_4.scrollRect = WorldBossItemList.New(arg0_4:findTF("list_panel/mask/bg/container"), arg0_4:findTF("list_panel/mask/tpl"))

	arg0_4.scrollRect:Make(function(arg0_5, arg1_5)
		arg0_4:OnInitCard(arg0_5, arg1_5)
	end, function(arg0_6, arg1_6)
		arg0_4:OnPreviewCard(arg0_6, arg1_6)
	end, function(arg0_7, arg1_7)
		arg0_4:OnSelectCard(arg0_7, arg1_7)
	end)

	arg0_4.hpSlider = arg0_4:findTF("main/hp/slider"):GetComponent(typeof(Slider))
	arg0_4.levelTxt = arg0_4:findTF("main/hp/level/Text"):GetComponent(typeof(Text))
	arg0_4.hpTxt = arg0_4:findTF("main/hp/Text"):GetComponent(typeof(Text))
	arg0_4.expiredTimeTxt = arg0_4:findTF("main/time/Text"):GetComponent(typeof(Text))
	arg0_4.mainPanel = arg0_4:findTF("main")
	arg0_4.painting = arg0_4:findTF("paint")

	setActive(arg0_4.painting, false)
	setActive(arg0_4.mainPanel, false)

	arg0_4.rankBtn = arg0_4.mainPanel:Find("rank_btn")
	arg0_4.startBtn = arg0_4.mainPanel:Find("start_btn")
	arg0_4.refreshBtn = arg0_4:findTF("list_panel/frame/filter/refresh_btn")
	arg0_4.refreshBtnGray = arg0_4:findTF("list_panel/frame/filter/refresh_btn_gray")
	arg0_4.cdTime = 0

	onButton(arg0_4, arg0_4.refreshBtn, function()
		if arg0_4.cdTime <= pg.TimeMgr.GetInstance():GetServerTime() then
			arg0_4.worldBossId = nil

			arg0_4:emit(WorldBossMediator.UPDATE_CACHE_BOSS_HP, function()
				arg0_4:OnCacheBossUpdated()
			end)
			assert(pg.gameset.world_boss_resfresh, "gameset >>>>>>>>>>world_boss_resfresh")

			local var0_8 = pg.gameset.world_boss_resfresh.key_value

			arg0_4.cdTime = pg.TimeMgr.GetInstance():GetServerTime() + var0_8

			arg0_4:RotateRefreshBtn(var0_8)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_not_refresh_frequently"))
		end
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.refreshBtnGray, function()
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_not_refresh_frequently"))
	end, SFX_PANEL)

	arg0_4.filterToggle = arg0_4:findTF("list_panel/frame/filter/toggles")
	arg0_4.filterFlags = {
		WorldBoss.BOSS_TYPE_WORLD,
		WorldBoss.BOSS_TYPE_FRIEND,
		WorldBoss.BOSS_TYPE_GUILD
	}

	onToggle(arg0_4, arg0_4:findTF("list_panel/frame/filter/toggles/friend"), function(arg0_11)
		arg0_4.filterFlags[2] = arg0_11 and WorldBoss.BOSS_TYPE_FRIEND or -1

		arg0_4:CheckToggle()
		arg0_4:UpdateNonProcessList()
	end, SFX_PANEL)
	GetComponent(arg0_4:findTF("list_panel/frame/filter/toggles/friend/unsel"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_4:findTF("list_panel/frame/filter/toggles/friend/sel"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_4:findTF("list_panel/frame/filter/toggles/guild/sel"), typeof(Image)):SetNativeSize()
	GetComponent(arg0_4:findTF("list_panel/frame/filter/toggles/guild/unsel"), typeof(Image)):SetNativeSize()
	onToggle(arg0_4, arg0_4:findTF("list_panel/frame/filter/toggles/guild"), function(arg0_12)
		arg0_4.filterFlags[3] = arg0_12 and WorldBoss.BOSS_TYPE_GUILD or -1

		arg0_4:CheckToggle()
		arg0_4:UpdateNonProcessList()
	end, SFX_PANEL)
end

function var0_0.UpdateEmptyCard(arg0_13)
	local var0_13 = arg0_13:findTF("list_panel/mask/tpl")
	local var1_13 = WorldBossConst.GetCurrBossGroup()
	local var2_13 = var0_13:Find("empty"):GetComponent(typeof(Image))

	var2_13.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var1_13, "item_04")

	var2_13:SetNativeSize()
end

function var0_0.CheckToggle(arg0_14)
	if _.all(arg0_14.filterFlags, function(arg0_15)
		return arg0_15 == -1
	end) then
		triggerToggle(arg0_14:findTF("list_panel/frame/filter/toggles/friend"), true)
		triggerToggle(arg0_14:findTF("list_panel/frame/filter/toggles/guild"), true)
	end
end

function var0_0.GetResSuffix(arg0_16)
	return ""
end

function var0_0.UpdatePainting(arg0_17, arg1_17)
	if arg0_17.groupId ~= arg1_17 then
		arg0_17.groupId = arg1_17

		local var0_17 = arg0_17:findTF("main/label"):GetComponent(typeof(Image))

		var0_17.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg1_17, "title" .. arg0_17:GetResSuffix())

		var0_17:SetNativeSize()
		setMetaPaintingPrefabAsync(arg0_17.painting, arg0_17.groupId, "lihuisha")

		local var1_17 = WorldBossConst.MetaId2BossId(arg0_17.groupId)
		local var2_17 = pg.world_joint_boss_template[var1_17].p_offset_other or var1_0[arg0_17.groupId]

		if var2_17 then
			setAnchoredPosition(arg0_17.painting, {
				x = var2_17[1],
				y = var2_17[2]
			})

			local var3_17 = var2_17[3] or 1
			local var4_17 = var2_17[4] or 1

			arg0_17.painting.localScale = Vector3(var3_17, var4_17, 1)
		end
	end
end

function var0_0.RotateRefreshBtn(arg0_18, arg1_18)
	LeanTween.rotate(rtf(arg0_18.refreshBtn), -360, 0.5):setOnComplete(System.Action(function()
		arg0_18.refreshBtn.localEulerAngles = Vector3(0, 0, 0)

		setActive(arg0_18.refreshBtnGray, false)
		setActive(arg0_18.refreshBtnGray, true)
	end))

	if arg0_18.refreshtimer then
		arg0_18.refreshtimer:Stop()

		arg0_18.refreshtimer = nil
	end

	arg0_18.refreshtimer = Timer.New(function()
		setActive(arg0_18.refreshBtnGray, true)
		setActive(arg0_18.refreshBtnGray, false)
	end, arg1_18, 1)

	arg0_18.refreshtimer:Start()
end

function var0_0.AddListeners(arg0_21, arg1_21)
	arg1_21:AddListener(WorldBossProxy.EventRankListUpdated, arg0_21.onRankListUpdated)
	arg1_21:AddListener(WorldBossProxy.EventCacheBossListUpdated, arg0_21.onCacheBossUpdated)
end

function var0_0.RemoveListeners(arg0_22, arg1_22)
	arg1_22:RemoveListener(WorldBossProxy.EventRankListUpdated, arg0_22.onRankListUpdated)
	arg1_22:RemoveListener(WorldBossProxy.EventCacheBossListUpdated, arg0_22.onCacheBossUpdated)
end

function var0_0.OnCacheBossUpdated(arg0_23)
	arg0_23:UpdateNonProcessList()
end

function var0_0.OnRankListUpdated(arg0_24, arg1_24, arg2_24, arg3_24)
	if arg0_24.boss and arg0_24.boss.id == arg3_24 and arg0_24.rankPage:GetLoaded() and arg0_24.rankPage:isActive() then
		arg0_24.rankPage:ExecuteAction("Update", arg0_24.proxy, arg0_24.boss.id)
	end
end

function var0_0.Update(arg0_25)
	arg0_25:emit(WorldBossMediator.UPDATE_CACHE_BOSS_HP, function()
		arg0_25:UpdateNonProcessList()
		arg0_25:Show()
	end)
end

function var0_0.UpdateNonProcessList(arg0_27)
	local var0_27 = arg0_27.proxy:GetCacheBossList()

	local function var1_27(arg0_28)
		local var0_28 = _.select(arg0_27.filterFlags, function(arg0_29)
			return arg0_29 >= 0
		end)

		return _.any(var0_28, function(arg0_30)
			return arg0_28:GetType() == arg0_30
		end)
	end

	arg0_27.displays = {}

	for iter0_27, iter1_27 in ipairs(var0_27) do
		if not iter1_27:isDeath() and not iter1_27:IsExpired() and var1_27(iter1_27) and not iter1_27:IsFullPeople() and arg0_27:OnFilterBoss(iter1_27) then
			table.insert(arg0_27.displays, iter1_27)
		end
	end

	table.sort(arg0_27.displays, function(arg0_31, arg1_31)
		return arg0_31:GetJoinTime() > arg1_31:GetJoinTime()
	end)

	local var2_27 = 1

	for iter2_27, iter3_27 in ipairs(arg0_27.displays) do
		if iter3_27.id == arg0_27.contextData.worldBossId or iter3_27.id == arg0_27.worldBossId then
			var2_27 = iter2_27

			break
		end
	end

	arg0_27.contextData.worldBossId = nil
	WorldBossScene.inOtherBossBattle = nil

	arg0_27.scrollRect:Align(#arg0_27.displays, var2_27)
	setActive(arg0_27.filterToggle, true)
	setActive(arg0_27.refreshBtn, true)
end

function var0_0.OnFilterBoss(arg0_32, arg1_32)
	return true
end

function var0_0.OnInitCard(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.displays[arg2_33 + 1]
	local var1_33 = false
	local var2_33 = arg1_33:Find("tags")

	removeOnButton(arg1_33)
	setText(arg1_33:Find("tags/friend/Text"), "")
	setText(arg1_33:Find("tags/guild/Text"), "")

	if var0_33 then
		var1_33 = var0_33:isDeath()

		local var3_33 = var0_33:GetType()

		setActive(arg1_33:Find("tags/friend"), var3_33 == WorldBoss.BOSS_TYPE_FRIEND)
		setActive(arg1_33:Find("tags/guild"), var3_33 == WorldBoss.BOSS_TYPE_GUILD)
		setActive(arg1_33:Find("tags/world"), var3_33 == WorldBoss.BOSS_TYPE_WORLD)

		var2_33.anchoredPosition = Vector3(0, 14, 0)

		setText(arg1_33:Find("tags/friend/Text"), var0_33:GetRoleName())
		setText(arg1_33:Find("tags/guild/Text"), var0_33:GetRoleName())
		onButton(arg0_33, arg1_33, function()
			arg0_33.scrollRect:SliceTo(arg1_33)
		end, SFX_PANEL)
		arg0_33:UpdateCardStyle(arg1_33, var0_33.config.meta_id)
	end

	setActive(arg1_33:Find("complete"), var0_33 and var1_33)
	setActive(arg1_33:Find("raiding"), var0_33 and not var1_33)
	setActive(arg1_33:Find("empty"), not var0_33)
	setActive(var2_33, var0_33)
	setActive(arg1_33:Find("tags/friend/Text"), false)
	setActive(arg1_33:Find("tags/guild/Text"), false)
end

function var0_0.UpdateCardStyle(arg0_35, arg1_35, arg2_35)
	arg1_35:Find("raiding"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg2_35, "item_03")

	local var0_35 = arg1_35:Find("empty"):GetComponent(typeof(Image))

	var0_35.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg2_35, "item_04")

	var0_35:SetNativeSize()

	arg1_35:Find("selected/challenging"):GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg2_35, "item_01" .. arg0_35:GetResSuffix())
end

function var0_0.OnPreviewCard(arg0_36, arg1_36, arg2_36)
	if arg0_36.prevSelected and arg0_36.prevSelected.boss then
		arg0_36.prevSelected.childTF:Find("tags").anchoredPosition = Vector3(0, 14, 0)

		setActive(arg0_36.prevSelected.childTF:Find("tags/friend/Text"), false)
		setActive(arg0_36.prevSelected.childTF:Find("tags/guild/Text"), false)
		setActive(arg0_36.prevSelected.childTF:Find("selected"), false)
	end

	local var0_36 = arg0_36.displays[arg2_36 + 1]

	if var0_36 then
		local var1_36 = var0_36:isDeath()

		setActive(arg1_36:Find("selected/challenging"), not var1_36)
		setActive(arg1_36:Find("selected/finished"), var1_36)

		arg1_36:Find("tags").anchoredPosition = Vector3(-17, 41.69, 0)

		setActive(arg1_36:Find("tags/friend/Text"), true)
		setActive(arg1_36:Find("tags/guild/Text"), true)
		arg0_36:UpdateMainView(var0_36)
	end

	setActive(arg1_36:Find("selected"), var0_36)

	arg0_36.prevSelected = {
		childTF = arg1_36,
		boss = var0_36
	}
end

function var0_0.OnSelectCard(arg0_37, arg1_37, arg2_37)
	local var0_37 = arg0_37.displays[arg2_37 + 1]

	arg0_37.boss = var0_37
	arg0_37.worldBossId = nil

	if arg0_37.boss then
		arg0_37.worldBossId = var0_37.id

		arg0_37:UpdateMainView(var0_37)
	else
		setActive(arg0_37.mainPanel, false)
		setActive(arg0_37.painting, false)
	end
end

function var0_0.UpdateMainView(arg0_38, arg1_38, arg2_38)
	setActive(arg0_38.mainPanel, true)
	setActive(arg0_38.painting, true)

	local var0_38 = arg0_38.proxy
	local var1_38 = arg1_38:isDeath()
	local var2_38 = arg1_38:GetLeftTime()

	onButton(arg0_38, arg0_38.rankBtn, function()
		arg0_38.rankPage:ExecuteAction("Update", arg0_38.proxy, arg1_38.id)
	end, SFX_PANEL)

	local var3_38 = arg1_38:GetMaxHp()

	arg0_38.hpSlider.value = 1
	arg0_38.levelTxt.text = arg1_38:GetLevel()
	arg0_38.hpTxt.text = "HP:" .. var3_38

	onButton(arg0_38, arg0_38.startBtn, function()
		arg0_38:emit(WorldBossMediator.ON_BATTLE, arg1_38.id, true)
	end, SFX_PANEL)
	setActive(arg0_38.startBtn, not var1_38 and var2_38 > 0)
	arg0_38:removeBattleTimer()

	if not var1_38 and not arg2_38 then
		arg0_38:addBattleTimer(arg1_38)
	end

	arg0_38:UpdatePainting(arg1_38.config.meta_id)
end

function var0_0.addBattleTimer(arg0_41, arg1_41)
	local var0_41 = arg1_41:GetExpiredTime()

	if var0_41 - pg.TimeMgr.GetInstance():GetServerTime() >= 0 then
		arg0_41.timer = Timer.New(function()
			if arg0_41.exited then
				arg0_41:removeBattleTimer()

				return
			end

			local var0_42 = var0_41 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_42 <= 0 then
				arg0_41.expiredTimeTxt.text = i18n("world_word_expired")

				arg0_41:removeBattleTimer()
				arg0_41:UpdateMainView(arg1_41, true)
			else
				arg0_41.expiredTimeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_42)
			end
		end, 1, -1)

		arg0_41.timer:Start()
		arg0_41.timer.func()
	else
		arg0_41.expiredTimeTxt.text = i18n("world_word_expired")

		arg0_41:UpdateMainView(arg1_41, true)
	end
end

function var0_0.removeBattleTimer(arg0_43)
	if arg0_43.timer then
		arg0_43.timer:Stop()

		arg0_43.timer = nil
	end
end

function var0_0.OnDestroy(arg0_44)
	retMetaPaintingPrefab(arg0_44.painting, arg0_44.groupId)
	arg0_44:RemoveListeners(arg0_44.proxy)
	arg0_44:removeBattleTimer()
	arg0_44.scrollRect:Dispose()
	arg0_44.rankPage:Destroy()

	if arg0_44.refreshtimer then
		arg0_44.refreshtimer:Stop()

		arg0_44.refreshtimer = nil
	end

	arg0_44.exited = true
end

return var0_0
