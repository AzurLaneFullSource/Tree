local var0 = class("SurveyPage", import("...base.BaseActivityPage"))

function var0.SetEnterTag(arg0)
	PlayerPrefs.SetInt("survey_enter_" .. tostring(arg0), 1)
end

function var0.IsEverEnter(arg0)
	return PlayerPrefs.HasKey("survey_enter_" .. tostring(arg0))
end

function var0.ClearEnterTag(arg0)
	PlayerPrefs.DeleteKey("survey_enter_" .. tostring(arg0))
end

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("BG")
	arg0.bguo = arg0:findTF("BGUO")
	arg0.goBtn = arg0:findTF("GO")
	arg0.awardTF = arg0:findTF("Award")
	arg0.itemTF = arg0:findTF("Award/IconTpl")
	arg0.maskTF = arg0:findTF("Award/Mask")
	arg0.actProxy = getProxy(ActivityProxy)
	arg0.isOpen, arg0.surveyID = arg0.actProxy:isSurveyOpen()

	if arg0.isOpen then
		arg0.isDone = arg0.actProxy:isSurveyDone()
	end

	setActive(arg0.bg, true)
	setActive(arg0.bguo, false)
	setActive(arg0.goBtn, true)
end

function var0.OnFirstFlush(arg0)
	setActive(arg0.maskTF, arg0.isDone == true)
	setActive(arg0.goBtn, not arg0.isDone)

	local var0 = pg.survey_data_template[arg0.surveyID].bonus[1]
	local var1 = {
		type = var0[1],
		id = var0[2],
		count = var0[3]
	}

	updateDrop(arg0.itemTF, var1)
	onButton(arg0, arg0.itemTF, function()
		arg0:emit(BaseUI.ON_DROP, var1)
	end, SFX_PANEL)
	onButton(arg0, arg0.goBtn, function()
		pg.m02:sendNotification(GAME.SURVEY_REQUEST, {
			surveyID = arg0.surveyID,
			surveyUrlStr = getSurveyUrl(arg0.surveyID)
		})

		if IsUnityEditor then
			var0.ClearEnterTag(arg0.surveyID)
		end
	end, SFX_PANEL)
	var0.SetEnterTag(arg0.surveyID)
end

return var0
