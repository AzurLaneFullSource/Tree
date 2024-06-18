local var0_0 = class("SurveyStateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11027, {
		survey_id = var0_1.surveyID
	}, 11028, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(ActivityProxy):setSurveyState(arg0_2.result)
		elseif arg0_2.result > 0 then
			getProxy(ActivityProxy):setSurveyState(arg0_2.result)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
