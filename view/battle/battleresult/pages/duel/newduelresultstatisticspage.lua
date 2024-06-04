local var0 = class("NewDuelResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0.UpdatePlayer(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	arg0.playerName.text = var0:GetName()

	local var1 = getProxy(MilitaryExerciseProxy):getSeasonInfo()
	local var2 = SeasonInfo.getMilitaryRank(var1.score, var1.rank)
	local var3, var4 = SeasonInfo.getNextMilitaryRank(var1.score, var1.rank)

	arg0.playerLv.text = var2.name
	arg0.playerExpLabel.text = i18n("word_rankScore")

	local function var5()
		arg0.playerExp.text = "+" .. NewBattleResultUtil.GetSeasonScoreOffset(arg0.contextData.oldRank, var1)
		arg0.playerExpBar.fillAmount = var1.score / var4
	end

	if not arg0.contextData.autoSkipFlag then
		arg0.duelAniamtion = NewBattleResultDuelAniamtion.New(arg0.playerExp, arg0.playerExpBar, var4, arg0.contextData.oldRank, var1)

		arg0.duelAniamtion:SetUp(var5)
	else
		var5()
	end
end

function var0.UpdateChapterName(arg0)
	local var0 = arg0.contextData
	local var1 = getProxy(MilitaryExerciseProxy):getPreRivalById(var0.rivalId or 0)
	local var2 = var1 and var1.name or ""

	arg0.chapterName.text = var2

	setActive(arg0.opBonus, false)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.duelAniamtion then
		arg0.duelAniamtion:Dispose()

		arg0.duelAniamtion = nil
	end
end

return var0
