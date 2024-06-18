local var0_0 = class("BeatMonsterMeidator")
local var1_0 = 1
local var2_0 = 0.1
local var3_0 = 1

function var0_0.Ctor(arg0_1, arg1_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.controller = arg1_1
end

function var0_0.SetUI(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = tf(arg1_2)
	arg0_2.monsterNian = arg0_2:findTF("AD/monster")
	arg0_2.fushun = arg0_2:findTF("AD/fushun")
	arg0_2.hpTF = arg0_2:findTF("AD/hp"):GetComponent(typeof(Slider))
	arg0_2.attackCntTF = arg0_2:findTF("AD/attack_count/Text"):GetComponent(typeof(Text))
	arg0_2.actions = arg0_2:findTF("AD/actions")
	arg0_2.actionKeys = {
		arg0_2.actions:Find("content/1"),
		arg0_2.actions:Find("content/2"),
		arg0_2.actions:Find("content/3")
	}
	arg0_2.curtainTF = arg0_2:findTF("AD/curtain")
	arg0_2.startLabel = arg0_2.curtainTF:Find("start_label")
	arg0_2.ABtn = arg0_2:findTF("AD/A_btn")
	arg0_2.BBtn = arg0_2:findTF("AD/B_btn")
	arg0_2.joyStick = arg0_2:findTF("AD/joyStick")
end

function var0_0.DoCurtainUp(arg0_3, arg1_3)
	local var0_3 = getProxy(SettingsProxy)

	if var0_3:IsShowBeatMonseterNianCurtain() then
		var0_3:SetBeatMonseterNianFlag()
		arg0_3:StartCurtainUp(arg1_3)
	else
		arg1_3()
	end
end

function var0_0.StartCurtainUp(arg0_4, arg1_4)
	setActive(arg0_4.curtainTF, true)
	LeanTween.color(arg0_4.curtainTF, Color.white, var1_0):setFromColor(Color.black):setOnComplete(System.Action(function()
		setActive(arg0_4.startLabel, true)
		blinkAni(arg0_4.startLabel, var2_0, 2):setOnComplete(System.Action(function()
			LeanTween.alpha(arg0_4.curtainTF, 0, var3_0):setFrom(1)
			LeanTween.alpha(arg0_4.startLabel, 0, var3_0):setFrom(1):setOnComplete(System.Action(arg1_4))
		end))
	end))
end

function var0_0.OnInited(arg0_7)
	local function var0_7()
		if arg0_7.attackCnt <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("activity_hit_monster_nocount"))

			return false
		end

		if arg0_7.hp <= 0 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("activity_hit_monster_reset_tip"),
				onYes = function()
					arg0_7.controller:ReStartGame()
				end
			})

			return false
		end

		return true
	end

	arg0_7:OnTrigger(arg0_7.ABtn, var0_7, function()
		arg0_7.controller:Input(BeatMonsterNianConst.ACTION_NAME_A)
	end)
	arg0_7:OnTrigger(arg0_7.BBtn, var0_7, function()
		arg0_7.controller:Input(BeatMonsterNianConst.ACTION_NAME_B)
	end)
	arg0_7:OnJoyStickTrigger(arg0_7.joyStick, var0_7, function(arg0_12)
		if arg0_12 > 0 then
			arg0_7.controller:Input(BeatMonsterNianConst.ACTION_NAME_R)
		elseif arg0_12 < 0 then
			arg0_7.controller:Input(BeatMonsterNianConst.ACTION_NAME_L)
		end
	end)
end

function var0_0.OnAttackCntUpdate(arg0_13, arg1_13, arg2_13)
	arg0_13.attackCnt = arg1_13
	arg0_13.attackCntTF.text = arg2_13 and "-" or arg1_13
end

function var0_0.OnMonsterHpUpdate(arg0_14, arg1_14)
	arg0_14.hp = arg1_14

	arg0_14.fuShun:SetInteger("hp", arg1_14)
	arg0_14.nian:SetInteger("hp", arg1_14)
end

function var0_0.OnUIHpUpdate(arg0_15, arg1_15, arg2_15, arg3_15)
	local var0_15 = arg0_15.hpTF.value
	local var1_15 = arg1_15 / arg2_15

	LeanTween.value(arg0_15.hpTF.gameObject, var0_15, var1_15, 0.3):setOnUpdate(System.Action_float(function(arg0_16)
		arg0_15.hpTF.value = arg0_16
	end)):setOnComplete(System.Action(function()
		if arg3_15 then
			arg3_15()
		end
	end))
end

function var0_0.OnAddFuShun(arg0_18, arg1_18)
	arg0_18.fuShun = arg0_18.fushun:GetComponent(typeof(Animator))

	arg0_18.fuShun:SetInteger("hp", arg1_18)
end

function var0_0.OnAddMonsterNian(arg0_19, arg1_19, arg2_19)
	arg0_19.hp = arg1_19
	arg0_19.nian = arg0_19.monsterNian:GetComponent(typeof(Animator))
	arg0_19.hpTF.value = arg1_19 / arg2_19

	arg0_19.nian:SetInteger("hp", arg1_19)
end

function var0_0.OnChangeFuShunAction(arg0_20, arg1_20)
	arg0_20.fuShun:SetTrigger(arg1_20)
end

function var0_0.OnChangeNianAction(arg0_21, arg1_21)
	arg0_21.nian:SetTrigger(arg1_21)
end

function var0_0.BanJoyStick(arg0_22, arg1_22)
	setActive(arg0_22.joyStick:Find("ban"), arg1_22)

	GetOrAddComponent(arg0_22.joyStick, typeof(EventTriggerListener)).enabled = not arg1_22
end

function var0_0.OnInputChange(arg0_23, arg1_23)
	local var0_23 = arg1_23 and arg1_23 ~= ""

	if var0_23 then
		for iter0_23, iter1_23 in ipairs(arg0_23.actionKeys) do
			local var1_23 = string.sub(arg1_23, iter0_23, iter0_23) or ""

			setActive(iter1_23:Find("A"), var1_23 == BeatMonsterNianConst.ACTION_NAME_A)
			setActive(iter1_23:Find("L"), var1_23 == BeatMonsterNianConst.ACTION_NAME_L)
			setActive(iter1_23:Find("R"), var1_23 == BeatMonsterNianConst.ACTION_NAME_R)
			setActive(iter1_23:Find("B"), var1_23 == BeatMonsterNianConst.ACTION_NAME_B)
		end
	end

	setActive(arg0_23.actions, var0_23)
	arg0_23:BanJoyStick(#arg1_23 == 2)
end

function var0_0.PlayStory(arg0_24, arg1_24, arg2_24)
	pg.NewStoryMgr.GetInstance():Play(arg1_24, arg2_24)
end

function var0_0.DisplayAwards(arg0_25, arg1_25, arg2_25)
	pg.m02:sendNotification(ActivityProxy.ACTIVITY_SHOW_AWARDS, {
		awards = arg1_25,
		callback = arg2_25
	})
end

function var0_0.Dispose(arg0_26)
	pg.DelegateInfo.Dispose(arg0_26)
end

function var0_0.OnTrigger(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = arg1_27:Find("off")
	local var1_27 = true
	local var2_27 = GetOrAddComponent(arg1_27, typeof(EventTriggerListener))

	var2_27:AddPointDownFunc(function(arg0_28, arg1_28)
		var1_27 = arg2_27()

		if var1_27 then
			setActive(var0_27, false)
		end
	end)
	var2_27:AddPointUpFunc(function(arg0_29, arg1_29)
		if var1_27 then
			setActive(var0_27, true)

			if arg3_27 then
				arg3_27()
			end
		end
	end)
end

function var0_0.OnJoyStickTrigger(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30 = arg1_30:Find("m")
	local var1_30 = arg1_30:Find("l")
	local var2_30 = arg1_30:Find("r")
	local var3_30 = GetOrAddComponent(arg1_30, typeof(EventTriggerListener))
	local var4_30
	local var5_30 = false

	var3_30:AddBeginDragFunc(function(arg0_31, arg1_31)
		var5_30 = arg2_30()
		var4_30 = arg1_31.position
	end)
	var3_30:AddDragFunc(function(arg0_32, arg1_32)
		if not var5_30 then
			return
		end

		local var0_32 = arg1_32.position.x - var4_30.x

		setActive(var0_30, var0_32 == 0)
		setActive(var1_30, var0_32 < 0)
		setActive(var2_30, var0_32 > 0)
	end)
	var3_30:AddDragEndFunc(function(arg0_33, arg1_33)
		if not var5_30 then
			return
		end

		local var0_33 = arg1_33.position.x - var4_30.x

		arg3_30(var0_33)
		setActive(var0_30, true)
		setActive(var1_30, false)
		setActive(var2_30, false)
	end)
end

function var0_0.findTF(arg0_34, arg1_34, arg2_34)
	assert(arg0_34._tf, "transform should exist")

	return findTF(arg2_34 or arg0_34._tf, arg1_34)
end

return var0_0
