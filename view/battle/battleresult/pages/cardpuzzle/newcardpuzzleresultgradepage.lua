local var0 = class("NewCardPuzzleResultGradePage", import("..NewBattleResultGradePage"))

function var0.LoadBG(arg0, arg1)
	local var0 = "CommonBg"

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		Object.Instantiate(arg0, arg0.bgTr).transform:SetAsFirstSibling()

		if arg1 then
			arg1()
		end
	end), false, false)
end

function var0.LoadGrade(arg0, arg1)
	local var0, var1 = NewBattleResultUtil.Score2Grade(arg0.contextData.score)

	LoadImageSpriteAsync(var0, arg0.gradeIcon, true)
	LoadImageSpriteAsync(var1, arg0.gradeTxt, true)

	if arg1 then
		arg1()
	end
end

function var0.SetUp(arg0, arg1)
	arg0:Show()
	seriesAsync({
		function(arg0)
			arg0:LoadBGAndGrade(arg0)
		end,
		function(arg0)
			arg0:PlayEnterAnimation(arg0)
		end,
		function(arg0)
			arg0:RegisterEvent(arg0)
		end
	}, function()
		arg0:Clear()
		arg0:Destroy()
		arg1()
	end)
end

return var0
