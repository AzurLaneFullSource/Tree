local var0_0 = class("IslandActivitySurveyPage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.SetEnterTag(arg0_1)
	PlayerPrefs.SetInt("survey_enter_" .. tostring(arg0_1), 1)
end

function var0_0.IsEverEnter(arg0_2)
	return PlayerPrefs.HasKey("survey_enter_" .. tostring(arg0_2))
end

function var0_0.ClearEnterTag(arg0_3)
	PlayerPrefs.DeleteKey("survey_enter_" .. tostring(arg0_3))
end

function var0_0.OnInit(arg0_4)
	arg0_4.actProxy = getProxy(ActivityProxy)
	arg0_4.isOpen, arg0_4.surveyID = arg0_4.actProxy:isSurveyOpen()

	if arg0_4.isOpen then
		arg0_4.isDone = arg0_4.actProxy:isSurveyDone()
	end

	setText(arg0_4.tipText1, i18n("island_survey_ui_1"))
	setText(arg0_4.tipText2, i18n("island_survey_ui_2"))
	setText(arg0_4.awardTipText, i18n("island_survey_ui_award"))
	setText(arg0_4.goTip, i18n("island_survey_ui_button"))
end

function var0_0.OnDataSetting(arg0_5)
	return
end

function var0_0.OnFirstFlush(arg0_6)
	setActive(arg0_6.goBtn, not arg0_6.isDone)

	local var0_6 = pg.survey_data_template[arg0_6.surveyID].bonus[1]

	updateCustomDrop(arg0_6.awardTF, Drop.New({
		type = var0_6[1],
		id = var0_6[2],
		count = var0_6[3]
	}))
	onButton(arg0_6, arg0_6.goBtn, function()
		pg.m02:sendNotification(GAME.SURVEY_REQUEST, {
			surveyID = arg0_6.surveyID,
			surveyUrlStr = getSurveyUrl(arg0_6.surveyID)
		})

		if IsUnityEditor then
			var0_0.ClearEnterTag(arg0_6.surveyID)
		end
	end, SFX_PANEL)
	var0_0.SetEnterTag(arg0_6.surveyID)
end

return var0_0
