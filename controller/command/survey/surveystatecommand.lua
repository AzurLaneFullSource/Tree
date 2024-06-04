local var0 = class("SurveyStateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11027, {
		survey_id = var0.surveyID
	}, 11028, function(arg0)
		if arg0.result == 0 then
			getProxy(ActivityProxy):setSurveyState(arg0.result)
		elseif arg0.result > 0 then
			getProxy(ActivityProxy):setSurveyState(arg0.result)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
