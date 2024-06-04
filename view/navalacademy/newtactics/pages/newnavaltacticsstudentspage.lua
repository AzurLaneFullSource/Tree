local var0 = class("NewNavalTacticsStudentsPage", import("....base.BaseSubView"))
local var1 = 1
local var2 = 2
local var3 = 3

function var0.getUIName(arg0)
	return "NewNavalTacticsStudentsPage"
end

function var0.OnUnlockSlot(arg0)
	arg0:Flush()
end

function var0.OnAddStudent(arg0)
	arg0:Flush()
end

function var0.OnExitStudent(arg0)
	arg0:Flush()
end

function var0.OnLoaded(arg0)
	arg0.helpBtn = arg0:findTF("help_btn")

	local var0 = arg0:findTF("info")
	local var1 = arg0:findTF("add")
	local var2 = arg0:findTF("lock")

	arg0.cards = {
		{},
		{},
		{}
	}

	table.insert(arg0.cards[var1], NewNavalTacticsShipCard.New(var0, arg0.event))
	table.insert(arg0.cards[var2], NewNavalTacticsEmptyCard.New(var1, arg0.event))
	table.insert(arg0.cards[var3], NewNavalTacticsLockCard.New(var2, arg0.event))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.tactics_lesson_system_introduce.tip
		})
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.students = arg1

	arg0:Flush()
end

function var0.Flush(arg0)
	local var0 = {
		0,
		0,
		0
	}
	local var1 = getProxy(NavalAcademyProxy):getSkillClassNum()

	for iter0 = 1, NavalAcademyProxy.MAX_SKILL_CLASS_NUM do
		local var2 = arg0:GetCardType(iter0, var1)

		var0[var2] = var0[var2] + 1

		arg0:UpdateTypeCard(var2, var0[var2], iter0)
	end

	for iter1, iter2 in ipairs(var0) do
		arg0:ClearDisableCards(iter1, iter2)
	end
end

function var0.GetCardType(arg0, arg1, arg2)
	if arg2 < arg1 then
		return var3
	else
		return arg0.students[arg1] and var1 or var2
	end
end

function var0.UpdateTypeCard(arg0, arg1, arg2, arg3)
	local var0 = arg0.cards[arg1]
	local var1 = var0[arg2]

	if not var1 then
		var1 = var0[1]:Clone()
		var0[arg2] = var1
	end

	var1:Enable()

	local var2 = arg0.students[arg3]

	var1:Update(arg3, var2)
end

function var0.ClearDisableCards(arg0, arg1, arg2)
	local var0 = arg0.cards[arg1]

	for iter0 = #var0, arg2 + 1, -1 do
		var0[iter0]:Disable()
	end
end

function var0.GetCard(arg0, arg1)
	local var0 = arg0.cards[var1]

	return underscore.detect(var0, function(arg0)
		return arg0.index == arg1
	end)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in ipairs(arg0.cards) do
		for iter2, iter3 in ipairs(iter1) do
			iter3:Dispose()
		end
	end

	arg0.cards = nil
end

return var0
