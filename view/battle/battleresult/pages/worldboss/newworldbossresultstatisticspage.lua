local var0_0 = class("NewWorldBossResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0_0.UpdateGrade(arg0_1)
	local var0_1 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0_1, arg0_1.gradeTxt, false)
	setActive(arg0_1.gradeIcon, false)
	setActive(arg0_1.topPanel:Find("grade/label"), false)
end

function var0_0.LoadBG(arg0_2, arg1_2)
	local var0_2 = "CommonBg"

	LoadAnyAsync("BattleResultItems/" .. var0_2, "", nil, function(arg0_3)
		if arg0_2.exited or IsNil(arg0_3) then
			if arg1_2 then
				arg1_2()
			end

			return
		end

		local var0_3 = Object.Instantiate(arg0_3, arg0_2._tf)

		var0_3.transform:SetAsFirstSibling()

		arg0_2.effectTr = var0_3.transform

		if arg1_2 then
			arg1_2()
		end
	end)
end

function var0_0.UpdateOutput(arg0_4, arg1_4)
	setText(arg1_4:Find("Text"), arg0_4.contextData.statistics.specificDamage)
end

function var0_0.UpdateCommanders(arg0_5, arg1_5)
	LoadAnyAsync("BattleResultItems/Worldboss", "", nil, function(arg0_6)
		if arg0_5.exited or IsNil(arg0_6) then
			arg1_5()

			return
		end

		local var0_6 = Object.Instantiate(arg0_6, arg0_5.topPanel)

		arg0_5:UpdateOutput(var0_6.transform)
		arg1_5()
	end)
end

function var0_0.UpdatePlayer(arg0_7)
	setActive(arg0_7.topPanel:Find("exp"), false)
end

function var0_0.RegisterEvent(arg0_8, arg1_8)
	var0_0.super.RegisterEvent(arg0_8, arg1_8)
	triggerButton(arg0_8.statisticsBtn)
	setActive(arg0_8.statisticsBtn, false)
end

function var0_0.UpdatePainting(arg0_9, arg1_9)
	arg0_9:UpdatePaintingPosition()
	arg0_9:UpdateMvpPainting(arg1_9)
end

function var0_0.UpdateChapterName(arg0_10)
	arg0_10.chapterName.text = ""

	setActive(arg0_10.opBonus, false)
end

return var0_0
