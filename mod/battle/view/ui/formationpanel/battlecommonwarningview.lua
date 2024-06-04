ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = var0.Battle.BattleSkillEditCustomWarning
local var3 = class("BattleCommonWarningView")

var0.Battle.BattleCommonWarningView = var3
var3.__name = "BattleCommonWarningView"
var3.WARNING_TYPE_SUBMARINE = "submarine"
var3.WARNING_TYPE_ARTILLERY = "artillery"

function var3.Ctor(arg0, arg1)
	arg0._submarineCount = 0
	arg0._go = arg1
	arg0._tf = arg1.transform
	arg0._subIcon = arg0._tf:Find("submarineIcon")
	arg0._tips = arg0._tf:Find("warningTips")
	arg0._subWarn = arg0._tf:Find("submarineWarningTips")
	arg0._warningRequestTable = {
		{
			flag = false,
			type = var3.WARNING_TYPE_ARTILLERY,
			tf = arg0._tips
		},
		{
			flag = false,
			type = var3.WARNING_TYPE_SUBMARINE,
			tf = arg0._subWarn
		}
	}
	arg0._customWarningTpl = arg0._tf:Find("customWarningTpl")
	arg0._customWarningContainer = arg0._tf:Find("customWarningContainer")
	arg0._customWarningList = {}
end

function var3.UpdateHostileSubmarineCount(arg0, arg1)
	if arg1 > 0 and arg0._submarineCount <= 0 then
		arg0:activeSubmarineWarning()
	elseif arg0._submarineCount > 0 and arg1 <= 0 then
		arg0:deactiveSubmarineWarning()
	end

	arg0._submarineCount = arg1
end

function var3.GetCount(arg0)
	return arg0._submarineCount
end

function var3.ActiveWarning(arg0, arg1)
	local var0 = false
	local var1 = #arg0._warningRequestTable

	for iter0, iter1 in ipairs(arg0._warningRequestTable) do
		if arg1 == iter1.type then
			iter1.flag = true

			if not var0 then
				SetActive(iter1.tf, true)

				var1 = iter0
			else
				break
			end
		else
			var0 = var0 or iter1.flag

			if iter1.flag and var1 < iter0 then
				SetActive(iter1.tf, false)
			end
		end
	end
end

function var3.DeactiveWarning(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._warningRequestTable) do
		if arg1 == iter1.type then
			iter1.flag = false

			SetActive(iter1.tf, false)
		elseif iter1.flag then
			arg0:ActiveWarning(iter1.type)

			break
		end
	end
end

function var3.EditCustomWarning(arg0, arg1)
	local var0 = arg1.op
	local var1 = arg1.key

	if var0 == var2.OP_ADD then
		local var2 = cloneTplTo(arg0._customWarningTpl, arg0._customWarningContainer)
		local var3 = var0.Battle.BattleCustomWarningLabel.New(var2)

		var3:ConfigData(arg1)

		arg0._customWarningList[var1] = var3
	elseif var0 == var2.OP_REMOVE then
		local var4 = arg0._customWarningList[var1]

		if var4 then
			var4:SetExpire()
		end
	elseif var0 == var2.OP_REMOVE_PERMANENT then
		for iter0, iter1 in pairs(arg0._customWarningList) do
			if iter1:GetDuration() <= 0 then
				iter1:SetExpire()
			end
		end
	elseif var0 == var2.OP_REMOVE_TEMPLATE then
		for iter2, iter3 in pairs(arg0._customWarningList) do
			if iter3:GetDuration() > 0 then
				iter3:SetExpire()
			end
		end
	end
end

function var3.Update(arg0)
	for iter0, iter1 in pairs(arg0._customWarningList) do
		iter1:Update()

		if iter1:IsExpire() then
			iter1:Dispose()

			arg0._customWarningList[iter0] = nil
		end
	end
end

function var3.activeSubmarineWarning(arg0)
	SetActive(arg0._subIcon, true)
	arg0:ActiveWarning(var3.WARNING_TYPE_SUBMARINE)
	LeanTween.cancel(go(arg0._subIcon))
	LeanTween.alpha(rtf(arg0._subIcon), 1, 2):setFrom(0)
end

function var3.deactiveSubmarineWarning(arg0)
	LeanTween.cancel(go(arg0._subIcon))
	LeanTween.alpha(rtf(arg0._subIcon), 0, 1):setFrom(1):setOnComplete(System.Action(function()
		SetActive(arg0._subIcon, false)
		arg0:DeactiveWarning(var3.WARNING_TYPE_SUBMARINE)
	end))
end

function var3.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._customWarningList) do
		iter1:Dispose()

		arg0._customWarningList[iter0] = nil
	end

	arg0._customWarningList = nil
	arg0._go = nil
	arg0._tf = nil
	arg0._icon = nil
	arg0._tips = nil
end
