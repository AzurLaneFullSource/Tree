local var0_0 = class("BaseWorldBossDetailPage", import("....base.BaseSubView"))
local var1_0 = {
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

function var0_0.Setup(arg0_1, arg1_1)
	local var0_1 = {
		onBossUpdated = "OnBossUpdated",
		onRankListUpdated = "OnRankListUpdated",
		onPtUpdated = "OnPtUpdated",
		onBossProgressUpdate = "OnBossProgressUpdate"
	}

	for iter0_1, iter1_1 in pairs(var0_1) do
		arg0_1[iter0_1] = function(...)
			var0_0[iter1_1](arg0_1, ...)
		end
	end

	arg0_1.proxy = arg1_1

	arg0_1:AddListeners(arg0_1.proxy)
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.supportBtn = arg0_3:findTF("btns/help_btn")
	arg0_3.startBtn = arg0_3:findTF("btns/start_btn")
	arg0_3.awardBtn = arg0_3:findTF("btns/award_btn")
	arg0_3.timeTF = arg0_3:findTF("btns/time")
	arg0_3.leftTime = arg0_3:findTF("btns/time/label/Text"):GetComponent(typeof(Text))
	arg0_3.awardList = UIItemList.New(arg0_3:findTF("award_panel/list"), arg0_3:findTF("award_panel/list/tpl"))
	arg0_3.levelTxt = arg0_3:findTF("hp/level/Text"):GetComponent(typeof(Text))
	arg0_3.hpTxt = arg0_3:findTF("hp/Text"):GetComponent(typeof(Text))
	arg0_3.hpSlider = arg0_3:findTF("hp/slider"):GetComponent(typeof(Slider))
	arg0_3.painting = arg0_3:findTF("paint")
	arg0_3.infoAndRankPanel = WorldBossInfoAndRankPanel.New(arg0_3._tf, arg0_3.event)

	arg0_3.infoAndRankPanel:SetCallback(function(arg0_4)
		setGray(arg0_3.awardBtn, arg0_4, true)
	end, function(arg0_5, arg1_5)
		setGray(arg0_3.supportBtn, arg1_5 <= arg0_5, true)
		onButton(arg0_3, arg0_3.supportBtn, function()
			if arg0_5 >= arg1_5 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_max_challenge_people_cnt"))

				return
			end

			if arg0_3.boss:isDeath() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))
			else
				arg0_3:OnRescue()
			end
		end, SFX_PANEL)
	end)
	setText(arg0_3:findTF("btns/time/label"), i18n("time_remaining_tip"))
end

function var0_0.OnInit(arg0_7)
	onButton(arg0_7, arg0_7.startBtn, function()
		arg0_7:OnStart()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.awardBtn, function()
		if arg0_7.boss:GetLeftTime() <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_award_expired"))
		else
			if arg0_7.boss:ShouldWaitForResult() then
				return
			end

			arg0_7:emit(WorldBossMediator.ON_SUBMIT_AWARD, arg0_7.boss.id)
		end
	end, SFX_PANEL)
end

function var0_0.OnStart(arg0_10)
	if arg0_10.boss:isDeath() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))
	elseif arg0_10.boss:GetLeftTime() <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_is_death"))
	else
		arg0_10:emit(WorldBossMediator.ON_BATTLE, arg0_10.boss.id, false, arg0_10.hpSlider.value)
	end
end

function var0_0.AddListeners(arg0_11, arg1_11)
	arg1_11:AddListener(WorldBossProxy.EventPtUpdated, arg0_11.onPtUpdated)
	arg1_11:AddListener(WorldBossProxy.EventBossUpdated, arg0_11.onBossUpdated)
	arg1_11:AddListener(WorldBossProxy.EventRankListUpdated, arg0_11.onRankListUpdated)
	arg1_11:AddListener(WorldBossProxy.EventUnlockProgressUpdated, arg0_11.onBossProgressUpdate)
end

function var0_0.RemoveListeners(arg0_12, arg1_12)
	arg1_12:RemoveListener(WorldBossProxy.EventPtUpdated, arg0_12.onPtUpdated)
	arg1_12:RemoveListener(WorldBossProxy.EventBossUpdated, arg0_12.onBossUpdated)
	arg1_12:RemoveListener(WorldBossProxy.EventRankListUpdated, arg0_12.onRankListUpdated)
	arg1_12:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, arg0_12.onBossProgressUpdate)
end

function var0_0.OnBossUpdated(arg0_13)
	if arg0_13:isShowing() then
		arg0_13:UpdateBoss()
	end
end

function var0_0.OnRankListUpdated(arg0_14, arg1_14, arg2_14, arg3_14)
	if arg0_14:isShowing() and arg0_14.boss and arg0_14.boss.id == arg3_14 and arg0_14.infoAndRankPanel and arg0_14.infoAndRankPanel:GetLoaded() then
		arg0_14.infoAndRankPanel:FlushRank()
	end
end

function var0_0.OnBossProgressUpdate(arg0_15)
	if arg0_15:isShowing() then
		arg0_15:OnUpdateRes()
	end
end

function var0_0.OnPtUpdated(arg0_16)
	if arg0_16:isShowing() then
		arg0_16:OnUpdatePt()
	end
end

function var0_0.UpdatePainting(arg0_17, arg1_17)
	if not arg1_17 then
		return
	end

	if arg0_17.groupId ~= arg1_17 then
		arg0_17.groupId = arg1_17

		local var0_17 = arg0_17:findTF("label"):GetComponent(typeof(Image))

		var0_17.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. arg0_17.groupId, "title" .. arg0_17:GetResSuffix())

		var0_17:SetNativeSize()
		setMetaPaintingPrefabAsync(arg0_17.painting, arg0_17.groupId, "lihuisha", function()
			arg0_17:OnPaintingLoad()
		end)

		local var1_17
		local var2_17 = WorldBossConst.MetaId2BossId(arg1_17)

		if var2_17 then
			var1_17 = pg.world_joint_boss_template[var2_17].p_offset or var1_0[arg1_17]
		else
			var1_17 = var1_0[arg1_17]
		end

		if var1_17 then
			setAnchoredPosition(arg0_17.painting, {
				x = var1_17[1],
				y = var1_17[2]
			})

			local var3_17 = var1_17[3] or 1
			local var4_17 = var1_17[4] or 1

			arg0_17.painting.localScale = Vector3(var3_17, var4_17, 1)
		end
	else
		arg0_17:OnPaintingLoad()
	end
end

function var0_0.UpdateBoss(arg0_19)
	arg0_19.boss = arg0_19.proxy:GetBoss()

	if arg0_19.boss then
		arg0_19:UpdateMainInfo()
		arg0_19:RemoveChallengeTimer()
		arg0_19:AddChanllengTimer()
		arg0_19:RemoveGetAwardTimer()
		arg0_19:AddGetAwaradTimer()
	end
end

function var0_0.Update(arg0_20)
	arg0_20:UpdateBoss()
	arg0_20:Show()

	if arg0_20.boss then
		arg0_20.infoAndRankPanel:ExecuteAction("Flush", arg0_20.boss, arg0_20.proxy)
		arg0_20:UpdateAward()
		arg0_20:OnUpdateRes()
		arg0_20:OnUpdatePt()
	end
end

function var0_0.UpdateAward(arg0_21)
	local var0_21 = arg0_21.boss:GetAwards()

	arg0_21.awardList:make(function(arg0_22, arg1_22, arg2_22)
		if arg0_22 == UIItemList.EventUpdate then
			local var0_22 = var0_21[arg1_22 + 1]
			local var1_22 = {
				count = 0,
				type = var0_22[1],
				id = var0_22[2]
			}

			updateDrop(arg2_22:Find("equipment/bg"), var1_22)

			local var2_22 = arg2_22:Find("mask/name"):GetComponent("ScrollText")
			local var3_22 = var1_22:getConfig("name")

			var2_22:SetText(var3_22)
			onButton(arg0_21, arg2_22, function()
				arg0_21:emit(BaseUI.ON_DROP, var1_22)
			end, SFX_PANEL)
		end
	end)
	arg0_21.awardList:align(math.min(#var0_21, 3))
end

function var0_0.UpdateMainInfo(arg0_24)
	local var0_24 = arg0_24.boss
	local var1_24 = arg0_24.proxy
	local var2_24 = var0_24:GetHP()
	local var3_24 = var0_24:GetMaxHp()

	arg0_24.levelTxt.text = var0_24:GetLevel()
	arg0_24.hpTxt.text = var2_24 .. "/<color=#E31D15>" .. var3_24 .. "</color>"
	arg0_24.hpSlider.value = var2_24 / var3_24

	local var4_24 = var0_24:isDeath()
	local var5_24 = var0_24:IsExpired()
	local var6_24 = var1_24:canGetSelfAward()

	setActive(arg0_24.supportBtn, not var4_24 and not var5_24)
	setActive(tf(arg0_24.leftTime).parent, true)
	setActive(arg0_24.awardBtn, var4_24 and var6_24)
	setActive(arg0_24.startBtn, not var4_24 and not var5_24)
	arg0_24:UpdatePainting(var0_24.config.meta_id)
end

function var0_0.AddChanllengTimer(arg0_25)
	local var0_25 = arg0_25.boss

	if var0_25:isDeath() then
		return
	end

	local var1_25 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_25 = var0_25:GetExpiredTime()

	local function var3_25()
		arg0_25.leftTime.text = i18n("world_word_expired")

		onNextTick(function()
			arg0_25:OnBossExpired()
		end)
	end

	if var2_25 < var1_25 then
		var3_25()
	else
		arg0_25.bossTimer = Timer.New(function()
			local var0_28 = var2_25 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_28 > 0 then
				arg0_25.leftTime.text = pg.TimeMgr.GetInstance():DescCDTime(var0_28)
			else
				var3_25()
				arg0_25:RemoveChallengeTimer()
			end
		end, 1, -1)

		arg0_25.bossTimer:Start()
		arg0_25.bossTimer.func()
	end
end

function var0_0.RemoveChallengeTimer(arg0_29)
	if arg0_29.bossTimer then
		arg0_29.bossTimer:Stop()

		arg0_29.bossTimer = nil
	end
end

function var0_0.AddGetAwaradTimer(arg0_30)
	local var0_30 = arg0_30.boss

	if not var0_30:isDeath() then
		return
	end

	local var1_30 = pg.TimeMgr.GetInstance():GetServerTime()
	local var2_30 = var0_30:GetExpiredTime()

	local function var3_30()
		arg0_30.leftTime.text = i18n("world_word_expired")

		onNextTick(function()
			arg0_30:OnBossExpired()
		end)
	end

	if var2_30 < var1_30 then
		var3_30()
	else
		arg0_30.awardTimer = Timer.New(function()
			local var0_33 = var2_30 - pg.TimeMgr.GetInstance():GetServerTime()

			if var0_33 > 0 then
				arg0_30.leftTime.text = pg.TimeMgr.GetInstance():DescCDTime(var0_33)
			else
				var3_30()
				arg0_30:RemoveGetAwardTimer()
			end
		end, 1, -1)

		arg0_30.awardTimer:Start()
		arg0_30.awardTimer.func()
	end
end

function var0_0.OnBossExpired(arg0_34)
	arg0_34:emit(WorldBossMediator.ON_SELF_BOSS_OVERTIME)
end

function var0_0.RemoveGetAwardTimer(arg0_35)
	if arg0_35.awardTimer then
		arg0_35.awardTimer:Stop()

		arg0_35.awardTimer = nil
	end
end

function var0_0.OnDestroy(arg0_36)
	if arg0_36.groupId then
		arg0_36:OnRetPaintingPrefab()
		retMetaPaintingPrefab(arg0_36.painting, arg0_36.groupId)
	end

	arg0_36:RemoveGetAwardTimer()
	arg0_36:RemoveListeners(arg0_36.proxy)
	arg0_36:RemoveChallengeTimer()

	if arg0_36.infoAndRankPanel then
		arg0_36.infoAndRankPanel:Destroy()

		arg0_36.infoAndRankPanel = nil
	end

	if arg0_36:isShowing() then
		arg0_36:Hide()
	end
end

function var0_0.OnRetPaintingPrefab(arg0_37)
	return
end

function var0_0.GetResSuffix(arg0_38)
	return ""
end

function var0_0.OnPaintingLoad(arg0_39)
	return
end

function var0_0.OnUpdateRes(arg0_40)
	return
end

function var0_0.OnUpdatePt(arg0_41)
	return
end

function var0_0.OnRescue(arg0_42)
	return
end

return var0_0
