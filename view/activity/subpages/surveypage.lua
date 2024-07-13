local var0_0 = class("SurveyPage", import("...base.BaseActivityPage"))

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
	arg0_4.bg = arg0_4:findTF("BG")
	arg0_4.bguo = arg0_4:findTF("BGUO")
	arg0_4.goBtn = arg0_4:findTF("GO")
	arg0_4.awardTF = arg0_4:findTF("Award")
	arg0_4.itemTF = arg0_4:findTF("Award/IconTpl")
	arg0_4.maskTF = arg0_4:findTF("Award/Mask")
	arg0_4.actProxy = getProxy(ActivityProxy)
	arg0_4.isOpen, arg0_4.surveyID = arg0_4.actProxy:isSurveyOpen()

	if arg0_4.isOpen then
		arg0_4.isDone = arg0_4.actProxy:isSurveyDone()
	end

	setActive(arg0_4.bg, true)
	setActive(arg0_4.bguo, false)
	setActive(arg0_4.goBtn, true)
end

function var0_0.OnFirstFlush(arg0_5)
	setActive(arg0_5.maskTF, arg0_5.isDone == true)
	setActive(arg0_5.goBtn, not arg0_5.isDone)

	local var0_5 = pg.survey_data_template[arg0_5.surveyID].bonus[1]
	local var1_5 = {
		type = var0_5[1],
		id = var0_5[2],
		count = var0_5[3]
	}

	updateDrop(arg0_5.itemTF, var1_5)
	onButton(arg0_5, arg0_5.itemTF, function()
		arg0_5:emit(BaseUI.ON_DROP, var1_5)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.goBtn, function()
		pg.m02:sendNotification(GAME.SURVEY_REQUEST, {
			surveyID = arg0_5.surveyID,
			surveyUrlStr = getSurveyUrl(arg0_5.surveyID)
		})

		if IsUnityEditor then
			var0_0.ClearEnterTag(arg0_5.surveyID)
		end
	end, SFX_PANEL)
	var0_0.SetEnterTag(arg0_5.surveyID)
end

return var0_0
