local var0 = class("BaseWorldBossDetailPage", import("....base.BaseSubView"))
local var1 = {
	[970701] = {
		-36.45481,
		717.0379
	},
	[970702] = {
		-36.45481,
		629.5
	},
	[970201] = {
		-36.45481,
		610.5,
		0.95,
		0.95
	},
	[970703] = {
		818,
		1268.1,
		1.7,
		1.7
	},
	[970401] = {
		-58.2,
		634.2
	},
	[970402] = {
		-58.2,
		634.2
	},
	[970403] = {
		-28.2,
		609.2,
		0.95,
		0.95
	}
}

function var0.Setup(arg0, arg1)
	local var0 = {
		onBossUpdated = "OnBossUpdated",
		onRankListUpdated = "OnRankListUpdated",
		onPtUpdated = "OnPtUpdated",
		onBossProgressUpdate = "OnBossProgressUpdate"
	}

	for iter0, iter1 in pairs(var0) do
		arg0[iter0] = function(...)
			var0[iter1](arg0, ...)
		end
	end

	arg0.proxy = arg1

	arg0:AddListeners(arg0.proxy)
end

function var0.OnLoaded(arg0)
	arg0.supportBtn = arg0:findTF("btns/help_btn")
	arg0.startBtn = arg0:findTF("btns/start_btn")
	arg0.awardBtn = arg0:findTF("btns/award_btn")
	arg0.timeTF = arg0:findTF("btns/time")
	arg0.leftTime = arg0:findTF("btns/time/label/Text"):GetComponent(typeof(Text))
	arg0.awardList = UIItemList.New(arg0:findTF("award_panel/list"), arg0:findTF("award_panel/list/tpl"))
	arg0.levelTxt = arg0:findTF("hp/level/Text"):GetComponent(typeof(Text))
	arg0.hpTxt = arg0:findTF("hp/Text"):GetComponent(typeof(Text))
	arg0.hpSlider = arg0:findTF("hp/slider"):GetComponent(typeof(Slider))
	arg0.painting = arg0:findTF("paint")
	arg0.infoAndRankPanel = WorldBossInfoAndRankPanel.New(arg0._tf, arg0.event)

	arg0.infoAndRankPanel:SetCallback(function(arg0)
		setGray(arg0.awardBtn, arg0, true)
	end, function(arg0, arg1)
		setGray(arg0.supportBtn, arg1 <= arg0, true)
		onButton(arg0, arg0.supportBtn, function()
			if arg0 >= arg1 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_max_challenge_people_cnt"))

				return
			end

			if arg0.boss:isDeath() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))
			else
				arg0:OnRescue()
			end
		end, SFX_PANEL)
	end)
	setText(arg0:findTF("btns/time/label"), i18n("time_remaining_tip"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.startBtn, function()
		arg0:OnStart()
	end, SFX_PANEL)
	onButton(arg0, arg0.awardBtn, function()
		if arg0.boss:GetLeftTime() <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_award_expired"))
		else
			if arg0.boss:ShouldWaitForResult() then
				return
			end

			arg0:emit(WorldBossMediator.ON_SUBMIT_AWARD, arg0.boss.id)
		end
	end, SFX_PANEL)
end

function var0.OnStart(arg0)
	if arg0.boss:isDeath() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))
	elseif arg0.boss:GetLeftTime() <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))
	else
		arg0:emit(WorldBossMediator.ON_BATTLE, arg0.boss.id)
	end
end

function var0.AddListeners(arg0, arg1)
	arg1:AddListener(WorldBossProxy.EventPtUpdated, arg0.onPtUpdated)
	arg1:AddListener(WorldBossProxy.EventBossUpdated, arg0.onBossUpdated)
	arg1:AddListener(WorldBossProxy.EventRankListUpdated, arg0.onRankListUpdated)
	arg1:AddListener(WorldBossProxy.EventUnlockProgressUpdated, arg0.onBossProgressUpdate)
end

function var0.RemoveListeners(arg0, arg1)
	arg1:RemoveListener(WorldBossProxy.EventPtUpdated, arg0.onPtUpdated)
	arg1:RemoveListener(WorldBossProxy.EventBossUpdated, arg0.onBossUpdated)
	arg1:RemoveListener(WorldBossProxy.EventRankListUpdated, arg0.onRankListUpdated)
	arg1:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, arg0.onBossProgressUpdate)
end

function var0.OnBossUpdated(arg0)
	if arg0:isShowing() then
		arg0:UpdateBoss()
	end
end

function var0.OnRankListUpdated(arg0, arg1, arg2, arg3)
	if arg0:isShowing() and arg0.boss and arg0.boss.id == arg3 and arg0.infoAndRankPanel and arg0.infoAndRankPanel:GetLoaded() then
		arg0.infoAndRankPanel:FlushRank()
	end
end

function var0.OnBossProgressUpdate(arg0)
	if arg0:isShowing() then
		arg0:OnUpdateRes()
	end
end

function var0.OnPtUpdated(arg0)
	if arg0:isShowing() then
		arg0:OnUpdatePt()
	end
end

function var0.UpdatePainting(arg0, arg1)
	if not arg1 then
		return
	end

	if arg0.groupId ~= arg1 then
		arg0.groupId = arg1

		local var0 = arg0:findTF("label"):GetComponent(typeof(Image))

		var0.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg0.groupId, "title" .. arg0:GetResSuffix())

		var0:SetNativeSize()
		setMetaPaintingPrefabAsync(arg0.painting, arg0.groupId, "lihuisha", function()
			arg0:OnPaintingLoad()
		end)

		local var1
		local var2 = WorldBossConst.MetaId2BossId(arg1)

		if var2 then
			var1 = pg.world_joint_boss_template[var2].p_offset or var1[arg1]
		else
			var1 = var1[arg1]
		end

		if var1 then
			setAnchoredPosition(arg0.painting, {
				x = var1[1],
				y = var1[2]
			})

			local var3 = var1[3] or 1
			local var4 = var1[4] or 1

			arg0.painting.localScale = Vector3(var3, var4, 1)
		end
	else
		arg0:OnPaintingLoad()
	end
end

function var0.UpdateBoss(arg0)
	arg0.boss = arg0.proxy:GetBoss()

	if arg0.boss then
		arg0:UpdateMainInfo()
		arg0:RemoveChallengeTimer()
		arg0:AddChanllengTimer()
		arg0:RemoveGetAwardTimer()
		arg0:AddGetAwaradTimer()
	end
end

function var0.Update(arg0)
	arg0:UpdateBoss()
	arg0:Show()

	if arg0.boss then
		arg0.infoAndRankPanel:ExecuteAction("Flush", arg0.boss, arg0.proxy)
		arg0:UpdateAward()
		arg0:OnUpdateRes()
		arg0:OnUpdatePt()
	end
end

function var0.UpdateAward(arg0)
	local var0 = arg0.boss:GetAwards()

	arg0.awardList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]
			local var1 = {
				count = 0,
				type = var0[1],
				id = var0[2]
			}

			updateDrop(arg2:Find("equipment/bg"), var1)

			local var2 = arg2:Find("mask/name"):GetComponent("ScrollText")
			local var3 = var1:getConfig("name")

			var2:SetText(var3)
			onButton(arg0, arg2, function()
				arg0:emit(BaseUI.ON_DROP, var1)
			end, SFX_PANEL)
		end
	end)
	arg0.awardList:align(math.min(#var0, 3))
end

function var0.UpdateMainInfo(arg0)
	local var0 = arg0.boss
	local var1 = arg0.proxy
	local var2 = var0:GetHP()
	local var3 = var0:GetMaxHp()

	arg0.levelTxt.text = var0:GetLevel()
	arg0.hpTxt.text = var2 .. "/<color=#E31D15>" .. var3 .. "</color>"
	arg0.hpSlider.value = var2 / var3

	local var4 = var0:isDeath()
	local var5 = var0:IsExpired()
	local var6 = var1:canGetSelfAward()

	setActive(arg0.supportBtn, not var4 and not var5)
	setActive(tf(arg0.leftTime).parent, true)
	setActive(arg0.awardBtn, var4 and var6)
	setActive(arg0.startBtn, not var4 and not var5)
	arg0:UpdatePainting(var0.config.meta_id)
end

function var0.AddChanllengTimer(arg0)
	local var0 = arg0.boss

	if var0:isDeath() then
		return
	end

	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = var0:GetExpiredTime()

	local function var3()
		arg0.leftTime.text = i18n("world_word_expired")

		onNextTick(function()
			arg0:OnBossExpired()
		end)
	end

	if var2 < var1 then
		var3()
	else
		arg0.bossTimer = Timer.New(function()
			local var0 = var2 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0 > 0 then
				arg0.leftTime.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
			else
				var3()
				arg0:RemoveChallengeTimer()
			end
		end, 1, -1)

		arg0.bossTimer:Start()
		arg0.bossTimer.func()
	end
end

function var0.RemoveChallengeTimer(arg0)
	if arg0.bossTimer then
		arg0.bossTimer:Stop()

		arg0.bossTimer = nil
	end
end

function var0.AddGetAwaradTimer(arg0)
	local var0 = arg0.boss

	if not var0:isDeath() then
		return
	end

	local var1 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2 = var0:GetExpiredTime()

	local function var3()
		arg0.leftTime.text = i18n("world_word_expired")

		onNextTick(function()
			arg0:OnBossExpired()
		end)
	end

	if var2 < var1 then
		var3()
	else
		arg0.awardTimer = Timer.New(function()
			local var0 = var2 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0 > 0 then
				arg0.leftTime.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
			else
				var3()
				arg0:RemoveGetAwardTimer()
			end
		end, 1, -1)

		arg0.awardTimer:Start()
		arg0.awardTimer.func()
	end
end

function var0.OnBossExpired(arg0)
	arg0:emit(WorldBossMediator.ON_SELF_BOSS_OVERTIME)
end

function var0.RemoveGetAwardTimer(arg0)
	if arg0.awardTimer then
		arg0.awardTimer:Stop()

		arg0.awardTimer = nil
	end
end

function var0.OnDestroy(arg0)
	if arg0.groupId then
		arg0:OnRetPaintingPrefab()
		retMetaPaintingPrefab(arg0.painting, arg0.groupId)
	end

	arg0:RemoveGetAwardTimer()
	arg0:RemoveListeners(arg0.proxy)
	arg0:RemoveChallengeTimer()

	if arg0.infoAndRankPanel then
		arg0.infoAndRankPanel:Destroy()

		arg0.infoAndRankPanel = nil
	end

	if arg0:isShowing() then
		arg0:Hide()
	end
end

function var0.OnRetPaintingPrefab(arg0)
	return
end

function var0.GetResSuffix(arg0)
	return ""
end

function var0.OnPaintingLoad(arg0)
	return
end

function var0.OnUpdateRes(arg0)
	return
end

function var0.OnUpdatePt(arg0)
	return
end

function var0.OnRescue(arg0)
	return
end

return var0
