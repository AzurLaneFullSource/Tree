local var0_0 = class("NewDuelResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0_0.UpdatePlayer(arg0_1)
	local var0_1 = getProxy(PlayerProxy):getRawData()

	arg0_1.playerName.text = var0_1:GetName()

	local var1_1 = getProxy(MilitaryExerciseProxy):getSeasonInfo()
	local var2_1 = SeasonInfo.getMilitaryRank(var1_1.score, var1_1.rank)
	local var3_1, var4_1 = SeasonInfo.getNextMilitaryRank(var1_1.score, var1_1.rank)

	arg0_1.playerLv.text = var2_1.name
	arg0_1.playerExpLabel.text = i18n("word_rankScore")

	local function var5_1()
		arg0_1.playerExp.text = "+" .. NewBattleResultUtil.GetSeasonScoreOffset(arg0_1.contextData.oldRank, var1_1)
		arg0_1.playerExpBar.fillAmount = var1_1.score / var4_1
	end

	if not arg0_1.contextData.autoSkipFlag then
		arg0_1.duelAniamtion = NewBattleResultDuelAniamtion.New(arg0_1.playerExp, arg0_1.playerExpBar, var4_1, arg0_1.contextData.oldRank, var1_1)

		arg0_1.duelAniamtion:SetUp(var5_1)
	else
		var5_1()
	end
end

function var0_0.UpdateChapterName(arg0_3)
	local var0_3 = arg0_3.contextData
	local var1_3 = getProxy(MilitaryExerciseProxy):getPreRivalById(var0_3.rivalId or 0)
	local var2_3 = var1_3 and var1_3.name or ""

	arg0_3.chapterName.text = var2_3

	setActive(arg0_3.opBonus, false)
end

function var0_0.OnDestroy(arg0_4)
	var0_0.super.OnDestroy(arg0_4)

	if arg0_4.duelAniamtion then
		arg0_4.duelAniamtion:Dispose()

		arg0_4.duelAniamtion = nil
	end
end

return var0_0
