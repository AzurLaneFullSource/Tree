local var0_0 = class("ChallengeProxy", import(".NetProxy"))

var0_0.MODE_CASUAL = 0
var0_0.MODE_INFINITE = 1

function var0_0.register(arg0_1)
	arg0_1._curMode = var0_0.MODE_CASUAL
	arg0_1._challengeInfo = nil
	arg0_1._userChallengeList = {}

	arg0_1:on(24010, function(arg0_2)
		arg0_1:updateCombatScore(arg0_2.score)
	end)
end

function var0_0.userSeaonExpire(arg0_3, arg1_3)
	if arg0_3._challengeInfo:getSeasonID() ~= arg0_3._userChallengeList[arg1_3]:getSeasonID() then
		return true
	else
		return false
	end
end

function var0_0.updateCombatScore(arg0_4, arg1_4)
	arg0_4:getUserChallengeInfo(arg0_4._curMode):updateCombatScore(arg1_4)
end

function var0_0.updateSeasonChallenge(arg0_5, arg1_5)
	if not arg0_5._challengeInfo then
		arg0_5._challengeInfo = ChallengeInfo.New(arg1_5)
	else
		arg0_5._challengeInfo:UpdateChallengeInfo(arg1_5)
	end
end

function var0_0.updateCurrentChallenge(arg0_6, arg1_6)
	local var0_6 = arg1_6.mode
	local var1_6 = arg0_6._userChallengeList[var0_6]

	if var1_6 == nil then
		arg0_6._userChallengeList[var0_6] = UserChallengeInfo.New(arg1_6)
	else
		var1_6:UpdateChallengeInfo(arg1_6)
	end
end

function var0_0.GetCurrentChallenge(arg0_7, arg1_7)
	return arg0_7._userChallengeList
end

function var0_0.getCurMode(arg0_8)
	return arg0_8._curMode
end

function var0_0.setCurMode(arg0_9, arg1_9)
	if arg1_9 == var0_0.MODE_CASUAL then
		arg0_9._curMode = var0_0.MODE_CASUAL
	elseif arg1_9 == var0_0.MODE_INFINITE then
		arg0_9._curMode = var0_0.MODE_INFINITE
	else
		assert(false, "challenge mode undefined")
	end
end

function var0_0.getChallengeInfo(arg0_10)
	return arg0_10._challengeInfo
end

function var0_0.getUserChallengeInfoList(arg0_11)
	return arg0_11._userChallengeList
end

function var0_0.getUserChallengeInfo(arg0_12, arg1_12)
	return arg0_12._userChallengeList[arg1_12]
end

function var0_0.WriteBackOnExitBattleResult(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13:getUserChallengeInfo(arg2_13)

	if arg1_13 < ys.Battle.BattleConst.BattleScore.S then
		arg0_13:sendNotification(GAME.CHALLENGE2_RESET, {
			mode = arg2_13
		})
	else
		local var1_13 = var0_13:IsFinish()

		var0_13:updateLevelForward()

		if var0_13:getMode() == ChallengeProxy.MODE_INFINITE and var1_13 then
			var0_13:setInfiniteDungeonIDListByLevel()
		end
	end

	local var2_13 = arg0_13:getChallengeInfo()

	if not arg0_13:userSeaonExpire(var0_13:getMode()) then
		var2_13:checkRecord(var0_13)
	end
end

return var0_0
