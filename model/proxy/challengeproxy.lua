local var0 = class("ChallengeProxy", import(".NetProxy"))

var0.MODE_CASUAL = 0
var0.MODE_INFINITE = 1

function var0.register(arg0)
	arg0._curMode = var0.MODE_CASUAL
	arg0._challengeInfo = nil
	arg0._userChallengeList = {}

	arg0:on(24010, function(arg0)
		arg0:updateCombatScore(arg0.score)
	end)
end

function var0.userSeaonExpire(arg0, arg1)
	if arg0._challengeInfo:getSeasonID() ~= arg0._userChallengeList[arg1]:getSeasonID() then
		return true
	else
		return false
	end
end

function var0.updateCombatScore(arg0, arg1)
	arg0:getUserChallengeInfo(arg0._curMode):updateCombatScore(arg1)
end

function var0.updateSeasonChallenge(arg0, arg1)
	if not arg0._challengeInfo then
		arg0._challengeInfo = ChallengeInfo.New(arg1)
	else
		arg0._challengeInfo:UpdateChallengeInfo(arg1)
	end
end

function var0.updateCurrentChallenge(arg0, arg1)
	local var0 = arg1.mode
	local var1 = arg0._userChallengeList[var0]

	if var1 == nil then
		arg0._userChallengeList[var0] = UserChallengeInfo.New(arg1)
	else
		var1:UpdateChallengeInfo(arg1)
	end
end

function var0.GetCurrentChallenge(arg0, arg1)
	return arg0._userChallengeList
end

function var0.getCurMode(arg0)
	return arg0._curMode
end

function var0.setCurMode(arg0, arg1)
	if arg1 == var0.MODE_CASUAL then
		arg0._curMode = var0.MODE_CASUAL
	elseif arg1 == var0.MODE_INFINITE then
		arg0._curMode = var0.MODE_INFINITE
	else
		assert(false, "challenge mode undefined")
	end
end

function var0.getChallengeInfo(arg0)
	return arg0._challengeInfo
end

function var0.getUserChallengeInfoList(arg0)
	return arg0._userChallengeList
end

function var0.getUserChallengeInfo(arg0, arg1)
	return arg0._userChallengeList[arg1]
end

function var0.WriteBackOnExitBattleResult(arg0, arg1, arg2)
	local var0 = arg0:getUserChallengeInfo(arg2)

	if arg1 < ys.Battle.BattleConst.BattleScore.S then
		arg0:sendNotification(GAME.CHALLENGE2_RESET, {
			mode = arg2
		})
	else
		local var1 = var0:IsFinish()

		var0:updateLevelForward()

		if var0:getMode() == ChallengeProxy.MODE_INFINITE and var1 then
			var0:setInfiniteDungeonIDListByLevel()
		end
	end

	local var2 = arg0:getChallengeInfo()

	if not arg0:userSeaonExpire(var0:getMode()) then
		var2:checkRecord(var0)
	end
end

return var0
