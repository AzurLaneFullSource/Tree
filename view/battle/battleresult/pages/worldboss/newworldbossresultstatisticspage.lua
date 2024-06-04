local var0 = class("NewWorldBossResultStatisticsPage", import("..NewBattleResultStatisticsPage"))

function var0.UpdateGrade(arg0)
	local var0 = "battlescore/grade_label_clear"

	LoadImageSpriteAsync(var0, arg0.gradeTxt, false)
	setActive(arg0.gradeIcon, false)
	setActive(arg0.topPanel:Find("grade/label"), false)
end

function var0.LoadBG(arg0, arg1)
	local var0 = "CommonBg"

	ResourceMgr.Inst:getAssetAsync("BattleResultItems/" .. var0, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			if arg1 then
				arg1()
			end

			return
		end

		local var0 = Object.Instantiate(arg0, arg0._tf)

		var0.transform:SetAsFirstSibling()

		arg0.effectTr = var0.transform

		if arg1 then
			arg1()
		end
	end), true, true)
end

function var0.UpdateOutput(arg0, arg1)
	setText(arg1:Find("Text"), arg0.contextData.statistics.specificDamage)
end

function var0.UpdateCommanders(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/Worldboss", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited or IsNil(arg0) then
			arg1()

			return
		end

		local var0 = Object.Instantiate(arg0, arg0.topPanel)

		arg0:UpdateOutput(var0.transform)
		arg1()
	end), true, true)
end

function var0.UpdatePlayer(arg0)
	setActive(arg0.topPanel:Find("exp"), false)
end

function var0.RegisterEvent(arg0, arg1)
	var0.super.RegisterEvent(arg0, arg1)
	triggerButton(arg0.statisticsBtn)
	setActive(arg0.statisticsBtn, false)
end

function var0.UpdatePainting(arg0, arg1)
	arg0:UpdatePaintingPosition()
	arg0:UpdateMvpPainting(arg1)
end

function var0.UpdateChapterName(arg0)
	arg0.chapterName.text = ""

	setActive(arg0.opBonus, false)
end

return var0
