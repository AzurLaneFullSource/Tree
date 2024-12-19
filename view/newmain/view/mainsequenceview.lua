local var0_0 = class("MainSequenceView")

function var0_0.Ctor(arg0_1)
	arg0_1.sequence = {
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
		MainSkinDiscountItemTipSequence.New(),
		MainOverDueSkinDiscountItemSequence.New(),
		MainOverDueAttireSequence.New(),
		MainOverDueSkinSequence.New(),
		MainGuildSequence.New(),
		MainMonthCardSequence.New(),
		MainMetaSkillSequence.New(),
		MainCrusingActSequence.New(),
		MainReceiveBossRushAwardsSequence.New(),
		MainActivateInsTopicSequence.New(),
		MainNotificationWindowSequence.New(),
		MainRequestFeastActDataSequence.New(),
		MainActDataExpirationReminderSequence.New(),
		MainCalcHxSequence.New(),
		MainGuideSequence.New(),
		MainOpenSystemSequence.New()
	}
end

function var0_0.MapSequence(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2) do
		table.insert(var0_2, function(arg0_3)
			if arg0_2._exited then
				return
			end

			iter1_2:Execute(arg0_3)
		end)
	end

	return var0_2
end

function var0_0.Execute(arg0_4, arg1_4)
	if not pg.SeriesGuideMgr.GetInstance():isEnd() then
		arg1_4()

		return
	end

	if not arg0_4.executable then
		arg0_4.executable = arg0_4:MapSequence(arg0_4.sequence)
	end

	seriesAsync(arg0_4.executable, arg1_4)
end

function var0_0.Disable(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.sequence) do
		if iter1_5.Clear ~= nil then
			iter1_5:Clear()
		end
	end
end

function var0_0.Dispose(arg0_6)
	arg0_6._exited = true

	for iter0_6, iter1_6 in ipairs(arg0_6.sequence) do
		if iter1_6.Dispose ~= nil then
			iter1_6:Dispose()
		end
	end

	arg0_6.sequence = nil
	arg0_6.executable = nil
end

return var0_0
