local var0 = class("NewNavalTacticsShipCard", import(".NewNavalTacticsBaseCard"))

function var0.OnInit(arg0)
	arg0.skillNameTxt = findTF(arg0._tf, "skill/name_Text"):GetComponent(typeof(Text))
	arg0.skillIcon = findTF(arg0._tf, "skill/icon"):GetComponent(typeof(Image))
	arg0.skillExpSlider = findTF(arg0._tf, "skill/exp"):GetComponent(typeof(Slider))
	arg0.skillLevelTxt = findTF(arg0._tf, "skill/level"):GetComponent(typeof(Text))
	arg0.skillNextExp = findTF(arg0._tf, "skill/next"):GetComponent(typeof(Text))
	arg0.timeTxt = findTF(arg0._tf, "timer_Text"):GetComponent(typeof(Text))
	arg0.cancelBtn = findTF(arg0._tf, "cancel_btn")
	arg0.quickFinishBtn = findTF(arg0._tf, "quick_finish_btn")

	onButton(arg0, arg0.cancelBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tactics_lesson_cancel"),
			onYes = function()
				arg0:OnCancel()
			end
		})
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0._tf, "skill"), function()
		arg0:emit(NewNavalTacticsMediator.ON_SKILL, arg0.skillVO:GetDisplayId(), arg0.skillVO)
	end, SFX_PANEL)
	onButton(arg0, arg0.quickFinishBtn, function()
		arg0:emit(NewNavalTacticsMediator.ON_QUICK_FINISH, arg0.student.id)
	end, SFX_PANEL)
end

function var0.LoadShipCard(arg0)
	ResourceMgr.Inst:getAssetAsync("template/shipcardtpl", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		local var0 = Object.Instantiate(arg0, arg0._tf)

		var0.transform.localScale = Vector3(1.28, 1.28, 1)
		var0.transform.localPosition = Vector3(0, 251, 0)
		arg0.shipCard = DockyardShipItem.New(var0, ShipStatus.TAG_HIDE_ALL)

		arg0:UpdateShipCard()
	end), true, true)
end

function var0.OnUpdate(arg0, arg1)
	arg0.student = arg1
	arg0.ship = getProxy(BayProxy):RawGetShipById(arg0.student.shipId)

	local var0 = arg0.student:getSkillId(arg0.ship)

	arg0.skillVO = ShipSkill.New(arg0.ship.skills[var0], arg0.ship.id)

	arg0:UpdateSkill()

	if not arg0.shipCard then
		arg0:LoadShipCard()
	else
		arg0:UpdateShipCard()
	end

	arg0:AddTimer()
	setActive(arg0.quickFinishBtn, getProxy(NavalAcademyProxy):getDailyFinishCnt() > 0)
end

function var0.UpdateSkill(arg0)
	local var0 = arg0.ship
	local var1 = arg0.student
	local var2 = arg0.skillVO

	arg0.skillNameTxt.text = shortenString(var2:GetName(), 8)
	arg0.skillLevelTxt.text = var2.level

	LoadSpriteAsync("skillicon/" .. var2:GetIcon(), function(arg0)
		arg0.skillIcon.sprite = arg0
	end)

	if var2:IsMaxLevel() then
		arg0.skillNextExp.text = "MAX"
		arg0.skillExpSlider.value = 1
	else
		local var3 = var2:GetNextLevelExp()

		arg0.skillNextExp.text = var2.exp .. "/" .. var3
		arg0.skillExpSlider.value = var2.exp / var3
	end
end

function var0.AddTimer(arg0)
	arg0:RemoveTimer()

	local var0 = arg0.student:getFinishTime()

	arg0.timer = Timer.New(function()
		local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 < 0 then
			arg0:OnFinish()
		else
			arg0.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0)
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.OnFinish(arg0)
	arg0:RemoveTimer()

	arg0.timeTxt.text = ""

	arg0:emit(NewNavalTacticsMediator.ON_CANCEL, arg0.student.id, Student.CANCEL_TYPE_AUTO)
end

function var0.OnCancel(arg0)
	arg0:emit(NewNavalTacticsMediator.ON_CANCEL, arg0.student.id, Student.CANCEL_TYPE_MANUAL)
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.UpdateShipCard(arg0)
	if arg0.ship.id == arg0.shipID then
		return
	end

	arg0.shipCard:update(arg0.ship)

	arg0.shipID = arg0.ship.id
end

function var0.OnDispose(arg0)
	arg0:RemoveTimer()

	if LeanTween.isTweening(arg0.skillExpSlider.gameObject) then
		LeanTween.cancel(arg0.skillExpSlider.gameObject)
	end

	if LeanTween.isTweening(arg0.skillNextExp.gameObject) then
		LeanTween.cancel(arg0.skillNextExp.gameObject)
	end
end

function var0.DoAddExpAnim(arg0, arg1, arg2, arg3)
	if arg2.level - arg1.level > 0 then
		arg0:DoLevelUpAnim(arg1, arg2, arg3)
	else
		arg0:DoUnLevelUpAnim(arg1, arg2, arg3)
	end
end

function var0.DoLevelUpAnim(arg0, arg1, arg2, arg3)
	seriesAsync({
		function(arg0)
			arg0:Curr2One(arg1, arg0)
		end,
		function(arg0)
			arg0:Zero2One(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:Zero2New(arg2, arg0)
		end
	}, arg3)
end

function var0.Curr2One(arg0, arg1, arg2)
	local var0 = arg1:GetNextLevelExp()
	local var1 = arg1.exp / var0
	local var2 = 1 - var1

	LeanTween.value(arg0.skillExpSlider.gameObject, var1, 1, var2):setOnUpdate(System.Action_float(function(arg0)
		arg0.skillExpSlider.value = arg0
	end))
	LeanTween.value(arg0.skillNextExp.gameObject, arg1.exp, var0, var2 + 0.001):setOnUpdate(System.Action_float(function(arg0)
		arg0.skillNextExp.text = math.ceil(arg0) .. "/" .. var0
	end)):setOnComplete(System.Action(function()
		arg0.skillLevelTxt.text = arg1.level + 1

		arg2()
	end))
end

function var0.Zero2One(arg0, arg1, arg2, arg3)
	local var0 = arg1.level + 1

	if var0 == arg2.level then
		arg3()

		return
	end

	local function var1(arg0)
		local var0 = 0.3

		LeanTween.value(arg0.skillExpSlider.gameObject, 0, 1, var0):setOnUpdate(System.Action_float(function(arg0)
			arg0.skillExpSlider.value = arg0
		end))

		local var1 = ShipSkill.StaticGetNextLevelExp(var0)

		LeanTween.value(arg0.skillNextExp.gameObject, 0, var1, var0 + 0.001):setOnUpdate(System.Action_float(function(arg0)
			arg0.skillNextExp.text = math.ceil(arg0) .. "/" .. var1
		end)):setOnComplete(System.Action(function()
			arg0.skillLevelTxt.text = var0 + 1
			var0 = var0 + 1

			arg0()
		end))
	end

	local var2 = {}

	for iter0 = 1, arg2.level - arg1.level - 1 do
		table.insert(var2, var1)
	end

	seriesAsync(var2, arg3)
end

function var0.Zero2New(arg0, arg1, arg2)
	local var0 = arg1:GetNextLevelExp()
	local var1 = arg1.exp / var0

	if var1 == 0 or arg1:IsMaxLevel() then
		arg2()

		return
	end

	LeanTween.value(arg0.skillExpSlider.gameObject, 0, var1, var1):setOnUpdate(System.Action_float(function(arg0)
		arg0.skillExpSlider.value = arg0
	end))
	LeanTween.value(arg0.skillNextExp.gameObject, 0, var0, var1 + 0.001):setOnUpdate(System.Action_float(function(arg0)
		arg0.skillNextExp.text = math.ceil(arg0) .. "/" .. var0
	end)):setOnComplete(System.Action(arg2))
end

function var0.DoUnLevelUpAnim(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetNextLevelExp()
	local var1 = arg1.exp / var0
	local var2 = arg2.exp / var0

	LeanTween.value(arg0.skillExpSlider.gameObject, var1, var2, 1):setOnUpdate(System.Action_float(function(arg0)
		arg0.skillExpSlider.value = arg0
	end))
	LeanTween.value(arg0.skillNextExp.gameObject, arg1.exp, arg2.exp, 1.001):setOnUpdate(System.Action_float(function(arg0)
		arg0.skillNextExp.text = math.ceil(arg0) .. "/" .. var0
	end)):setOnComplete(System.Action(arg3))
end

return var0
