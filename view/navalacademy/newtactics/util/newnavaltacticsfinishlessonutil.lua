local var0 = class("NewNavalTacticsFinishLessonUtil")

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.studentsPage = arg1
	arg0.selLessonPage = arg2
	arg0.selSkillPage = arg3
	arg0.queue = {}
end

function var0.Enter(arg0, arg1, arg2)
	if _.any(arg0.queue, function(arg0)
		return arg0[1] == arg1
	end) then
		return
	end

	table.insert(arg0.queue, {
		arg1,
		arg2
	})

	if #arg0.queue == 1 then
		arg0:Excute()
	end
end

function var0.Excute(arg0)
	local var0 = arg0.queue[1]

	if var0[2] == Student.CANCEL_TYPE_QUICKLY then
		pg.m02:sendNotification(GAME.QUICK_FINISH_LEARN_TACTICS, {
			shipId = var0[1]
		})
	else
		pg.m02:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = var0[1],
			type = var0[2]
		})
	end
end

function var0.NextOne(arg0)
	table.remove(arg0.queue, 1)
	pg.m02:sendNotification(NewNavalTacticsMediator.ON_FINISH_ONE_ANIM)

	if #arg0.queue > 0 then
		arg0:Excute()
	end
end

function var0.IsWorking(arg0)
	return #arg0.queue > 0
end

function var0.WaitForFinish(arg0, arg1, arg2, arg3, arg4, arg5)
	local function var0()
		arg0:DisplayResult(arg1, arg3, arg2, arg4, arg5)
	end

	local var1 = arg0.studentsPage:GetCard(arg1)

	var1:RemoveTimer()
	arg0:DoAnimtion(var1, arg3, arg4, arg5, var0)
end

function var0.DisplayResult(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = ""
	local var1 = getProxy(BayProxy):RawGetShipById(arg3)
	local var2 = var1:getName()
	local var3 = arg4:GetName()

	if arg5.level > arg4.level then
		var0 = i18n("tactics_end_to_learn", var2, var3, arg2) .. i18n("tactics_skill_level_up", arg4.level, arg5.level)
	else
		var0 = i18n("tactics_end_to_learn", var2, var3, arg2)
	end

	if arg5:IsMaxLevel() then
		arg0:HandleMaxLevel(arg1, var1, var0, var2, var3, arg2)
	else
		arg0:WhetherToContinue(var0, arg1, var1, arg4.id)
	end
end

function var0.HandleMaxLevel(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg2:getSkillList()

	if _.all(var0, function(arg0)
		return ShipSkill.New(arg2.skills[arg0]):IsMaxLevel()
	end) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = arg3,
			onYes = function()
				arg0:NextOne()
			end
		})
	else
		arg0:WhetherToContinueForOtherSkill(arg1, arg2, arg4, arg5, arg6)
	end
end

function var0.WhetherToContinueForOtherSkill(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = i18n("tactics_end_to_learn", arg3, arg4, arg5) .. i18n("tactics_continue_to_learn_other_skill")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideClose = true,
		content = var0,
		onYes = function()
			if arg0:ExistBook() then
				arg0:ContinuousLearningForOtherSkill(arg1, arg2)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
				arg0:NextOne()
			end
		end,
		onNo = function()
			arg0:NextOne()
		end
	})
end

function var0.ContinuousLearningForOtherSkill(arg0, arg1, arg2)
	local var0 = Student.New({
		id = arg1,
		ship_id = arg2.id
	})

	arg0.selSkillPage:SetCancelCallback(function()
		arg0:NextOne()
	end)
	arg0.selLessonPage:SetHideCallback(function()
		arg0:NextOne()
	end)
	arg0.selSkillPage:ExecuteAction("Show", var0)
end

function var0.WhetherToContinue(arg0, arg1, arg2, arg3, arg4)
	arg1 = arg1 .. i18n("tactics_continue_to_learn")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideClose = true,
		content = arg1,
		onYes = function()
			if arg0:ExistBook() then
				arg0:ContinuousLearning(arg2, arg3, arg4)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
				arg0:NextOne()
			end
		end,
		onNo = function()
			arg0:NextOne()
		end
	})
end

function var0.ExistBook(arg0)
	return #getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE) > 0
end

function var0.ContinuousLearning(arg0, arg1, arg2, arg3)
	local var0 = Student.New({
		id = arg1,
		ship_id = arg2.id
	})
	local var1 = arg2:getSkillList()
	local var2 = table.indexof(var1, arg3)

	assert(var2 and var2 > 0)
	var0:setSkillIndex(var2)
	arg0.selLessonPage:SetHideCallback(function()
		arg0:NextOne()
	end)
	arg0.selLessonPage:ExecuteAction("Show", var0, false)
end

function var0.DoAnimtion(arg0, arg1, arg2, arg3, arg4, arg5)
	if not arg1 then
		arg5()
	else
		arg1:DoAddExpAnim(arg3, arg4, arg5)
	end
end

function var0.Dispose(arg0)
	arg0.studentsPage = nil
	arg0.selLessonPage = nil
	arg0.selSkillPage = nil
	arg0.queue = {}
end

return var0
