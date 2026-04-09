local var0_0 = class("IslandCheaterTavernInGamingView", import(".IslandCheaterTavernBaseView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
end

local var1_0 = {
	129,
	-52
}
local var2_0 = {
	{
		-406,
		205
	},
	{
		243,
		356
	},
	{
		406,
		152
	}
}
local var3_0 = {
	{
		-741,
		197
	},
	{
		-209.9,
		400
	},
	{
		680,
		300
	}
}

function var0_0.Init(arg0_2)
	arg0_2.super.Init(arg0_2)

	arg0_2.playerHudTFDic = {}
	arg0_2.uiplayerHudInfoList = UIItemList.New(arg0_2.uiplayerInfoList, arg0_2.uiplayerInfoItem)

	arg0_2.uiplayerHudInfoList:make(function(arg0_3, arg1_3, arg2_3)
		if arg0_3 == UIItemList.EventInit then
			arg0_2:OnInitPlayerHudInfoItem(arg1_3, arg2_3)
		elseif arg0_3 == UIItemList.EventUpdate then
			arg0_2:OnUpdatePlayerHudInfoItem(arg1_3, arg2_3)
		end
	end)
	arg0_2.uiplayerHudInfoList:each(function(arg0_4, arg1_4)
		arg0_2:OnInitPlayerHudInfoItem(arg0_4, arg1_4)
	end)

	local var0_2 = pg.gameset.bar_punishment_limit.key_value

	setText(arg0_2.uicurHpNum, string.format("%s/%s", var0_2, var0_2))
	onButton(arg0_2, arg0_2.uiqueryBtn, function()
		arg0_2:emit(IslandMediator.CHEATER_TAVERN_OPERATE, IslandCheaterTavernConst.PlayerOperateType.Query)
	end)

	local var1_2 = GetOrAddComponent(arg0_2.uishootBtn, "EventTriggerListener")
	local var2_2 = 10

	var1_2:AddPointDownFunc(function(arg0_6, arg1_6)
		startPos = arg1_6.position
		hasTriggered = false
	end)
	var1_2:AddDragFunc(function(arg0_7, arg1_7)
		if hasTriggered or not startPos then
			return
		end

		if (arg1_7.position - startPos).magnitude >= var2_2 then
			hasTriggered = true

			arg0_2:emit(IslandMediator.CHEATER_TAVERN_OPERATE, IslandCheaterTavernConst.PlayerOperateType.Shoot)
		end
	end)
	var1_2:AddPointUpFunc(function(arg0_8, arg1_8)
		startPos = nil
	end)
	onButton(arg0_2, arg0_2.uiDelegate, function()
		arg0_2:emit(IslandMediator.CHEATER_TAVERN_CANCEL_DELEGATE)
	end)
	onButton(arg0_2, arg0_2.uiputCardBtn, function()
		local var0_10 = arg0_2.cardViewManager:GetSelectCardKeyList()

		if IslandCheaterTavernConst.putCardTest then
			arg0_2.cardViewManager:PutDownMainCard(var0_10)

			return
		end

		local var1_10 = #var0_10

		if var1_10 == 0 or var1_10 > IslandCheaterTavernConst.putCountMax then
			return
		end

		arg0_2:emit(IslandMediator.CHEATER_TAVERN_OPERATE, IslandCheaterTavernConst.PlayerOperateType.PutCard, var0_10)
	end)

	arg0_2.timeMgr = pg.TimeMgr.GetInstance()
	arg0_2.cardViewManager = IslandCheaterTavernCardViewManager.New(arg0_2.uicardList)

	local var3_2 = PlayRoomTools.GetPtScrore(PlayRoomTools.GetGameTypeID())

	setText(arg0_2.uiScoreNum, var3_2)
	setText(arg0_2.uireakCardbgText, i18n("bar_ui_start2"))
	setText(arg0_2.uireakCardTipText, i18n("bar_ui_start1"))
	setText(arg0_2.uiScoreTitle, i18n("bar_ui_game3"))
	setText(arg0_2.uishootText, i18n("bar_ui_game4"))
	setText(arg0_2.uiOutText, i18n("bar_ui_game1"))
	setActive(arg0_2.uiTipsTf, false)
	setParent(arg0_2.uiTipsTf, pg.UIMgr.GetInstance().OverlayToast)
end

function var0_0.OnCheaterOperateDone(arg0_11, arg1_11)
	if arg1_11.type == IslandCheaterTavernConst.PlayerOperateType.PutCard then
		setActive(arg0_11.uiopBtn, false)
		arg0_11:PutMainCardDone(arg1_11.arg_list)
	elseif arg1_11.type == IslandCheaterTavernConst.PlayerOperateType.Shoot then
		setActive(arg0_11.uishootOp, false)
	else
		setActive(arg0_11.uiopBtn, false)
	end
end

function var0_0.PutMainCardDone(arg0_12, arg1_12)
	arg0_12.cardViewManager:PutDownMainCard(arg1_12)

	arg0_12.cardDataList = arg0_12.cheaterTavernAgency:GetMainPlayerCards()

	arg0_12.cardViewManager:RefreshMainCard(arg0_12.cardDataList)
end

function var0_0.StartLastBountPerformTimer(arg0_13, arg1_13, arg2_13)
	if arg1_13 <= 0 then
		existCall(arg2_13)

		return
	end

	arg0_13.lastBountPerformTimer = Timer.New(function()
		existCall(arg2_13)
	end, arg1_13, 1)

	arg0_13.lastBountPerformTimer:Start()
end

function var0_0.StopLastBountPerformTimer(arg0_15)
	if arg0_15.lastBountPerformTimer then
		arg0_15.lastBountPerformTimer:Stop()

		arg0_15.lastBountPerformTimer = nil
	end
end

function var0_0.HideCurrentBoutCoundDown(arg0_16)
	setActive(arg0_16.uicountDown, false)
	arg0_16:StopRoundCoundDown()
end

function var0_0.UpdataLastBoutDisplay(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17.user_id
	local var1_17 = 0
	local var2_17
	local var3_17 = var0_17 == getProxy(PlayerProxy):getRawData().id
	local var4_17 = var3_17 and arg0_17.cheaterTavernAgency:GetMainPlayer() or arg0_17.cheaterTavernAgency:GetPlayerData(var0_17)
	local var5_17 = getProxy(PlayerProxy):getRawData().id

	local function var6_17()
		if var3_17 then
			setActive(arg0_17.uiopBtn, false)
		end
	end

	switch(arg1_17.type, {
		[IslandCheaterTavernConst.PlayerOperateType.PutCard] = function()
			var6_17()
			arg0_17.cardViewManager:ClearTableCard()

			if var3_17 then
				if arg2_17 then
					arg0_17.cardViewManager:PutDownMainCard(arg2_17)

					arg0_17.cardDataList = arg0_17.cheaterTavernAgency:GetMainPlayerCards()

					arg0_17.cardViewManager:RefreshMainCard(arg0_17.cardDataList)
				end
			else
				local var0_19 = arg1_17.return_list[2]

				arg0_17.cardViewManager:OtherPlayerPutCard(var0_17, var0_19)
			end

			arg0_17.tableCardNum = arg1_17.return_list[2]
		end,
		[IslandCheaterTavernConst.PlayerOperateType.Query] = function()
			var6_17()

			arg0_17.tableCardNum = 0
			arg0_17.deskCardList = {}

			local var0_20 = arg1_17.return_list[1]

			setActive(arg0_17.uiqueryEffect, true)

			local var1_20

			if var3_17 then
				setAnchoredPosition(arg0_17.uiqueryEffect, Vector2(var1_0[1], var1_0[2]))
			else
				local var2_20 = arg0_17.playerUserIndexDic[var0_17]

				setAnchoredPosition(arg0_17.uiqueryEffect, Vector2(var2_0[var2_20][1], var2_0[var2_20][2]))
			end

			local var3_20

			if var3_17 then
				var3_20 = var4_17.seat

				local var4_20 = "questSeet0" .. var3_20

				CheatTavernCameraMgr.instance:ActiveVirtualCamera(var4_20)
				onNextTick(function()
					arg0_17:UpdatePlayerHudInfo()
				end)
			else
				arg0_17.cardViewManager:PlayerCardSetActive(var0_17, false)
			end

			arg0_17.parent:emitCore(CheaterTavernEvent.PLAYER_QUESTION_ANIMATION, var0_17, var3_17, var3_20)

			local function var5_20()
				if var3_17 then
					local var0_22 = "lookSeet0" .. var3_20

					CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_22)
					onNextTick(function()
						arg0_17:UpdatePlayerHudInfo()
					end)
				else
					arg0_17.cardViewManager:PlayerCardSetActive(var0_17, true)
				end

				setActive(arg0_17.uiqueryEffect, false)

				local var1_22 = arg0_17.cheaterTavernAgency:GetMainPlayer().seat
				local var2_22 = "shootSeet0" .. var1_22

				CheatTavernCameraMgr.instance:ActiveVirtualCamera(var2_22)
				arg0_17.cardViewManager:PlayerCardSetActive(var5_17, false)

				local var3_22 = {}
				local var4_22 = #arg1_17.return_list

				for iter0_22 = 2, var4_22 do
					table.insert(var3_22, arg1_17.return_list[iter0_22])
				end

				arg0_17.cardViewManager:FlipTableCard(var3_22)
			end

			local function var6_20()
				local var0_24 = var0_20 == 1 and "bar_tips_game1" or "bar_tips_game2"
				local var1_24 = arg0_17.cheaterTavernAgency:GetPlayerData(var0_17):GetName()
				local var2_24 = arg0_17.cheaterTavernAgency:GetPlayerData(arg1_17.next_user_id):GetName()

				arg0_17:ShowTips(i18n(var0_24, var1_24), i18n("bar_tips_game5", var0_20 == 1 and var2_24 or var1_24))
			end

			if arg0_17.questionTimer then
				arg0_17.questionTimer:Stop()
			end

			arg0_17.questionTimer = Timer.New(function()
				var5_20()
			end, 2, 1)

			if arg0_17.tipsTimer then
				arg0_17.tipsTimer:Stop()
			end

			arg0_17.tipsTimer = Timer.New(function()
				var6_20()
			end, 3.5, 1)

			arg0_17.questionTimer:Start()
			arg0_17.tipsTimer:Start()

			var1_17 = pg.gameset.bar_question_time.key_value

			function var2_17()
				setActive(arg0_17.uiTipsTf, false)
			end
		end,
		[IslandCheaterTavernConst.PlayerOperateType.Shoot] = function()
			var6_17()

			if var3_17 then
				setActive(arg0_17.uishootOp, false)
			end

			arg0_17.cardViewManager:ClearTableCard()

			local var0_28 = arg1_17.return_list[2]
			local var1_28 = arg0_17.cheaterTavernAgency:GetMainPlayer().seat
			local var2_28, var3_28 = var4_17:GetCurrentBombId()
			local var4_28 = var4_17.seat

			arg0_17.parent:emitCore(CheaterTavernEvent.SHOOT_AND_TURN_TABLE, var3_17, var4_28, var2_28, var3_28, var0_28 == 1)

			var1_17 = pg.gameset.bar_punishment_turntable_time.key_value

			function var2_17()
				local var0_29 = "lookSeet0" .. var1_28

				CheatTavernCameraMgr.instance:ActiveVirtualCamera(var0_29)
				arg0_17.cardViewManager:PlayerCardSetActive(var5_17, true)

				local var1_29 = var4_17:GetName()
				local var2_29 = var0_28 == 1 and "bar_tips_game3" or "bar_tips_game4"

				arg0_17:ShowTips(i18n(var2_29, var1_29))

				if var0_28 == 1 then
					if var3_17 then
						arg0_17.cardViewManager:DestroyMainCard()
					else
						arg0_17.cardViewManager:OtherPlayerCardDestroy(var0_17)
					end

					local var3_29 = var4_17.seat

					arg0_17.parent:emitCore(CheaterTavernEvent.PLAYER_OUT_ANIMATION, var0_17, var3_29, var0_17 == getProxy(PlayerProxy):getRawData().id)
				end

				local var4_29 = arg0_17.playerUserIndexDic[var0_17]

				if var4_29 then
					local var5_29 = arg0_17.playerHudTFDic[var4_29]

					if var0_28 == 1 then
						local var6_29 = arg0_17.playerList[var4_29]:IsOut()

						setActive(var5_29:Find("out"), var6_29)
					end
				end

				onNextTick(function()
					arg0_17:UpdatePlayerHudInfo()
				end)
			end
		end
	}, function()
		return
	end)

	return var1_17, var2_17
end

function var0_0.UpdateCurrentBoutDisplay(arg0_32, arg1_32)
	local var0_32 = {
		user_id = arg1_32.next_user_id
	}

	if var0_32.user_id == 0 then
		return
	end

	local var1_32

	if arg1_32.next_type == 1 then
		var1_32 = IslandCheaterTavernConst.PlayerCurrentOperateType.PutCardOrQuery
	elseif arg1_32.next_type == 2 then
		var1_32 = IslandCheaterTavernConst.PlayerCurrentOperateType.ShootByOther
	else
		var1_32 = IslandCheaterTavernConst.PlayerCurrentOperateType.ShootByOwn
	end

	if var1_32 >= IslandCheaterTavernConst.PlayerCurrentOperateType.ShootByOther then
		local var2_32, var3_32 = arg0_32.cheaterTavernAgency:GetPlayerData(var0_32.user_id):GetCurrentAndAllHp()

		if var2_32 ~= var3_32 then
			return
		end
	end

	var0_32.operationType = var1_32
	var0_32.auto_time = arg1_32.auto_time

	arg0_32:UpdateOneBout(var0_32)
end

function var0_0.OnCheaterOperateDoneNotify(arg0_33, arg1_33)
	local var0_33 = arg1_33.data
	local var1_33 = arg1_33.putCard

	arg0_33:HideCurrentBoutCoundDown()

	local var2_33, var3_33 = arg0_33:UpdataLastBoutDisplay(var0_33, var1_33)

	local function var4_33()
		existCall(var3_33)
		arg0_33:UpdateCurrentBoutDisplay(var0_33)
	end

	arg0_33:StopLastBountPerformTimer()
	arg0_33:StartLastBountPerformTimer(var2_33, var4_33)
end

function var0_0.OnPlayerEscape(arg0_35, arg1_35)
	local var0_35 = arg0_35.cheaterTavernAgency:GetPlayerData(arg1_35)

	if var0_35:IsOut() then
		return
	end

	var0_35:SetOutState()

	local var1_35 = arg0_35.playerUserIndexDic[arg1_35]
	local var2_35 = arg0_35.playerHudTFDic[var1_35]

	setActive(var2_35:Find("out"), true)
	setActive(var2_35:Find("hp"), false)
	arg0_35.cardViewManager:OtherPlayerCardDestroy(arg1_35)
	arg0_35.parent:emitCore(CheaterTavernEvent.PLAYER_OUT_ANIMATION, arg1_35, var0_35.seat, arg1_35 == getProxy(PlayerProxy):getRawData().id)
end

function var0_0.Show(arg0_36)
	return
end

function var0_0.OnInitPlayerHudInfoItem(arg0_37, arg1_37, arg2_37)
	local var0_37 = tf(arg2_37)

	arg0_37.playerHudTFDic[arg1_37 + 1] = var0_37

	setActive(var0_37:Find("out"), false)
	setText(var0_37:Find("out/outText"), i18n("bar_ui_game1"))

	local var1_37 = pg.gameset.bar_punishment_limit.key_value

	setText(var0_37:Find("hp/hpNum"), string.format("%s/%s", var1_37, var1_37))
	setActive(arg0_37.uiOutGo, false)
	setActive(arg0_37.uiHpGo, true)
end

function var0_0.OnUpdatePlayerHudInfoItem(arg0_38, arg1_38, arg2_38)
	local var0_38 = tf(arg2_38)
	local var1_38 = arg1_38 + 1
	local var2_38 = arg0_38.playerList[var1_38]
	local var3_38 = var2_38.seat
	local var4_38 = 10110000 + var3_38
	local var5_38 = pg.island_world_objects[var4_38]
	local var6_38 = var5_38.param.position[1]
	local var7_38 = var5_38.param.position[3]
	local var8_38 = {
		1,
		0,
		-1,
		0
	}
	local var9_38 = {
		0,
		-1,
		0,
		1
	}
	local var10_38 = 2
	local var11_38 = var6_38 + var8_38[var3_38] * var10_38
	local var12_38 = var7_38 + var9_38[var3_38] * var10_38
	local var13_38 = arg0_38.cheaterTavernAgency:GetMainPlayer().seat
	local var14_38 = 0

	if math.abs(var13_38 - var3_38) == 2 then
		var14_38 = 0.3
	end

	local var15_38 = Vector3(var11_38, IslandCheaterTavernConst.hudHeight + var14_38, var12_38)

	var0_38.localPosition = arg0_38:WorldPosition2LocalPosition(arg0_38.uiplayerInfoList, var15_38)

	setText(var0_38:Find("adapt/name"), tostring(var2_38.player_info.name))

	local var16_38, var17_38 = var2_38:GetCurrentAndAllHp()

	setText(var0_38:Find("hp/hpNum"), var16_38 .. "/" .. var17_38)

	local var18_38 = arg0_38.operation and arg0_38.operation.user_id == var2_38.user_id

	setActive(var0_38:Find("in_process"), var18_38)

	local var19_38 = var2_38:IsOut()

	setActive(var0_38:Find("hp"), not var19_38)
	setActive(var0_38:Find("adapt/delegate"), var2_38:IsDelegate())
end

function var0_0.StartRounCountDown(arg0_39, arg1_39)
	arg0_39:StopRoundCoundDown()

	arg0_39.randCoundDownTimer = Timer.New(function()
		local var0_40 = arg1_39 - arg0_39.timeMgr:GetServerTime()

		setActive(arg0_39.uiFirstTimeImg, true)
		setActive(arg0_39.uiSecondTimeImg, true)

		if var0_40 < 0 then
			var0_40 = 0

			setImageSprite(arg0_39.uiFirstTimeImg, arg0_39.parent:GetNumSpriteByIndex(0), true)
			setImageSprite(arg0_39.uiSecondTimeImg, arg0_39.parent:GetNumSpriteByIndex(0), true)
			arg0_39:StopRoundCoundDown()

			return
		end

		local var1_40 = math.floor(var0_40 % 60)
		local var2_40 = math.floor(var1_40 / 10)
		local var3_40 = var1_40 % 10

		if var2_40 <= 0 then
			setActive(arg0_39.uiFirstTimeImg, false)
			setImageSprite(arg0_39.uiSecondTimeImg, arg0_39.parent:GetNumSpriteByIndex(var3_40), true)

			return
		end

		setImageSprite(arg0_39.uiFirstTimeImg, arg0_39.parent:GetNumSpriteByIndex(var2_40), true)
		setImageSprite(arg0_39.uiSecondTimeImg, arg0_39.parent:GetNumSpriteByIndex(var3_40), true)
	end, 1, -1)

	arg0_39.randCoundDownTimer.func()
	arg0_39.randCoundDownTimer:Start()
end

function var0_0.StopRoundCoundDown(arg0_41)
	if arg0_41.randCoundDownTimer then
		arg0_41.randCoundDownTimer:Stop()
	end
end

function var0_0.RemoveRealCardTipShowTime(arg0_42)
	if arg0_42.realCardTipShowTimer then
		arg0_42.realCardTipShowTimer:Stop()
	end
end

function var0_0.OnCheaterEveryRoundStart(arg0_43)
	arg0_43.tableCardNum = 0

	local var0_43 = arg0_43.cheaterTavernAgency:GetMainPlayer()

	arg0_43.cardViewManager:SetMainPlayerSeat(var0_43.seat)
	arg0_43:SetActiveState(false)
	setActive(arg0_43.uiRondRealCardTips, false)
	setActive(arg0_43.uiputCardDestList, false)
	setActive(arg0_43.uiqueryEffect, false)
	setActive(arg0_43.uicountDown, false)
	setActive(arg0_43.uiDelegate, false)
	arg0_43:StopLastBountPerformTimer()
end

function var0_0.OnCheaterEveryRoundStartDone(arg0_44, arg1_44)
	local var0_44 = arg0_44.cheaterTavernAgency:GetMainPlayer().seat
	local var1_44 = "lookSeet0" .. var0_44

	CheatTavernCameraMgr.instance:ActiveVirtualCamera(var1_44)
	arg0_44:HideCurrentBoutCoundDown()
	arg0_44:SetActiveState(true)
	setActive(arg0_44.uiRondRealCardTips, true)

	local var2_44 = arg0_44.cheaterTavernAgency:GetRealCard()
	local var3_44 = pg.bar_card[var2_44]

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var3_44.card_res, "", arg0_44.uirealCard)
	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var3_44.card_res, "", arg0_44.uirealCardTip)
	arg0_44:RemoveRealCardTipShowTime()

	local var4_44 = pg.gameset.bar_refreshcard_time.key_value

	arg0_44.realCardTipShowTimer = Timer.New(function()
		setActive(arg0_44.uiRondRealCardTips, false)
		arg0_44:UpdateOneBout(arg1_44)
	end, var4_44, 1)

	arg0_44.realCardTipShowTimer:Start()
	arg0_44:ResetBountOp()
	arg0_44:InitPlayerHudInfo()
	arg0_44:InitMainCard()
	arg0_44:InitOtherPlayerCard()
	arg0_44:UpdateDelegateState()
end

function var0_0.OnCheaterReconected(arg0_46, arg1_46)
	setActive(arg0_46.uiRondRealCardTips, false)

	arg0_46.tableCardNum = 0

	local var0_46 = arg0_46.cheaterTavernAgency:GetMainPlayer()

	arg0_46.cardViewManager:SetMainPlayerSeat(var0_46.seat)
	arg0_46:SetActiveState(true)
	arg0_46:HideCurrentBoutCoundDown()

	local var1_46 = arg0_46.cheaterTavernAgency:GetRealCard()
	local var2_46 = pg.bar_card[var1_46]

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var2_46.card_res, "", arg0_46.uirealCard)
	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var2_46.card_res, "", arg0_46.uirealCardTip)
	arg0_46:ResetBountOp()
	arg0_46:InitPlayerHudInfo()
	arg0_46:InitMainCard()
	arg0_46:InitOtherPlayerCard()
	arg0_46:UpdateDelegateState()
	arg0_46:UpdateOneBout(arg1_46)
end

function var0_0.InitMainCard(arg0_47)
	arg0_47.cardDataList = arg0_47.cheaterTavernAgency:GetMainPlayerCards()

	arg0_47.cardViewManager:DestroyMainCard()
	arg0_47.cardViewManager:InitMainCard(arg0_47.cardDataList)
end

function var0_0.InitPlayerHudInfo(arg0_48)
	arg0_48.playerList, arg0_48.playerUserIndexDic = arg0_48.cheaterTavernAgency:GetPlayerList()
end

function var0_0.InitOtherPlayerCard(arg0_49)
	arg0_49.cardViewManager:InitOtherPlayerCard(arg0_49.playerList)
end

function var0_0.UpdatePlayerHudInfo(arg0_50)
	arg0_50.uiplayerHudInfoList:align(#arg0_50.playerList)
end

function var0_0.ResetBountOp(arg0_51)
	setActive(arg0_51.uiopBtn, false)
	setActive(arg0_51.uishootOp, false)
end

function var0_0.UpdateOneBout(arg0_52, arg1_52)
	setActive(arg0_52.uiopBtn, false)
	setActive(arg0_52.uishootOp, false)

	arg0_52.operation = arg1_52

	arg0_52:UpdatePlayerHudInfo()
	arg0_52:UpdataHp()

	if IslandCheaterTavernConst.putCardTest then
		setActive(arg0_52.uiopBtn, true)
		setActive(arg0_52.uiopBtn:Find("putCard"), true)

		return
	end

	setActive(arg0_52.uicountDown, true)
	arg0_52:StartRounCountDown(arg1_52.auto_time)

	if not arg0_52:IsSelf(arg1_52.user_id) then
		return
	end

	if arg1_52.operationType >= IslandCheaterTavernConst.PlayerCurrentOperateType.ShootByOther then
		local var0_52 = arg0_52.cheaterTavernAgency:GetMainPlayer()
		local var1_52, var2_52 = var0_52:GetCurrentAndAllHp()

		if var1_52 == var2_52 then
			arg0_52.cardViewManager:ClearTableCard()
			setActive(arg0_52.uishootOp, true)
			arg0_52.parent:emitCore(CheaterTavernEvent.FIRST_TAKE_SHOOT_TIPS, var0_52.seat)
		end

		return
	end

	setActive(arg0_52.uiopBtn, true)
	IslandCheaterTavernRecordTools.StartPutCardTime()

	local var3_52 = arg0_52.cheaterTavernAgency:CheckCanOnlyQurey()

	setActive(arg0_52.uiopBtn:Find("putCard"), not var3_52)
	setActive(arg0_52.uiopBtn:Find("query"), arg0_52.tableCardNum > 0)
end

function var0_0.UpdataHp(arg0_53)
	local var0_53 = arg0_53.cheaterTavernAgency:GetMainPlayer()

	if var0_53:IsOut() then
		setActive(arg0_53.uiOutGo, true)
		setActive(arg0_53.uiHpGo, false)
	else
		setActive(arg0_53.uiOutGo, false)
		setActive(arg0_53.uiHpGo, true)

		local var1_53, var2_53 = var0_53:GetCurrentAndAllHp()

		setText(arg0_53.uicurHpNum, var1_53 .. "/" .. var2_53)
	end
end

function var0_0.OnInit(arg0_54)
	return
end

function var0_0.OnHide(arg0_55)
	setParent(arg0_55.uiTipsTf, arg0_55._tf)

	if arg0_55.cardViewManager then
		arg0_55.cardViewManager:Destroy()

		arg0_55.cardViewManager = nil
	end

	arg0_55:StopRoundCoundDown()
	arg0_55:RemoveRealCardTipShowTime()
	arg0_55:StopLastBountPerformTimer()

	if arg0_55.questionTimer then
		arg0_55.questionTimer:Stop()

		arg0_55.questionTimer = nil
	end

	if arg0_55.tipsTimer then
		arg0_55.tipsTimer:Stop()

		arg0_55.tipsTimer = nil
	end

	arg0_55:StopHideTipsTimer()
end

function var0_0.WorldPosition2LocalPosition(arg0_56, arg1_56, arg2_56)
	local var0_56 = pg.UIMgr.GetInstance().overlayCameraComp
	local var1_56 = CheatTavernCameraMgr.instance._mainCamera:WorldToViewportPoint(arg2_56)
	local var2_56 = var0_56:ViewportToScreenPoint(var1_56)
	local var3_56 = arg1_56:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var3_56, var2_56, var0_56))
end

function var0_0.UpdateDelegateState(arg0_57)
	local var0_57 = arg0_57.cheaterTavernAgency:GetMainPlayer()

	setActive(arg0_57.uiDelegate, var0_57:IsDelegate())
	arg0_57:UpdatePlayerHudInfo()
end

function var0_0.DestroyMainCard(arg0_58)
	if arg0_58.cardViewManager then
		arg0_58.cardViewManager:DestroyMainCard()
	end
end

function var0_0.ShowTips(arg0_59, arg1_59, arg2_59)
	if arg2_59 == nil then
		setText(arg0_59.uiResultText, arg1_59)
		setActive(arg0_59.uiResultText, true)
		setActive(arg0_59.uiQueryText, false)
		setActive(arg0_59.uiPunishmentText, false)
	else
		setText(arg0_59.uiQueryText, arg1_59)
		setText(arg0_59.uiPunishmentText, arg2_59)
		setActive(arg0_59.uiResultText, false)
		setActive(arg0_59.uiQueryText, true)
		setActive(arg0_59.uiPunishmentText, true)
	end

	arg0_59:StopHideTipsTimer()
	setActive(arg0_59.uiTipsTf, false)
	setActive(arg0_59.uiTipsTf, true)

	arg0_59.hideTipsTimer = Timer.New(function()
		arg0_59.uiTipsAnimator:SetTrigger("hide")
	end, 2, 1)

	arg0_59.hideTipsTimer:Start()
end

function var0_0.StopHideTipsTimer(arg0_61)
	if arg0_61.hideTipsTimer then
		arg0_61.hideTipsTimer:Stop()

		arg0_61.hideTipsTimer = nil
	end
end

return var0_0
