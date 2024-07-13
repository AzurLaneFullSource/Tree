local var0_0 = class("NewNavalTacticsShipCard", import(".NewNavalTacticsBaseCard"))

function var0_0.OnInit(arg0_1)
	arg0_1.skillNameTxt = findTF(arg0_1._tf, "skill/name_Text"):GetComponent(typeof(Text))
	arg0_1.skillIcon = findTF(arg0_1._tf, "skill/icon"):GetComponent(typeof(Image))
	arg0_1.skillExpSlider = findTF(arg0_1._tf, "skill/exp"):GetComponent(typeof(Slider))
	arg0_1.skillLevelTxt = findTF(arg0_1._tf, "skill/level"):GetComponent(typeof(Text))
	arg0_1.skillNextExp = findTF(arg0_1._tf, "skill/next"):GetComponent(typeof(Text))
	arg0_1.timeTxt = findTF(arg0_1._tf, "timer_Text"):GetComponent(typeof(Text))
	arg0_1.cancelBtn = findTF(arg0_1._tf, "cancel_btn")
	arg0_1.quickFinishBtn = findTF(arg0_1._tf, "quick_finish_btn")

	onButton(arg0_1, arg0_1.cancelBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("tactics_lesson_cancel"),
			onYes = function()
				arg0_1:OnCancel()
			end
		})
	end, SFX_CANCEL)
	onButton(arg0_1, findTF(arg0_1._tf, "skill"), function()
		arg0_1:emit(NewNavalTacticsMediator.ON_SKILL, arg0_1.skillVO:GetDisplayId(), arg0_1.skillVO)
	end, SFX_PANEL)
	onButton(arg0_1, arg0_1.quickFinishBtn, function()
		arg0_1:emit(NewNavalTacticsMediator.ON_QUICK_FINISH, arg0_1.student.id)
	end, SFX_PANEL)
end

function var0_0.LoadShipCard(arg0_6)
	ResourceMgr.Inst:getAssetAsync("template/shipcardtpl", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_7)
		local var0_7 = Object.Instantiate(arg0_7, arg0_6._tf)

		var0_7.transform.localScale = Vector3(1.28, 1.28, 1)
		var0_7.transform.localPosition = Vector3(0, 251, 0)
		arg0_6.shipCard = DockyardShipItem.New(var0_7, ShipStatus.TAG_HIDE_ALL)

		arg0_6:UpdateShipCard()
	end), true, true)
end

function var0_0.OnUpdate(arg0_8, arg1_8)
	arg0_8.student = arg1_8
	arg0_8.ship = getProxy(BayProxy):RawGetShipById(arg0_8.student.shipId)

	local var0_8 = arg0_8.student:getSkillId(arg0_8.ship)

	arg0_8.skillVO = ShipSkill.New(arg0_8.ship.skills[var0_8], arg0_8.ship.id)

	arg0_8:UpdateSkill()

	if not arg0_8.shipCard then
		arg0_8:LoadShipCard()
	else
		arg0_8:UpdateShipCard()
	end

	arg0_8:AddTimer()
	setActive(arg0_8.quickFinishBtn, getProxy(NavalAcademyProxy):getDailyFinishCnt() > 0)
end

function var0_0.UpdateSkill(arg0_9)
	local var0_9 = arg0_9.ship
	local var1_9 = arg0_9.student
	local var2_9 = arg0_9.skillVO

	arg0_9.skillNameTxt.text = shortenString(var2_9:GetName(), 8)
	arg0_9.skillLevelTxt.text = var2_9.level

	LoadSpriteAsync("skillicon/" .. var2_9:GetIcon(), function(arg0_10)
		arg0_9.skillIcon.sprite = arg0_10
	end)

	if var2_9:IsMaxLevel() then
		arg0_9.skillNextExp.text = "MAX"
		arg0_9.skillExpSlider.value = 1
	else
		local var3_9 = var2_9:GetNextLevelExp()

		arg0_9.skillNextExp.text = var2_9.exp .. "/" .. var3_9
		arg0_9.skillExpSlider.value = var2_9.exp / var3_9
	end
end

function var0_0.AddTimer(arg0_11)
	arg0_11:RemoveTimer()

	local var0_11 = arg0_11.student:getFinishTime()

	arg0_11.timer = Timer.New(function()
		local var0_12 = var0_11 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_12 < 0 then
			arg0_11:OnFinish()
		else
			arg0_11.timeTxt.text = pg.TimeMgr.GetInstance():DescCDTime(var0_12)
		end
	end, 1, -1)

	arg0_11.timer:Start()
	arg0_11.timer.func()
end

function var0_0.OnFinish(arg0_13)
	arg0_13:RemoveTimer()

	arg0_13.timeTxt.text = ""

	arg0_13:emit(NewNavalTacticsMediator.ON_CANCEL, arg0_13.student.id, Student.CANCEL_TYPE_AUTO)
end

function var0_0.OnCancel(arg0_14)
	arg0_14:emit(NewNavalTacticsMediator.ON_CANCEL, arg0_14.student.id, Student.CANCEL_TYPE_MANUAL)
end

function var0_0.RemoveTimer(arg0_15)
	if arg0_15.timer then
		arg0_15.timer:Stop()

		arg0_15.timer = nil
	end
end

function var0_0.UpdateShipCard(arg0_16)
	if arg0_16.ship.id == arg0_16.shipID then
		return
	end

	arg0_16.shipCard:update(arg0_16.ship)

	arg0_16.shipID = arg0_16.ship.id
end

function var0_0.OnDispose(arg0_17)
	arg0_17:RemoveTimer()

	if LeanTween.isTweening(arg0_17.skillExpSlider.gameObject) then
		LeanTween.cancel(arg0_17.skillExpSlider.gameObject)
	end

	if LeanTween.isTweening(arg0_17.skillNextExp.gameObject) then
		LeanTween.cancel(arg0_17.skillNextExp.gameObject)
	end
end

function var0_0.DoAddExpAnim(arg0_18, arg1_18, arg2_18, arg3_18)
	if arg2_18.level - arg1_18.level > 0 then
		arg0_18:DoLevelUpAnim(arg1_18, arg2_18, arg3_18)
	else
		arg0_18:DoUnLevelUpAnim(arg1_18, arg2_18, arg3_18)
	end
end

function var0_0.DoLevelUpAnim(arg0_19, arg1_19, arg2_19, arg3_19)
	seriesAsync({
		function(arg0_20)
			arg0_19:Curr2One(arg1_19, arg0_20)
		end,
		function(arg0_21)
			arg0_19:Zero2One(arg1_19, arg2_19, arg0_21)
		end,
		function(arg0_22)
			arg0_19:Zero2New(arg2_19, arg0_22)
		end
	}, arg3_19)
end

function var0_0.Curr2One(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:GetNextLevelExp()
	local var1_23 = arg1_23.exp / var0_23
	local var2_23 = 1 - var1_23

	LeanTween.value(arg0_23.skillExpSlider.gameObject, var1_23, 1, var2_23):setOnUpdate(System.Action_float(function(arg0_24)
		arg0_23.skillExpSlider.value = arg0_24
	end))
	LeanTween.value(arg0_23.skillNextExp.gameObject, arg1_23.exp, var0_23, var2_23 + 0.001):setOnUpdate(System.Action_float(function(arg0_25)
		arg0_23.skillNextExp.text = math.ceil(arg0_25) .. "/" .. var0_23
	end)):setOnComplete(System.Action(function()
		arg0_23.skillLevelTxt.text = arg1_23.level + 1

		arg2_23()
	end))
end

function var0_0.Zero2One(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg1_27.level + 1

	if var0_27 == arg2_27.level then
		arg3_27()

		return
	end

	local function var1_27(arg0_28)
		local var0_28 = 0.3

		LeanTween.value(arg0_27.skillExpSlider.gameObject, 0, 1, var0_28):setOnUpdate(System.Action_float(function(arg0_29)
			arg0_27.skillExpSlider.value = arg0_29
		end))

		local var1_28 = ShipSkill.StaticGetNextLevelExp(var0_27)

		LeanTween.value(arg0_27.skillNextExp.gameObject, 0, var1_28, var0_28 + 0.001):setOnUpdate(System.Action_float(function(arg0_30)
			arg0_27.skillNextExp.text = math.ceil(arg0_30) .. "/" .. var1_28
		end)):setOnComplete(System.Action(function()
			arg0_27.skillLevelTxt.text = var0_27 + 1
			var0_27 = var0_27 + 1

			arg0_28()
		end))
	end

	local var2_27 = {}

	for iter0_27 = 1, arg2_27.level - arg1_27.level - 1 do
		table.insert(var2_27, var1_27)
	end

	seriesAsync(var2_27, arg3_27)
end

function var0_0.Zero2New(arg0_32, arg1_32, arg2_32)
	local var0_32 = arg1_32:GetNextLevelExp()
	local var1_32 = arg1_32.exp / var0_32

	if var1_32 == 0 or arg1_32:IsMaxLevel() then
		arg2_32()

		return
	end

	LeanTween.value(arg0_32.skillExpSlider.gameObject, 0, var1_32, var1_32):setOnUpdate(System.Action_float(function(arg0_33)
		arg0_32.skillExpSlider.value = arg0_33
	end))
	LeanTween.value(arg0_32.skillNextExp.gameObject, 0, var0_32, var1_32 + 0.001):setOnUpdate(System.Action_float(function(arg0_34)
		arg0_32.skillNextExp.text = math.ceil(arg0_34) .. "/" .. var0_32
	end)):setOnComplete(System.Action(arg2_32))
end

function var0_0.DoUnLevelUpAnim(arg0_35, arg1_35, arg2_35, arg3_35)
	local var0_35 = arg2_35:GetNextLevelExp()
	local var1_35 = arg1_35.exp / var0_35
	local var2_35 = arg2_35.exp / var0_35

	LeanTween.value(arg0_35.skillExpSlider.gameObject, var1_35, var2_35, 1):setOnUpdate(System.Action_float(function(arg0_36)
		arg0_35.skillExpSlider.value = arg0_36
	end))
	LeanTween.value(arg0_35.skillNextExp.gameObject, arg1_35.exp, arg2_35.exp, 1.001):setOnUpdate(System.Action_float(function(arg0_37)
		arg0_35.skillNextExp.text = math.ceil(arg0_37) .. "/" .. var0_35
	end)):setOnComplete(System.Action(arg3_35))
end

return var0_0
