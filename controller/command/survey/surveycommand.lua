local var0 = class("SurveyCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11025, {
		survey_id = var0.surveyID
	}, 11026, function(arg0)
		if arg0.result == 0 then
			print(var0.surveyID, var0.surveyUrlStr)
			pg.SdkMgr.GetInstance():Survey(var0.surveyUrlStr)

			if IsUnityEditor then
				Application.OpenURL(var0.surveyUrlStr)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
