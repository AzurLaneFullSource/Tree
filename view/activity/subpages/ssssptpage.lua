local var0 = class("SSSSPtPage", import(".TemplatePage.PtTemplatePage"))
local var1 = {
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
local var2 = 0.25
local var3 = 20
local var4 = 20
local var5 = 0.75
local var6 = 3
local var7 = 0.75
local var8 = 5
local var9 = "he"

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.maskNode = arg0:findTF("mask", arg0.bg)
	arg0.role = arg0:findTF("role", arg0.maskNode)
	arg0.food = arg0:findTF("food", arg0.maskNode)
	arg0.monster = arg0:findTF("monster", arg0.maskNode)
	arg0.reflectNode = arg0:findTF("reflection", arg0.maskNode)
	arg0.monsterReflect = arg0:findTF("monster_reflection", arg0.reflectNode)
	arg0.roleReflect = arg0:findTF("role_reflection", arg0.reflectNode)
	arg0.feedBtn = arg0:findTF("feed_btn", arg0.bg)
	arg0.window = arg0:findTF("window")
	arg0.monsterAni = GetComponent(arg0:findTF("panel/monster", arg0.window), typeof(Animator))
	arg0.spineRole = arg0:findTF("panel/spinechar", arg0.window)
	arg0.spriteRole = arg0:findTF("panel/spritechar", arg0.window)
	arg0.isPlaying = false
	arg0.coutinuePlay = {}
end

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	setActive(arg0.window, false)
	onButton(arg0, arg0.monster, function()
		if arg0.monster.localScale.x == var1[#var1][2] then
			arg0:OpenMonsterWin()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("close", arg0.window), function()
		setActive(arg0.window, false)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("close_btn", arg0.window), function()
		setActive(arg0.window, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.feedBtn, function()
		local var0 = {}
		local var1 = arg0.ptData:GetAward()
		local var2 = getProxy(PlayerProxy):getRawData()
		local var3 = pg.gameset.urpt_chapter_max.description[1]
		local var4 = LOCK_UR_SHIP and 0 or getProxy(BagProxy):GetLimitCntById(var3)
		local var5, var6 = Task.StaticJudgeOverflow(var2.gold, var2.oil, var4, true, true, {
			{
				var1.type,
				var1.id,
				var1.count
			}
		})

		if var5 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					type = MSGBOX_TYPE_ITEM_BOX,
					content = i18n("award_max_warning"),
					items = var6,
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			local function var0()
				arg0:PlayFeedAni()
			end

			local var1, var2 = arg0.ptData:GetResProgress()

			arg0:emit(ActivityMediator.EVENT_PT_OPERATION, {
				cmd = 1,
				activity_id = arg0.ptData:GetId(),
				arg1 = var2,
				callback = var0
			})
		end)
	end, SFX_PANEL)
	setActive(arg0:findTF("blink_effect", arg0.bg), true)
	arg0:UpdateMonster()
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	local var0, var1, var2 = arg0.ptData:GetLevelProgress()
	local var3, var4, var5 = arg0.ptData:GetResProgress()

	setText(arg0.step, setColorStr(var0, "#f0dbff") .. "/" .. var1)
	setText(arg0.progress, (var5 >= 1 and setColorStr(var3, "#f0dbff") or var3) .. "/" .. var4)

	if isActive(arg0.getBtn) and arg0:IsSpecialPhase() then
		setActive(arg0.getBtn, false)
		setActive(arg0.feedBtn, true)
	else
		setActive(arg0.feedBtn, false)
	end
end

function var0.IsSpecialPhase(arg0)
	local var0 = arg0.ptData:GetLevelProgress()
	local var1 = false

	for iter0, iter1 in ipairs(var1) do
		if var0 == iter1[1] then
			var1 = true
		end
	end

	return var1
end

function var0.GetMonsterScale(arg0, arg1)
	local var0 = 1

	for iter0, iter1 in ipairs(var1) do
		if arg1 > iter1[1] then
			var0 = iter1[2]
		end
	end

	return var0
end

function var0.UpdateMonster(arg0)
	local var0 = arg0.ptData:GetLevelProgress()
	local var1 = arg0:GetMonsterScale(var0)

	setLocalScale(arg0.monster, Vector2(var1, var1))
	setLocalScale(arg0.monsterReflect, Vector2(var1, var1))
end

function var0.PlayFeedAni(arg0)
	if arg0.isPlaying then
		local var0 = arg0.ptData:GetLevelProgress() - 1

		table.insert(arg0.coutinuePlay, var0)

		return
	end

	arg0.isPlaying = true

	arg0:managedTween(LeanTween.moveX, function()
		arg0:PlayThrowFoodAni(function()
			arg0:PlayMonsterAni()
		end)
	end, arg0.role, arg0.role.localPosition.x + var3, var2):setLoopPingPong(1)
end

function var0.PlayThrowFoodAni(arg0, arg1)
	local var0 = Vector2(280, -70)
	local var1 = Vector2(500, -70)
	local var2 = 1
	local var3 = (var1.x - var0.x) / var6
	local var4 = (var1.y - var0.y) / var6

	setLocalPosition(arg0.food, var0)
	setActive(arg0.food, true)

	arg0.foodTimer = Timer.New(function()
		local var0 = Vector2(var0.x + var3 * var2, var0.y + var4 * var2)

		setLocalPosition(arg0.food, var0)

		if var2 == var6 then
			arg0.foodTimer:Stop()
			setActive(arg0.food, false)

			if arg1 then
				arg1()
			end
		else
			var2 = var2 + 1
		end
	end, var5 / var6, var6)

	arg0.foodTimer:Start()
end

function var0.PlayMonsterAni(arg0)
	local var0 = arg0.monster.localScale.x
	local var1 = arg0.coutinuePlay[1] and arg0.coutinuePlay[1] or arg0.ptData:GetLevelProgress()
	local var2 = arg0:GetMonsterScale(var1)
	local var3 = 1
	local var4 = (var2 - var0) / var8

	setLocalScale(arg0.monster, Vector2(var0, var0))
	setLocalScale(arg0.monsterReflect, Vector2(var0, var0))

	arg0.monsterTimer = Timer.New(function()
		local var0 = Vector2(var0 + var4 * var3, var0 + var4 * var3)

		setLocalScale(arg0.monster, var0)
		setLocalScale(arg0.monsterReflect, var0)

		if var3 == var8 then
			arg0.monsterTimer:Stop()

			arg0.monsterTimer = nil
			arg0.isPlaying = false

			if #arg0.coutinuePlay > 0 then
				table.remove(arg0.coutinuePlay, 1)
				arg0:PlayFeedAni()
			end
		else
			var3 = var3 + 1
		end
	end, var7 / var8, var8)

	arg0:managedTween(LeanTween.moveX, function()
		arg0:managedTween(LeanTween.moveY, function()
			arg0.monsterTimer:Start()
		end, arg0.monster, arg0.monster.localPosition.y + var4, var2):setLoopPingPong(2)
	end, arg0.monster, arg0.monster.localPosition.x + var3, var2):setLoopPingPong(2)
end

function var0.OpenMonsterWin(arg0)
	setActive(arg0.window, true)
	arg0.monsterAni:Play("ATK")
	setLocalPosition(arg0.spriteRole, Vector2(-180, -115))

	if LeanTween.isTweening(go(arg0.spriteRole)) then
		LeanTween.cancel(go(arg0.spriteRole))
	end

	arg0:managedTween(LeanTween.moveX, nil, arg0.spriteRole, arg0.spriteRole.localPosition.x + 20, 0.8):setLoopPingPong()
end

function var0.OnHideFlush(arg0)
	setActive(arg0.window, false)
end

function var0.OnDestroy(arg0)
	arg0:cleanManagedTween()

	if arg0.foodTimer then
		arg0.foodTimer:Stop()

		arg0.foodTimer = nil
	end

	if arg0.monsterTimer then
		arg0.monsterTimer:Stop()

		arg0.monsterTimer = nil
	end

	if arg0.model then
		PoolMgr.GetInstance():ReturnSpineChar(var9, arg0.model)

		arg0.model = nil
	end
end

return var0
