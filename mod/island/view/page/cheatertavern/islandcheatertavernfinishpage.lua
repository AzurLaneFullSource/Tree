local var0_0 = class("IslandCheaterTavernFinishPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandCheaterTavernFinishUI"
end

function var0_0.NeedCache(arg0_2)
	return false
end

function var0_0.OnLoaded(arg0_3)
	onButton(arg0_3, arg0_3.uiquitBtn, function()
		arg0_3:Hide()
		arg0_3:emit(CheaterTavernEvent.FINSH_PAGE_QUIT)
	end)
	onButton(arg0_3, arg0_3.conninueBtn, function()
		arg0_3:Hide()
	end)
	setText(arg0_3.quitText, i18n("bar_ui_end1"))
	setText(arg0_3.continueText, i18n("bar_ui_end2"))
	setText(arg0_3.uiPtNameText, i18n("bar_ui_game3"))
end

function var0_0.AddListeners(arg0_6)
	arg0_6:AddListener(GAME.ISLAND_CHEATER_REAL_END_NOTIFY, arg0_6.OnGameEndNotify)
end

function var0_0.RemoveListeners(arg0_7)
	arg0_7:RemoveListener(GAME.ISLAND_CHEATER_REAL_END_NOTIFY, arg0_7.OnGameEndNotify)
end

function var0_0.OnInit(arg0_8)
	arg0_8.animation = arg0_8.uirightAdapt:GetComponent(typeof(Animation))
end

function var0_0.OnGameEndNotify(arg0_9, arg1_9)
	local var0_9 = arg0_9:GetIsland():GetCheaterTavernAgency():GetMainPlayer().id

	if arg1_9.win_user == var0_9 then
		return
	end

	arg0_9:RefreshUI(IslandCheaterTavernConst.SettlementType.ByFinal)
end

function var0_0.RefreshUI(arg0_10, arg1_10)
	IslandCheaterTavernRecordTools.RecordResult(arg1_10 == IslandCheaterTavernConst.SettlementType.ByScore and IslandCheaterTavernRecordTools.LOST or IslandCheaterTavernRecordTools.WIN)

	arg0_10.cheaterTavernAgency = arg0_10:GetIsland():GetCheaterTavernAgency()

	local var0_10 = arg0_10.cheaterTavernAgency:GetMainPlayer()
	local var1_10 = var0_10:GetRank()
	local var2_10 = var0_10:GetAddScore()

	setActive(arg0_10.uiSus, var1_10 == 1)
	setActive(arg0_10.uiFail, var1_10 ~= 1)
	setText(arg0_10.uiWinNameText, var0_10:GetName())
	setActive(arg0_10.conninueBtn, var1_10 ~= 1)

	local var3_10 = PlayRoomTools.GetPtScoreIcon(PlayRoomTools.GetGameTypeID())

	GetImageSpriteFromAtlasAsync("Island/IslandCheaterTavernIcon/" .. var3_10, "", arg0_10.uiPtIcon)

	local var4_10 = PlayRoomTools.GetPtScrore(PlayRoomTools.GetGameTypeID())

	setText(arg0_10.uiPtText, var4_10)
	setActive(arg0_10.uiScore, getProxy(PlayRoomProxy):GetRoomData().roomType == PlayRoomConst.PLAY_ROOM_TYPE.MATCH)

	local var5_10 = var2_10 >= 0 and "+" or ""

	setText(arg0_10.uiPtAddText, var5_10 .. var2_10)

	if var1_10 == 1 then
		arg0_10.animation:Play("Anim_IslandCheaterTavernFinishUI_win")
	else
		arg0_10.animation:Play("Anim_IslandCheaterTavernFinishUI_los")
	end

	if arg1_10 == IslandCheaterTavernConst.SettlementType.ByFinal then
		setActive(arg0_10.conninueBtn, false)
	end
end

function var0_0.Show(arg0_11, arg1_11)
	var0_0.super.Show(arg0_11)
	arg0_11:RefreshUI(arg1_11)
end

function var0_0.OnDestroy(arg0_12)
	var0_0.super.OnDestroy(arg0_12)
end

function var0_0.OnHide(arg0_13)
	return
end

return var0_0
