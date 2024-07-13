local var0_0 = class("NewCardPuzzleResultGradePage", import("..NewBattleResultGradePage"))

function var0_0.LoadBG(arg0_1, arg1_1)
	local var0_1 = "CommonBg"

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0_1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_2)
		if arg0_1.exited or IsNil(arg0_2) then
			if arg1_1 then
				arg1_1()
			end

			return
		end

		Object.Instantiate(arg0_2, arg0_1.bgTr).transform:SetAsFirstSibling()

		if arg1_1 then
			arg1_1()
		end
	end), false, false)
end

function var0_0.LoadGrade(arg0_3, arg1_3)
	local var0_3, var1_3 = NewBattleResultUtil.Score2Grade(arg0_3.contextData.score)

	LoadImageSpriteAsync(var0_3, arg0_3.gradeIcon, true)
	LoadImageSpriteAsync(var1_3, arg0_3.gradeTxt, true)

	if arg1_3 then
		arg1_3()
	end
end

function var0_0.SetUp(arg0_4, arg1_4)
	arg0_4:Show()
	seriesAsync({
		function(arg0_5)
			arg0_4:LoadBGAndGrade(arg0_5)
		end,
		function(arg0_6)
			arg0_4:PlayEnterAnimation(arg0_6)
		end,
		function(arg0_7)
			arg0_4:RegisterEvent(arg0_7)
		end
	}, function()
		arg0_4:Clear()
		arg0_4:Destroy()
		arg1_4()
	end)
end

return var0_0
