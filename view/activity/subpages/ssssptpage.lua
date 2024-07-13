local var0_0 = class("SSSSPtPage", import(".TemplatePage.PtTemplatePage"))
local var1_0 = {
	{
		11,
		1.5
	},
	{
		19,
		2
	},
	{
		25,
		3
	},
	{
		28,
		4
	}
}
local var2_0 = 0.25
local var3_0 = 20
local var4_0 = 20
local var5_0 = 0.75
local var6_0 = 3
local var7_0 = 0.75
local var8_0 = 5
local var9_0 = "he"

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.maskNode = arg0_1:findTF("mask", arg0_1.bg)
	arg0_1.role = arg0_1:findTF("role", arg0_1.maskNode)
	arg0_1.food = arg0_1:findTF("food", arg0_1.maskNode)
	arg0_1.monster = arg0_1:findTF("monster", arg0_1.maskNode)
	arg0_1.reflectNode = arg0_1:findTF("reflection", arg0_1.maskNode)
	arg0_1.monsterReflect = arg0_1:findTF("monster_reflection", arg0_1.reflectNode)
	arg0_1.roleReflect = arg0_1:findTF("role_reflection", arg0_1.reflectNode)
	arg0_1.feedBtn = arg0_1:findTF("feed_btn", arg0_1.bg)
	arg0_1.window = arg0_1:findTF("window")
	arg0_1.monsterAni = GetComponent(arg0_1:findTF("panel/monster", arg0_1.window), typeof(Animator))
	arg0_1.spineRole = arg0_1:findTF("panel/spinechar", arg0_1.window)
	arg0_1.spriteRole = arg0_1:findTF("panel/spritechar", arg0_1.window)
	arg0_1.isPlaying = false
	arg0_1.coutinuePlay = {}
end

function var0_0.OnFirstFlush(arg0_2)
	var0_0.super.OnFirstFlush(arg0_2)
	setActive(arg0_2.window, false)
	onButton(arg0_2, arg0_2.monster, function()
		if arg0_2.monster.localScale.x == var1_0[#var1_0][2] then
			arg0_2:OpenMonsterWin()
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("close", arg0_2.window), function()
		setActive(arg0_2.window, false)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("close_btn", arg0_2.window), function()
		setActive(arg0_2.window, false)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.feedBtn, function()
		local var0_6 = {}
		local var1_6 = arg0_2.ptData:GetAward()
		local var2_6 = getProxy(PlayerProxy):getRawData()
		local var3_6 = pg.gameset.urpt_chapter_max.description[1]
		local var4_6 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3_6)
		local var5_6, var6_6 = Task.StaticJudgeOverflow(var2_6.gold, var2_6.oil, var4_6, true, true, {
			{
				var1_6.type,
				var1_6.id,
				var1_6.count
			}
		})

		if var5_6 then
			table.insert(var0_6, function(arg0_7)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6_6,
					onYes = arg0_7
				})
			end)
		end

		seriesAsync(var0_6, function()
			local function var0_8()
				arg0_2:PlayFeedAni()
			end

			local var1_8, var2_8 = arg0_2.ptData:GetResProgress()

			arg0_2:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0_2.ptData:GetId(),
				arg1 = var2_8,
				callback = var0_8
			})
		end)
	end, SFX_PANEL)
	setActive(arg0_2:findTF("blink_effect", arg0_2.bg), true)
	arg0_2:UpdateMonster()
end

function var0_0.OnUpdateFlush(arg0_10)
	var0_0.super.OnUpdateFlush(arg0_10)

	local var0_10, var1_10, var2_10 = arg0_10.ptData:GetLevelProgress()
	local var3_10, var4_10, var5_10 = arg0_10.ptData:GetResProgress()

	setText(arg0_10.step, setColorStr(var0_10, "#f0dbff") .. "/" .. var1_10)
	setText(arg0_10.progress, (var5_10 >= 1 and setColorStr(var3_10, "#f0dbff") or var3_10) .. "/" .. var4_10)

	if isActive(arg0_10.getBtn) and arg0_10:IsSpecialPhase() then
		setActive(arg0_10.getBtn, false)
		setActive(arg0_10.feedBtn, true)
	else
		setActive(arg0_10.feedBtn, false)
	end
end

function var0_0.IsSpecialPhase(arg0_11)
	local var0_11 = arg0_11.ptData:GetLevelProgress()
	local var1_11 = false

	for iter0_11, iter1_11 in ipairs(var1_0) do
		if var0_11 == iter1_11[1] then
			var1_11 = true
		end
	end

	return var1_11
end

function var0_0.GetMonsterScale(arg0_12, arg1_12)
	local var0_12 = 1

	for iter0_12, iter1_12 in ipairs(var1_0) do
		if arg1_12 > iter1_12[1] then
			var0_12 = iter1_12[2]
		end
	end

	return var0_12
end

function var0_0.UpdateMonster(arg0_13)
	local var0_13 = arg0_13.ptData:GetLevelProgress()
	local var1_13 = arg0_13:GetMonsterScale(var0_13)

	setLocalScale(arg0_13.monster, Vector2(var1_13, var1_13))
	setLocalScale(arg0_13.monsterReflect, Vector2(var1_13, var1_13))
end

function var0_0.PlayFeedAni(arg0_14)
	if arg0_14.isPlaying then
		local var0_14 = arg0_14.ptData:GetLevelProgress() - 1

		table.insert(arg0_14.coutinuePlay, var0_14)

		return
	end

	arg0_14.isPlaying = true

	arg0_14:managedTween(LeanTween.moveX, function()
		arg0_14:PlayThrowFoodAni(function()
			arg0_14:PlayMonsterAni()
		end)
	end, arg0_14.role, arg0_14.role.localPosition.x + var3_0, var2_0):setLoopPingPong(1)
end

function var0_0.PlayThrowFoodAni(arg0_17, arg1_17)
	local var0_17 = Vector2(280, -70)
	local var1_17 = Vector2(500, -70)
	local var2_17 = 1
	local var3_17 = (var1_17.x - var0_17.x) / var6_0
	local var4_17 = (var1_17.y - var0_17.y) / var6_0

	setLocalPosition(arg0_17.food, var0_17)
	setActive(arg0_17.food, true)

	arg0_17.foodTimer = Timer.New(function()
		local var0_18 = Vector2(var0_17.x + var3_17 * var2_17, var0_17.y + var4_17 * var2_17)

		setLocalPosition(arg0_17.food, var0_18)

		if var2_17 == var6_0 then
			arg0_17.foodTimer:Stop()
			setActive(arg0_17.food, false)

			if arg1_17 then
				arg1_17()
			end
		else
			var2_17 = var2_17 + 1
		end
	end, var5_0 / var6_0, var6_0)

	arg0_17.foodTimer:Start()
end

function var0_0.PlayMonsterAni(arg0_19)
	local var0_19 = arg0_19.monster.localScale.x
	local var1_19 = arg0_19.coutinuePlay[1] and arg0_19.coutinuePlay[1] or arg0_19.ptData:GetLevelProgress()
	local var2_19 = arg0_19:GetMonsterScale(var1_19)
	local var3_19 = 1
	local var4_19 = (var2_19 - var0_19) / var8_0

	setLocalScale(arg0_19.monster, Vector2(var0_19, var0_19))
	setLocalScale(arg0_19.monsterReflect, Vector2(var0_19, var0_19))

	arg0_19.monsterTimer = Timer.New(function()
		local var0_20 = Vector2(var0_19 + var4_19 * var3_19, var0_19 + var4_19 * var3_19)

		setLocalScale(arg0_19.monster, var0_20)
		setLocalScale(arg0_19.monsterReflect, var0_20)

		if var3_19 == var8_0 then
			arg0_19.monsterTimer:Stop()

			arg0_19.monsterTimer = nil
			arg0_19.isPlaying = false

			if #arg0_19.coutinuePlay > 0 then
				table.remove(arg0_19.coutinuePlay, 1)
				arg0_19:PlayFeedAni()
			end
		else
			var3_19 = var3_19 + 1
		end
	end, var7_0 / var8_0, var8_0)

	arg0_19:managedTween(LeanTween.moveX, function()
		arg0_19:managedTween(LeanTween.moveY, function()
			arg0_19.monsterTimer:Start()
		end, arg0_19.monster, arg0_19.monster.localPosition.y + var4_0, var2_0):setLoopPingPong(2)
	end, arg0_19.monster, arg0_19.monster.localPosition.x + var3_0, var2_0):setLoopPingPong(2)
end

function var0_0.OpenMonsterWin(arg0_23)
	setActive(arg0_23.window, true)
	arg0_23.monsterAni:Play("ATK")
	setLocalPosition(arg0_23.spriteRole, Vector2(-180, -115))

	if LeanTween.isTweening(go(arg0_23.spriteRole)) then
		LeanTween.cancel(go(arg0_23.spriteRole))
	end

	arg0_23:managedTween(LeanTween.moveX, nil, arg0_23.spriteRole, arg0_23.spriteRole.localPosition.x + 20, 0.8):setLoopPingPong()
end

function var0_0.OnHideFlush(arg0_24)
	setActive(arg0_24.window, false)
end

function var0_0.OnDestroy(arg0_25)
	arg0_25:cleanManagedTween()

	if arg0_25.foodTimer then
		arg0_25.foodTimer:Stop()

		arg0_25.foodTimer = nil
	end

	if arg0_25.monsterTimer then
		arg0_25.monsterTimer:Stop()

		arg0_25.monsterTimer = nil
	end

	if arg0_25.model then
		PoolMgr.GetInstance():ReturnSpineChar(var9_0, arg0_25.model)

		arg0_25.model = nil
	end
end

return var0_0
