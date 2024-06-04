local var0 = class("MainSequenceView")

function var0.Ctor(arg0)
	arg0.sequence = {
		MainRefundSequence.New(),
		MainForcePlayerNameModificationSequence.New(),
		MainRequestVoteInfoSequence.New(),
		MainStroySequence.New(),
		MainRequestActDataSequence.New(),
		MainUrShipReFetchSequence.New(),
		MainUrgencySceneSequence.New(),
		MainEquipmentChangeSequence.New(),
		MainServerNoticeSequence.New(),
		MainSublayerSequence.New(),
		MainChapterTimeUpSequence.New(),
		MainTechnologySequence.New(),
		MainSubmitTaskSequence.New(),
		MainRemoveNpcSequence.New(),
		MainReplaceFoodSequence.New(),
		MainOverDueEquipmentSequence.New(),
		MainOverDueAttireSequence.New(),
		MainOverDueSkinSequence.New(),
		MainGuildSequence.New(),
		MainMonthCardSequence.New(),
		MainMetaSkillSequence.New(),
		MainCrusingActSequence.New(),
		MainReceiveBossRushAwardsSequence.New(),
		MainNotificationWindowSequence.New(),
		MainRequestFeastActDataSequence.New(),
		MainActDataExpirationReminderSequence.New(),
		MainCalcHxSequence.New(),
		MainGuideSequence.New(),
		MainOpenSystemSequence.New()
	}
end

function var0.MapSequence(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg1) do
		table.insert(var0, function(arg0)
			if arg0._exited then
				return
			end

			iter1:Execute(arg0)
		end)
	end

	return var0
end

function var0.Execute(arg0, arg1)
	if not pg.SeriesGuideMgr.GetInstance():isEnd() then
		arg1()

		return
	end

	if not arg0.executable then
		arg0.executable = arg0:MapSequence(arg0.sequence)
	end

	seriesAsync(arg0.executable, arg1)
end

function var0.Disable(arg0)
	for iter0, iter1 in ipairs(arg0.sequence) do
		if iter1.Clear ~= nil then
			iter1:Clear()
		end
	end
end

function var0.Dispose(arg0)
	arg0._exited = true

	for iter0, iter1 in ipairs(arg0.sequence) do
		if iter1.Dispose ~= nil then
			iter1:Dispose()
		end
	end

	arg0.sequence = nil
	arg0.executable = nil
end

return var0
