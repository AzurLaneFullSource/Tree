local var0_0 = class("SurveyCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11025, {
		survey_id = var0_1.surveyID
	}, 11026, function(arg0_2)
		if arg0_2.result == 0 then
			print(var0_1.surveyID, var0_1.surveyUrlStr)
			pg.SdkMgr.GetInstance():Survey(var0_1.surveyUrlStr)

			if IsUnityEditor then
				Application.OpenURL(var0_1.surveyUrlStr)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
