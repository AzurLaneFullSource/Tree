local var0 = class("BeatMonsterMeidator")
local var1 = 1
local var2 = 0.1
local var3 = 1

function var0.Ctor(arg0, arg1)
	pg.DelegateInfo.New(arg0)

	arg0.controller = arg1
end

function var0.SetUI(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.monsterNian = arg0:findTF("AD/monster")
	arg0.fushun = arg0:findTF("AD/fushun")
	arg0.hpTF = arg0:findTF("AD/hp"):GetComponent(typeof(Slider))
	arg0.attackCntTF = arg0:findTF("AD/attack_count/Text"):GetComponent(typeof(Text))
	arg0.actions = arg0:findTF("AD/actions")
	arg0.actionKeys = {
		arg0.actions:Find("content/1"),
		arg0.actions:Find("content/2"),
		arg0.actions:Find("content/3")
	}
	arg0.curtainTF = arg0:findTF("AD/curtain")
	arg0.startLabel = arg0.curtainTF:Find("start_label")
	arg0.ABtn = arg0:findTF("AD/A_btn")
	arg0.BBtn = arg0:findTF("AD/B_btn")
	arg0.joyStick = arg0:findTF("AD/joyStick")
end

function var0.DoCurtainUp(arg0, arg1)
	local var0 = getProxy(SettingsProxy)

	if var0:IsShowBeatMonseterNianCurtain() then
		var0:SetBeatMonseterNianFlag()
		arg0:StartCurtainUp(arg1)
	else
		arg1()
	end
end

function var0.StartCurtainUp(arg0, arg1)
	setActive(arg0.curtainTF, true)
	LeanTween.color(arg0.curtainTF, Color.white, var1):setFromColor(Color.black):setOnComplete(System.Action(function()
		setActive(arg0.startLabel, true)
		blinkAni(arg0.startLabel, var2, 2):setOnComplete(System.Action(function()
			LeanTween.alpha(arg0.curtainTF, 0, var3):setFrom(1)
			LeanTween.alpha(arg0.startLabel, 0, var3):setFrom(1):setOnComplete(System.Action(arg1))
		end))
	end))
end

function var0.OnInited(arg0)
	local function var0()
		if arg0.attackCnt <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_hit_monster_nocount"))

			return false
		end

		if arg0.hp <= 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("activity_hit_monster_reset_tip"),
				onYes = function()
					arg0.controller:ReStartGame()
				end
			})

			return false
		end

		return true
	end

	arg0:OnTrigger(arg0.ABtn, var0, function()
		arg0.controller:Input(BeatMonsterNianConst.ACTION_NAME_A)
	end)
	arg0:OnTrigger(arg0.BBtn, var0, function()
		arg0.controller:Input(BeatMonsterNianConst.ACTION_NAME_B)
	end)
	arg0:OnJoyStickTrigger(arg0.joyStick, var0, function(arg0)
		if arg0 > 0 then
			arg0.controller:Input(BeatMonsterNianConst.ACTION_NAME_R)
		elseif arg0 < 0 then
			arg0.controller:Input(BeatMonsterNianConst.ACTION_NAME_L)
		end
	end)
end

function var0.OnAttackCntUpdate(arg0, arg1, arg2)
	arg0.attackCnt = arg1
	arg0.attackCntTF.text = arg2 and "-" or arg1
end

function var0.OnMonsterHpUpdate(arg0, arg1)
	arg0.hp = arg1

	arg0.fuShun:SetInteger("hp", arg1)
	arg0.nian:SetInteger("hp", arg1)
end

function var0.OnUIHpUpdate(arg0, arg1, arg2, arg3)
	local var0 = arg0.hpTF.value
	local var1 = arg1 / arg2

	LeanTween.value(arg0.hpTF.gameObject, var0, var1, 0.3):setOnUpdate(System.Action_float(function(arg0)
		arg0.hpTF.value = arg0
	end)):setOnComplete(System.Action(function()
		if arg3 then
			arg3()
		end
	end))
end

function var0.OnAddFuShun(arg0, arg1)
	arg0.fuShun = arg0.fushun:GetComponent(typeof(Animator))

	arg0.fuShun:SetInteger("hp", arg1)
end

function var0.OnAddMonsterNian(arg0, arg1, arg2)
	arg0.hp = arg1
	arg0.nian = arg0.monsterNian:GetComponent(typeof(Animator))
	arg0.hpTF.value = arg1 / arg2

	arg0.nian:SetInteger("hp", arg1)
end

function var0.OnChangeFuShunAction(arg0, arg1)
	arg0.fuShun:SetTrigger(arg1)
end

function var0.OnChangeNianAction(arg0, arg1)
	arg0.nian:SetTrigger(arg1)
end

function var0.BanJoyStick(arg0, arg1)
	setActive(arg0.joyStick:Find("ban"), arg1)

	GetOrAddComponent(arg0.joyStick, typeof(EventTriggerListener)).enabled = not arg1
end

function var0.OnInputChange(arg0, arg1)
	local var0 = arg1 and arg1 ~= ""

	if var0 then
		for iter0, iter1 in ipairs(arg0.actionKeys) do
			local var1 = string.sub(arg1, iter0, iter0) or ""

			setActive(iter1:Find("A"), var1 == BeatMonsterNianConst.ACTION_NAME_A)
			setActive(iter1:Find("L"), var1 == BeatMonsterNianConst.ACTION_NAME_L)
			setActive(iter1:Find("R"), var1 == BeatMonsterNianConst.ACTION_NAME_R)
			setActive(iter1:Find("B"), var1 == BeatMonsterNianConst.ACTION_NAME_B)
		end
	end

	setActive(arg0.actions, var0)
	arg0:BanJoyStick(#arg1 == 2)
end

function var0.PlayStory(arg0, arg1, arg2)
	pg.NewStoryMgr.GetInstance():Play(arg1, arg2)
end

function var0.DisplayAwards(arg0, arg1, arg2)
	pg.m02:sendNotification(ActivityProxy.ACTIVITY_SHOW_AWARDS, {
		awards = arg1,
		callback = arg2
	})
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
end

function var0.OnTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("off")
	local var1 = true
	local var2 = GetOrAddComponent(arg1, typeof(EventTriggerListener))

	var2:AddPointDownFunc(function(arg0, arg1)
		var1 = arg2()

		if var1 then
			setActive(var0, false)
		end
	end)
	var2:AddPointUpFunc(function(arg0, arg1)
		if var1 then
			setActive(var0, true)

			if arg3 then
				arg3()
			end
		end
	end)
end

function var0.OnJoyStickTrigger(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("m")
	local var1 = arg1:Find("l")
	local var2 = arg1:Find("r")
	local var3 = GetOrAddComponent(arg1, typeof(EventTriggerListener))
	local var4
	local var5 = false

	var3:AddBeginDragFunc(function(arg0, arg1)
		var5 = arg2()
		var4 = arg1.position
	end)
	var3:AddDragFunc(function(arg0, arg1)
		if not var5 then
			return
		end

		local var0 = arg1.position.x - var4.x

		setActive(var0, var0 == 0)
		setActive(var1, var0 < 0)
		setActive(var2, var0 > 0)
	end)
	var3:AddDragEndFunc(function(arg0, arg1)
		if not var5 then
			return
		end

		local var0 = arg1.position.x - var4.x

		arg3(var0)
		setActive(var0, true)
		setActive(var1, false)
		setActive(var2, false)
	end)
end

function var0.findTF(arg0, arg1, arg2)
	assert(arg0._tf, "transform should exist")

	return findTF(arg2 or arg0._tf, arg1)
end

return var0
