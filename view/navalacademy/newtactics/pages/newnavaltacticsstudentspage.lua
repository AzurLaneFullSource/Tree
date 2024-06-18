local var0_0 = class("NewNavalTacticsStudentsPage", import("....base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.getUIName(arg0_1)
	return "NewNavalTacticsStudentsPage"
end

function var0_0.OnUnlockSlot(arg0_2)
	arg0_2:Flush()
end

function var0_0.OnAddStudent(arg0_3)
	arg0_3:Flush()
end

function var0_0.OnExitStudent(arg0_4)
	arg0_4:Flush()
end

function var0_0.OnLoaded(arg0_5)
	arg0_5.helpBtn = arg0_5:findTF("help_btn")

	local var0_5 = arg0_5:findTF("info")
	local var1_5 = arg0_5:findTF("add")
	local var2_5 = arg0_5:findTF("lock")

	arg0_5.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0_5.cards[var1_0], NewNavalTacticsShipCard.New(var0_5, arg0_5.event))
	table.insert(arg0_5.cards[var2_0], NewNavalTacticsEmptyCard.New(var1_5, arg0_5.event))
	table.insert(arg0_5.cards[var3_0], NewNavalTacticsLockCard.New(var2_5, arg0_5.event))
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tactics_lesson_system_introduce.tip
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8, arg1_8)
	var0_0.super.Show(arg0_8)

	arg0_8.students = arg1_8

	arg0_8:Flush()
end

function var0_0.Flush(arg0_9)
	local var0_9 = {
		0,
		0,
		0
	}
	local var1_9 = getProxy(NavalAcademyProxy):getSkillClassNum()

	for iter0_9 = 1, NavalAcademyProxy.MAX_SKILL_CLASS_NUM do
		local var2_9 = arg0_9:GetCardType(iter0_9, var1_9)

		var0_9[var2_9] = var0_9[var2_9] + 1

		arg0_9:UpdateTypeCard(var2_9, var0_9[var2_9], iter0_9)
	end

	for iter1_9, iter2_9 in ipairs(var0_9) do
		arg0_9:ClearDisableCards(iter1_9, iter2_9)
	end
end

function var0_0.GetCardType(arg0_10, arg1_10, arg2_10)
	if arg2_10 < arg1_10 then
		return var3_0
	else
		return arg0_10.students[arg1_10] and var1_0 or var2_0
	end
end

function var0_0.UpdateTypeCard(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg0_11.cards[arg1_11]
	local var1_11 = var0_11[arg2_11]

	if not var1_11 then
		var1_11 = var0_11[1]:Clone()
		var0_11[arg2_11] = var1_11
	end

	var1_11:Enable()

	local var2_11 = arg0_11.students[arg3_11]

	var1_11:Update(arg3_11, var2_11)
end

function var0_0.ClearDisableCards(arg0_12, arg1_12, arg2_12)
	local var0_12 = arg0_12.cards[arg1_12]

	for iter0_12 = #var0_12, arg2_12 + 1, -1 do
		var0_12[iter0_12]:Disable()
	end
end

function var0_0.GetCard(arg0_13, arg1_13)
	local var0_13 = arg0_13.cards[var1_0]

	return underscore.detect(var0_13, function(arg0_14)
		return arg0_14.index == arg1_13
	end)
end

function var0_0.OnDestroy(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.cards) do
		for iter2_15, iter3_15 in ipairs(iter1_15) do
			iter3_15:Dispose()
		end
	end

	arg0_15.cards = nil
end

return var0_0
